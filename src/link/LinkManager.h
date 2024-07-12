//
// Created by Wang on 2022/10/11.
//

#pragma once
#include <list>

#include "GCToolbox.h"
#include "LinkInterface.h"
#include "json.hpp"
#include "UdpLink.h"
#include "TcpClientLink.h"


class LinkManager : public GCTool {
Q_OBJECT
public:

    LinkManager(Application *app, GCToolbox *toolbox);

    void init();
    void setToolbox(GCToolbox *toolbox);

    std::shared_ptr<LinkInterface> getLink();



    UdpLink *getUdpLink() const;
    TcpClientLink *sblTcpClient() const;

    void reConnectSblTcpClient(QString ip, int port);

public slots:
    void onMessageReceived(const QByteArray msg, const QString &topic);


private:
    const std::string _name{"LinkManager"};
    std::shared_ptr<LinkInterface>  link = nullptr;

    UdpLink *udpLink;
    TcpClientLink *_sblTcpClient;
    TcpClientLink *_uav;

};
