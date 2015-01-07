import QtQuick 2.0
import ".."

TrackPiece {
    Component.onCompleted: {
        var MAX_VERTICES = 256;
        var MAX_VERTICES_MASK = MAX_VERTICES -1;
        var amplitude = 1;
        var scale = 1;

        var r = [];

        for ( var i = 0; i < MAX_VERTICES; ++i ) {
            r.push(Math.random());
        }

        var getVal = function( x ){
            var scaledX = x * scale;
            var xFloor = Math.floor(scaledX);
            var t = scaledX - xFloor;
            var tRemapSmoothstep = t * t * ( 3 - 2 * t );

            /// Modulo using &
            var xMin = xFloor & MAX_VERTICES_MASK;
            var xMax = ( xMin + 1 ) & MAX_VERTICES_MASK;

            var y = lerp( r[ xMin ], r[ xMax ], tRemapSmoothstep );

            return y * amplitude;
        };

        /**
        * Linear interpolation function.
        * @param a The lower integer value
        * @param b The upper integer value
        * @param t The value between the two
        * @returns {number}
        */
        var lerp = function(a, b, t ) {
            return a * ( 1 - t ) + b * t;
        };

        var verticesNew = []
        var x = 0
        var y = 0
        for(var i = 0; i < 1000; i++) {
            x = 30 * i
            y = 600 + (x*0.01)*getVal(0.005*x) + 0.1*Math.pow(x, 1.2)
//            y = 800 - 100*Math.exp(0.0005*x) + 0.3*x
            verticesNew.push(Qt.point(x, y))
        }
        vertices = verticesNew
    }
}

