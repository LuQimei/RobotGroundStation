#ifndef UDPLINK_H
#define UDPLINK_H
#pragma once


#include <log.hpp>

#include <GCToolbox.h>
#include <LinkInterface.h>
#include <json.hpp>

#include <QUdpSocket>
#include <mavlink/common/mavlink.h>
#include <mavlink/mavlink_types.h>


#define SYSTEM_ID		1
#define COMPONENT_ID	MAV_COMP_ID_AUTOPILOT1
#define BUFFER_LENGTH	MAVLINK_MAX_PACKET_LEN

class UdpLink : public LinkInterface
{
Q_OBJECT
public:
    UdpLink(QHostAddress addr, quint16 port, QObject *parent = nullptr);
    ~UdpLink();

    void                        run                 ()              override;
    bool                        _connect            () { return true; }

    void udpInit(QHostAddress hostAddr, quint16 port);
    //mavlink协议专用
    void sendMavData(mavlink_message_t &msg);

    void writeData(QByteArray ba);
signals:
    void sig_receiveData(QByteArray ba);

public slots:
    void handleData();
private:
    QUdpSocket *_udpSocket;
    QHostAddress _groupAdress;

    bool _isLink = false;
    QHostAddress clientAddr;
    quint16 clientPort;
//    bool isHeartbeat = false;
};

#endif // UDPLINK_H
