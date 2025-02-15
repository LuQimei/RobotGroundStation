#include "winGetMac.h"
#ifdef _WIN32
#pragma comment(lib, "IPHLPAPI.lib")

#include <winsock2.h>
#include <iphlpapi.h>
bool GetMacByGetAdaptersInfo(std::string &macOUT) {
//    std::cout << "CurrentPlatform: Windows" << std::endl;

    bool ret = false;

    ULONG ulOutBufLen = sizeof(IP_ADAPTER_INFO);
    PIP_ADAPTER_INFO pAdapterInfo = (IP_ADAPTER_INFO *) malloc(sizeof(IP_ADAPTER_INFO));
    if (pAdapterInfo == NULL)
        return false;
    // Make an initial call to GetAdaptersInfo to get the necessary size into the ulOutBufLen variable
//    if (GetAdaptersInfo(pAdapterInfo, &ulOutBufLen) == ERROR_BUFFER_OVERFLOW) {
//        free(pAdapterInfo);
//        pAdapterInfo = (IP_ADAPTER_INFO *) malloc(ulOutBufLen);
//        if (pAdapterInfo == NULL)
//            return false;
//    }

//    if (GetAdaptersInfo(pAdapterInfo, &ulOutBufLen) == NO_ERROR) {
//        for (PIP_ADAPTER_INFO pAdapter = pAdapterInfo; pAdapter != NULL; pAdapter = pAdapter->Next) {
//            // 确保是以太网
//            if (pAdapter->Type != MIB_IF_TYPE_ETHERNET)
//                continue;
//            // 确保MAC地址的长度为 00-00-00-00-00-00
//            if (pAdapter->AddressLength != 6)
//                continue;
//            char acMAC[32];
//            sprintf_s(acMAC, "%02X-%02X-%02X-%02X-%02X-%02X",
//                    int(pAdapter->Address[0]),
//                    int(pAdapter->Address[1]),
//                    int(pAdapter->Address[2]),
//                    int(pAdapter->Address[3]),
//                    int(pAdapter->Address[4]),
//                    int(pAdapter->Address[5]));
//            macOUT = acMAC;
//            ret = true;
//            break;
//        }
//    }

    free(pAdapterInfo);
    return ret;
}

#endif
#ifndef _WIN32
bool GetMacByGetAdaptersInfo(std::string &macOUT) {

    //std::cout << "CurrentPlatform: Linux" << std::endl;
    macOut = "00-00-00-00-00-00";
    return true;
}
#endif
