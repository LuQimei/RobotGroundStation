import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.14

import CustomControl 1.0

Window {
    id: popWindow
    flags: Qt.Window | Qt.FramelessWindowHint //隐藏标题栏

    minimumWidth: 982
    minimumHeight: 728
    color: "#2B2D30"
    property var defaultWidth:982
    property var defaultHeight:728
    property alias loaderState: widgetLoader.state
//    property var tValue:mainWindow.positionTool.tValue*height/defaultHeight
//    property var bValue:mainWindow.positionTool.bValue*height/defaultHeight
//    property var lValue:mainWindow.positionTool.lValue*width/defaultWidth
//    property var rValue:mainWindow.positionTool.rValue*width/defaultWidth

    signal sig_accept()


    //中间内容加载
    Loader{
        id:widgetLoader
//        state: "设置"
        z: entends.z+1
        anchors{
            fill: parent
            topMargin:50
            bottomMargin:60
            leftMargin:10
            rightMargin:10
        }
        states:[
            State {
                name: "设置"
                PropertyChanges  { target: widgetLoader; source: "qrc:/qml/CustomWindow/SettingWidget.qml";}
            }
        ]
    }
    Component.onCompleted: widgetLoader.state = "设置"

    //底部按钮
    RowLayout{
        anchors.top: bottomLine.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        width: 300
        z:entends.z+1

        Rectangle{
            id: yes
            Layout.maximumWidth: 90
            Layout.maximumHeight: 35
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#3574f0"
            radius: 3
            border.width: !yesArea.containsMouse ? 1 : 2
            border.color: !yesArea.containsMouse ? "#4e5157" : "#3574F0"

            Text{
                anchors.fill: parent
                text: "确定"
                color: "#ffffff"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }

            MouseArea{
                id: yesArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    sig_accept()
                    popWindow.close()
                }
            }
        }
        Rectangle{
            id: cancel
            Layout.maximumWidth: 90
            Layout.maximumHeight: 35
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#00000000"
            radius: 3
            border.width: !concelArea.containsMouse ? 1 : 2
            border.color: !concelArea.containsMouse ? "#4e5157" : "#3574F0"
            Text{
                anchors.fill: parent
                text: "取消"
                color: "#ffffff"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }
            MouseArea{
                id: concelArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    popWindow.close()
                }
            }
        }
        Rectangle{
            id: use
            Layout.maximumWidth: 90
            Layout.maximumHeight: 35
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#00000000"
            radius: 3
            border.width: !useArea.containsMouse ? 1 : 2
            border.color: !useArea.containsMouse ? "#4e5157" : "#3574F0"
            Text{
                anchors.fill: parent
                text: "应用"
                color: "#ffffff"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
            }
            MouseArea{
                id: useArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    sig_accept()
                }
            }
        }
    }

    //背景颜色
    Rectangle{
        anchors.fill: parent
        color: "#2B2D30"
    }
    //上部标题内容分割线
    Rectangle{
        id: topLine
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 40
        width: parent.width
        height: 1
        color: "#393B40"
    }
    //下部按钮内容分割线
    Rectangle{
        id: bottomLine
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 50
        width: parent.width
        height: 1
        color: "#1e1F22"
    }
    //标题
    Text{
        id: title
        anchors{
            top: parent.top
            topMargin:08
            left: parent.left
            leftMargin:08
            bottom:topLine.top
            bottomMargin:08
        }
        text: widgetLoader.state
        font.pixelSize: 28
        color: "#ffffff"
        verticalAlignment: Qt.AlignVCenter
    }

    //关闭
    Rectangle{
        id: closeRec
        z: entends.z+2
        anchors{
            top: parent.top
            topMargin:08
            right: parent.right
            rightMargin:08
            bottom:topLine.top
            bottomMargin:08
        }
        width: height
        color: "#00000000"
        Image{
            id: closeImage
            anchors.fill: parent
            source: "qrc:/ui/Images/LGC/close.png"
            fillMode:Image.PreserveAspectFit
        }
        MouseArea{
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onContainsMouseChanged: {
                if(containsMouse  == false){
                    closeRec.color = "#00000000"
                }else{
                    closeRec.color = "red"
                }
            }
            onClicked: {
                popWindow.close()
                closeRec.color = "#00000000"
            }
        }
    }
    //移动
    Move{
        id:move
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: closeRec.left
        anchors.bottom: topLine.top
        z:parent.z+1e2
        _window: popWindow
    }
    //延申
    Extends{
        id: entends
        anchors.fill: parent
        z: move.z*2
        myZ:move.z*2+1
        _window: popWindow
    }

    //模板不要删！！！！！！！！！！！！！
    // anchors{
    //     fill: parent
    //     topMargin:popWindow.tValue
    //     bottomMargin:popWindow.bValue
    //     leftMargin:popWindow.lValue
    //     rightMargin:popWindow.rValue
    // }
    // anchors{
    //     fill: parent
    //     topMargin:00*popWindow.height/popWindow.defaultHeight
    //     bottomMargin:00*popWindow.height/popWindow.defaultHeight
    //     leftMargin:00*popWindow.width/popWindow.defaultWidth
    //     rightMargin:00*popWindow.width/popWindow.defaultWidth
    // }
        //============================================
}
