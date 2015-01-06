import QtQuick 2.0
import Box2D 2.0
import "shared"

Item {
    id: cartRoot
    property alias box: box
    property alias motorSpeed: leftWheelJoint.motorSpeed
    property alias enableMotor: leftWheelJoint.enableMotor
    PhysicsItem {
        id: wheel
        property bool positionSet: false
        property point nextPosition
        width: 32
        height: 32
        x: 0
        y: 0
        bodyType: Body.Dynamic
        fixtures: Circle {
            radius: wheel.width / 2
            friction: 1000
            density: 50
            restitution: 0.1
        }
        Rectangle {
            anchors.fill: parent
            color: "red"
            radius: parent.width / 2
            Rectangle {
                width: parent.width * 0.1
                height: width
                color: "blue"
                y: parent.height / 2
            }
        }
    }

    PhysicsItem {
        id: wheel2
        property bool positionSet: false
        property point nextPosition
        width: 32
        height: 32
        x: 100
        y: 0
        bodyType: Body.Dynamic
        fixtures: Circle {
            radius: wheel2.width / 2
            friction: 1000
            density: 50
            restitution: 0.1
        }
        Rectangle {
            anchors.fill: parent
            color: "red"
            radius: parent.width / 2
            Rectangle {
                width: parent.width * 0.1
                height: width
                color: "blue"
                y: parent.height / 2
            }
        }
    }

    PhysicsItem {
        id: box
        width: 96
        height: 32
        x: 0
        y: 0
        bodyType: Body.Dynamic
        fixtures: Box {
            width: box.width
            height: box.height
            density: 50
            friction: 1
    //            restitution: 0.1
        }
        Rectangle {
            anchors.fill: parent
            color: "brown"
        }
    }

    RevoluteJoint {
        id: leftWheelJoint
        bodyA: box.body
        bodyB: wheel.body
        localAnchorA: Qt.point(box.width - wheel.width / 2, box.height)
        localAnchorB: Qt.point(wheel.width / 2, wheel.height / 2)
        motorSpeed: 0
        maxMotorTorque: 2000
        enableMotor: true
    }

    RevoluteJoint {
        id: rightWheelJoint
        bodyA: box.body
        bodyB: wheel2.body
        localAnchorA: Qt.point(wheel.width / 2, box.height)
        localAnchorB: Qt.point(wheel2.width / 2, wheel2.height / 2)
        motorSpeed: leftWheelJoint.motorSpeed
        maxMotorTorque: 2000
        enableMotor: false
    }
}
