#include "RovVehicle.h"
#include <QDebug>

#define                     COORDINATE_SIMULATOR                    1
#define                     COORDINATE_SBL                          1

RovVehicle::RovVehicle(QObject *parent)
        : QObject{parent} {
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<RovVehicle *>("RovVehicle*");
//    joyStick = new QGamepad();
    joystickStart();

    QTimer *_timer = new QTimer;
    _timer->start(1000);
    connect(_timer, &QTimer::timeout, this, [=] {
        if (_connectFlag == 0) {
            setIsConnect(false);
        } else{
            _connectFlag = 0;
        }
    });

//    QTimer *_timer2 = new QTimer;
//    _timer2->start(500);
//    connect(_timer2, &QTimer::timeout, this, [=] {
//        LOGI("===============================================> rov current lng : {},            lat : {},          yaw : {}",_coordinate.longitude(), _coordinate.latitude(), yawAngle);
//
//    });

    _planTimer = new QTimer;
    connect(_planTimer, &QTimer::timeout, this, [=] {
        static int i = 0;
        QGeoCoordinate target_point;
//        LOGD("=============================>_plan count : {}",  _plan->count());

        if(i < _plan->count()){
            target_point = _plan->coordinateList().at(i);
//            LOGD("=============================> pid control target point lng : {}, lat : {}", target_point.longitude(), target_point.latitude());
//            set_target_point(point_list[i]);
        }else{
            i = 0;
            _planTimer->stop();
            setIsExecutePlan(false);
//            setState(ROV_STATE_ACTIVE);
            setSystemModeText("manual");
            return ;
        }

        double _distance = coordinate().distanceTo(target_point);
        double _bearing  = coordinate().azimuthTo(target_point);
        LOGD("=============================> _distance : {}, _bearing : {}", _distance, _bearing);

        double speed = _headingPidControl->headingPid(yawAngle, _bearing, 3, _heading, _yawSpeed);
        LOGD("=============================> speed : {},", speed);

        if(speed != 0){
            setChannel4Value(speed);
            setRcChannel();
        }else{
            double forwardspeed = _pwmPidControl->pwmPid(_distance, 1);
            LOGD("=============================> forwardspeed : {},", forwardspeed);
            setChannel4Value(1500);
            setChannel5Value(forwardspeed);
            setRcChannel();
        }


        if (_distance<1){
            i++;
        }
    });


    _homeTimer = new QTimer;
    connect(_homeTimer, &QTimer::timeout, this, [=] {
        double _distance = coordinate().distanceTo(_homeCoordinate);
        double _bearing  = coordinate().azimuthTo(_homeCoordinate);

        double speed = _headingPidControl->headingPid(yawAngle, _bearing, 3, _heading, _yawSpeed);

        if(speed != 0){
            setChannel4Value(speed);
            setRcChannel();
        }else{
            double forwardspeed = _pwmPidControl->pwmPid(_distance, 1);
            setChannel4Value(1500);
            setChannel5Value(forwardspeed);
            setRcChannel();
        }

        if (_distance<1){
            _homeTimer->stop();
            setIsGoHome(false);
//            setState(ROV_STATE_ACTIVE);
            setSystemModeText("manual");
            return ;
        }
    });
    setState(0);
}

RovVehicle::~RovVehicle() {

}


float RovVehicle::getHeading() const {
    return _heading;
}

void RovVehicle::setHeading(float newHeading) {
    if (_heading == newHeading)
        return;
    _heading = newHeading;
    emit headingChanged();
}

bool RovVehicle::isConnect() const {
    return _isConnect;
}

void RovVehicle::setIsConnect(bool newIsConnect) {
    if (_isConnect == newIsConnect)
        return;
    _isConnect = newIsConnect;
    emit isConnectChanged();
}

QGeoCoordinate RovVehicle::coordinate() const {
    return _coordinate;
}

void RovVehicle::setCoordinate(const QGeoCoordinate &newCoordinate) {
    if (_coordinate == newCoordinate)
        return;
    _coordinate = newCoordinate;
    emit coordinateChanged();
}

