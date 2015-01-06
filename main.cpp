#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath("/home/svenni/apps/qt/qml-box2d/build-box2d-Desktop_Qt_5_4_0_GCC_64bit-Release");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
