import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0

Page {
    id: page

    property string url

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
            pullDownMenu: pulleyMenu

            NumberAnimation { id: fadeIn; running: true; target: webview; properties: "opacity"; from: 0; to: 1.0; duration: 500 }

            PullDownMenu {
                id: pulleyMenu
                MenuItem {
                    id: downloadMenu
                    text: qsTr("Download")
                    onClicked: getApp(url2id(webview.url), false)
                    enabled: (String(webview.url).indexOf('/apps/details?id=') > -1)
                }
                MenuItem {
                    text: qsTr('Install')
                    onClicked: getApp(url2id(webview.url), true)
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

}
