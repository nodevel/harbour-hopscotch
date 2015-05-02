import QtQuick 2.0
import Sailfish.Silica 1.0
import "components"

Page {
    id: page
    property var param
    property bool favorite: false
    SilicaFlickable {
        contentHeight: column.height
        anchors.fill: parent
        PullDownMenu {
            id: pulleyMenu
            MenuItem {
                text: favorite ? qsTr("Remove from Favorites") : qsTr("Add to Favorites")
                onClicked: {
                    if (favorite) {
                        remorse.execute("Removing from favorites", function() { storage.removeFavorite(param); favorite = false })
                    } else {
                        remorse.execute("Adding to favorites", function() { storage.saveFavorite(param); favorite = true })
                    }
                }
            }
            MenuItem {
                id: downloadMenu
                text: qsTr("Download")
                onClicked: download()
            }
            MenuItem {
                text: qsTr('Install')
                onClicked: install()
            }
        }

        Column {
            id: column
            anchors.fill: parent
            spacing: Theme.paddingMedium
            //
            PageHeader {
                title: param.name
            }
            Image {
                source: param.cover
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 2
                height: width
            }
            Item {
                height: Theme.paddingLarge
            }
            RatingIndicator {
                height: Theme.paddingLarge
                maximumValue: 5
                ratingValue: param.rating
                anchors.horizontalCenter: parent.horizontalCenter
            }
            DetailItem {
                label: "Votes"
                value: param.votes
            }
            DetailItem {
                label: "Price"
                value: param.price ? param.price : 'Free'
            }
            DetailItem {
                label: "Author"
                value: param.author
                // author_id
                MouseArea {
                    anchors.fill: parent
                    onClicked: pageStack.push(Qt.resolvedUrl("GridPage.qml"), { 'category': 'developer', 'query': param.author_id })
                }

            }
            DetailItem {
                label: "Version"
                value: param.version
            }
            DetailItem {
                label: "Date"
                value: param.date
            }
            DetailItem {
                label: "Size"
                value: param.size
            }
            DetailItem {
                label: "Downloads"
                value: param.downloads
            }
            DetailItem {
                label: "Category"
                value: param.category
            }
            Label {
                text: param.description
                width: parent.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                truncationMode: TruncationMode.Fade
                color: Theme.primaryColor
            }
            Label {
                text: param.subtitle
                width: parent.width - 2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                truncationMode: TruncationMode.Fade
                color: Theme.secondaryColor
            }

        }
    }
    ListModel { id: recModel }
    ListModel { id: screenModel }
    Component.onCompleted: {
        loading = true
        var type_tmp = param.type
        py.call('hop_parser.app', [param.id, language], function(result) {
            console.log(Object.keys(result))
            param = result
            param.type = type_tmp
            for (var i = 0; i < result.recommendations.length; i++) {
                recModel.append({ 'Id': result.recommendations[i]})
            }
            for (var j = 0; j < result.screenshots.length; j++) {
                screenModel.append({ 'image_url': result.screenshots[j] })
            }
            loading = false
        });
        favorite = storage.inFavorites(param)
        console.log(favorite)
    }
    function download(app_id) {
        remorse.execute("Starting download", function() { getApp(app_id, false) })
    }
    function install(app_id) {
        remorse.execute("Starting installation", function() { getApp(app_id, true) })
    }
    RemorsePopup { id: remorse }
}
