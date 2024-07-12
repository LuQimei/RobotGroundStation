import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14
import QtLocation 5.15
import GroundControl 1.0
import GCMap 1.0
import CustomControl 1.0
import CustomWindow 1.0

Window {
    id: mainWindow

    property var defaultWidth: 1920
    property var defaultHeight: 1080
    property var littleWidgetFlag:true
    property var showLittleWidgetFlag:true
    property alias opencvVideo: opencvvideo.opencvVideo


    minimumWidth: 1280
    minimumHeight: 760
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint //隐藏标题栏
    color: "#000000"

    Component.onCompleted: {
        mainWindow.showMaximized()
    }


    /****************************************地图****************************************/
    MainMap {
        id: imap
        anchors {
            left: parent.left
            bottom: bottomItem.top
            leftMargin: !littleWidgetFlag ?  10 : 0
            bottomMargin: !littleWidgetFlag ?  10 : 0
        }
        width: !littleWidgetFlag ? 640 * mainWindow.width/mainWindow.defaultWidth : mainWindow.width
        height: !littleWidgetFlag ? width/64*36 : mainWindow.height - topButtonList.height - bottomItem.height
        visible: !littleWidgetFlag ? showLittleWidgetFlag : true

        MouseArea{
            anchors.fill: parent
            enabled : !littleWidgetFlag
            propagateComposedEvents : true
            onPressed: mouse.accepted = !littleWidgetFlag
            onReleased: mouse.accepted = !littleWidgetFlag

            onDoubleClicked:
            {
                littleWidgetFlag = !littleWidgetFlag
            }
        }
    }
    /****************************************视频****************************************/
     OpencvVideo {
         id: opencvvideo
         anchors {
             left: parent.left
             bottom: bottomItem.top
             leftMargin: littleWidgetFlag ?  10 : 0
             bottomMargin: littleWidgetFlag ?  10 : 0
         }
         width: littleWidgetFlag ? 1280*0.5 * mainWindow.width / mainWindow.defaultWidth : mainWindow.width
         height: littleWidgetFlag ? width/64*36 : mainWindow.height - topButtonList.height - bottomItem.height
         z: littleWidgetFlag ? imap.z+1 : imap.z-1
         visible: littleWidgetFlag ? showLittleWidgetFlag : true
         MouseArea{
             anchors.fill: parent
             enabled : littleWidgetFlag
             propagateComposedEvents : true
             onDoubleClicked: {
                 littleWidgetFlag = !littleWidgetFlag
             }
         }
     }



    /****************************************显示隐藏副屏****************************************/
    Rectangle {
        id:                     showPip
        anchors.left :          parent.left
        anchors.bottom:         bottomItem.top
        anchors.leftMargin:     10
        anchors.bottomMargin:   10
        height:                 40
        width:                  40
        radius:                 20 / 3
        color:                  Qt.rgba(0,0,0,0.75)
        z:                      opencvvideo.z+1
        Image {
            width:              parent.width  * 0.75
            height:             parent.height * 0.75
            sourceSize.height:  height
            rotation:           !showLittleWidgetFlag ? 0 : 180
            source:             "qrc:/ui/Images/LGC/buttonRight.svg"
            fillMode:           Image.PreserveAspectFit
            anchors.verticalCenter:     parent.verticalCenter
            anchors.horizontalCenter:   parent.horizontalCenter

        }
        MouseArea {
            anchors.fill:   parent
            onClicked:      showLittleWidgetFlag = !showLittleWidgetFlag
        }
    }

    /****************************************设置****************************************/
    PopWindow{
        id: settingWindow
        visible: false
    }

    /****************************************顶部栏****************************************/
    TopItem{
        id: topButtonList
        width: parent.width
        height: 50
        z: imap.z + 1
    }

    /****************************************底部栏****************************************/
    BottomItem{
        id: bottomItem
        width: parent.width
        height: 30
        z: topButtonList.z
        anchors.bottom:parent.bottom
    }

    /****************************************虚拟摇杆****************************************/
    VirtualJoyStick{
        id: virtualJoyStick
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: leftButtonList.bottom
        anchors.topMargin: 40 * mainWindow.height / mainWindow.defaultHeight
        height: 150 * mainWindow.height / mainWindow.defaultHeight
        visible: !GroundControl.multiVehicleManager.isDrawingPlan
    }


    /****************************************姿态****************************************/
    LGCInstrumentWidget {
        id: instrumentWidget
        visible: !GroundControl.multiVehicleManager.isDrawingPlan
        width: 260 //* mainWindow.width / mainWindow.defaultWidth //260
        z: imap.z + 1000
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 10
        anchors.topMargin: 70
    }

    /****************************************拍摄录像****************************************/
    CapVideo{
        id: capvideo
        visible: !GroundControl.multiVehicleManager.isDrawingPlan
        anchors.right: instrumentWidget.right
        anchors.top: instrumentWidget.bottom
        anchors.topMargin: 40

        height: 60
        width: (height-20)*3+30
    }


    /****************************************左侧按钮****************************************/
    LeftButtonList{
        id: leftButtonList
        anchors.top:topButtonList.bottom
        anchors.topMargin: 5
        anchors.left:parent.left
        anchors.leftMargin: 5
        width: 65
        height: width*4
        z: imap.z + 1
    }

    /****************************************航点编辑****************************************/
    WaypointEditWidget{
        anchors{
            right: parent.right
            top: topButtonList.bottom
            bottom: parent.bottom
            rightMargin: 10
            topMargin: 10
            bottomMargin: 10
        }
        width: 300
        z: imap.z + 1e2
        visible: GroundControl.multiVehicleManager.isDrawingPlan
    }



    /****************************************移动****************************************/
    Move{
        id:move
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: topButtonList.right
        anchors.bottom: topButtonList.bottom
        z:imap.z+1e6
        _window: mainWindow
    }

    /****************************************延申****************************************/
    Extends{
        id: entends
        anchors.fill: parent
        z: move.z*2
        myZ:move.z*2+1
        _window: mainWindow
    }


//    /****************************************地图****************************************/
//    Component{
//        id: iMap
//        MainMap {
//            anchors.fill: parent
//        }
//    }

//    /****************************************视频****************************************/
//    Component{
//        id: iVideo
//        OpencvVideo {
//            anchors.fill: parent
//        }
//    }

    //    function switchMain(){
    //        if(imap.state == "Map"){
    //            imap.state = "Video"
    //            secWidget.state = "Map"
    //        }else{
    //            imap.state = "Map"
    //            secWidget.state = "Video"
    //        }
    //    }

    //    /****************************************主界面****************************************/
    //    imap{
    //        id: imap
    //        anchors {
    //            top: topButtonList.bottom
    //            bottom: bottomItem.top
    //            left: parent.left
    //            right: parent.right
    //        }
    //    }
    //    /****************************************副界面****************************************/
    //    SecondaryWidget{
    //        id: secWidget
    //        anchors {
    //            bottom: bottomItem.top
    //            left: parent.left
    //            leftMargin: 10
    //            bottomMargin: 10
    //        }
    //        z: imap.z+1
    //        width: 1280*0.5
    //        height: 720*0.5
    //        MouseArea{
    //            anchors.fill: parent
    //            onDoubleClicked:
    //            {
    //                switchMain()
    //            }
    //        }
    //    }


    //模板不要删
    // anchors{
    //     fill: parent
    //     topMargin:mainWindow.tValue
    //     bottomMargin:mainWindow.bValue
    //     leftMargin:mainWindow.lValue
    //     rightMargin:mainWindow.rValue
    // }
    // anchors{
    //     fill: parent
    //     topMargin:00*mainWindow.height/mainWindow.defaultHeight
    //     bottomMargin:00*mainWindow.height/mainWindow.defaultHeight
    //     leftMargin:00*mainWindow.width/mainWindow.defaultWidth
    //     rightMargin:00*mainWindow.width/mainWindow.defaultWidth
    // }
    //        id: video
    //            anchors{
    //                fill:parent
    //                topMargin:720*mainWindow.height/mainWindow.defaultHeight
    //                bottomMargin:00*mainWindow.height/mainWindow.defaultHeight
    //                leftMargin:00*mainWindow.width/mainWindow.defaultWidth
    //                rightMargin:1280*mainWindow.width/mainWindow.defaultWidth
    //            }
    //            z: imap.z + 1
    //    }

}
