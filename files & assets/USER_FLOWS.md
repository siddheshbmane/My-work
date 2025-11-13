# User Flows & Navigation

> **Lead Analytics Dashboard - User Journey Documentation**
> Version 1.0 | Phase 1 MVP

---

## Table of Contents

1. [Overview](#overview)
2. [User Roles](#user-roles)
3. [Primary User Flows](#primary-user-flows)
4. [Navigation Structure](#navigation-structure)
5. [State Diagrams](#state-diagrams)

---

## Overview

This document describes all user journeys through the Lead Analytics Dashboard, including happy paths, error scenarios, and edge cases.

### Key User Goals

1. **View Performance:** Quickly understand campaign performance across all clients
2. **Upload Data:** Import Google Ads, Meta Ads, and Leads data
3. **Analyze Clients:** Deep-dive into individual client performance
4. **Compare Platforms:** Evaluate Google Ads vs Meta Ads effectiveness
5. **Track Leads:** Monitor lead progression and qualification

---

## User Roles

### 1. Admin
**Permissions:**
- View all reports
- Upload data for any client
- Manage users
- Export all data

### 2. Manager
**Permissions:**
- View all reports
- Upload data for assigned clients
- Export reports

### 3. Analyst
**Permissions:**
- View all reports
- Export reports (read-only)

### 4. Viewer
**Permissions:**
- View reports for assigned clients only

---

## Primary User Flows

### Flow 1: First-Time Login & Dashboard Access

```
┌─────────────────────────────────────────────────────────────┐
│ FLOW: First-Time Login & Dashboard Access                  │
└─────────────────────────────────────────────────────────────┘

1. START: User navigates to https://leadanalytics.olioglobal.com
   ↓
2. LOGIN PAGE
   - User sees login form
   - Fields: Email, Password
   - Actions: [Login] [Forgot Password?]
   ↓
3. User enters credentials
   - Email: user@example.com
   - Password: ********
   ↓
4. User clicks [Login]
   ↓
5. AUTHENTICATION
   ├─→ SUCCESS: Token generated, stored in localStorage
   │   ↓
   │   6. REDIRECT to Master Summary Dashboard
   │      - Show loading spinner (0.5-1s)
   │      - Fetch master summary data
   │      ↓
   │   7. DASHBOARD LOADED
   │      - Display 8 KPI cards
   │      - Display 5 charts
   │      - Display client table
   │      - Show date range filter (default: Last 30 days)
   │      END: User can interact with dashboard
   │
   └─→ FAILURE: Invalid credentials
       ↓
       6. ERROR MESSAGE displayed
          "Invalid email or password. Please try again."
          - Stay on login page
          - Highlight error fields in red
          - Clear password field
          END: User tries again
```

**Key Screens:**
1. `/login` - Login page
2. `/dashboard` - Master Summary Dashboard

**Success Criteria:**
- User successfully authenticated
- Dashboard loads within 2 seconds
- All KPIs and charts display correctly

**Error Scenarios:**
- Invalid credentials → Show error message
- Network error → Show "Unable to connect" message with retry button
- Session expired → Redirect to login with message "Session expired, please login again"

---

### Flow 2: View Master Summary Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│ FLOW: View Master Summary Dashboard                         │
└─────────────────────────────────────────────────────────────┘

1. START: User on Master Summary Dashboard (/dashboard)
   ↓
2. DEFAULT VIEW
   - Date Range: Last 30 days (auto-calculated)
   - Platform: All
   - Display:
     ├─ 8 KPI Cards: Spend, Leads, Qualified, Rate, CPL, CPQL, Revenue, ROI
     ├─ 5 Charts: Quality, Trend, Spend, Platforms, Top Clients
     └─ Client Table: 3 clients with key metrics
   ↓
3. USER INTERACTIONS (Any order)
   │
   ├─→ 3A. FILTER BY DATE RANGE
   │   - User clicks date range picker
   │   - Selects: "Last 7 days" or "Last 90 days" or Custom range
   │   - System fetches new data
   │   - All KPIs and charts update
   │   - Loader shown during fetch (1-2s)
   │
   ├─→ 3B. FILTER BY PLATFORM
   │   - User clicks platform dropdown
   │   - Options: All | Google Ads | Meta Ads
   │   - User selects option
   │   - Dashboard updates to show filtered data
   │
   ├─→ 3C. VIEW CLIENT DETAILS
   │   - User clicks on client name in table
   │   - Navigate to /client-deepdive/:client_id
   │   (See Flow 3)
   │
   ├─→ 3D. HOVER ON CHART
   │   - User hovers over chart data point
   │   - Tooltip appears showing:
   │     * Date
   │     * Metric value
   │     * Percentage/trend
   │
   └─→ 3E. EXPORT REPORT
       - User clicks [Export to Excel] button
       - System generates Excel file
       - Browser downloads "Master_Summary_2025-11-11.xlsx"
       END: File downloaded
```

**Key Components:**
- KPI Cards (8)
- Chart.js visualizations (5)
- Filter bar (date range, platform)
- Client table with pagination
- Export button

**Success Criteria:**
- All 8 KPIs display correct values
- Charts render without errors
- Filters update data within 1 second
- Export completes successfully

**Error Scenarios:**
- API fetch fails → Show error state with retry button
- No data for date range → Show empty state message
- Chart rendering fails → Show fallback message

---

### Flow 3: Client Deep-Dive Analysis

```
┌─────────────────────────────────────────────────────────────┐
│ FLOW: Client Deep-Dive Analysis                             │
└─────────────────────────────────────────────────────────────┘

1. START: User clicks client name from Master Dashboard
   OR User navigates directly to /client-deepdive/CLT001
   ↓
2. LOADING STATE
   - Show spinner with message "Loading client data..."
   - Simulate API call (1.5s delay)
   - 10% chance of error (for demo)
   ↓
3. LOADING RESULT
   ├─→ SUCCESS (90% of cases)
   │   ↓
   │   4. CLIENT DEEPDIVE DISPLAYED
   │      TOP SECTION:
   │      - Client name and info
   │      - 6 KPI cards
   │      - Lead funnel visualization
   │
   │      MIDDLE SECTION:
   │      - Filter bar:
   │        * Search campaigns by name
   │        * Platform dropdown (All/Google/Meta)
   │        * Date range picker
   │
   │      BOTTOM SECTION:
   │      - Campaign performance table
   │        * Sortable columns
   │        * Expandable rows showing ad groups
   │      ↓
   │   5. USER INTERACTIONS
   │      │
   │      ├─→ 5A. SEARCH CAMPAIGNS
   │      │   - User types in search box
   │      │   - Table filters in real-time
   │      │   - Show matching campaigns only
   │      │
   │      ├─→ 5B. SORT TABLE
   │      │   - User clicks column header
   │      │   - Table sorts ascending/descending
   │      │   - Arrow icon shows sort direction
   │      │
   │      ├─→ 5C. EXPAND CAMPAIGN
   │      │   - User clicks expand button (chevron)
   │      │   - Row expands to show ad groups
   │      │   - Display nested table with:
   │      │     * Ad Group name
   │      │     * Spend, Clicks, Leads
   │      │     * CPL, CPQL
   │      │   - User can collapse by clicking again
   │      │
   │      ├─→ 5D. FILTER BY PLATFORM
   │      │   - User selects "Google Ads"
   │      │   - Table shows only Google campaigns
   │      │   - KPIs update to show Google-only metrics
   │      │
   │      └─→ 5E. CHANGE DATE RANGE
   │          - User selects "Last 7 days"
   │          - All data refreshes
   │          - Show loading indicator
   │          - Update KPIs, charts, table
   │
   │      END: User analyzes data
   │
   └─→ FAILURE (10% of cases for demo)
       ↓
       4. ERROR STATE DISPLAYED
          - Show error icon
          - Message: "Error Loading Data"
          - Description: "Unable to load client performance data"
          - [Retry] button
          ↓
       5. User clicks [Retry]
          → Return to step 2 (Loading)
```

**Key Screens:**
- `/client-deepdive/:client_id`

**Key Features:**
- Real-time search
- Column sorting
- Expandable rows (drill-down)
- Multiple filters (search, platform, date)
- 4 UI states (loading, success, empty, error)

**Success Criteria:**
- Page loads within 2 seconds
- Search filters table instantly
- Expand/collapse animations smooth
- All metrics calculate correctly

---

### Flow 4: Upload Data (Google Ads)

```
┌─────────────────────────────────────────────────────────────┐
│ FLOW: Upload Google Ads Data                                │
└─────────────────────────────────────────────────────────────┘

1. START: User navigates to /upload
   ↓
2. UPLOAD PAGE LOADED
   - Show tabbed interface:
     * [Google Ads] (active)
     * [Meta Ads]
     * [Leads]
     * [History]
   ↓
3. GOOGLE ADS TAB
   - Display:
     * Client selector dropdown
     * Drag-and-drop upload zone
     * [Download Template] button
     * Required fields list
     * Upload instructions
   ↓
4. USER SELECTS CLIENT
   - User clicks client dropdown
   - Selects: "Tech Manufacturing Ltd (CLT001)"
   - Client ID stored for upload
   ↓
5. USER UPLOADS FILE
   │
   ├─→ METHOD A: Drag & Drop
   │   - User drags GoogleAds.csv onto zone
   │   - Zone highlights on hover
   │   - File dropped
   │   ↓
   │   6. FILE VALIDATION
   │      ├─→ Valid CSV file
   │      │   - Show file name, size
   │      │   - Show [Upload] [Cancel] buttons
   │      │   ↓
   │      │   7. User clicks [Upload]
   │      │      → Go to step 8
   │      │
   │      └─→ Invalid file type
   │          - Show error: "Please upload a CSV file"
   │          - Clear file selection
   │          - Stay on upload page
   │
   └─→ METHOD B: Browse Files
       - User clicks "Browse Files" link
       - File picker opens
       - User selects GoogleAds.csv
       → Continue to step 6
   ↓
8. UPLOAD PROCESSING
   - Show progress bar (0% → 100%)
   - Display message: "Uploading and validating data..."
   - Processing stages:
     1. Upload file (0-30%)
     2. Validate rows (30-70%)
     3. Import data (70-100%)
   ↓
9. UPLOAD RESULT
   │
   ├─→ SUCCESS (Valid data)
   │   ↓
   │   10. SUCCESS STATE
   │       - Show success icon (green checkmark)
   │       - Message: "Google Ads data uploaded successfully"
   │       - Summary:
   │         * 1,247 rows imported
   │         * 0 rows failed
   │         * 15 campaigns found
   │         * Date range: 2025-11-01 to 2025-11-11
   │       - Warnings (if any):
   │         * Row 245: Keyword field empty, set to N/A
   │       - Actions:
   │         * [View Reports] button → Navigate to dashboard
   │         * [Upload More Data] button → Reset form
   │       END: Upload complete
   │
   ├─→ PARTIAL SUCCESS (Some errors)
   │   ↓
   │   10. PARTIAL SUCCESS STATE
   │       - Show warning icon (yellow)
   │       - Message: "Upload completed with errors"
   │       - Summary:
   │         * 1,200 rows imported
   │         * 47 rows failed
   │       - Errors table:
   │         | Row | Field | Error | Value |
   │         |-----|-------|-------|-------|
   │         | 5   | date  | Invalid format | 2025-13-01 |
   │         | 12  | spend | Cannot be negative | -500 |
   │       - [Download Error Report] button
   │       - [Fix and Re-upload] button
   │       END: User reviews errors
   │
   └─→ FAILURE (Critical error)
       ↓
       10. ERROR STATE
           - Show error icon (red X)
           - Message: "Upload failed"
           - Description: "File does not match required format"
           - Details:
             * Missing required column: "Campaign ID"
             * Invalid date format in row 3
           - Actions:
             * [Download Template] button
             * [Try Again] button → Reset form
           END: User fixes file and retries
```

**Key Screens:**
- `/upload` (Google Ads tab)

**Key Components:**
- Client selector
- Drag-and-drop zone
- Progress indicator
- Success/Error states with detailed feedback

**Success Criteria:**
- File uploads successfully
- Validation errors clearly displayed
- User can download error report
- Upload history updated

**Error Scenarios:**
- Invalid file type → Show error immediately
- Missing required fields → Show validation errors
- Duplicate data → Show warning, allow skip or update
- Network timeout → Show retry option

---

### Flow 5: Compare Platform Performance

```
┌─────────────────────────────────────────────────────────────┐
│ FLOW: Compare Platform Performance (Google vs Meta)         │
└─────────────────────────────────────────────────────────────┘

1. START: User clicks "Platform Comparison" in navigation
   OR User navigates to /platform-comparison
   ↓
2. PAGE LOADED
   - Display:
     * Date range filter (default: Last 30 days)
     * Client filter (default: All Clients)

     TOP SECTION: Side-by-side comparison cards
     ├─ Google Ads Card (left)
     │  - Logo/icon
     │  - 8 key metrics with values
     │  - Color: Google Blue theme
     │
     └─ Meta Ads Card (right)
        - Logo/icon
        - 8 key metrics with values
        - Color: Meta Blue theme

     MIDDLE SECTION: Winner indicator
     - Animated badge showing overall winner
     - Text: "Google Ads performs better overall"

     BOTTOM SECTION: Metric-by-metric comparison
     - Table showing each metric with winner
     - Visual indicators (checkmarks, colors)
   ↓
3. USER INTERACTIONS
   │
   ├─→ 3A. CHANGE DATE RANGE
   │   - User selects "Last 7 days"
   │   - All data refreshes
   │   - Comparison updates
   │   - Winner may change
   │
   ├─→ 3B. FILTER BY CLIENT
   │   - User selects specific client
   │   - Comparison shows client-specific data
   │   - KPIs update
   │
   ├─→ 3C. VIEW DETAILED BREAKDOWN
   │   - User scrolls to charts section
   │   - See:
   │     * CPL comparison chart (bar)
   │     * Lead quality comparison (stacked bar)
   │     * Trend over time (line)
   │   - Hover on charts for details
   │
   └─→ 3D. EXPORT COMPARISON
       - User clicks [Export Report]
       - PDF generated with comparison
       - Download: "Platform_Comparison_2025-11-11.pdf"

   END: User analyzes platform effectiveness
```

**Key Screens:**
- `/platform-comparison`

**Key Features:**
- Side-by-side metric cards
- Animated winner badge
- Metric-by-metric breakdown table
- Comparison charts
- Export to PDF

**Success Criteria:**
- Comparison displays clearly
- Winner determination accurate
- Export includes all data

---

### Flow 6: Track Lead Progression

```
┌─────────────────────────────────────────────────────────────┐
│ FLOW: Track Lead Progression Through Funnel                 │
└─────────────────────────────────────────────────────────────┘

1. START: User clicks "Lead Stage Funnel" in navigation
   OR User navigates to /lead-stage-funnel
   ↓
2. PAGE LOADED
   - Display:
     * Date range filter
     * Client filter
     * Platform filter

     MAIN SECTION: Visual funnel
     ┌─────────────────────────┐
     │ New: 847 (100%)         │ ← Widest
     ├─────────────────────────┤
     │ Contacted: 789 (93%)    │
     ├─────────────────────────┤
     │ Qualified: 612 (72%)    │
     ├─────────────────────────┤
     │ Converted: 278 (33%)    │ ← Narrowest
     └─────────────────────────┘

     - Drop-off indicators between stages
     - Color-coded stages
   ↓
3. USER INTERACTIONS
   │
   ├─→ 3A. CLICK ON STAGE
   │   - User clicks "Qualified (612)"
   │   - Expand to show:
   │     * Average time in stage: 4.8 days
   │     * Conversion rate to next stage: 45%
   │     * Top campaigns contributing
   │     * [View Leads] button
   │
   ├─→ 3B. VIEW LEADS LIST
   │   - User clicks [View Leads]
   │   - Navigate to /leads?stage=qualified
   │   - Show table of all qualified leads
   │   - Columns: Name, Email, Phone, Source, Date, Revenue
   │   - Actions: Sort, Filter, Search, Export
   │
   ├─→ 3C. ANALYZE DROP-OFF
   │   - User hovers on drop-off indicator
   │   - Tooltip shows:
   │     * Number dropped: 177 leads
   │     * Drop-off rate: 22%
   │     * Reason analysis (if available)
   │
   └─→ 3D. FILTER FUNNEL
       - User selects "Google Ads" only
       - Funnel updates to show Google-specific data
       - Numbers change
       - Drop-off rates recalculated

   END: User identifies bottlenecks
```

**Key Screens:**
- `/lead-stage-funnel`
- `/leads` (leads list)

**Key Features:**
- Visual funnel representation
- Clickable stages
- Drop-off analysis
- Time-in-stage metrics
- Filter by source/platform

**Success Criteria:**
- Funnel accurately represents lead flow
- Drop-off calculations correct
- Filtering updates funnel dynamically

---

## Navigation Structure

### Primary Navigation (Sidebar)

```
┌───────────────────────────────────────┐
│ OLIO GLOBAL LEAD ANALYTICS            │
├───────────────────────────────────────┤
│                                       │
│ 📊 REPORTS                            │
│   → Master Summary Dashboard          │
│   → Platform Comparison               │
│   → Lead Stage Funnel                 │
│   → Revenue Attribution               │
│   → Creative Performance              │
│   → Cost Variance                     │
│   → Campaign Performance              │
│                                       │
│ 👥 CLIENTS                            │
│   → All Clients                       │
│   → Client Deep-Dive (dynamic)        │
│                                       │
│ 📤 UPLOAD                             │
│   → Google Ads Data                   │
│   → Meta Ads Data                     │
│   → Leads Data                        │
│   → Upload History                    │
│                                       │
│ ⚙️ SETTINGS (Admin only)              │
│   → User Management                   │
│   → Client Settings                   │
│   → API Configuration                 │
│                                       │
│ 👤 USER MENU (bottom)                 │
│   → Profile                           │
│   → Logout                            │
│                                       │
└───────────────────────────────────────┘
```

### Breadcrumb Navigation

```
Example paths:

Home > Dashboard
Home > Clients > Tech Manufacturing Ltd
Home > Reports > Platform Comparison
Home > Upload > Google Ads > Upload History
```

### URL Structure

```
/                              → Redirects to /dashboard (if logged in) or /login
/login                         → Login page
/dashboard                     → Master Summary Dashboard
/client-deepdive/:client_id    → Client Deep-Dive (e.g., /client-deepdive/CLT001)
/platform-comparison           → Google vs Meta comparison
/lead-stage-funnel             → Lead funnel visualization
/revenue-attribution           → Revenue breakdown
/creative-performance          → Creative analysis
/cost-variance                 → CPL/CPQL variance
/campaign-performance          → Campaign hierarchy
/upload                        → Upload page (default tab: Google Ads)
/upload?tab=meta               → Upload page (Meta Ads tab)
/upload?tab=leads              → Upload page (Leads tab)
/upload?tab=history            → Upload history
/clients                       → Client list
/settings                      → Settings (admin only)
/profile                       → User profile
```

---

## State Diagrams

### Data Loading States

```
┌─────────────────────────────────────────────────────────────┐
│ STATE: Data Loading Lifecycle                                │
└─────────────────────────────────────────────────────────────┘

[IDLE]
  ↓ (User action: View report, Change filter)
[LOADING]
  - Show spinner or skeleton
  - Display "Loading..." message
  - Disable interactions
  ↓
  ├─→ [SUCCESS]
  │   - Display data
  │   - Enable interactions
  │   - Return to IDLE
  │   ↓ (User changes filter)
  │   Return to LOADING
  │
  ├─→ [EMPTY]
  │   - Display empty state
  │   - Show icon and message
  │   - Suggest actions (e.g., "Select different date range")
  │   - Return to IDLE
  │
  └─→ [ERROR]
      - Display error state
      - Show error message
      - Show [Retry] button
      ↓ (User clicks Retry)
      Return to LOADING
```

### Upload States

```
┌─────────────────────────────────────────────────────────────┐
│ STATE: File Upload Lifecycle                                 │
└─────────────────────────────────────────────────────────────┘

[READY]
  - Show upload zone
  - Enable file selection
  ↓ (User selects file)
[FILE_SELECTED]
  - Display file name, size
  - Show [Upload] [Cancel] buttons
  ↓ (User clicks Upload)
[UPLOADING]
  - Show progress bar (0-30%)
  - Disable other actions
  ↓
[VALIDATING]
  - Show progress bar (30-70%)
  - Message: "Validating data..."
  ↓
[PROCESSING]
  - Show progress bar (70-100%)
  - Message: "Importing data..."
  ↓
  ├─→ [SUCCESS]
  │   - Show success message
  │   - Display summary
  │   - Show [View Reports] [Upload More] buttons
  │   → Return to READY (if Upload More)
  │
  ├─→ [PARTIAL_SUCCESS]
  │   - Show warning message
  │   - Display errors table
  │   - Show [Download Error Report] button
  │   → Return to READY
  │
  └─→ [ERROR]
      - Show error message
      - Display error details
      - Show [Try Again] button
      → Return to READY
```

### Authentication States

```
┌─────────────────────────────────────────────────────────────┐
│ STATE: Authentication Lifecycle                              │
└─────────────────────────────────────────────────────────────┘

[LOGGED_OUT]
  - Show login page
  - Store intended destination (if deep link)
  ↓ (User submits credentials)
[AUTHENTICATING]
  - Show loading spinner
  - Disable login button
  ↓
  ├─→ [AUTHENTICATED]
  │   - Store JWT token
  │   - Fetch user profile
  │   - Redirect to intended destination or /dashboard
  │   ↓ (Session active)
  │   [ACTIVE_SESSION]
  │   - User can access all pages
  │   - Token refreshed automatically
  │   ↓ (Token expires or user logs out)
  │   Return to LOGGED_OUT
  │
  └─→ [AUTH_FAILED]
      - Show error message
      - Clear password field
      - Return to LOGGED_OUT
```

---

## Common Patterns

### Filter Pattern

**Steps:**
1. User opens filter dropdown/panel
2. User selects filter option(s)
3. User clicks [Apply] or filter applies automatically
4. System shows loading indicator
5. Data refreshes with filtered results
6. User can see active filters (with clear/remove option)

### Sort Pattern

**Steps:**
1. User clicks table column header
2. Column header shows sort icon (↑ or ↓)
3. Table re-renders with sorted data (instant, no API call if data in memory)
4. Click again to reverse sort direction
5. Click third time to remove sort

### Search Pattern

**Steps:**
1. User types in search box
2. Debounce 300ms (wait for typing to stop)
3. Filter results in real-time
4. Highlight matching text (optional)
5. Show "No results found" if no matches
6. Clear button (X) appears when text entered

### Drill-Down Pattern

**Steps:**
1. User clicks expandable row icon (chevron)
2. Icon rotates 180° (animation)
3. Child rows slide in (expand animation)
4. Child data loads (if not already loaded)
5. Click again to collapse (reverse animation)

### Export Pattern

**Steps:**
1. User clicks [Export] button
2. Modal opens with export options:
   - Format: Excel / PDF / CSV
   - Date range: Confirm or modify
   - Filters: Show active filters
3. User clicks [Export]
4. Button shows loading spinner
5. File generates on server
6. Browser downloads file automatically
7. Success message: "Report exported successfully"

---

**End of User Flows Documentation**

For component implementation, see `COMPONENTS.md`.
For API endpoints, see `API_DOCUMENTATION.md`.
For HTML prototypes, see `HTML Files/` folder.
