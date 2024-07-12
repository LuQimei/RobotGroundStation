import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.12

// 一次测距里包含多个标记点以及连线
MapItemGroup {
    id: planControl
    visible: true

    //----------------------------public var
    property alias waypointList: missionPathLine.path

    //--------------------------------------
    property color pointColor: "yellow"
    property color textColor: "#00000000"

    property color linrColor: getColor(0, 255, 252)
    property string type: "Plan"

    property bool planIsDrawing: false
    property bool fromThis: true

    function getColor(r, g, b) {
        var ret = (r << 16 | g << 8 | b)

        var retColor = (((r === 0) ? "#00" : "#") + ret.toString(
                            16)).toUpperCase()
        return retColor
    }

    //获取航线总长度/米
    function getDistance() {
        return missionPathLine.getDistanceCount()
    }

    function getWaypointList() {
        for (var index = 0; index < waypointList.length; ++index) {
            var point = waypointList[index]
            console.log("index:" + index + "  {lat: " + point.latitude
                        + "}, {lon: " + point.longitude + "}")
        }
    }



    MapPolyline {
        id: missionPathLine
        opacity: 0.7
        line.color: linrColor
        line.width: 5
        function getDistanceCount() {
            var distance_count = 0
            for (var i = 1; i < pathLength(); i++) {
                distance_count += missionPathLine.coordinateAt(i).distanceTo(
                            missionPathLine.coordinateAt(i - 1))
            }
            return Math.round(distance_count)
        }
    }

    MapItemView {
        id: item_view
        add: Transition {}
        remove: Transition {}
        model: waypointList
        delegate: MapQuickItem {
            id: ietm_delegate
            sourceItem:    Rectangle {
                width: 14
                height: 14
                radius: 7
                color: !index ? "green" : (index === waypointList.count - 1) ? "red" : pointColor
                border.width: 1
                border.color: pointColor
                Rectangle {
                    anchors.fill: parent
                    width: 14
                    height: 14
                    border.color: "#00000000" //标签边框颜色
                    color: "#00000000" //标签颜色
                    Text {
                        color: index === 0 ? "white" : "black"
                        anchors.centerIn: parent
                        text: (index === waypointList.count - 1) ? "L" : index + 1
                    }
                    Rectangle {
                        width: 14
                        height: 14
                        anchors.fill: parent
                        border.color: textColor
                        color: "#00000000" //删除按钮颜色

                        MouseArea {
                            anchors.fill: parent
                            enabled: !planIsDrawing
                            preventStealing: true
                            onClicked: {
                                console.log("点击了航点" + index)
                            }

                            onDoubleClicked: {
                                showPlanList(index)
                            }
                            onPressAndHold: {

                            }
                            property point clickPos: "0,0"
                            onPressed: {
                                //接收鼠标按下事件
                                clickPos = Qt.point(mouse.x, mouse.y)
                                //                                console.log()
                                fromThis = true
                            }
                            onReleased: {

                                var mouseLocation = map.toCoordinate(Qt.point(mouseX,
                                                                              mouseY),
                                                                     false)
                                clickPos = Qt.point(mouse.x, mouse.y)
                                console.log(mouseLocation)
                            }
                            onPositionChanged: {
                                //鼠标偏移量
                                var delta = Qt.point(mouse.x - clickPos.x,
                                                     mouse.y - clickPos.y)
                                ietm_delegate.x = ietm_delegate.x + delta.x
                                ietm_delegate.y = ietm_delegate.y + delta.y
                                movePoint(index,
                                          Qt.point(ietm_delegate.x + parent.width / 2,
                                                   ietm_delegate.y + parent.height / 2))
                            }
                        }
                    }
                }
            }
            //通过listmodel来设置数据
            coordinate: modelData
            anchorPoint: Qt.point(7, 7)
        }
    }



    function appendPoint(coord, updataTable) {
        planIsDrawing = true
        //        item_model.append({"latitudeval":coord.latitude,"longitudeval":coord.longitude});
        missionPathLine.addCoordinate(coord)
        if (!updataTable)
            return
        var afterCooed = waypointList.count > 1 ? missionPathLine.coordinateAt(
                                                      waypointList.count - 2) : coord
        var dis = afterCooed.distanceTo(coord)
        console.log(coord)
    }

    function followMouse(coord) {
        //        moving = true
        if (missionPathLine.pathLength() <= 0)
            return
        if (missionPathLine.pathLength() === waypointList.count) {
            missionPathLine.addCoordinate(coord)
        } else {
            missionPathLine.replaceCoordinate(missionPathLine.pathLength() - 1,
                                              coord)
        }
    }

    function closePath() {
        while (missionPathLine.pathLength() > waypointList.count) {
            missionPathLine.removeCoordinate(missionPathLine.pathLength() - 1)
        }
        fromThis = false
        planIsDrawing = false
    }

    function movePoint(index, point) {
        var coord = map.getMouseLocation(point)
        missionPathLine.replaceCoordinate(index, coord) //更新地图航点位置
    }
}
