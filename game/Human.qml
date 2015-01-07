import QtQuick 2.0
import Box2D 2.0
import "shared"

Item {
    property alias chest: chest

    function resetPositions() {
        if(x !== 0) {
            chest.x = x
            leftArm.x = x
            rightArm.x = x
            head.x = x
            x = 0
        }
        if(y !== 0) {
            chest.y = y
            leftArm.y = y
            rightArm.y = y
            head.y = y
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
        id: chest
        width: 16
        height: 24
        bodyType: Body.Dynamic
        fixtures: [
            Box {
                width: chest.width
                height: chest.height
                density: 0.1
                friction: 0.4
                restitution: 0.1
            }
        ]
        Rectangle {
            width: parent.width
            height: parent.height
            color: "black"
            smooth: true
            antialiasing: true
        }
    }

    PhysicsItem {
        id: leftArm
        width: 20
        height: 6
        bodyType: Body.Dynamic
        fixtures: [
            Box {
                width: leftArm.width
                height: leftArm.height
                density: 0.1
                friction: 0.4
                restitution: 0.1
            }
        ]
        Rectangle {
            width: parent.width
            height: parent.height
            color: "black"
            smooth: true
            antialiasing: true
        }
    }
    PhysicsItem {
        id: rightArm
        width: 20
        height: 6
        bodyType: Body.Dynamic
        fixtures: [
            Box {
                width: rightArm.width
                height: rightArm.height
                density: 0.1
                friction: 1
                restitution: 0.01
            }
        ]
        Rectangle {
            width: parent.width
            height: parent.height
            color: "black"
            smooth: true
            antialiasing: true
        }
    }

    RevoluteJoint {
        bodyA: chest.body
        bodyB: rightArm.body
        enableLimit: true
        localAnchorA: Qt.vector2d(0,0)
        localAnchorB: Qt.vector2d(0,0)
        Component.onCompleted: {
            setLimits(120,90)
        }
    }

    RevoluteJoint {
        bodyA: chest.body
        bodyB: leftArm.body
        enableLimit: true
        localAnchorA: Qt.vector2d(16,0)
        localAnchorB: Qt.vector2d(0,4)
        Component.onCompleted: {
            setLimits(90,60)
        }
    }


    PhysicsItem {
        id: head
        width: 12
        height: width
        bodyType: Body.Dynamic
        fixtures: [
            Circle {
                radius: head.width / 2
                density: 0.1
                friction: 1
                restitution: 0.01
            }
        ]
        Rectangle {
            width: parent.width
            height: parent.height
            radius: width / 2
            color: "black"
        }
    }

    RevoluteJoint {
        bodyA: chest.body
        bodyB: head.body
        enableLimit: true
        localAnchorA: Qt.vector2d(8,0)
        localAnchorB: Qt.vector2d(6,12)
        Component.onCompleted: {
            setLimits(30,-30)
        }
    }
}

