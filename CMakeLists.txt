cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME RobotGroundControl)

project(${PROJECT_NAME} VERSION 0.1 LANGUAGES CXX)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)

set(MY_QML_MOUDLE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/ui)

set(QML_IMPORT_PATH ${MY_QML_MOUDLE_PATH} CACHE STRING "")
set(QML2_IMPORT_PATH ${MY_QML_MOUDLE_PATH} CACHE STRING "")
set(QML_DESIGNER_IMPORT_PATH ${MY_QML_MOUDLE_PATH} CACHE STRING "")

#=======================================
# -log
include_directories(libs/spdlog/include)

#=======================================eigen
include_directories(libs/eigen/Eigen)

#=======================================YAML
include_directories(libs/YAML/include)

link_directories(
        libs/YAML/lib
)

#=======================================opencv
include_directories(
    opencv
    opencv/include
)
link_directories(
    opencv/lib
)

#------------Mavlink--------------
include_directories(
    src/link/mavlink
    src/link/mavlink/common
)

set(GLOB OPENCV_LIBS
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/*.lib
)

include_directories(
        src
        src/tools/log
        src/tools/other
        src/link
        src/link/udp
        src/link/tcp
        src/json
        src/vehicle
        src/vehicle/plan
        src/algorithm
        opencv

        ffmpeg
        ffmpeg/ffmpeg4/include64
        src/geo

)


FILE(GLOB SOURCE_FILES
        src/*.*
        src/sql/*.*
        src/tools/log/*.*
        src/tools/other/*.*
        src/link/*.*
        src/link/udp/*.*
        src/link/tcp/*.*
        src/json/*.*
        src/vehicle/*.*
        src/vehicle/plan/*.*
        src/algorithm/*.*
        ffmpeg/*.cpp
        opencv/*.*
        src/geo/*.*

)

#find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick)
#find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick)

find_package(Qt5 ${QT_VERSION}
    COMPONENTS
    Bluetooth
    Charts
    Concurrent
    Core
    Location
    Multimedia
    Network
    SerialPort
    Positioning
    Quick
    QuickControls2
    QuickWidgets
    OpenGL
    Sql
    Svg
    Test
    TextToSpeech
    Widgets
    Xml
    Gamepad
    REQUIRED
    HINTS
    ${QT_LIBRARY_HINTS}
)


set(PROJECT_SOURCES
    groundcontrol.qrc
    gcimages.qrc
)

add_executable(${PROJECT_NAME}
    ${PROJECT_SOURCES}
    ${EXT_RESOURCES}
    ${SOURCE_FILES}
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Bluetooth
    Qt${QT_VERSION_MAJOR}::Charts
    Qt${QT_VERSION_MAJOR}::Concurrent
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Location
    Qt${QT_VERSION_MAJOR}::Multimedia
    Qt${QT_VERSION_MAJOR}::Network
    Qt${QT_VERSION_MAJOR}::Positioning
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::QuickControls2
    Qt${QT_VERSION_MAJOR}::QuickWidgets
    Qt${QT_VERSION_MAJOR}::OpenGL
    Qt${QT_VERSION_MAJOR}::Sql
    Qt${QT_VERSION_MAJOR}::Svg
    Qt${QT_VERSION_MAJOR}::Test
    Qt${QT_VERSION_MAJOR}::TextToSpeech
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::Xml
    Qt${QT_VERSION_MAJOR}::SerialPort
    Qt${QT_VERSION_MAJOR}::Gamepad
    ${CMAKE_CURRENT_SOURCE_DIR}/libs/spdlog/lib/spdlogd.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/libs/YAML/lib/yaml-cppd.lib
    #    ${CMAKE_CURRENT_SOURCE_DIR}/libs/spdlog/winlib/spdlogd.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/ffmpeg4/winlib64/avcodec.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/ffmpeg4/winlib64/avfilter.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/ffmpeg4/winlib64/avformat.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/ffmpeg4/winlib64/swscale.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/ffmpeg4/winlib64/avutil.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/ffmpeg4/winlib64/swresample.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/ffmpeg4/winlib64/avdevice.lib

    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_bgsegm480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_bioinspired480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_calib3d480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_ccalib480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_core480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_cvv480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_datasets480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_dnn_objdetect480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_dnn_superres480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_dnn480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_dpm480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_face480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_features2d480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_flann480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_fuzzy480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_gapi480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_hfs480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_highgui480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_img_hash480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_imgcodecs480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_imgproc480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_intensity_transform480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_line_descriptor480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_mcc480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_ml480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_objdetect480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_optflow480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_phase_unwrapping480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_plot480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_quality480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_rapid480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_reg480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_rgbd480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_saliency480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_shape480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_stereo480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_stitching480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_structured_light480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_superres480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_surface_matching480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_text480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_tracking480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_video480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_videoio480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_videostab480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_wechat_qrcode480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_xfeatures2d480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_ximgproc480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_xobjdetect480d.lib
    ${CMAKE_CURRENT_SOURCE_DIR}/opencv/lib/opencv_xphoto480d.lib

)

set_target_properties(${PROJECT_NAME} PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

