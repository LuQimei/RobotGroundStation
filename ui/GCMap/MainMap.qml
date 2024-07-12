import QtQuick 2.0
import QtQuick.Controls 2.0
import QtPositioning 5.12
import QtLocation 5.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import "MapTools"
import GroundControl 1.0

Item{
    id:root
    //--------------------------public variable
    property var mouseLng: 0 //鼠标经度
    property var mouseLat: 0 //鼠标纬度

    property var planList: []
    property var multiVehicleManager: GroundControl.multiVehicleManager
    property var taskManager: GroundControl.taskManager
    //    property var mapMode: taskManager.mapMode

    property var missionVehicle: null
    property alias mapCenter: map.center
    property alias mapZoomLevel: map.zoomLevel
    //--------------------------public function

    //设置地图中心点
    function setMapCenter(coordinate) {
        map.center = coordinate
    }

    function printWaypointList() {
        if (planList.length >= 1) {
            console.log("planList is not null")
            planList[planList.length - 1].getWaypointList()
        } else {

            console.log("planList is null")
        }
    }

    //--------------------------private function



    //更新航线选择cb的model
    function updateCBplanList() {
        var newModel = []
        for (var i = 0; i < planList.length; ++i) {
            newModel.push("index :" + i)
        }
        //        mainWindow.missionSelector.planList = newModel
    }

    //--------------------------private variable

    property var mapPlanList : []


    //移除测量距离和测量面积
    function removeItemGroup(type) {
        var i = 0
        for (var v in map.children) {
            if ((map.children[i].type === type)) {
                map.removeMapItemGroup(map.children[i])
            } else
                i++
        }

        i = 0
        for (var v in map.children) {
            if ((map.children[i].type === type)) {
                map.removeMapItemGroup(map.children[i])
            } else
                i++
        }
        i = 0
        for (var v in map.children) {
            if ((map.children[i].type === type)) {
                map.removeMapItemGroup(map.children[i])
            } else
                i++
        }
    }

    //清除所有航线
    function clearAllPlan() {
        removeItemGroup('Mission')
        removeItemGroup("Plan")
        planList = []
        updateCBplanList()
        taskManager.mapMode=0
        currentPlan=null
    }

    //添加航线
    onPlanListChanged: {
        if (planList.length > 0)
            map.addMapItemGroup(planList[planList.length - 1])
    }

    Map {
        id: map
        anchors.fill: parent
        zoomLevel: GroundControl.settingManager.zoom
        center: QtPositioning.coordinate(GroundControl.settingManager.lat,
                                         GroundControl.settingManager.lng) //初始化地图中心坐标
        maximumZoomLevel: GroundControl.settingManager.maxZoom

        //--------------------------public function
        function getMouseLocation(point) {
            var location = map.toCoordinate(point, false)
            mouseLat = location.latitude
            mouseLng = location.longitude
            return location
        }

        //----------------------------init Comp
        Component.onCompleted: {
            console.log("Map: Component.onCompleted")
        }

        plugin: Plugin {
            id: mymapPlugin
//            name: "osm"
            name:"amap"

        }
        activeMapType: supportedMapTypes[2]
        //-----------------------------mouse action
        MouseArea {
            id: map_mouse
            anchors.fill: map
            //画了一个点后跟随鼠标，除非双击
            hoverEnabled: true
            enabled: GroundControl.multiVehicleManager.isDrawingPlan
            propagateComposedEvents:true
            onClicked: {
                var coordinate = map.toCoordinate(
                            Qt.point(mouseX, mouseY), false)
                GroundControl.multiVehicleManager.plan.appendVertex(coordinate)
                console.log(coordinate)
            }
        }

        MapItemView{
            model: 1
            delegate: MapVehicle{
                vehicle: GroundControl.multiVehicleManager.rovVehicle
            }
        }

        MapItemView{
            model: 1
            delegate: MapPlan{
                mapPolyline: GroundControl.multiVehicleManager.plan
            }
        }
    }
}
