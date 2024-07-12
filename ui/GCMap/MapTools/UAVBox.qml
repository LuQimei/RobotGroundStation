import QtQuick 2.0
import QtPositioning 5.12
import QtLocation 5.12
import GroundControl 1.0

import CustomQml 1.0


MapItemGroup{
    id:uav_box

    property var type: "UAVIcon"
    property bool pointMove: false
    property var vehicle: null
    property var vehicleStateVisible: false

    property    var     myIcon:             vehicle.vehicleType === "djiMavic3Enterprise" ? "qrc:/ui/Images/vehicleIco/UAV.png" :
                                            (vehicle.vehicleType === "rov" ? "qrc:/ui/Images/vehicleIco/sub.png" :
                                            (vehicle.vehicleType === "usv" ? "qrc:/ui/Images/vehicleIco/Boat.svg" :
                                            (vehicle.vehicleType === "uuv" ? "qrc:/ui/Images/vehicleIco/uuv.png" :
                                            (vehicle.vehicleType === "carryUav" ? "qrc:/ui/Images/vehicleIco/CarryUav.png" :
                                            "qrc:/ui/Images/vehicleIco/team.png" ) ) ) )

//    property    var     myIcon: vehicle.vehicleType === "djiMavic3Enterprise" ? "qrc:/ui/Images/vehicleIco/UAV.png" : (vehicle.vehicleType === "rov" ? "qrc:/ui/Images/vehicleIco/sub.png" : (vehicle.vehicleType === "usv" ? "qrc:/ui/Images/vehicleIco/Boat.svg" : "qrc:/ui/Images/vehicleIco/UAV.png" ) )
//    property var image: vehiclevehicle.vehicleType === "djiMavic3Enterprise" ? "qrc:/ui/Images/vehicleIco/UAV.png" : (vehicle.vehicleType === "rov" ? "qrc:/ui/Images/vehicleIco/sub.png" : (vehicle.vehicleType === "usv" ? "qrc:/ui/Images/vehicleIco/Boat.svg" : "qrc:/ui/Images/vehicleIco/UAV.png" ))

    width: 40
    height: 40

    function resetImage(){
        uav_Icon.image_source = myIcon
    }

    visible: vehicle != null ? vehicle.isConnect : false

    MapQuickItem{
        sourceItem: Rectangle{
            MyIcon{
                id:uav_Icon
                myName: vehicle.vehicleName
                image_source: myIcon
                width: 40
                height: 40
                showText: true
                rotation: vehicle.vehicleYaw
                MapVehicleDatas{
                    anchors{
                        bottom: parent.top
                        left: parent.right
                        topMargin: 0
                        rightMargin:0
                    }
                    visible: vehicleStateVisible
                    vehicleData: uav_box.vehicle
                }
//                VehicleDatas{
//                    anchors{
//                        bottom: parent.top
//                        left: parent.right
//                        topMargin: 0
//                        rightMargin:0
//                    }
//                    visible: vehicleStateVisible
//                    width:300
//                    height:200
//                    vehicle: uav_box.vehicle
//                    vehicleNameVisible: false
//                }

            }
        }
        coordinate : vehicle.coordinate
//        coordinate : vehicle.coordinate.latitude != 0 && vehicle.coordinate.longitude != 0 ? vehicle.coordinate : undefined               /*QtPositioning.coordinate(39.658305255376675, 116.100772)//*/
    }

    MapPolyline {
        id: item_line
        opacity: 0.7
        line.color: "yellow"
        line.width: 3
        path: vehicle.track
    }

}
