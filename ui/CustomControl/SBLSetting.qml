import QtQuick 2.5
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5

import GroundControl 1.0


Item  {
    id: root

    Component.onCompleted: {
        //信号--方法
        popWindow.sig_accept.connect(on_accept)
    }
    //函数可以放到js文件中
    function on_accept(){
        if(title.text === settingWidget.currentTitle){
            GroundControl.settingManager.sblIp = addrField.text
            GroundControl.settingManager.sblPort = portField.text
            GroundControl.settingManager.saveSblConfig()
        }
    }
    Text{
        id: title
        text: "SBL"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 22
        height: 40
        color: "#ffffff"
    }
    RowLayout{
        id: tcp
        anchors.top: title.bottom
//        anchors.top: parent.top
        anchors.topMargin: 8
        height: 40
        width: parent.width
        Text{
            text: "TCP"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 20
            height: 40
            color: "#ffffff"
        }
        Rectangle{
            color: "#393b40"
            height: 1
            Layout.fillWidth: true
        }
    }

    RowLayout{
        id: addr
        anchors.top: tcp.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
        height: 40
        width: parent.width
        Text{
            text: "地址："
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 20
            height: 40
            color: "#ffffff"
            Layout.minimumWidth: 70
            Layout.maximumWidth: 70
        }
        CustomTextField{
            id: addrField
            Layout.fillWidth: true
            Layout.maximumWidth: 300
            height: 40
            text: GroundControl.settingManager.sblIp
        }
    }

    RowLayout{
        id: port
        anchors.top: addr.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
        height: 40
        width: parent.width
        Text{
            text: "端口："
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 20
            height: 40
            color: "#ffffff"
            Layout.minimumWidth: 70
            Layout.maximumWidth: 70
        }
        CustomTextField{
            id: portField
            Layout.fillWidth: true
            Layout.maximumWidth: 300
            height: 40
            text: GroundControl.settingManager.sblPort
        }
    }



}
