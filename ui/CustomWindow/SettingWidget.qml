import QtQuick 2.0
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0

Item {
    id: settingWidget
    property var titles: ["地图","SBL","系统设置","车辆设置"]
    property var currentTitle : "地图"

    Component.onCompleted: {
        settingLoader.state = currentTitle
    }

    //左侧标题栏
    ListView{
        id: titleListView
        anchors{
            fill: parent
            topMargin:00*popWindow.height/popWindow.defaultHeight
            bottomMargin:00*popWindow.height/popWindow.defaultHeight
            leftMargin:00*popWindow.width/popWindow.defaultWidth
            rightMargin:780*popWindow.width/popWindow.defaultWidth
        }
        model: titles
        clip: true
        delegate: Rectangle{
            id: titleRec
            width: parent.width
            height: 40
            color: titleListView.currentIndex == index ? "#2e436e" : "#00000000"
            Text{
                id: titleText
                anchors.fill: parent
                anchors.leftMargin: 20*popWindow.width/popWindow.defaultWidth
                text: modelData
                color: "#ffffff"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 20
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    titleListView.currentIndex = index
                    currentTitle = titleText.text
                    settingLoader.state = currentTitle
                }
            }
        }
    }


    Loader{
        id: settingLoader
        anchors{
            fill: parent
            topMargin:00*popWindow.height/popWindow.defaultHeight
            bottomMargin:00*popWindow.height/popWindow.defaultHeight
            leftMargin:190*popWindow.width/popWindow.defaultWidth
            rightMargin:00*popWindow.width/popWindow.defaultWidth
        }
        state : ""

        states:[
            State {
                name: "地图"
                PropertyChanges  { target: settingLoader; source: "qrc:/qml/CustomControl/MapSetting.qml";}
            },
            State {
                name: "SBL"
                PropertyChanges  { target: settingLoader; source: "qrc:/qml/CustomControl/SBLSetting.qml";}
            }
        ]
    }


}

