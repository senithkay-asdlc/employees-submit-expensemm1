# Security Design

## Roles → permissions

No separate admin role is defined — the PRD names only Employee, Manager, and
Finance actors.

## Authentication (Thunder)

- Shared `thunder-app` dependency name: `user-auth`, declared identically on
`expense-webapp` (the SPA) and `expense-api` (the protected backend) — the
shared name ties browser sign-in to the bearer tokens `expense-api`
validates.
- Scopes: `openid profile email` (default).
- `expense-webapp` performs OIDC + PKCE sign-in and attaches the resulting
access token to every `expense-api` call. `expense-api` validates the token
on every request; the gateway injects the caller's identity header.

## Role resolution

`expense-api` resolves the caller's role from the employee record matched to
the token's subject/email claim: an employee with reports acts as a Manager
for those reports' claims, and Finance is a flag/group on the employee record
(organization-provisioned, not self-service). A caller whose identity matches
no employee record is denied (403) on every endpoint — deny by default. A
Manager may only act on claims submitted by their own direct reports; acting
on another manager's report's claim is rejected (403).