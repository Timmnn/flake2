import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Item {
    id: launcherManager
    
    property var currentLauncher: null
    property var previousLauncher: null
    
    // Main launcher that shows categories
    MainLauncher {
        id: mainLauncher
        
        onLauncherSelected: launcherType => {
            launcherManager.showLauncher(launcherType);
        }
    }
    
    // Individual launchers
    AppLauncher {
        id: appLauncher
        onGoBackRequested: launcherManager.goBack()
    }
    
    ScreenshotLauncher {
        id: screenshotLauncher
        onGoBackRequested: launcherManager.goBack()
    }
    
    // Placeholder for future launchers - easily extensible
    // WallpaperLauncher {
    //     id: wallpaperLauncher
    // }
    
    // SystemLauncher {
    //     id: systemLauncher
    // }
    
    function showMain() {
        if (currentLauncher !== mainLauncher) {
            previousLauncher = currentLauncher;
        }
        hideAll();
        mainLauncher.show();
        currentLauncher = mainLauncher;
    }
    
    function showLauncher(launcherType) {
        if (currentLauncher !== null) {
            previousLauncher = currentLauncher;
        }
        hideAll();
        
        switch(launcherType) {
            case "apps":
                appLauncher.show();
                currentLauncher = appLauncher;
                break;
            case "screenshot":
                screenshotLauncher.show();
                currentLauncher = screenshotLauncher;
                break;
            // case "wallpaper":
            //     wallpaperLauncher.show();
            //     currentLauncher = wallpaperLauncher;
            //     break;
            // case "system":
            //     systemLauncher.show();
            //     currentLauncher = systemLauncher;
            //     break;
            default:
                showMain();
        }
    }
    
    function goBack() {
        if (previousLauncher !== null) {
            var temp = currentLauncher;
            hideAll();
            previousLauncher.show();
            currentLauncher = previousLauncher;
            previousLauncher = temp;
        } else {
            // If no previous launcher, close everything
            hideAll();
        }
    }
    
    function hideAll() {
        mainLauncher.hide();
        appLauncher.hide();
        screenshotLauncher.hide();
        // wallpaperLauncher.hide();
        // systemLauncher.hide();
        currentLauncher = null;
    }
    
    function toggleMain() {
        if (currentLauncher === mainLauncher) {
            hideAll();
        } else {
            showMain();
        }
    }
    
    function toggleApps() {
        if (currentLauncher === appLauncher) {
            hideAll();
        } else {
            showLauncher("apps");
        }
    }
    
    function toggleScreenshot() {
        if (currentLauncher === screenshotLauncher) {
            hideAll();
        } else {
            showLauncher("screenshot");
        }
    }
    
    // Add more toggle functions as needed
    // function toggleWallpaper() {
    //     if (currentLauncher === wallpaperLauncher) {
    //         hideAll();
    //     } else {
    //         showLauncher("wallpaper");
    //     }
    // }
}