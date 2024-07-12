#ifndef GROUNDCONTROLQMLGLOBAL_H
#define GROUNDCONTROLQMLGLOBAL_H
#include "GCToolbox.h"
#include "Application.h"

#include <QtPositioning/QGeoCoordinate>


class GCToolbox;
class LinkManager;
class SettingManager;

class GroundControlQmlGlobal : public GCTool
{
Q_OBJECT

public:
    GroundControlQmlGlobal(Application* app, GCToolbox* toolbox);
    ~GroundControlQmlGlobal();

    Q_PROPERTY(QString              appName                 READ    appName                 CONSTANT)
    Q_PROPERTY(LinkManager*         linkManager             READ    linkManager             CONSTANT)
    Q_PROPERTY(SettingManager*      settingManager          READ    settingManager          CONSTANT)
    Q_PROPERTY(MultiVehicleManager* multiVehicleManager     READ    multiVehicleManager     CONSTANT)

    QString                 appName             ()  { return gcApp()->applicationName(); }
    LinkManager*            linkManager         ()  { return _linkManager; }
    SettingManager*         settingManager      ()  { return _settingManager; }
    MultiVehicleManager*    multiVehicleManager ()  { return _multiVehicleManager; }

    // Overrides from GCTool
    virtual void setToolbox(GCToolbox* toolbox);

private:
    LinkManager*            _linkManager            = nullptr;
    SettingManager*         _settingManager         = nullptr;
    MultiVehicleManager     *_multiVehicleManager   = nullptr;


};

#endif // GROUNDCONTROLQMLGLOBAL_H
