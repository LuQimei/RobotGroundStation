import QtQuick 2.9

Item {
    id: root
    anchors.fill: parent

    property bool visibleFlags: false
    property var parentItem
    property var _maxSize: 1
    property var _minSize: 0.1

    /*******************************检测鼠标位置*******************************/
    MouseArea{
        id: rootMouseArea
        anchors.fill: root
        z: root.z+1
        hoverEnabled: true
        propagateComposedEvents: true
        onPressed: mouse.accepted = false
        onReleased: mouse.accepted = false
//        onClicked: console.log("-=====================")
    }

    Item{
        anchors.fill: root
        visible: rootMouseArea.containsMouse && visibleFlags
        /*******************************右上延申*******************************/
        Image {
            id: extend
            anchors.right: parent.right
            anchors.top: parent.top
            source: "qrc:/ui/Images/LGC/pipResize.svg"
            width: 40
            height: 40

            // MouseArea to drag in order to resize the PiP area
            MouseArea {
                id:             pipResize
                anchors.fill:   parent
                hoverEnabled: true

                property real initialX:     0
                property real initialWidth: 0


                onClicked: console.log("onclicked")

                // When we push the mouse button down, we un-anchor the mouse area to prevent a resizing loop
                onPressed: {
                    console.log("onPressed")
                    pipResize.anchors.top = undefined // Top doesn't seem to 'detach'
                    pipResize.anchors.right = undefined // This one works right, which is what we really need
                    pipResize.initialX = mouse.x
                    pipResize.initialWidth = root.width
                }

                // When we let go of the mouse button, we re-anchor the mouse area in the correct position
                onReleased: {
                    console.log("onReleased")
                    pipResize.anchors.top = root.top
                    pipResize.anchors.right = root.right
                }

                // Drag
                onPositionChanged: {
                    console.log("onPositionChanged")
                    if (pipResize.pressed) {
                        var parentWidth = parentItem.width
                        console.log(parentWidth)

                        var newWidth = pipResize.initialWidth + mouse.x - pipResize.initialX
                        console.log(newWidth)

                        if (newWidth < parentWidth * 1.1 && newWidth > parentWidth * 0.9) {
                            console.log(newWidth)
                            parentItem.width = newWidth
                        }
                    }
                }
            }
        }
    }



}
