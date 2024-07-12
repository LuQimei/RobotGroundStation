import QtQuick 2.15
import QtQuick.Controls 2.0
import QtPositioning 5.12
import QtLocation 5.12
import QtQuick.Layouts 1.0
import GroundControl 1.0

import CustomControl 1.0

MapItemGroup {
    id: mapvehicle
    property var vehicle

    property bool vehicleStateVisible : false
    property var myIcon: "qrc:/ui/Images/LGC/sub.png"


    visible: vehicle.isConnect
    /***********************************实体**********************************/
    MapQuickItem{
        id:myvehicle
        coordinate: vehicle.coordinate// QtPositioning.coordinate(38.865155,
                                        //     121.550995) //
        sourceItem: Image{
            id: icon
            width: 48
            height: width
            x: -width/2
            y: -width/2
            source: myIcon
            transform: Rotation { origin.x: myvehicle.width/2; origin.y: myvehicle.height/2; angle: vehicle.yawAngle}



            /***********************************名称**********************************/



            MouseArea{
                anchors.fill: parent
                onClicked: {
                    vehicleStateVisible = !vehicleStateVisible
                }
                onDoubleClicked: {
                    GroundControl.vehicleManager.activevehicle = vehicle
                }
            }
        }
    }


    /***********************************状态**********************************/
    MapQuickItem{
        coordinate: vehicle.coordinate
        sourceItem: VehicleDatas{
            anchors{
                bottom: mapvehicle.top
                left: mapvehicle.right
                topMargin: 20
                rightMargin:20
            }
            width: 420
            height: 200
            visible: vehicleStateVisible == true
            vehicle: mapvehicle.vehicle
        }
    }


    property var vehicles: []
    property var vehicleColors: []

    //根据不同实体以及红蓝方获取不同偏蓝偏红颜色
    function getColorByVehicle(vehicle,forceId){
        if(vehicles.indexOf(vehicle) == -1){
            vehicles.push(vehicle)
            if(forceId == 2){
                var red2 = Math.floor(Math.random() * 128);
                var green2 = Math.floor(Math.random() * 128);
                var blue2 = Math.floor(Math.random() * 128) + 128;
                vehicleColors.push(Qt.rgba(red2 / 255, green2 / 255, blue2 / 255, 1))
            }else{
                var red = Math.floor(Math.random() * 128) + 128;
                var green = Math.floor(Math.random() * 128);
                var blue = Math.floor(Math.random() * 128);
                vehicleColors.push(Qt.rgba(red / 255, green / 255, blue / 255, 1))
            }
        }
        return vehicleColors[vehicles.indexOf(vehicle)]
    }


    /**********************************轨迹**********************************/
    MapPolyline {
        id: item_line
        opacity: 0.7
        line.color: getColorByVehicle(mapvehicle.vehicle, 1)
        line.width: 3
        visible: GroundControl.multiVehicleManager.isTrackShow
        Connections{
            target: vehicle
            function onTrackChanged(action)
            {
                switch(action){
                case 0:
                    item_line.addCoordinate(vehicle.coordinate)
                    break;
                case 1:
                    item_line.setPath(undefined)
                    break;
                }
//                switch(GroundControl.vehicleManager.trajectoryStep){
//                case 0:
//                    break;
//                default:
//                    if(item_line.pathLength() > GroundControl.vehicleManager.trajectoryStep*1000/60.0){
//                        item_line.removeCoordinate(item_line.path[0])
//                    }
//                    break;
//                }
            }
        }
    }



}
