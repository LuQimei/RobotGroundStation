import QtQuick 2.0
import QtPositioning 5.12
import QtLocation 5.12
import GroundControl 1.0

MapQuickItem{
    id:root
    property var vehicle

    MapPolyline {
        id: item_line
        opacity: 0.7
        line.color: linrColor
        line.width: 7
        path: vehicle.track
//        onPathChanged: {
//            console.log("run path changed")
//        }
    }


//    property var myCoordinate
////    property var m_name: actieveVehicle.vehicleLinkManager.primaryLinkName
////    property var heading: actieveVehicle.heading.value
//    property var type: "UAVIcon"
//    property bool pointMove: false
//    property var actieveVehicle: null
////    property var image: actieveVehicle.vehicleType === "djiMavic3Enterprise" ? "qrc:/ui/Images/vehicleIco/UAV.png" : (actieveVehicle.vehicleType === "rov" ? "qrc:/ui/Images/vehicleIco/sub.png" : "qrc:/ui/Images/vehicleIco/UAV.png" )

//    width: 10
//    height: 10

////    function resetImage(){
////        uav_Icon.image_source = image
////    }

//    sourceItem: Rectangle{
//        width: 10
//        height: 10
//        color: "red"
////        MyIcon{
////            id:uav_Icon
////            width: 40
////            height: 40
////            myName: actieveVehicle.vehicleName
////            image_source: image
////            showText: true
////        }
//    }

//    coordinate : myCoordinate

}
