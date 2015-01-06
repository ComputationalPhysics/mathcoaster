import QtQuick 2.0
import Box2D 2.0
import "shared"

PhysicsItem {
    id: trackPiece
    property point startVertex: Qt.point(0, 0)
    property point endVertex: Qt.point(100, 10)
    clip: false
    height: 1
    width: 1
    x: 100
    y: 260
    fixtures: Edge {
        vertices: [
            startVertex,
            endVertex
        ]
        friction: 1000
    }
}
