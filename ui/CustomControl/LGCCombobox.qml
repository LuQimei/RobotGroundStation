import QtQuick 2.3
import QtQuick.Controls 2.15

ComboBox {
    id: myCombobox
    property var displayData
    currentIndex: 0
    model: displayData
    width: 120

//    background: Rectangle{
//        radius: 10
//        implicitHeight: myCombobox.height
//    }
    onCurrentTextChanged: console.log(currentText)
}
