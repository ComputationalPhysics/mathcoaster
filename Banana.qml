import QtQuick 2.2
import Box2D 2.0
import "shared"

Rectangle {
    id: root

    width: 9000
    height: 1200

    focus: true
    property bool accelerating: false
    property bool decelerating: false

    World {
        id: physicsWorld
        onStepped: {
//            joint.step += 0.2
//            if (joint.step > width - 150)
//                joint.step = 0;
//            joint.linearOffset = Qt.point(5*joint.step, 100-Math.exp(0.1*joint.step));
            //joint.angularOffset = Math.sin(2*joint.step / 8.0) * 10.0;
//            if(wheel.positionSet) {
//                wheel.x = wheel.nextPosition.x
//                wheel.y = wheel.nextPosition.y
//                wheel.positionSet = false
//            }
//            wheel.sleepingAllowed = false
            if(decelerating) {
                cart.motorSpeed /= 1.1
            }
            if(accelerating) {
                cart.motorSpeed += 10
            }
            cart.motorSpeed = Math.min(Math.max(cart.motorSpeed, 0), 2000)
//            if(leftWheelJoint.motorSpeed > wheel.angularVelocity) {
//                leftWheelJoint.enableMotor = true
//            } else {
//                leftWheelJoint.enableMotor = false
//            }
//            text.text = leftWheelJoint.enableMotor
        }
    }

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

        var prevX = 0
        var prevY = 0
        for(var i = 0; i < 300; i++) {
            var component = Qt.createComponent("TrackPiece.qml")
            var x = 10 * i
//            var y = 750 + 50*Math.cos(0.1*i) + Math.random() * 1
            var y = 850 + 200*getVal(0.05*i);
            var yOffset = y - prevY

            var diffX = x - prevX
            var diffY = y - prevY
            var rotation = Math.atan2(diffY, diffX) * 180 / Math.PI
            var properties = {
                x: x,
                y: prevY,
                endVertex: Qt.point(10, yOffset),
//                rotation: rotation,
                height: 20,
                width: 10
            }
            canvas.vertices.push(Qt.point(x, y))
            var trackPiece = component.createObject(root, properties)
            prevX = x
            prevY = y
            if(i === 0) {
//                cart.rotation = rotation
//                wheel.x = x + 100
//                wheel.y = y - wheel.height - 100
//                boat2.x = x + 20
//                boat2.y = y + 30
            }
        }
        canvas.requestPaint()
        canvas.update()
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        property var vertices: []
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

    Cart {
        id: cart
        box.x: 300
        enableMotor: true
    }

    Cart {
        id: cart2
        box.x: 100
        enableMotor: false
    }

    DistanceJoint {
        bodyA: cart.box.body
        bodyB: cart2.box.body
        localAnchorA: Qt.point(0,0)
        localAnchorB: Qt.point(100,0)
        length: 20
    }

    Rectangle {
        id: button
        x: 10
        y: 10
        width: 100
        height: 40
        color: "#DEDEDE"
        border.color: "#999"
        radius: 5
        Text {
            id: title
            text: debugDraw.visible ? "Debug view: on" : "Debug view: off"
            anchors.centerIn: parent
            anchors.margins: 5
        }
        MouseArea {
            anchors.fill: parent
            onClicked: debugDraw.visible = !debugDraw.visible;
        }
    }

    DebugDraw {
        id: debugDraw
        world: physicsWorld
        visible: false
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_W) {
            accelerating = true
        }

        if(event.key === Qt.Key_S) {
            decelerating = true
        }
    }

    Keys.onReleased: {
        if(event.key === Qt.Key_W) {
            accelerating = false
        }

        if(event.key === Qt.Key_S) {
            decelerating = false
        }
    }
}
