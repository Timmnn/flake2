import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Item {
    id: screenshotLauncher
    
    signal goBackRequested()
    
    property var screenshotOptions: [
        { name: "Full Screen", icon: "monitor", command: ["grim", "~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"] },
        { name: "Current Window", icon: "window", command: ["sh", "-c", "grim -g \"$(hyprctl activewindow -j | jq -r '.at[0],.at[1],.size[0],.size[1]' | xargs printf '%d,%d %dx%d')\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"] },
        { name: "Select Area", icon: "select-rectangular", command: ["grim", "-g", "$(slurp)", "~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"] },
        { name: "Full Screen to Clipboard", icon: "clipboard", command: ["grim", "-", "|", "wl-copy"] },
        { name: "Select Area to Clipboard", icon: "clipboard-text", command: ["sh", "-c", "grim -g \"$(slurp)\" - | wl-copy"] },
        { name: "Record Screen", icon: "media-record", command: ["wf-recorder", "-f", "~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4"] },
        { name: "Record Area", icon: "media-record", command: ["sh", "-c", "wf-recorder -g \"$(slurp)\" -f ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4"] }
    ]
    
    function show() {
        window.visible = true;
        optionsList.forceActiveFocus();
    }
    
    function hide() {
        window.visible = false;
    }
    
    function toggle() {
        if (window.visible) {
            hide();
        } else {
            show();
        }
    }
    
    Process {
        id: screenshotProc
    }
    
    function executeScreenshot(command) {
        if (command.length === 1 && command[0].includes("|")) {
            // Handle piped commands
            screenshotProc.command = ["sh", "-c", command[0]];
        } else {
            screenshotProc.command = command;
        }
        screenshotProc.running = true;
        hide();
    }
    
    PanelWindow {
        id: window
        visible: false
        color: "transparent"
        
        aboveWindows: true
        focusable: true
        exclusiveZone: 0
        exclusionMode: "Ignore"
        
        implicitWidth: 500
        implicitHeight: 400
        
        onVisibleChanged: {
            if (visible) {
                optionsList.forceActiveFocus();
            }
        }
        
        // Main screenshot launcher rectangle
        Rectangle {
            id: mainRect
            anchors.centerIn: parent
            width: 500
            height: 400
            color: "#1e1e2e"
            border.color: "#89b4fa"
            border.width: 2
            radius: 10
            
            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Text {
                    text: "Screenshot & Recording"
                    color: "#cdd6f4"
                    font.pixelSize: 18
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                ListView {
                    id: optionsList
                    width: parent.width
                    height: parent.height - 40
                    model: screenshotLauncher.screenshotOptions
                    currentIndex: 0
                    focus: true
                    clip: true
                    
                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            screenshotLauncher.goBackRequested();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (currentIndex >= 0) {
                                var option = screenshotLauncher.screenshotOptions[currentIndex];
                                screenshotLauncher.executeScreenshot(option.command);
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down) {
                            currentIndex = (currentIndex + 1) % screenshotLauncher.screenshotOptions.length;
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            currentIndex = currentIndex <= 0 ? 
                                screenshotLauncher.screenshotOptions.length - 1 : currentIndex - 1;
                            event.accepted = true;
                        }
                    }
                    
                    delegate: Rectangle {
                        width: optionsList.width
                        height: 50
                        color: index === optionsList.currentIndex ? "#45475a" : "transparent"
                        radius: 8
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onEntered: optionsList.currentIndex = index
                            onClicked: {
                                screenshotLauncher.executeScreenshot(modelData.command);
                            }
                        }
                        
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 15
                            
                            Rectangle {
                                width: 32
                                height: 32
                                color: "#89b4fa"
                                radius: 6
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: {
                                        switch(modelData.icon) {
                                            case "monitor": return "🖥"
                                            case "window": return "🪟"
                                            case "select-rectangular": return "⬜"
                                            case "clipboard": return "📋"
                                            case "clipboard-text": return "📄"
                                            case "media-record": return "🎥"
                                            default: return "📷"
                                        }
                                    }
                                    color: "#1e1e2e"
                                    font.bold: true
                                    font.pixelSize: 16
                                }
                            }
                            
                            Text {
                                text: modelData.name
                                color: "#cdd6f4"
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}