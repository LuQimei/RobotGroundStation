import QtQuick 2.0
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.0


Item {
    property var target
    property var fontColor: "#00dbd9"
    property var textTitles: ["经度：","纬度：","误差半径：", "来源：","概率：","类别：","类别概率：","区域边长："]
    property var textDatas : [target.coordinate.longitude,target.coordinate.latitude,target.difference,target.sourceId,target.probability,target.type,target.typeProbability,target.step]

    Rectangle{
        anchors{
            fill: parent
        }
        color: Qt.rgba(0,219,217, 0.1)
        clip: true
    }

    ColumnLayout{
        anchors{
            fill: parent
            topMargin:10
            bottomMargin:6
            leftMargin:6
            rightMargin:6
        }
        Repeater{
            model: textTitles
            RowLayout{
                Label {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    horizontalAlignment:  Text.AlignLeft
                    text: textTitles[index]
                    Layout.alignment:Qt.AlignLeft
                    color: fontColor
                    font.pixelSize: mainWindow.fontSize
                }
                Label {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    horizontalAlignment:   Text.AlignRight
                    text: textDatas[index]
                    Layout.alignment:Qt.AlignRight
                    color: fontColor
                    font.pixelSize: mainWindow.fontSize
                }
            }
        }
    }
}
