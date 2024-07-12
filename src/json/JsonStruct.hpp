//
// Created by Wang on 2022/11/23.
//

#pragma once

#include "log.hpp"

#include "json.hpp"

#include "string"

#include <QString>

using namespace nlohmann;

namespace ns {

    /*************************************************地图设置*************************************************/
    struct s_mapSetting{
        double lng;
        double lat;
        int zoom;
        int maxZoom;
        std::string source;
        int mapType;
    public:
        NLOHMANN_DEFINE_TYPE_INTRUSIVE(s_mapSetting, lng, lat, zoom, maxZoom, source, mapType)
    };

    struct _s_sbl_init{
        std::string ip{"192.168.1.1"};
        int port{8000};
    public:
        NLOHMANN_DEFINE_TYPE_INTRUSIVE(_s_sbl_init,ip, port)
    };

    struct _s_init_config{
        _s_sbl_init sbl;
        s_mapSetting mapSetting;
    public:
        NLOHMANN_DEFINE_TYPE_INTRUSIVE(_s_init_config, sbl, mapSetting)
    };

}

