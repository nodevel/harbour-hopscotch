import QtQuick 2.0
import Sailfish.Silica 1.0
import "components"


Page {
    id: page
    property string category: 'search'
    property int page_n: 0
    property string query
    property string subcategory: 'apps'

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaGridView {
        id: grid
        model: listModel
        anchors.fill: parent
        property int columns: isPortrait ? 3 : 5
        cellWidth: width / columns
        cellHeight: cellWidth*1.2

        ScrollDecorator {}
        onAtYEndChanged: {
            if (atYEnd && count > 0 && !model.busy && !model.lastpage) {
                model.more()
            }
        }
//        PushUpMenu {
//            MenuItem {
//                text: 'Load more'
//                onClicked: listModel.more()
//            }
//        }
        PullDownMenu {
            enabled: (category == 'favorites')
            visible: (category == 'favorites')
            MenuItem {
                text: 'Remove all'
                onClicked: remorse.execute("Removing...", function() { storage.clearFavorites() })
            }
            MenuItem {
                text: 'Import'
                onClicked: remorse.execute("Starting import...", function() { import_favorites() })
            }
            MenuItem {
                text: 'Export'
                onClicked: remorse.execute("Starting export...", function() { export_favorites() })
            }
        }

        header: (category == 'developer' || category == 'favorites') ? classicHeader : searchHeader
        Component {
            id: classicHeader
            PageHeader {
                title: query
            }
        }

        Component {
            id: searchHeader
            SearchField {
                width: grid.width
                text: query
                EnterKey.onClicked: {
                    query = text
                    listModel.refresh()
                }
            }
        }

        delegate: GridItem {
            id: delegate
            width: grid.cellWidth
            height: grid.cellHeight
            clip: true
            Image {
                id: image
                source: cover

                sourceSize.width: grid.cellWidth
                fillMode: Image.PreserveAspectCrop
                width: parent.width / 2
                height: width
                anchors {
                    margins: Theme.paddingMedium
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                }
                Component.onCompleted: console.log(cover)
            }
            Label {
                id: nameLabel
                text: name
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: image.bottom
                    margins: Theme.paddingMedium
                }
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                truncationMode: TruncationMode.Fade
                width: parent.width - 2*Theme.paddingMedium
                font.pixelSize: Theme.fontSizeTiny
            }
            Label {
                id: authorLabel
                text: author
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: nameLabel.bottom
                }
                color: Theme.rgba(Theme.highlightColor, 0.6)
                truncationMode: TruncationMode.Fade
                width: parent.width - 2*Theme.paddingMedium
                font.pixelSize: Theme.fontSizeTiny
            }
            RatingIndicator {
                maximumValue: 100
                ratingValue: rating
                opacity: 0.6
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: authorLabel.bottom
                }
            }

            onClicked: {
                var priceTmp = (price) ? price : ''
                pageStack.push(Qt.resolvedUrl("AppPage.qml"), { 'param': { 'id': Id, 'name': name, 'author': '', 'price': priceTmp, 'rating': rating/20, 'type': subcategory, 'cover': cover } } )
            }
            BusyIndicator {
                anchors.centerIn: parent
                running: !(image.height > 0)
            }
        }
        VerticalScrollDecorator {}
        ViewPlaceholder {
            enabled: grid.count == 0
            text: "No items"
        }
    }
    ListModel {
        id: listModel
        property bool lastpage: false
        signal more
        onMore: {
//            console.log("loading more")
//            if (page_n) {
//                page_n++
//            } else {
//                page_n = 2
//            }
//            load()
        }
        signal load
        onLoad: {
            if (category == 'favorites') {
                listModel.clear()
                var favorites = storage.getFavorites()
                for (var i = 0; i < favorites.length; i++) {
                    listModel.append(favorites[i])
                }
                loading = false
            } else {
                console.log("Load")
                py.call('hop_parser.'+category, [query, subcategory, page_n, perPage], function(result) {
                    console.log(result)
                    console.log(Object.keys(result[1]))
                    for (var i = 0; i < result.length; i++) {
                        listModel.append(result[i])
                    }
                    if (result.length < perPage) lastpage = true
                    else lastpage = false
                    loading = false
                });
            }
        }
        signal refresh
        onRefresh: {
            clear()
            page_n = 0
            load(0)
        }

        Component.onCompleted: {
            loading = true
            load()
        }
    }
    onSubcategoryChanged: refresh()


    function export_favorites() {
        busy = true
        var favorites = storage.getFavorites()
        py.call('hopscotch.export_favorites', [favorites, export_path], function(result) {
            if (result) { // checking if the export was successful
                busy = false
                notify('info', 'Export saved to '+export_path)
            } else {
                busy = false
                notify('error', 'Export failed.')
            }
        });
    }
    function import_favorites() {
        busy = true
        py.call('hopscotch.import_favorites', [export_path], function(result) {
            if (result) { // checking if the import was successful
                for (var i = 0; i < result.length; i++) {
                    storage.saveFavorite(result[i])
                }
                listModel.refresh()
                busy = false
                notify('info', 'Import successful.')
            } else {
                busy = false
                notify('error', 'Import failed.')
            }
        });
    }
    RemorsePopup { id: remorse }
}


