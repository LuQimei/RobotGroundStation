import QtQuick              2.3
import QtGraphicalEffects   1.0

import GroundControl 1.0

Item {
    id:     root
    width:  size
    height: size

    property real size:     _defaultSize
    property bool arrowVisible : GroundControl.multiVehicleManager.rovVehicle.isConnect ? true : false//RovVehicle.isConnect ? true : false
//    property var  vehicle:  null

//    property var  _activeVehicle:       QGroundControl.multiVehicleManager.activeVehicle
    property real _defaultSize:         20 * 10
//    property real _sizeRatio:           ScreenTools.isTinyScreen ? (size / _defaultSize) * 0.5 : size / _defaultSize
    property int  _fontSize:            10
//    property real _heading:             vehicle ? vehicle.heading.rawValue : 0
    property real _heading:             GroundControl.multiVehicleManager.rovVehicle.isConnect ? GroundControl.multiVehicleManager.rovVehicle.yawAngle : 0//RovVehicle.yawAngle


    //表盘的轮廓和内部填充色
    Rectangle {
        id:             borderRect
        anchors.fill:   parent
        radius:         width / 2
        color:          "#222222"//"black"//"transparent"
        border.color:   "#d8d8d8"//"#9d9d9d"
        border.width:   1
    }

    Item {
        id:             instrument
        anchors.fill:   parent
        visible:        arrowVisible//false

        Image {
            id:                 pointer
            width:              size * 0.65
            source:             GroundControl.multiVehicleManager.rovVehicle.isConnect ? "qrc:/ui/Images/LGC/compassInstrumentArrow.svg" : ""//RovVehicle.isConnect ? "qrc:/ui/Images/LGC/compassInstrumentArrow.svg" : ""

            mipmap:             true
            sourceSize.width:   width
            fillMode:           Image.PreserveAspectFit
            anchors.centerIn:   parent
            transform: Rotation {
                origin.x:       pointer.width  / 2
                origin.y:       pointer.height / 2
                angle:         _heading// 2 > 1 ? _heading : 0
            }
        }


        LGCColoredImage {
            id:                 compassDial
            source:             "qrc:/ui/Images/LGC/compassInstrumentDial.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
            color:              "#d8d8d8"//qgcPal.text
//            transform: Rotation {
//                origin.x:       compassDial.width  / 2
//                origin.y:       compassDial.height / 2
//                angle:          isNoseUpLocked()?-_heading:0
//            }
        }

        //OFF指示
        Rectangle {
            anchors.centerIn:   parent
            width:              size * 0.35
            height:             size * 0.2
            border.color:       "#bdbdbd"//"white"//qgcPal.text
            border.width: 2
            color:              "#bdbdbd"//"transparent"//"#bdbdbd"//qgcPal.window
            opacity:            0.65

            LGCLabel {
                text:               _headingString3
                font.family:        "Consolas"
                font.pointSize:     _fontSize < 8 ? 8 : _fontSize;
                color:              "green"//qgcPal.text
                anchors.centerIn:   parent

                property string _headingString: GroundControl.multiVehicleManager.rovVehicle.isConnect ? _heading.toFixed(0) : "OFF"
                property string _headingString2: _headingString.length === 1 ? "0" + _headingString : _headingString
                property string _headingString3: _headingString2.length === 2 ? "0" + _headingString2 : _headingString2
            }
        }
    }

    Rectangle {
        id:             mask
        anchors.fill:   instrument
        radius:         width / 2
        color:          "black"
        visible:        false
    }

    OpacityMask {
        anchors.fill:   instrument
        source:         instrument
        maskSource:     mask
    }

}
