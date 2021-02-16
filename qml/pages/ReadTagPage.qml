import QtQuick 2.12
import com.scythestudio.nfc 1.0
import "../"
import "../controls"

Item {
  id: root

  signal tagFound(string dishname, int seconds)

  Text {
    id: noTagInRangeText

    width: parent.width * 0.8
    visible: !nfcManager.hasTagInRange && nfcManager.actionType === NFCManager.Reading

    anchors {
      top: parent.top
      bottom: pulsatingImage.top
      horizontalCenter: parent.horizontalCenter
    }

    color: theme.textColor
    text: "There is no NFC tag in range.\nTouch tag to read message"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    wrapMode: Text.WordWrap
  }

  PulsatingImage {
    id: pulsatingImage
    width: parent.width * 0.5
    height: width

    anchors.centerIn: parent
    imageSource: "qrc:/assets/icons/readTagWhite.png"
  }

  CustomPopup {
    id: popup

    width: parent.width
    height: parent.height

    onClosed: {
      if (isErrorPopup) {
        root.startReading()
      }
    }
  }

  onVisibleChanged: {
    if (visible) {
      startReading()
    }
  }

  Connections {
    target: nfcManager
    enabled: root.visible

    function onRecordChanged(record) {
      root.tagFound(record.dishName, record.seconds)
    }

    function onNfcError(error) {
      popup.show(error, true)
    }
  }

  function startReading() {
    console.log("start reading")
    pulsatingImage.startAnimation()
    nfcManager.startReading()
  }
}
