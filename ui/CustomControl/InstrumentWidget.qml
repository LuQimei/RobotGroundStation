import QtQuick 2.15
import QtQuick.Layouts 1.15


ColumnLayout {
    id:         root
    spacing:    10 / 4

    property real   _innerRadius:           (width - (_topBottomMargin * 3)) / 4
    property real   _outerRadius:          _innerRadius + _topBottomMargin
    property real   _spacing:               10 * 0.33
    property real   _topBottomMargin:       (width * 0.05) / 2



    Rectangle {
        id:                 visualInstrument
        height:             _outerRadius * 2
        Layout.fillWidth:   true
        radius:             _outerRadius
        color:              "#222222"//"black"//qgcPal.window"#222222""#ffffff"

        DeadMouseArea { anchors.fill: parent }

        LGCAttitudeWidget {
            id:                     attitude
            anchors.leftMargin:     _topBottomMargin
            anchors.left:           parent.left
            size:                   _innerRadius * 2
//            vehicle:                globals.activeVehicle
            anchors.verticalCenter: parent.verticalCenter
        }
        LGCCompassWidget {
            id:                     compass
            anchors.leftMargin:     _spacing+4
            anchors.left:           attitude.right
            size:                   _innerRadius * 2
            anchors.verticalCenter: parent.verticalCenter
        }
    }

//    TerrainProgress {
//        Layout.fillWidth: true
//    }
}
