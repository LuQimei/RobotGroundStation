import QtQuick 2.15

Item {
    property alias state: widgetLoader.state

    Loader{
        id:widgetLoader
        anchors{
            fill: parent
        }
        state: "Map"
        states:[
            State {
                name: "Map"
                PropertyChanges  { target: widgetLoader; sourceComponent:mainWindow._map}//source: "qrc:/qml/GCMap/MainMap.qml";}
            },
            State {
                name: "Video"
                PropertyChanges  { target: widgetLoader;  sourceComponent:mainWindow._video}//source: "qrc:/qml/CustomControl/OpencvVideo.qml";}
            }
        ]
    }
}
