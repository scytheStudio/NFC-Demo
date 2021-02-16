import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: root

    property color backgroundColor: theme.tintColor

    contentItem: Text {
        text: root.text
        font: root.font
        opacity: enabled ? 1.0 : 0.3
        color: root.down ? Qt.darker(theme.textColor) : theme.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        opacity: enabled ? 1 : 0.3
        color: root.down ? Qt.darker(root.backgroundColor) : root.backgroundColor
        radius: 5
    }
}
