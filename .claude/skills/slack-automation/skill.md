---
name: slack-automation
description: "Automate Slack operations: send messages, manage channels, search conversations, post notifications, handle threads, and integrate with CI/CD pipelines. Works with Slack MCP integration."
auto_invoke: false
tags: [slack, automation, messaging, notifications, integrations]
---

# Slack Automation Skill

Automate Slack messaging, channel management, and notification workflows. Designed to work with Slack MCP tools when available, or via Slack API directly.

## When to Invoke

- User needs to send Slack messages or notifications
- CI/CD pipeline needs Slack integration
- Channel management or search operations
- Thread replies and conversation management
- Automated status updates or alerts

## Available Operations

### Message Operations

#### Send a Message
```
Channel: #channel-name or channel ID
Message: Plain text or Slack mrkdwn format
Thread: Optional thread_ts for replies
```

**Slack mrkdwn formatting**:
- Bold: `*text*`
- Italic: `_text_`
- Strikethrough: `~text~`
- Code: `` `inline` `` or ` ```block``` `
- Link: `<https://url|Display Text>`
- Mention: `<@USER_ID>` or `<!channel>` or `<!here>`
- Emoji: `:emoji_name:`

#### Rich Messages with Block Kit
```json
{
  "channel": "C0123456789",
  "blocks": [
    {
      "type": "header",
      "text": {"type": "plain_text", "text": "Deployment Report"}
    },
    {
      "type": "section",
      "fields": [
        {"type": "mrkdwn", "text": "*Environment:*\nProduction"},
        {"type": "mrkdwn", "text": "*Status:*\n:white_check_mark: Success"}
      ]
    },
    {
      "type": "section",
      "text": {"type": "mrkdwn", "text": "*Changes:*\n- feat: Add user auth\n- fix: Login redirect bug"}
    },
    {
      "type": "actions",
      "elements": [
        {"type": "button", "text": {"type": "plain_text", "text": "View Logs"}, "url": "https://logs.example.com"},
        {"type": "button", "text": {"type": "plain_text", "text": "Rollback"}, "style": "danger", "url": "https://deploy.example.com/rollback"}
      ]
    }
  ]
}
```

### Channel Operations

| Operation | Description |
|-----------|------------|
| List channels | Get all channels the bot has access to |
| Create channel | Create public/private channel |
| Archive channel | Archive an inactive channel |
| Set topic | Update channel topic/purpose |
| Invite users | Add users to a channel |
| Get history | Retrieve message history |

### Search Operations

```
Search messages: query + optional filters (from:user, in:channel, after:date, before:date)
Search files: Find files shared in Slack
```

### Notification Templates

#### Deployment Notification
```
:rocket: *Deployment to Production*
*Service:* api-gateway v2.3.1
*Status:* :white_check_mark: Success
*Duration:* 3m 42s
*Changes:* 4 commits by 2 authors
*Rollback:* `git revert abc1234`
```

#### Security Alert
```
:rotating_light: *Security Alert - HIGH*
*Type:* Dependency vulnerability
*Package:* lodash@4.17.20
*CVE:* CVE-2024-XXXX
*Impact:* Prototype pollution
*Action Required:* Update to 4.17.21+
```

#### Build Failure
```
:x: *Build Failed - PR #142*
*Branch:* feature/user-auth
*Author:* <@U0123456789>
*Error:* TypeScript compilation - 3 errors
*Details:* <https://ci.example.com/build/142|View Build Log>
```

#### Incident Notification
```
:fire: *INCIDENT - P1*
*Service:* Payment API
*Impact:* Users cannot complete checkout
*Started:* 2026-04-13 14:22 UTC
*Status:* Investigating
*Commander:* <@U0123456789>
*Channel:* <#C0123456789|inc-payments-20260413>
```

## Integration Patterns

### With CI/CD Pipeline
```yaml
# GitHub Actions example
- name: Notify Slack
  uses: slackapi/slack-github-action@v2
  with:
    channel-id: 'C0123456789'
    payload: |
      {
        "text": "Deploy ${{ job.status }}: ${{ github.repository }}@${{ github.sha }}"
      }
  env:
    SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
```

### With Incident Response
1. Create incident channel: `#inc-[service]-[date]`
2. Post initial alert with severity and impact
3. Pin the incident summary
4. Set channel topic to incident status
5. Post updates as investigation progresses
6. Archive channel after post-mortem

### With Agentic Substrate
- `@incident-commander` posts status updates to incident channels
- `@brahma-deployer` sends deployment notifications
- `@brahma-monitor` sends alert notifications
- `@review-coordinator` can post review summaries
- Security alerts from `@security-auditor` route to security channel

## MCP Integration

When Slack MCP tools are available (check deferred tools for `mcp__claude_ai_Slack__*`):
1. Authenticate: `mcp__claude_ai_Slack__authenticate`
2. Complete auth: `mcp__claude_ai_Slack__complete_authentication`
3. Use authenticated Slack API for all operations

## Source
Adapted from ComposioHQ/awesome-claude-skills slack-automation patterns.
