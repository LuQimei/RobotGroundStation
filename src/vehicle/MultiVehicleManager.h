#ifndef MULTIVEHICLEMANAGER_H
#define MULTIVEHICLEMANAGER_H

//
// Created by Wang on 2022/10/8.
//

#pragma once

#include "GCToolbox.h"

#include <utility>

#include "QmlObjectListModel.h"
#include "LinkManager.h"
#include "GCMapPolyline.h"

class RovVehicle;


class MultiVehicleManager : public GCTool {
    Q_OBJECT

public:
    MultiVehicleManager(Application *app, GCToolbox *toolbox);

    void setToolbox(GCToolbox *toolbox);

    void init();

    //qml相关接口========================================================================
    Q_PROPERTY(RovVehicle           *rovVehicle         READ rovVehicle             WRITE setRovVehicle                 NOTIFY rovVehicleChanged)
    Q_PROPERTY(bool                 isDrawingPlan       READ isDrawingPlan          WRITE setIsDrawingPlan              NOTIFY isDrawingPlanChanged)
    Q_PROPERTY(GCMapPolyline        *plan               READ plan                   WRITE setPlan                       NOTIFY planChanged)
    Q_PROPERTY(bool                 isTrackShow         READ isTrackShow            WRITE setIsTrackShow                NOTIFY isTrackShowChanged)

    RovVehicle                      *rovVehicle         () const;
    void                            setRovVehicle       (RovVehicle *newRovVehicle);
    bool                            isDrawingPlan       () const                                                        { return _isDrawingPlan; }
    void                            setIsDrawingPlan    (bool isDrawingPlan);//                                            { _isDrawingPlan = isDrawingPlan; emit isDrawingPlanChanged();}
    GCMapPolyline                   *plan               ()                                                              { return _plan; }
    void                            setPlan             (GCMapPolyline *newPlan)                                        { _plan = newPlan; emit planChanged(); }
    bool                            isTrackShow         () const                                                        { return _isTrackShow; }
    void                            setIsTrackShow      (bool isTrackShow)                                              { _isTrackShow = isTrackShow; emit isTrackShowChanged(); }

    Q_INVOKABLE void                clearPlan();

signals:
    //接口相关========================================================================
    void rovVehicleChanged();
    void isDrawingPlanChanged();
    void planChanged();
    void isTrackShowChanged();


public slots:
    //数据解析========================================================================



private:
    std::string                 _name;
    QmlObjectListModel          _vehicles;
    QmlObjectListModel          _plans;
    LinkInterface               *_link;
    RovVehicle                  *_rovVehicle;
    GCMapPolyline               *_plan;
    bool                        _isDrawingPlan{false};
    bool                        _isTrackShow{true};
    //    MultiControlModel *_multiControlModel;



};





#endif // MULTIVEHICLEMANAGER_H
