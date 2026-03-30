#!/usr/bin/env bash
# notify-completion.sh
# Notification hook: Desktop notification when Claude needs attention
# Works on macOS, Linux, and Windows (Git Bash/PowerShell)

# Detect OS and send notification
send_notification() {
    local title="$1"
    local message="$2"

    # Sanitize inputs to prevent shell injection
    # Escape double quotes for osascript
    local title_osa="${title//\"/\\\"}"
    local message_osa="${message//\"/\\\"}"
    # Escape single quotes for PowerShell
    local title_ps="${title//\'/\'\'}"
    local message_ps="${message//\'/\'\'}"

    case "$OSTYPE" in
        darwin*)
            osascript -e "display notification \"$message_osa\" with title \"$title_osa\"" 2>/dev/null
            ;;
        linux*)
            if command -v notify-send &>/dev/null; then
                notify-send "$title" "$message" 2>/dev/null
            fi
            ;;
        msys*|cygwin*|win*)
            # Windows: use PowerShell toast notification
            powershell.exe -Command "
                [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > \$null
                \$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
                \$textNodes = \$template.GetElementsByTagName('text')
                \$textNodes.Item(0).AppendChild(\$template.CreateTextNode('$title_ps')) > \$null
                \$textNodes.Item(1).AppendChild(\$template.CreateTextNode('$message_ps')) > \$null
                \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$template)
                [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Claude Code').Show(\$toast)
            " 2>/dev/null || true
            ;;
    esac
}

send_notification "Claude Code" "Task complete - needs your attention"
exit 0
