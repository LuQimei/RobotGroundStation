import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.12

import GroundControl 1.0
import CustomControl 1.0

// 一次测距里包含多个标记点以及连线
MapItemGroup {

    id: root
    property color pointColor: "yellow"
    property color textColor: "#00000000"
    property color linrColor: getColor(0, 255, 252)
    property var mapPolyline
    property var _itemWidth: 30

    //    property var plan
    //    property var object:plan.editMapPolyline
    //    property var tmpPath

    function getColor(r, g, b) {
        var ret = (r << 16 | g << 8 | b)

        var retColor = (((r === 0) ? "#00" : "#") + ret.toString(
                            16)).toUpperCase()
        return retColor
    }


    MapPolyline {
        id: item_line
        opacity: 0.7
        line.color: linrColor
        line.width: 5
        path: mapPolyline.path
    }

    MapItemView {
        id: item_view
        add: Transition {}
        remove: Transition {}
        model: mapPolyline.path
        delegate: MapQuickItem {
            id: ietm_delegate
            //通过listmodel来设置数据
            coordinate: modelData
            anchorPoint{
                x: width / 2
                y: height / 2
            }
            MouseArea {
                anchors.fill: parent
                drag.target: parent
                // 当鼠标释放时还原透明度
                // 当鼠标移动时更新位置
                enabled: GroundControl.multiVehicleManager.isDrawingPlan
                onPositionChanged: {
                    item_line.replaceCoordinate(index,coordinate)//更新地图航点位置
                    mapPolyline.adjustVertex(index,coordinate)
                }
                onDoubleClicked: {
                    GroundControl.multiVehicleManager.isDrawingPlan = false
                }
                onPressed: {
                    if(popRec.visible){
                        popRec.visible = false
                    }
                }
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                enabled: GroundControl.multiVehicleManager.isDrawingPlan
                onClicked: {
                    popRec.visible = !popRec.visible
                }
            }
            sourceItem: Rectangle {
                width: _itemWidth
                height: _itemWidth
                color: "#00000000"

                Rectangle{
                    anchors.fill: parent
                    color: mapPolyline.pathModel.get(index) ?  (index === mapPolyline.pathModel.count - 1 ? "red" : pointColor) : pointColor
//                    color: mapPolyline.pathModel.get(index).timeVisible ? "blue" : (index === mapPolyline.pathModel.count - 1) ? "red" : pointColor
                    border.width: 1
                    border.color: "#00000000"
                    radius: _itemWidth/2
                    visible: true
                    Text {
                        color: "black"
                        anchors.centerIn: parent
                        text: (index === mapPolyline.path.count - 1) ? "L" : index + 1
                    }
                }

                Rectangle{
                    id: popRec
                    visible: false
                    x: parent.width
                    y: parent.width

                    width: 100
                    height: 40

                    Button{
                        anchors.fill: parent
                        text: "删除"
                        onClicked: {
                            mapPolyline.removeVertex(index)
                        }
                    }
                }
            }
        }
    }
}
