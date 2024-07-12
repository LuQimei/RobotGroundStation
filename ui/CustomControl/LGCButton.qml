import QtQuick 2.3
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Button{

    property var showText
    property var defaultHeight
    id: lgcButton
    text: showText
    hoverEnabled: true
    Layout.fillWidth: true
    contentItem: Text {
        text: lgcButton.text
//        color: "white"
        font.pixelSize: 20
        font.bold: true
        font.family: "Consolas"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle{
        color: lgcButton.hovered ? "#95d3f7" : "#0261a0"
        radius: 10
        implicitHeight: defaultHeight
    }

}
