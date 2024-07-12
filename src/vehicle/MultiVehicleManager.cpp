#include "MultiVehicleManager.h"
#include "SettingManager.h"

#include <qmath.h>
#include "RovVehicle.h"


MultiVehicleManager::MultiVehicleManager(Application *app, GCToolbox *toolbox)
    : GCTool(app, toolbox), _name("MultiVehicleManager") {

    //    _multiControlModel = new MultiControlModel(this);
}

void MultiVehicleManager::setToolbox(GCToolbox *toolbox) {
    GCTool::setToolbox(toolbox);

    //    LOGD("MultiVehicleManager::setToolbox");
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<MultiVehicleManager>("GroundControl", 1, 0,
                                                    "MultiVehicleManager",
                                                    "Reference only");


}

void MultiVehicleManager::init() {
//    auto settingManager = _app->toolbox()->settingManager();

    _plan = new GCMapPolyline(this);

    _rovVehicle = new RovVehicle(this);
    auto linkManager = _toolbox->linkManager();

    connect(linkManager->getUdpLink(), &UdpLink::sig_receiveData, _rovVehicle, &RovVehicle::onMessageReceived);
    connect(linkManager->sblTcpClient(), &TcpClientLink::sig_receiveData, _rovVehicle, &RovVehicle::onSblMessageReceived);
//    connect(_rovVehivle, &RovVehicle::sig_sendData, linkManager->getUdpLink(), &UdpLink::sendMavData);  //发送数据
    connect(_rovVehicle, &RovVehicle::sig_sendData, this,[=](mavlink_message_t &msg){
        linkManager->getUdpLink()->sendMavData(msg);    //发送数据
    });


}

RovVehicle *MultiVehicleManager::rovVehicle() const
{
    return _rovVehicle;
}

void MultiVehicleManager::setRovVehicle(RovVehicle *newRovVehicle)
{
    if (_rovVehicle == newRovVehicle)
        return;
    _rovVehicle = newRovVehicle;
    emit rovVehicleChanged();
}

void MultiVehicleManager::clearPlan() {
    _plan->clear();
    emit planChanged();
    _rovVehicle->setPlan(_plan);

}

void MultiVehicleManager::setIsDrawingPlan(bool isDrawingPlan) {
    _isDrawingPlan = isDrawingPlan;
    emit isDrawingPlanChanged();
    if(!isDrawingPlan){
        _rovVehicle->setPlan(_plan);
    }
}
