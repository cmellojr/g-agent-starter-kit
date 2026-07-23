---
shortDescription: Standards for REST API design and resource naming.
scope: architecture
version: 1.0.0
lastUpdated: 2026-06-03
---

# API Design Standards

This document defines the standards for designing networked APIs, following the
[Google API Design Guide](https://cloud.google.com/apis/design).

[TOC]

## Resource-oriented Design

APIs SHOULD be designed as a collection of individual resources that can be
manipulated. A resource-oriented API is typically modeled as a resource
hierarchy, where each node is either a simple resource or a collection resource.

### Resource Names

Resource names SHOULD be intuitive and hierarchical. A resource name consists of
the collection ID and the resource ID, formatted as a path.

- **Collection ID**: MUST be plural (e.g., `users`, `projects`, `vessels`).
- **Resource ID**: SHOULD be a unique identifier for the resource within the
  collection.

Example: `//storage.googleapis.com/buckets/bucket-id/objects/object-id`

### Standard Methods

APIs SHOULD use standard methods for common operations to reduce complexity and
increase consistency.

| Method | HTTP Mapping | Description |
|---|---|---|
| **List** | `GET <collection_url>` | Lists resources in a collection. |
| **Get** | `GET <resource_url>` | Retrieves a single resource. |
| **Create** | `POST <collection_url>` | Creates a new resource. |
| **Update** | `PUT` or `PATCH <resource_url>` | Updates a resource. |
| **Delete** | `DELETE <resource_url>` | Deletes a resource. |

#### List

- MUST use `GET`.
- SHOULD support pagination (e.g., `page_size`, `page_token`).
- Responses SHOULD contain a `next_page_token` if more results exist.

#### Get

- MUST use `GET`.
- MUST return the resource directly in the response body.

#### Create

- MUST use `POST`.
- SHOULD accept the resource to be created in the request body.
- SHOULD return the created resource in the response body.

#### Update

- SHOULD use `PATCH` with a field mask to allow partial updates.
- If `PUT` is used, it MUST replace the entire resource.

#### Delete

- MUST use `DELETE`.
- SHOULD return an empty response or a "deleted" status.

### Custom Methods

Custom methods SHOULD only be used for operations that do not map naturally to
standard methods. They SHOULD use the `:customMethod` suffix in the URI.

Example: `POST /v1/projects/123/locations/us-central1/clusters/456:stop`

## Standard Fields

Consistency in field naming is critical for a high-quality API.

- `name`: The full resource name.
- `id`: The resource ID (unique within the collection).
- `create_time`: Timestamp when the resource was created.
- `update_time`: Timestamp when the resource was last updated.
- `display_name`: A human-readable name for the resource.
- `etag`: Entity tag for optimistic concurrency control.

## Error Handling

APIs MUST use a consistent error model. Errors SHOULD include:

- **Code**: A numeric error code (aligned with HTTP status codes).
- **Message**: A developer-facing error message (in English).
- **Status**: A string-based error code (e.g., `INVALID_ARGUMENT`).
- **Details**: (Optional) Additional structured information about the error.

### Common Error Codes

- `400 BAD REQUEST`: Invalid arguments or malformed request.
- `401 UNAUTHORIZED`: Authentication required.
- `403 FORBIDDEN`: Authenticated but lacks permission.
- `404 NOT FOUND`: Resource does not exist.
- `409 CONFLICT`: Resource already exists or state conflict.
- `429 TOO MANY REQUESTS`: Rate limit exceeded.
- `500 INTERNAL SERVER ERROR`: Unexpected server failure.

## See also

- [Google API Design Guide](https://cloud.google.com/apis/design)
- [AIP.dev - API Improvement Proposals](https://google.aip.dev/)
- [Google HTTP Guidelines](https://cloud.google.com/apis/docs/http)
