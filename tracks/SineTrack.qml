import QtQuick 2.0
import ".."

TrackPiece {
    Component.onCompleted: {
        var verticesNew = []
        var x = 0
        var y = 0
        for(var i = 0; i < 1000; i++) {
            x = 40 * i
            y = 8800 + 8000*Math.sin(0.0005*x - 2 * Math.PI / 3) // + 0.3*x
            verticesNew.push(Qt.point(x, y))
        }
        vertices = verticesNew
    }
}

