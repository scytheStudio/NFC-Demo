import QtQuick 2.12
import com.scythestudio.nfc 1.0
import "../"
import "../controls"

Item {
  id: root

  signal saved()

  states: [
    State {
      name: "saveTag"
      PropertyChanges {
        target: saveDetailsItem
        visible: false
      }
      PropertyChanges {
        target: saveTagItem
        visible: true
      }
    }
  ]

  Item {
    id: saveDetailsItem
    anchors.fill: parent
    visible: true

    property string error: ""

    Column {
      width: parent.width * 0.8
      anchors.centerIn: parent

      spacing: 30

      Text {
        id: saveDetailsText
        width: parent.width

        color: theme.textColor
        text: "Input dish name and desired cooking time. It will be saved on tag"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
      }

      Rectangle {
        width: parent.width
        height: dishnameTextInput.implicitHeight

        color: "transparent"
        border {
          color: theme.textColor
          width: 1
        }

        Text {
          id: dishnameTextPlaceholderText
          anchors.fill: dishnameTextInput
          visible: dishnameTextInput.displayText == ""

          font: dishnameTextInput.font
          color: Qt.darker(theme.textColor)
          padding: dishnameTextInput.padding
          text: "Chicken"
        }

        TextInput {
          id: dishnameTextInput

          width: parent.width

          font.pixelSize: saveDetailsText.font.pixelSize * 2
          color: dishnameTextInput.focus ? theme.tintColor : theme.textColor
          cursorVisible: false
          padding: 10
        }
      }

      CustomTumbler {
        id: tumbler

        anchors.horizontalCenter: parent.horizontalCenter
      }

      CustomButton {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Save Tag"

        onClicked: {
          var dishname = dishnameTextInput.displayText
          var seconds = tumbler.getSeconds()

          if (dishname == "") {
            saveDetailsItem.error = "Dish name can not be empty"
            return
          }

          if (seconds <= 0) {
            saveDetailsItem.error = "You need to set cooking time"
            return
          }

          root.startSaving(dishname, seconds)
        }
      }

      Text {
        width: parent.width
        visible: saveDetailsItem.error != ""

        color: theme.errorColor
        text: saveDetailsItem.error
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
      }
    }

    function resetInputFields() {
      root.state = ""
      saveDetailsItem.error = ""
      dishnameTextPlaceholderText.text = "Chicken"
      dishnameTextInput.text = ""
      tumbler.reset()
      nfcManager.stopDetecting()
    }
  }

  Item {
    id: saveTagItem
    anchors.fill: parent
    visible: false

    Text {
      id: noTagInRangeText

      width: parent.width * 0.8
      visible: !nfcManager.hasTagInRange && nfcManager.actionType === NFCManager.Writing

      anchors {
        top: parent.top
        bottom: pulsatingImage.top
        horizontalCenter: parent.horizontalCenter
      }

      color: theme.textColor
      text: "There is no NFC tag in range.\nTouch tag to save record"
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      wrapMode: Text.WordWrap
    }

    PulsatingImage {
      id: pulsatingImage
      width: parent.width * 0.5
      height: width

      anchors.centerIn: parent
      imageSource: "qrc:/assets/icons/saveTagWhite.png"
    }

    CustomButton {
      text: "Cancel"

      anchors {
        top: pulsatingImage.bottom
        topMargin: 50
        horizontalCenter: parent.horizontalCenter
      }

      onClicked: {
        saveDetailsItem.resetInputFields()
      }
    }
  }

  CustomPopup {
    id: popup

    width: parent.width
    height: parent.height

    onClosed: {
      if (isErrorPopup) {
        saveDetailsItem.resetInputFields()
      } else {
        root.saved()
      }
    }
  }

  onVisibleChanged: {
    saveDetailsItem.resetInputFields()
  }

  Connections {
    target: nfcManager
    enabled: root.visible

    function onNfcError(error) {
      popup.show(error, true)
    }

    function onWroteSuccessfully() {
      popup.show("NFC Tag Saved Successfully", false)
    }
  }

  function startSaving(dishname, seconds) {
    console.log("start saving")
    root.state = "saveTag"
    pulsatingImage.startAnimation()
    nfcManager.saveRecord(dishname, seconds)
  }
}
