//
// Created by Wang on 2023/4/22.
//
#include <QQmlEngine>

#include "LinkInterface.h"

LinkInterface::LinkInterface(): QThread(0) {
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<LinkInterface*>("LinkInterface*");
}