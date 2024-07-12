#include "ffmpeg.h"
#include <QQmlEngine>

FFmpegThread::FFmpegThread(QObject *parent) : QThread(parent)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<FFmpegThread *>("FFmpegThread*");

    setObjectName("FFmpegThread");
    stopped = false;
    isPlay = false;

    frameFinish = false;
    videoWidth = 0;
    videoHeight = 0;
    oldWidth = 0;
    oldHeight = 0;
    videoStreamIndex = -1;
    audioStreamIndex = -1;

    url = "rtsp://49.65.97.190:8554/live/test1";

    buffer = NULL;
    avPacket = NULL;
    avFrame = NULL;
    avFrame2 = NULL;
    avFrame3 = NULL;
    avFormatContext = NULL;
    videoCodec = NULL;
    audioCodec = NULL;
    swsContext = NULL;

    options = NULL;
    videoDecoder = NULL;
    audioDecoder = NULL;

    //初始化注册,一个软件中只注册一次即可
    FFmpegThread::initlib();
}

//一个软件中只需要初始化一次就行
void FFmpegThread::initlib()
{
    static QMutex mutex;
    QMutexLocker locker(&mutex);
    static bool isInit = false;
    if (!isInit) {
        //注册库中所有可用的文件格式和解码器
        av_register_all();
        //注册所有设备,主要用于本地摄像机播放支持
#ifdef ffmpegdevice
        avdevice_register_all();
#endif
        //初始化网络流格式,使用网络流时必须先执行
        avformat_network_init();

        isInit = true;
        qDebug() << TIMEMS << "init ffmpeg lib ok" << " version:" << FFMPEG_VERSION;
#if 0
        //输出所有支持的解码器名称
        QStringList listCodeName;
        AVCodec *code = av_codec_next(NULL);
        while (code != NULL) {
            listCodeName << code->name;
            code = code->next;
        }

        qDebug() << TIMEMS << listCodeName;
#endif
    }
}

