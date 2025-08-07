import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Item {
    id: launcher
    
    property var applications: []
    property var filteredApps: []
    
    Component.onCompleted: loadApplications()
    
    Process {
        id: findProc
        command: ["sh", "-c", `
            # Get executables from PATH and common Nix locations
            echo '['
            first=true
            
            # Add common GUI applications that might be in PATH
            for app in firefox chromium code kitty alacritty thunar pcmanfm nautilus dolphin gedit kate vim nvim emacs gimp inkscape blender libreoffice discord spotify vlc mpv obs-studio; do
                if command -v "$app" >/dev/null 2>&1; then
                    if [ "$first" = "false" ]; then echo ','; fi
                    appname=$(echo $app | sed 's/^./\\U&/')
                    
                    # Try to find icon using rofi-like approach
                    icon=""
                    
                    # First try desktop files
                    for desktop_dir in /usr/share/applications /usr/local/share/applications ~/.local/share/applications; do
                        if [ -f "$desktop_dir/$app.desktop" ]; then
                            icon=$(grep "^Icon=" "$desktop_dir/$app.desktop" | head -1 | cut -d'=' -f2-)
                            break
                        fi
                    done
                    
                    # If no desktop file or no icon, try icon theme directories
                    if [ -z "$icon" ]; then
                        # Check XDG icon directories like rofi does
                        icon_dirs="$HOME/.icons /usr/share/icons /usr/share/pixmaps"
                        for icon_dir in $icon_dirs; do
                            if [ -d "$icon_dir" ]; then
                                # Try different sizes and formats
                                for size in scalable 48x48 32x32 24x24 16x16; do
                                    for format in svg png xpm; do
                                        if [ -f "$icon_dir/hicolor/$size/apps/$app.$format" ]; then
                                            icon="$app"
                                            break 3
                                        fi
                                    done
                                done
                            fi
                        done
                    fi
                    
                    # If still no icon, try pixmaps directly
                    if [ -z "$icon" ]; then
                        for format in png svg xpm; do
                            if [ -f "/usr/share/pixmaps/$app.$format" ]; then
                                icon="$app"
                                break
                            fi
                        done
                    fi
                    
                    echo "{\\\"name\\\": \\\"$appname\\\", \\\"exec\\\": \\\"$app\\\", \\\"icon\\\": \\\"$icon\\\"}"
                    first=false
                fi
            done
            
            # Also check desktop files if they exist
            if [ -d ~/.local/share/applications ]; then
                for file in ~/.local/share/applications/*.desktop; do
                    if [ -f "$file" ]; then
                        name=$(grep "^Name=" "$file" | head -1 | cut -d'=' -f2-)
                        exec=$(grep "^Exec=" "$file" | head -1 | cut -d'=' -f2-)
                        icon=$(grep "^Icon=" "$file" | head -1 | cut -d'=' -f2-)
                        hidden=$(grep -E "^(Hidden|NoDisplay)=true" "$file")
                        
                        if [ -n "$name" ] && [ -n "$exec" ] && [ -z "$hidden" ]; then
                            if [ "$first" = "false" ]; then echo ','; fi
                            echo "{\\\"name\\\": \\\"$name\\\", \\\"exec\\\": \\\"$exec\\\", \\\"icon\\\": \\\"$icon\\\"}"
                            first=false
                        fi
                    fi
                done
            fi
            
            echo ']'
        `]
        stdout: StdioCollector {
            id: findOutput
            onStreamFinished: {
                console.log("Found applications");
                try {
                    var apps = JSON.parse(text);
                    console.log("Parsed", apps.length, "applications");
                    applications = apps.sort((a, b) => a.name.localeCompare(b.name));
                    filteredApps = applications.slice();
                    appList.model = filteredApps;
                } catch (e) {
                    console.log("Error parsing applications:", e);
                    console.log("Raw output:", text);
                    // Fallback
                    var fallbackApps = [
                        { name: "Firefox", exec: "firefox", icon: "" },
                        { name: "Terminal", exec: "kitty", icon: "" },
                        { name: "File Manager", exec: "thunar", icon: "" },
                        { name: "Text Editor", exec: "code", icon: "" }
                    ];
                    applications = fallbackApps;
                    filteredApps = applications.slice();
                    appList.model = filteredApps;
                }
            }
        }
    }

    function loadApplications() {
        findProc.running = true;
    }
    
    
    function filterApps(query) {
        if (query === "") {
            filteredApps = applications.slice();
        } else {
            filteredApps = applications.filter(app => 
                app.name.toLowerCase().includes(query.toLowerCase())
            );
        }
        appList.model = filteredApps;
        appList.currentIndex = filteredApps.length > 0 ? 0 : -1;
    }
    
    function show() {
        window.visible = true;
        searchInput.focus = true;
        searchInput.text = "";
        filterApps("");
    }
    
    function hide() {
        window.visible = false;
    }
    
    Process {
        id: launchProc
    }
    
    function launchApp(exec) {
        var cleanExec = exec.replace(/%[fFuU]/g, '').replace(/"/g, '').trim();
        var parts = cleanExec.split(' ').filter(part => part.length > 0);
        
        if (parts.length > 0) {
            launchProc.command = parts;
            launchProc.running = true;
        }
        hide();
    }
    
    function toggle() {
        if (window.visible) {
            hide();
        } else {
            show();
        }
    }
    
    PanelWindow {
        id: window
        visible: false
        color: "transparent"
        
        aboveWindows: true
        focusable: true
        exclusiveZone: 0
        exclusionMode: "Ignore"
        
        implicitWidth: 600
        implicitHeight: 400
        
        onVisibleChanged: {
            if (visible) {
                searchInput.forceActiveFocus();
                focusTimer.start();
            } else {
                focusTimer.stop();
            }
        }
        
        Timer {
            id: focusTimer
            interval: 100
            running: false
            repeat: true
            onTriggered: {
                if (window.visible && !searchInput.activeFocus) {
                    searchInput.forceActiveFocus();
                }
            }
        }
        
        
        // Main launcher rectangle
        Rectangle {
            id: mainRect
            anchors.centerIn: parent
            width: 600
            height: 400
            color: "#1e1e2e"
            border.color: "#89b4fa"
            border.width: 2
            radius: 10
            
            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Rectangle {
                    width: parent.width
                    height: 40
                    color: "#313244"
                    radius: 8
                    border.color: searchInput.focus ? "#89b4fa" : "#45475a"
                    border.width: 2
                    
                    TextInput {
                        id: searchInput
                        anchors.fill: parent
                        anchors.margins: 12
                        color: "#cdd6f4"
                        font.pixelSize: 16
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        
                        Text {
                            anchors.fill: parent
                            anchors.margins: parent.anchors.margins
                            text: "Search applications..."
                            color: "#6c7086"
                            font: searchInput.font
                            verticalAlignment: searchInput.verticalAlignment
                            visible: !searchInput.focus && searchInput.text === ""
                        }
                        
                        onTextChanged: launcher.filterApps(text)
                        
                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Escape) {
                                launcher.hide();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                if (appList.currentIndex >= 0 && launcher.filteredApps.length > 0) {
                                    launcher.launchApp(launcher.filteredApps[appList.currentIndex].exec);
                                }
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Down) {
                                if (launcher.filteredApps.length > 0) {
                                    appList.currentIndex = (appList.currentIndex + 1) % launcher.filteredApps.length;
                                }
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Up) {
                                if (launcher.filteredApps.length > 0) {
                                    appList.currentIndex = appList.currentIndex <= 0 ? 
                                        launcher.filteredApps.length - 1 : appList.currentIndex - 1;
                                }
                                event.accepted = true;
                            }
                        }
                    }
                }
                
                ListView {
                    id: appList
                    width: parent.width
                    height: parent.height - 55
                    model: launcher.filteredApps
                    currentIndex: -1
                    clip: true
                    
                    delegate: Rectangle {
                        width: appList.width
                        height: 50
                        color: index === appList.currentIndex ? "#45475a" : "transparent"
                        radius: 6
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onEntered: appList.currentIndex = index
                            onClicked: launcher.launchApp(modelData.exec)
                        }
                        
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 15
                            
                            Rectangle {
                                width: 32
                                height: 32
                                color: modelData.icon ? "transparent" : "#89b4fa"
                                radius: 4
                                
                                Image {
                                    id: iconImage
                                    anchors.centerIn: parent
                                    width: 24
                                    height: 24
                                    source: modelData.icon ? "image://icon/" + modelData.icon : ""
                                    visible: modelData.icon
                                    fillMode: Image.PreserveAspectFit
                                    
                                    onStatusChanged: {
                                        if (status === Image.Error) {
                                            visible = false;
                                            fallbackText.visible = true;
                                        }
                                    }
                                }
                                
                                Text {
                                    id: fallbackText
                                    anchors.centerIn: parent
                                    text: modelData.name ? modelData.name.charAt(0).toUpperCase() : "?"
                                    color: "#1e1e2e"
                                    font.bold: true
                                    font.pixelSize: 16
                                    visible: !modelData.icon || iconImage.status === Image.Error
                                }
                            }
                            
                            Text {
                                text: modelData.name || "Unknown Application"
                                color: "#cdd6f4"
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
