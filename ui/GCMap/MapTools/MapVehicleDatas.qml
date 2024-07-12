import QtQuick 2.0
import QtQuick.Layouts 1.15
import CustomQml 1.0

Rectangle {
    property alias vehicleData: vehicleDatas.vehicle

    color: "#00000000"
    border.color: "#00dbd9"
    width:300
    height:200

    ColumnLayout{
        anchors.fill: parent

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: 20
            Text {
                id: text1
                text: qsTr("任务:")
                color: "#00dbd9"
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.left: parent.left
                anchors.leftMargin: 6
                font.pixelSize: 20
            }
            Text {
                text: qsTr("无任务")
                color: "#00dbd9"
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.left: text1.right
                anchors.leftMargin: 20
                font.pixelSize: 20
            }
        }

        VehicleDatas{
            id: vehicleDatas
            Layout.fillWidth: true
            Layout.fillHeight: true
            vehicleNameVisible: false
            backGroundVisible : false
        }
    }



    Rectangle{
        anchors{
            fill: parent
        }
        color: Qt.rgba(0,219,217, 0.1)
        clip: true
    }
}
