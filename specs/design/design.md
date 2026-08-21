# Expense Claims &amp; Payroll Export — Design

## Overview

The system is a single React SPA (`expense-webapp`) fronting one Ballerina API
(`expense-api`) that owns the full expense-claim lifecycle: employees submit
claims with a required receipt, managers approve or reject the claims their
reports submit, and finance reviews approved-but-unexported claims and
downloads a CSV/Excel export to hand to payroll. `expense-api` persists claims
in a Postgres database, stores receipt files in an object store, sends
transactional email notifications on submission and decision, and both the
SPA and the API authenticate signed-in users through Thunder, the platform
IDP. There is no live payroll integration — export is a file the finance
actor manually uploads elsewhere.

## Context (C1)

```mermaid
graph TD
  Employee((Employee))
  Manager((Manager))
  Finance((Finance))
  System[Expense Claims & Payroll Export]
  Thunder[[Thunder Auth]]
  Email[[Email Provider]]

  Employee -->|submits claims, tracks status| System
  Manager -->|reviews & approves/rejects| System
  Finance -->|exports approved claims| System
  System -->|sign-in| Thunder
  System -->|status notifications| Email
```

## Domain model (ER)

```mermaid
erDiagram
  EMPLOYEE {
    string id
    string name
    string email
    string managerId
  }
  EXPENSE_CLAIM {
    string id
    string employeeId
    decimal amount
    string category
    string description
    string status
    string receiptFileId
    string decisionComment
    boolean exported
    datetime submittedAt
    datetime decidedAt
  }
  RECEIPT {
    string id
    string claimId
    string fileName
    string contentType
    string storageRef
  }
  EXPORT_BATCH {
    string id
    string createdBy
    datetime createdAt
    string fileRef
  }

  EMPLOYEE ||--o{ EXPENSE_CLAIM : submits
  EMPLOYEE ||--o{ EMPLOYEE : manages
  EXPENSE_CLAIM ||--|| RECEIPT : has
  EXPORT_BATCH ||--o{ EXPENSE_CLAIM : includes
```

## Key flows

### Submit and approve a claim

```mermaid
sequenceDiagram
  actor Employee
  participant Webapp as expense-webapp
  participant API as expense-api
  actor Manager

  Employee->>Webapp: Fill claim form + attach receipt
  Webapp->>API: POST /expense-claims (amount, category, description, receipt)
  API->>API: Store claim (status=submitted) + receipt
  API-->>Manager: Email: new claim awaiting review
  Manager->>Webapp: Open pending claims
  Webapp->>API: GET /expense-claims?status=submitted
  Manager->>Webapp: Approve or reject (+ comment)
  Webapp->>API: POST /expense-claims/{id}/approve or /reject
  API->>API: Update status
  API-->>Employee: Email: claim approved/rejected
```

### Finance export to payroll

```mermaid
sequenceDiagram
  actor Finance
  participant Webapp as expense-webapp
  participant API as expense-api

  Finance->>Webapp: Open approved, unexported claims
  Webapp->>API: GET /expense-claims?status=approved&exported=false
  Finance->>Webapp: Select claims + Export
  Webapp->>API: POST /expense-claims/export
  API->>API: Build CSV/Excel file, mark claims exported
  API-->>Webapp: File download
  Finance->>Finance: Upload file into payroll system
```