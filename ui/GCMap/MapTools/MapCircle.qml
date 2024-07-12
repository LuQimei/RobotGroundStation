import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.12

// 一次测距里包含多个标记点以及连线
MapItemGroup{
    id: circleConlor
    property color innerColor: Qt.rgba(77/255,76/255,167/255,0.5)
    property color outColor: Qt.rgba(242/255,58/255,58/255,0.9)
    property var type: "Circle"
    property var centreLocation
    property var pointList: []
    property var diameter: 14
    property var havePoint: false
    property var mouseX: 0
    property var mouseY: 0
    property var zoomlev: 0
    property var cirArea: 0
    property var cirArea2: 0
//    property var textColor: value

    MapItemView{
        id: item_view
        add: Transition {}
        remove: Transition {}
        model: ListModel{
            id: item_model
        }
        delegate: MapQuickItem{
            id: ietm_delegate
            zoomLevel: zoomlev

            sourceItem: Rectangle {
                id: circle
                width: diameter
                height: diameter
                radius: height/2
                color: innerColor
                border.width: 2
                border.color: outColor
                Rectangle{
                    id: textbg
                    width: item_text.width+10
                    height: item_text.height+10
                    x: circle.radius + 30
                    y: circle.radius - textbg.height/2
                    color: "#00000000"
                    Text {
                        id: item_text
                        anchors.verticalCenter: parent.verticalCenter
                        color: outColor
                        text: index ===0 ? "面积：" + cirArea2 + "平方米": ""
                    }
                }

                Loader{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                    anchors.margins: 5
                }
            }
            //通过listmodel来设置数据
            coordinate{
                latitude: latitudeval
                longitude: longitudeval
            }
            anchorPoint: Qt.point(sourceItem.width/2, sourceItem.height/2)
        }


    }



    function appendPoint(coord,mousePoint){
        if(havePoint) return
        item_model.append({"latitudeval":coord.latitude,"longitudeval":coord.longitude});
        havePoint = true
        mouseX = mousePoint.x
        mouseY = mousePoint.y
        pointList.push(coord)
    }

    function followMouse(coord,mousePoint){
        if(havePoint){
            var isLat = Math.abs(mouseX - mousePoint.x) < Math.abs(mouseY - mousePoint.y)
            diameter = isLat ? (Math.abs(mouseY - mousePoint.y) * 2) : (Math.abs(mouseX - mousePoint.x) * 2)
            getArea(coord,isLat)
        }

    }

    function closePath(){

    }

    //获取面积
    function getArea(point,isLat){
        var v = point
        var angle = isLat ? Math.abs(pointList[0].latitude - v.latitude) : Math.abs(pointList[0].longitude - v.longitude)
        v.latitude = isLat ? v.latitude : pointList[0].latitude
        v.longitude = isLat ? pointList[0].longitude : v.longitude
        var dis  = pointList[0].distanceTo(v)
        var data = (90-(angle))*Math.PI/180
        cirArea = getArea1(data).toFixed(2)
        cirArea2 = getArea2(dis).toFixed(2)
    }

    function getArea1(angle){
        return (2 * Math.PI * Math.pow(6378137, 2 )* (1-Math.sin(angle)))
    }

    function getArea2(angle){
        return Math.PI*Math.pow(angle, 2)
    }
}
