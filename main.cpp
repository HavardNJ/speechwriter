#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "reloadhelper.h"
#include "speechmodel.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("speechwriter", "Main");

    ReloadHelper reloadHelper;
    reloadHelper.setEngine(&engine);

    engine.rootContext()->setContextProperty("reloadhelper", &reloadHelper);
    
    SpeechModel speechModel;
    engine.rootContext()->setContextProperty("speechModel", &speechModel);

    return app.exec();
}
