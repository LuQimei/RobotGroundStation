import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle {
    id:hudControl
    width: 500
    height: 500
    color: "#00000000"
    property double pitch: 0
    property double roll: 0
    property double yaw: 0

    Canvas{
        id:canvas
        width: parent.width
        height: parent.height
        property double pitch: hudControl.pitch
        property double roll: hudControl.roll
        property double yaw: hudControl.yaw


        onPaint: {
            var context = canvas.getContext("2d");

//            context.translate(0.5, 0.5)
            /**
             * 画刻度盘
             */
            function drawDial() {
                drawRing();
                setHeading(0);
                drawCentroid(0, 0);
            }

            /**
             * 中心俯仰与横滚视图
             */
            function drawCentroid(pitch, roll) {
                context.translate(canvas.width / 2, canvas.height / 2);
                context.rotate(d2r(-roll));
                context.translate(-canvas.width / 2, -canvas.height / 2);
                drawPitchBG(pitch);
                drawPathTick(pitch);
                drawRollTicks(roll);
                context.translate(canvas.width / 2, canvas.height / 2);
                context.rotate(d2r(roll));
                context.translate(-canvas.width / 2, -canvas.height / 2);
            }

            /**
             *  画环
             */
            function drawRing() {
                drawRingOuterCircle();
                context.strokeStyle = 'rgb(0 255 252)';
                var Outerstyle = context.createLinearGradient(0, 0, 0, canvas.height / 2 + canvas.height / 10);
                Outerstyle.addColorStop(0, "#009387");
                Outerstyle.addColorStop(1, "#03353c");
                context.fillStyle = Outerstyle;
                context.fill();
                context.stroke();
            }

            /**
             * 画外层环带
             */
            function drawRingOuterCircle() {

                context.shadowBlur = 6;
                context.beginPath();
                context.fillStyle = 'rgb(0 255 252)';
                context.arc(canvas.width / 2, canvas.height / 2, canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 65 - 1, 0, Math.PI * 2, false);
                context.stroke();
            }

            /**
             * 画每个刻度线的方法
             * @param angle
             * @param radius
             * @param cnt
             */
            function drawTick(angle, radius, cnt) {
                var tickWidth = cnt % 5 === 0 ? (canvas.height / 300) * 10 : (canvas.height / 300) * 10 / 2;

                context.beginPath();

                //利用三角函数确定小刻度两端的位置并连线
                context.moveTo(canvas.width / 2 + Math.cos(angle) * (radius - tickWidth), canvas.height / 2 + Math.sin(angle) * (radius - tickWidth));
                context.lineTo(canvas.width / 2 + Math.cos(angle) * radius, canvas.height / 2 + Math.sin(angle) * radius);

                context.strokeStyle = 'rgba(6,228,239, 1)';
                context.stroke();
            }

            /**
             * 绘制俯仰角背景
             * @param Pitch
             */
            function drawPitchBG(Pitch) {

                var movePicture;
                if (Pitch <= 45 && Pitch >= -45) {
                    movePicture = computingAngle(Pitch * 2);
                }
                else {
                    if (Pitch > 0)
                        movePicture = computingAngle(90);
                    if (Pitch < 0)
                        movePicture = computingAngle(-90);
                }
                //创建上下两个矩形方块用于代表天空及地面
                var sky = context.createLinearGradient(0, 0, 0, canvas.height * 0.625);
                sky.addColorStop(0, "#1294a8");
                sky.addColorStop(1, "#1294a8");
                var ground = context.createLinearGradient(0, 0, 0, canvas.height * 0.625);
                ground.addColorStop(0, "#003d45");
                ground.addColorStop(1, "#003d45");
                //创建天空背景
                context.beginPath();
                context.save();
                if (movePicture < 90 && movePicture > -90)
                    context.arc(canvas.height * 0.5, canvas.height * 0.5, canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35, d2r(movePicture), d2r(180 - movePicture), true);
                else if (movePicture >= 90)
                    context.arc(canvas.height * 0.5, canvas.height * 0.5, canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35, d2r(89), d2r(180 - 89), true);
                context.closePath();
                context.fillStyle = sky;
                context.fill();
                context.stroke();
                //创建地面背景
                context.beginPath();
                context.save();
                if (movePicture > -90 && movePicture < 90)
                    context.arc(canvas.height * 0.5, canvas.height * 0.5, canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35, d2r(movePicture), d2r(180 - movePicture), false);
                else if (movePicture <= -90)
                    context.arc(canvas.height * 0.5, canvas.height * 0.5, canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35, d2r(180 - 89), d2r(89), false);
                context.closePath();
                context.fillStyle = ground;
                context.fill();
                context.stroke();
            }

            /**
             * 绘制俯仰角刻度
             * @param pitch
             */
            function drawPathTick(pitch) {
                var number = 0;
                var startpoint = canvas.width / 2;
                var height = (canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35) * 2;
                var stepSize = height / 90;
                var startY = startpoint - height / 90 * 21;

                //长刻度
                var scaleL = {
                    startX: startpoint - height / 10,
                    stopX: startpoint + height / 10
                };
                //中刻度
                var scaleM = {
                    startX: startpoint - height / 13,
                    stopX: startpoint + height / 13
                };
                //短刻度
                var scaleS = {
                    startX: startpoint - height / 20,
                    stopX: startpoint + height / 20
                };
                //绘制刻度线
                for (var i = pitch + 20; i >= pitch - 20; i--) {
                    var j = i;

                    number++;
                    context.beginPath();
                    context.fillStyle = "red";
                    if (i > 90)
                        continue;
                    if (i < -90)
                        continue;
                    // context.save();
                    if (j % 10 == 0) {
                        context.moveTo(scaleL.startX, startY + stepSize * number);
                        context.lineTo(scaleL.stopX, startY + stepSize * number);
                        context.strokeStyle = 'rgba(6,228,239, 1)';
                        context.font = (canvas.height / 300) * 12 + 'px Helvetica';
                        context.fillStyle = 'rgba(6,228,239, 1)';
                        context.fillText(j, scaleL.startX - height / 14, startY + stepSize * number);
                        context.fillText(j, scaleL.stopX + height / 15, startY + stepSize * number);
                        context.stroke();
                    }
                    else if (j % 5 == 0) {
                        context.moveTo(scaleM.startX, startY + stepSize * number);
                        context.lineTo(scaleM.stopX, startY + stepSize * number);
                        context.strokeStyle = 'rgba(6,228,239, 1)';
                        context.stroke();
                    }
                    else {
                        context.moveTo(scaleS.startX, startY + stepSize * number);
                        context.lineTo(scaleS.stopX, startY + stepSize * number);
                        context.strokeStyle = 'rgba(6,228,239, 1)';
                        context.stroke();
                    }
                }

                //画中心刻度线
                context.beginPath();
                context.save();
                context.moveTo(startpoint - height / 9, canvas.height / 2);
                context.lineTo(startpoint + height / 9, canvas.height / 2);
                context.strokeStyle = "rgba(274,234,8,1)";
                context.stroke();
            }

            context.shadowBlur = 4;
            context.textAlign = 'center';
            context.textBaseline = 'middle';
            drawDial();

            /**
             * 设置航向角
             * @param heading
             * @constructor
             */
            function setHeading(heading) {
                var radius = canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35 + (canvas.height / 300) * 29;
                var shoutof = 270 - heading;
                context.save();
                context.fillStyle = 'rgba(6,228,239, 1)';
                context.font = (canvas.height / 300) * 12 + 'px Helvetica';
                drawTicks(heading);
                for (var angle = heading - 75; angle <= heading + 75; angle++) {
                    var angle2R = d2r((angle + 360) % 360);
                    var angle2Rs = d2r((shoutof + angle + 360) % 360);
                    context.beginPath();
                    if (r2d(angle2R) === 0)
                        context.fillText("N", canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2));
                    else if (r2d(angle2R) === 90)
                        context.fillText("E", canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2));
                    else if (r2d(angle2R) === 180)
                        context.fillText("S", canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2));
                    else if (r2d(angle2R) === 270)
                        context.fillText("W", canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2));
                    else if (angle % 15 == 0)
                        if (angle >= 0) {
                            context.fillText((angle2R * 180 / Math.PI).toFixed(0), canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2));
                        }
                        else {
                            var angle2RS = d2r(-angle);
                            context.fillText((angle2RS * 180 / Math.PI).toFixed(0), canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2));
                        }
                }
                context.restore();
            }

            /**
             * 绘制刻度线
             * @param heading
             */
            function drawTicks(heading) {
                var radius = canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35 + (canvas.height / 300) * 29;
                context.save();
                var shoutof = 270 - heading;
                for (var angle = heading - 75, cnt = heading; angle <= heading + 75; angle++, cnt++) {
                    var angle2Rs = d2r((shoutof + angle + 360) % 360);
                    drawTick(angle2Rs, radius, cnt);
                }
                context.restore();

                context.beginPath();
                //利用三角函数确定小刻度两端的位置并连线
                context.moveTo(canvas.width / 2, 1);
                context.lineTo(canvas.width / 2, 7);

                context.strokeStyle = "red";
                context.stroke();
            }

            /**
             * 绘制横滚角刻度尺
             * @constructor
             */
            function drawRollTicks(roll) {
                var rollS = -roll;
                var radius = canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35 - (canvas.height / 300);
                var shoutof = 90 - rollS;
                context.beginPath();
                context.arc(canvas.width / 2, canvas.height / 2, canvas.width / 2 - (canvas.height / 300) * 65 + (canvas.height / 300) * 35 - (canvas.height / 300) * 11, d2r(45), d2r(135), false);
                context.strokeStyle = 'rgba(6,228,239, 1)';
                context.stroke();
                context.restore();
                context.closePath();

                context.beginPath();
                context.save();
                context.fillStyle = 'rgba(6,228,239, 1)';
                context.font = (canvas.height / 300) * 12 + 'px Helvetica';
                for (var angle = rollS - 45; angle <= rollS + 45; angle++) {
                    if (angle % 15 == 0) {
                        var angle2R = d2r(angle);
                        var angle2Rs = d2r((shoutof + angle + 360) % 360);
                        context.beginPath();
                        if (angle2R >= 0 && angle2R <= 180) {
                            context.fillText((angle2R * 180 / Math.PI).toFixed(0), canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2));
                        }
                        else {
                            context.fillText((-angle2R * 180 / Math.PI).toFixed(0), canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 2));
                        }

                        //绘制刻度线
                        context.moveTo(canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10 * 1.5), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10 * 1.5));
                        context.lineTo(canvas.width / 2 + Math.cos(angle2Rs) * (radius - (canvas.height / 300) * 10), canvas.height / 2 + Math.sin(angle2Rs) * (radius - (canvas.height / 300) * 10));
                        context.stroke();
                    }
                }
                //绘制红色指针
                context.beginPath();
                context.moveTo(canvas.width / 2 + Math.cos(d2r((rollS + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10 * 1.5), canvas.height / 2 + Math.sin(d2r((rollS + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10 * 1.5));
                context.lineTo(canvas.width / 2 + Math.cos(d2r((rollS + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10), canvas.height / 2 + Math.sin(d2r((rollS + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10));
                context.moveTo(canvas.width / 2 + Math.cos(d2r((rollS + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10 * 1.5), canvas.height / 2 + Math.sin(d2r((rollS + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10 * 1.5));
                context.lineTo(canvas.width / 2 + Math.cos(d2r((rollS + 1 + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10), canvas.height / 2 + Math.sin(d2r((rollS + 1 + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10));
                context.moveTo(canvas.width / 2 + Math.cos(d2r((rollS + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10 * 1.5), canvas.height / 2 + Math.sin(d2r((rollS + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10 * 1.5));
                context.lineTo(canvas.width / 2 + Math.cos(d2r((rollS - 1 + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10), canvas.height / 2 + Math.sin(d2r((rollS - 1 + shoutof + 360) % 360)) * (radius - (canvas.height / 300) * 10));
                context.strokeStyle = "red";
                context.stroke();

                context.restore();
            }

            /**
             * 设置横滚角
             * @param roll
             * @constructor
             */
            function SetRoll(roll) {
                drawCentroid(roll);
            }

            /**
             * 设置俯仰角
             * @param pitch
             * @constructor
             */
            function SetPitch(pitch) {
                drawPitchBG(pitch);
                drawPathTick(pitch);
            }

            /**
             * 角度转弧度
             * @param degree  角度值
             * @returns {number}
             * @constructor
             */
            function d2r(degree) {
                return degree / 180 * Math.PI;
            }

            /**
             * 弧度转角度
             * @param radius
             * @returns {number}
             * @constructor
             */
            function r2d(radius) {
                return radius * 180 / Math.PI;
            }

            /**
             * 根据俯仰角计算仪表盘上下浮动
             * @param pitch
             * @constructor
             */
            function computingAngle(pitch) {
                var anger = Math.asin(pitch / 90);
                return r2d(anger);
            }

            /**
             * 更新仪表盘刻度显示
             * @param heading   航向角
             * @param pitch     俯仰角
             * @param roll      横滚角
             */
            function updateDial(heading, pitch, roll) {
                context.clearRect(0, 0, Dwidth, Dheight);//重新绘制之前清除画布，否则状态叠加
                drawRing();
                setHeading(heading);
                drawCentroid(pitch, roll);
            }
        }
    }

}
