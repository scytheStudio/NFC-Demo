import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import com.scythestudio.nfc 1.0
import "../"
import "../controls"

Item {
  id: root

  signal readButtonClicked
  signal saveButtonClicked

  state: "noTimer"
  states: [
    State {
      name: "noTimer"
      PropertyChanges {
        target: noTimerItem
        visible: true
      }
      PropertyChanges {
        target: clockItem
        visible: false
      }
      PropertyChanges {
        target: alarmItem
        visible: false
      }
    },
    State {
      name: "countdown"
      PropertyChanges {
        target: noTimerItem
        visible: false
      }
      PropertyChanges {
        target: clockItem
        visible: true
      }
      PropertyChanges {
        target: alarmItem
        visible: false
      }
    },
    State {
      name: "alarm"
      PropertyChanges {
        target: noTimerItem
        visible: false
      }
      PropertyChanges {
        target: clockItem
        visible: false
      }
      PropertyChanges {
        target: alarmItem
        visible: true
      }
    }
  ]

  Item {
    id: noTimerItem
    anchors.fill: parent
    visible: true

    Column {
      width: parent.width * 0.8
      anchors.centerIn: parent

      spacing: 30

      Text {
        width: parent.width

        color: theme.textColor
        text: "There is no active timer. What do you wish to do?"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
      }

      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20

        CustomButton {
          text: "Read Tag"

          onClicked: {
            root.readButtonClicked()
          }
        }

        CustomButton {
          text: "Save Tag"

          onClicked: {
            root.saveButtonClicked()
          }
        }
      }
    }
  }

  Item {
    id: clockItem

    anchors.fill: parent
    visible: false

    Column {
      width: parent.width * 0.8
      anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: dishImageItem.top
        bottomMargin: 40
      }

      spacing: 30

      Text {
        id: dishInProgressText
        width: parent.width

        property string standardText: _.dishName + " in progress"

        color: theme.textColor
        text: standardText
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        Timer {
          repeat: true
          running: countdownTimer.running
          interval: countdownTimer.interval

          property int visibleDots: 0

          onTriggered: {
            if (visibleDots == 3) {
              dishInProgressText.text = dishInProgressText.standardText
              visibleDots = 0
              return
            }

            dishInProgressText.text += "."
            visibleDots++
          }
        }
      }

      Text {
        width: parent.width

        color: theme.textColor
        font {
          pixelSize: dishInProgressText.font.pixelSize * 2
          bold: true
        }

        text: _.secondsAsHms()
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
      }
    }

    Item {
      id: dishImageItem
      width: dishImage.maxSize
      height: width
      anchors.centerIn: parent

      Image {
        id: dishImage

        readonly property int standardSize: 100
        readonly property int maxSize: standardSize * 1.3

        width: standardSize
        height: width
        anchors.centerIn: parent

        source: "qrc:/assets/bake.png"

        SequentialAnimation on width {
          loops: Animation.Infinite
          running: countdownTimer.running

          PropertyAnimation {
            duration: 1000
            to: dishImage.standardSize
          }
          PropertyAnimation {
            duration: 1000
            to: dishImage.maxSize
          }
        }
      }
    }
  }

  Item {
    id: alarmItem
    anchors.fill: parent
    visible: false

    Column {
      width: parent.width * 0.8
      anchors.centerIn: parent

      spacing: 30

      Text {
        width: parent.width

        color: theme.textColor
        font {
          pixelSize: dishInProgressText.font.pixelSize * 2
          bold: true
        }
        text: _.dishName + " is ready!"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
      }

      CustomButton {
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Dismiss alarm"

        onClicked: {
          console.log("alarm dismissed")
          alarmSoundEffect.stop()
          root.state = "noTimer"
        }
      }
    }
  }

  Timer {
    id: countdownTimer

    interval: 1000
    repeat: true
    running: _.seconds > 0

    onTriggered: {
      if (_.seconds > 0) {
        _.seconds--

        if (_.seconds == 0) {
          console.log("ALARM")
          root.state = "alarm"
          alarmSoundEffect.play()
        }
      }
    }
  }

  SoundEffect {
    id: alarmSoundEffect

    loops: SoundEffect.Infinite
    source: "qrc:/assets/alarm.wav"
  }

  QtObject {
    id: _

    property int seconds: 0
    property string dishName: ""

    function secondsAsHms() {
      var h = Math.floor(_.seconds / 3600)
      var m = Math.floor(_.seconds % 3600 / 60)
      var s = Math.floor(_.seconds % 3600 % 60)

      var hDisplay = h < 10 ? '0' + h : h
      var mDisplay = m < 10 ? '0' + m : m
      var sDisplay = s < 10 ? '0' + s : s

      return hDisplay + ':' + mDisplay + ':' + sDisplay
    }
  }

  onVisibleChanged: {
    if (visible) {
      // NFC detecting is not necessary on this page
      nfcManager.stopDetecting()
    }
  }

  function startCountdown(dishname, seconds) {
    _.dishName = dishname
    _.seconds = seconds
    root.state = "countdown"
  }
}
