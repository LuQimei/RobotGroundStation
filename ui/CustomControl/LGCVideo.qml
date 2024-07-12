import QtQuick 2.3
import QtQuick.Window 2.14
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15

import FFmpegWidget 1.0

Item {
//    color: "grey"
//    opacity: 0.5
    property var addr

    Rectangle{
        id: background
        color: "black"
        anchors.fill: parent
        opacity: 0.7
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

    FFmpegWidget{
        id: myVideo
        visible: true
        anchors.fill: parent
        nWidth :parent.width;//cpp中的宽和高
        nHeight:parent.height;
        video: addr
    }


    MouseArea{
        anchors.fill: parent
        onClicked:{
            console.log("===============>video start : ",addr)
            myVideo.video = addr
        }
    }


}
