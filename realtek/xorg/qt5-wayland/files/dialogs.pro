TEMPLATE      = subdirs
SUBDIRS       = classwizard \
                configdialog \
                standarddialogs \
                tabdialog \
                trivialwizard \
		nvr_demo

!wince {
    SUBDIRS += \
        licensewizard \
        extension \
        findfiles
}

!qtHaveModule(printsupport): SUBDIRS -= licensewizard
contains(DEFINES, QT_NO_WIZARD): SUBDIRS -= trivialwizard licensewizard classwizard
wince: SUBDIRS += sipdialog
