import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.12

// 一次测距里包含多个标记点以及连线
MapItemGroup{
    id: rulerConlor
    property color pointColor: "blue"
    property color textColor: "red"
    property color linrColor: "blue"
    property var type: "Ruler"

    property var pointList: []

    MapPolyline {
        id: item_line
        line.color: linrColor
        line.width: 2
        function getDistanceCount(){
            var distance_count=0;
            for(var i=1;i<pathLength();i++){
                distance_count+=item_line.coordinateAt(i).distanceTo(item_line.coordinateAt(i-1));
            }
            return Math.round(distance_count);
        }
    }

    MapItemView{
        id: item_view
        add: Transition {}
        remove: Transition {}
        model: ListModel{
            id: item_model
        }
        delegate: MapQuickItem{
            id: ietm_delegate
            sourceItem: Rectangle {
                width: 14
                height: 14
                radius: 7
                color: pointColor
                border.width: 2
                border.color: pointColor
                Rectangle{
                    anchors.left: parent.right
                    anchors.top: parent.bottom
                    width: item_text.width+5+5+14+5
                    height: item_text.height+10
                    border.color: "#00000000" //标签边框颜色
                    color: "#00000000" //标签颜色
                    Text {
                        id: item_text
                        x: 5
                        anchors.verticalCenter: parent.verticalCenter
                        color: textColor
                        text: index<=0
                              ? "起点"
                              : (index==item_model.count-1)
                                ? ("总长 "+item_line.getDistanceCount()/1000+" km")
                                :(Math.round(ietm_delegate.coordinate.distanceTo(item_line.coordinateAt(index-1)))/1000+" km")
                    }
                    Rectangle{
                        width: 14
                        height: 14
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        anchors.verticalCenter: parent.verticalCenter
                        border.color: textColor
                        color: "#00000000" //删除按钮颜色
                        Text {
                            color: textColor
                            anchors.centerIn: parent
                            text: "+"
                            rotation: 45
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                //最后一个全部删除,否则一个一个的删除
                                //为0的时候发送信号给group请求删除
                                if(index==item_model.count-1){
                                    item_line.path=[];
                                    item_model.clear();
                                    //control.destroy();
                                }else{
                                    item_line.removeCoordinate(index);
                                    item_model.remove(index);
                                }
                            }
                        }
                    }
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

    function appendPoint(coord){
        item_model.append({"latitudeval":coord.latitude,"longitudeval":coord.longitude});
        item_line.addCoordinate(coord);
        pointList.push(coord)
    }

    function followMouse(coord){
        if(item_line.pathLength()<=0)
            return;
        if(item_line.pathLength()===item_model.count){
            item_line.addCoordinate(coord);
        }else{
            item_line.replaceCoordinate(item_line.pathLength()-1,coord);
        }
    }

    function closePath(){
        while(item_line.pathLength()>item_model.count){
            item_line.removeCoordinate(item_line.pathLength()-1);
        }
    }
}
