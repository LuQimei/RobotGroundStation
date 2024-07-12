//
// Created by Wang on 2022/10/7.
//

#pragma once

#include "LinkInterface.h"
#include <QTcpSocket>

class TcpClientLink : public LinkInterface {
    Q_OBJECT
public:
    explicit TcpClientLink(QString serverAddr, int serverPort,  QObject *parent = nullptr);

    ~TcpClientLink();

    void connectToServer(QString serverAddr, int serverPort);


    void run() override;

    bool _connect() override;

public slots:
    void senData(const QByteArray &data);
    void onReceiveData();
    void onStateChanged(QAbstractSocket::SocketState);

signals:
    void sig_receiveData(QByteArray &data);



private:
    QString         _serverAddr;
    int             _serverPort;
    QTcpSocket*     _socket;
    bool            _isConnect;
    QTimer          *_timer;

};
