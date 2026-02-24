#!/usr/bin/env python3
"""Agentic Substrate - Cross-Platform Setup & Management"""

import platform
import subprocess
import sys
import os
import shutil

VERSION = "5.4.0"
INSTALL_DIR = os.path.join(os.path.expanduser("~"), ".claude")

# ============================================================================
# PLATFORM DETECTION
# ============================================================================

def detect_os():
    system = platform.system().lower()
    if system == "darwin":
        return "macos"
    elif system == "linux":
        try:
            with open("/proc/version", "r") as f:
                if "microsoft" in f.read().lower():
                    return "wsl"
        except FileNotFoundError:
            pass
        return "linux"
    elif system == "windows":
        return "windows"
    return "unknown"

def has_bash():
    try:
        subprocess.run(["bash", "--version"], capture_output=True, timeout=5)
        return True
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False

def has_powershell():
    for cmd in ["pwsh", "powershell"]:
        try:
            subprocess.run([cmd, "-Version"], capture_output=True, timeout=5)
            return cmd
        except (FileNotFoundError, subprocess.TimeoutExpired):
            continue
    return None

def is_installed():
    version_file = os.path.join(INSTALL_DIR, ".agentic-substrate-version")
    if os.path.isfile(version_file):
        with open(version_file) as f:
            return f.read().strip()
    return None

# ============================================================================
# SCRIPT RUNNERS
# ============================================================================

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

def to_bash_path(win_path):
    """Convert Windows path to bash-compatible path (C:\\foo -> /c/foo)."""
    path = win_path.replace("\\", "/")
    if len(path) >= 2 and path[1] == ":":
        path = "/" + path[0].lower() + path[2:]
    return path

def run_bash(script_name):
    script = os.path.join(SCRIPT_DIR, "scripts", "unix", script_name)
    if not os.path.isfile(script):
        print(f"    Script not found: {script}")
        return 1
    bash_path = to_bash_path(script) if detect_os() == "windows" else script
    return subprocess.call(["bash", bash_path])

def run_bash_with_args(script_name, args):
    script = os.path.join(SCRIPT_DIR, "scripts", "unix", script_name)
    if not os.path.isfile(script):
        print(f"    Script not found: {script}")
        return 1
    bash_path = to_bash_path(script) if detect_os() == "windows" else script
    return subprocess.call(["bash", bash_path] + args)

def run_powershell(ps_cmd, script_name):
    script = os.path.join(SCRIPT_DIR, "scripts", "windows", script_name)
    if not os.path.isfile(script):
        print(f"    Script not found: {script}")
        return 1
    return subprocess.call([ps_cmd, "-ExecutionPolicy", "Bypass", "-File", script])

# ============================================================================
# ACTIONS
# ============================================================================

def action_install(os_type):
    print("\n    --- Install Agentic Substrate ---\n")

    if os_type == "windows":
        bash = has_bash()
        ps_cmd = has_powershell()

        if bash and ps_cmd:
            print("    Available methods:")
            print("      1) Git Bash  (install.sh)")
            print("      2) PowerShell (install.ps1)")
            choice = input("\n    Choose [1/2] (default: 1): ").strip()
            if choice == "2":
                return run_powershell(ps_cmd, "install.ps1")
            return run_bash("install.sh")
        elif ps_cmd:
            return run_powershell(ps_cmd, "install.ps1")
        elif bash:
            return run_bash("install.sh")
        else:
            print("    ERROR: No bash or PowerShell found.")
            print("    Install Git for Windows: https://git-scm.com/download/win")
            return 1
    else:
        return run_bash("install.sh")

def action_uninstall(os_type):
    print("\n    --- Uninstall Agentic Substrate ---\n")

    installed = is_installed()
    if not installed:
        print("    Nothing to uninstall (not installed).")
        return 0

    print(f"    Installed version: {installed}")
    print(f"    Location: {INSTALL_DIR}")
    print()

    preview = input("    Preview first? [Y/n]: ").strip().lower()
    if preview in ("", "y", "yes", "s", "si"):
        run_bash_with_args("uninstall.sh", ["--dry-run"])
        print()

    confirm = input("    Proceed with uninstall? [y/N]: ").strip().lower()
    if confirm in ("y", "yes", "s", "si"):
        return run_bash("uninstall.sh")
    print("    Cancelled.")
    return 0

def action_update(os_type):
    print("\n    --- Update (changed files only) ---\n")
    return run_bash("update.sh")

def action_verify(os_type):
    print("\n    --- Verify Installation ---\n")

    installed = is_installed()
    if not installed:
        print("    Not installed.")
        return 1

    print(f"    Version:  {installed}")
    print(f"    Location: {INSTALL_DIR}")
    print()

    # Check key directories
    dirs = ["agents", "skills", "commands", "hooks", "templates", "validators"]
    all_ok = True
    for d in dirs:
        path = os.path.join(INSTALL_DIR, d)
        if os.path.isdir(path):
            count = len([f for f in os.listdir(path) if not f.startswith(".")])
            print(f"    [OK]   {d}/ ({count} files)")
        else:
            print(f"    [MISS] {d}/")
            all_ok = False

    # Check CLAUDE.md
    claude_md = os.path.join(INSTALL_DIR, "CLAUDE.md")
    if os.path.isfile(claude_md):
        size = os.path.getsize(claude_md)
        print(f"    [OK]   CLAUDE.md ({size} bytes)")
    else:
        print(f"    [MISS] CLAUDE.md")
        all_ok = False

    # Check settings.json
    settings = os.path.join(INSTALL_DIR, "settings.json")
    if os.path.isfile(settings):
        print(f"    [OK]   settings.json")
    else:
        print(f"    [MISS] settings.json")

    print()
    if all_ok:
        print("    Installation is healthy.")
    else:
        print("    Some components are missing. Try reinstalling:")
        print("    python setup.py -> Install")
    return 0 if all_ok else 1

