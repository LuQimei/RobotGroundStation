//
// Created by Wang on 2022/10/10.
//
//

#include <QFile>
#include <QRegularExpression>
#include <QFontDatabase>
#include <QQuickWindow>
#include <QQuickImageProvider>
#include <QQuickStyle>

#include "Application.h"
#include "GCToolbox.h"
#include "GroundControlQmlGlobal.h"
#include "QmlObjectListModel.h"
#include "LinkManager.h"
#include "SettingManager.h"
#include "MultiVehicleManager.h"
#include "ffmpeg/ffmpeg.h"
#include "opencv/CVThread.h"

Application *Application::_app = nullptr;

static QObject *groundcontrolQmlGlobalSingletonFactory(QQmlEngine *, QJSEngine *) {
    // We create this object as a QGCTool even though it isn't in the toolbox
    GroundControlQmlGlobal *qmlGlobal = new GroundControlQmlGlobal(gcApp(), gcApp()->toolbox());
    qmlGlobal->setToolbox(gcApp()->toolbox());

    return qmlGlobal;
}

Application::Application(int &argc, char *argv[], bool unitTesting)
        : QApplication(argc, argv), _runningUnitTests(unitTesting) {
    _app = this;
    _toolbox = new GCToolbox(this);
    _toolbox->setChildToolboxes();
}

static const char *kVehicle = "GroundControl.Vehicle";
static const char *kRefOnly = "Reference only";

void Application::_initCommon() {
    //注册元类型
    qRegisterMetaType<std::string>("std::string");

    qmlRegisterType<FFmpegWidget>("FFmpegWidget", 1, 0, "FFmpegWidget");
    qmlRegisterType<OpencvWidget>("OpencvWidget", 1, 0, "OpencvWidget");

    //注册相关类
    qmlRegisterUncreatableType<QmlObjectListModel>  ("GroundControl", 1, 0, "QmlObjectListModel", kRefOnly);

    //注册全局单例
    qmlRegisterSingletonType<GroundControlQmlGlobal>("GroundControl", 1, 0, "GroundControl",
                                                     groundcontrolQmlGlobalSingletonFactory);

    //初始化各个模块
    assert(_toolbox->_settingManager->init());
    _toolbox->linkManager()->init();
    _toolbox->multiVehicleManager()->init();
    LOGD("Application::_initCommon() end.");
}

bool Application::_initForNormalAppBoot() {
    _qmlAppEngine = createQmlApplicationEngine();
    createRootWindow(_qmlAppEngine);
    return true;
}

void Application::_shutdown() {
    delete _qmlAppEngine;
    delete _toolbox;
}


GCToolbox *Application::toolbox(void) { return _toolbox; }

QQmlApplicationEngine *Application::createQmlApplicationEngine() {
    QQmlApplicationEngine * qmlEngine = new QQmlApplicationEngine(this);

    qmlEngine->addImportPath("qrc:/qml");
    LOGD("Application::createQmlApplicationEngine() end.");
    return qmlEngine;
}

void Application::createRootWindow(QQmlApplicationEngine *qmlEngine) {
    LOGD("Application::createRootWindow() start.");
    qmlEngine->load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    LOGD("Application::createRootWindow() end.");

}

QQmlApplicationEngine *Application::qmlAppEngine() { return _qmlAppEngine; }

Application *gcApp(void) {
    return Application::_app;
}
