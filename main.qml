import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import Box2D 2.0

ApplicationWindow {
    title: qsTr("Hello World")
    width: 1920
    height: 1200
    visible: true

    Flickable {
        anchors.fill: parent
        contentWidth: 90000
        contentHeight: 1200
        Banana {

        }
    }
}