double RovVehicle::getRollAngle() const {
    return rollAngle;
}

void RovVehicle::setRollAngle(double newRollAngle) {
    if (qFuzzyCompare(rollAngle, newRollAngle))
        return;
    rollAngle = newRollAngle;
    emit rollAngleChanged();
}

double RovVehicle::getPitchAngle() const {
    return pitchAngle;
}

void RovVehicle::setPitchAngle(double newPitchAngle) {
    if (qFuzzyCompare(pitchAngle, newPitchAngle))
        return;
    pitchAngle = newPitchAngle;
    emit pitchAngleChanged();
}

double RovVehicle::getYawAngle() const {
    return yawAngle;
}

void RovVehicle::setYawAngle(double newYawAngle) {
    if (qFuzzyCompare(yawAngle, newYawAngle))
        return;
    yawAngle = newYawAngle;
    emit yawAngleChanged();
}

uint16_t RovVehicle::limitMaxRange(uint16_t pwm) {
    if (pwm > maxPwm) {
        pwm = maxPwm;
    }
    if (pwm < 1600) {
        pwm = 1600;
    }
    return pwm;
}

uint16_t RovVehicle::limitMinRange(uint16_t pwm) {
    if (pwm > 1400) {
        pwm = 1400;
    }
    if (pwm < minPwm) {
        pwm = minPwm;
    }
    return pwm;
}


double RovVehicle::rad2deg(double rad) {
    double degrees = rad * 180 / M_PI;
    if (degrees < 0.0) {
        degrees += 360.0;
    }
    if (degrees >= 360.0) {
        degrees -= 360.0;
    }

    return degrees;
}

double RovVehicle::deg2rad(double deg) {
    return deg * M_PI / 180.0;
}

double RovVehicle::convertTo180Range(double radians) {
    double degrees = qRadiansToDegrees(radians); // 弧度转角度
    if (degrees > 180.0) {
        degrees -= 360.0;
    } else if (degrees < -180.0) {
        degrees += 360.0;
    }

    return degrees;
}

double RovVehicle::pressure2Depth(double pressure) {
    const double atmosphericPressure = 101325.0;  // 单位：帕斯卡 (Pa)，标准大气压
    const double waterDensity = 1025.0;           // 单位：千克/立方米 (kg/m³)，海水密度
    const double gravity = 9.81;                  // 单位：米/秒² (m/s²)，重力加速度

    double caldepth = (pressure * 100 - atmosphericPressure) / (waterDensity * gravity);
    return caldepth;
}

double RovVehicle::mapToRange(double value, double inputMin, double inputMax, double outputMin, double outputMax) {
    return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin);
}

double RovVehicle::getDepth() const {
    return depth;
}

void RovVehicle::setDepth(double newDepth) {
    if (qFuzzyCompare(depth, newDepth))
        return;
    depth = newDepth;
    emit depthChanged();
}

QVariantList RovVehicle::track() const {
    return _track;
}

void RovVehicle::arm() {
    mavlink_command_long_t cmd = {0};

    cmd.target_system = SYSTEM_ID;
    cmd.target_component = COMPONENT_ID;
    cmd.command = MAV_CMD_COMPONENT_ARM_DISARM;
    cmd.confirmation = 0;
    cmd.param1 = 1.0f;

    // Encode
    mavlink_message_t message;

    mavlink_msg_command_long_encode(STATION_SYSYEM_ID, STATION_COMPONENT_ID, &message, &cmd);
    emit sig_sendData(message);


    setLockState(false);
//    link->sendMavData(message);
}

void RovVehicle::disarm() {
    mavlink_command_long_t cmd = {0};

    cmd.target_system = SYSTEM_ID;
    cmd.target_component = COMPONENT_ID;
    cmd.command = MAV_CMD_COMPONENT_ARM_DISARM;
    cmd.confirmation = 0;
    cmd.param1 = 0.0f;

    // Encode
    mavlink_message_t message;
    mavlink_msg_command_long_encode(STATION_SYSYEM_ID, STATION_COMPONENT_ID, &message, &cmd);
    emit sig_sendData(message);     //发送数据

    setLockState(true);

//    link->sendMavData(message);
}

