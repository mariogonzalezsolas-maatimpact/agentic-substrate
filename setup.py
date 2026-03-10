#!/usr/bin/env python3
"""Agentic Substrate - Cross-Platform Setup & Management"""

import platform
import subprocess
import sys
import os
import shutil

VERSION = "7.1.0"
INSTALL_DIR = os.path.join(os.path.expanduser("~"), ".claude")
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

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
# SCRIPT RUNNERS (use relative paths from repo root)
# ============================================================================

def run_bash(relative_path):
    """Run a bash script using relative path from repo root."""
    full_path = os.path.join(SCRIPT_DIR, relative_path)
    if not os.path.isfile(full_path):
        print(f"    Script not found: {relative_path}")
        return 1
    try:
        return subprocess.call(["bash", relative_path.replace("\\", "/")], cwd=SCRIPT_DIR)
    except FileNotFoundError:
        print("    ERROR: bash not found.")
        print("    Install Git for Windows: https://git-scm.com/download/win")
        return 1

def run_bash_with_args(relative_path, args):
    """Run a bash script with arguments using relative path from repo root."""
    full_path = os.path.join(SCRIPT_DIR, relative_path)
    if not os.path.isfile(full_path):
        print(f"    Script not found: {relative_path}")
        return 1
    try:
        return subprocess.call(["bash", relative_path.replace("\\", "/")] + args, cwd=SCRIPT_DIR)
    except FileNotFoundError:
        print("    ERROR: bash not found.")
        print("    Install Git for Windows: https://git-scm.com/download/win")
        return 1

def run_powershell(ps_cmd, relative_path):
    """Run a PowerShell script using full path (PS handles Windows paths)."""
    full_path = os.path.join(SCRIPT_DIR, relative_path)
    if not os.path.isfile(full_path):
        print(f"    Script not found: {relative_path}")
        return 1
    return subprocess.call([ps_cmd, "-ExecutionPolicy", "Bypass", "-File", full_path])

def run_powershell_with_args(ps_cmd, relative_path, args):
    """Run a PowerShell script with arguments using full path."""
    full_path = os.path.join(SCRIPT_DIR, relative_path)
    if not os.path.isfile(full_path):
        print(f"    Script not found: {relative_path}")
        return 1
    return subprocess.call([ps_cmd, "-ExecutionPolicy", "Bypass", "-File", full_path] + args)

# ============================================================================
# ACTIONS
# ============================================================================

def _run_install_bash(force=False):
    if force:
        return run_bash_with_args("scripts/unix/install.sh", ["--force"])
    return run_bash("scripts/unix/install.sh")

def _run_install_ps(ps_cmd, force=False):
    if force:
        return run_powershell_with_args(ps_cmd, "scripts/windows/install.ps1", ["-Force"])
    return run_powershell(ps_cmd, "scripts/windows/install.ps1")

def action_install(os_type):
    print("\n    --- Install Agentic Substrate ---\n")

    # Check if already installed - offer --force
    installed = is_installed()
    force = False
    if installed:
        print(f"    Already installed: v{installed}")
        print()
        print("    Options:")
        print("      1) Reinstall with --force")
        print("      2) Back to menu")
        choice = input("\n    Choose [1/2]: ").strip()
        if choice != "1":
            print("    Cancelled.")
            return 0
        force = True
        print()

    if os_type == "windows":
        bash = has_bash()
        ps_cmd = has_powershell()

        if bash and ps_cmd:
            print("    Available methods:")
            print("      1) Git Bash  (install.sh)")
            print("      2) PowerShell (install.ps1)")
            choice = input("\n    Choose [1/2] (default: 1): ").strip()
            if choice == "2":
                return _run_install_ps(ps_cmd, force)
            return _run_install_bash(force)
        elif ps_cmd:
            return _run_install_ps(ps_cmd, force)
        elif bash:
            return _run_install_bash(force)
        else:
            print("    ERROR: No bash or PowerShell found.")
            print("    Install Git for Windows: https://git-scm.com/download/win")
            return 1
    else:
        return _run_install_bash(force)

def action_uninstall(os_type):
    print("\n    --- Uninstall Agentic Substrate ---\n")

    installed = is_installed()
    if not installed:
        print("    Nothing to uninstall (not installed).")
        return 0

    print(f"    Installed version: {installed}")
    print(f"    Location: {INSTALL_DIR}")
    print()

    if os_type == "windows" and not has_bash():
        print("    ERROR: Uninstall requires bash (no PowerShell uninstaller available).")
        print("    Install Git for Windows: https://git-scm.com/download/win")
        return 1

    preview = input("    Preview first? [Y/n]: ").strip().lower()
    if preview in ("", "y", "yes", "s", "si"):
        run_bash_with_args("scripts/unix/uninstall.sh", ["--dry-run"])
        print()

    confirm = input("    Proceed with uninstall? [y/N]: ").strip().lower()
    if confirm in ("y", "yes", "s", "si"):
        return run_bash("scripts/unix/uninstall.sh")
    print("    Cancelled.")
    return 0

