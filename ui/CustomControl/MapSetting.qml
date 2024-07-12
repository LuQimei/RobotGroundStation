import QtQuick 2.3
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.14

import GroundControl 1.0
import CustomWindow 1.0

ListView {
    property var mapSources: ["amap"]
    property var mapType: ["平面", "卫星"]

    Component.onCompleted: {
        //信号--方法
        popWindow.sig_accept.connect(on_accept)

    }
    //函数可以放到js文件中
    function on_accept(){
        if(title.text === settingWidget.currentTitle){
            GroundControl.settingManager.lng = lngField.text
            GroundControl.settingManager.lat = latField.text
            GroundControl.settingManager.zoom = zoomField.text
            GroundControl.settingManager.maxZoom = maxZoomField.text
            GroundControl.settingManager.source = sourceComboBox.currentText
            GroundControl.settingManager.mapType = mapTypeComboBox.currentIndex
            GroundControl.settingManager.saveConfig()
        }
    }

    Text{
        id: title
        text: "地图"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 22
        height: 40
        color: "#ffffff"
    }

    RowLayout{
        id: init
        anchors.top: title.bottom
        anchors.topMargin: 8
        height: 40
        width: parent.width
        Text{
            text: "初始化"
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
        id: lngLayout
        anchors.top: init.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
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
            text: GroundControl.settingManager.lng
        }
    }
    RowLayout{
        id: latLayout
        anchors.top: lngLayout.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
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
            text: GroundControl.settingManager.lat
        }
    }
    RowLayout{
        id: zoomLayout
        anchors.top: latLayout.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
        height: 40
        width: parent.width
        Text{
            text: "放大倍数："
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 20
            height: 40
            color: "#ffffff"
            Layout.minimumWidth: 70
            Layout.maximumWidth: 70
        }
        CustomTextField{
            id: zoomField
            Layout.fillWidth: true
            Layout.maximumWidth: 300
            height: 40
            text: GroundControl.settingManager.zoom
        }
    }

    RowLayout{
        id: normal
        anchors.top: zoomLayout.bottom
        anchors.topMargin: 8
        height: 40
        width: parent.width
        Text{
            text: "通用"
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
        id: maxZoomLayout
        anchors.top: normal.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
        height: 40
        width: parent.width
        Text{
            text: "最大放大倍数："
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 20
            height: 40
            color: "#ffffff"
            Layout.minimumWidth: 70
            Layout.maximumWidth: 70
        }
        CustomTextField{
            id: maxZoomField
            Layout.fillWidth: true
            Layout.maximumWidth: 300
            height: 40
            text: GroundControl.settingManager.maxZoom
        }
    }

    RowLayout{
        id: sourceLayout
        anchors.top: maxZoomLayout.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
        height: 40
        width: parent.width
        Text{
            text: "地图源："
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 20
            height: 40
            color: "#ffffff"
            Layout.minimumWidth: 70
            Layout.maximumWidth: 70
        }
        MyComboBox{
            id: sourceComboBox
            enabled: false
            Layout.fillWidth: true
            Layout.maximumWidth: 300
            height: 40
            model: mapSources //GroundControl.settingManager.source
        }
    }

    RowLayout{
        id: mapTypeLayout
        anchors.top: sourceLayout.bottom
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
        height: 40
        width: parent.width
        Text{
            text: "地图类型："
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 20
            height: 40
            color: "#ffffff"
            Layout.minimumWidth: 70
            Layout.maximumWidth: 70
        }
        MyComboBox{
            id: mapTypeComboBox
            Layout.fillWidth: true
            Layout.maximumWidth: 300
            height: 40
            model: mapType
            currentIndex: GroundControl.settingManager.mapType
        }
    }

}
