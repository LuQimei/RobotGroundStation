import QtQuick 2.12
import QtQuick.Controls 2.12
import QtPositioning 5.12
import QtLocation 5.15
// 计算地图连线围成面积
//import GroundControl 1.0

MapItemGroup{
    id:root
    property var _itemWidth: 22
//    property alias editPath: item_line.path
    property alias mapPolyline: item_line
    property var mapPolygon
//    property type name: value

    MapPolygon{
        id: polygon
        color: Qt.rgba(0,1,0,0.4);
        border.width: 0
        path: item_line.path
    }

    MapPolyline{
        id: item_line
        line.width: 1
        line.color: "red"
        path:mapPolygon.path
        onPathChanged: {
            console.log("run path changed")
        }
    }


    MapItemView {
        id: item_view
        add: Transition {}
        remove: Transition {}
        model: mapPolygon.path
//        visible:  item_line.path.count
        delegate: MapQuickItem {
            id: item_delegate
            width: _itemWidth
            height: _itemWidth
            anchorPoint{
                x: width / 2
                y: height / 2
            }
            coordinate: modelData
            // 添加鼠标事件处理器
            MouseArea {
                anchors.fill: parent
                drag.target: parent
                // 当鼠标释放时还原透明度
                // 当鼠标移动时更新位置

                enabled: taskManager.isGonAdjust;
                onPositionChanged: {
                        item_line.replaceCoordinate(index,coordinate)//更新地图航点位置
                        mapPolygon.adjustVertex(index,coordinate,false)
                }
            }

            // 使用sourceItem属性绘制航点外观
            sourceItem: Rectangle {
                width: item_delegate.width
                height: item_delegate.height
                radius: width / 2
                color: "white"
                border.width: 2
                border.color: "red"
                // 显示序号的文本
                Text {
                    anchors.centerIn: parent
                    text: index // 假设index是代表序号的属性或变量
                    color: "black"
                    font.pixelSize: 10
                }
                // 添加点击动画效果
                Behavior on opacity {
                    PropertyAnimation { duration: 200 }
                }

                // 当鼠标按下时设置点击动画效果
                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.opacity = 0.5
                    }
                    onReleased: {
                        parent.opacity = 1.0
                    }
                }
            }
        }
    }


    //计算方式1：https://www.cnblogs.com/c-w20140301/p/10308431.html
    //根据py代码换砖而来
    //转换为弧度
    function convertToRadian(num){
        return num*Math.PI/180;
    }
    //计算地图区域面积
    function calculatePolygonArea(path){
        let area_count=0;
        let path_len=path.length;
        if(path_len<3)
            return area_count;
        let data_list=[];
        for(let i=0;i<path_len;i++){
            area_count+=convertToRadian(path[(i+1)%path_len].longitude-path[(i)%path_len].longitude)*
                    (2+Math.sin(convertToRadian(path[(i)%path_len].latitude))+
                     Math.sin(convertToRadian(path[(i+1)%path_len].latitude)));
        }
        area_count*=6378137.0 * 6378137.0 / 2.0;
        return Math.abs(area_count);
    }

    //计算方式2：https://blog.csdn.net/zdb1314/article/details/80661602
    //应该是提取的高德api里的函数，命名应该是混淆加密之后的
    function getPolygonArea(path){
        let area_count=0;
        let path_len=path.length;
        if(path_len<3)
            return area_count;
        let data_list=[];
        //WGS84地球半径
        let sJ = 6378137;
        //Math.PI/180
        let Hq = 0.017453292519943295;
        let c = sJ *Hq;
        for(let i=0;i<path_len-1;i++){
            let h=path[i];
            let k=path[i+1];
            let u=h.longitude*c*Math.cos(h.latitude*Hq);
            let hhh=h.latitude*c;
            let v=k.longitude*c*Math.cos(k.latitude*Hq);
            area_count+=(u*k.latitude*c-v*hhh);
        }
        let eee=path[path_len-1].longitude*c*Math.cos(path[path_len-1].latitude*Hq);
        let g2=path[path_len-1].latitude*c;
        let k=path[0].longitude*c*Math.cos(path[0].latitude*Hq);
        area_count+=eee*path[0].latitude*c-k*g2;

        return Math.round(Math.abs(area_count)/2);
    }
}
