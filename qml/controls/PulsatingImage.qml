import QtQuick 2.15
import QtQuick.Particles 2.15

Item {
  id: root

  readonly property real maxHeight: root.height
  readonly property int pulseInterval: 800

  property alias imageSource: image.source

  Rectangle {
    id: rectangleOne
    anchors.centerIn: imageRec
    height: imageRec.height * 0.7
    width: height
    radius: height / 2
    z: 1
    color: theme.backgroundColor
  }

  PropertyAnimation {
    id: rectangleOneAnim
    target: rectangleOne
    property: "height"
    from: imageRec.height * 0.7
    to: maxHeight
    duration: root.pulseInterval * 5
    loops: Animation.Infinite

    onStarted: {
      delayTimer.targetAnimationIndex = 2
      delayTimer.start()
    }
  }

  Timer {
    running: rectangleOneAnim.running
    repeat: true
    interval: rectangleOneAnim.duration

    onTriggered: {
      rectangleOne.z = 3
      rectangleTwo.z -= 1
      rectangleThree.z -= 1
    }
  }

  Rectangle {
    id: rectangleTwo
    anchors.centerIn: imageRec
    z: 2
    height: imageRec.height * 0.7
    width: height
    radius: height / 2
    color: theme.secondaryBackgroundColor
  }

  PropertyAnimation {
    id: rectangleTwoAnim
    target: rectangleTwo
    property: "height"
    from: imageRec.height * 0.7
    to: maxHeight
    duration: root.pulseInterval * 5
    loops: Animation.Infinite
    onStarted: {
      delayTimer.targetAnimationIndex = 3
      delayTimer.start()
    }
  }

  Timer {
    running: rectangleTwoAnim.running
    repeat: true
    interval: rectangleTwoAnim.duration

    onTriggered: {
      rectangleTwo.z = 3
      rectangleOne.z -= 1
      rectangleThree.z -= 1
    }
  }

  Rectangle {
    id: rectangleThree
    anchors.centerIn: imageRec
    z: 3
    height: imageRec.height * 0.7
    width: height
    radius: height / 2
    color: Qt.lighter(theme.secondaryBackgroundColor)

  }

  PropertyAnimation {
    id: rectangleThreeAnim
    target: rectangleThree
    property: "height"
    from: imageRec.height * 0.7
    to: maxHeight
    duration: root.pulseInterval * 5
    loops: Animation.Infinite
  }

  Timer {
    running: rectangleThreeAnim.running
    repeat: true
    interval: rectangleThreeAnim.duration

    onTriggered: {
      rectangleThree.z = 3
      rectangleOne.z -= 1
      rectangleTwo.z -= 1
    }
  }

  Timer {
    id: delayTimer

    property int targetAnimationIndex: 2
    property real startDelay: 5

    repeat: false
    interval: root.pulseInterval
    onTriggered: {
      if (startDelay == 0) {
        switch (targetAnimationIndex) {
        case 2:
          rectangleTwoAnim.start()
          break
        case 3:
          rectangleThreeAnim.start()
          break
        }
      } else {
        startDelay = 0
        rectangleOneAnim.start()
      }
    }
  }

  Rectangle {
    id: imageRec
    z: 10
    width: 80
    height: width
    anchors.centerIn: parent

    color: theme.backgroundColor
    radius: height / 2

    Image {
      id: image
      width: parent.width / 2
      height: width
      anchors.centerIn: parent

      antialiasing: true
      smooth: true
    }
  }

  function stopAnimation() {
    rectangleOneAnim.complete()
    rectangleTwoAnim.complete()
    rectangleThreeAnim.complete()
    delayTimer.stop()
  }

  function resetValues() {
    rectangleOne.height = imageRec.height * 0.7
    rectangleOne.z = 1
    rectangleTwo.height = imageRec.height * 0.7
    rectangleTwo.z = 2
    rectangleThree.height = imageRec.height * 0.7
    rectangleThree.z = 3
    delayTimer.startDelay = 10
    delayTimer.targetAnimationIndex = 2
  }

  function startAnimation() {
    resetValues()
    delayTimer.start()
  }
}
