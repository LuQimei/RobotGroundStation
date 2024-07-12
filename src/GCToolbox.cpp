//
// Created by Wang on 2022/10/10.
//

#include "GCToolbox.h"
#include "Application.h"
#include "LinkManager.h"
#include "SettingManager.h"
#include "MultiVehicleManager.h"


GCToolbox::GCToolbox(Application *app) : _app(app) {
    _linkManager = new LinkManager(app, this);
    _settingManager = new SettingManager(app, this);
    _multiVehicleManager = new MultiVehicleManager(app, this);

}

GCToolbox::~GCToolbox() {
    delete _linkManager;
    delete _settingManager;
    delete _multiVehicleManager;

}

void GCToolbox::setChildToolboxes() {
    _linkManager->setToolbox(this);
    _settingManager->setToolbox(this);
    _multiVehicleManager->setToolbox(this);
}


GCTool::GCTool(Application *app, GCToolbox *toolbox)
        : _app(app), _toolbox(nullptr) {
}

void GCTool::setToolbox(GCToolbox *toolbox) {
    _toolbox = toolbox;

}

