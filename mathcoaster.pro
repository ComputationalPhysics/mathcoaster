TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = /home/svenni/apps/qt/box2d/qml-box2d

# Default rules for deployment.
include(deployment.pri)
