import QtQuick 2.0
import Box2D 2.0
import "shared"

Item {
    id: cartRoot
    property alias box: box
    property alias wheel: wheel
    property alias wheel2: wheel2
    property alias motorSpeed: leftWheelJoint.motorSpeed
    property alias enableMotor: leftWheelJoint.enableMotor
    property alias maxMotorTorque: leftWheelJoint.maxMotorTorque

    function resetPositions() {
        if(x !== 0) {
            box.x = x
            wheel.x = x
            wheel2.x = x
            human.x = x
            x = 0
        }
        if(y !== 0) {
            box.y = y
            wheel.y = y
            wheel2.y = y
            human.y = y - 20
            y = 0
        }
    }

    onXChanged: {
        resetPositions()
    }

    onYChanged: {
        resetPositions()
    }

    Component.onCompleted: {
        resetPositions()
    }

    PhysicsItem {
        id: wheel
        property bool positionSet: false
        property point nextPosition
        width: 16
        height: width
        bodyType: Body.Dynamic
        fixtures: Circle {
            radius: wheel.width / 2
            friction: 1000
            density: 10
            restitution: 0.01
        }
        Rectangle {
            anchors.fill: parent
            color: "red"
            radius: parent.width / 2
            Rectangle {
                width: parent.width * 0.3
                height: width
                color: "blue"
                y: parent.height / 2
                smooth: true
                antialiasing: true
            }
        }
    }

    PhysicsItem {
        id: wheel2
        property bool positionSet: false
        property point nextPosition
        width: 16
        height: width
        bodyType: Body.Dynamic
        fixtures: Circle {
            radius: wheel2.width / 2
            friction: 1000
            density: 10
            restitution: 0.01
        }
        Rectangle {
            anchors.fill: parent
            color: "red"
            radius: parent.width / 2
            Rectangle {
                width: parent.width * 0.3
                height: width
                color: "blue"
                y: parent.height / 2
                smooth: true
                antialiasing: true
            }
        }
    }

    PhysicsItem {
        id: box
        width: 50
        height: 16
        bodyType: Body.Dynamic
        fixtures: [
            Box {
                width: box.width
                height: box.height
                density: 1
                friction: 1
                restitution: 0.01
            },
            Box {
                id: leftEdge
                y: -box.height * 2
                width: box.width * 0.1
                height: box.height * 2
                density: 1
                friction: 1
                restitution: 0.01
            },
            Box {
                id: rightEdge
                x: box.width - width
                y: -box.height * 2
                width: box.width * 0.1
                height: box.height * 2
                density: 1
                friction: 1
                restitution: 0.01
            }
        ]
        Rectangle {
            width: parent.width
            height: parent.height
            color: "brown"
            smooth: true
            antialiasing: true
        }
        Rectangle {
            x: leftEdge.x
            y: leftEdge.y
            width: leftEdge.width
            height: leftEdge.height
            color: "brown"
            smooth: true
            antialiasing: true
        }
        Rectangle {
            x: rightEdge.x
            y: rightEdge.y
            width: rightEdge.width
            height: rightEdge.height
            color: "brown"
            smooth: true
            antialiasing: true
        }
    }

    Human {
        id: human
    }

    RevoluteJoint {
        id: leftWheelJoint
        bodyA: box.body
        bodyB: wheel.body
        localAnchorA: Qt.vector2d(wheel.width / 2, box.height)
        localAnchorB: Qt.vector2d(wheel.width / 2, wheel.height / 2)
        //        localAxisA: Qt.vector2d(0, 1)
        motorSpeed: 0
        maxMotorTorque: 500
        enableMotor: true
    }

    RevoluteJoint {
        id: rightWheelJoint
        bodyA: box.body
        bodyB: wheel2.body
        localAnchorA: Qt.vector2d(box.width - wheel.width / 2, box.height)
        localAnchorB: Qt.vector2d(wheel2.width / 2, wheel2.height / 2)
        //        localAxisA: Qt.vector2d(0, 1)
        motorSpeed: leftWheelJoint.motorSpeed
        maxMotorTorque: 500
        enableMotor: leftWheelJoint.enableMotor
    }
}
