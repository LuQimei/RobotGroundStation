#include "GroundControlQmlGlobal.h"
#include "LinkManager.h"

#include <QLineF>


GroundControlQmlGlobal::GroundControlQmlGlobal(Application *app, GCToolbox *toolbox)
        : GCTool(app, toolbox) {
    // We clear the parent on this object since we run into shutdown problems caused by hybrid qml app. Instead we let it leak on shutdown.
    setParent(nullptr);

}

GroundControlQmlGlobal::~GroundControlQmlGlobal() {
}

void GroundControlQmlGlobal::setToolbox(GCToolbox *toolbox) {
    GCTool::setToolbox(toolbox);

    _linkManager = toolbox->linkManager();
    _settingManager = toolbox->settingManager();
    _multiVehicleManager = toolbox->multiVehicleManager();
}
