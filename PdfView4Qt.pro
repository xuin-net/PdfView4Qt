QT += quick concurrent

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        pdfprovider.cpp

RESOURCES += qml.qrc

TRANSLATIONS += \
    PdfView4Qt_zh_CN.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# 拷贝PDF文件
CONFIG += file_copies

pdfFile.files = $$PWD/asset/210207_Client@xuin.pdf
# 配置需要复制的目标目录, $$OUT_PWD为QMake内置变量，含义为程序输出目录
pdfFile.path = $$OUT_PWD

# 配置COPIES
COPIES += pdfFile

#mupdf
INCLUDEPATH += $$PWD/include
DEPENDPATH  += $$PWD/include

macx {
    LIBS += -L$$PWD/libs/mac/mupdf/ -lmupdf
    PRE_TARGETDEPS += $$PWD/libs/mac/mupdf/libmupdf.a

    LIBS += -L$$PWD/libs/mac/mupdf/ -lmupdf-third
    PRE_TARGETDEPS += $$PWD/libs/mac/mupdf/libmupdf-third.a
}

win32 {
    LIBS += -L$$PWD/libs/win/mupdf/ -llibmupdf
    PRE_TARGETDEPS += $$PWD/libs/win/mupdf/libmupdf.lib

    LIBS += -L$$PWD/libs/win/mupdf/ -llibresources
    PRE_TARGETDEPS += $$PWD/libs/win/mupdf/libresources.lib

    LIBS += -L$$PWD/libs/win/mupdf/ -llibthirdparty
    PRE_TARGETDEPS += $$PWD/libs/win/mupdf/libthirdparty.lib
}

HEADERS += \
    pdfprovider.h
