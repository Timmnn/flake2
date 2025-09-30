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
    left: true
    top: true
    bottom: true
  }

  implicitWidth: 250
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

  // Content column
  Column {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 20
    spacing: 8
    property var currentTime: new Date()
    
    // Date - Day
    Text {
        text: Qt.formatDateTime(currentTime, "dd")
        color: colors.base05 ? "#" + colors.base05 : "#ff0000"
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        
        layer.enabled: true
        layer.effect: MultiEffect {
          shadowEnabled: true
          shadowOpacity: 0.6
          shadowBlur: 0.2
          shadowColor: colors.base0D ? "#" + colors.base0D : "#ff0000"
        }
      }
      
      // Date - Month
    Text {
        text: Qt.formatDateTime(currentTime, "MM")
        color: colors.base04 ? "#" + colors.base05 : "#ff0000"
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        opacity: 0.9
      }
      
      // Weekday
    Text {
        text: Qt.formatDateTime(currentTime, "ddd")
        color: colors.base04 ? "#" + colors.base04 : "#ff0000"
        font.pixelSize: 16
        font.family: "JetBrains Mono"
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        opacity: 0.8
      }
      
      // Hour 
    Text {
        text: Qt.formatDateTime(currentTime, "HH")
        color: colors.base0D ? "#" + colors.base0D : "#ff0000"
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        
        layer.enabled: true
        layer.effect: MultiEffect {
          shadowEnabled: true
          shadowOpacity: 0.8
          shadowBlur: 0.3
          shadowColor: colors.base0D ? "#" + colors.base0D : "#ff0000"
        }
      }

      // Minute 
    Text {
        text: Qt.formatDateTime(currentTime, "mm")
        color: colors.base0D ? "#" + colors.base0D : "#ff0000"
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        font.weight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        
        layer.enabled: true
        layer.effect: MultiEffect {
          shadowEnabled: true
          shadowOpacity: 0.8
          shadowBlur: 0.3
          shadowColor: colors.base0D ? "#" + colors.base0D : "#ff0000"
        }
      }

      
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentTime = new Date()
      }
    }
    
  }
}