/******************
*   0-STABLELIZIED
*   2-DEPTH_HOLD
*   19-MANUAL
*********************/
void RovVehicle::setMode(float mode) {
    mavlink_message_t message;
    mavlink_command_long_t cmd;

    cmd.target_system = SYSTEM_ID;
    cmd.target_component = COMPONENT_ID;
    cmd.command = MAV_CMD_DO_SET_MODE;  // 设置模式的命令
    cmd.confirmation = 0;  // 不需要确认
    cmd.param1 = 19;  // 自定义模式，通常设置为0
    cmd.param2 = mode;  // 基本模式标志位

    // 将命令消息打包为 Mavlink 消息
    mavlink_msg_command_long_encode(STATION_SYSYEM_ID, STATION_COMPONENT_ID, &message, &cmd);
//    link->sendMavData(message);
    emit sig_sendData(message);
}

/*
rc_override.chan1_raw: Pitch。
rc_override.chan2_raw: Roll
rc_override.chan3_raw: Throttle，控制上升和下降。
rc_override.chan4_raw: Yaw通常用于控制偏航（Yaw），控制水平旋转。
rc_override.chan5_raw: Forward
rc_override.chan6_raw: Lateral 横移？
rc_override.chan7_raw: Camera Pan
rc_override.chan5_raw 到 rc_override.chan8_raw: 这些通道可以根据需要用于其他控制，例如灯光、摄像头云台或其他特殊功能。
*/
void RovVehicle::setRcChannel() {
    mavlink_message_t message;
    mavlink_rc_channels_override_t rc_override;

    // 设置消息字段
    rc_override.target_system = SYSTEM_ID; // 目标系统的ID
    rc_override.target_component = COMPONENT_ID; // 目标组件的ID

    // 设置遥控通道的值
    rc_override.chan1_raw = channel1Value;
    rc_override.chan2_raw = channel2Value;
    rc_override.chan3_raw = channel3Value;
    rc_override.chan4_raw = channel4Value;
    rc_override.chan5_raw = channel5Value;
    rc_override.chan6_raw = channel6Value;
    rc_override.chan7_raw = channel7Value;
    rc_override.chan8_raw = channel8Value;

    // 填充消息数据
    mavlink_msg_rc_channels_override_encode(STATION_SYSYEM_ID, STATION_COMPONENT_ID, &message, &rc_override);
//    link->sendMavData(message);
    emit sig_sendData(message);
}

