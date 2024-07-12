//
// Created by Wang on 2022/10/12.
//

#include "LinkManager.h"

#include <future>
#include "SettingManager.h"



LinkManager::LinkManager(Application *app, GCToolbox *toolbox)
        : GCTool(app, toolbox) {
    qmlRegisterUncreatableType<LinkManager>("GroundControl", 1, 0, "LinkManager", "Reference only");

}

void LinkManager::init() {
    auto settingManager = _toolbox->settingManager();
    udpLink = new UdpLink(QHostAddress("192.168.2.1"),14550);
//    _sblTcpClient = new TcpClientLink("47.104.21.115", 5104);
//    _sblTcpClient = new TcpClientLink(QString::fromStdString(settingManager->initConfig().sbl.ip) , settingManager->initConfig().sbl.port);
    _sblTcpClient = new TcpClientLink("192.168.3.107",88888);
//    _uav = new TcpClientLink("192.168.1.19",8010);
}

void LinkManager::setToolbox(GCToolbox *toolbox) {
    GCTool::setToolbox(toolbox);

    LOGD("TaskManager::setToolbox");
    qmlRegisterUncreatableType<LinkManager>("GroundControl.LinkManager", 1, 0,
                                            "LinkManager",
                                            "Reference only");

}

std::shared_ptr<LinkInterface> LinkManager::getLink() {
    return link;
}

void LinkManager::onMessageReceived(const QByteArray msg, const QString &topic)
{
    auto payload = msg.data();
    auto json = std::make_shared<nlohmann::json>();
    try {
        *json = nlohmann::json::parse(payload);
    } catch (std::exception &e) {
        LOGE("json parse error:{}", e.what());
        return;
    }

}

UdpLink *LinkManager::getUdpLink() const
{
    return udpLink;
}

TcpClientLink *LinkManager::sblTcpClient() const {
    return _sblTcpClient;
}

void LinkManager::reConnectSblTcpClient(QString ip, int port) {
    _sblTcpClient = nullptr;
    _sblTcpClient = new TcpClientLink(ip, port);
}
