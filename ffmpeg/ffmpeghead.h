#ifndef FFMPEGHEAD_H
#define FFMPEGHEAD_H

//必须加以下内容,否则编译不能通过,为了兼容C和C99标准
#ifndef INT64_C
#define INT64_C
#define UINT64_C
#endif

//引入ffmpeg头文件
extern "C" {
#include "libavutil/opt.h"
#include "libavutil/time.h"
#include "libavutil/frame.h"
#include "libavutil/pixdesc.h"
#include "libavutil/avassert.h"
#include "libavutil/imgutils.h"
#include "libavutil/ffversion.h"
#include "libavcodec/avcodec.h"
#include "libavcodec/dxva2.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavformat/avformat.h"
#include "libavfilter/avfilter.h"

#ifdef ffmpegdevice
#include "libavdevice/avdevice.h"
#endif

#ifndef gcc45
#include "libavutil/hwcontext.h"
#include "libavutil/hwcontext_qsv.h"
#endif
}

#include "qdatetime.h"
#pragma execution_character_set("utf-8")

#define TIMEMS          qPrintable(QTime::currentTime().toString("HH:mm:ss zzz"))
#define TIME            qPrintable(QTime::currentTime().toString("HH:mm:ss"))
#define QDATE           qPrintable(QDate::currentDate().toString("yyyy-MM-dd"))
#define QTIME           qPrintable(QTime::currentTime().toString("HH-mm-ss"))
#define DATETIME        qPrintable(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"))
#define STRDATETIME     qPrintable(QDateTime::currentDateTime().toString("yyyy-MM-dd-HH-mm-ss"))
#define STRDATETIMEMS   qPrintable(QDateTime::currentDateTime().toString("yyyy-MM-dd-HH-mm-ss-zzz"))

/// <summary>
/// 硬件加速选项
/// </summary>
typedef enum
{
    AC_HARDWAREACCELERATETYPE_DISABLED,
    AC_HARDWAREACCELERATETYPE_AUTO,
    //使用dxva解码,仅在Windows有效,成功启动：started、display事件的pixformat为AC_PIXELFORMAT_DXVA2_VLD，render事件的data[3]为d3d9的surface对象。
    AC_HARDWAREACCELERATETYPE_DXVA
}ACHardwareAccelerateType;

#endif // FFMPEGHEAD_H
