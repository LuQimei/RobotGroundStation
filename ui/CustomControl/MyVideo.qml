import QtQuick 2.3
import QtQuick.Window 2.14
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15

import FFmpegWidget 1.0

Rectangle {
    color: "grey"
//    opacity: 0.5
    property var addr

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
