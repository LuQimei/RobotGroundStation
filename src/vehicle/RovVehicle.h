#ifndef ROVVEHICLE_H
#define ROVVEHICLE_H

#include <QObject>
#include <QtQml>
#include <UdpLink.h>
#include <QtLocation>
#include <cmath>
#include <QtGamepad/QGamepad>
//#include <QtGamepad/QGamepad>
//#include <QGamepadManager>
#include <QGeoCoordinate>
#include <QDebug>
#include "GCMapPolyline.h"
#include "RovPidControl.h"

#define SYSTEM_ID        1
#define COMPONENT_ID    MAV_COMP_ID_AUTOPILOT1
#define STATION_SYSYEM_ID 255
#define STATION_COMPONENT_ID 0

#define ROV_STATE_UNINIT            0
#define ROV_STATE_BOOT              1
#define ROV_STATE_CALIBRATING       2
#define ROV_STATE_STANDBY           3
#define ROV_STATE_ACTIVE            4
#define ROV_STATE_PLAN              9
#define ROV_STATE_GOHOME            10

typedef struct Data {
    unsigned short imuTemperature;
    float rollAngle;
    float pitchAngle;
    float yawAngle;
    unsigned char targetCount;
    unsigned char currentTargetID;
    unsigned char targetFrequency;
    unsigned char mainMode;
    unsigned char subMode;
    unsigned char filterParam;
    unsigned short syncCount;
    float absolutePhase1;
    float phaseDiff12;
    float phaseDiff13;
    float phaseDiff14;
    unsigned char pressureVoltage;
    unsigned char reserved[3];
    float range1;
    float range2;
    float range3;
    float range4;
    float beaconX;
    float beaconY;
    float beaconZ;
    float earthCoordX;
    float earthCoordY;
    float earthCoordZ;
    float baselineX;
    float baselineY;
    float baselineZ;
    float installAngleX;
    float installAngleY;
    float installAngleZ;
    float beaconDepth;
    float soundSpeed;
    float gain;
    float signalEnergy;
    unsigned char signalFrequency;
    unsigned char checksum;
}SblData;


class RovVehicle : public QObject {
Q_OBJECT
public:
    explicit RovVehicle(QObject *parent = nullptr);

    ~RovVehicle();

    void handHeartBeat(const mavlink_message_t &message);

    void handleAttitude(const mavlink_message_t &message);

    void handleGPS(const mavlink_message_t &message);

    void handlePressure(const mavlink_message_t &message);

    void handleBattery(const mavlink_message_t &message);

    void handleBatteryInfo(const mavlink_message_t &message);



    float getHeading() const;

    void setHeading(float newHeading);

    Q_PROPERTY(float heading READ getHeading WRITE setHeading NOTIFY headingChanged)
    Q_PROPERTY(bool isConnect READ isConnect WRITE setIsConnect NOTIFY isConnectChanged)
    Q_PROPERTY(QGeoCoordinate coordinate READ coordinate WRITE setCoordinate NOTIFY coordinateChanged)
    Q_PROPERTY(QGeoCoordinate homeCoordinate READ homeCoordinate WRITE setHomeCoordinate NOTIFY homeCoordinateChanged)
    Q_PROPERTY(double rollAngle READ getRollAngle WRITE setRollAngle NOTIFY rollAngleChanged)
    Q_PROPERTY(double pitchAngle READ getPitchAngle WRITE setPitchAngle NOTIFY pitchAngleChanged)
    Q_PROPERTY(double yawAngle READ getYawAngle WRITE setYawAngle NOTIFY yawAngleChanged)
    Q_PROPERTY(double depth READ getDepth WRITE setDepth NOTIFY depthChanged)
    Q_PROPERTY(QVariantList track READ track NOTIFY trackChanged)
    Q_PROPERTY(GCMapPolyline *plan READ plan WRITE setPlan NOTIFY planChanged)
    Q_PROPERTY(QGamepad *joystick READ joystick CONSTANT)
    Q_PROPERTY(bool lockState READ lockState WRITE setLockState NOTIFY lockStateChanged)
    Q_PROPERTY(int runMode READ runMode WRITE setRunMode NOTIFY runModeChanged)
    Q_PROPERTY(bool isExecutePlan READ isExecutePlan WRITE setIsExecutePlan NOTIFY isExecutePlanChanged)
    Q_PROPERTY(bool isGoHome READ isGoHome WRITE setIsGoHome NOTIFY isGoHomeChanged)
    Q_PROPERTY(QString currentStateText READ currentStateText WRITE setCurrentStateText NOTIFY currentStateTextChanged)
    Q_PROPERTY(QString systemModeText READ systemModeText WRITE setSystemModeText NOTIFY systemModeTextChanged)
    Q_PROPERTY(QString gearText READ gearText WRITE setGearText NOTIFY gearTextChanged)
    Q_PROPERTY(int battery READ battery WRITE setBattery NOTIFY batteryChanged)

