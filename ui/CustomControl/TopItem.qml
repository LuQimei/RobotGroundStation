import QtQuick 2.9

import GroundControl 1.0

Rectangle {
    id: topButtonList
    color: "#2b2d30"
    border.color: "#000000"
    border.width: 1

    DeadMouseArea{ anchors.fill: parent }

    /*******************************设置*******************************/
    Rectangle{
        id: settingRec
        color: "#00000000"//transparent//"#222222"
        anchors{
            left:parent.left
            leftMargin: 10
            top: parent.top
            topMargin: 6
            bottom: parent.bottom
            bottomMargin: 6
        }
        width: height

        Image {
            id: settingImage
            anchors.fill: parent
            source: "qrc:/ui/Images/LGC/menu.svg"
            fillMode: Image.Stretch
        }

        MouseArea{
            id: planButton
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                console.log("menu")
                settingWindow.visible = !settingWindow.visible

            }
        }
    }

    /*******************************电量*******************************/
    Image{
        id: batteryState
        anchors{
            left: settingRec.right
            leftMargin : 30
            top: parent.top
            topMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        source: !GroundControl.multiVehicleManager.rovVehicle.isConnect ? "qrc:/ui/Images/LGC/battery_white.svg" :
                GroundControl.multiVehicleManager.rovVehicle.battery >= 50 ? "qrc:/ui/Images/LGC/battery_green.svg" :
                GroundControl.multiVehicleManager.rovVehicle.battery < 50 && GroundControl.multiVehicleManager.rovVehicle.battery >= 20 ? "qrc:/ui/Images/LGC/battery_yellow.svg" :
                "qrc:/ui/Images/LGC/battery_red.svg"

        MouseArea{
            id: batteryMouse
            anchors.fill: parent
            hoverEnabled: true
        }
        Text{
            anchors.top: batteryState.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            visible: batteryMouse.containsMouse
            text: GroundControl.multiVehicleManager.rovVehicle.battery + "%"
            font.pixelSize: 20

            color: "#ffffff"
        }
    }

    /*******************************手柄连接状态*******************************/
    Image{
        id: joyStickConnect
        anchors{
            left: batteryState.right
            leftMargin : 20
            top: parent.top
            topMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        source: GroundControl.multiVehicleManager.rovVehicle.joystick.connected ? "qrc:/ui/Images/LGC/joystickConnect.svg" : "qrc:/ui/Images/LGC/joystick.svg"
        MouseArea{
            id: joyStickConnectMouse
            anchors.fill: parent
            hoverEnabled: true
        }
        Text{
            anchors.top: joyStickConnect.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.right: parent.right
            visible: joyStickConnectMouse.containsMouse
            text: GroundControl.multiVehicleManager.rovVehicle.joystick.connected ? "已连接" : "未连接"
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#ffffff"
        }
    }

    /*******************************锁定状态*******************************/
    Image{
        id: lockState
        anchors{
            left: joyStickConnect.right
            leftMargin : 20
            top: parent.top
            topMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        source: GroundControl.multiVehicleManager.rovVehicle.lockState ? "qrc:/ui/Images/LGC/lock.svg" : "qrc:/ui/Images/LGC/unlock.svg"
    }

    /*******************************加锁解锁*******************************/
    TransparentComboBox{
        id: lockComboBox
        anchors{
            left: lockState.right
            leftMargin : 3
            top: parent.top
            topMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        width: 90
        z: parent.z+1
        model: ["锁定","解锁"]

        Connections{
            target: GroundControl.multiVehicleManager.rovVehicle
            function onLockStateChanged(){
                if(lockComboBox.currentIndex != !GroundControl.multiVehicleManager.rovVehicle.lockState){
                    lockComboBox.currentIndex = !GroundControl.multiVehicleManager.rovVehicle.lockState
                }
            }
        }
        onCurrentIndexChanged: {
            switch(currentIndex){
            case 0:
                GroundControl.multiVehicleManager.rovVehicle.disarm()
                break;
            case 1:
                GroundControl.multiVehicleManager.rovVehicle.arm()
                break;
            }
        }
    }
    /*******************************模式*******************************/
    TransparentComboBox{
        id: modeComboBox
        anchors{
            left: lockComboBox.right
            leftMargin : 5
            top: parent.top
            topMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        width: 90
        z: parent.z+1
        model: ["手动","定深","定航"]
        Connections{
            target: GroundControl.multiVehicleManager.rovVehicle
            function onRunModeChanged(){
                if(modeComboBox.currentIndex != GroundControl.multiVehicleManager.rovVehicle.runMode){
                    modeComboBox.currentIndex = GroundControl.multiVehicleManager.rovVehicle.runMode
                }
            }
        }
        onCurrentIndexChanged: {
            switch(currentIndex){
            case 0:
                GroundControl.multiVehicleManager.rovVehicle.setManualMode()
                break;
            case 1:
                GroundControl.multiVehicleManager.rovVehicle.setDepthHoldMode()
                break;
            case 2:
                GroundControl.multiVehicleManager.rovVehicle.setStabilizeMode()
                break;
            }
        }
    }


    /*******************************关闭*******************************/
    Rectangle{
        id: closeRect
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: height
        color: closeBtn.containsPress ? "#dc5c66" : closeBtn.containsMouse ?  "#e81123" : "transparent"
        Image {
            anchors.centerIn: parent
            source: "qrc:/ui/Images/Top/close.svg"

        }
        MouseArea{
            id: closeBtn
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                mainWindow.close()
            }
        }
    }
    /*******************************最大化*******************************/
    Rectangle{
        id: maxRect
        anchors.right: closeRect.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: height
        color: maxBtn.containsPress ? "#555759" : maxBtn.containsMouse ?  "#383a3d" : "transparent"
        Image {
            anchors.centerIn: parent
            source: mainWindow.visibility == 4 && mainWindow.x == 0 && mainWindow.y == 0 ? "qrc:/ui/Images/Top/max2.svg" : "qrc:/ui/Images/Top/max.svg"

        }
        MouseArea{
            id: maxBtn
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if(mainWindow.visibility == 4 && mainWindow.x == 0 && mainWindow.y == 0){
//                    mainWindow.showMinimized()
                    mainWindow.showNormal()
                }else{
                    mainWindow.showMaximized()
                    mainWindow.x = 0
                    mainWindow.y = 0
                }
            }
        }
    }
    /*******************************最小化*******************************/
    Rectangle{
        id: minRect
        anchors.right: maxRect.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: height
        color: minBtn.containsPress ? "#555759" : minBtn.containsMouse ?  "#383a3d" : "transparent"
        Image {
            anchors.centerIn: parent
            source: "qrc:/ui/Images/Top/min.svg"

        }
        MouseArea{
            id: minBtn
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                mainWindow.showMinimized()

            }
        }
    }

    MouseArea{
        anchors.left: modeComboBox.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: minRect.left

        onDoubleClicked: {
            if(mainWindow.visibility == 4 && mainWindow.x == 0 && mainWindow.y == 0){
//                mainWindow.showMinimized()
                mainWindow.showNormal()
            }else{
                mainWindow.showMaximized()
                mainWindow.x = 0
                mainWindow.y = 0
            }
        }
    }
//    Text{
//        anchors.right: parent.right
//        anchors.top: parent.top
//        anchors.bottom: parent.bottom
//        anchors.rightMargin: 10

//        text: GroundControl.multiVehicleManager.rovVehicle.currentStateText
//        color: "#ffffff"
//        font.pixelSize: 28
//        verticalAlignment: Text.AlignVCenter
//        horizontalAlignment: Text.AlignRight
//    }
}
