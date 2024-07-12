#ifndef FFMPEG_H
#define FFMPEG_H

#include <QtGui>
#include <atomic>
#include <QLabel>
#if (QT_VERSION >= QT_VERSION_CHECK(5,0,0))
#include <QtWidgets>
#endif

#define TEST 0

#include "ffmpeghead.h"
#include <QtQuick/QQuickPaintedItem>
#include "QmlObjectListModel.h"

class FFmpegThread : public QThread
{
    Q_OBJECT
public:
    explicit FFmpegThread(QObject *parent = 0);
    static void initlib();

protected:
    void run();

private:
    volatile bool stopped;          //线程停止标志位
    volatile bool isPlay;           //播放视频标志位

    int frameFinish;                //一帧完成
    int videoWidth;                 //视频宽度
    int videoHeight;                //视频高度
    int oldWidth;                   //上一次视频宽度
    int oldHeight;                  //上一次视频高度
    int videoStreamIndex;           //视频流索引
    int audioStreamIndex;           //音频流索引

    QString url;                    //视频流地址

    uint8_t *buffer;                //存储解码后图片buffer
    AVPacket *avPacket;             //包对象
    AVFrame *avFrame;               //帧对象
    AVFrame *avFrame2;              //帧对象
    AVFrame *avFrame3;              //帧对象
    AVFormatContext *avFormatContext;//格式对象
    AVCodecContext *videoCodec;     //视频解码器
    AVCodecContext *audioCodec;     //音频解码器
    SwsContext *swsContext;         //处理图片数据对象

    AVDictionary *options;          //参数对象
    AVCodec *videoDecoder;          //视频解码
    AVCodec *audioDecoder;          //音频解码
    AVBufferRef* ctx_ref = nullptr;

    QString _vehicleId;                    //视频流地址

public:
    void setVehicleId(const QString &vehicleId) { _vehicleId = vehicleId; }
    QString vehicleId() { return _vehicleId; }

signals:
    //收到图片信号
    void receiveImage(const QImage &image);
    void message(QString message);
public slots:
    //设置视频流地址
    void setUrl(const QString &url);

    //初始化视频对象
    bool init();
    //释放对象
    void free();
    //播放视频对象
    void play();
    //暂停播放
    void pause();
    //继续播放
    void next();
    //停止采集线程
    void stop();
};

//实时视频显示窗体类
class FFmpegWidget : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString url READ getUrl WRITE setUrl)
    Q_PROPERTY(qreal nWidth READ getNWidth WRITE setNWidth)
    Q_PROPERTY(qreal nHeight READ getNHeight WRITE setNHeight)
    Q_PROPERTY(QString video READ video WRITE setVideo)

public:
    FFmpegWidget(QQuickItem *parent = 0);
    virtual ~FFmpegWidget();

    void setUrl(QString url);
    QString getUrl();

    virtual void paint(QPainter *painter);

    Q_INVOKABLE void start(QString url);


    void setNWidth(qreal width);
    qreal getNWidth();

    void setNHeight(qreal height);
    qreal getNHeight();

    void setVideo(QString url) { _video = url;  start(url); }
    QString video() { return _video; }

    Q_INVOKABLE QImage getImage() { return _image; }

public slots:
    void updataImage(QImage image);

private:
    QImage _image;
    QString _url;
    qreal nWidth;
    qreal nHeight;
    QString _video;

//    VideoPlayer *_videoPlayer{};
    FFmpegThread *_videoPlayer{};

//    QmlObjectListModel
};

//实时视频显示窗体类
class VideoWidget : public QQuickPaintedItem
{
Q_OBJECT
    Q_PROPERTY(qreal nWidth READ getNWidth WRITE setNWidth)
    Q_PROPERTY(qreal nHeight READ getNHeight WRITE setNHeight)
    Q_PROPERTY(FFmpegThread* video READ video WRITE setVideo)

public:
    explicit VideoWidget(QQuickItem *parent = nullptr);
    virtual ~VideoWidget();

    virtual void paint(QPainter *painter);

    void setNWidth(qreal width);
    qreal getNWidth();

    void setNHeight(qreal height);
    qreal getNHeight();

    FFmpegThread* video() { return _videoPlayer; }
    void setVideo(FFmpegThread *video);
    Q_INVOKABLE QImage getImage() { return _image; }

public slots:
    void updateImage(const QImage& image);

private:
    QImage _image;
    qreal nWidth{};
    qreal nHeight{};
    FFmpegThread *_videoPlayer{nullptr};
};

#endif // FFMPEG_H
