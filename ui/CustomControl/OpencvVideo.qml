import QtQuick 2.0
import OpencvWidget 1.0

Item {
    id: root
    property alias opencvVideo: opencvwidget

    Rectangle{
        id: background
        color: "black"
        anchors.fill: parent
//        opacity: 0.7
        z: -1
    }

    Image {
        id: image
        source: "qrc:/ui/Images/LGC/videoBackground.png"
        fillMode: Image.PreserveAspectCrop

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        width: parent.width * 0.15
        height: parent.height * 0.15
    }

    OpencvWidget {
        id: opencvwidget

        anchors.fill: parent
        Component.onCompleted: {
            opencvwidget.start();
        }
        visible: true
        nWidth: parent.width
        nHeight: parent.height

        MouseArea{
            anchors.fill: parent
            onClicked: opencvwidget.start()
        }
    }

//    SecondaryWidgetExtend{
//        z:opencvwidget.z+1
//        visibleFlags: true
//        parentItem:root
//    }

}
