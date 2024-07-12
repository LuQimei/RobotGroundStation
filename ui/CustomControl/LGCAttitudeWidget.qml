import QtQuick              2.3
import QtGraphicalEffects   1.0

import GroundControl 1.0



Item {
    id: root

    property bool showPitch:    true
//    property var  vehicle:      null
    property real size
    property bool showHeading:  false//RovVehicle.isConnect ? true : false

    property var _multiVehicleManager: GroundControl.multiVehicleManager
    property var _rovVehicle: _multiVehicleManager.rovVehicle

    property real _rollAngle: _rovVehicle.isConnect ? _rovVehicle.rollAngle : 0//RovVehicle.isConnect ? RovVehicle.rollAngle  : 0
    property real _pitchAngle: _rovVehicle.isConnect ? _rovVehicle.pitchAngle : 0//RovVehicle.isConnect ? RovVehicle.pitchAngle : 0

    width: size
    height: size



    Item {
        id:             instrument
        anchors.fill:   parent
        visible:        false

        //----------------------------------------------------
        //-- Artificial Horizon
        LGCArtificialHorizon {
            rollAngle:          _rollAngle
            pitchAngle:         _pitchAngle
            anchors.fill:       parent
        }
        //----------------------------------------------------
        //-- Pointer
        Image {
            id:                 pointer
            source:             "qrc:/ui/Images/LGC/attitudePointer.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
        }
        //----------------------------------------------------
        //-- Instrument Dial
        Image {
            id:                 instrumentDial
            source:             "qrc:/ui/Images/LGC/attitudeDial.svg"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            anchors.fill:       parent
            sourceSize.height:  parent.height
            transform: Rotation {
                origin.x:       root.width  / 2
                origin.y:       root.height / 2
                angle:          -_rollAngle
            }
        }
        //----------------------------------------------------
        //-- Pitch
        LGCPitchIndicator {
            id:                 pitchWidget
            visible:            root.showPitch
            size:               root.size * 0.5
            anchors.verticalCenter: parent.verticalCenter
            pitchAngle:         _pitchAngle
            rollAngle:          _rollAngle
            color:              Qt.rgba(0,0,0,0)
        }
        //----------------------------------------------------
        //-- Cross Hair
        Image {
            id:                 crossHair
            anchors.centerIn:   parent
            source:             "qrc:/ui/Images/LGC/crossHair.svg"
            mipmap:             true
            width:              size * 0.75
            sourceSize.width:   width
            fillMode:           Image.PreserveAspectFit
        }
    }

    Rectangle {
        id:             mask
        anchors.fill:   instrument
        radius:         width / 2
        color:          "#222222"
        visible:        false
    }

    OpacityMask {
        anchors.fill: instrument
        source: instrument
        maskSource: mask
    }
    //轮廓?
    Rectangle {
        id:             borderRect
        anchors.fill:   parent
        radius:         width / 2
        color:          Qt.rgba(0,0,0,0)
        border.color:   "#d8d8d8"//"white" //qgcPal.text
        border.width:   1
    }

    LGCLabel {
        anchors.bottomMargin:       Math.round(10 * .75)
        anchors.bottom:             parent.bottom
        anchors.horizontalCenter:   parent.horizontalCenter
        text:                       _headingString3
        color:                      "white"
        visible:                    showHeading

        property string _headingString: "OFF"//GroundControl.rovVehicle.isConnect ? rovVehicle.heading.toFixed(0)  : "OFF" //RovVehicle.isConnect ? RovVehicle.heading.toFixed(0) : "OFF"
        property string _headingString2: _headingString.length === 1 ? "0" + _headingString : _headingString
        property string _headingString3: _headingString2.length === 2 ? "0" + _headingString2 : _headingString2
    }
}
