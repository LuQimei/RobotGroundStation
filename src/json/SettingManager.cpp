//
// Created by 29450 on 2023/4/24.
//

#include "SettingManager.h"
#include "LinkManager.h"
#include "TimeHelp.h"

SettingManager::SettingManager(Application *app, GCToolbox *toolbox)
        : GCTool(app, toolbox), _name("SettingManager") {
}

void SettingManager::setToolbox(GCToolbox *toolbox) {
    GCTool::setToolbox(toolbox);
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<SettingManager>("GroundControl.SettingManager", 1, 0,
                                               "SettingManager",
                                               "Reference only");
}

bool SettingManager::init() {
    auto settingManager = _app->toolbox()->settingManager();


    //更新mac地址
    std::string mac;
    GetMacByGetAdaptersInfo(mac);
    try {
        // 读取配置文件
        std::ifstream f(_filename);
        if (!f.is_open()) {
            LOGE("The configuration file (config.json) does not exist,The system will create a default configuration file. Check the parameters in the default configuration file.");
            return false;
        }

        json temp = json::parse(f);
        temp.get_to(_init_config);
        LOGI("The configuration file (config.json) is read successfully.\n{}", nlohmann::json(_init_config).dump());

    } catch (const std::exception &e) {
        LOGE("An exception occurred while parsing the configuration file (config.json) -> {}", e.what());
        return false;
    }
    return true;
}

void SettingManager::setLng(double lng) {
    _init_config.mapSetting.lng = lng;
}

void SettingManager::setLat(double lat) {
    _init_config.mapSetting.lat = lat;
}

void SettingManager::setZoom(int zoom) {
    _init_config.mapSetting.zoom = zoom;
}

void SettingManager::setMaxZoom(int maxZoom) {
    _init_config.mapSetting.maxZoom = maxZoom;
    emit maxZoomChanged();
}

void SettingManager::setSource(const QString &source) {
    _init_config.mapSetting.source = source.toStdString();
    emit sourceChanged();
}

void SettingManager::setMapType(int mapType) {
    _init_config.mapSetting.mapType = mapType;
    emit mapTypeChanged();
}

void SettingManager::saveConfig() {
    std::ofstream o(_filename);
    o.clear();
    o << std::setw(4) << json(_init_config) << std::endl;
    o.close();
    LOGI("The configuration file has been updated.");
}

void SettingManager::setSblIp(const QString &sblIp) {
    _init_config.sbl.ip = sblIp.toStdString();
}

void SettingManager::setSblPort(int sblPort) {
    _init_config.sbl.port = sblPort;
}

void SettingManager::saveSblConfig() {
    saveConfig();
    auto linkManager = _app->toolbox()->linkManager();
    linkManager->reConnectSblTcpClient(QString::fromStdString(_init_config.sbl.ip), _init_config.sbl.port);
}