bool FFmpegThread::init()
{
#if TEST
    //在打开码流前指定各种参数比如:探测时间/超时时间/最大延时等
    //设置缓存大小,1080p可将值调大
    av_dict_set(&options, "buffer_size", "8192000", 0);
    //以tcp方式打开,如果以udp方式打开将tcp替换为udp
    av_dict_set(&options, "rtsp_transport", "tcp", 0);
    //设置超时断开连接时间,单位微秒,3000000表示3秒
    av_dict_set(&options, "stimeout", "3000000", 0);
    //设置最大时延,单位微秒,1000000表示1秒
    av_dict_set(&options, "max_delay", "1000000", 0);
    //自动开启线程数
    av_dict_set(&options, "threads", "auto", 0);

    //打开视频流
    avFormatContext = avformat_alloc_context();



    int result = avformat_open_input(&avFormatContext, url.toStdString().data(), NULL, &options);
    if (result < 0) {
        qDebug() << TIMEMS << "open input error" << url;
        return false;
    }

    //释放设置参数
    if (options != NULL) {
        av_dict_free(&options);
    }

    //获取流信息
    result = avformat_find_stream_info(avFormatContext, NULL);
    if (result < 0) {
        qDebug() << TIMEMS << "find stream info error";
        return false;
    }

    if(1){
        videoStreamIndex = av_find_best_stream(avFormatContext, AVMEDIA_TYPE_VIDEO, -1, -1, &videoDecoder, 0);
        if (videoStreamIndex < 0) {
            qDebug() << TIMEMS << "find video stream index error";
            return false;
        }

        //获取视频流
        AVStream *videoStream = avFormatContext->streams[videoStreamIndex];

        //获取视频流解码器,或者指定解码器
        videoCodec = videoStream->codec;
        videoDecoder = avcodec_find_decoder(videoCodec->codec_id);
        //videoDecoder = avcodec_find_decoder_by_name("h264_qsv");
        if (videoDecoder == NULL) {
            qDebug() << TIMEMS << "video decoder not found";
            return false;
        }

        /// 打印所有支持的硬件加速方式
        for (int i = 0; ; i++)
        {
            auto config = avcodec_get_hw_config(videoDecoder, i);

            if (config == nullptr)
            {
                break;
            }

            if (config->device_type)
            {
                qDebug() << av_hwdevice_get_type_name(config->device_type);
            }
        }

        if(av_hwdevice_ctx_create(&ctx_ref, AV_HWDEVICE_TYPE_DXVA2, nullptr, nullptr, 0) < 0){
            qDebug() << "av_hwdevice_ctx_create failed!" ;
            return false;
        }

        // 设定硬件GPU加速
        videoCodec->hw_device_ctx = av_buffer_ref(ctx_ref);
        //打开视频解码器
        if(avcodec_open2(videoCodec, videoDecoder, nullptr) < 0){
            qDebug() << "avcodec_open2 failed!" ;
            return false;
        }

        //获取分辨率大小
        videoWidth = videoStream->codec->width;
        videoHeight = videoStream->codec->height;

        //如果没有获取到宽高则返回
        if (videoWidth == 0 || videoHeight == 0) {
            qDebug() << TIMEMS << "find width height error";
            return false;
        }

        if (av_parser_init(videoCodec->codec_id) == nullptr)
        {
            qDebug() << "av_parser_init failed!";

            return false;
        }

        QString videoInfo = QString("视频流信息 -> 索引: %1  解码: %2  格式: %3  时长: %4 秒  分辨率: %5*%6")
                .arg(videoStreamIndex).arg(videoDecoder->name).arg(avFormatContext->iformat->name)
                .arg((avFormatContext->duration) / 1000000).arg(videoWidth).arg(videoHeight);
        qDebug() << TIMEMS << videoInfo;
    }

    //----------音频流部分开始,打个标记方便折叠代码----------
    if (1) {
        //循环查找音频流索引
        audioStreamIndex = -1;
        for (uint i = 0; i < avFormatContext->nb_streams; i++) {
            if (avFormatContext->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
                audioStreamIndex = i;
                break;
            }
        }

        //有些没有音频流,所以这里不用返回
        if (audioStreamIndex == -1) {
            qDebug() << TIMEMS << "find audio stream index error";
        } else {
            //获取音频流
            AVStream *audioStream = avFormatContext->streams[audioStreamIndex];
            audioCodec = audioStream->codec;

            //获取音频流解码器,或者指定解码器
            audioDecoder = avcodec_find_decoder(audioCodec->codec_id);
            //audioDecoder = avcodec_find_decoder_by_name("aac");
            if (audioDecoder == NULL) {
                qDebug() << TIMEMS << "audio codec not found";
                return false;
            }

            //打开音频解码器
            result = avcodec_open2(audioCodec, audioDecoder, NULL);
            if (result < 0) {
                qDebug() << TIMEMS << "open audio codec error";
                return false;
            }

            QString audioInfo = QString("音频流信息 -> 索引: %1  解码: %2  比特率: %3  声道数: %4  采样: %5")
                                .arg(audioStreamIndex).arg(audioDecoder->name).arg(avFormatContext->bit_rate)
                                .arg(audioCodec->channels).arg(audioCodec->sample_rate);
            qDebug() << TIMEMS << audioInfo;
        }
    }
    //----------音频流部分结束----------

    //预分配好内存
    avPacket = av_packet_alloc();
    avFrame = av_frame_alloc();
    avFrame2 = av_frame_alloc();
    avFrame3 = av_frame_alloc();

    //比较上一次文件的宽度高度,当改变时,需要重新分配内存
    if (oldWidth != videoWidth || oldHeight != videoHeight) {
        int byte = avpicture_get_size(AV_PIX_FMT_RGB32, videoWidth, videoHeight);
        buffer = (uint8_t *)av_malloc(byte * sizeof(uint8_t));
        oldWidth = videoWidth;
        oldHeight = videoHeight;
    }

    //定义像素格式
    AVPixelFormat srcFormat = AV_PIX_FMT_DXVA2_VLD;
    AVPixelFormat dstFormat = AV_PIX_FMT_RGB32;
    //通过解码器获取解码格式
    srcFormat = videoCodec->pix_fmt;

    //默认最快速度的解码采用的SWS_FAST_BILINEAR参数,可能会丢失部分图片数据,可以自行更改成其他参数
    int flags = SWS_FAST_BILINEAR;

    //开辟缓存存储一帧数据
    //以下两种方法都可以,avpicture_fill已经逐渐被废弃
    //avpicture_fill((AVPicture *)avFrame3, buffer, dstFormat, videoWidth, videoHeight);
    av_image_fill_arrays(avFrame2->data, avFrame2->linesize, buffer, dstFormat, videoWidth, videoHeight, 1);

    //图像转换
    swsContext = sws_getContext(videoWidth, videoHeight, AV_PIX_FMT_NV12, videoWidth, videoHeight, AV_PIX_FMT_RGB24, flags, NULL, NULL, NULL);

    //输出视频信息
    //av_dump_format(avFormatContext, 0, url.toStdString().data(), 0);

    //qDebug() << TIMEMS << "init ffmpeg finsh";
    return true;
#else
    //在打开码流前指定各种参数比如:探测时间/超时时间/最大延时等
    //设置缓存大小,1080p可将值调大
    av_dict_set(&options, "buffer_size", "8192000", 0);
    //以tcp方式打开,如果以udp方式打开将tcp替换为udp
    av_dict_set(&options, "rtsp_transport", "tcp", 0);
    //设置超时断开连接时间,单位微秒,3000000表示3秒
    av_dict_set(&options, "stimeout", "3000000", 0);
    //设置最大时延,单位微秒,1000000表示1秒
    av_dict_set(&options, "max_delay", "1000000", 0);
    //自动开启线程数
    av_dict_set(&options, "threads", "auto", 0);

    //打开视频流
    avFormatContext = avformat_alloc_context();
    int result = avformat_open_input(&avFormatContext, url.toStdString().data(), NULL, &options);
    if (result < 0) {
        qDebug() << TIMEMS << "open input error" << url;
        return false;
    }

    //释放设置参数
    if (options != NULL) {
        av_dict_free(&options);
    }

    //获取流信息
    result = avformat_find_stream_info(avFormatContext, NULL);
    if (result < 0) {
        qDebug() << TIMEMS << "find stream info error";
        return false;
    }

    //----------视频流部分开始,打个标记方便折叠代码----------
    if (1) {
        videoStreamIndex = av_find_best_stream(avFormatContext, AVMEDIA_TYPE_VIDEO, -1, -1, &videoDecoder, 0);
        if (videoStreamIndex < 0) {
            qDebug() << TIMEMS << "find video stream index error";
            return false;
        }

        //获取视频流
        AVStream *videoStream = avFormatContext->streams[videoStreamIndex];

        //获取视频流解码器,或者指定解码器
        videoCodec = videoStream->codec;
        videoDecoder = avcodec_find_decoder(videoCodec->codec_id);
        //videoDecoder = avcodec_find_decoder_by_name("h264_qsv");
        if (videoDecoder == NULL) {
            qDebug() << TIMEMS << "video decoder not found";
            return false;
        }

        //设置加速解码
        videoCodec->lowres = videoDecoder->max_lowres;
        videoCodec->flags2 |= AV_CODEC_FLAG2_FAST;

        //打开视频解码器
        result = avcodec_open2(videoCodec, videoDecoder, NULL);
        if (result < 0) {
            qDebug() << TIMEMS << "open video codec error";
            return false;
        }

        //获取分辨率大小
        videoWidth = videoStream->codec->width;
        videoHeight = videoStream->codec->height;

        //如果没有获取到宽高则返回
        if (videoWidth == 0 || videoHeight == 0) {
            qDebug() << TIMEMS << "find width height error";
            return false;
        }

        QString videoInfo = QString("视频流信息 -> 索引: %1  解码: %2  格式: %3  时长: %4 秒  分辨率: %5*%6")
                            .arg(videoStreamIndex).arg(videoDecoder->name).arg(avFormatContext->iformat->name)
                            .arg((avFormatContext->duration) / 1000000).arg(videoWidth).arg(videoHeight);
        qDebug() << TIMEMS << videoInfo;
    }
    //----------视频流部分开始----------

    //----------音频流部分开始,打个标记方便折叠代码----------
    if (1) {
        //循环查找音频流索引
        audioStreamIndex = -1;
        for (uint i = 0; i < avFormatContext->nb_streams; i++) {
            if (avFormatContext->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
                audioStreamIndex = i;
                break;
            }
        }

        //有些没有音频流,所以这里不用返回
        if (audioStreamIndex == -1) {
            qDebug() << TIMEMS << "find audio stream index error";
        } else {
            //获取音频流
            AVStream *audioStream = avFormatContext->streams[audioStreamIndex];
            audioCodec = audioStream->codec;

            //获取音频流解码器,或者指定解码器
            audioDecoder = avcodec_find_decoder(audioCodec->codec_id);
            //audioDecoder = avcodec_find_decoder_by_name("aac");
            if (audioDecoder == NULL) {
                qDebug() << TIMEMS << "audio codec not found";
                return false;
            }

            //打开音频解码器
            result = avcodec_open2(audioCodec, audioDecoder, NULL);
            if (result < 0) {
                qDebug() << TIMEMS << "open audio codec error";
                return false;
            }

            QString audioInfo = QString("音频流信息 -> 索引: %1  解码: %2  比特率: %3  声道数: %4  采样: %5")
                                .arg(audioStreamIndex).arg(audioDecoder->name).arg(avFormatContext->bit_rate)
                                .arg(audioCodec->channels).arg(audioCodec->sample_rate);
            qDebug() << TIMEMS << audioInfo;
        }
    }
    //----------音频流部分结束----------

    //预分配好内存
    avPacket = av_packet_alloc();
    avFrame = av_frame_alloc();
    avFrame2 = av_frame_alloc();
    avFrame3 = av_frame_alloc();

    //比较上一次文件的宽度高度,当改变时,需要重新分配内存
    if (oldWidth != videoWidth || oldHeight != videoHeight) {
        int byte = avpicture_get_size(AV_PIX_FMT_RGB32, videoWidth, videoHeight);
        buffer = (uint8_t *)av_malloc(byte * sizeof(uint8_t));
        oldWidth = videoWidth;
        oldHeight = videoHeight;
    }

    //定义像素格式
    AVPixelFormat srcFormat = AV_PIX_FMT_YUV420P;
    AVPixelFormat dstFormat = AV_PIX_FMT_RGB32;
    //通过解码器获取解码格式
    srcFormat = videoCodec->pix_fmt;

    //默认最快速度的解码采用的SWS_FAST_BILINEAR参数,可能会丢失部分图片数据,可以自行更改成其他参数
    int flags = SWS_FAST_BILINEAR;

    //开辟缓存存储一帧数据
    //以下两种方法都可以,avpicture_fill已经逐渐被废弃
    //avpicture_fill((AVPicture *)avFrame3, buffer, dstFormat, videoWidth, videoHeight);
    av_image_fill_arrays(avFrame3->data, avFrame3->linesize, buffer, dstFormat, videoWidth, videoHeight, 1);

    //图像转换
    swsContext = sws_getContext(videoWidth, videoHeight, srcFormat, videoWidth, videoHeight, dstFormat, flags, NULL, NULL, NULL);

    //输出视频信息
    //av_dump_format(avFormatContext, 0, url.toStdString().data(), 0);

    //qDebug() << TIMEMS << "init ffmpeg finsh";
    return true;
#endif
}


