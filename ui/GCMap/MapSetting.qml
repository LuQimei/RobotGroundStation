import QtQuick 2.4
import QtQuick.Layouts 1.0

import QtQuick.Controls 1.4
import QtLocation 5.12


Rectangle{
    id:_root
    border.width: 2
    border.color: "black"
    color: Qt.rgba(0,0,0,0)

    property var mapModeList: ["Null","mission","uav"]

    property int mapMode: 0//：默认 1：画航点 2:画飞机
    property Map mapControl: null

//    property var supportedMapTypes: mapControl.supportedMapTypes


//    function getMapTypeList(){
//        var mapTypeList=[]
//        for(var i=0;i<supportedMapTypes.length;++i){
//            mapTypeList.push(supportedMapTypes[i].name)
//        }

////        console.log(mapTypeList)

//        return mapTypeList
//    }

//    function getMapTypeIndex(maptype){
//        for(var i=0;i<supportedMapTypes.length;++i){
//            if (supportedMapTypes[i].name == maptype){
//                return i;
//            }
//        }
//        return -1;
//    }

    Image {
        anchors.fill: parent
        source: "qrc:/images/images/dialog/setbackground.png"
    }
    GridLayout{
        anchors.fill: parent

        columns: 2
        Text {
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: qsTr("map Mode")
        }
        ComboBox {
            id:mapModelListCb
            model:                  mapModeList
//            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            currentIndex: mapMode
            onCurrentIndexChanged:{
                mapMode=currentIndex
            }

        }

//        Text {
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            text: qsTr("map Type")
//        }

//        ComboBox {
//            id:mapTypeCb
//            model:   getMapTypeList()
////            Layout.fillHeight: true
//            Layout.fillWidth: true
//            Layout.preferredHeight: 20
//            onCurrentIndexChanged:{
//                console.log("select Type: " + currentText)
//                var index = getMapTypeIndex(currentText)
//                mapControl.activeMapType=supportedMapTypes[index==-1?0:index]
//            }
//            Component.onCompleted: {

//                mapTypeCb.currentIndex=getMapTypeIndex(mapControl.activeMapType.name)
//            }
//        }

    }


}
