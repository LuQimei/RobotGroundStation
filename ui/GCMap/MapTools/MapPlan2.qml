import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.12

// 一次测距里包含多个标记点以及连线
MapItemGroup{
    id: planControl
    visible: true
    property color pointColor: "yellow"
    property color textColor: "#00000000"
    property color linrColor: map.getColor(0,255,252)
    property var type: "Plan"

    property var pointList: []
    property bool planIsDrawing: false
    property var uavName: 0
    property var fromThis: true
    //    property var moving: true
    //    property var number : 0
    onPointListChanged:{

        console.log(pointList)
    }
    //获取航线总长度/米
    function getDistance(){
        return item_line.getDistanceCount()
    }

    function showPlanList(index){
        flightData.showPlanUpLoad(index)
    }

    function updatePlan(fromjson) {
        planControl.parent.updatePointsTable()
        if(fromThis) return
        item_model.clear()
        var len = item_line.pathLength()
        var coord = item_line.coordinateAt(0)
        for(var i = 0;i < len;i++){
            item_line.removeCoordinate(0)
        }

//        for(var i = 0;i < messageRegister.pointLists[uavName].length;i++){
//            item_model.append({"latitudeval":Number(messageRegister.pointLists[uavName][i].latitude),"longitudeval":Number(messageRegister.pointLists[uavName][i].longitude)});
//            coord.latitude = Number(messageRegister.pointLists[uavName][i].latitude)
//            coord.longitude = Number(messageRegister.pointLists[uavName][i].longitude)
//            item_line.addCoordinate(coord);

//            var afterCooed = i > 0 ? item_line.coordinateAt(i - 1): coord
//            var dis = afterCooed.distanceTo(coord)
//            messageRegister.pointLists[uavName][i].dis = dis
//            planUpLoad.updataTable(uavName,i)
//        }

    }

    MapPolyline {
        opacity: 0.7
        id: item_line
        line.color: linrColor
        line.width: 5
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
                color: !index ? "green" : (index === item_model.count-1) ? "red" : pointColor
                border.width: 1
                border.color: pointColor
                Rectangle{
                    anchors.fill: parent
                    width: 14
                    height: 14
                    border.color: "#00000000" //标签边框颜色
                    color: "#00000000" //标签颜色
                    Text {
                        color: index === 0 ? "white" : "black"
                        anchors.centerIn: parent
                        text: (index === item_model.count-1) ? "L" : index + 1
                    }
                    Rectangle{
                        width: 14
                        height: 14
                        anchors.fill: parent
                        border.color: textColor
                        color: "#00000000" //删除按钮颜色

                        MouseArea{
                            anchors.fill: parent
                            enabled: !planIsDrawing
                            preventStealing :true
                            onClicked: {
                                  console.log("点击了航点"+index)

                            }

                            onDoubleClicked: {
                                showPlanList(index)
                            }
                            onPressAndHold: {}
                            property point clickPos: "0,0"
                            onPressed: { //接收鼠标按下事件
                                clickPos  = Qt.point(mouse.x,mouse.y)
//                                console.log()
                                fromThis = true
                            }
                            onReleased: {

                                var mouseLocation = map.toCoordinate(Qt.point(mouseX,mouseY),false)
                                clickPos  = Qt.point(mouse.x,mouse.y)
                                console.log(mouseLocation)

                            }
                            onPositionChanged:{
                                //鼠标偏移量
                                var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
                                ietm_delegate.x = ietm_delegate.x+delta.x
                                ietm_delegate.y = ietm_delegate.y+delta.y
                                movePoint(index,Qt.point(ietm_delegate.x+parent.width/2,ietm_delegate.y+parent.height/2))
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

    function appendPoint(coord,updataTable){
        planIsDrawing = true
        item_model.append({"latitudeval":coord.latitude,"longitudeval":coord.longitude});
        item_line.addCoordinate(coord);
        if(!updataTable) return
        var afterCooed = item_model.count > 1 ? item_line.coordinateAt(item_model.count-2): coord
        var dis = afterCooed.distanceTo(coord)
        console.log(coord)
//        var angle =  messageRegister.getAngle(afterCooed.longitude,afterCooed.latitude,coord.longitude,coord.latitude)
//        var getKeys = messageRegister.haveKey(uavName)
//        if(getKeys !== 7){
//            if((getKeys & 1) !== 1)
//                messageRegister.pointLists[uavName] = []
//            if((getKeys & 2) !== 2)
//                messageRegister.selectLists[uavName] = []
//            if((getKeys & 4) !== 4)
//                messageRegister.tackPhotos[uavName] = []
//        }
//        messageRegister.selectLists[uavName].push(true)
//        messageRegister.tackPhotos[uavName].push(messageRegister.defaultTakePhoto)
//        messageRegister.pointLists[uavName].push({
//                                                     number:messageRegister.pointLists[uavName].length+1,
//                                                     latitude:coord.latitude,longitude:coord.longitude,
//                                                     altitude:messageRegister.defaultAlt,
//                                                     altitudeModel:messageRegister.defaulAltMode,
//                                                     turnModel:messageRegister.defaulTurnMode,
//                                                     VX:messageRegister.defaultVX,
//                                                     VY:messageRegister.defaultVY,
//                                                     hoverTime:messageRegister.defaulthoverTime,
//                                                     minRadius:messageRegister.defaulminRadius,
//                                                     dis:dis,
//                                                     picture:messageRegister.defaultTakePhoto ? 1 : 0,
//                                                     heading:angle,
//                                                     landPoint:0
//                                                 })

    }

    function followMouse(coord){
        //        moving = true
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
        fromThis = false
        planIsDrawing = false
    }

    function movePoint(index,point){
        var coord = map.getMouseLocation(point)
        item_line.replaceCoordinate(index,coord)//更新地图航点位置
//        var afterCooed = index > 0 ? item_line.coordinateAt(index - 1): coord
//        var nextCooed = (index === item_model.count -1) ? null :  item_line.coordinateAt(index+1)
//        var angle = messageRegister.getAngle(afterCooed.longitude,afterCooed.latitude,coord.longitude,coord.latitude)
//        var angle2 = (nextCooed === null) ? null : messageRegister.getAngle(coord.longitude,coord.latitude,nextCooed.longitude,nextCooed.latitude)
//        var dis = afterCooed.distanceTo(coord)
//        var dis2 = (nextCooed === null) ? null : coord.distanceTo(nextCooed)
//        messageRegister.pointLists[uavName][index].latitude = coord.latitude //更次航点数组
//        messageRegister.pointLists[uavName][index].longitude = coord.longitude
//        messageRegister.pointLists[uavName][index].dis = dis
//        messageRegister.pointLists[uavName][index].heading = angle
//        if(nextCooed !== null)  {
//            messageRegister.pointLists[uavName][index+1].dis = dis2
//            messageRegister.pointLists[uavName][index+1].heading = angle2
//        }
//        planUpLoad.updataTable(uavName,index)
//        if(nextCooed !== null) planUpLoad.updataTable(uavName,index+1)
    }
}
