#ifndef RELOADHELPER_H
#define RELOADHELPER_H

#include <QObject>
#include <QQmlApplicationEngine>

class ReloadHelper : public QObject
{
    Q_OBJECT
private:
    QQmlApplicationEngine* mQmlEngine;

public:
    explicit ReloadHelper(QObject *parent = nullptr);
    Q_INVOKABLE void loadQml();

    void setEngine(QQmlApplicationEngine *engine) { mQmlEngine = engine; }

signals:

};

#endif // RELOADHELPER_H