//轴的数值上左是负值
void RovVehicle::joystickStart() {

    joyStick = new QGamepad();

    connect(joyStick, &QGamepad::connectedChanged, this, [=](bool value) {
        LOGD("joystick is connected:{}", value);
    });


    connect(joyStick, &QGamepad::buttonBChanged, this, [=](bool value) {
//        qDebug() << value;
        if (value) {
//            setMode(19);
            LOGD("手动模式");
            setManualMode();

        }
    });
    connect(joyStick, &QGamepad::buttonAChanged, this, [=](bool value) {
//        qDebug() << value;
        LOGD("A pressed {}",value);
    });
    connect(joyStick, &QGamepad::buttonXChanged, this, [=](bool value) {
        LOGD("X pressed {}",value);

        if (value) {
//            setMode(2);//定深
            LOGD("定深模式");
            setDepthHoldMode();
        }
    });
    connect(joyStick, &QGamepad::buttonYChanged, this, [=](bool value) {

        if (value) {
//            setMode(0);//定航
            LOGD("定航模式");
            setStabilizeMode();
        }
    });

    //开锁start键

    connect(joyStick, &QGamepad::buttonStartChanged, this, [=](bool value) {
        qDebug() << value;
        if (value) {
            arm();
            LOGD("arm");
        }
    });

    //关锁back键

    connect(joyStick,&QGamepad::buttonSelectChanged,this,[=](bool value){
        qDebug() << value;
        if (value) {
            disarm();
            LOGD("disarm");
        }
    });


    connect(joyStick, &QGamepad::axisLeftXChanged, this, [=](double value) {
        if (value == -1) {
            setChannel4Value(negativePwm);
//            channel4Value = negativePwm;
            setRcChannel();
            LOGD("turn left");
        } else if (value == 1) {
//            channel4Value = positivePwm;
            setChannel4Value(positivePwm);
            setRcChannel();
            LOGD("turn right");
        } else {
//            channel4Value = CH;
            setChannel4Value(CH);
            setRcChannel();
        }
    });




    connect(joyStick, &QGamepad::axisLeftYChanged, this, [=](double value) {
        if (value <= -0.9) {
            setChannel3Value(negativePwm);
            setRcChannel();
            LOGD("up");
        } else if (value >= 0.9) {
            setChannel3Value(positivePwm);
            setRcChannel();
            LOGD("down");
        } else {
            setChannel3Value(CH);
            setRcChannel();
        }

    });

    connect(joyStick, &QGamepad::axisRightXChanged, this, [=](double value) {
        if (value == -1) {
            setChannel6Value(negativePwm);
            setRcChannel();
            LOGD("左横");
        } else if (value == 1) {
            setChannel6Value(positivePwm);
            setRcChannel();
            LOGD("右横");
        } else {
            setChannel6Value(CH);
            setRcChannel();
        }
    });

    connect(joyStick, &QGamepad::axisRightYChanged, this, [=](double value) {
        if (value <= -0.9) {
            setChannel5Value(positivePwm);
            setRcChannel();
            LOGD("前进");
        } else if (value >= 0.9) {
            setChannel5Value(negativePwm);
            setRcChannel();
            LOGD("后退");
        } else {
            setChannel5Value(CH);
            setRcChannel();
        }
    });



    connect(joyStick, &QGamepad::buttonUpChanged, this, [=](bool value) {
        qDebug() << value;
        if (value) {
            positivePwm = limitMaxRange(positivePwm += 100);
            negativePwm = limitMinRange(negativePwm -= 100);
            switch (positivePwm) {
                case 1600:
                    setGearText("1");
                    break;
                case 1700:
                    setGearText("2");
                    break;
                case 1800:
                    setGearText("3");
                    break;
                case 1900:
                    setGearText("4");
                    break;
            }
        }
    });
    connect(joyStick, &QGamepad::buttonDownChanged, this, [=](bool value) {
        qDebug() << value;
        if (value) {
            positivePwm = limitMaxRange(positivePwm -= 100);
            negativePwm = limitMinRange(negativePwm += 100);
            switch (positivePwm) {
                case 1600:
                    setGearText("1");
                    break;
                case 1700:
                    setGearText("2");
                    break;
                case 1800:
                    setGearText("3");
                    break;
                case 1900:
                    setGearText("4");
                    break;
            }
        }
    });
//    connect(joyStick, &QGamepad::buttonLeftChanged, this, [=](bool value) {
//        qDebug() << value;
//    });
//    connect(joyStick, &QGamepad::buttonRightChanged, this, [=](bool value) {
//        qDebug() << value;
//    });


}

void RovVehicle::stopRun() {
    setChannel3Value(positivePwm);
    setChannel4Value(positivePwm);
    setChannel6Value(CH);
    setChannel5Value(CH);
    setRcChannel();
}

double RovVehicle::getBeaconLongitude() const{
    return beaconLongitude;

}

double RovVehicle::getBeaconLatitude() const{
    return beaconLatitude;
}

uint16_t RovVehicle::getChannel1Value() const {
    return channel1Value;
}

void RovVehicle::setChannel1Value(uint16_t newChannel1Value) {
    if (channel1Value == newChannel1Value)
        return;
    channel1Value = newChannel1Value;
    emit channel1ValueChanged();
}

uint16_t RovVehicle::getChannel2Value() const {
    return channel2Value;
}

void RovVehicle::setChannel2Value(uint16_t newChannel2Value) {
    if (channel2Value == newChannel2Value)
        return;
    channel2Value = newChannel2Value;
    emit channel2ValueChanged();
}

uint16_t RovVehicle::getChannel3Value() const {
    return channel3Value;
}

