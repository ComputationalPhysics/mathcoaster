#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath("../box2d");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
