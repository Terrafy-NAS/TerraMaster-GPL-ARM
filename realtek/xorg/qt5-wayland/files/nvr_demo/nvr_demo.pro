QT += widgets

HEADERS       = dialog.h
SOURCES       = dialog.cpp \
                main.cpp

# install
target.path = $$[QT_INSTALL_EXAMPLES]/widgets/dialogs/nvr_demo
INSTALLS += target

CONFIG += link_pkgconfig
PKGCONFIG += gstreamer-1.0
LIBS += -lrtkcontrol -lrtkrtsp
wince50standard-x86-msvc2005: LIBS += libcmt.lib corelibc.lib ole32.lib oleaut32.lib uuid.lib commctrl.lib coredll.lib winsock.lib ws2.lib