void RovVehicle::setChannel3Value(uint16_t newChannel3Value) {
    if (channel3Value == newChannel3Value)
        return;
    channel3Value = newChannel3Value;
    emit channel3ValueChanged();
}

uint16_t RovVehicle::getChannel4Value() const {
    return channel4Value;
}

void RovVehicle::setChannel4Value(uint16_t newChannel4Value) {
    if (channel4Value == newChannel4Value)
        return;
    channel4Value = newChannel4Value;
    emit channel4ValueChanged();
}

uint16_t RovVehicle::getChannel5Value() const {
    return channel5Value;
}

void RovVehicle::setChannel5Value(uint16_t newChannel5Value) {
    if (channel5Value == newChannel5Value)
        return;
    channel5Value = newChannel5Value;
    emit channel5ValueChanged();
}

uint16_t RovVehicle::getChannel6Value() const {
    return channel6Value;
}

void RovVehicle::setChannel6Value(uint16_t newChannel6Value) {
    if (channel6Value == newChannel6Value)
        return;
    channel6Value = newChannel6Value;
    emit channel6ValueChanged();
}

uint16_t RovVehicle::getChannel7Value() const {
    return channel7Value;
}

void RovVehicle::setChannel7Value(uint16_t newChannel7Value) {
    if (channel7Value == newChannel7Value)
        return;
    channel7Value = newChannel7Value;
    emit channel7ValueChanged();
}

uint16_t RovVehicle::getChannel8Value() const {
    return channel8Value;
}

void RovVehicle::setChannel8Value(uint16_t newChannel8Value) {
    if (channel8Value == newChannel8Value)
        return;
    channel8Value = newChannel8Value;
    emit channel8ValueChanged();
}

void RovVehicle::onMessageReceived(const QByteArray msg) {
    mavlink_message_t receivedMsg;
    mavlink_status_t status;
    for (int i = 0; i < msg.size(); ++i) {
        if (mavlink_parse_char(MAVLINK_COMM_0, msg[i], &receivedMsg, &status)) {
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
                case MAVLINK_MSG_ID_BATTERY_STATUS:
                    handleBattery(receivedMsg);
                    break;
                    // 添加其他消息类型的处理
                default:
                    break;

            }
        }
    }



    if(!_isConnect){
        setIsConnect(true);
    }
    _connectFlag++;
}

void RovVehicle::handleHeartbeat(const mavlink_message_t &message) {
    static uint32_t _custom_mode = -1;
    static uint8_t _system_status = -1;
    static uint8_t _base_mode = -1;


    mavlink_heartbeat_t heartbeat;
    mavlink_msg_heartbeat_decode(&message, &heartbeat);

    if(_base_mode != heartbeat.base_mode){
        _base_mode = heartbeat.base_mode;
        setState(_base_mode);

    }
    if(_custom_mode != heartbeat.custom_mode){
        _custom_mode = heartbeat.custom_mode;
        setRunState(_custom_mode);
    }
    if(_system_status != heartbeat.system_status){
        _system_status = heartbeat.system_status;
    }
//    LOGD("=====================>_custom_mode : {}, _system_status : {}, _base_mode : {}",_custom_mode, _system_status, _base_mode);

    // 处理心跳消息数据
//    emit recHeartBeat(heartbeat.type);
}

void RovVehicle::handleAttitude(const mavlink_message_t &message) {
    mavlink_attitude_t attitude;
    mavlink_msg_attitude_decode(&message, &attitude);

    _heading = attitude.yaw;
    _yawSpeed = attitude.yawspeed;

    // 处理姿态信息数据
    setRollAngle(convertTo180Range(attitude.roll));
    setPitchAngle(convertTo180Range(attitude.pitch));
    setYawAngle(convertTo180Range(attitude.yaw));



//    rollAngle = attitude.roll;
//    pitchAngle = attitude.pitch;
//    yawAngle = attitude.yaw;
//    LOGI("rollAngle:{}", rollAngle);
//    LOGI("pitchAngle:{}", pitchAngle);
//    LOGI("yawAngle:{}", yawAngle);
//    emit sendAttitude(attitude.roll, attitude.pitch, attitude.yaw);
}

