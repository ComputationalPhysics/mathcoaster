import QtQuick 2.0
import Box2D 2.0
import "shared"

PhysicsItem {
    id: wheel
    property bool positionSet: false
    property point nextPosition
    width: 8
    height: width
    bodyType: Body.Dynamic
    fixtures: Circle {
        radius: wheel.width / 2
        friction: 1000
        density: 10
        restitution: 0.5
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
