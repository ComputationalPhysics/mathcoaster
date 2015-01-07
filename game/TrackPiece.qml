import QtQuick 2.0
import Box2D 2.0
import "shared"

PhysicsItem {
    id: trackPiece
    property alias vertices: chain.vertices
    clip: false
    anchors.fill: parent
    fixtures: Chain {
        id: chain
        friction: 1000
    }

    onVerticesChanged: {
        canvas.requestPaint()
        canvas.update()
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = canvas.getContext("2d")
            ctx.beginPath();

            ctx.moveTo(0,0);
            for(var i in vertices) {
                var vertex = vertices[i]
                ctx.lineTo(vertex.x, vertex.y)
            }
            ctx.stroke()
        }
    }
}
