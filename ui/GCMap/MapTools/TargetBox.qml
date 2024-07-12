import QtQuick 2.0
import QtPositioning 5.12
import QtLocation 5.12
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.12

import GroundControl 1.0

MapItemGroup{
    id:_root
    property var target
    property var multiVehicleManager : GroundControl.multiVehicleManager
    property var vehicleTypes: ["rov","carryUav"]
    property var hitVehicles : GroundControl.multiVehicleManager.getVehiclesByType(vehicleTypes)

    visible: true
    width: 30
    height: width

    MapQuickItem{
        id: targetItem
        sourceItem: Rectangle{
            x: -width/2
            y: -width/2
            width: 30
            height: width
            color: "red"
            radius: width/2
            Text{
                anchors.fill: parent
                text: target.name
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: mainWindow.fontSize
//                color: "#00dbd9"
            }
            TargetDatas{
                id: targetDatas
                visible: false
                anchors.left: parent.right
                anchors.bottom: parent.top
                width: 200
                height: 200
                target:_root.target
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    targetDatas.visible = !targetDatas.visible


                }

            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                enabled: mainWindow.mainWindowState === "MuBiaoDaJi" ? true : false
                onClicked: {
                    myLayout.visible = !myLayout.visible
                }
            }

            ColumnLayout{
                id: myLayout
                anchors.top: parent.bottom
                anchors.left: parent.right
                visible: false
                Repeater{
                    model: hitVehicles
                    Button{
                        text: "下发"+object.vehicleName
                        onClicked: {
                            object.automatic(object.id, target.coordinate.longitude, target.coordinate.latitude, target.step)
                            myLayout.visible = false
                        }
                    }
                }
            }
        }
        coordinate : target.coordinate//QtPositioning.coordinate(target.coordinate.longitude, target.coordinate.latitude)
    }

    MapCircle{
        center: target.coordinate
        radius: target.difference
        color: "yellow"
        opacity: 0.1
    }

    MapPolygon{
        id: polygon
        color: Qt.rgba(0,1,0,0.2);
        border.width: 0
        path: item_line.path
        visible: mainWindow.mainWindowState === "MuBiaoDaJi" ? true : false
    }

    MapPolyline{
        id: item_line
        line.width: 1
        line.color: "yellow"
        path: target.path
        visible: mainWindow.mainWindowState === "MuBiaoDaJi" ? true : false
    }


//    id:target_box
//    property var lat: 0
//    property var lon: 0
//    property var m_name: "1"
//    property var image: "qrc:/image/mapfeaturesframe/target.png"
//    property var heading: 0
//    property var type: "TargetIcon"
//    property bool pointMove: false

//    property var alt: 0
//    property var radius: 0
//    property var time: 0
//    property var direction: 0
//    property var mode: 0
//    property var speed: 0
//    width: 411
//    height: 200

//    onAltChanged: { target_box.parent.saveTarget = false }
//    onLatChanged: { target_box.parent.saveTarget = false }
//    onLonChanged: { target_box.parent.saveTarget = false }
//    onRadiusChanged: { target_box.parent.saveTarget = false }
//    onTimeChanged: { target_box.parent.saveTarget = false }
//    onDirectionChanged: { target_box.parent.saveTarget = false }
//    onModeChanged: { target_box.parent.saveTarget = false }
//    onSpeedChanged: { target_box.parent.saveTarget = false }

//    function resetImage(){
//        target_Icon.image_source = image
//    }

//    sourceItem: Rectangle{
//        Image {
//            id: valueBox
//            source: "qrc:/image/numberturnsframe/numberturnsframebackground.png"
//            MouseArea{
//                x:parent.width-25
//                y:0
//                height: 25
//                width: 25
//                onClicked: {
//                    valueBox.visible = false
//                    target_box.width = 30
//                    target_box.height = 30
//                }
//            }

//            Text{
//                id:targetTitleText
//                x:25
//                y:10
//                text: "目标点设置"
//                font.pointSize: 14
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter

//            }

