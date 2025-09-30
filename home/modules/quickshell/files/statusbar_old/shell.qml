import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects

PanelWindow {
  property var colors: {
    try {
      var content = stylixColors.text()
      if (content && content.length > 0) {
        console.log("Parsing colors, content length:", content.length)
        return JSON.parse(content)
      } else {
        console.log("No content or empty file")
        return {}
      }
    } catch (e) {
      console.log("Failed to parse colors:", e)
      return {}
    }
  }
  
  FileView {
    id: stylixColors
    path: "/home/timm/.config/stylix/palette.json"
    watchChanges: true
    
    onLoadFailed: {
      console.log("Failed to load stylix colors file")
    }
  }
  
  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: 35
  color: "transparent"
  
  Rectangle {
    anchors.fill: parent
    anchors.margins: 4
    anchors.bottomMargin: 2
    
    color: colors.base00 ? "#" + colors.base00 : "#ff0000"
    opacity: 0.7
    radius: 12
    
    // Subtle gradient overlay
    Rectangle {
      anchors.fill: parent
      radius: parent.radius
      gradient: Gradient {
        GradientStop { position: 0.0; color: colors.base05 ? "#33" + colors.base05 : "#33ff0000" }
        GradientStop { position: 1.0; color: colors.base05 ? "#11" + colors.base05 : "#11ff0000" }
      }
    }
    
    // Border accent
    Rectangle {
      anchors.fill: parent
      radius: parent.radius
      color: "transparent"
      border.width: 1
      border.color: colors.base05 ? "#44" + colors.base05 : "#44ff0000"
    }
    
    // Drop shadow effect
    layer.enabled: true
    layer.effect: MultiEffect {
      shadowEnabled: true
      shadowOpacity: 0.3
      shadowBlur: 0.8
      shadowVerticalOffset: 2
      shadowColor: "#000000"
    }
  }

  // Content row
  Row {
    anchors.centerIn: parent
    spacing: 20
    
    Text {
      property var currentTime: new Date()
      
      text: Qt.formatDateTime(currentTime, "dddd, dd.MM.yyyy HH:mm")
      color: colors.base05 ? "#" + colors.base05 : "#ff0000"
      font.pixelSize: 14
      font.family: "JetBrains Mono"
      font.weight: Font.Medium
      
      // Subtle glow effect
      layer.enabled: true
      layer.effect: MultiEffect {
        shadowEnabled: true
        shadowOpacity: 0.6
        shadowBlur: 0.2
        shadowColor: colors.base0D ? "#" + colors.base0D : "#ff0000"
      }
      
      Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: parent.currentTime = new Date()
      }
    }
    
  }
}
