import QtQuick 2.2
import Box2D 2.0
import "shared"

Item {
    id: root
    property bool accelerating: false
    property bool decelerating: false

    focus: true

    function createFunction() {
//                var component = Qt.createComponent("tracks/SineTrack.qml")
        var component = Qt.createComponent("tracks/NoiseTrack.qml")
        var trackPiece = component.createObject(workspace)
    }

    Component.onCompleted: {
        createFunction()
    }

    Flickable {
        id: workspaceView
        anchors.fill: parent
        boundsBehavior: Flickable.DragOverBounds
        contentHeight: workspace.height
        contentWidth: workspace.width

        Rectangle {
            id: workspace

            width: 2000
            height: 2000

            World {
                id: physicsWorld
                gravity: Qt.vector2d(0, 10)
                onStepped: {
                    if(train.firstCart) {
                        if(decelerating) {
                            train.firstCart.enableMotor = true
//                            train.lastCart.enableMotor = true
                        } else {
                            train.firstCart.enableMotor = false
//                            train.lastCart.enableMotor = false
                        }

                        if(accelerating) {
                            train.motorSpeed += 10
                            var linearVelocity = Qt.vector2d(train.firstCart.box.body.linearVelocity.x,
                                                             train.firstCart.box.body.linearVelocity.y)
                            var linearVelocityNorm = linearVelocity.normalized()
                            var impulse = linearVelocityNorm.times(10)
                            var impulsePoint = Qt.vector2d(impulse.x, impulse.y)
                            train.firstCart.box.body.applyLinearImpulse(impulsePoint, train.firstCart.box.body.getWorldCenter())
                        }
                        train.motorSpeed = Math.min(Math.max(train.motorSpeed, -2000), 2000)
                        workspaceView.contentX = train.firstCart.box.x - 1000
                        workspaceView.contentY = train.firstCart.box.y - 500
                    }
                }
            }

            DebugDraw {
                id: debugDraw
                world: physicsWorld
                visible: false
            }

            Train {
                id: train
            }
        }
    }

    Rectangle {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: 100
        color: "yellow"
        Column {
            anchors.fill: parent
            Repeater {
                model: 9
                delegate: Tile {
                    onDropped: {
                        createFunction()
                    }
                }
            }
        }
    }

    Rectangle {
        id: button
        anchors {
            right: parent.right
            top: parent.top
        }

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
