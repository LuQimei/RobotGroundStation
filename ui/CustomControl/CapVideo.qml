import QtQuick 2.9

Rectangle {
    color: "#000000"
    radius: 10
    opacity: 0.5

    property var currentModel: mainWindow.opencvVideo.saveType
    property var start: mainWindow.opencvVideo.isSaved

    Item{
        anchors.centerIn: parent
        height: parent.height-20
        width: height*3+10
        Rectangle{
            id: opt
            color: "#626262"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height*2
            radius: height

            Rectangle{
                anchors.fill: parent
                anchors.rightMargin: parent.width/2
                radius: width

                color: mainWindow.opencvVideo.saveType == 0 ? "#000000" : "transparent"
                border.width: mainWindow.opencvVideo.saveType == 0 ? 1 : 0
                border.color: "#ffffff"

                Image {
                    anchors.fill: parent
                    anchors.margins: 10
                    source: mainWindow.opencvVideo.saveType == 0 ? "qrc:/ui/Images/LGC/cap_green.svg" : "qrc:/ui/Images/LGC/cap_white.svg"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: mainWindow.opencvVideo.saveType = 0
                }
            }
            Rectangle{
                anchors.fill: parent
                anchors.leftMargin: parent.width/2
                radius: width

                color: mainWindow.opencvVideo.saveType == 1 ? "#000000" : "transparent"
                border.width: mainWindow.opencvVideo.saveType == 1 ? 1 : 0
                border.color: "#ffffff"

                Image {
                    anchors.fill: parent
                    anchors.margins: 10
                    source: mainWindow.opencvVideo.saveType == 1 ? "qrc:/ui/Images/LGC/video_green.svg" : "qrc:/ui/Images/LGC/video_white.svg"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: mainWindow.opencvVideo.saveType = 1
                }
            }
        }
        Rectangle{
            anchors.fill: parent
            anchors.leftMargin: opt.width+10
            radius: width
            border.width: 3
            border.color: "#ffffff"
            color: "black"

            Rectangle{
                anchors.fill: parent
                color: mainWindow.opencvVideo.isSaved ? "transparent" : "red"
                anchors.margins: 10
                radius: width
                Rectangle{
                    anchors.fill: parent
                    anchors.margins: parent.width/8
                    visible: mainWindow.opencvVideo.isSaved
                    color: "red"
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked:{
                    mainWindow.opencvVideo.isSaved = !mainWindow.opencvVideo.isSaved
                }
            }
        }
    }

}