void RovVehicle::handleGPS(const mavlink_message_t &message) {

#if COORDINATE_SIMULATOR
    mavlink_gps_raw_int_t gps;
    mavlink_msg_gps_raw_int_decode(&message, &gps);
    static double lng = 0;
    static double lat = 0;
    // 处理GPS信息数据
    QGeoCoordinate coor;
    lng = gps.lon / 10000000.0;
    lat = gps.lat / 10000000.0;

    coor.setLongitude(lng);
    coor.setLatitude(lat);
    //处理经纬度数据
    setCoordinate(coor);
    //在这里保存经纬度到列表，在qml中绘制航线
    _track.append(QVariant::fromValue(coor));
    emit trackChanged();
#endif

}

void RovVehicle::handlePressure(const mavlink_message_t &message) {
    mavlink_scaled_pressure_t pressure;
    mavlink_msg_scaled_pressure_decode(&message, &pressure);
    // 处理压力信息数据
    depth = pressure2Depth(pressure.press_abs);
//    LOGI("depth:{}", depth);
    //    emit sendPressure(pressure.press_abs);
}

void RovVehicle::handleBattery(const mavlink_message_t &message) {
    mavlink_battery_status_t battery;
    mavlink_msg_battery_status_decode(&message, &battery);
    setBattery(battery.battery_remaining);
}

void RovVehicle::handleBatteryInfo(const mavlink_message_t &message)
{
    mavlink_battery_status_t batteryInfo;
    mavlink_msg_battery_status_decode(&message, &batteryInfo);
    batteryInfo.current_battery;

}

//设为手动模式
void RovVehicle::setManualMode()
{
    mavlink_message_t message;
    mavlink_msg_set_mode_pack_chan(STATION_SYSYEM_ID,STATION_COMPONENT_ID,MAVLINK_COMM_0,&message,1,19,19);
    emit sig_sendData(message);

}
//设为定航模式
void RovVehicle::setStabilizeMode()
{
    mavlink_message_t message;
    mavlink_msg_set_mode_pack_chan(STATION_SYSYEM_ID,STATION_COMPONENT_ID,MAVLINK_COMM_0,&message,1,19,0);
    emit sig_sendData(message);
}
//设为定深模式
void RovVehicle::setDepthHoldMode()
{
    mavlink_message_t message;
    mavlink_msg_set_mode_pack_chan(STATION_SYSYEM_ID,STATION_COMPONENT_ID,MAVLINK_COMM_0,&message,1,19,2);
    emit sig_sendData(message);
}

void RovVehicle::onSblMessageReceived(const QByteArray msg) {
#if COORDINATE_SBL
    LOGD("======================================> data : {}", msg.toHex().toStdString());
    _recvData.append(msg);
    QByteArray data1;
    QByteArray checkData;
    QByteArray check;
    //拆分出单条数据
    static int headindex;
    static int endindex1;        //包尾索引1
    headindex = _recvData.indexOf(QByteArray::fromHex("FCCF"));

    if (headindex != -1) {
        _recvData.remove(0, headindex);
        endindex1 = _recvData.indexOf(QByteArray::fromHex("FEEF"));
        if(endindex1 != -1){
            data1 = _recvData.mid(2, endindex1 - 3);
            check = _recvData.mid(endindex1 - 1, 1);

            LOGD("lon========>{}",data1.mid(70,4).toHex());
            LOGD("lat========>{}",data1.mid(74,4).toHex());

            beaconLongitude = littleEndianToDecimal(data1.mid(70,4))/10000000.0;
            beaconLatitude = littleEndianToDecimal(data1.mid(74,4))/10000000.0;

            LOGI("======================================> 信标经度 : {}", beaconLongitude);
            LOGI("======================================> 信标纬度 : {}", beaconLatitude);
            QGeoCoordinate coor;
            coor.setLongitude(beaconLongitude);
            coor.setLatitude(beaconLatitude);
            setCoordinate(coor);
            //在这里保存经纬度到列表，在qml中绘制航线
            _track.append(QVariant::fromValue(coor));
            emit trackChanged();
//            LOGI("======================================> 经度 : {}", data1.mid(70,4).toHex().toStdString());
//            LOGI("======================================> 纬度 : {}", data1.mid(74,4).toHex().toStdString());

//            LOGI("======================================> check : {}", check.toHex().toStdString());

            _recvData.remove(headindex, endindex1 + 2);
        }
    }
#endif
}