void FFmpegThread::run()
{
#if TEST
    qint64 startTime = av_gettime();
    while (!stopped) {
        //根据标志位执行初始化操作
        if (isPlay) {
            if(!this->init()){
                emit message(QString::fromLocal8Bit("打开文件失败！"));
                this->stop();
            }
            isPlay = false;
            continue;
        }
        frameFinish = av_read_frame(avFormatContext, avPacket);
        if (frameFinish >= 0) {
            //判断当前包是视频还是音频
            int index = avPacket->stream_index;
            if (index == videoStreamIndex) {
                frameFinish = avcodec_send_packet(videoCodec, avPacket);
                if (frameFinish < 0) {
                    continue;
                }

                frameFinish = avcodec_receive_frame(videoCodec, avFrame2);
                if (frameFinish < 0) {
                    continue;
                }

                if (frameFinish == 0) {
                    if (videoCodec->hw_device_ctx != nullptr)  // 硬解码
                    {
                        if (av_hwframe_transfer_data(avFrame, avFrame2, 0) >= 0)
                        {
                            av_frame_copy_props(avFrame, avFrame2);
                            av_frame_unref(avFrame2);
                            avFrame3 = avFrame;
                        }

//                        //将数据转成一张图片
//                        sws_scale(swsContext, (const uint8_t *const *)avFrame3->data, avFrame3->linesize, 0, videoHeight, outData, outLinesize);

//                        //以下两种方法都可以
//                        QImage image(outData[0], videoWidth, videoHeight, QImage::Format_RGB32);
////                        QImage image((uchar *)buffer, videoWidth, videoHeight, QImage::Format_RGB32);
//                        if (!image.isNull()) {
//                            emit receiveImage(image);
//                        }

//                        // 确保 QImage 的格式与源帧的格式匹配
//                        if (avFrame3->format != AV_PIX_FMT_NV12) {
//                            qDebug() << "源帧格式与 QImage 格式不匹配";
//                            return;
//                        }

                        // 创建 QImage
                        QImage image(avFrame3->width, avFrame3->height, QImage::Format_RGB32);
                        // 拷贝数据到 QImage
                        const uint8_t* srcDataY = avFrame3->data[0];
                        const uint8_t* srcDataUV = avFrame3->data[1];
                        uint8_t* destData = image.bits();
                        int linesizeY = avFrame3->linesize[0];
                        int linesizeUV = avFrame3->linesize[1];
                        int destBytesPerLine = image.bytesPerLine();

                        for (int y = 0; y < avFrame3->height; ++y) {
                            const uint8_t* srcRowY = srcDataY + y * linesizeY;
                            const uint8_t* srcRowUV = srcDataUV + (y / 2) * linesizeUV;

                            uint8_t* destRow = destData + y * destBytesPerLine;

                            for (int x = 0; x < avFrame3->width; ++x) {
                                int uvIndex = (x / 2) * 2;

                                int Y = srcRowY[x];
                                int U = srcRowUV[uvIndex];
                                int V = srcRowUV[uvIndex + 1];

                                int R, G, B;
                                // 根据 YUV 值计算 RGB 值
                                // ...
                                R= Y + ((360 * (V - 128))>>8) ;
                                G= Y - (( ( 88 * (U - 128) + 184 * (V - 128)) )>>8) ;
                                B= Y +((455 * (U - 128))>>8) ;

                                QRgb pixelValue = qRgb(R, G, B);
                                reinterpret_cast<QRgb*>(destRow)[x] = pixelValue;
                            }
                        }

                        if (!image.isNull()) {
                            emit receiveImage(image);
                        }
                        usleep(1);
                    }
                }

#if 0
                //延时(不然文件会立即全部播放完)
                AVRational timeBase = {1, AV_TIME_BASE};
                int64_t ptsTime = av_rescale_q(avPacket->dts, avFormatContext->streams[videoStreamIndex]->time_base, timeBase);
                int64_t nowTime = av_gettime() - startTime;
                if (ptsTime > nowTime) {
                    av_usleep(ptsTime - nowTime);
                }

                avcodec_receive_frame(videoCodec, avFrame2);
#endif

            } else if (index == audioStreamIndex) {
                //解码音频流,自行处理
            }
        }
        av_packet_unref(avPacket);
        av_freep(avPacket);
//        usleep(1);
    }


    /* 取出缓存数据 */
//    avcodec_send_packet(videoCodec, nullptr);

//    avcodec_receive_frame(videoCodec, avFrame2);

    //线程结束后释放资源
    free();
    stopped = false;
    isPlay = false;
    qDebug() << TIMEMS << "stop ffmpeg thread";
#else
    qint64 startTime = av_gettime();
    while (!stopped) {
        //根据标志位执行初始化操作
        if (isPlay) {
            if(!this->init()){
                emit message(QString::fromLocal8Bit("打开文件失败！"));
                this->stop();
            }
            isPlay = false;
            continue;
        }

        frameFinish = av_read_frame(avFormatContext, avPacket);
        if (frameFinish >= 0) {
            //判断当前包是视频还是音频
            int index = avPacket->stream_index;
            if (index == videoStreamIndex) {
                //解码视频流 avcodec_decode_video2 方法已被废弃
#if 0
                avcodec_decode_video2(videoCodec, avFrame2, &frameFinish, avPacket);
#else
                frameFinish = avcodec_send_packet(videoCodec, avPacket);
                if (frameFinish < 0) {
                    continue;
                }

                frameFinish = avcodec_receive_frame(videoCodec, avFrame2);
                if (frameFinish < 0) {
                    continue;
                }
#endif

                if (frameFinish >= 0) {
                    //将数据转成一张图片
                    sws_scale(swsContext, (const uint8_t *const *)avFrame2->data, avFrame2->linesize, 0, videoHeight, avFrame3->data, avFrame3->linesize);

                    //以下两种方法都可以
                    QImage image(avFrame3->data[0], videoWidth, videoHeight, QImage::Format_RGB32);
//                    QImage image((uchar *)buffer, videoWidth, videoHeight, QImage::Format_RGB32);
                    if (!image.isNull()) {
                        emit receiveImage(image);
                    }

                    usleep(1);
                }
#if 0
                //延时(不然文件会立即全部播放完)
                AVRational timeBase = {1, AV_TIME_BASE};
                int64_t ptsTime = av_rescale_q(avPacket->dts, avFormatContext->streams[videoStreamIndex]->time_base, timeBase);
                int64_t nowTime = av_gettime() - startTime;
                if (ptsTime > nowTime) {
                    av_usleep(ptsTime - nowTime);
                }
#endif
            } else if (index == audioStreamIndex) {
                //解码音频流,自行处理
            }
        }

        av_packet_unref(avPacket);
        av_freep(avPacket);
        usleep(1);
    }

    //线程结束后释放资源
    free();
    stopped = false;
    isPlay = false;
    qDebug() << TIMEMS << "stop ffmpeg thread";
#endif
}

