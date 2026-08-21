// Expense Claims & Payroll Export — wireframes

screen MyClaims "Employee tracks the status of claims they've submitted"
  navbar "ExpenseHub"
  sidebar "My Claims -> MyClaims | Settings"
  row
    heading "My Claims"
    right
    button "New claim" primary -> NewClaim
  row
    card "Pending | 2 | awaiting manager review"
    card "Approved | 5 | ready for payroll"
    card "Rejected | 1 | see comment"
  table "Date | Category | Amount | Status"
    row "Aug 18 | Travel | $142.50 | Pending"
    row "Aug 12 | Meals | $38.20 | Approved"
    row "Aug 3 | Software | $99.00 | Rejected"

screen NewClaim "Employee submits a new expense claim with a receipt"
  navbar "ExpenseHub"
  sidebar "My Claims -> MyClaims | Settings"
  breadcrumb "My Claims / New claim"
  heading "New Expense Claim"
  input "Amount — e.g. 142.50"
  select "Category: Travel"
  textarea "Description of the expense"
  input "Receipt file (image or PDF)"
  row
    right
    button "Cancel"
    button "Submit claim" primary -> MyClaims

screen ReviewQueue "Manager reviews claims submitted by their team"
  navbar "ExpenseHub"
  sidebar "Review Queue -> ReviewQueue | Settings"
  row
    heading "Review Queue"
    right
    select "Status: Pending"
  row
    card "Pending review | 6 | across your team"
    card "Approved this month | 14 | $2,340 total"
  table "Employee | Category | Amount | Submitted | Status" -> ClaimDetail
    row "A. Chen | Travel | $142.50 | Aug 18 | Pending"
    row "M. Diaz | Meals | $38.20 | Aug 17 | Pending"
    row "R. Osei | Software | $99.00 | Aug 15 | Pending"

screen ClaimDetail "Manager reviews one claim's receipt and approves or rejects it"
  navbar "ExpenseHub"
  sidebar "Review Queue -> ReviewQueue | Settings"
  breadcrumb "Review Queue / A. Chen — Travel"
  row
    heading "Travel — $142.50"
    badge "Pending" warning
  text "Submitted by A. Chen on Aug 18"
  split 60/40
    left
      heading "Details"
      text "Client site visit — round-trip train ticket."
      image "receipt.pdf" 300x200
    right
      textarea "Decision comment (optional)"
      row
        button "Reject" danger
        button "Approve" primary -> ReviewQueue

screen ExportQueue "Finance reviews approved unexported claims and exports them for payroll"
  navbar "ExpenseHub"
  sidebar "Export Queue -> ExportQueue | Settings"
  row
    heading "Export Queue"
    right
    button "Export selected" primary -> ExportConfirm
  row
    card "Ready to export | 23 | approved, not yet exported"
    card "Total amount | $4,812.30 | this batch"
  table "Employee | Category | Amount | Approved on"
    row "A. Chen | Travel | $142.50 | Aug 19"
    row "M. Diaz | Meals | $38.20 | Aug 18"
    row "R. Osei | Software | $99.00 | Aug 16"

screen ExportConfirm "Finance downloads the payroll file and confirms the batch is marked exported"
  navbar "ExpenseHub"
  sidebar "Export Queue -> ExportQueue | Settings"
  breadcrumb "Export Queue / Export batch"
  heading "Export 23 Claims"
  text "This generates a CSV file and marks these claims as exported so they can't be exported again."
  progress "100%" success
  text "expense-export-2026-08-21.csv ready"
  row
    right
    button "Cancel"
    button "Download & mark exported" primary -> ExportQueue

flow "Submit a claim"
  role "Employee"
  description "An employee submits a new claim and tracks it through review"
  MyClaims
  NewClaim

flow "Review team claims"
  role "Manager"
  description "A manager reviews pending claims and approves or rejects each"
  ReviewQueue
  ClaimDetail

flow "Export to payroll"
  role "Finance"
  description "Finance reviews approved claims and exports a batch for payroll"
  ExportQueue
  ExportConfirm
