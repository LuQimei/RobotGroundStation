#ifndef MAVLINKUDP_H
#define MAVLINKUDP_H

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


class MavlinkUdp : public LinkInterface
{
    Q_OBJECT
public:
    explicit MavlinkUdp(QHostAddress addr, quint16 port, QObject *parent = nullptr);
    ~MavlinkUdp();

    void                        run                 ()              override;
    bool                        _connect            () { return true; }

    void udpInit(QHostAddress hostAddr, quint16 port);
//    void parseMavlinkMessage(uint8_t* buf, int64_t bufSize);
//    void decodeMavlinkMessage(mavlink_message_t* msg);
//    void writeBytes(const char *data, uint16_t len);
    void sendMavData(mavlink_message_t &msg);

    void handleHeartbeat(const mavlink_message_t& message);

    void handleAttitude(const mavlink_message_t& message);

    void handleGPS(const mavlink_message_t& message);

    void handlePressure(const mavlink_message_t& message);

signals:
    void sendAttitude(double roll, double pitch, double yaw);
    void sendGPS(QGeoCoordinate coor);
    void sendPressure(double press);
    void recHeartBeat(uint8_t type);
    void deviceConnected(bool state);

public slots:
//    void readBytes(void);
    void handleData();

//private:
//    QUdpSocket *_udpSocket;
//    bool _isLink;

private:
    QUdpSocket *_udpSocket;
    QHostAddress _groupAdress;
//    QMutex*		_mutex;
    bool _isLink = false;
    QHostAddress clientAddr;
    quint16 clientPort;
    bool isHeartbeat = false;
};

#endif // MAVLINKUDP_H
