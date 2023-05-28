#include "reloadhelper.h"

ReloadHelper::ReloadHelper(QObject *parent)
    : QObject{parent}
{

}

void ReloadHelper::loadQml()
{
    mQmlEngine->load(QUrl(QStringLiteral("../speechwriter/Main.qml")));
}
