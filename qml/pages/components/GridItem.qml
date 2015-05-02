import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    Image {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: Math.min(parent.width, sourceSize.width)
        height: Math.min(parent.height, sourceSize.height)
        opacity: 0.15
        source: "image://theme/graphic-gradient-corner?" + Theme.highlightBackgroundColor
    }
}
