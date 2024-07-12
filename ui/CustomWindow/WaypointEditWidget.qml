import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import CustomControl 1.0
import QtPositioning 5.12

import GroundControl 1.0

ListView {
    id: waypointEdit
    property var currentWayPointIndex: -1

    model: GroundControl.multiVehicleManager.plan.pathModel
    clip: true

    spacing: 5

    delegate: Rectangle{
        width: waypointEdit.width
        height: currentWayPointIndex == index ? 180 : 40
        color: currentWayPointIndex == index ? "#585d83" : "#393d3d"
        opacity: currentWayPointIndex == index ? 1 : 0.7
        radius: 3
        /********************************删除按钮********************************/
        Rectangle{
            id: delBackGround
            anchors{
                left: parent.left
                leftMargin: 3
                top: parent.top
                topMargin: 3
//                bottom: parent.bottom
//                bottomMargin: 3
            }
            width: 32
            height: width
            color: delBtn.containsMouse ? "#fff291" : "transparent"
            radius: 3

            Image {
                id: delImg
                anchors.fill: parent
                source: "qrc:/ui/Images/LGC/del.svg"
            }
            MouseArea{
                id: delBtn
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    GroundControl.multiVehicleManager.plan.removeVertex(index)
                }
            }
        }

        /********************************保存按钮********************************/
        Rectangle{
            id: saveBackGround
            anchors{
                right: parent.right
                rightMargin: 3
                top: parent.top
                topMargin: 3
            }
            visible: currentWayPointIndex == index ? true : false

            width: 32
            height: width
            color: saveBtn.containsMouse ? "#fff291" : "transparent"
            radius: 3

            Image {
                id: saveImg
                anchors.fill: parent
                source: "qrc:/ui/Images/LGC/save.svg"
            }
            MouseArea{
                id: saveBtn
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    console.log("================> on save clicked")
                    var coor = QtPositioning.coordinate(latField.text, lngField.text, depthField.text)
                    GroundControl.multiVehicleManager.plan.adjustVertex(index, coor, true)
                }
            }
        }

        /********************************航点名********************************/
        Text{
            anchors{
                left: delBackGround.right
                right: parent.right
                top: parent.top
//                bottom: parent.bottom
                leftMargin: 3
                rightMargin: 3
            }
            height: 40
            text: "航点" + (index+1)
            color: "#ffffff"
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea{
            anchors{
                left: delBackGround.right
                right: saveBackGround.left
                top: parent.top
//                bottom: parent.bottom
            }
            height: 40
            propagateComposedEvents : false

            onClicked: {
                currentWayPointIndex = index
            }
        }

        /********************************航点编辑********************************/
        Rectangle{
            color: "#282828"
            radius: 3
            visible: currentWayPointIndex == index ? true : false
            z: waypointEdit.z + 1e3
            anchors{
                left:parent.left
                right:parent.right
                bottom: parent.bottom
                top:parent.top
                leftMargin: 3
                rightMargin: 3
                bottomMargin: 3
                topMargin: 40
            }
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents : false
            }
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 10
                RowLayout{
                    id: lngLayout
                    height: 40
                    width: parent.width
                    Text{
                        text: "经度："
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 20
                        height: 40
                        color: "#ffffff"
                        Layout.minimumWidth: 70
                        Layout.maximumWidth: 70
                    }
                    CustomTextField{
                        id: lngField
                        Layout.fillWidth: true
                        Layout.maximumWidth: 300
                        height: 40
                        text: object.coordinate.longitude
                    }
                }
                RowLayout{
                    id: latLayout
                    height: 40
                    width: parent.width
                    Text{
                        text: "纬度："
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 20
                        height: 40
                        color: "#ffffff"
                        Layout.minimumWidth: 70
                        Layout.maximumWidth: 70
                    }
                    CustomTextField{
                        id: latField
                        Layout.fillWidth: true
                        Layout.maximumWidth: 300
                        height: 40
                        text: object.coordinate.latitude
                    }
                }
                RowLayout{
                    id: depthLayout

                    height: 40
                    width: parent.width
                    Text{
                        text: "高度："
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 20
                        height: 40
                        color: "#ffffff"
                        Layout.minimumWidth: 70
                        Layout.maximumWidth: 70
                    }
                    CustomTextField{
                        id: depthField
                        Layout.fillWidth: true
                        Layout.maximumWidth: 300
                        height: 40
                        text: object.coordinate.altitude
                    }
                }
            }
        }
    }

//    MouseArea{
//        anchors.fill: parent

//        propagateComposedEvents : true
//    }
    /********************************背景底色********************************/
    Rectangle{
        anchors.fill: parent
        anchors.margins: -10
        z: parent.z + 1
        color: "#222222"
        opacity: 0.1
    }
}
