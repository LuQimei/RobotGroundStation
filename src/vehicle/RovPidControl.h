//
// Created by w on 2024/3/18.
//

#ifndef ROBOTGROUNDCONTROL_ROVPIDCONTROL_H
#define ROBOTGROUNDCONTROL_ROVPIDCONTROL_H

#include <QObject>


class RovPidControl : public QObject{
Q_OBJECT
public:
    explicit RovPidControl(float kp, float ki, float kd,QObject *parent = nullptr);

//    double pidPosition(double error);
    double pidPosition(double value, double target);

    double pwmPid(double value, double distance_threshold);
    int headingPid(double value, double target, double bearing_threshold, double _yaw, double _yawSpeed);



signals:

private:
    /* data */
    double Kp{0}; // 比例系数
    double Ki{0}; // 积分系数
    double Kd{0}; // 微分系数
    double prevError; // 上一个误差
    double integral; // 积分项


    double deg2rad(int course);

    double sawtooth(double rad);
};


#endif //ROBOTGROUNDCONTROL_ROVPIDCONTROL_H
