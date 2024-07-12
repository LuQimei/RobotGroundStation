import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12
import QtPositioning 5.12


MapItemGroup{
    id:myIcon
    width: 40
    height: 40

    property alias myImage: image
    property alias rotation: image.rotation
    property double locationx: -myIcon.width/2
    property double locationy: -myIcon.height/2
    property double heading : 0
    property var myName: 1
    property var image_source: ""
    property var showText: false

    MapItemView{
        id:myItemView
        anchors.fill: parent
        add: Transition {}
        remove: Transition {}
        model: ListModel{
            id: my_model
        }
        Image { //图标
            id: image
            x: myIcon.locationx
            y: myIcon.locationy
            width: myIcon.width
            height: myIcon.height
            fillMode: Image.PreserveAspectFit
            source: image_source
            rotation:heading//旋转图片

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    vehicleStateVisible = !vehicleStateVisible
                }
            }
        }
        Text {
            id: myNumber
            color: "#f3fa2b"
            x:(parent.width-myNumber.width)/2 + myIcon.locationx
            y:(parent.height-myNumber.height)/2 + myIcon.locationy
            text: qsTr(myName)
            font.pointSize: 20
            styleColor: "#e9f850"
            visible: showText
        }
    }


}
