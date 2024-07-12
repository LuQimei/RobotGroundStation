import QtQuick 2.15
import QtQuick.Window 2.15

import QtQuick.Controls 2.4

Canvas {
    id:myCanvas
    width: parent.width
    height: parent.height

    contextType: "2d"

    //左右刻度与Canvas边距
    property int _SPACING : 40

    //刻度尺每条线的长度
    property int _SCALE_LINE_LENGTH : 15

    //顶部距离Canvas
    property int topMargin:height/2

    //需要把刻度尺分成几等份大刻度,取偶数
    property int _SCALE_LINE_SPACE : 8

    //每1大刻度代表多少度
    property int _UNIT_SPACING: 15

    //每1大刻度的像素宽度
    property int _UNIT_PIX_SPACING : (width - _SPACING * 2) / _SCALE_LINE_SPACE

    //输入角度的像素偏移(相对于最近的前一个大刻度线) = 每一度的像素宽度*当前输入角度的度数偏移(相对于最近的前一个大刻度线度数)
    property int offset : (_UNIT_PIX_SPACING / _UNIT_SPACING) * (intputAngle % _UNIT_SPACING);

    //输入角度
    property int intputAngle: 0

    //1大刻度等分_UNIT_MINI_SPACING个小刻度
    property int _UNIT_MINI_SPACING : 5

    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0,0,width, height);
        ctx.fillStyle = "#00000000"
        ctx.fillRect(0, 0, width, height)

        drawCurrentAngle(ctx)
        drawScale(ctx)
        drawTriangle(ctx)
    }

    function drawScale(ctx){

        for (var i = 0; i < _SCALE_LINE_SPACE + 1; i++) {

            // 需要画大刻度线的x坐标值
            var x = _UNIT_PIX_SPACING * i + _SPACING  - offset

            //当前角度最近前一个大刻度线上的刻度
            var stdLineCurrentDrawAngle = intputAngle - intputAngle%_UNIT_SPACING
            //大刻度线上的刻度
            var stdLineAngle = stdLineCurrentDrawAngle + _UNIT_SPACING * (i - _SCALE_LINE_SPACE/2)

            // 标准化 0-360
            stdLineAngle = (stdLineAngle%360 + 360)%360

            var largeMark;
            if(stdLineAngle%45===0){
                largeMark = true
            }else{
                largeMark = false
            }

            //画大刻度线
            ctx.beginPath()
            ctx.lineWidth="2"
            ctx.strokeStyle=largeMark?"red":"white"
            ctx.moveTo(x,topMargin);
            ctx.lineTo(x,topMargin + _SCALE_LINE_LENGTH)
            ctx.stroke();

            //画小刻度线
            for (var j = 1; j < _UNIT_MINI_SPACING; j++){
                var miniX = x + j*_UNIT_PIX_SPACING/_UNIT_MINI_SPACING
                ctx.beginPath()
                ctx.lineWidth="1"
                ctx.strokeStyle="white"
                ctx.moveTo(miniX,topMargin + 2);
                ctx.lineTo(miniX,topMargin + _SCALE_LINE_LENGTH/2)
                ctx.stroke();
            }

            // 画刻度值
            ctx.font =largeMark?"25px Consolas":"20px Consolas"
            ctx.fillStyle = "#ffffff";
            var mark = calculateDegree(stdLineAngle)

            var markPosX = x - (mark.length===1?8:
                                                 mark.length===2?18:
                                                                  mark.length===4?20:15)
            var markPosY = topMargin -5

            //context.fillText(text,x,y,maxWidth=default);
            ctx.fillText(mark, markPosX, markPosY)

            // 进行绘制
            ctx.stroke();
        }
    }

    function drawTriangle(ctx){
        //中间刻度位置
        var x = (_SCALE_LINE_SPACE * _UNIT_PIX_SPACING)/2.0 + _SPACING

        ctx.fillStyle = "red"
        ctx.beginPath()
        ctx.moveTo(x, myCanvas.height-20)
        ctx.lineTo(x - 6, myCanvas.height)
        ctx.lineTo(x + 6,  myCanvas.height)
        ctx.fill()
        ctx.stroke();
    }

    function drawCurrentAngle(ctx){

        ctx.font ="25px Consolas"
        ctx.fillStyle = "#ffffff";
        //中间刻度位置
        var x = (_SCALE_LINE_SPACE * _UNIT_PIX_SPACING)/2.0 + _SPACING

        var mark = getDirectionText(intputAngle)

        var markPosX = x - (mark.length/2.0)*10
        var markPosY = topMargin -40

        //context.fillText(text,x,y,maxWidth=default);
        ctx.fillText(markPosX, markPosY)
        ctx.stroke();
    }

    function calculateDegree(degree) {
        degree = (degree%360 + 360)%360
        if (degree === 45) {
            return "NE";
        }
        else if (degree === 135) {
            return "SE";
        }
        else if (degree === 225) {
            return "SW";
        }
        else if (degree === 315) {
            return "NW";
        }
        else if (degree === 0 || degree === 360) {
            return "N";
        } else if (degree === 90) {
            return "E";
        } else if (degree === 180) {
            return "S";
        } else if (degree === 270) {
            return "W";
        }else{
            return degree + "°"
        }
    }

    function getDirectionText(direction){

        direction = (direction%360 + 360)%360
        //东南西北
        if(direction<22.5||direction>=337.5&&direction<360){
            return "北" +direction + "°"
        }else if(direction>=22.5&&direction<67.5){
            return "东北" +direction + "°"
        }else if(direction>=67.5&&direction<112.5){
            return "东" +direction + "°"
        }else if(direction>=112.5&&direction<157.5){
            return "东南" +direction + "°"
        }else if(direction>=157.5&&direction<202.5){
            return "南" +direction + "°"
        }else if(direction>=202.5&&direction<247.5){
            return "西南" +direction + "°"
        }else if(direction>=247.5&&direction<292.5){
            return "西" +direction + "°"
        }else if(direction>=292.5&&direction<337.5){
            return "西北" +direction + "°"
        }
        //default
        //return "北" + 0 + "°"
    }
}

