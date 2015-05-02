import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0

Page {
    id: page

    property string url
    property bool favorite: false

    allowedOrientations: Orientation.Landscape | Orientation.Portrait

    Loader {
        anchors.fill: parent
        sourceComponent: parent.status === PageStatus.Active ? webComponent : undefined
    }

    Component {
        id: webComponent

        SilicaWebView {
            id: webview
            header: PageHeader {
                id: webHeader
                title: webview.title
            }
            url: page.url
            onUrlChanged: {
                if (String(webview.url).indexOf('/apps/details?id=') > -1) {
                    favorite = storage.inFavorites({'id': url2id(url)})
                }
            }

            pullDownMenu: pulleyMenu

            NumberAnimation { id: fadeIn; running: true; target: webview; properties: "opacity"; from: 0; to: 1.0; duration: 500 }

            PullDownMenu {
                id: pulleyMenu
                MenuItem {
                    text: favorite ? qsTr("Remove from Favorites") : qsTr("Add to Favorites")
                    onClicked: {
                        if (favorite) {
                            remorse.execute("Removing from favorites", function() { storage.removeFavorite({'id': url2id(webview.url)}); favorite = false })
                        } else {
                            remorse.execute("Adding to favorites", function() { storage.saveFavorite({'id': url2id(webview.url), 'cover': "image://theme/icon-launcher-default", 'author': '', 'rating': 0, 'name': String(webview.title).split(' - ')[0], 'price': qsTr('Unknown'), 'type': 'unknown' }); favorite = true })
                            remorse.execute("Adding to favorites", function() { storage.saveFavorite(param); favorite = true })
                        }
                    }
                    enabled: (String(webview.url).indexOf('/apps/details?id=') > -1)
                }
                MenuItem {
                    id: downloadMenu
                    text: qsTr("Download")
                    onClicked: download(url2id(webview.url))
                    enabled: (String(webview.url).indexOf('/apps/details?id=') > -1)
                }
                MenuItem {
                    text: qsTr('Install')
                    onClicked: install(url2id(webview.url))
                    enabled: downloadMenu.enabled
                }
            }
            pushUpMenu: pushyMenu

            PushUpMenu {
                id: pushyMenu
                MenuItem {
                    text: qsTr("Scroll up")

                    onClicked: {
                        webview.scrollToTop()
                    }
                }
            }


            // Improve readability
//            experimental.transparentBackground: true;
            experimental.preferences.javascriptEnabled: false
            experimental.preferences.minimumFontSize: 20
            experimental.deviceWidth: page.width / 1.25
            experimental.deviceHeight: page.height
//            experimental.userScripts: [Qt.resolvedUrl("../js/userscripts.js")]
        }
    }
    function download(app_id) {
        remorse.execute("Starting download", function() { getApp(app_id, false) })
    }
    function install(app_id) {
        remorse.execute("Starting installation", function() { getApp(app_id, true) })
    }
    RemorsePopup { id: remorse }

}
