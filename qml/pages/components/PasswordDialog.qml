import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property string text
    property bool remove

    Column {
        width: parent.width

        DialogHeader { }
        TextField {
            id: passwordField
            text: password
            anchors { left: parent.left; right: parent.right }
            echoMode: TextInput.Password
            label: "Password"; placeholderText: label
            EnterKey.enabled: text || inputMethodComposing
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: {
                dialog.accept()
            }
        }
        TextSwitch {
            id: passwordSwitch
            text: qsTr('Save password')
            checked: storage.getSetting('save_password', false)
            onCheckedChanged: {
                if (!checked) {
                    password = ''
                }
                storage.setSetting('save_password', checked)
            }
        }
    }
    onDone: {
        if (result == DialogResult.Accepted) {
            password = passwordField.text
            if (passwordSwitch.checked) {
                storage.setSetting('password', password)
            }
        }
    }
}