def action_configure(os_type):
    print("\n    --- Configure MCP Servers ---\n")
    return run_bash("customize.sh")

def action_status(os_type):
    print("\n    --- Status ---\n")

    installed = is_installed()
    if installed:
        print(f"    Installed:  v{installed}")
        print(f"    Location:   {INSTALL_DIR}")

        # Count components
        for component, subdir in [("Agents", "agents"), ("Skills", "skills"),
                                   ("Commands", "commands"), ("Hooks", "hooks")]:
            path = os.path.join(INSTALL_DIR, subdir)
            if os.path.isdir(path):
                count = len([f for f in os.listdir(path)
                           if os.path.isfile(os.path.join(path, f)) and not f.startswith(".")])
                print(f"    {component}:     {count}")
    else:
        print("    Not installed.")
        print(f"    Expected location: {INSTALL_DIR}")

    print(f"\n    OS:         {detect_os()}")
    print(f"    Python:     {platform.python_version()}")
    print(f"    Bash:       {'Yes' if has_bash() else 'No'}")
    ps = has_powershell()
    print(f"    PowerShell: {ps if ps else 'No'}")

    return 0

def action_diagnose(os_type):
    print("\n    --- Diagnose Installation ---\n")

    script = os.path.join(SCRIPT_DIR, "dev", "tools", "diagnose-install.sh")
    if os.path.isfile(script) and has_bash():
        bash_path = to_bash_path(script) if detect_os() == "windows" else script
        return subprocess.call(["bash", bash_path])

    # Fallback: basic Python diagnostics
    print("    Running basic diagnostics...\n")
    action_verify(os_type)

    # Check for common issues
    print("\n    --- Common Issues ---\n")

    claude_md = os.path.join(INSTALL_DIR, "CLAUDE.md")
    if os.path.isfile(claude_md):
        size = os.path.getsize(claude_md)
        if size > 5000:
            print(f"    [WARN] CLAUDE.md is {size} bytes (target: <5000)")
            print("           May have bloat from repeated installs.")
        else:
            print(f"    [OK]   CLAUDE.md size: {size} bytes")

    # Check for Claude CLI
    claude_exists = shutil.which("claude") is not None
    if claude_exists:
        print("    [OK]   Claude CLI found")
    else:
        print("    [WARN] Claude CLI not found in PATH")
        print("           Install from: https://claude.ai/download")

    return 0

# ============================================================================
# MENU
# ============================================================================

MENU_SECTIONS = [
    ("SETUP", [
        ("1", "Install",    "Install Agentic Substrate", action_install),
        ("2", "Uninstall",  "Remove (preserves your data)", action_uninstall),
        ("3", "Update",     "Update only changed files", action_update),
    ]),
    ("TOOLS", [
        ("4", "Verify",     "Check installation health", action_verify),
        ("5", "Configure",  "MCP servers & settings", action_configure),
        ("6", "Status",     "System info & components", action_status),
        ("7", "Diagnose",   "Debug installation problems", action_diagnose),
    ]),
]

# Flat list for lookups
MENU_OPTIONS = [item for _, items in MENU_SECTIONS for item in items]
MENU_OPTIONS.append(("q", "Quit", "Exit", None))

def show_menu(os_type):
    installed = is_installed()

    status_line = f"v{installed}" if installed else "Not installed"
    status_color = status_line

    print(f"""
    ╔══════════════════════════════════════════════╗
    ║   Agentic Substrate v{VERSION}                 ║
    ║   Research-first dev system for Claude Code  ║
    ╚══════════════════════════════════════════════╝

    OS: {os_type}  |  Python {platform.python_version()}  |  {status_color}
    """)

    for section_name, items in MENU_SECTIONS:
        print(f"    --- {section_name} ---")
        for key, name, desc, _ in items:
            print(f"    {key}) {name:<12} {desc}")
        print()

    print(f"    q) Quit")
    print()

def main():
    os_type = detect_os()

    # Direct command: python setup.py install / uninstall / verify / status
    if len(sys.argv) > 1:
        cmd = sys.argv[1].lower()
        for key, name, desc, action in MENU_OPTIONS:
            if cmd == name.lower() and action:
                sys.exit(action(os_type))
        print(f"    Unknown command: {cmd}")
        print(f"    Available: {', '.join(name.lower() for _, name, _, a in MENU_OPTIONS if a)}")
        sys.exit(1)

    # Interactive menu
    while True:
        show_menu(os_type)
        choice = input("    Choose an option: ").strip().lower()

        if choice in ("q", "quit", "exit", ""):
            print("    Bye!")
            break

        matched = False
        for key, name, desc, action in MENU_OPTIONS:
            if choice == key or choice == name.lower():
                if action:
                    action(os_type)
                    input("\n    Press Enter to continue...")
                matched = True
                break

        if not matched:
            print(f"    Invalid option: {choice}")
            input("\n    Press Enter to continue...")

if __name__ == "__main__":
    main()
