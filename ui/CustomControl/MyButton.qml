import QtQuick 2.3
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
//import RovVehicle 1.0
import GroundControl 1.0

Rectangle {
    id: frameRect
    width: parent.width
    height: 48
    color: "grey"
//    Row{
//        Layout.fillHeight: true
        Image {
//            Layout.fillHeight: true
//            anchors.left: parent.left
//            anchors.leftMargin: 2
            id: icon
            width: 48
            height: 48
            source: "qrc:/ui/Images/appIcon/app5.png"
            MouseArea{
                anchors.fill: parent

                onClicked: {
                    console.log("设置参数")
                }
            }
        }

        Text {
//            Layout.fillHeight: true
            id: status
            anchors.left: icon.right
            font.pixelSize: 24
            text: GroundControl.rovVehicle.isConnect ? "Ready to Fly" : "Disconnected"
//            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
            height: parent.height
        }
//    }
}
