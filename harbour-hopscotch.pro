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
    qml/cover/cover.png \
    qml/pages/GridPage.qml \
    qml/pages/components/CustomXmlModel.qml \
    qml/pages/AppPage.qml \
    qml/py/hop_parser.py \
    qml/pages/components/RatingIndicator.qml \
    qml/pages/components/GridItem.qml \
    qml/py/LICENSE \
    qml/py/README \
    qml/py/AssetRequest.py \
    qml/py/compat.py \
    qml/py/ExtendedOptionParser.py \
    qml/py/hopscotch.py \
    qml/py/Market.py \
    qml/py/OperatorModel.py \
    qml/py/server.py \
    qml/py/Util.py \
    qml/py/ProtocolBuffer.py

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-hopscotch-de.ts

