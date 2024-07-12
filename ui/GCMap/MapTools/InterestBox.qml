import QtQuick 2.0
import QtPositioning 5.12
import QtLocation 5.12

MapQuickItem{
    id:interest_box
    property var lat: 0
    property var lon: 0
    property var m_name: "1"
    property var image: "qrc:/image/mapfeaturesframe/pointclear.png"
    property var heading: 0
    property var type: "InterestIcon"
    property bool pointMove: false
    width: 30
    height: 30

    function resetImage(){
        interest_Icon.image_source = image
    }

    sourceItem: Rectangle{
        MyIcon{
            id:interest_Icon
            width: 30
            height: 30
            heading: interest_box.heading
            myName: m_name.toString()
            image_source: image
            showText: false
            MouseArea{
                x:parent.x-parent.width/2
                y:parent.y-parent.height/2
                width: parent.width
                height: parent.height
                preventStealing :true
                onClicked: {
                    interest_box.parent.moveIconType = interest_box.type
                }
                property point clickPos: "0,0"
                onPressed: { //接收鼠标按下事件
                    clickPos  = Qt.point(mouse.x,mouse.y)
                }
                onPositionChanged:{
                    //鼠标偏移量
                    var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
                    interest_box.x = interest_box.x+delta.x
                    interest_box.y = interest_box.y+delta.y
                    movePoint(Qt.point(interest_box.x,interest_box.y))
                }
            }
        }
    }
    coordinate {
        latitude: lat
        longitude: lon
    }

    function movePoint(point){

        var coord = parent.getMouseLocation(point)
        lat = coord.latitude
        lon = coord.longitude
        var i = 0
        for(var v in parent.interestPointList){
            if(parent.interestPointList[i].name === m_name){
                parent.interestPointList[i].lat = lat
                parent.interestPointList[i].lon = lon
            }
            i++
        }
    }
}