quint32 RovVehicle::littleEndianToDecimal(const QByteArray &byteArray)
{
    quint32 result = 0;
    for(int i = 0; i < byteArray.size(); ++i)
    {
        result += (static_cast<quint32>(byteArray.at(i)) << (i * 8));
    }
    return result;
}


QByteArray RovVehicle::calculateXorChecksumAsByteArray(const QByteArray &data) {
    uint8_t checksum = 0;
    for (char byte : data) {
        checksum ^= static_cast<uint8_t>(byte);
    }
    // 创建一个大小为1的QByteArray，并将checksum作为元素
    QByteArray checksumByteArray;
    checksumByteArray.append(static_cast<char>(checksum));
    return checksumByteArray;
}

QGeoCoordinate RovVehicle::homeCoordinate() const {
    return _homeCoordinate;
}

void RovVehicle::setHomeCoordinate(const QGeoCoordinate &newHomeCoordinate) {
    _homeCoordinate = newHomeCoordinate;
    emit homeCoordinateChanged();
}

void RovVehicle::executeRoute(bool action) {
    if(!_isConnect){
        return;
    }
    if(_plan == nullptr){
        return;
    }
    if(_lockState == true){
        arm();
    }
    if(action){
        _planTimer->start(10);
        setIsExecutePlan(true);
//        setState(ROV_STATE_PLAN);
        setSystemModeText("plan");
    }else{
        _planTimer->stop();
        stopRun();
        setIsExecutePlan(false);
//        setState(ROV_STATE_ACTIVE);
        setSystemModeText("manual");
    }

}

void RovVehicle::goHome(bool action) {
    if(!_isConnect){
        return;
    }
    if(_plan == nullptr){
        return;
    }

    if(action){
        _homeTimer->start(10);
        setIsGoHome(true);
        setSystemModeText("go home");
//        setState(ROV_STATE_GOHOME);
    }else{
        _homeTimer->stop();
        stopRun();
        setIsGoHome(false);
//        setState(ROV_STATE_ACTIVE);
        setSystemModeText("manual");
    }

}

void RovVehicle::setState(int state) {
    switch (state) {
        case 81:
            setCurrentStateText("Ready to fly");
            setLockState(true);
            break;
        case 209:
            setCurrentStateText("Flying");
            setLockState(false);
            break;
        default:
            setCurrentStateText("Unconnected");
            break;
    }
//    switch (state) {
//        case ROV_STATE_UNINIT:
//            setCurrentStateText("Unconnected");
//            break;
//        case ROV_STATE_BOOT:
//            setCurrentStateText("Booting");
//            break;
//        case ROV_STATE_CALIBRATING:
//            setCurrentStateText("Calibrating");
//            break;
//        case ROV_STATE_STANDBY:
//            setCurrentStateText("Ready to fly");
//            setLockState(true);
//            break;
//        case ROV_STATE_ACTIVE:
//            setCurrentStateText("Flying");
//            setLockState(false);
//            break;
//        case ROV_STATE_PLAN:
//            setCurrentStateText("Executing plan");
//            break;
//        case ROV_STATE_GOHOME:
//            setCurrentStateText("Going home");
//            break;
//        default:
//            setCurrentStateText("Unconnected");
//            break;
//    }
}

void RovVehicle::setRunState(int state) {
    switch (state) {
        case 19:
            setRunMode(0);
            break;
        case 2:
            setRunMode(1);
            break;
        case 0:
            setRunMode(2);
            break;
    }
}

void RovVehicle::setLockState(bool newLockState)  {
    if(_lockState == newLockState){
        return;
    }
    setHomeCoordinate(_coordinate);
    _lockState = newLockState;
    emit lockStateChanged();
}

void RovVehicle::clearTrack() {
    _track.clear();
    emit trackChanged(1);
}



