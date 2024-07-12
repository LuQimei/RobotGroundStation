import QtQuick 2.0
import QtQuick.Layouts 1.14
import QtQuick.Controls 1.4

import GroundControl 1.0

Item {
    id: _root
    property var fontColor: "#ffffff"
    property var parentWindow: mainWindow
    property var vehicle: null
    property alias backGroundColor: _telemetryValueItem.color
    property alias backGroundVisible: _telemetryValueItem.visible


    property var titleStize:vehicle?GroundControl.multiVehicleManager.activeVehicle ==vehicle?17:16:16
//    property var defaultTitiles: ["经度","纬度","深度","航向","模式"]
    property var titles: ["经度","纬度","深度","航向","俯仰","横滚","状态","模式"]

    property var vehicleData: [vehicle.coordinate.longitude, vehicle.coordinate.latitude, vehicle.depth, vehicle.yawAngle,
        vehicle.pitchAngle, vehicle.rollAngle, vehicle.currentStateText, vehicle.runMode]

    function getVehicleData(_index){
        if(!vehicle){
            return "-.-";
        }
        if(_index == 7){
            switch(vehicleData[_index]){
            case 0:
                return "手动";
            case 1:
                return "定深";
            case 2:
                return "定航";
            }
        }else{
            return vehicleData[_index]
        }
    }



    Rectangle{
        id:_telemetryValueItem
        anchors{
            fill: parent
        }
        color: "#222222"
        clip: true
        opacity: 0.5
    }
    GridLayout{
        columns: 2
        anchors{
            fill: parent
            leftMargin:15*parentWindow.width/parentWindow.defaultWidth
            rightMargin:15*parentWindow.width/parentWindow.defaultWidth
            topMargin: 15*parentWindow.height/parentWindow.defaultHeight
            bottomMargin: 15*parentWindow.height/parentWindow.defaultHeight
        }
        columnSpacing:  40*parentWindow.height/parentWindow.defaultHeight
        Repeater{
            model:titles
            RowLayout{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Label {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    horizontalAlignment:  Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: titles[index]
                    Layout.alignment:Qt.AlignLeft
                    color: fontColor
                }
                Label {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    horizontalAlignment:   Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: getVehicleData(index)
                    Layout.alignment:Qt.AlignRight
                    color: fontColor
                }
            }
        }
    }
}
