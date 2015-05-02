import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property string output
    property string type
    property string text

    Column {
        width: parent.width

        DialogHeader { }
        TextField {
            id: inputField
            text: dialog.text
            focus: true
            anchors { left: parent.left; right: parent.right }
            label: { 'search': "Search term", 'url': "URL/Application ID" }[type]
            placeholderText: label
            EnterKey.enabled: text
            EnterKey.iconSource: "image://theme/icon-m-search"
            EnterKey.onClicked: {
                dialog.accept()
            }
        }
    }
    onAccepted: output = inputField.text
}
