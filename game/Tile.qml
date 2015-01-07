import QtQuick 2.0

Item {
    id: tileBackground

    signal dropped(point drop)

    anchors {
        horizontalCenter: parent.horizontalCenter
    }

    width: 30
    height: 30

    Rectangle {
        id: tile

        property bool dragActive: dragArea.drag.active

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: tileBackground.width
        height: tileBackground.height

        color: "blue"

        states: State {
            when: dragArea.drag.active
            ParentChange { target: tile; parent: root }
            AnchorChanges { target: tile; anchors.horizontalCenter: undefined; anchors.verticalCenter: undefined }
        }

        onDragActiveChanged: {
            if (dragActive) {
                Drag.start();
            } else {
                dropped(Qt.vector2d(tile.x, tile.y))
                Drag.drop();
            }
        }

        Drag.dragType: Drag.Automatic

        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: parent
        }
    }
}