void FFmpegThread::setUrl(const QString &url)
{
    this->url = url;
}

void FFmpegThread::free()
{
    if (avFrame3 != NULL) {
        av_frame_free(&avFrame3);
        avFrame3 = NULL;
    }

    if (swsContext != NULL) {
        sws_freeContext(swsContext);
        swsContext = NULL;
    }

    if (avPacket != NULL) {
        av_packet_unref(avPacket);
        avPacket = NULL;
    }

    if (avFrame2 != NULL) {
        av_frame_free(&avFrame2);
        avFrame2 = NULL;
    }

    if (avFrame != NULL) {
        av_frame_free(&avFrame);
        avFrame = NULL;
    }

    if (videoCodec != NULL) {
        avcodec_close(videoCodec);
        videoCodec = NULL;
    }

    if (audioCodec != NULL) {
        avcodec_close(audioCodec);
        audioCodec = NULL;
    }

    if (avFormatContext != NULL) {
        avformat_close_input(&avFormatContext);
        avFormatContext = NULL;
    }

    av_dict_free(&options);
    //qDebug() << TIMEMS << "close ffmpeg ok";
}

void FFmpegThread::play()
{
    //通过标志位让线程执行初始化
    isPlay = true;
}

void FFmpegThread::pause()
{

}

void FFmpegThread::next()
{

}

