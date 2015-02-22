import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property string output
    property string type

    Column {
        width: parent.width

        DialogHeader { }
        TextField {
            id: inputField
            text: dialog.text
            focus: true
            anchors { left: parent.left; right: parent.right }
            label: { 'search': "Search term", 'id': "Application ID", 'url': 'URL' }[type]
            placeholderText: label
            EnterKey.enabled: text
            EnterKey.iconSource: "image://theme/icon-m-search"
            EnterKey.onClicked: {
                dialog.accept()
            }
        }
    }
    onDone: {
        if (result === DialogResult.Accepted) {
            output = inputField.text
        }
    }
}
