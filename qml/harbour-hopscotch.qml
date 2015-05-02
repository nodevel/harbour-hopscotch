import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import org.nemomobile.notifications 1.0
import "pages"
import "pages/components"

ApplicationWindow
{
    id: window
    initialPage: Component { FirstPage { } }
//    initialPage: Component { GridPage { query: 'pubtran' } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    property string email
    property string password
    property string device_id
    property string country
    property string operator
    property int sdklevel
    property bool busy
    property bool loading
    property int perPage: 24

    property string language: 'en'
    property string export_path: '/home/nemo/hopscotch_favorites.json'
    Python {
        id: py

        Component.onCompleted: {
            storage.initialize()
            email = storage.getSetting('email', '')
            password = storage.getSetting('password', '')
            device_id = storage.getSetting('device_id', '')

            country = storage.getSetting('country', '')
            operator = storage.getSetting('operator', '')
            sdklevel = storage.getSetting('sdklevel', 19)

            addImportPath(Qt.resolvedUrl('./py'));
            importModule('hopscotch', function () {
            }) // Importing module
            importModule('hop_parser', function () {
            }) // Importing module
            setHandler('upload_progress', function (index, progress) {
                uploadModel.set(index, {'progress': progress})
            });
        }
    }
    Notification {
        id: notification
        category: "network.conf"
    }
    function url2id(url) {
        var urlString = String(url)
        if (urlString.indexOf('/apps/details?id=') > -1) {
            var appId
            if (urlString.indexOf('&') > -1) appId = urlString.substring(urlString.indexOf("id=")+3,urlString.indexOf("&"))
            else appId = urlString.substring(urlString.indexOf("id=")+3)
            return appId
        } else {
            notify('error', 'Error: Not an app.')
        }
    }
    function getApp(appId, install) {
        busy = true
        var path
        if (install) {
            path = '/tmp'
        } else {
            // TODO setting
            path = '/home/nemo/Downloads'
        }
        notify('info', 'Downloading '+appId+'...')
        py.call('hopscotch.download', [appId, email, password, country, operator, device_id, path], function(result) {
            if (result) { // checking if the download was successful
                if (install) {
                    Qt.openUrlExternally(path + '/' + appId + '.apk')
                } else {
                    notify('info', 'Download successful. File saved to Downloads')
                }

                busy = false
            } else {
                busy = false
                notify('error', 'Download unsuccessful, check your credentials.')
            }
        });
    }
    Storage { id: storage }

    Component {
        id: firstPage
        FirstPage {}

    }
    BusyIndicator {
        running: (busy || loading)
        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
    }
    signal notify (string category, string message)
    // category is either 'error', or 'info'
    onNotify: {
        if (category == 'error') {
            category = 'network.error.conf'
        } else {
            category = 'network.conf'
        }
        notification.category = category
        notification.previewBody = qsTr('Hopscotch');
        notification.previewSummary = message;
        notification.publish();
    }
    signal inputDialog ( string type )
    onInputDialog: {
        // workaround for an error
        if (type == 'search') {
            var dialog = pageStack.push(Qt.resolvedUrl("pages/components/InputDialog.qml"), { 'type': type })
            dialog.accepted.connect(function() {
                dialogTimerNew.query = dialog.output
                dialogTimerNew.start()
            })
        } else if (type == 'url' || type == 'id') {
            pageStack.pop(null)
            pageStack.completeAnimation()
            var dialog = pageStack.push(Qt.resolvedUrl("pages/components/InputDialog.qml"), { 'type': type })
            dialog.accepted.connect(function() {
                if (dialog.output.indexOf("play.google.com") === -1) type = 'id'
                var url = { 'search': 'https://play.google.com/store/search?q=', 'id': 'https://play.google.com/store/apps/details?id=', 'url': '' }[type]

                dialogTimer.url = url+dialog.output
                dialogTimer.start()
            })
        }
    }

    Timer {
        id: dialogTimer
        property string url
        interval: 500
        repeat: false
        running: false
        onTriggered: {
            pageStack.completeAnimation()
            pageStack.push(Qt.resolvedUrl("pages/AppPage.qml"), { 'param': {'id': url} } )
        }
    }
    Timer {
        id: dialogTimerNew
        property string query
        interval: 500
        repeat: false
        running: false
        onTriggered: {
            pageStack.completeAnimation()
            pageStack.push(Qt.resolvedUrl("pages/GridPage.qml"), { 'query': query } )
        }
    }
}


