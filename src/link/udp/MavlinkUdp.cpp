#include "MavlinkUdp.h"

MavlinkUdp::MavlinkUdp(QHostAddress addr, quint16 port, QObject *parent)
{
    spdlog::info("UDP INIT");
    udpInit(addr, port);
}

MavlinkUdp::~MavlinkUdp()
{
    _udpSocket->close();
    quit();
    wait();
}

void MavlinkUdp::run()
{
    exec();
}

void MavlinkUdp::handleData(){
    if (_udpSocket->hasPendingDatagrams()) {
        QByteArray receivedData;
        receivedData.resize(_udpSocket->pendingDatagramSize());

        //获取到是谁发来的消息，端口是什么，最后把端口应到到发送的端口，实现双向通信
        _udpSocket->readDatagram(receivedData.data(), receivedData.size(), &clientAddr, &clientPort);
        //        udpSocket->readDatagram(receivedData.data(), receivedData.size());
        // 在这里处理接收到的MAVLink消息 你可以使用MAVLink库来解析消息
        emit deviceConnected(true);
        mavlink_message_t receivedMsg;
        mavlink_status_t status;
        for (int i = 0; i < receivedData.size(); ++i) {
            if (mavlink_parse_char(MAVLINK_COMM_0, receivedData[i], &receivedMsg, &status)) {
                // 根据消息类型处理消息 每个消息对应不同的ID
                switch (receivedMsg.msgid) {
                case MAVLINK_MSG_ID_HEARTBEAT:
                    handleHeartbeat(receivedMsg);
                    break;
                case MAVLINK_MSG_ID_ATTITUDE:
                    handleAttitude(receivedMsg);
                    break;
                case MAVLINK_MSG_ID_GPS_RAW_INT:
                    handleGPS(receivedMsg);
                    break;
                case MAVLINK_MSG_ID_SCALED_PRESSURE:
                    handlePressure(receivedMsg);
                    break;
                    // 添加其他消息类型的处理
                }
            }
        }
    }
    else{
        emit deviceConnected(false);
    }
}

void MavlinkUdp::udpInit(QHostAddress hostAddr, quint16 port)
{
    _udpSocket = new QUdpSocket();
    _isLink = _udpSocket->bind(hostAddr, port, QUdpSocket::ShareAddress);
    spdlog::info("binding =====>{}---{}",hostAddr.toString().toStdString(), port);

    if(_isLink){
        spdlog::info("Bind Success, ready to handle mavdata");
        connect(_udpSocket, &QUdpSocket::readyRead, this, &MavlinkUdp::handleData);
    }
    else{
        spdlog::info("Bind Fail, plase retry");
    }
}

void MavlinkUdp::sendMavData(mavlink_message_t &msg)
{
    QHostAddress sitlAddress("127.0.0.1"); // 替换为设备的IP地址
//    quint16 sitlPort = 14550; // 设备的默认端口
    uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
    int packetLen = mavlink_msg_to_send_buffer(buffer, &msg);
    _udpSocket->writeDatagram((const char*)buffer, packetLen, sitlAddress, clientPort);
}

void MavlinkUdp::handleHeartbeat(const mavlink_message_t &message) {
    mavlink_heartbeat_t heartbeat;
    mavlink_msg_heartbeat_decode(&message, &heartbeat);
    // 处理心跳消息数据
    emit recHeartBeat(heartbeat.type);
}

void MavlinkUdp::handleAttitude(const mavlink_message_t &message) {
    mavlink_attitude_t attitude;
    mavlink_msg_attitude_decode(&message, &attitude);
    // 处理姿态信息数据
    qDebug()<<attitude.roll<<"    "<<attitude.pitch<<"    "<<attitude.yaw;
    emit sendAttitude(attitude.roll, attitude.pitch, attitude.yaw);
}

void MavlinkUdp::handleGPS(const mavlink_message_t &message) {
    mavlink_gps_raw_int_t gps;
    mavlink_msg_gps_raw_int_decode(&message, &gps);
    // 处理GPS信息数据
    QGeoCoordinate coor;
    static double lng = gps.lon/10000000.0;
    static double lat = gps.lat/10000000.0;
    coor.setLongitude(gps.lon/1e7);
    coor.setLatitude(gps.lat/1e7);
    emit sendGPS(coor);
}

void MavlinkUdp::handlePressure(const mavlink_message_t &message) {
    mavlink_scaled_pressure_t pressure;
    mavlink_msg_scaled_pressure_decode(&message, &pressure);
    // 处理压力信息数据
    emit sendPressure(pressure.press_abs);
}
