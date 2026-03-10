# API Spec Template

Standard template for API design specifications. Used by @api-designer and `/api-design` command.

---

## Format

```markdown
# API Specification: [Service/Feature Name]

## Overview
- **Base URL**: `/api/v1`
- **Auth**: [Bearer token | API key | OAuth 2.0 | None]
- **Format**: JSON
- **Versioning**: URL path (`/v1/`)

## Authentication

[Describe auth mechanism, token format, how to obtain credentials]

## Common Headers

| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | `Bearer {token}` |
| Content-Type | Yes (POST/PUT/PATCH) | `application/json` |
| Accept | No | `application/json` |

## Error Format (RFC 7807)

All errors return:
```json
{
  "type": "https://api.example.com/errors/{error-type}",
  "title": "Human-readable title",
  "status": 422,
  "detail": "Specific error explanation",
  "errors": [
    { "field": "email", "message": "Must be a valid email" }
  ]
}
```

## Status Codes

| Code | Meaning | Used For |
|------|---------|----------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Malformed request |
| 401 | Unauthorized | Missing/invalid auth |
| 403 | Forbidden | Valid auth, insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource |
| 422 | Unprocessable | Validation failed |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Error | Server failure |

## Pagination

Cursor-based:
```
GET /resources?cursor={cursor}&limit={limit}

Response:
{
  "data": [...],
  "meta": {
    "next_cursor": "abc123",
    "has_more": true,
    "total": 150
  }
}
```

## Filtering & Sorting

```
GET /resources?status=active&created_after=2024-01-01&sort=name&order=asc
```

---

## Endpoints

### [Resource Name]

#### List [Resources]
```
GET /resources
```

**Query Parameters**:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| cursor | string | null | Pagination cursor |
| limit | integer | 20 | Items per page (max 100) |
| status | string | null | Filter by status |
| sort | string | created_at | Sort field |
| order | string | desc | Sort order (asc/desc) |

**Response** `200 OK`:
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Example",
      "status": "active",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "next_cursor": "abc123",
    "has_more": true,
    "total": 42
  }
}
```

#### Get [Resource]
```
GET /resources/:id
```

**Response** `200 OK`:
```json
{
  "data": {
    "id": "uuid",
    "name": "Example",
    "status": "active",
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

**Error** `404 Not Found`:
```json
{
  "type": "https://api.example.com/errors/not-found",
  "title": "Resource Not Found",
  "status": 404,
  "detail": "Resource with id 'uuid' does not exist"
}
```

#### Create [Resource]
```
POST /resources
```

**Request Body**:
```json
{
  "name": "Example",
  "status": "active"
}
```

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| name | string | Yes | 1-255 chars |
| status | string | No | active, inactive (default: active) |

**Response** `201 Created`:
```json
{
  "data": {
    "id": "uuid",
    "name": "Example",
    "status": "active",
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

#### Update [Resource]
```
PATCH /resources/:id
```

**Request Body** (partial update):
```json
{
  "name": "Updated Example"
}
```

**Response** `200 OK`: Returns updated resource.

#### Delete [Resource]
```
DELETE /resources/:id
```

**Response** `204 No Content`: Empty body.

---

## Rate Limiting

| Tier | Requests/min | Burst |
|------|-------------|-------|
| Free | 60 | 10 |
| Pro | 600 | 100 |
| Enterprise | 6000 | 1000 |

**Headers**:
```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1704067200
```

## Webhooks (if applicable)

```json
{
  "event": "resource.created",
  "timestamp": "2024-01-15T10:30:00Z",
  "data": { ... }
}
```

Verification: HMAC-SHA256 signature in `X-Webhook-Signature` header.

Retry policy: 3 attempts with exponential backoff (1s, 10s, 100s).
```

---

## Guidelines

1. **Every endpoint has examples**: Request AND response, including errors
2. **Every field is documented**: Type, required, validation rules
3. **Use consistent naming**: camelCase or snake_case (not mixed)
4. **ISO 8601 dates**: Always UTC timezone
5. **UUIDs for IDs**: String format, not integer

---

**Updated**: 2026-03-10 | **Version**: 7.1.0
