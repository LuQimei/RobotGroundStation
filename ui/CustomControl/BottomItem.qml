import QtQuick 2.9
import QtQuick.Layouts 1.15

import GroundControl 1.0

Rectangle {
    id: bottomItem
    color: "#2b2d30"
    border.color: "#000000"
    border.width: 1

    DeadMouseArea{ anchors.fill: parent }

    RowLayout{
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10
        Text{
            id: stateTitle
            Layout.fillHeight: true
            color: "#ffffff"
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLight
            width: 50

            text: "状态: "
        }
        Text{
            Layout.fillHeight: true
            color: "#ffffff"
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLight

            text: GroundControl.multiVehicleManager.rovVehicle.currentStateText
        }
    }


    RowLayout{
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width/3
        Text{
            id: speedTitle
            Layout.fillHeight: true
            color: "#ffffff"
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLight
            width: 50

            text: "挡位: "
        }
        Text{
            color: "#ffffff"
            Layout.fillHeight: true
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLight

            text: GroundControl.multiVehicleManager.rovVehicle.gearText + "档"
        }
    }

    RowLayout{
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: parent.width/3
        Text{
            id: modelTitle
            Layout.fillHeight: true
            color: "#ffffff"
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLight
            width: 50

            text: "模式: "
        }
        Text{
            color: "#ffffff"
            Layout.fillHeight: true
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLight

            text: GroundControl.multiVehicleManager.rovVehicle.systemModeText
        }
    }

    RowLayout{
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        Text{
            id: trackTitle
            Layout.fillHeight: true
            color: "#ffffff"
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLight
            width: 50

            text: "轨迹: "
        }

        /*******************************模式*******************************/
        TransparentComboBox{
            id: trackComboBox
            Layout.minimumWidth: 90
            Layout.fillHeight: true
            width: 90
            z: parent.z+1
            model: ["显示","隐藏","清理"]
            fontSize: 20
            _angleDir: true
            onCurrentIndexChanged: {
                switch(currentIndex){
                case 0:
                    GroundControl.multiVehicleManager.isTrackShow = true
                    break;
                case 1:
                    GroundControl.multiVehicleManager.isTrackShow = false
                    break;
                case 2:
                    GroundControl.multiVehicleManager.rovVehicle.clearTrack()
                    currentIndex = 0
                    break;
                }
            }
        }
    }
}
