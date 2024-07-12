#ifndef ESKF_H
#define ESKF_H

#include <QObject>
#include<Eigen>

#include "yaml-cpp/yaml.h"

class ESKF : public QObject
{
    Q_OBJECT
public:
    explicit ESKF(QObject *parent = nullptr);

signals:

};

#endif // ESKF_H
