import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Popup {
  id: root

  property string message: ""
  property bool isErrorPopup: false
  readonly property color mainColor: root.isErrorPopup ? theme.errorColor : theme.tintColor

  modal: true
  focus: true
  closePolicy: Popup.NoAutoClose

  background: Rectangle {
    opacity: 0.2
    color: "black"
  }

  Rectangle {
    id: content
    anchors.centerIn: parent
    width: root.width * 0.8
    height: contentColumn.height + 2 * 20

    color: theme.backgroundColor
    radius: 10

    Column {
      id: contentColumn
      anchors.centerIn: parent
      width: parent.width
      spacing: 20

      Text {
        anchors.horizontalCenter: parent.horizontalCenter

        color: root.mainColor
        font.bold: true
        text: root.isErrorPopup ? "Error" : "Success"
      }

      Text {
        anchors.horizontalCenter: parent.horizontalCenter

        color: theme.textColor
        text: root.message
      }

      CustomButton {
        anchors.horizontalCenter: parent.horizontalCenter

        backgroundColor: root.mainColor
        text: "Ok"

        onClicked: {
          root.close()
        }
      }
    }
  }

  DropShadow {
    anchors.fill: content

    radius: 18
    samples: 37
    color: root.mainColor
    source: content
    transparentBorder: true
  }

  function show(message, isErrorPopup) {
    root.message = message
    root.isErrorPopup = isErrorPopup
    root.open()
  }
}
