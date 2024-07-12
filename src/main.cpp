#include "tools/log/log.hpp"
#include "Application.h"
#include "TimeHelp.h"




int main(int argc, char *argv[]) {

    LOGI("====================!!! MAIN RUNNING !!!====================");
    LOGI("===================={}====================", getCurrentTimeFormat());
    int exitCode = 0;

//    QGeoCoordinate coor(38.0,
//                        121.0),bCoor;
//    bCoor = coor.atDistanceAndAzimuth(1000,45);
//    qDebug()<<bCoor;
//    MavlinkUdp *link = new MavlinkUdp(QHostAddress("127.0.0.1"),14550);

    Application *app = new Application(argc, argv, false);

    app->_initCommon();

    if (!app->_initForNormalAppBoot()) {
        return -1;
    }
    exitCode = app->exec();
    app->_shutdown();
    delete app;

    LOGI("====================!!!  MAIN  EXIT  !!!====================");
    return exitCode;
}
