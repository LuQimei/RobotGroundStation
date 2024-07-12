//
// Created by Wang on 2022/10/10.
//

#pragma once

#include <QApplication>
#include <QQmlApplicationEngine>

#include "QGeoCoordinate.h"
#include "log.hpp"

//全局变量定义
#define     appInstance              Application::getAppInstance()

class GCToolbox;

class Application : public QApplication {
Q_OBJECT
public:
    Application(int &argc, char *argv[], bool unitTesting);

    GCToolbox *toolbox(void);

    static Application *getAppInstance(){
        return _app;
    }

    void _initCommon();

    bool _initForNormalAppBoot();

    void _shutdown();

    QQmlApplicationEngine *qmlAppEngine();

private:
    QQmlApplicationEngine *createQmlApplicationEngine();

    void createRootWindow(QQmlApplicationEngine *qmlEngine);

private:
    GCToolbox *_toolbox = nullptr;
    QQmlApplicationEngine *_qmlAppEngine = nullptr;
public:
    static Application *_app;
    bool _runningUnitTests{};
};

Application *gcApp(void);