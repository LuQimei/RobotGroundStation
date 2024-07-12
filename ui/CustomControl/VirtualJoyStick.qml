import QtQuick 2.3
//import RovVehicle 1.0
import GroundControl 1.0

Item {
    //    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
//    property var multiVehicleManager: GroundControl.multiVehicleManager
//    property var vehicle : multiVehicleManager.getVehiclesByType("rov").get(0)

    Timer {
        id: myTimer;
        interval: 50;//设置定时器定时时间为500ms,默认1000ms
        repeat: true //是否重复定时,默认为false
        running: false //是否开启定时，默认是false，当为true的时候，进入此界面就开始定时
        triggeredOnStart: true // 是否开启定时就触发onTriggered，一些特殊用户可以用来设置初始值。
        onTriggered: {
//            if(vehicle.vehicleType === "rov"){
//                vehicle.start(vehicle.id, 1500 + leftStick.yAxis*300)
//            }else if(vehicle.vehicleType === "djiMavic3Enterprise"){
//                console.log("====================>vehicle.vehicleYaw : ", vehicle.vehicleYaw)
//                console.log("====================>vehicle.  yaw : ", vehicle.vehicleYaw/180*10000)
//                vehicle.attitudeControl(vehicle.id, 0, 0, 0, leftStick.yAxis*10000)
//            }
//            GroundControl.rovVehicle.channel1Value(leftStick.yAxis*10000)
//            GroundControl.rovVehicle.setRcChannel()
        }
    }

    Timer {
        id: myTimer2;
        interval: 50;//设置定时器定时时间为500ms,默认1000ms
        repeat: true //是否重复定时,默认为false
        running: false //是否开启定时，默认是false，当为true的时候，进入此界面就开始定时
        triggeredOnStart: true // 是否开启定时就触发onTriggered，一些特殊用户可以用来设置初始值。
        onTriggered: {
            if(vehicle.vehicleType == "rov"){
                vehicle.throttle(vehicle.id, 1500 + rightStick.yAxis*300)
            }else if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                vehicle.attitudeControl(vehicle.id, rightStick.yAxis*10000, 0, 0, 0)
                console.log("====================>vehicle.vehicleYaw : ", vehicle.vehicleYaw)
                console.log("====================>vehicle.  yaw : ", vehicle.vehicleYaw/180*10000)
                vehicle.attitudeControl(vehicle.id, rightStick.yAxis*10000, 0, 0, 0)
            }
        }
    }

    Timer {
        id: myTimer3;
        interval: 50;//设置定时器定时时间为500ms,默认1000ms
        repeat: true //是否重复定时,默认为false
        running: false //是否开启定时，默认是false，当为true的时候，进入此界面就开始定时
        triggeredOnStart: true // 是否开启定时就触发onTriggered，一些特殊用户可以用来设置初始值。
        onTriggered: {
            if(vehicle.vehicleType == "rov"){
                vehicle.yaw(vehicle.id, 1500 + rightStick.xAxis*300)
            }else if(vehicle.vehicleType == "djiMavic3Enterprise"){
                console.log("====================>vehicle.vehicleYaw : ", vehicle.vehicleYaw)
                console.log("====================>vehicle.  yaw : ", vehicle.vehicleYaw/180*10000)
                vehicle.attitudeControl(vehicle.id, 0, -rightStick.xAxis*10000, 0, 0)
            }
        }
    }

    Timer {
        id: myTimer4;
        interval: 50;//设置定时器定时时间为500ms,默认1000ms
        repeat: true //是否重复定时,默认为false
        running: false //是否开启定时，默认是false，当为true的时候，进入此界面就开始定时
        triggeredOnStart: true // 是否开启定时就触发onTriggered，一些特殊用户可以用来设置初始值。
        onTriggered: {
            if(vehicle.vehicleType == "rov"){
//                vehicle.start(vehicle.id, 1500 + leftStick.yAxis*300)
            }else if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                vehicle.attitudeControl(vehicle.id, 0, 0, leftStick.xAxis*10000, 0)
                vehicle.attitudeControl(vehicle.id, 0, 0, leftStick.xAxis*10000, 0)
            }
        }
    }

    JoystickThumbPad {
        id:                     leftStick
        anchors.leftMargin:     xPositionDelta
        anchors.bottomMargin:   -yPositionDelta
        anchors.left:           parent.left
        anchors.bottom:         parent.bottom
        width:                  parent.height
        height:                 parent.height
//        onYAxisChanged: {
//            if(yAxis <= -0.4 || yAxis >= 0.4){
//                if( myTimer.running == false ){
//                    myTimer.start()
//                    if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                        vehicle.joystick(vehicle.id);
//                    }
//                }
//            }
//            else{
//                if( myTimer.running == true )
//                {
//                    myTimer.stop()
//                    if(vehicle.vehicleType == "rov"){
//                        vehicle.start(vehicle.id, 1500)
//                    }else if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                        vehicle.joystick(vehicle.id, "stop");
//                    }
//                }
//            }
//        }

//        onXAxisChanged: {
//            if(xAxis <= -0.4 || xAxis >= 0.4){
//                if( myTimer4.running == false ){
//                    myTimer4.start()
//                    if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                        vehicle.joystick(vehicle.id);
//                    }
//                }
//            }
//            else{
//                if( myTimer4.running == true ){
//                    myTimer4.stop()
//                    if(vehicle.vehicleType == "rov"){
//                        vehicle.yaw(vehicle.id, 1500)
//                    }else if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                        vehicle.joystick(vehicle.id, "stop");
//                    }
//                }
//            }
//        }
    }

    JoystickThumbPad {
        id:                     rightStick
        anchors.rightMargin:    -xPositionDelta
        anchors.bottomMargin:   -yPositionDelta
        anchors.right:          parent.right
        anchors.bottom:         parent.bottom
        width:                  parent.height
        height:                 parent.height
//        onYAxisChanged: {
//            if(yAxis <= -0.4 || yAxis >= 0.4){
//                if( myTimer2.running == false || yAxis >= 0.4){
//                    myTimer2.start()
//                    if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                        vehicle.joystick(vehicle.id);
//                    }
//                }
//            }else{
//                if( myTimer2.running == true )
//                {
//                    myTimer2.stop()
//                    if(vehicle.vehicleType == "rov"){
//                        vehicle.throttle(vehicle.id, 1500)
//                    }else if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                        vehicle.joystick(vehicle.id, "stop");
//                    }
//                }
//            }
//        }
//        onXAxisChanged: {
//            if(xAxis <= -0.4 || xAxis >= 0.4){
//                if( myTimer3.running == false ){
//                    myTimer3.start()
//                    if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                        vehicle.joystick(vehicle.id);
//                    }
//                }
//            }
//            else{
//                if( myTimer3.running == true ){
//                    myTimer3.stop()
//                    if(vehicle.vehicleType == "rov"){
//                        vehicle.yaw(vehicle.id, 1500)
//                    }else if(vehicle.vehicleType == "djiMavic3Enterprise"){
//                        vehicle.joystick(vehicle.id, "stop");
//                    }
//                }
//            }
//        }
    }
}

