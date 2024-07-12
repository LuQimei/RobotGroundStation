#include "CVThread.h"
#include "QDir"
#include "QDateTime"

CVThread::CVThread()
{
//cap.open("rtsp://admin:biegai666@192.168.1.64/Streaming/Channels/101");
//cap.open("rtsp://49.65.97.190:8554/live/rov1");
}


void CVThread::startVideo() {
    if (cap.isOpened()) {
        return;
    }
        cap.open(" udpsrc port=5600 ! application/x-rtp, payload=96 ! rtph264depay ! decodebin ! videoconvert ! appsink",cv::CAP_GSTREAMER); //打开相机
//    cap.open(0,cv::CAP_DSHOW);
//cap.open("rov.mp4");
    if(this->isRunning()){
        return;
    }
    this->start();
}

void CVThread::run()
{
    if (!cap.isOpened()) {
        return;
    }

    while (true)
    {
        cap >> img; //以流形式捕获图像
//        if(img.empty()){
//            cap.open("rov.mp4");
//            continue;
//            return;
//        }

        switch(img.type())
        {

            case CV_8UC1:
                //qDebug() << "CV_8UC1";
                // QImage构造：数据，宽度，高度，每行多少字节，存储结构
                _img = QImage((const unsigned char*)img.data, img.cols, img.rows, img.step, QImage::Format_Grayscale8);
                break;

            case CV_8UC3:
                //qDebug() << "CV_8UC3";
                _img = QImage((const unsigned char*)img.data, img.cols, img.rows, img.step, QImage::Format_RGB888);
                _img = _img.rgbSwapped(); // BRG转为RGB
                // Qt5.14增加了Format_BGR888
                // image = QImage((const unsigned char*)mat.data, mat.cols, mat.rows, mat.cols * 3, QImage::Format_BGR888);
                break;

            case CV_8UC4:
                //qDebug() << "CV_8UC4";
                _img = QImage((const unsigned char*)img.data, img.cols, img.rows, img.step, QImage::Format_ARGB32);
                break;

            case CV_16UC4:
                //qDebug() << "CV_16UC4";
                _img = QImage((const unsigned char*)img.data, img.cols, img.rows, img.step, QImage::Format_RGBA64);
                _img = _img.rgbSwapped(); // BRG转为RGB
                break;

            default:
                break;
        }

        if(_isSaved){
            std::string path = _path.toStdString() + ".jpg";

            switch (_saveType) {
                case 0:
                    cv::imwritemulti(path, img);
                    setIsSaved(false);
                    break;
                case 1:
                    _out.write(img);
                    break;
            }
        }

        msleep(30);

        emit receiveImage(_img);
    }

}

void CVThread::setIsSaved(bool isSaved) {
    _isSaved = isSaved;

    if(_isSaved){
        QString currentPath = QCoreApplication::applicationDirPath();
        QString currentTime = QDateTime::currentDateTime().toString("yyyy_MM_dd_hh_mm_ss");
        QDir dir;
        dir.setPath(currentPath);
        switch (_saveType) {
            case 0:
                if(!dir.exists(_historyPhoto)){
                    if(dir.mkdir(_historyPhoto)){
                        if(!dir.exists(_historyPhoto + QDir::separator() + currentTime)){
                            dir.mkdir(_historyPhoto + QDir::separator() + currentTime);
                        }
                    }
                }
                _path = _historyPhoto + QDir::separator() + currentTime;
                break;
            case 1:
                if(!dir.exists(_historyVideo)){
                    if(dir.mkdir(_historyVideo)){
                        if(!dir.exists(_historyVideo + QDir::separator() + currentTime)){
                            dir.mkdir(_historyVideo + QDir::separator() + currentTime);
                        }
                    }
                }
                _path = _historyVideo + QDir::separator() + currentTime;
                /********************************opencv测试***************************************/
                int fourcc;
                switch(img.type()){
                    case CV_8UC3:
                        fourcc = cv::VideoWriter::fourcc('X', 'V', 'I', 'D');  // 使用XVID编码器
                        _out.open(_path.toStdString()+".avi", fourcc, 30.0, cv::Size(img.cols, img.rows));
                        break;
                    case CV_8UC1:
                        fourcc = cv::VideoWriter::fourcc('X', 'V', 'I', 'D');  // 使用XVID编码器
                        _out.open(_path.toStdString()+".avi", fourcc, 30.0, cv::Size(img.cols, img.rows), false);
                        break;
                }

                break;
        }
        /********************************opencv测试***************************************/
    }else{
        switch (_saveType) {
            case 0:
                emit sig_save_complete();
                break;
            case 1:
                _out.release();
                break;
        }
    }
}

void CVThread::setSaveType(int saveType) {
    _saveType = saveType;
}


OpencvWidget::OpencvWidget(QQuickItem *parent) : QQuickPaintedItem(parent)
{
    _videoPlayer = new CVThread();

    connect(_videoPlayer,&CVThread::receiveImage,this,&OpencvWidget::updataImage);
    connect(_videoPlayer,&CVThread::sig_save_complete,this,&OpencvWidget::on_save_complete);
    this->update();

}



OpencvWidget::~OpencvWidget()
{

}

void OpencvWidget::setUrl(QString url)
{
    _url=url;
    //    _videoPlayer->setUrl(_url);
}

QString OpencvWidget::getUrl()
{
    return _url;
}

void OpencvWidget::paint(QPainter *painter)
{
    painter->drawImage(QRect(0, 0, nWidth, nHeight), _image);
}

void OpencvWidget::start()
{
    _videoPlayer->startVideo();
}

void OpencvWidget::setNWidth(qreal width)
{
    nWidth = width;
}

qreal OpencvWidget::getNWidth()
{
    return nWidth;
}

void OpencvWidget::setNHeight(qreal height)
{
    nHeight=height;
}

qreal OpencvWidget::getNHeight()
{
    return nHeight;
}

void OpencvWidget::updataImage(QImage image)
{
    _image=image;
    // qDebug()<<"len"<<image.size();
    this->update();
}

void OpencvWidget::setIsSaved(bool isSaved) {
    _videoPlayer->setIsSaved(isSaved);
    _isSaved = isSaved;
    emit isSavedChanged();
}
void OpencvWidget::setSaveType(int saveType) {
    _videoPlayer->setSaveType(saveType);
    _saveType = saveType;
    emit saveTypeChanged();
}

void OpencvWidget::on_save_complete() {
    _isSaved = false;
    emit isSavedChanged();}
