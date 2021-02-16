import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
  id: root

  property real realHeight: timerItem.height

  readonly property int navigationItemSize: 50
  readonly property int navigationItemImageSize: 35

  height: timerItem.height

  state: "timer"
  states: [
    State {
      name: "readTag"
      PropertyChanges {
        target: readTagItem
        isSelected: true
      }
      PropertyChanges {
        target: timerItem
        isSelected: false
      }
    },
    State {
      name: "saveTag"
      PropertyChanges {
        target: saveTagItem
        isSelected: true
      }
      PropertyChanges {
        target: timerItem
        isSelected: false
      }
    }
  ]

  Item {

    height: readTagItem.height
    anchors {
      verticalCenter: parent.verticalCenter
      left: parent.left
      right: timerItem.left
    }

    BottomNavigationItem {
      id: readTagItem

      width: root.navigationItemSize
      height: root.navigationItemSize

      iconName: "readTag"
      iconSize: root.navigationItemImageSize

      anchors {
        horizontalCenter: parent.horizontalCenter
      }

      onClicked: {
        root.state = "readTag"
      }
    }
  }

  Item {

    height: saveTagItem.height
    anchors {
      verticalCenter: parent.verticalCenter
      left: parent.right
      right: timerItem.right
    }

    Rectangle {
      color: "lime"
      opacity: 0.1
    }

    BottomNavigationItem {
      id: saveTagItem

      width: root.navigationItemSize
      height: root.navigationItemSize

      iconName: "saveTag"
      iconSize: root.navigationItemImageSize

      anchors {
        horizontalCenter: parent.horizontalCenter
      }

      onClicked: {
        root.state = "saveTag"
      }
    }
  }

  Item {
    id: timerItem

    property bool isSelected: true

    anchors {
      verticalCenter: parent.verticalCenter
      verticalCenterOffset: -15
      horizontalCenter: parent.horizontalCenter
    }

    width: 75
    height: width

    Rectangle {
      id: timerItemCircle

      width: parent.width - (timerItemMouseArea.pressed ? 4 : 0)
      height: width
      anchors.centerIn: parent

      color: theme.backgroundColor
      radius: height / 2

      visible: false
    }

    DropShadow {
      anchors.fill: timerItemCircle

      radius: 18
      samples: 37
      color: timerItem.isSelected ? theme.tintColor : theme.textColor
      source: timerItemCircle
      transparentBorder: true
    }

    Image {
      anchors.centerIn: timerItemCircle

      width: 44 - (timerItemMouseArea.pressed ? 4 : 0)
      height: width

      source: "qrc:/assets/icons/timer" + (timerItem.isSelected ? "Green" : "White") + ".png"
    }

    MouseArea {
      id: timerItemMouseArea
      anchors.fill: parent

      onClicked: {
        root.state = "timer"
      }
    }
  }
}
