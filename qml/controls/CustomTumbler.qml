import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
  id: root

  property alias hours: hoursTumbler.currentIndex
  property alias minutes: minutesTumbler.currentIndex

  width: frame.implicitWidth + 10
  height: frame.implicitHeight + 10

  function formatText(count, modelData) {
    var data = count === 12 ? modelData + 1 : modelData
    return data.toString().length < 2 ? "0" + data : data
  }

  FontMetrics {
    id: fontMetrics
  }

  Component {
    id: delegateComponent

    Label {
      opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)

      color: theme.textColor
      font.pixelSize: fontMetrics.font.pixelSize * 1.25
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: formatText(Tumbler.tumbler.count, modelData)
    }
  }

  Frame {
    id: frame
    padding: 0
    anchors.centerIn: parent

    Row {
      id: row

      Tumbler {
        id: hoursTumbler
        model: 24
        delegate: delegateComponent
      }

      Tumbler {
        id: minutesTumbler
        model: 60
        delegate: delegateComponent
      }

      Tumbler {
        id: secondsTumbler
        model: 60
        delegate: delegateComponent
      }
    }
  }

  function reset() {
    hoursTumbler.currentIndex = 0
    minutesTumbler.currentIndex = 0
    secondsTumbler.currentIndex = 0
  }

  function getSeconds() {
    var hSec = hoursTumbler.currentIndex * 60 * 60
    var mSec = minutesTumbler.currentIndex * 60

    return hSec + mSec + secondsTumbler.currentIndex
  }
}