def action_update(os_type):
    print("\n    --- Update (changed files only) ---\n")

    if os_type == "windows" and not has_bash():
        print("    ERROR: Update requires bash (no PowerShell updater available).")
        print("    Install Git for Windows: https://git-scm.com/download/win")
        return 1

    # Pull latest changes from remote before updating
    print("    Pulling latest changes from git...")
    result = subprocess.run(["git", "pull"], cwd=SCRIPT_DIR, capture_output=True, text=True)
    if result.returncode == 0:
        output = result.stdout.strip()
        if "Already up to date" in output or "Already up-to-date" in output:
            print("    Already up to date.\n")
        else:
            print(f"    {output}\n")
    else:
        print(f"    WARNING: git pull failed: {result.stderr.strip()}")
        choice = input("    Continue with local files? [y/N]: ").strip().lower()
        if choice not in ("y", "yes", "s", "si"):
            print("    Cancelled.")
            return 0
        print()

    return run_bash("scripts/unix/update.sh")

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

    # Try bash script first
    script = os.path.join(SCRIPT_DIR, "scripts", "unix", "customize.sh")
    if os.path.isfile(script) and has_bash():
        result = run_bash("scripts/unix/customize.sh")
        if result == 0:
            return 0

    # Fallback: Python-based configuration guide
    print("    MCP Configuration Guide")
    print("    -----------------------")
    print()

    config_dir = os.path.join(INSTALL_DIR, "data")
    config_file = os.path.join(config_dir, "mcp-config.json")
    template_file = os.path.join(config_dir, "mcp-config-template.json")

    if os.path.isfile(config_file):
        size = os.path.getsize(config_file)
        print(f"    [OK] Config exists: {config_file} ({size} bytes)")
    elif os.path.isfile(template_file):
        print(f"    [OK] Template available: {template_file}")
        print(f"    To create your config:")
        print(f"         Copy the template and edit it:")
        print(f"         cp {template_file} {config_file}")
    else:
        print(f"    [MISS] No config template found")
        print(f"    Run install first: python setup.py -> Install")
        return 1

    settings_file = os.path.join(INSTALL_DIR, "settings.json")
    if os.path.isfile(settings_file):
        print(f"    [OK] Settings: {settings_file}")
    else:
        print(f"    [MISS] Settings file not found")

    print()
    print("    To configure MCP servers manually:")
    print(f"    1. Edit: {config_file}")
    print(f"    2. Add server entries with name, command, and args")
    print(f"    3. Restart Claude Code to pick up changes")
    print()
    print(f"    Docs: https://docs.anthropic.com/en/docs/claude-code/mcp")

    return 0

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

    # Try dedicated diagnostic script
    diag_path = os.path.join(SCRIPT_DIR, "dev", "tools", "diagnose-install.sh")
    if os.path.isfile(diag_path) and has_bash():
        result = run_bash("dev/tools/diagnose-install.sh")
        if result == 0:
            return 0

    # Fallback: Python diagnostics
    print("    Running diagnostics...\n")
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

    # Check line endings on bash scripts
    scripts_dir = os.path.join(SCRIPT_DIR, "scripts", "unix")
    if os.path.isdir(scripts_dir):
        crlf_files = []
        for f in os.listdir(scripts_dir):
            if f.endswith(".sh"):
                fpath = os.path.join(scripts_dir, f)
                with open(fpath, "rb") as fh:
                    if b"\r\n" in fh.read(1024):
                        crlf_files.append(f)
        if crlf_files:
            print(f"    [WARN] CRLF line endings in: {', '.join(crlf_files)}")
            print("           Run: dos2unix scripts/unix/*.sh")
        else:
            print("    [OK]   Shell scripts have correct line endings (LF)")

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

# Valid menu keys for quick re-entry
VALID_KEYS = {key for key, _, _, action in MENU_OPTIONS if action}
VALID_KEYS.add("q")

def show_menu(os_type):
    installed = is_installed()

    status_line = f"v{installed}" if installed else "Not installed"

    print(f"""
    ╔══════════════════════════════════════════════╗
    ║   Agentic Substrate v{VERSION}                 ║
    ║   Research-first dev system for Claude Code  ║
    ╚══════════════════════════════════════════════╝

    OS: {os_type}  |  Python {platform.python_version()}  |  {status_line}
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
        force_flag = "--force" in sys.argv or "-Force" in sys.argv

        # Handle install --force directly (bypass interactive menu)
        if cmd == "install" and force_flag:
            if os_type == "windows":
                ps_cmd = has_powershell()
                if has_bash():
                    sys.exit(_run_install_bash(force=True))
                elif ps_cmd:
                    sys.exit(_run_install_ps(ps_cmd, force=True))
                else:
                    print("    ERROR: No bash or PowerShell found.")
                    print("    Install Git for Windows: https://git-scm.com/download/win")
                    sys.exit(1)
            else:
                sys.exit(_run_install_bash(force=True))

        for key, name, desc, action in MENU_OPTIONS:
            if cmd == name.lower() and action:
                sys.exit(action(os_type))
        print(f"    Unknown command: {cmd}")
        print(f"    Available: {', '.join(name.lower() for _, name, _, a in MENU_OPTIONS if a)}")
        sys.exit(1)

    # Interactive menu
    next_choice = None
    while True:
        if next_choice:
            choice = next_choice
            next_choice = None
        else:
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
                    # Smart continue: if user types a valid option, use it directly
                    cont = input("\n    Press Enter to continue (or type option number): ").strip().lower()
                    if cont in VALID_KEYS:
                        next_choice = cont
                matched = True
                break

        if not matched:
            print(f"    Invalid option: {choice}")
            cont = input("\n    Press Enter to continue (or type option number): ").strip().lower()
            if cont in VALID_KEYS:
                next_choice = cont

if __name__ == "__main__":
    main()
