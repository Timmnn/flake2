import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

ShellRoot {
    AppLauncher {
        id: launcher
    }
    
    Component.onCompleted: {
        launcher.show()
    }
}