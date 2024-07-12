#include "Vehicle.h"
#include "QQmlEngine"

Vehicle::Vehicle(QObject *parent)
    : QObject{parent}
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<Vehicle *>("Vehicle*");
}
