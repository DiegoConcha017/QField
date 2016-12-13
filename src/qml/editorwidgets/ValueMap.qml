import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Item {
  signal valueChanged(var value, bool isNull)

  anchors.left: parent.left
  anchors.right: parent.right

  height: childrenRect.height


  ComboBox {
    id: comboBox

    property var reverseConfig: ({})
    property var currentValue: value

    anchors { left: parent.left; right: parent.right }

    currentIndex: find(reverseConfig[value])

    Component.onCompleted: {
      model = Object.keys(config['map']);
      for(var key in config['map']) {
        reverseConfig[config['map'][key]] = key;
      }
      currentIndex = find(reverseConfig[value])
    }

    onCurrentTextChanged: {
      valueChanged(config['map'][currentText], false)
    }

    // Workaround to get a signal when the value has changed
    onCurrentValueChanged: {
      currentIndex = find(reverseConfig[value])
    }

    MouseArea {
      anchors.fill: parent
      propagateComposedEvents: true

      onClicked: mouse.accepted = false
      onPressed: { forceActiveFocus(); mouse.accepted = false; }
      onReleased: mouse.accepted = false;
      onDoubleClicked: mouse.accepted = false;
      onPositionChanged: mouse.accepted = false;
      onPressAndHold: mouse.accepted = false;
    }

    // [hidpi fixes]
    delegate: ItemDelegate {
      width: comboBox.width
      height: 36 * dp
      text: modelData
      font.weight: comboBox.currentIndex === index ? Font.DemiBold : Font.Normal
      font.pointSize: 12
      highlighted: comboBox.highlightedIndex == index
    }

    contentItem: Text {
      height: 36 * dp
      text: comboBox.displayText
      horizontalAlignment: Text.AlignLeft
      verticalAlignment: Text.AlignVCenter
      elide: Text.ElideRight
    }

    background: Item {
      implicitWidth: 120 * dp
      implicitHeight: 36 * dp

      Rectangle {
        anchors.fill: parent
        id: backgroundRect
        border.color: control.pressed ? "#17a81a" : "#21be2b"
        border.width: control.visualFocus ? 2 : 1
        radius: 2
      }

      DropShadow {
        anchors.fill: backgroundRect
        horizontalOffset: 4 * dp
        verticalOffset: 4 * dp
        radius: 2 * dp
        samples: 17
        color: "#40000000"
        source: backgroundRect
      }
    }
    // [/hidpi fixes]
  }
}
