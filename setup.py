#!/usr/bin/env python3
"""Agentic Substrate - Cross-Platform Setup"""

import platform
import subprocess
import sys
import os

VERSION = "5.4.0"

def detect_os():
    system = platform.system().lower()
    if system == "darwin":
        return "macos"
    elif system == "linux":
        # Check for WSL
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

def main():
    os_type = detect_os()
    script_dir = os.path.dirname(os.path.abspath(__file__))

    print(f"""
    ╔══════════════════════════════════════════════╗
    ║   Agentic Substrate v{VERSION}                 ║
    ║   Research-first dev system for Claude Code  ║
    ╚══════════════════════════════════════════════╝

    Detected OS: {os_type}
    Python:      {platform.python_version()}
    """)

    if os_type == "windows":
        bash = has_bash()
        ps_cmd = has_powershell()

        if bash and ps_cmd:
            print("    Available installers:")
            print("      1) install.sh   (Git Bash)")
            print("      2) install.ps1  (PowerShell)")
            print()
            choice = input("    Choose [1/2] (default: 1): ").strip()
            if choice == "2":
                run_powershell(script_dir, ps_cmd)
            else:
                run_bash(script_dir)
        elif bash:
            print("    Installer: install.sh (Git Bash)")
            confirm_and_run(lambda: run_bash(script_dir))
        elif ps_cmd:
            print("    Installer: install.ps1 (PowerShell)")
            confirm_and_run(lambda: run_powershell(script_dir, ps_cmd))
        else:
            print("    ERROR: No bash or PowerShell found.")
            print("    Install Git for Windows: https://git-scm.com/download/win")
            sys.exit(1)
    else:
        # macOS, Linux, WSL
        if not has_bash():
            print("    ERROR: bash not found.")
            sys.exit(1)
        print("    Installer: install.sh")
        confirm_and_run(lambda: run_bash(script_dir))

def confirm_and_run(run_fn):
    print()
    answer = input("    Install now? [Y/n]: ").strip().lower()
    if answer in ("", "y", "yes", "s", "si"):
        run_fn()
    else:
        print("    Cancelled.")

def run_bash(script_dir):
    script = os.path.join(script_dir, "scripts", "unix", "install.sh")
    print()
    sys.exit(subprocess.call(["bash", script]))

def run_powershell(script_dir, ps_cmd):
    script = os.path.join(script_dir, "scripts", "windows", "install.ps1")
    print()
    sys.exit(subprocess.call([
        ps_cmd, "-ExecutionPolicy", "Bypass", "-File", script
    ]))

if __name__ == "__main__":
    main()
