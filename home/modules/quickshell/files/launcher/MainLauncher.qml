import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Item {
    id: mainLauncher
    
    property var launcherCategories: [
        { name: "Applications", icon: "applications-other", launcher: "apps" },
        { name: "Screenshots", icon: "camera-photo", launcher: "screenshot" },
        { name: "Wallpapers", icon: "preferences-desktop-wallpaper", launcher: "wallpaper" },
        { name: "System", icon: "preferences-system", launcher: "system" }
    ]
    
    signal launcherSelected(string launcherType)
    
    function show() {
        window.visible = true;
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
    
    PanelWindow {
        id: window
        visible: false
        color: "transparent"
        
        aboveWindows: true
        focusable: true
        exclusiveZone: 0
        exclusionMode: "Ignore"
        
        implicitWidth: 400
        implicitHeight: 300
        
        onVisibleChanged: {
            if (visible) {
                categoryList.forceActiveFocus();
            }
        }
        
        // Main launcher rectangle
        Rectangle {
            id: mainRect
            anchors.centerIn: parent
            width: 400
            height: 300
            color: "#1e1e2e"
            border.color: "#89b4fa"
            border.width: 2
            radius: 10
            
            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Text {
                    text: "Quick Launcher"
                    color: "#cdd6f4"
                    font.pixelSize: 18
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                ListView {
                    id: categoryList
                    width: parent.width
                    height: parent.height - 40
                    model: mainLauncher.launcherCategories
                    currentIndex: 0
                    focus: true
                    
                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            mainLauncher.hide();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            if (currentIndex >= 0) {
                                var category = mainLauncher.launcherCategories[currentIndex];
                                mainLauncher.launcherSelected(category.launcher);
                                mainLauncher.hide();
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Down) {
                            currentIndex = (currentIndex + 1) % mainLauncher.launcherCategories.length;
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            currentIndex = currentIndex <= 0 ? 
                                mainLauncher.launcherCategories.length - 1 : currentIndex - 1;
                            event.accepted = true;
                        }
                    }
                    
                    delegate: Rectangle {
                        width: categoryList.width
                        height: 50
                        color: index === categoryList.currentIndex ? "#45475a" : "transparent"
                        radius: 8
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onEntered: categoryList.currentIndex = index
                            onClicked: {
                                mainLauncher.launcherSelected(modelData.launcher);
                                mainLauncher.hide();
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
                                    text: modelData.name.charAt(0).toUpperCase()
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