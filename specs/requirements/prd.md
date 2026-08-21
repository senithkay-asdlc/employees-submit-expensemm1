# Expense Claims &amp; Payroll Export — PRD

## Problem Statement

Employees who incur business expenses today track them through ad-hoc means —
spreadsheets, email threads, paper receipts — and managers approve them the
same way. Finance then has to manually chase down and reconcile approved
claims before they can be paid out through payroll. This costs time for every
role involved, loses receipts and approval history, and delays reimbursement
to employees.

## Solution

A single system where employees submit expense claims with the details and
receipts finance needs, managers review and approve or reject those claims,
and finance exports the batch of approved claims as a file ready to feed into
payroll — replacing the scattered spreadsheets and email approvals with one
tracked workflow.

## Actors

- **Employee** — submits expense claims for their own spending, attaches
receipts, and tracks the status of their claims.
- **Manager** — reviews expense claims submitted by their team, approves or
rejects each one.
- **Finance** — reviews approved claims across the organization and exports
them as a file for payroll processing.

## User Stories

1. As an employee, I want to submit an expense claim with an amount, category,
 description, and a receipt attachment, so that my manager has everything
 needed to review it.
2. As an employee, I want to see the status of my submitted claims (pending,
 approved, rejected), so that I know where my reimbursement stands.
3. As an employee, I want to be notified by email when my claim is approved or
 rejected, so that I don't have to keep checking the app.
4. As a manager, I want to see a list of expense claims submitted by my team
 awaiting my review, so that I can act on them.
5. As a manager, I want to be notified by email when a new claim is submitted
 to me, so that I know to review it promptly.
6. As a manager, I want to approve or reject a claim, optionally with a
 comment, so that the employee understands the decision.
7. As finance, I want to see all approved claims that haven't yet been
 exported, so that I know what's ready for payroll.
8. As finance, I want to export a batch of approved claims as a downloadable
 file (CSV/Excel), so that I can upload it into our payroll system.
9. As finance, I want exported claims to be marked as exported, so that they
 are not accidentally exported twice.

## Product Decisions

- Sign-in is via SSO through Thunder, the platform IDP, for all actors
(organization default).
- Approval is single-level: the employee's manager is the sole approver;
once a manager approves a claim it is ready for payroll export (no
additional finance-level approval gate).
- A receipt attachment (image or PDF) is required on every claim submission,
alongside amount, category, and description.
- Payroll integration is a manual file handoff: finance downloads a
CSV/Excel export of approved claims and uploads it into whichever payroll
system the organization uses; no live integration with a named payroll
provider is built.
- Email notifications are sent on claim submission (to the manager) and on
approval/rejection (to the employee).
- The product supports a single organization-wide currency; no multi-currency
or conversion handling.

## Out of Scope

- Multi-level or amount-based approval routing.
- Direct/live integration with a specific payroll provider's API.
- Multi-currency claims or currency conversion.
- Editing or resubmitting a rejected claim as a new version (employee would
submit a fresh claim).
- Expense policy enforcement or automated fraud/anomaly detection.
- Reporting/analytics dashboards beyond the approved-but-unexported list.

## Open Questions

None — all decisions needed to proceed to design were resolved above.