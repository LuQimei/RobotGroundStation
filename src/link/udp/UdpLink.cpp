#include "UdpLink.h"


UdpLink::UdpLink(QHostAddress addr, quint16 port, QObject *parent) {
    udpInit(addr,port);
    connect(_udpSocket, &QUdpSocket::readyRead, this, &UdpLink::handleData);
}

UdpLink::~UdpLink(){
    _udpSocket->close();
    quit();
    wait();
}

void UdpLink::run() {
    exec();
}

void UdpLink::udpInit(QHostAddress hostAddr, quint16 port) {
    _udpSocket = new QUdpSocket();
    _isLink = _udpSocket->bind(hostAddr, port, QUdpSocket::ShareAddress);
    spdlog::info("binding =====>{}---{}",hostAddr.toString().toStdString(), port);

    if(_isLink){
        spdlog::info("Bind Success");

    }
    else{
        spdlog::info("Bind Fail, plase retry");
    }
}

void UdpLink::handleData() {
    if (_udpSocket->hasPendingDatagrams()) {
        QByteArray receivedData;
        receivedData.resize(_udpSocket->pendingDatagramSize());

        //获取到是谁发来的消息，端口是什么，最后把端口应到到发送的端口，实现双向通信
        _udpSocket->readDatagram(receivedData.data(), receivedData.size(), &clientAddr, &clientPort);
        emit sig_receiveData(receivedData);
    }

}

void UdpLink::sendMavData(mavlink_message_t &msg) {
//    QHostAddress sitlAddress("192.168.2.2"); // 替换为设备的IP地址
    uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
    int packetLen = mavlink_msg_to_send_buffer(buffer, &msg);
    _udpSocket->writeDatagram((const char*)buffer, packetLen, clientAddr, clientPort);
}

void UdpLink::writeData(QByteArray ba) {
//    _udpSocket->writeDatagram(ba, packetLen, sitlAddress, clientPort);
}