void FFmpegThread::stop()
{
    //通过标志位让线程停止
    stopped = true;
}

FFmpegWidget::FFmpegWidget(QQuickItem  *parent) :
    QQuickPaintedItem(parent)
{
    _videoPlayer = new FFmpegThread();

    connect(_videoPlayer,&FFmpegThread::receiveImage,this,&FFmpegWidget::updataImage);
    this->update();
}

FFmpegWidget::~FFmpegWidget()
{

}

void FFmpegWidget::setUrl(QString url)
{
    _url=url;
    _videoPlayer->setUrl(_url);
}

QString FFmpegWidget::getUrl()
{
    return _url;
}

void FFmpegWidget::paint(QPainter *painter)
{
    painter->drawImage(QRect(0, 0, nWidth, nHeight), _image);
}

void FFmpegWidget::start(QString url)
{
    _url=url;
    _videoPlayer->setUrl(_url);

    _videoPlayer->play();
    _videoPlayer->start();
}

void FFmpegWidget::setNWidth(qreal width)
{
    nWidth = width;
}

qreal FFmpegWidget::getNWidth()
{
    return nWidth;
}

void FFmpegWidget::setNHeight(qreal height)
{
    nHeight=height;
}

qreal FFmpegWidget::getNHeight()
{
    return nHeight;
}

void FFmpegWidget::updataImage(QImage image)
{
    _image=image;
    this->update();
}



VideoWidget::VideoWidget(QQuickItem  *parent) :
        QQuickPaintedItem(parent)
{

}

VideoWidget::~VideoWidget() = default;

void VideoWidget::paint(QPainter *painter)
{
    painter->drawImage(QRect(0, 0, nWidth, nHeight), _image);
}

void VideoWidget::setNWidth(qreal width)
{
    nWidth = width;
}

qreal VideoWidget::getNWidth()
{
    return nWidth;
}

void VideoWidget::setNHeight(qreal height)
{
    nHeight=height;
}

qreal VideoWidget::getNHeight()
{
    return nHeight;
}

void VideoWidget::updateImage(const QImage& image)
{
    _image=image;
    this->update();
}

void VideoWidget::setVideo(FFmpegThread *video) {
    _videoPlayer = video;
//    if(!_videoPlayer->isRunning()){
    connect(_videoPlayer, &FFmpegThread::receiveImage, this, &VideoWidget::updateImage);
//    }
    this->update();

    _videoPlayer->play();
    _videoPlayer->start();
}
