//
// Created by Wang on 2022/11/23.
//

#pragma once


#include <map>
#include <fstream>
#include <json.hpp>
#include <bitset>

#include "GCToolbox.h"
#include "log.hpp"
#include "JsonStruct.hpp"
#include "winGetMac.h"

using namespace std;
using json = nlohmann::json;

//using namespace strns;

class SettingManager : public GCTool {
Q_OBJECT
public:
    SettingManager(Application *app, GCToolbox *toolbox);

    bool init();

    void setToolbox(GCToolbox *toolbox);
    ns::_s_init_config initConfig() { return _init_config; }

    Q_PROPERTY(double       lng                             READ lng                            WRITE setLng                            NOTIFY lngChanged)
    Q_PROPERTY(double       lat                             READ lat                            WRITE setLat                            NOTIFY latChanged)
    Q_PROPERTY(int          zoom                            READ zoom                           WRITE setZoom                           NOTIFY zoomChanged)
    Q_PROPERTY(int          maxZoom                         READ maxZoom                        WRITE setMaxZoom                        NOTIFY maxZoomChanged)
    Q_PROPERTY(QString      source                          READ source                         WRITE setSource                         NOTIFY sourceChanged)
    Q_PROPERTY(int          mapType                         READ mapType                        WRITE setMapType                        NOTIFY mapTypeChanged)
    Q_PROPERTY(QString      sblIp                           READ sblIp                          WRITE setSblIp                          NOTIFY sblConfigChanged)
    Q_PROPERTY(int          sblPort                         READ sblPort                        WRITE setSblPort                        NOTIFY sblConfigChanged)

    double                  lng                             () const                            { return _init_config.mapSetting.lng; }
    void                    setLng                          (double lng);
    double                  lat                             () const                            { return _init_config.mapSetting.lat; }
    void                    setLat                          (double lat);
    int                     zoom                            () const                            { return _init_config.mapSetting.zoom; }
    void                    setZoom                         (int zoom);
    int                     maxZoom                         () const                            { return _init_config.mapSetting.maxZoom; }
    void                    setMaxZoom                      (int maxZoom);
    QString                 source                          () const                            { return QString::fromStdString(_init_config.mapSetting.source); }
    void                    setSource                       (const QString &source);
    int                     mapType                         () const                            { return _init_config.mapSetting.mapType; }
    void                    setMapType                      (int mapType);
    QString                 sblIp                           () const                            { return QString::fromStdString(_init_config.sbl.ip); }
    void                    setSblIp                        (const QString &sblIp);
    int                     sblPort                         () const                            { return _init_config.sbl.port; }
    void                    setSblPort                      (int sblPort);

    Q_INVOKABLE void        saveConfig                      ();
    Q_INVOKABLE void        saveSblConfig                   ();

signals:
    void                    lngChanged                      ();
    void                    latChanged                      ();
    void                    zoomChanged                     ();
    void                    maxZoomChanged                  ();
    void                    sourceChanged                   ();
    void                    mapTypeChanged                  ();
    void                    sblConfigChanged                ();


private:
    std::string _name;
    const std::string _filename = "config.json";
    ns::_s_init_config  _init_config;
};
