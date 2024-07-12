import QtQuick 2.3
import QtQuick.Controls 2.0

TextField{
    id: root

    color: "#ffffff"
    font.pixelSize: 20
    background: Rectangle{
        color: "#00000000"
        border.width: !root.focus ? 1 : 2
        border.color: !root.focus ? "#4E5157" :"#3574F0"
    }
}
