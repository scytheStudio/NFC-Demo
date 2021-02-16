import QtQuick 2.12
import QtQuick.Controls 2.12
import "navigation"
import "pages"

Item {
  id: root

  SwipeView {
    id: swipeView

    anchors {
      top: parent.top
      bottom: bottomNavigationBar.top
      left: parent.left
      right: parent.right
    }

    state: bottomNavigationBar.state
    states: [
      State {
        name: "readTag"
        PropertyChanges {
          target: swipeView
          currentIndex: 0
        }
      },
      State {
        name: "timer"
        PropertyChanges {
          target: swipeView
          currentIndex: 1
        }
      },
      State {
        name: "saveTag"
        PropertyChanges {
          target: swipeView
          currentIndex: 2
        }
      }
    ]

    interactive: false

    ReadTagPage {
      id: readTagPage

      visible: SwipeView.isCurrentItem

      onTagFound: {
        timerPage.startCountdown(dishname, seconds)
        bottomNavigationBar.state = "timer"
      }
    }

    TimerPage {
      id: timerPage

      visible: SwipeView.isCurrentItem

      onReadButtonClicked: {
        bottomNavigationBar.state = "readTag"
      }

      onSaveButtonClicked: {
        bottomNavigationBar.state = "saveTag"
      }
    }

    SaveTagPage {
      id: saveTagPage

      visible: SwipeView.isCurrentItem

      onSaved: {
        bottomNavigationBar.state = "timer"
      }
    }
  }

  BottomNavigationBar {
    id: bottomNavigationBar

    width: parent.width

    anchors {
      bottom: parent.bottom
    }
  }
}
