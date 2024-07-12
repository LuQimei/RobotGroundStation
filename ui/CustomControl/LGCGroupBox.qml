import QtQuick 2.3


Rectangle {
    property alias title: titleText.text
    property alias recItem: recitem
    color: "#f0f0f0"
    Text {
        id:titleText
        text: "Group Box Title"
        font.bold: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pixelSize: 16
    }

    Rectangle {
        id: recitem
        width: parent.width-20
        height: parent.height-20
        color: "white"
        border.color: "#b3b3b3"
        anchors.top: titleText.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        // Add your content here
    }
}

