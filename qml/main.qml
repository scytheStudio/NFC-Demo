import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
  id: root
  visible: true
  width: 640
  height: 480
  title: qsTr("Hello World")
  color: theme.backgroundColor

  Theme {
    id: theme
  }

  MainView {
    id: mainView

    anchors.fill: parent
  }
}
