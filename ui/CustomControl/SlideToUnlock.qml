import QtQuick 2.3
import QtQuick.Controls 2.15

Rectangle {

    property var _width
    property var _height
        width: _width
        height: _height

        Rectangle {
            id: slider
            width: 100
            height: 40
            color: "#3498db"
            radius: 20

            property real startX: 0
            property real offsetX: 0
            property bool dragging: false

            Behavior on x {
                NumberAnimation {
                    duration: 300
                }
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onPressed: {
                    slider.startX = mouse.x
                    slider.offsetX = 0
                    slider.dragging = true
                }

                onPositionChanged: {
                    if (slider.dragging) {
                        slider.offsetX = mouse.x - slider.startX
                        if (slider.offsetX >= 0 && slider.offsetX <= 200) {
                            slider.x = slider.offsetX
                        }
                    }
                }

                onReleased: {
                    if (slider.dragging) {
                        slider.dragging = false
                        if (slider.offsetX >= 200) {
                            slider.x = 200
                            slider.color = "#27ae60"
                            sliderText.text = "解锁成功"
                        } else {
                            slider.x = 0
                            slider.color = "#3498db"
                            sliderText.text = ""
                        }
                    }
                }
            }

            Text {
                id: sliderText
                text: ""
                anchors.centerIn: parent
                color: "white"
                font.bold: true
                font.pixelSize: 14
            }
        }
    }
