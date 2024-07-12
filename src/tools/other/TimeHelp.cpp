//
// Created by Wang on 2023/6/1.
//

#include "TimeHelp.h"
#include <ctime>
#include <chrono>


std::string getCurrentTimeFormat() {//"2023-06-01  14:35:29"
    // 获取当前系统时间点
    std::chrono::system_clock::time_point now = std::chrono::system_clock::now();

    // 将时间点转换为time_t类型
    std::time_t currentTime = std::chrono::system_clock::to_time_t(now);

    // 将time_t类型的时间转换为本地时间结构
    struct tm localTime{};
    if (localtime_s(&localTime, &currentTime) != 0) {
        std::cerr << "Failed to get the local time." << std::endl;
        return "Failed to get the local time.";
    }

    // 将本地时间结构格式化为字符串
    const int bufferSize = 100;
    char timeString[bufferSize];
    if (strftime(timeString, bufferSize, "%Y-%m-%d  %H:%M:%S", &localTime) == 0) {
        std::cerr << "Failed to format the time string." << std::endl;
        return "Failed to format the time string.";
    }
    return std::string(timeString);

}

unsigned int getCurrentTimeStamp() {
    auto now = std::chrono::system_clock::now();
    auto since_epoch = now.time_since_epoch();
    auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(since_epoch);
    return ms.count();
}
