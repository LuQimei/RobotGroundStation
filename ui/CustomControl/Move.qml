import QtQuick 2.3

//用来移动的
MouseArea{  //设置可以拖动没有标题的登录界面.  /*这个要放在上面，放在最下面的话，会把上面全部屏蔽掉的*/
    id: moveTitle
    property point clickPos: "0,0"  //定义一个点
    property var _window

    z: parent.z+1e2
    onPressed: {
        clickPos = Qt.point(mouseX, mouseY)
    }

    onPositionChanged: {  //属性的改变
        var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
        _window.setX(_window.x+delta.x)
        _window.setY(_window.y+delta.y)
    }

    propagateComposedEvents : true
}
