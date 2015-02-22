import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        id: listView
        model: menuModel
        anchors.fill: parent
        header: PageHeader {
            title: "Hopscotch"
        }
        PullDownMenu {
            MenuItem {
                text: qsTr('Configuration wizard')
                onClicked: pageStack.push(Qt.resolvedUrl("WizardPage.qml"), { })
            }
        }

        delegate: BackgroundItem {
            id: delegate
            height: Theme.itemSizeLarge*1.5
            Image {
                id: menuIcon
                source: icon
                x: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                text: title
                anchors {
                    left: menuIcon.right
                    margins: Theme.paddingLarge
                    verticalCenter: parent.verticalCenter
                }
                font.pixelSize: Theme.fontSizeExtraLarge
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                var dialog
                switch (category) {
                    case 'main':
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), { 'url': 'https://play.google.com' });
                    case 'about':
                        pageStack.push(Qt.resolvedUrl("AboutPage.qml"), { } )
                    default:
                        inputDialog(category);
                }
            }
        }
        VerticalScrollDecorator {}
    }
    ListModel {
        id: menuModel
        ListElement {
            title: 'Main page'
            icon: "image://theme/icon-m-computer"
            category: 'main'
        }
        ListElement {
            title: 'Search'
            icon: "image://theme/icon-m-search"
            category: 'search'
        }
        ListElement {
            title: 'Open URL'
            icon: "image://theme/icon-m-region"
            category: 'url'
        }
        ListElement {
            title: 'App ID'
            icon: "image://theme/icon-m-link"
            category: 'id'
        }
        ListElement {
            title: 'About'
            icon: "image://theme/icon-m-question"
            category: 'about'
        }
    }

    Component.onCompleted: timer.start()
    Timer {
        id: timer
        interval: 500
        repeat: false
        running: false
        onTriggered: {
            //
            if (!email) {
                pageStack.push(Qt.resolvedUrl("WizardPage.qml"), { })
            } else if (!password) {
                var dialog = pageStack.push(Qt.resolvedUrl("components/PasswordDialog.qml"), {})
                dialog.accepted.connect(function() {
                    // TODO notification
                    notify('info', 'Password set.')
                })
            }
        }
    }
}


