//
// Created by Wang on 2022/10/5.
//

#pragma once

#pragma comment(lib, "ws2_32.lib")

#if !defined(SPDLOG_ACTIVE_LEVEL)
#   define SPDLOG_ACTIVE_LEVEL SPDLOG_LEVEL_TRACE
#endif

#include <iostream>
#include <memory>
#include "libs/spdlog/include/spdlog/spdlog.h"
#include "spdlog/async.h"
#include "spdlog/sinks/stdout_color_sinks.h"
#include "spdlog/sinks/rotating_file_sink.h"
#include "spdlog/sinks/daily_file_sink.h"
#include "spdlog/sinks/basic_file_sink.h"

#define LOGT(...)  SPDLOG_LOGGER_TRACE(glog,## __VA_ARGS__)
#define LOGD(...)  SPDLOG_LOGGER_DEBUG(glog,## __VA_ARGS__)
#define LOGI(...)  SPDLOG_LOGGER_INFO(glog,## __VA_ARGS__)
#define LOGW(...)  SPDLOG_LOGGER_WARN(glog,## __VA_ARGS__)
#define LOGE(...)  SPDLOG_LOGGER_ERROR(glog,## __VA_ARGS__)
#define LOGC(...)  SPDLOG_LOGGER_CRITICAL(glog,## __VA_ARGS__)

class GLog {

public:
    static GLog &instance() {
        static GLog m_instance;
        return m_instance;
    }

    auto get_logger() const {
        return this->logger_;
    }

private:
    GLog() {
        this->init();
    }

    ~GLog() {
        spdlog::drop_all(); // 释放所有logger
    }

private:
    void init() {
        std::cout << "log init " << std::endl;
        this->init_file();
        this->init_logger();
    }

    void init_file() {
        this->log_root_path = std::string("log/")+getCurrentSystemTime()+"/";
        this->debug_file_path = "debug.log";
        this->info_file_path = "info.log";
        this->warning_file_path = "warning.log";
        this->error_file_path = "error.log";
        this->rotation_h = 5; // 分割时间
        this->rotation_m = 59;
    }

    void init_logger() {

        this->debug_sink_ = std::make_shared<spdlog::sinks::daily_file_sink_mt>(
                this->log_root_path + this->debug_file_path, this->rotation_h, this->rotation_m);
        this->info_sink_ = std::make_shared<spdlog::sinks::daily_file_sink_mt>(
                this->log_root_path + this->info_file_path, this->rotation_h, this->rotation_m);
        this->warning_sink_ = std::make_shared<spdlog::sinks::daily_file_sink_mt>(
                this->log_root_path + this->warning_file_path, this->rotation_h, this->rotation_m);
        this->error_sink_ = std::make_shared<spdlog::sinks::daily_file_sink_mt>(
                this->log_root_path + this->error_file_path, this->rotation_h, this->rotation_m);
        this->console_sink_ = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();

        this->debug_sink_->set_level(spdlog::level::debug); // debug< info< warn< error< critical  日志信息低于设置的级别时, 不予显示
        this->info_sink_->set_level(spdlog::level::info);
        this->warning_sink_->set_level(spdlog::level::warn);
        this->error_sink_->set_level(spdlog::level::err);
        this->console_sink_->set_level(spdlog::level::trace);

        this->sinks_.push_back(this->debug_sink_); // debug
        this->sinks_.push_back(this->info_sink_); // info
        this->sinks_.push_back(this->warning_sink_); // warning
        this->sinks_.push_back(this->error_sink_); // error
        this->sinks_.push_back(this->console_sink_); // console

        this->logger_ = std::make_shared<spdlog::logger>("log_", this->sinks_.begin(), this->sinks_.end());
        this->logger_->set_level(spdlog::level::trace);
        this->logger_->set_pattern("[%D %H:%M:%S.%e][T %t][%^%L%$] - %v  [%s %!:%#]");
        this->logger_->flush_on(spdlog::level::warn); // 设置当触发 info 或更严重的错误时立刻刷新日志到 disk
        spdlog::register_logger(this->logger_); // 注册logger
        spdlog::flush_every(std::chrono::seconds(10)); // 每隔10秒刷新一次日志
    }
    std::string getCurrentSystemTime() {
        time_t rawtime;
        struct tm ptm;
        time(&rawtime);
        localtime_s(&ptm, &rawtime);
        char date[60] = {0};
        sprintf_s(date, "%d-%02d-%02d",
                (int) ptm.tm_year + 1900, (int) ptm.tm_mon + 1, (int) ptm.tm_mday);
        return move(std::string(date));
    }
private:
    std::shared_ptr<spdlog::logger> logger_;
    std::shared_ptr<spdlog::sinks::daily_file_sink_mt> debug_sink_; // debug
    std::shared_ptr<spdlog::sinks::daily_file_sink_mt> info_sink_; // info
    std::shared_ptr<spdlog::sinks::daily_file_sink_mt> warning_sink_; // warning
    std::shared_ptr<spdlog::sinks::daily_file_sink_mt> error_sink_; // error
    std::shared_ptr<spdlog::sinks::stdout_color_sink_mt> console_sink_; // console
    std::vector<spdlog::sink_ptr> sinks_;
    std::string debug_file_path;
    std::string info_file_path;
    std::string warning_file_path;
    std::string error_file_path;
    std::string log_root_path;
    short int rotation_h{};
    short int rotation_m{};

}; // GLog


#define glog GLog::instance().get_logger()
