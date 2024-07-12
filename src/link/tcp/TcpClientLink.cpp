//
// Created by 22527 on 2023/6/23.
//
#include "TcpClientLink.h"
#include "log.hpp"
#include "QTimer"

TcpClientLink::TcpClientLink(QString serverAddr, int serverPort, QObject *parent) :
        LinkInterface(),
        _serverAddr(serverAddr),
        _serverPort(serverPort),
        _socket(new QTcpSocket(this)) {
    connectToServer(serverAddr, serverPort);
    QObject::connect(_socket, &QTcpSocket::readyRead, this, &TcpClientLink::onReceiveData);
    QObject::connect(_socket, &QTcpSocket::stateChanged, this, &TcpClientLink::onStateChanged);
//    _timer = new QTimer;
//    _timer->setInterval(1000);
//    _timer->start();
//    connect(_timer, &QTimer::timeout, [this] (){
//        if(_socket->state() == QAbstractSocket::UnconnectedState){
//            connectToServer(_serverAddr, _serverPort);
//        }else if(_socket->state() == QAbstractSocket::ConnectedState){
//            return;
//        }
//    });

}

TcpClientLink::~TcpClientLink() {
    quit();
// Wait for it to exit
    wait();
}

void TcpClientLink::connectToServer(QString serverAddr, int serverPort) {
    if(_socket->isOpen()){
        _socket->close();
    }
    _serverAddr = serverAddr;
    _serverPort = serverPort;
    _socket->connectToHost(_serverAddr, _serverPort);
}

void TcpClientLink::onReceiveData() {
    QByteArray data = _socket->readAll();
    emit sig_receiveData(data);
}

void TcpClientLink::senData(const QByteArray &data) {
    LOGD("======================================>send ip : {} , port : {},  data : {}",_serverAddr.toStdString(), _serverPort, data.toHex().toStdString());
    _socket->write(data);
}

void TcpClientLink::run() {
    // 在线程中等待信号的到来
    exec();
}



bool TcpClientLink::_connect() {
    start(NormalPriority);
    return true;
}

void TcpClientLink::onStateChanged(QAbstractSocket::SocketState state) {
    if(state == QAbstractSocket::UnconnectedState){
        connectToServer(_serverAddr, _serverPort);
    }
}




