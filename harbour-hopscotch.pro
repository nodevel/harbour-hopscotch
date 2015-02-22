# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-hopscotch

CONFIG += sailfishapp

SOURCES += src/harbour-hopscotch.cpp

OTHER_FILES += qml/harbour-hopscotch.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-hopscotch.changes.in \
    rpm/harbour-hopscotch.spec \
    rpm/harbour-hopscotch.yaml \
    translations/*.ts \
    harbour-hopscotch.desktop \
    qml/pages/WebViewPage.qml \
    qml/pages/WizardPage.qml \
    qml/pages/components/Storage.qml \
    qml/pages/components/PasswordDialog.qml \
    qml/pages/components/InputDialog.qml \
    qml/pages/AboutPage.qml \
    qml/cover/cover.png

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-hopscotch-de.ts

