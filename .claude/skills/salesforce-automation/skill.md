---
name: salesforce-automation
description: "Automate Salesforce CRM operations: manage leads, contacts, opportunities, accounts, cases, and custom objects. SOQL queries, bulk data operations, and workflow automation."
auto_invoke: false
tags: [salesforce, crm, automation, leads, opportunities, soql]
---

# Salesforce Automation Skill

Automate Salesforce CRM operations including lead management, opportunity tracking, case handling, and reporting via SOQL queries.

## When to Invoke

- Managing leads, contacts, or opportunities
- SOQL queries for CRM reporting
- Bulk data operations (import/export/update)
- Case management and support workflows
- Salesforce API integrations

## Core Objects

| Object | Purpose | Key Fields |
|--------|---------|------------|
| Lead | Unqualified prospect | Name, Company, Email, Status, Source |
| Contact | Qualified individual | Name, Account, Email, Phone, Title |
| Account | Organization/company | Name, Industry, Revenue, Website |
| Opportunity | Potential deal | Name, Stage, Amount, CloseDate, Account |
| Case | Support ticket | Subject, Status, Priority, Contact |
| Task | Activity tracking | Subject, Status, DueDate, WhoId, WhatId |

## SOQL Queries

### Lead Management
```sql
-- Hot leads from last 7 days
SELECT Id, Name, Company, Email, LeadSource, Status, CreatedDate
FROM Lead
WHERE Status = 'Open' AND Rating = 'Hot'
AND CreatedDate = LAST_N_DAYS:7
ORDER BY CreatedDate DESC

-- Leads by source
SELECT LeadSource, COUNT(Id) total, 
  SUM(CASE WHEN IsConverted = true THEN 1 ELSE 0 END) converted
FROM Lead
WHERE CreatedDate = THIS_QUARTER
GROUP BY LeadSource
ORDER BY COUNT(Id) DESC

-- Unassigned leads
SELECT Id, Name, Company, Email, CreatedDate
FROM Lead
WHERE OwnerId = '00G...' AND Status = 'Open'
```

### Opportunity Pipeline
```sql
-- Open pipeline by stage
SELECT StageName, COUNT(Id) count, SUM(Amount) total
FROM Opportunity
WHERE IsClosed = false
GROUP BY StageName
ORDER BY SUM(Amount) DESC

-- Closing this month
SELECT Id, Name, Account.Name, Amount, StageName, CloseDate, Owner.Name
FROM Opportunity
WHERE CloseDate = THIS_MONTH AND IsClosed = false
ORDER BY Amount DESC

-- Stale opportunities (no activity in 30 days)
SELECT Id, Name, Amount, StageName, LastActivityDate
FROM Opportunity
WHERE IsClosed = false AND LastActivityDate < LAST_N_DAYS:30
ORDER BY Amount DESC

-- Win rate by rep
SELECT Owner.Name, COUNT(Id) total,
  SUM(CASE WHEN IsWon = true THEN 1 ELSE 0 END) won
FROM Opportunity
WHERE CloseDate = THIS_QUARTER AND IsClosed = true
GROUP BY Owner.Name
```

### Account Intelligence
```sql
-- Top accounts by revenue
SELECT Id, Name, Industry, AnnualRevenue, 
  (SELECT COUNT(Id) FROM Opportunities WHERE IsClosed = false) open_opps
FROM Account
WHERE AnnualRevenue > 1000000
ORDER BY AnnualRevenue DESC LIMIT 50

-- Accounts without recent activity
SELECT Id, Name, LastActivityDate
FROM Account
WHERE LastActivityDate < LAST_N_DAYS:90
AND Id IN (SELECT AccountId FROM Opportunity WHERE IsClosed = false)
```

### Support Cases
```sql
-- Open high-priority cases
SELECT Id, CaseNumber, Subject, Status, Priority, Contact.Name, CreatedDate
FROM Case
WHERE IsClosed = false AND Priority IN ('High', 'Critical')
ORDER BY CreatedDate ASC

-- Case resolution time
SELECT Status, AVG(ClosedDate - CreatedDate) avg_resolution
FROM Case
WHERE IsClosed = true AND ClosedDate = THIS_QUARTER
GROUP BY Status
```

## Workflow Patterns

### Lead Lifecycle
```
New -> Contacted -> Qualified -> Converted (to Contact + Opportunity)
  |                    |
  +-> Unqualified      +-> Nurture -> Re-engage
```

### Opportunity Stages
```
Prospecting -> Qualification -> Needs Analysis -> Proposal -> Negotiation -> Closed Won
                                                                          -> Closed Lost
```

### Case Workflow
```
New -> Assigned -> In Progress -> Escalated -> Resolved -> Closed
                      |                           |
                      +-> Waiting on Customer ----+
```

## Bulk Operations

| Operation | API | Use Case |
|-----------|-----|----------|
| Insert | `/composite/sobjects` | Import new leads from event |
| Update | `/composite/sobjects` | Mass status change |
| Upsert | `/composite/sobjects` | Sync from external system |
| Delete | `/composite/sobjects` | Clean up duplicates |
| Query | `/query` | Export data for reporting |

### Bulk Insert Example
```json
{
  "allOrNone": false,
  "records": [
    {
      "attributes": {"type": "Lead"},
      "FirstName": "Jane",
      "LastName": "Doe",
      "Company": "Acme Corp",
      "Email": "jane@acme.com",
      "LeadSource": "Web"
    }
  ]
}
```

## Reporting Templates

### Pipeline Report
```markdown
## Pipeline Summary - Q2 2026

| Stage | Count | Value | Avg Deal |
|-------|-------|-------|----------|
| Prospecting | 12 | $180K | $15K |
| Qualification | 8 | $240K | $30K |
| Proposal | 5 | $350K | $70K |
| Negotiation | 3 | $210K | $70K |
| **Total Pipeline** | **28** | **$980K** | |

**Forecast**: $420K (weighted by stage probability)
**Quota**: $500K | **Coverage**: 1.96x
```

## Integration with Agentic Substrate

- `@business-analyst` uses SOQL queries for requirements analysis
- `@product-strategist` leverages pipeline data for roadmap decisions
- `@incident-commander` creates cases for customer-impacting incidents
- Lead/opportunity data feeds `@content-strategist` targeting

## API Reference

Base URL: `https://your-instance.salesforce.com/services/data/v60.0/`

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/sobjects/{Object}` | POST | Create record |
| `/sobjects/{Object}/{Id}` | GET/PATCH/DELETE | CRUD on record |
| `/query?q={SOQL}` | GET | Execute SOQL query |
| `/composite/sobjects` | POST | Bulk operations |
| `/search?q={SOSL}` | GET | Full-text search |

## Source
Adapted from ComposioHQ/awesome-claude-skills salesforce-automation patterns and Salesforce API v60.0 documentation.
