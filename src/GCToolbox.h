//
// Created by Wang on 2022/10/10.
//

#pragma once

#include <QObject>

#include "Application.h"
#include "iostream"
#include "log.hpp"

class SettingManager;
class LinkManager;
class MultiVehicleManager;


class GCToolbox : public QObject {
Q_OBJECT

public:
    GCToolbox(Application *app);
    ~GCToolbox() override;

    SettingManager          *settingManager             ()          { return _settingManager; }
    LinkManager             *linkManager                ()          { return _linkManager; }
    MultiVehicleManager     *multiVehicleManager        ()          { return _multiVehicleManager; }


private:
    SettingManager          *_settingManager = nullptr;
    LinkManager             *_linkManager = nullptr;
    MultiVehicleManager     *_multiVehicleManager = nullptr;

private:
    void setChildToolboxes(void);

private:
    Application *_app = nullptr;

    friend class Application;
};

class GCTool : public QObject {
Q_OBJECT

public:
    GCTool(Application *app, GCToolbox *toolbox);

    virtual void setToolbox(GCToolbox *toolbox);

protected:
    Application *_app;
    GCToolbox *_toolbox;
};

