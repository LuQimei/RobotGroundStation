#ifndef CV_THREAD_H
#define CV_THREAD_H

#include <QObject>
#include <QThread>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <iostream>
#include <QtQuick/QQuickPaintedItem>
#include <QImage>
#include <opencv2/imgproc/types_c.h>
#include <QPainter>


class CVThread : public QThread
{
    //有信号就必须得有他
Q_OBJECT

public:

    CVThread();

    void run() override;

    void startVideo();

    void setIsSaved(bool isSaved);

    void setSaveType(int saveType);

signals:

    void receiveImage(const QImage &image);

    void sig_save_complete();

private:
    cv::VideoCapture    cap;  //声明相机捕获对象
    cv::Mat             img;
    QImage              _img;
    QString             _path;
    QString             _fileName;
    bool                _runThread{false};
    cv::VideoWriter     _out;
    bool                _isSaved{false};
    QString             _historyVideo{"history_video"};
    QString             _historyPhoto{"history_photo"};
    int                 _saveType{0};

};



//实时视频显示窗体类
class OpencvWidget : public QQuickPaintedItem
{
Q_OBJECT
    Q_PROPERTY(QString url READ getUrl WRITE setUrl)
    Q_PROPERTY(qreal nWidth READ getNWidth WRITE setNWidth)
    Q_PROPERTY(qreal nHeight READ getNHeight WRITE setNHeight)
    Q_PROPERTY(QString video READ video WRITE setVideo)
    Q_PROPERTY(bool isSaved READ isSaved WRITE setIsSaved NOTIFY isSavedChanged)
    Q_PROPERTY(int saveType READ saveType WRITE setSaveType NOTIFY saveTypeChanged)


public:
    OpencvWidget(QQuickItem *parent = 0);
    virtual ~OpencvWidget();

    void setUrl(QString url);
    QString getUrl();

    virtual void paint(QPainter *painter);

    Q_INVOKABLE void start();


    void setNWidth(qreal width);
    qreal getNWidth();

    void setNHeight(qreal height);
    qreal getNHeight();

    void setVideo(QString url) { _video = url; start(); }
    QString video() { return _video; }


    bool isSaved() { return _isSaved; }
    void setIsSaved(bool isSaved);
    int saveType() { return _saveType; }
    void setSaveType(int saveType);

public slots:
    void updataImage(QImage image);

    void on_save_complete();

signals:
    void isSavedChanged();
    void saveTypeChanged();

private:
    QImage _image;
    QString _url;
    qreal nWidth;
    qreal nHeight;
    QString _video;
    CVThread *_videoPlayer{};
    bool _isSaved{false};
    int _saveType{0};

};


#endif // CV_THREAD_H
