import QtQuick 2.0
import Box2D 2.0

Item {
    id: trainRoot
    property real motorSpeed
    property var firstCart
    property var lastCart

    Component.onCompleted: {
        var previousCart
        var cartComponent = Qt.createComponent("Cart.qml")
        var cartCount = 10
        for(var i = 0; i < cartCount; i++) {
            var cart = cartComponent.createObject(trainRoot)
            cart.x = 800 + 80*cartCount - i*80
            cart.y = 600
            cart.enableMotor = false
            if(previousCart) {
                var joint = jointComponent.createObject(trainRoot)
                joint.bodyA = previousCart.box.body
                joint.bodyB = cart.box.body


                var joint2 = jointComponent2.createObject(trainRoot)
                joint2.bodyA = previousCart.box.body
                joint2.bodyB = cart.box.body
            } else {
                firstCart = cart
            }
            lastCart = cart
            previousCart = cart
        }
    }

//    Cart {
//        id: firstCart
//        box.y: 600
//        wheel.y: 600
//        wheel2.y: 600
//        box.x: 700
//        wheel.x: 700
//        wheel2.x: 700
////        motorSpeed: trainRoot.motorSpeed
//        enableMotor: false
//    }

    Component {
        id: jointComponent

        WheelJoint {
//            bodyA: cart.box.body
//            bodyB: cart2.box.body
            localAnchorA: Qt.vector2d(-5, 8)
            localAnchorB: Qt.vector2d(55, 8)
            localAxisA: Qt.vector2d(1,0)
            dampingRatio: 2000
            enableMotor: true
            maxMotorTorque: 100
//            maxLength: 10
        }
    }

    Component {
        id: jointComponent2

        WheelJoint {
//            bodyA: cart.box.body
//            bodyB: cart2.box.body
            localAnchorA: Qt.vector2d(-5, 16)
            localAnchorB: Qt.vector2d(55, 16)
            localAxisA: Qt.vector2d(1,0)
            dampingRatio: 2000
            enableMotor: true
            maxMotorTorque: 100
//            maxLength: 10
        }
    }

//    Cart {
//        id: cart2
//        box.x: 550
//        wheel.x: 550
//        wheel2.x: 550
//        box.y: 600
//        wheel.y: 600
//        wheel2.y: 600
//        enableMotor: false
//    }

//    WheelJoint {
//        bodyA: cart2.box.body
//        bodyB: cart3.box.body
//        localAnchorA: Qt.vector2d(-5, 0)
//        localAnchorB: Qt.vector2d(55, 0)
//        localAxisA: Qt.vector2d(1,0)
////        length: 50
//    }

//    Cart {
//        id: cart3
//        box.x: 500
//        wheel.x: 500
//        wheel2.x: 500
//        box.y: 600
//        wheel.y: 600
//        wheel2.y: 600
//        enableMotor: false
//    }
}

