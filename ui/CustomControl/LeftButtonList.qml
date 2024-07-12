import QtQuick 2.3
import QtQuick.Layouts 1.15

import GroundControl 1.0

Rectangle {
    id: root
    radius: width/15
    color: "#222222"
    property var fontSize: 16

    ColumnLayout{
        id: leftButtonLayout
        anchors.fill:parent
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        spacing: 5
        //航线规划组件
        Rectangle{
            id: planRec

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: root.width - 10
            Layout.preferredHeight: root.width - 10

            color: GroundControl.multiVehicleManager.isDrawingPlan ? "#fff291" : planButton.containsMouse ? "#585d83" : "transparent"
            radius: 3

            Image {
                id: planImage
                source: !GroundControl.multiVehicleManager.isDrawingPlan ? "qrc:/ui/Images/LGC/plan.svg" : "qrc:/ui/Images/LGC/plan_black.svg"
                anchors{
                    fill:parent
                    bottomMargin: 20
                    leftMargin: 10
                    rightMargin: 10
                }
            }
            Text {
                id: planName
                text: qsTr("航线")
                anchors.top: planImage.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: !GroundControl.multiVehicleManager.isDrawingPlan ? "#ffffff" : "#000000"
                font.pixelSize: fontSize
            }

            MouseArea{
                id: planButton
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    GroundControl.multiVehicleManager.isDrawingPlan = !GroundControl.multiVehicleManager.isDrawingPlan
                }
            }
        }

        //航线清楚组件
        Rectangle{
            id: clearRec

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: root.width - 10
            Layout.preferredHeight: root.width - 10

            color: clearButton.containsPress ? "#fff291" : clearButton.containsMouse ? "#585d83" : "transparent"
            radius: 3

            Image {
                id: clearImage
                source: "qrc:/ui/Images/LGC/clear.svg"
                anchors{
                    fill:parent
                    bottomMargin: 20
                    leftMargin: 10
                    rightMargin: 10
                }
            }
            Text {
                id: clearName
                text: qsTr("清除")
                anchors.top: clearImage.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                font.pixelSize: fontSize
            }

            MouseArea{
                id: clearButton
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    GroundControl.multiVehicleManager.clearPlan()
                }
            }
        }

        //take off 组件
        Rectangle{
            id: takeoffRec

            Layout.alignment: Qt.AlignCenter

            Layout.preferredWidth: root.width - 10
            Layout.preferredHeight: root.width - 10

            color: GroundControl.multiVehicleManager.rovVehicle.isExecutePlan ? "#fff291" : takeoffButton.containsMouse ? "#585d83" : "transparent"
            radius: 3

            Image {
                id: takeoffImage
                source:GroundControl.multiVehicleManager.rovVehicle.isExecutePlan ? "qrc:/ui/Images/LGC/takeoff_black.svg" : "qrc:/ui/Images/LGC/takeOff.svg"
                anchors{
                    fill:parent
                    bottomMargin: 20
                    leftMargin: 10
                    rightMargin: 10
                }
            }
            Text {
                id: takeoffName
                text: GroundControl.multiVehicleManager.rovVehicle.isExecutePlan ? qsTr("暂停") : qsTr("起飞")
                anchors.top: takeoffImage.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:GroundControl.multiVehicleManager.rovVehicle.isExecutePlan ? "#000000" : "#ffffff"
                font.pixelSize: fontSize
            }

            MouseArea{
                id: takeoffButton
                anchors.fill: parent
                hoverEnabled: true
                enabled: !GroundControl.multiVehicleManager.rovVehicle.isGoHome
                onClicked: {
                    GroundControl.multiVehicleManager.rovVehicle.executeRoute(!GroundControl.multiVehicleManager.rovVehicle.isExecutePlan)
                }
            }
        }


        //返航组件
        Rectangle{
            id: gohomeRec

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: root.width - 10
            Layout.preferredHeight: root.width - 10

            color: GroundControl.multiVehicleManager.rovVehicle.isGoHome ? "#fff291" : gohomeButton.containsMouse ? "#585d83" : "transparent"
            radius: 3

            Image {
                id: gohomeImage
                source: GroundControl.multiVehicleManager.rovVehicle.isGoHome ? "qrc:/ui/Images/LGC/gohome_black.svg" : "qrc:/ui/Images/LGC/gohome.svg"
                anchors{
                    fill:parent
                    bottomMargin: 20
                    leftMargin: 10
                    rightMargin: 10
                }
            }
            Text {
                id: gohomeName
                text:GroundControl.multiVehicleManager.rovVehicle.isGoHome ? qsTr("暂停") :  qsTr("返航")
                anchors.top: gohomeImage.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: GroundControl.multiVehicleManager.rovVehicle.isGoHome ? "#000000" : "#ffffff"
                font.pixelSize: fontSize
            }

            MouseArea{
                id: gohomeButton
                anchors.fill: parent
                hoverEnabled: true
                enabled: !GroundControl.multiVehicleManager.rovVehicle.isExecutePlan

                onClicked: {
                    GroundControl.multiVehicleManager.rovVehicle.goHome(!GroundControl.multiVehicleManager.rovVehicle.isGoHome)
                }
            }
        }
    }

}
