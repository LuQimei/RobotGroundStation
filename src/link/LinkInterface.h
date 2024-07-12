//
// Created by Wang on 2022/10/12.
//

#pragma once

#include "QThread"
#include <memory>

class LinkInterface : public QThread {
Q_OBJECT

    friend class LinkManager;

public:
    explicit LinkInterface();

    virtual bool _connect() = 0;
};

typedef std::shared_ptr<LinkInterface>  SharedLinkInterfacePtr;
typedef std::weak_ptr<LinkInterface>    WeakLinkInterfacePtr;
