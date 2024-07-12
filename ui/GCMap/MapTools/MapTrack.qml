import QtLocation 5.12
import QtPositioning 5.12
import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4

// 一次测距里包含多个标记点以及连线
MapItemGroup{
    id: rulerConlor
    property color pointColor: "yellow"
    property var type: "Track"
    property var uavNamelist: {"0":[]}
    property var uavNameIndex: {"0":0}
    property var maxLen: 1000
    property var index: 0

    property var coordinate: []

    ListModel {
        id: lineList
    }

    MapItemView{
        id :planTable
        anchors.fill: parent
        model: lineList

        delegate: MapPolyline{
            id:trackline
            line.color: "yellow"
            line.width: 10
            property var uavName : ""
            property var uavIndex : uavNameIndex[uavName]

            property var listPoint : []
//            path: lineList.get(trackline.uavIndex).locations.list
            path: coordinate
        }
    }

    function clearTrack(uavName){
        if(uavName === ""){
            rulerConlor.uavNamelist = {}
        }
        else{
            rulerConlor.uavNamelist[uavName] = []
        }
    }

    function addTrackPoint(coor){
        console.log("lat "+coor.latitude + "         lng " + coor.longitude)

        coordinate.push(coor);
        lineList.clear();
        lineList.append({"locations": coor})
    }

    function addLinePoint(uavName,lat,lng){
        console.log("uavName: "+ uavName + "             lat "+lat+ "         lng " + lng)

        if(!haveKey(uavName)){
            rulerConlor.uavNamelist[uavName] = []
            rulerConlor.uavNameIndex[uavName] = index
            lineList.append({"locations":{"list":rulerConlor.uavNamelist[uavName]}})
            index++
        }

        if(!getlinelist(uavName,lat,lng)){
            var number = 0
            for(var v in planTable.children){
                if(planTable.children[number].uavName === ""){
                    planTable.children[number].uavName = uavName
                }
            }
        }

        rulerConlor.uavNamelist[uavName].push({latitude: lat, longitude: lng })
        if(uavNamelist[uavName].length >= maxLen)
        {
            rulerConlor.uavNamelist[uavName].shift()
        }
        var list = {"list":rulerConlor.uavNamelist[uavName]}
        lineList.setProperty(0,"locations",list)
    }

    function haveKey(getkey){
        for(var key in uavNamelist){
            if(key === getkey)
                return true
        }
        return false
    }

    function getlinelist(uavName,lat,lng){
        var number = 0
        for(var v in planTable.children){
            if(planTable.children[number].uavName === uavName){
                return true
            }
            number++
        }
        return false
    }

}
