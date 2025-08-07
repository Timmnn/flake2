import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

ShellRoot {
    LauncherManager {
        id: launcherManager
    }
    
    // Keybind handlers - you can bind these to your window manager
    // Example keybinds (configure in your window manager):
    // Super+Space: toggleMain()
    // Super+A: toggleApps() 
    // Super+S: toggleScreenshot()
    
    Component.onCompleted: {
        // Show main launcher on startup
        launcherManager.showMain()
    }
}