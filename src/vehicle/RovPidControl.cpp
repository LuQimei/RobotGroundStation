//
// Created by w on 2024/3/18.
//

#include "RovPidControl.h"
#include "log.hpp"

#define M_PI       3.14159265358979323846

RovPidControl::RovPidControl(float kp, float ki, float kd, QObject *parent)
        : QObject{parent}
{
    Kp = kp;
    Ki = ki;
    Kd = kd;
    prevError = 0;
    integral = 0;
}

double RovPidControl::pidPosition(double value, double target)
{
    double error = value - target;
    double RovPidControlOutput;
    integral += error;
    double derivative = error - prevError;
    RovPidControlOutput = Kp * error + Kd * derivative + Ki * integral;
    prevError = error;
    return RovPidControlOutput;
}

double RovPidControl::pwmPid(double value, double distance_threshold) {
    static double pre_e = 0;
//    double e = fabs(0 - value);
    double e = value;

    uint16_t u = e * 1550 + (e - pre_e) * 400;

    if (u < 1500){u = 1500;}
    else if(u > 1900){u=1900;}
    if (e < distance_threshold) {u = 1500;}
    else {pre_e = e;}

    return u;
}


int RovPidControl::headingPid(double value, double target, double bearing_threshold, double _yaw, double _yawSpeed){
    static double pre_e = 0;

    double _error_deg = (value - target);
    if (_error_deg > 180){_error_deg -= 360;}
    else if (_error_deg < -180){_error_deg+= 360;}
    double error = sawtooth(_yaw -deg2rad(target));
    LOGD("===============================================> _yawSpeed : {}, (error - pre_e) :{}",_yawSpeed, (error - pre_e));
    if (fabs(_error_deg) >= bearing_threshold){
        uint16_t u = 280*error + 317*(error - pre_e);
        uint16_t PMAX = 1900;
        uint16_t PMIN = 1100;
        uint16_t U = 1500-u;

        if (U > PMAX){
            U = PMAX;
        }
        else if (U<PMIN){
            U = PMIN;
        }
        return U;
    }
    else if (fabs(_error_deg) < bearing_threshold){
        return 0;
    }else{
        pre_e = error;
    }
    return 0;
}


//角度转弧度
double RovPidControl::deg2rad(int course)
{
    if (course>=0 && course<=180){
        return (course*M_PI)/180;
    }
    if (course>180 && course<=360){
        return ((course-360)*M_PI)/180;
    }
}

//-pi-pi转换为0-2pi
double RovPidControl::sawtooth(double rad)
{
    return std::fmod(rad + M_PI, 2 * M_PI) - M_PI;
}