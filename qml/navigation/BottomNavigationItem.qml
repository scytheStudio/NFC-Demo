import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
  id: root

  property bool isSelected: false
  property string iconName: ""
  property int iconSize: 0

  property alias imageWidth: image.width
  property alias imageHeight: image.height

  signal clicked()

  Image {
    id: image

    anchors.centerIn: parent
    width: root.iconSize - (mouseArea.pressed ? 4 : 0)
    height: width

    source: "qrc:/assets/icons/" + root.iconName + (root.isSelected ? "Green" : "White") + ".png"
  }

  Rectangle {
    id: dot

    width: 4
    height: width
    visible: root.isSelected

    anchors {
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.bottom
    }

    color: theme.tintColor
    radius: height / 2
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent

    onClicked: {
      if (!root.isSelected) {
        root.clicked()
      }
    }
  }
}