//            Text{
//                id:latText
//                width: 60
//                height: 20
//                x:(parent.width/7)*1-(latText.width/2)
//                y:(parent.height-50)/5*1 - (latText.height/2) +25
//                font.pointSize: 12
//                text: "经度："
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Text{
//                id:latValue
//                width: 100
//                height: 20
//                x:(parent.width/7)*2-(latValue.width/2) + 20
//                y:(parent.height-50)/5*1 - (latValue.height/2) +27
//                font.pointSize: 12
//                text: lat.toFixed(6)
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Text{
//                id:lngText
//                width: 60
//                height: 20
//                x:(parent.width/7)*4-(lngText.width/2)
//                y:(parent.height-50)/5*1 - (lngText.height/2) +25
//                font.pointSize: 12
//                text: "纬度："
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Text{
//                id:lngValue
//                width: 100
//                height: 20
//                x:(parent.width/7)*5-(lngValue.width/2) + 20
//                y:(parent.height-50)/5*1 - (lngValue.height/2) +27
//                font.pointSize: 12
//                text: lon.toFixed(6)
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Text{
//                id:altText
//                width: 60
//                height: 20
//                x:(parent.width/7)*1-(latText.width/2)
//                y:(parent.height-50)/5*2 - (latText.height/2) +25
//                font.pointSize: 12
//                text: "高度："
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Image{
//                width: 100
//                height: 20
//                fillMode: Image.Stretch
//                x:(parent.width/7)*2-(latText.width/2)
//                y:(parent.height-50)/5*2 - (latText.height/2) +25
//                source: "qrc:/image/buttonborder.png"
//                TextInput{
//                    id:altValue
//                    anchors.fill: parent
//                    font.pointSize: 12
//                    text: alt
//                    verticalAlignment: Text.AlignVCenter
//                    color:"#00dbd9"
//                    horizontalAlignment: Text.AlignHCenter
//                }
//            }

//            Text{
//                id:radiusText
//                width: 60
//                height: 20
//                x:(parent.width/7)*4-(latText.width/2)
//                y:(parent.height-50)/5*2 - (latText.height/2) +25
//                font.pointSize: 12
//                text: "半径："
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Image{
//                width: 100
//                height: 20
//                fillMode: Image.Stretch
//                x:(parent.width/7)*5-(latText.width/2)
//                y:(parent.height-50)/5*2 - (latText.height/2) +25
//                source: "qrc:/image/buttonborder.png"
//                TextInput{
//                    id:radiusValue
//                    anchors.fill: parent
//                    font.pointSize: 12
//                    text: radius
//                    verticalAlignment: Text.AlignVCenter
//                    color:"#00dbd9"
//                    horizontalAlignment: Text.AlignHCenter
//                }
//            }

//            Text{
//                id:timeText
//                width: 60
//                height: 20
//                x:(parent.width/7)*1-(latText.width/2)
//                y:(parent.height-50)/5*3 - (latText.height/2) +25
//                font.pointSize: 12
//                text: "时间："
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Image{
//                width: 100
//                height: 20
//                fillMode: Image.Stretch
//                x:(parent.width/7)*2-(latText.width/2)
//                y:(parent.height-50)/5*3 - (latText.height/2) +25
//                source: "qrc:/image/buttonborder.png"
//                TextInput{
//                    id:timeValue
//                    anchors.fill: parent
//                    font.pointSize: 12
//                    text: time
//                    verticalAlignment: Text.AlignVCenter
//                    color:"#00dbd9"
//                    horizontalAlignment: Text.AlignHCenter
//                }
//            }

//            Text{
//                id:speedText
//                width: 60
//                height: 20
//                x:(parent.width/7)*4-(latText.width/2)
//                y:(parent.height-50)/5*3 - (latText.height/2) +25
//                font.pointSize: 12
//                text: "速度："
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Image{
//                width: 100
//                height: 20
//                fillMode: Image.Stretch
//                x:(parent.width/7)*5-(latText.width/2)
//                y:(parent.height-50)/5*3 - (latText.height/2) +25
//                source: "qrc:/image/buttonborder.png"
//                TextInput{
//                    id:speedValue
//                    anchors.fill: parent
//                    font.pointSize: 12
//                    text: speed
//                    verticalAlignment: Text.AlignVCenter
//                    color:"#00dbd9"
//                    horizontalAlignment: Text.AlignHCenter
//                }
//            }

//            Text{
//                id:directionText
//                width: 60
//                height: 20
//                x:(parent.width/7)*1-(latText.width/2)
//                y:(parent.height-50)/5*4 - (latText.height/2) +25
//                font.pointSize: 12
//                text: "方向："
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Image{
//                width: 100
//                height: 20
//                fillMode: Image.Stretch
//                x:(parent.width/7)*2-(latText.width/2)
//                y:(parent.height-50)/5*4 - (latText.height/2) +25
//                source: "qrc:/image/buttonborder.png"
//                TextInput{
//                    id:directionValue
//                    anchors.fill: parent
//                    font.pointSize: 12
//                    text: direction
//                    verticalAlignment: Text.AlignVCenter
//                    color:"#00dbd9"
//                    horizontalAlignment: Text.AlignHCenter
//                }
//            }

//            Text{
//                id:modeText
//                width: 60
//                height: 20
//                x:(parent.width/7)*4-(latText.width/2)
//                y:(parent.height-50)/5*4 - (latText.height/2) +25
//                font.pointSize: 12
//                text: "盘旋模式："
//                verticalAlignment: Text.AlignVCenter
//                color:"#00dbd9"
//                horizontalAlignment: Text.AlignHCenter
//            }

//            Image{
//                width: 100
//                height: 20
//                fillMode: Image.Stretch
//                x:(parent.width/7)*5-(latText.width/2)
//                y:(parent.height-50)/5*4 - (latText.height/2) +25
//                source: "qrc:/image/buttonborder.png"
//                TextInput{
//                    id:modeValue
//                    anchors.fill: parent
//                    font.pointSize: 12
//                    text: mode
//                    verticalAlignment: Text.AlignVCenter
//                    color:"#00dbd9"
//                    horizontalAlignment: Text.AlignHCenter
//                }
//            }

//            Image{
//                id:pushButton
//                width: 120
//                height: 25
//                fillMode: Image.Stretch
//                x:(parent.width/7)*3-(latText.width/2)
//                y:(parent.height-50)/5*5 - (latText.height/2) +20
//                source: "qrc:/image/flightbutton/planningbutton.png"
//                Text{
//                    anchors.fill: parent
//                    color:"#00dbd9"
//                    text:"确定"
//                    verticalAlignment: Text.AlignVCenter
//                    horizontalAlignment: Text.AlignHCenter
//                }
//                MouseArea{
//                    anchors.fill: parent

//                    onEntered: {
//                        pushButton.source = "qrc:/image/flightbutton/planningbutton1.png"
//                    }

//                    onExited: {
//                        pushButton.source = "qrc:/image/flightbutton/planningbutton.png"
//                    }
//                    onClicked: {
//                        alt = Number(altValue.text)
//                        radius = Number(radiusValue.text)
//                        time = Number(timeValue.text)
//                        direction = Number(directionValue.text)
//                        mode = Number(modeValue.text)
//                        speed = Number(speedValue.text)
//                        target_box.parent.targetPoint = {type:0,lat:lat,lon:lon,alt:alt,radius:radius,time:time,direction:direction,mode:mode,speed:speed}
//                        valueBox.visible = false
//                        target_box.width = 30
//                        target_box.height = 30
//                        target_box.parent.saveTarget = true
//                    }
//                }
//            }


//        }

//        MyIcon{
//            id:target_Icon
//            width: 30
//            height: 30
//            heading: target_box.heading
//            myName: m_name.toString()
//            image_source: image
//            showText: false
//            MouseArea{
//                x:parent.x-parent.width/2
//                y:parent.y-parent.height/2
//                width: parent.width
//                height: parent.height
//                preventStealing :true
//                onDoubleClicked: {
//                    valueBox.visible = true
//                    target_box.width = 411
//                    target_box.height = 200
//                }
//                onClicked: {
//                    target_box.parent.moveIconType = type
//                    target_box.parent.selectTarget = 1

//                }
//                property point clickPos: "0,0"
//                onPressed: { //接收鼠标按下事件
//                    clickPos  = Qt.point(mouse.x,mouse.y)
//                }
//                onPositionChanged:{
//                    //鼠标偏移量
//                    var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
//                    target_box.x = target_box.x+delta.x
//                    target_box.y = target_box.y+delta.y
//                    movePoint(Qt.point(target_box.x,target_box.y))
//                }
//            }
//        }
//    }
//    coordinate {
//        latitude: lat
//        longitude: lon
//    }

//    function movePoint(point){
//        var coord = parent.getMouseLocation(point)
//        lat = coord.latitude
//        lon = coord.longitude
//    }
}
