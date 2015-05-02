import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.Landscape | Orientation.Portrait

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width - 2*Theme.paddingLarge

            anchors.centerIn: parent
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("About")
            }
            Label {
                text: qsTr("Hopscotch is a simple unofficial client for the Google Play store.")
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.Wrap
            }
            Label {
                text: qsTr("Author")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                text: "Jakub Kožíšek"
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                text: "2015"
                font.pixelSize: Theme.fontSizeMedium
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                text: qsTr("Donate")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                text: qsTr("If you enjoy this application and want to see more features, then please consider a small (or bigger) donation.")
                font.pixelSize: Theme.fontSizeMedium
                width: parent.width - 2*Theme.paddingLarge
                wrapMode: Text.Wrap
            }
            Button {
                text: qsTr('Donate in EUR')
                onClicked: Qt.openUrlExternally('https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=2ZP5SYMN4DDGJ')
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: qsTr('Donate in USD')
                onClicked: Qt.openUrlExternally('https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=F3HRVJYWS4WMW')
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: qsTr('Donate in CZK')
                onClicked: Qt.openUrlExternally('https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=XXMRQDRBTWVHJ')
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: qsTr("Data")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("This unofficial Google Play client is in no way affiliated with Google or Android. The author is not responsible for the content. Use on your own risk.")
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("© 2012 Google Inc. All rights reserved. Google and the Google Logo are registered trademarks of Google Inc.")
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("Android™, Android Market™ and Google Play are trademarks of Google Inc.")
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("This application is available under the GPL license.")
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}