    Q_PROPERTY(uint16_t channel1Value READ getChannel1Value WRITE setChannel1Value NOTIFY channel1ValueChanged)
    Q_PROPERTY(uint16_t channel2Value READ getChannel2Value WRITE setChannel2Value NOTIFY channel2ValueChanged)
    Q_PROPERTY(uint16_t channel3Value READ getChannel3Value WRITE setChannel3Value NOTIFY channel3ValueChanged)
    Q_PROPERTY(uint16_t channel4Value READ getChannel4Value WRITE setChannel4Value NOTIFY channel4ValueChanged)
    Q_PROPERTY(uint16_t channel5Value READ getChannel5Value WRITE setChannel5Value NOTIFY channel5ValueChanged)
    Q_PROPERTY(uint16_t channel6Value READ getChannel6Value WRITE setChannel6Value NOTIFY channel6ValueChanged)
    Q_PROPERTY(uint16_t channel7Value READ getChannel7Value WRITE setChannel7Value NOTIFY channel7ValueChanged)
    Q_PROPERTY(uint16_t channel8Value READ getChannel8Value WRITE setChannel8Value NOTIFY channel8ValueChanged)

    Q_PROPERTY(double beaconLongitude READ getBeaconLongitude)
    Q_PROPERTY(double beaconLatitude  READ getBeaconLatitude)

    double getBeaconLongitude() const;
    double getBeaconLatitude() const;

    bool isConnect() const;

    void setIsConnect(bool newIsConnect);


    QGeoCoordinate coordinate() const;

    void setCoordinate(const QGeoCoordinate &newCoordinate);

    QGeoCoordinate homeCoordinate() const;

    void setHomeCoordinate(const QGeoCoordinate &newHomeCoordinate);

    double getRollAngle() const;

    void setRollAngle(double newRollAngle);

    double getPitchAngle() const;

    void setPitchAngle(double newPitchAngle);

    double getYawAngle() const;

    void setYawAngle(double newYawAngle);

    uint16_t limitMaxRange(uint16_t pwm);

    uint16_t limitMinRange(uint16_t pwm);

    QGamepad *joystick() { return joyStick; }

    double rad2deg(double rad);

    double deg2rad(double deg);

    double convertTo180Range(double radians);

    double pressure2Depth(double press);

    double mapToRange(double value, double inputMin, double inputMax, double outputMin, double outputMax);
//    bool sbl_message_check(QByteArray &sblMessage);

    QByteArray calculateXorChecksumAsByteArray(const QByteArray &data);

    quint32 littleEndianToDecimal(const QByteArray &byteArray);

    double getDepth() const;

    void setDepth(double newDepth);

    QVariantList track() const;

    GCMapPolyline *plan() const { return _plan; }
    void setPlan(GCMapPolyline *newPlan) { _plan = newPlan; emit planChanged(); }

    bool lockState() const { return _lockState; }
    void setLockState(bool newLockState);
    int runMode() const { return _runMode; }
    void setRunMode(int newRunMode) { _runMode = newRunMode; emit runModeChanged(); }
    bool isExecutePlan() const { return _isExecutePlan; }
    void setIsExecutePlan(bool newIsExecutePlan) { _isExecutePlan = newIsExecutePlan; emit isExecutePlanChanged(); }
    bool isGoHome() const { return _isGoHome; }
    void setIsGoHome(bool newIsGoHome) { _isGoHome = newIsGoHome; emit isGoHomeChanged(); }
    QString currentStateText() const { return _currentStateText; }
    void setCurrentStateText(QString newCurrentStateText) { _currentStateText = newCurrentStateText; emit currentStateTextChanged(); }
    QString systemModeText() const { return _systemModeText; }
    void setSystemModeText(QString systemModeText) { _systemModeText = systemModeText; emit systemModeTextChanged(); }
    QString gearText() const { return _gearText; }
    void setGearText(QString gearText) { _gearText = gearText; emit gearTextChanged(); }
    int battery()  const { return _battery; }
    void setBattery(int battery) { _battery = battery; emit batteryChanged(); }

