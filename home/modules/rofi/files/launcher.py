#!/usr/bin/env python3


from pathlib import Path
import argparse
import subprocess
import sys
from typing import List, Dict, Callable, Optional


class Menu:
    def __init__(
        self, name: str, prompt: str, options: List[str], actions: Dict[str, Callable]
    ):
        self.name = name
        self.prompt = prompt
        self.options = options
        self.actions = actions


def launch_applications():
    """Launch applications menu"""
    apps = subprocess.run(
        ["rofi", "-show", "drun", "-show-icons"], capture_output=False
    )


def launch_workspaces():
    """Launch workspaces menu"""
    # Get workspace list from hyprctl
    result = subprocess.run(
        ["hyprctl", "workspaces", "-j"], capture_output=True, text=True
    )
    if result.returncode == 0:
        workspaces = [f"Workspace {i}" for i in range(1, 11)]  # Simple 1-10 workspaces
        choice = show_rofi_menu(workspaces, "Switch Workspace")
        if choice:
            workspace_num = choice.split()[-1]
            subprocess.run(["hyprctl", "dispatch", "workspace", workspace_num])


def launch_screenshots():
    """Launch screenshot/screenrecording menu"""
    options = [
        "📸 Screenshot Area",
        "🪟 Screenshot Window", 
        "🖥️ Screenshot Full",
        "🎬 Record Area",
        "📹 Record Full",
    ]
    choice = show_rofi_menu(options, "📷 Screenshot/Recording")

    if choice == "📸 Screenshot Area":
        # First get the area selection with slurp
        slurp_result = subprocess.run(["slurp"], capture_output=True, text=True)
        if slurp_result.returncode == 0 and slurp_result.stdout.strip():
            area = slurp_result.stdout.strip()
            timestamp = subprocess.run(
                ["date", "+%s"], capture_output=True, text=True
            ).stdout.strip()
            subprocess.run(
                [
                    "grim",
                    "-g",
                    area,
                    f"{Path.home()}/Screenshots/screenshot-{timestamp}.png",
                ]
            )
    elif choice == "🪟 Screenshot Window":
        # Get active window geometry from hyprctl
        window_result = subprocess.run(
            ["hyprctl", "activewindow", "-j"], capture_output=True, text=True
        )
        if window_result.returncode == 0:
            import json

            window_data = json.loads(window_result.stdout)
            x = window_data["at"][0]
            y = window_data["at"][1]
            width = window_data["size"][0]
            height = window_data["size"][1]
            geometry = f"{x},{y} {width}x{height}"
            timestamp = subprocess.run(
                ["date", "+%s"], capture_output=True, text=True
            ).stdout.strip()
            subprocess.run(
                [
                    "grim",
                    "-g",
                    geometry,
                    f"{Path.home()}/Screenshots/screenshot-{timestamp}.png",
                ]
            )
    elif choice == "🖥️ Screenshot Full":
        timestamp = subprocess.run(
            ["date", "+%s"], capture_output=True, text=True
        ).stdout.strip()
        subprocess.run(
            ["grim", f"{Path.home()}/Screenshots/screenshot-{timestamp}.png"]
        )
    elif choice == "🎬 Record Area":
        subprocess.run(
            [
                "wf-recorder",
                "-g",
                "$(slurp)",
                "-f",
                "~/Videos/recording-$(date +%s).mp4",
            ],
            shell=True,
        )
    elif choice == "📹 Record Full":
        subprocess.run(
            ["wf-recorder", "-f", "~/Videos/recording-$(date +%s).mp4"], shell=True
        )


def launch_emojis():
    """Launch emoji picker"""
    subprocess.run(["rofi", "-show", "emoji", "-modi", "emoji"])


menus = {
    "applications": Menu(
        "applications",
        "Applications",
        ["Launch Application"],
        {"Launch Application": launch_applications},
    ),
    "workspaces": Menu(
        "workspaces",
        "Workspaces",
        ["Switch Workspace"],
        {"Switch Workspace": launch_workspaces},
    ),
    "screenshots": Menu(
        "screenshots",
        "Screenshots/Recording",
        ["Take Screenshot or Record"],
        {"Take Screenshot or Record": launch_screenshots},
    ),
    "emojis": Menu("emojis", "Emojis", ["Pick Emoji"], {"Pick Emoji": launch_emojis}),
    "main": Menu(
        "main",
        "Main Launcher",
        ["Applications", "Workspaces", "Screenshots/Recording", "Emojis"],
        {
            "Applications": lambda: launch_specific_menu("applications", "main"),
            "Workspaces": lambda: launch_specific_menu("workspaces", "main"),
            "Screenshots/Recording": lambda: launch_specific_menu(
                "screenshots", "main"
            ),
            "Emojis": lambda: launch_specific_menu("emojis", "main"),
        },
    ),
}


def show_rofi_menu(options, prompt="Choose"):
    """Show rofi menu and return selected option"""
    options_str = "\n".join(options)

    result = subprocess.run(
        ["rofi", "-dmenu", "-p", prompt],
        input=options_str,
        text=True,
        capture_output=True,
    )

    if result.returncode == 0:
        return result.stdout.strip()
    else:
        return None


def launch_specific_menu(menu_name: str, parent_menu: Optional[str] = None):
    """Launch a specific menu by name"""
    if menu_name not in menus:
        print(f"Unknown menu: {menu_name}")
        return

    menu = menus[menu_name]

    if menu_name in ["applications", "workspaces", "screenshots", "emojis"]:
        # Direct launchers - execute immediately
        if menu.options:
            action = list(menu.actions.values())[0]
            action()
        # After executing, go back to parent menu if there is one
        if parent_menu:
            launch_specific_menu(parent_menu)
    else:
        # Menu with choices
        choice = show_rofi_menu(menu.options, menu.prompt)
        if choice and choice in menu.actions:
            menu.actions[choice]()
        elif choice is None:
            # ESC pressed - go to parent menu or exit if at root
            if parent_menu:
                launch_specific_menu(parent_menu)
            else:
                sys.exit(0)  # ESC from root menu, exit


def show_main_menu():
    """Show the main menu"""
    launch_specific_menu("main")


def main():

    screenshots_path = Path.home() / "Screenshots"
    screenshots_path.mkdir(exist_ok=True)

    parser = argparse.ArgumentParser(description="Global launcher with sub-launchers")
    parser.add_argument(
        "launcher",
        nargs="?",
        choices=["main", "applications", "workspaces", "screenshots", "emojis"],
        default="main",
        help="Which launcher to show (default: main)",
    )

    args = parser.parse_args()
    # If launching directly to a sub-launcher, set main as parent for ESC behavior
    if args.launcher != "main":
        launch_specific_menu(args.launcher, "main")
    else:
        launch_specific_menu(args.launcher)


if __name__ == "__main__":
    main()
