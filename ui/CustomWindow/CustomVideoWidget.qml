import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Window 2.14
import GroundControl 1.0
import VideoWidget 1.0
import CustomControl 1.0

Item {
    id:root

    property var _cameraManager : GroundControl.cameraManager
    property var _camera : _cameraManager.camera
    property var _identify : _camera != undefined ?  _camera.identify : undefined



        Rectangle{
            id: backGround
            anchors.fill: parent
            color: "#000000"
            z: parent.z - 1

        }

        Image {
            source: "qrc:/ui/Images/general/videoBackground.png"
            // 设置背景图片的路径
//            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            // 居中设置
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            // 大小设置
            width: parent.width * 0.15
            // 设置图片宽度为父元素宽度的80%
            height: parent.height * 0.15
            // 设置图片高度为父元素高度的80%
         }

        VideoWidget{
            id: videoWidget
            visible: true
            anchors.fill: parent
            nWidth: parent.width
            nHeight: parent.height
            video: GroundControl.videoManager.video

//            Text{
//                anchors.bottom: parent.bottom
//                anchors.left: parent.left
//                anchors.bottomMargin: 20
//                anchors.leftMargin: 20

//                text: GroundControl.videoManager.video.currentTime
//                font.pixelSize: 30
//                color: "white"
//            }

            JoystickThumbPad {
                id:                     stick
                visible:                _camera != undefined ? _camera.isConn : false
                anchors.right:          parent.right
                anchors.top:            parent.top
                anchors.rightMargin:    20
                anchors.topMargin:      400*root.height/mainWindow.defaultHeight
                width:                  200*root.height/mainWindow.defaultHeight
                height:                 width
                enabled:                true
                onYAxisChanged: {
                    GroundControl.cameraManager.camera.OnLButtonDown(stick.xAxis,stick.yAxis)
                }

                onXAxisChanged: {
                    GroundControl.cameraManager.camera.OnLButtonDown(stick.xAxis,stick.yAxis)
                }
            }

            Repeater{
                model : GroundControl.videoManager.video.rects
                delegate: Rectangle{
                    z:                      backGround.z+10
                    color: "#00000000"
                    border.width: 4
                    border.color: "red"
                    x: object.rectX*videoWidget.nWidth/videoWidget.iWidth
                    y: object.rectY*videoWidget.nHeight/videoWidget.iHeight
                    width: object.rectWidth*videoWidget.nWidth/videoWidget.iWidth
                    height: object.rectHeight*videoWidget.nHeight/videoWidget.iHeight
                }
            }

//            Window{
//                id: externalwindow
//                x: root.x+mainWindow.x+300
//                y: root.y+mainWindow.y+50
//                width: root.width
//                height: root.height
//                visible: true
//                flags: Qt.SubWindow | Qt.FramelessWindowHint
//                transientParent: mainWindow
//                color: "#00000000"
//                Item{
//                    id: hwidItem
//                    anchors.fill: parent
//                    Component.onCompleted:{
//                        _camera.setParentWindow(hwidItem)
//                    }
//                }

//        }
    }


}
