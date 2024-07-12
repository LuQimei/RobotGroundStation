import QtQuick 2.3

Item {
    property var myZ
    property var _window
    //向左拖动
    MouseArea{  //设置可以拖动没有标题的登录界面.  /*这个要放在上面，放在最下面的话，会把上面全部屏蔽掉的*/
        id:leftSizeChange;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        width: 10;
        z: myZ
        property point clickPos: "0,0"  //定义一个点
        cursorShape:Qt.SizeHorCursor
        onPressed: {
            clickPos = Qt.point(mouseX, mouseY)
        }

        onPositionChanged: {  //属性的改变
            var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
            if((_window.width-delta.x)>_window.minimumWidth)
            {
               _window.setX(_window.x+delta.x)
               _window.setWidth(_window.width-delta.x)
            }
            else
                _window.setWidth(_window.minimumWidth)
            _window.showNormal()
        }
    }
    //向右拖动
    MouseArea{  //设置可以拖动没有标题的登录界面.  /*这个要放在上面，放在最下面的话，会把上面全部屏蔽掉的*/
        id:rightSizeChange;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        anchors.right: parent.right;
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        width: 10;
        z: myZ
        property point clickPos: "0,0"  //定义一个点
        cursorShape:Qt.SizeHorCursor
        onPressed: {
            clickPos = Qt.point(mouseX, mouseY)
        }

        onPositionChanged: {  //属性的改变
            var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
            if((_window.width+delta.x)>_window.minimumWidth)
            {
               _window.setWidth(_window.width+delta.x)
            }
            else
                _window.setWidth(_window.minimumWidth)
            _window.showNormal()
        }
    }

    //向上拖动
    MouseArea{  //设置可以拖动没有标题的登录界面.  /*这个要放在上面，放在最下面的话，会把上面全部屏蔽掉的*/
        id:topSizeChange;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        height: 10;
        z: myZ
        propagateComposedEvents : true

        property point clickPos: "0,0"  //定义一个点
        cursorShape:Qt.SizeVerCursor
        onPressed: {
            clickPos = Qt.point(mouseX, mouseY)
        }

        onPositionChanged: {  //属性的改变
            var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
            if((_window.height-delta.y)>_window.minimumHeight){
                _window.setY(_window.y+delta.y)
                _window.setHeight(_window.height-delta.y)
            }
            else
                _window.setHeight(_window.minimumHeight)
            _window.showNormal()
        }
    }
    //向下拖动
    MouseArea{  //设置可以拖动没有标题的登录界面.  /*这个要放在上面，放在最下面的话，会把上面全部屏蔽掉的*/
        id:downSizeChange;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        height: 10;
        z: myZ
        property point clickPos: "0,0"  //定义一个点
        cursorShape:Qt.SizeVerCursor
        onPressed: {
            clickPos = Qt.point(mouseX, mouseY)
        }

        onPositionChanged: {  //属性的改变
            var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
            if((_window.height+delta.y)>_window.minimumHeight)
                _window.height += delta.y
            else
                _window.setHeight(_window.minimumHeight)
            _window.showNormal()
        }
    }

    //左上角
    MouseArea{
        anchors.top: parent.top
        anchors.left: parent.left
        width: 10
        height: 10
        z: myZ
        property point clickPos: "0,0"  //定义一个点
        cursorShape:Qt.SizeFDiagCursor
        onPressed: {
            clickPos = Qt.point(mouseX, mouseY)
        }
        propagateComposedEvents : true

        onPositionChanged: {  //属性的改变
            var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
            if((_window.width-delta.x)<=_window.minimumWidth && (_window.height-delta.y)<=_window.minimumHeight){
                _window.setWidth(_window.minimumWidth)
                _window.setHeight(_window.minimumHeight)
            }else if((_window.width-delta.x)>_window.minimumWidth && (_window.height-delta.y)<=_window.minimumHeight){
                _window.setX(_window.x+delta.x)
                _window.setWidth(_window.width-delta.x)
                _window.setHeight(_window.minimumHeight)
            }else if((_window.width-delta.x)<=_window.minimumWidth && (_window.height-delta.y)>_window.minimumHeight){
                _window.setY(_window.y+delta.y)
                _window.setHeight(_window.height-delta.y)
                _window.setWidth(_window.minimumWidth)
            }else{
                _window.setX(_window.x+delta.x)
                _window.setY(_window.y+delta.y)
                _window.setWidth(_window.width-delta.x)
                _window.setHeight(_window.height-delta.y)
            }
            _window.showNormal()
        }
    }

    //左下角
    MouseArea{
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 10
        height: 10
        z: myZ
        property point clickPos: "0,0"  //定义一个点
        cursorShape:Qt.SizeBDiagCursor
        onPressed: {
            clickPos = Qt.point(mouseX, mouseY)
        }

        onPositionChanged: {  //属性的改变
            var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
            if((_window.width-delta.x)<=_window.minimumWidth && (_window.height+delta.y)<=_window.minimumHeight){
                _window.setWidth(_window.minimumWidth)
                _window.setHeight(_window.minimumHeight)
            }else if((_window.width-delta.x)>_window.minimumWidth && (_window.height+delta.y)<=_window.minimumHeight){
                _window.setX(_window.x+delta.x)
                _window.setWidth(_window.width-delta.x)
                _window.setHeight(_window.minimumHeight)
            }else if((_window.width-delta.x)<=_window.minimumWidth && (_window.height+delta.y)>_window.minimumHeight){
                _window.setHeight(_window.height + delta.y)
                _window.setWidth(_window.minimumWidth)
            }else{
                _window.setX(_window.x+delta.x)
                _window.setWidth(_window.width-delta.x)
                _window.setHeight(_window.height + delta.y)
            }
            _window.showNormal()
        }
    }

    //右下角
    MouseArea{
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 10
        height: 10
        z: myZ
        property point clickPos: "0,0"  //定义一个点
        cursorShape:Qt.SizeFDiagCursor
        onPressed: {
            clickPos = Qt.point(mouseX, mouseY)
        }

        onPositionChanged: {  //属性的改变
            var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
            if((_window.width+delta.x)<=_window.minimumWidth && (_window.height+delta.y)<=_window.minimumHeight){
                _window.setWidth(_window.minimumWidth)
                _window.setHeight(_window.minimumHeight)
            }else if((_window.width+delta.x)>_window.minimumWidth && (_window.height+delta.y)<=_window.minimumHeight){
                _window.setWidth(_window.width+delta.x)
                _window.setHeight(_window.minimumHeight)
            }else if((_window.width+delta.x)<=_window.minimumWidth && (_window.height+delta.y)>_window.minimumHeight){
                _window.setHeight(_window.height + delta.y)
                _window.setWidth(_window.minimumWidth)
            }else{
                _window.setWidth(_window.width+delta.x)
                _window.setHeight(_window.height + delta.y)
            }
            _window.showNormal()
        }
    }

    //右上角
    MouseArea{
        anchors.top: parent.top
        anchors.right: parent.right
        width: 10
        height: 10
        z: myZ
        property point clickPos: "0,0"  //定义一个点
        cursorShape:Qt.SizeBDiagCursor
        onPressed: {
            clickPos = Qt.point(mouseX, mouseY)
        }
        propagateComposedEvents : true

        onPositionChanged: {  //属性的改变
            var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
            if((_window.width+delta.x)<=_window.minimumWidth && (_window.height-delta.y)<=_window.minimumHeight){
                _window.setWidth(_window.minimumWidth)
                _window.setHeight(_window.minimumHeight)
            }else if((_window.width+delta.x)>_window.minimumWidth && (_window.height-delta.y)<=_window.minimumHeight){
                _window.setWidth(_window.width+delta.x)
                _window.setHeight(_window.minimumHeight)
            }else if((_window.width+delta.x)<=_window.minimumWidth && (_window.height-delta.y)>_window.minimumHeight){
                _window.setY(_window.y+delta.y)
                _window.setHeight(_window.height-delta.y)
                _window.setWidth(_window.minimumWidth)
            }else{
                _window.setWidth(_window.width+delta.x)
                _window.setY(_window.y+delta.y)
                _window.setHeight(_window.height-delta.y)
            }
            _window.showNormal()
        }
    }
}