    //机器人操作指令消息
    Q_INVOKABLE void arm();

    Q_INVOKABLE void disarm();

    Q_INVOKABLE void setMode(float mode);

    Q_INVOKABLE void setRcChannel();

    Q_INVOKABLE void setManualMode();
    Q_INVOKABLE void setStabilizeMode();
    Q_INVOKABLE void setDepthHoldMode();
    Q_INVOKABLE void executeRoute(bool action = true);
    Q_INVOKABLE void goHome(bool action = true);
    Q_INVOKABLE void clearTrack();

    void setState(int state);
    void setRunState(int state);

    void joystickStart();

    uint16_t getChannel1Value() const;

    void setChannel1Value(uint16_t newChannel1Value);

    uint16_t getChannel2Value() const;

    void setChannel2Value(uint16_t newChannel2Value);

    uint16_t getChannel3Value() const;

    void setChannel3Value(uint16_t newChannel3Value);

    uint16_t getChannel4Value() const;

    void setChannel4Value(uint16_t newChannel4Value);

    uint16_t getChannel5Value() const;

    void setChannel5Value(uint16_t newChannel5Value);

    uint16_t getChannel6Value() const;

    void setChannel6Value(uint16_t newChannel6Value);

    uint16_t getChannel7Value() const;

    void setChannel7Value(uint16_t newChannel7Value);

    uint16_t getChannel8Value() const;

    void setChannel8Value(uint16_t newChannel8Value);

    void handleHeartbeat(const mavlink_message_t &message);

    void stopRun();

signals:

    void sig_sendData(mavlink_message_t &msg);

    void headingChanged();

    void isConnectChanged();

    void coordinateChanged();

    void homeCoordinateChanged();

    void rollAngleChanged();

    void pitchAngleChanged();

    void yawAngleChanged();

    void depthChanged();

    void trackChanged(int action = 0);

    void planChanged();

    void lockStateChanged();

    void runModeChanged();

    void isExecutePlanChanged();

    void isGoHomeChanged();

    void currentStateTextChanged();
    void systemModeTextChanged();
    void gearTextChanged();
    void batteryChanged();

    void channel1ValueChanged();

    void channel2ValueChanged();

    void channel3ValueChanged();

    void channel4ValueChanged();

    void channel5ValueChanged();

    void channel6ValueChanged();

    void channel7ValueChanged();

    void channel8ValueChanged();


public slots:

    void onMessageReceived(const QByteArray msg);
    void onSblMessageReceived(const QByteArray msg);

private:
    float _heading;
    float _yawSpeed;
    bool _isConnect{false};
    int _connectFlag{0};
    double rollAngle;
    double pitchAngle;
    double yawAngle;
    double depth;
    bool _lockState{true};
    int _runMode{0};
    bool _isExecutePlan{false};
    bool _isGoHome{false};
    QGeoCoordinate _coordinate;
    QGeoCoordinate _homeCoordinate;
    QVariantList _track;
    QString _currentStateText;
    QString _systemModeText{"manual"};
    QString _gearText{"1"};
    int _battery{0};

    uint16_t channel1Value = 1500;
    uint16_t channel2Value = 1500;
    uint16_t channel3Value = 1500;
    uint16_t channel4Value = 1500;
    uint16_t channel5Value = 1500;
    uint16_t channel6Value = 1500;
    uint16_t channel7Value = 1500;
    uint16_t channel8Value = 1500;

    uint16_t positivePwm = 1600;
    uint16_t negativePwm = 1400;
    uint16_t CH = 1500;

    uint16_t maxPwm = 1900;
    uint16_t minPwm = 1100;

    QGamepad *joyStick;

    //sbl解析数据使用变量
    QByteArray _recvData;

    double beaconLongitude;
    double beaconLatitude;

    GCMapPolyline *_plan{nullptr};

    RovPidControl *_pwmPidControl = new RovPidControl(0.5, 0.1, 0.1);
    RovPidControl *_headingPidControl = new RovPidControl(0.5, 0.1, 0.1);

    QTimer *_planTimer;
    QTimer *_homeTimer;


};

#endif // ROVVEHICLE_H
