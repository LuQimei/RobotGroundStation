import QtQuick 2.9
import QtQuick.Controls 2.5

ComboBox {
    property var defaultText: topText.text
    id: root
    contentItem: Text {
        id: topText
        leftPadding: 10
        text: currentText
        font.pixelSize: 20
        color: "#ffffff"
        verticalAlignment: Text.AlignVCenter  //文字位置
    }

    background: Rectangle{
        id: myBackGround
        color: "#393b40"
        border.width: !root.focus ? 1 : 2
        border.color: !root.focus ? "#4E5157" :"#3574F0"
    }

    popup: Popup {    //弹出项
        id: myPopup
        y: root.height
        width: root.width
        padding: 1
        height: root.height*(model.length)+padding*model.length
        //istView具有一个模型和一个委托。模型model定义了要显示的数据
        contentItem: ListView {   //显示通过ListModel创建的模型中的数据
            clip: true
            model: root.popup.visible ? root.delegateModel : null
        }

        background: Rectangle {
            color:  "#00000000"
            radius: 2
            border.width: 1
            border.color: "#4E5157"
        }
    }
    // 弹出框行委托
    delegate: ItemDelegate {
        id: deleg
        width: root.width
        height: root.height
        // 行字体样式
        contentItem: Text {
            text: modelData
            leftPadding: 10
            font.pixelSize: 20
            color: "#ffffff"
            verticalAlignment: Text.AlignVCenter  //文字位置
        }
        palette.text: root.palette.text
        palette.highlightedText: root.palette.highlightedText
        font.weight: root.currentIndex === index ? Font.DemiBold : Font.Normal
        highlighted: root.highlightedIndex === index
        hoverEnabled: root.hoverEnabled

        background: Rectangle {
            color:  deleg.hovered ? "#2E436E"  :  "#2B2D30"
            radius: 2
        }
    }
}
