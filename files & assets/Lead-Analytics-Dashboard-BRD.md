# Business Requirements Document (BRD)
## Multi-Client Lead Tracking & Performance Analytics Dashboard

**Document Version:** 1.0  
**Date:** November 11, 2025  
**Project Owner:** Olio Global AdTech  
**Document Type:** Business Requirements Document

---

## Executive Summary

Olio Global AdTech is building a comprehensive lead tracking and performance analytics dashboard to manage multiple client campaigns across Google Ads and Meta Ads platforms. The system will connect advertising performance data with lead quality outcomes and revenue attribution, enabling data-driven optimization of client campaigns based on qualified lead generation rather than vanity metrics.

The product will be developed in three phases, with Phase 1 focusing on manual data uploads and pre-built reports for internal agency use.

---

## 1. Business Objectives

### Primary Goals
1. **Centralize multi-client campaign data** from Google Ads and Meta Ads into a single analytics platform
2. **Track lead quality as the primary success metric** (Qualified vs Junk leads) across all campaigns
3. **Enable cost efficiency analysis** by calculating true Cost Per Qualified Lead (CPQL) across platforms
4. **Attribute revenue back to specific campaigns** to measure actual ROI beyond vanity metrics
5. **Simplify reporting** with pre-built reports covering all critical dimensions for both technical and non-technical users

### Success Criteria
- Reduce time spent on manual reporting by 70%
- Identify top-performing campaigns by qualified lead generation within 5 minutes
- Enable platform comparison (Google vs Meta) across all key metrics
- Track revenue attribution at campaign level automatically

---

## 2. Product Vision & Scope

### What This Product IS
- A **lead tracking and performance analytics dashboard** for digital marketing agencies
- A **campaign performance analyzer** that connects ad spend to lead quality to revenue
- A **multi-dimensional reporting tool** that slices data by source, campaign, creative, location, service, qualification status
- A **simple, user-friendly interface** accessible to both technical and non-technical team members

### What This Product IS NOT
- A CRM system (Phase 1 & 2)
- An ad management/optimization tool
- A lead generation tool
- A data storage platform (uses existing Google Sheets/uploads)

---

## 3. Development Phases

### Phase 1: MVP - Manual Upload + Pre-built Reports (CURRENT FOCUS)
**Timeline:** 3-4 months  
**Core Features:**
- Manual CSV/Excel upload for Google Ads, Meta Ads, and Lead data
- 10-15 pre-built standard reports covering all dimensions
- Date range filtering
- Platform comparison (Google vs Meta)
- Lead quality tracking (Qualified vs Junk)
- Revenue attribution to campaigns
- Creative type identification via naming convention
- Dynamic qualification field mapping (reads columns from uploaded sheet)
- Internal agency use only

### Phase 2: Automation + Custom Reports
**Timeline:** 6 months post-Phase 1  
**Core Features:**
- API integration for automated daily/hourly sync from Google Ads & Meta Ads
- Report builder with drag-drop dimensions and metrics
- Enhanced filtering and drill-down capabilities
- Automated alerts for performance anomalies

### Phase 3: Advanced CRM + Multi-tenant
**Timeline:** 12 months post-Phase 2  
**Core Features:**
- Hybrid system (API for ad data + manual lead status updates like a CRM)
- Configuration page for custom qualification fields per client
- User access & permissions (agency vs client access)
- White-label reporting for client delivery
- Advanced predictive analytics

---

## 4. User Personas

### Primary User: Agency Performance Manager
**Profile:** 
- Role: Campaign manager handling 4-10 client accounts
- Tech Savvy: Moderate (comfortable with Excel, Google Sheets, basic analytics)
- Goals: Quickly assess campaign performance, identify underperforming campaigns, justify budget allocation to clients
- Pain Points: Manual data compilation, difficulty comparing platforms, lead quality tracking is manual

### Secondary User: Agency Leadership
**Profile:**
- Role: Founder/Director reviewing overall agency performance
- Tech Savvy: Low to Moderate
- Goals: High-level overview of all clients, identify revenue-driving campaigns, portfolio health check
- Pain Points: No consolidated view across clients, decisions based on incomplete data

### Tertiary User: Account Executive
**Profile:**
- Role: Client-facing team member preparing reports
- Tech Savvy: Low
- Goals: Generate professional client reports quickly, answer client questions about performance
- Pain Points: Complex data visualization, time-consuming report creation

---

## 5. Functional Requirements - PHASE 1

### 5.1 Data Upload Module

#### 5.1.1 Google Ads Data Upload
**Requirement ID:** FR-001  
**Description:** System shall allow users to upload Google Ads performance data via CSV/Excel

**Required Fields:**
- Date (format: YYYY-MM-DD)
- Campaign Name
- Campaign ID
- Ad Group Name
- Ad Group ID
- Ad Name/Creative
- Ad ID
- Keyword
- Location (Country, State, City)
- Landing Page URL
- Ad Type (Search/YouTube/Display)
- Spend (Cost)
- Impressions
- Clicks
- Conversions
- CTR
- CPC
- CPL (calculated if not provided)

**Acceptance Criteria:**
- System accepts .csv, .xlsx, .xls formats
- System validates all required fields are present
- System shows error message for missing/incorrect data
- System displays upload summary (rows imported, errors found)
- System allows re-upload to replace data

---

#### 5.1.2 Meta Ads Data Upload
**Requirement ID:** FR-002  
**Description:** System shall allow users to upload Meta Ads (Facebook/Instagram) performance data via CSV/Excel

**Required Fields:**
- Date (format: YYYY-MM-DD)
- Campaign Name
- Campaign ID
- AdSet Name
- AdSet ID
- Ad Name/Creative
- Ad ID
- Form ID
- Platform (Facebook/Instagram)
- Placement (Feed/Stories)
- Region/State
- Landing Page URL
- Creative Type (Static/Video) - identified from ad name
- Spend (Cost)
- Impressions
- Clicks
- Conversions
- CTR
- CPC
- CPL (calculated if not provided)

**Acceptance Criteria:**
- Same as FR-001
- System identifies creative type from naming convention (e.g., "video_" prefix = Video)

---

#### 5.1.3 Lead Data Upload
**Requirement ID:** FR-003  
**Description:** System shall allow users to upload lead data with status tracking and revenue attribution

**Required Fields (Standard):**
- Lead Date (format: YYYY-MM-DD)
- Lead Name
- Email
- Phone
- City
- Source (Google Search/YouTube/Display/Meta-FB/Meta-Insta)
- UTM URL (full URL with parameters)
- Campaign ID (extracted from UTM)
- Ad Group ID/AdSet ID (extracted from UTM)
- Keyword (if applicable)
- Interested Service/Product
- Lead Stage (New/Contacted/Qualified/Junk/Converted/Lost)
- Lead Sub-Stage (custom per client)
- Follow-up Date
- Revenue Generated (₹)
- Remarks/Notes

**Dynamic Fields (Phase 1):**
- System shall read ANY additional columns present in the uploaded sheet
- These columns become available as "Custom Qualification Fields" in reports
- Examples: Budget Range, Timeline, Company Size, Industry, etc.

**Acceptance Criteria:**
- System extracts Campaign ID and Ad Group ID from UTM URL automatically
- System matches leads to campaign data using Campaign ID
- System calculates CPQL (Cost Per Qualified Lead) based on "Qualified" status
- System allows partial data upload (not all fields mandatory except Lead Date, Source, Lead Stage)

---

### 5.2 Date Range Filtering

**Requirement ID:** FR-004  
**Description:** All reports shall include date range selection capability

**Features:**
- Calendar widget for "From Date" and "To Date" selection
- Quick filters: Today, Yesterday, Last 7 Days, Last 30 Days, This Month, Last Month, Custom Range
- Selected date range applies to ALL data (Ads + Leads)
- Date range persists across report navigation within session

**Acceptance Criteria:**
- Maximum date range: 2 years
- System displays selected date range prominently in all reports
- Data refreshes automatically when date range changes

---

### 5.3 Pre-built Standard Reports

#### 5.3.1 Master Summary Dashboard
**Requirement ID:** FR-005  
**Description:** Executive overview showing aggregated performance across all clients

**KPIs Displayed:**
1. Total Ad Spend (₹)
2. Total Leads Generated
3. Total Qualified Leads
4. Overall Qualification Rate (%)
5. Average CPL (₹)
6. Average CPQL (₹)
7. Total Revenue Generated (₹)
8. Overall ROI (%)

**Visualizations:**
1. Lead Quality by Platform (Stacked Bar: Qualified vs Junk for Google vs Meta)
2. Cost Efficiency Comparison (Bar Chart: CPL vs CPQL for Google vs Meta)
3. Lead Volume by Client (Grouped Bar: Google vs Meta leads per client)
4. Qualification Rate Trend (Line Chart: % over time)
5. Revenue Attribution by Platform (Pie Chart)

**Data Table:**
- Client-wise performance summary with columns:
  - Client Name
  - Total Spend
  - Total Leads
  - Qualified Leads
  - Junk Leads
  - Qualification Rate (%)
  - CPL (₹)
  - CPQL (₹)
  - Revenue (₹)
  - ROI (%)
  - Best Performing Platform

**Acceptance Criteria:**
- All data aggregates correctly across clients
- Clicking on a client row navigates to Client Deep-Dive report
- Export to Excel/PDF functionality available

---

#### 5.3.2 Client Deep-Dive Report
**Requirement ID:** FR-006  
**Description:** Detailed performance analysis for a single selected client

**Selection Method:**
- Dropdown to select client
- Alternatively, clicking from Master Summary

**KPIs Displayed:**
1. Client Total Spend (Google + Meta breakdown)
2. Total Leads (Google + Meta breakdown)
3. Qualified Leads (Google + Meta breakdown)
4. Revenue Generated
5. ROI (%)
6. Average CPL by Platform
7. Average CPQL by Platform

**Visualizations:**
1. Lead Quality Breakdown (Stacked Bar: Qualified/Junk per platform)
2. Platform Cost Comparison (Bar: CPL vs CPQL)
3. Campaign Performance (Table with all campaigns)
4. Lead Stage Funnel (Funnel chart showing progression)
5. Revenue Timeline (Line chart: cumulative revenue over selected date range)

**Data Table: Campaign Performance**
Columns:
- Campaign Name
- Platform
- Spend (₹)
- Impressions
- Clicks
- CTR (%)
- CPC (₹)
- Conversions
- CPL (₹)
- Qualified Leads
- CPQL (₹)
- Revenue (₹)
- ROI (%)

**Acceptance Criteria:**
- Data filters to selected client only
- Can drill down to AdGroup/AdSet level by clicking campaign
- Shows "No Data" message if client has no data in selected date range

---

#### 5.3.3 Source-wise Performance Report
**Requirement ID:** FR-007  
**Description:** Compare performance across all traffic sources

**Sources Tracked:**
- Google Search
- Google YouTube
- Google Display
- Meta Facebook
- Meta Instagram

**Metrics per Source:**
- Spend (₹)
- Impressions
- Clicks
- CTR (%)
- CPC (₹)
- Total Leads
- Qualified Leads
- Qualification Rate (%)
- CPL (₹)
- CPQL (₹)
- Revenue (₹)
- ROI (%)

**Visualizations:**
1. Source Comparison Matrix (Heatmap showing CPQL by source)
2. Lead Volume by Source (Bar Chart)
3. Qualification Rate by Source (Bar Chart)
4. ROI by Source (Bar Chart - sorted)

**Acceptance Criteria:**
- Sources with zero data show as "No Data" instead of ₹0
- Sorting capability on all columns
- Highlight best and worst performing source automatically

---

#### 5.3.4 Campaign-Level Performance Report
**Requirement ID:** FR-008  
**Description:** Detailed performance of campaigns across all clients with drill-down capability

**Hierarchy:**
Campaign → AdSet/AdGroup → Ad/Creative

**Data Table Structure:**
Main View (Campaign Level):
- Campaign Name
- Client Name
- Platform
- Date Range
- Spend
- Impressions
- Clicks
- CTR
- CPC
- Leads
- Qualified Leads
- Qualification Rate
- CPL
- CPQL
- Revenue
- ROI

**Drill-Down Level 1 (AdSet/AdGroup):**
Clicking campaign expands to show all AdSets/AdGroups with same metrics

**Drill-Down Level 2 (Ad/Creative):**
Clicking AdSet/AdGroup expands to show individual ads with same metrics

**Acceptance Criteria:**
- Expandable/collapsible rows for drill-down
- Subtotals calculate correctly at each level
- Export maintains hierarchy structure
- Search/filter functionality across campaign names

---

#### 5.3.5 Creative Performance Report
**Requirement ID:** FR-009  
**Description:** Analyze performance based on creative type (Static vs Video)

**Creative Type Identification:**
- Primary: From ad name using naming convention
  - Contains "video", "vid", "reel", "yt" → Video
  - Contains "static", "image", "carousel" → Static
  - Default: Static (if no identifier)
- Future (Phase 2): Detect from platform API data

**Metrics by Creative Type:**
- Count of Creatives
- Total Spend
- Impressions
- Clicks
- CTR
- Total Leads
- Qualified Leads
- Qualification Rate
- CPQL
- Revenue
- ROI

**Visualizations:**
1. Static vs Video Performance Comparison (Side-by-side bars)
2. Creative Type Distribution by Platform (Stacked bar)
3. Top 10 Best Performing Creatives (by CPQL)
4. Top 10 Worst Performing Creatives (by CPQL)

**Acceptance Criteria:**
- Correctly identifies creative type from naming convention
- Handles mixed-case names
- Shows warning if creative type cannot be determined

---

#### 5.3.6 Landing Page Performance Report
**Requirement ID:** FR-010  
**Description:** Evaluate performance of different landing pages

**Metrics per Landing Page:**
- URL
- Total Visits (sum of clicks)
- Conversions (leads generated)
- Conversion Rate (%)
- Qualified Leads
- Qualification Rate (%)
- Total Spend on campaigns using this LP
- CPL
- CPQL
- Revenue
- ROI

**Visualizations:**
1. Top 10 Landing Pages by Conversion Rate
2. Top 10 Landing Pages by Qualification Rate
3. Landing Page Performance Matrix (Conversion Rate vs Qualification Rate scatter plot)

**Acceptance Criteria:**
- Normalizes URLs (removes UTM parameters for grouping)
- Handles both shortened and full URLs
- Shows full URL on hover

---

#### 5.3.7 Keyword Performance Report
**Requirement ID:** FR-011  
**Description:** Analyze performance of keywords (Google Ads specific)

**Metrics per Keyword:**
- Keyword
- Match Type (if available in data)
- Campaign Name
- Spend
- Impressions
- Clicks
- CTR
- CPC
- Conversions
- CPL
- Qualified Leads
- CPQL
- Revenue
- ROI

**Visualizations:**
1. Top 20 Keywords by CPQL (ascending)
2. Top 20 Keywords by Revenue (descending)
3. Keyword Performance Matrix (Clicks vs Qualification Rate)

**Search Functionality:**
- Search keywords by text
- Filter by campaign
- Filter by match type

**Acceptance Criteria:**
- Shows "N/A" for Meta Ads data (keyword not applicable)
- Case-insensitive keyword matching
- Handles keyword variations (plural, etc.)

---

#### 5.3.8 Lead Stage Funnel Report
**Requirement ID:** FR-012  
**Description:** Track lead progression through stages

**Stages (Standard):**
1. New (Lead received)
2. Contacted (First touch made)
3. Qualified (Meets criteria)
4. Junk (Does not meet criteria)
5. Converted (Revenue generated)
6. Lost (Opportunity lost)

**Sub-Stages:**
- Dynamic per client (reads from uploaded data)
- Example: Qualified → Demo Scheduled → Proposal Sent → Negotiation

**Metrics:**
- Count of leads at each stage
- Conversion rate between stages (%)
- Average time at each stage (days)
- Drop-off rate (%)

**Visualizations:**
1. Funnel Chart (New → Contacted → Qualified → Converted)
2. Stage-wise Lead Count (Bar chart)
3. Average Time by Stage (Bar chart)

**Filters:**
- By Client
- By Platform
- By Source
- By Date Range

**Acceptance Criteria:**
- Funnel calculates percentages correctly
- Handles custom sub-stages dynamically
- Shows conversion velocity (speed of progression)

---

#### 5.3.9 Service/Product-wise Performance Report
**Requirement ID:** FR-013  
**Description:** Break down performance by service or product interest

**Metrics per Service/Product:**
- Service/Product Name
- Total Leads
- Qualified Leads
- Qualification Rate (%)
- Total Spend (campaigns targeting this service)
- CPQL
- Revenue
- ROI

**Visualizations:**
1. Service/Product Lead Distribution (Pie chart)
2. Service/Product Qualification Rates (Bar chart)
3. Service/Product ROI Comparison (Bar chart)

**Acceptance Criteria:**
- Maps service/product from lead data
- Handles multiple services per lead (if applicable)
- Sorts by user-selected metric

---

#### 5.3.10 Location-wise Performance Report
**Requirement ID:** FR-014  
**Description:** Analyze performance by geographic location (Country → State → City)

**Hierarchy Drill-Down:**
Level 1: Country
Level 2: State/Region
Level 3: City

**Metrics per Location:**
- Location Name
- Total Spend
- Impressions
- Clicks
- Leads
- Qualified Leads
- Qualification Rate (%)
- CPL
- CPQL
- Revenue
- ROI

**Visualizations:**
1. Geographic Heatmap (by CPQL or Revenue)
2. Top 10 Locations by Lead Volume
3. Top 10 Locations by Qualification Rate

**Acceptance Criteria:**
- Handles location data from both ad platforms and lead data
- Normalizes location names (e.g., "Mumbai" and "Bombay" → Mumbai)
- Shows "Unknown" for missing location data

---

#### 5.3.11 Qualification-wise Performance Report
**Requirement ID:** FR-015  
**Description:** Analyze performance based on custom qualification attributes (dynamic fields)

**Dynamic Nature:**
- System reads ALL columns from lead upload sheet
- Identifies columns that are not standard fields
- Makes these available as "Qualification Dimensions"

**Example Use Cases:**
- Client A: Analyze by Budget Range (Low/Medium/High)
- Client B: Analyze by Company Size (SMB/Mid-Market/Enterprise)
- Client C: Analyze by Timeline (Immediate/1-3 months/3+ months)

**Metrics per Qualification Attribute:**
- Attribute Value
- Lead Count
- Conversion Rate (%)
- Revenue
- Average Deal Size

**Visualizations:**
1. Attribute Distribution (Pie chart)
2. Conversion Rate by Attribute (Bar chart)
3. Revenue by Attribute (Bar chart)

**Acceptance Criteria:**
- Automatically detects custom columns in lead data
- Allows selection of which attribute to analyze
- Handles multiple values per lead (comma-separated)
- Shows "Not Specified" for blank values

---

#### 5.3.12 Platform Comparison Report
**Requirement ID:** FR-016  
**Description:** Side-by-side comparison of Google Ads vs Meta Ads performance

**Comparison Metrics:**
- Total Spend
- Total Impressions
- Total Clicks
- Average CTR
- Average CPC
- Total Leads
- Qualified Leads
- Qualification Rate
- CPL
- CPQL
- Revenue
- ROI

**Visualizations:**
1. Head-to-Head Metrics (Side-by-side bar charts for each metric)
2. Platform Efficiency Score (Radar chart comparing normalized metrics)
3. Cost Breakdown (Pie chart: spend distribution)
4. Revenue Attribution (Pie chart: revenue distribution)

**Filters:**
- By Client
- By Date Range

**Acceptance Criteria:**
- Shows percentage difference between platforms for each metric
- Highlights which platform is winning for each metric
- Shows statistical significance if data volume permits

---

#### 5.3.13 Cost Variance Analysis Report
**Requirement ID:** FR-017  
**Description:** Track CPL and CPQL variance over time

**Metrics Tracked:**
- CPL by Week/Month
- CPQL by Week/Month
- Variance from previous period (%)
- Trend direction (↑ ↓ →)

**Visualizations:**
1. CPL Trend Over Time (Line chart with Google vs Meta)
2. CPQL Trend Over Time (Line chart with Google vs Meta)
3. Variance Heatmap (Week-by-week change percentage)

**Alerts (Phase 1 - Visual Only):**
- Highlight weeks where CPL increased >20%
- Highlight weeks where CPQL increased >20%

**Acceptance Criteria:**
- Calculates variance correctly
- Handles missing weeks (shows gap instead of connecting line)
- Export with variance annotations

---

#### 5.3.14 Revenue Attribution Report
**Requirement ID:** FR-018  
**Description:** Track revenue back to specific campaigns, ads, and sources

**Attribution Model (Phase 1):**
- Last-Click Attribution (revenue credited to campaign that generated the lead)

**Hierarchy:**
Source → Campaign → AdSet/AdGroup → Ad

**Metrics at Each Level:**
- Total Revenue (₹)
- Number of Converted Leads
- Average Deal Size (₹)
- Revenue per Spend (ROAS)
- ROI (%)

**Visualizations:**
1. Revenue Waterfall (from total down to top campaigns)
2. Top 10 Revenue-Generating Campaigns
3. Revenue Timeline (Cumulative over date range)
4. Revenue by Source (Pie chart)

**Acceptance Criteria:**
- Revenue sums correctly at each hierarchy level
- Handles leads with zero revenue
- Shows pending revenue (leads in pipeline with expected value if available)

---

#### 5.3.15 Client Executive Summary
**Requirement ID:** FR-019  
**Description:** Professional one-page summary for client reporting

**Content:**
- Client Logo/Name
- Date Range
- Executive KPIs (4-6 key metrics with visual indicators)
- Key Insights (3-5 bullet points auto-generated)
- Platform Performance Comparison (visual)
- Top Performing Campaigns (top 3)
- Recommendations (3-5 action items)

**Format:**
- Clean, professional design
- Print-friendly
- Exportable as PDF

**Acceptance Criteria:**
- Generates automatically for selected client
- Insights are data-driven (not generic)
- Can be customized before export (Phase 2)

---

### 5.4 Common Report Features

**Requirement ID:** FR-020  
**Description:** Features available across all reports

**Export Options:**
- Export to Excel (.xlsx)
- Export to PDF
- Export to Google Sheets (creates new sheet with data)

**Sorting & Filtering:**
- All data tables sortable by clicking column headers
- Multi-column sorting (hold Shift + click)
- Quick filters for common dimensions (Client, Platform, Source)

**Search:**
- Global search box to find campaigns, clients, keywords
- Search within individual reports

**Visualization Interactions:**
- Hover for detailed tooltips
- Click to drill-down (where applicable)
- Legend toggle (click to show/hide data series)

**Mobile Responsiveness:**
- All reports viewable on tablet devices
- Touch-friendly interactions
- Simplified layout for smaller screens

**Acceptance Criteria:**
- Export maintains formatting and data accuracy
- Sorting handles numeric and text correctly
- Search is case-insensitive
- Mobile view loads within 3 seconds

---

## 6. Non-Functional Requirements

### 6.1 Performance
- Dashboard loads within 3 seconds for datasets up to 100,000 rows
- Report generation completes within 5 seconds
- CSV upload processes at minimum 10,000 rows per second
- Concurrent users supported: 10 (Phase 1)

### 6.2 Usability
- Interface usable by non-technical users with zero training
- All reports accessible within 3 clicks from home
- Consistent design language across all screens
- Helpful error messages (not technical jargon)

### 6.3 Data Accuracy
- All calculations verified against source data (±0 tolerance)
- Date range filtering excludes data outside range (no leakage)
- Revenue attribution verified at lead level
- No duplicate lead counting

### 6.4 Security (Phase 1 - Basic)
- Password-protected access
- Session timeout after 30 minutes of inactivity
- No data stored in browser cache
- HTTPS encryption for all data transmission

### 6.5 Browser Compatibility
- Chrome (latest version) - Primary
- Firefox (latest version)
- Safari (latest version)
- Edge (latest version)

### 6.6 Data Retention
- Uploaded data retained for 2 years
- Option to purge client data on request
- Backup taken daily (stored for 30 days)

---

## 7. Data Model & Structure

### 7.1 Core Entities

#### Entity: Client
Fields:
- Client ID (Auto-generated)
- Client Name
- Industry
- Date Added
- Status (Active/Inactive)

#### Entity: Campaign
Fields:
- Campaign ID (from platform)
- Campaign Name
- Client ID (FK)
- Platform (Google/Meta)
- Campaign Type (Search/Display/YouTube/Facebook/Instagram)
- Date Created
- Status (Active/Paused/Ended)

#### Entity: AdSet/AdGroup
Fields:
- AdSet ID (from platform)
- AdSet Name
- Campaign ID (FK)
- Platform
- Targeting Details (JSON - location, demographics, etc.)
- Status

#### Entity: Ad/Creative
Fields:
- Ad ID (from platform)
- Ad Name
- AdSet ID (FK)
- Creative Type (Static/Video)
- Ad Copy
- Landing Page URL
- Status

#### Entity: Performance (Daily metrics)
Fields:
- Date
- Ad ID (FK)
- Spend
- Impressions
- Clicks
- Conversions
- CTR
- CPC
- CPL

#### Entity: Lead
Fields:
- Lead ID (Auto-generated)
- Lead Date
- Client ID (FK)
- Campaign ID (FK)
- AdSet ID (FK)
- Ad ID (FK)
- Name
- Email
- Phone
- City
- Source
- UTM URL
- Keyword
- Service/Product Interest
- Lead Stage
- Lead Sub-Stage
- Qualification Status (Qualified/Junk/Pending)
- Follow-up Date
- Revenue Generated
- Remarks
- Custom Fields (JSON - stores dynamic qualification attributes)
- Date Created
- Last Updated

---

### 7.2 Data Relationships
```
Client (1) ----< (Many) Campaign
Campaign (1) ----< (Many) AdSet/AdGroup
AdSet/AdGroup (1) ----< (Many) Ad/Creative
Ad/Creative (1) ----< (Many) Performance (Daily)
Ad/Creative (1) ----< (Many) Lead

Client (1) ----< (Many) Lead
```

---

### 7.3 Calculated Fields

**CPL (Cost Per Lead):**
```
CPL = Total Spend / Total Leads
```

**CPQL (Cost Per Qualified Lead):**
```
CPQL = Total Spend / Total Qualified Leads
Where Qualified Leads = Leads with Qualification Status = "Qualified"
```

**CTR (Click-Through Rate):**
```
CTR = (Clicks / Impressions) × 100
```

**CPC (Cost Per Click):**
```
CPC = Total Spend / Total Clicks
```

**Qualification Rate:**
```
Qualification Rate = (Qualified Leads / Total Leads) × 100
```

**ROI (Return on Investment):**
```
ROI = ((Revenue - Total Spend) / Total Spend) × 100
```

**ROAS (Return on Ad Spend):**
```
ROAS = Revenue / Total Spend
```

**Conversion Rate (Click to Lead):**
```
Conversion Rate = (Leads / Clicks) × 100
```

---

## 8. User Interface & Experience

### 8.1 Navigation Structure

```
Home Dashboard (Master Summary)
│
├── Reports
│   ├── Client Deep-Dive
│   ├── Source Performance
│   ├── Campaign Performance
│   ├── Creative Performance
│   ├── Landing Page Performance
│   ├── Keyword Performance
│   ├── Lead Stage Funnel
│   ├── Service/Product Performance
│   ├── Location Performance
│   ├── Qualification Analysis
│   ├── Platform Comparison
│   ├── Cost Variance Analysis
│   ├── Revenue Attribution
│   └── Client Executive Summary
│
├── Data Upload
│   ├── Google Ads Upload
│   ├── Meta Ads Upload
│   └── Lead Data Upload
│
└── Settings (Phase 1 - Basic)
    ├── User Profile
    └── Help/Documentation
```

### 8.2 Design Principles

**Simplicity First:**
- Clean, uncluttered layouts
- Maximum 3 primary actions per screen
- Progressive disclosure (advanced options hidden initially)

**Visual Hierarchy:**
- Most important metrics at top (KPI cards)
- Visualizations in middle (charts)
- Detailed tables at bottom

**Consistency:**
- Same color codes across all reports:
  - Google Ads: Blue (#4285F4)
  - Meta Ads: Blue (#1877F2)
  - Qualified: Green (#34A853)
  - Junk: Red (#EA4335)
  - Pending: Yellow (#FBBC04)
- Same layout pattern for all reports
- Same export options in same location

**Feedback:**
- Loading spinners for all async operations
- Success messages for uploads
- Error messages with actionable guidance
- Confirmation dialogs for destructive actions

**Accessibility:**
- Minimum font size: 14px
- High contrast ratios (WCAG AA compliant)
- Keyboard navigation support
- Screen reader friendly

---

### 8.3 Color Palette

**Primary Colors:**
- Primary Brand: #667EEA (Purple)
- Google Ads: #4285F4 (Blue)
- Meta Ads: #1877F2 (Blue)

**Status Colors:**
- Success/Qualified: #34A853 (Green)
- Warning/Pending: #FBBC04 (Yellow)
- Error/Junk: #EA4335 (Red)
- Info: #4285F4 (Blue)

**Neutral Colors:**
- Dark Text: #333333
- Medium Text: #666666
- Light Text: #999999
- Background: #F5F7FA
- White: #FFFFFF
- Border: #E0E0E0

---

### 8.4 Typography

**Font Family:** 
- Primary: 'Segoe UI', Roboto, sans-serif
- Monospace (for numbers): 'Roboto Mono', monospace

**Font Sizes:**
- H1 (Page Title): 32px, Bold
- H2 (Section Title): 24px, Semi-Bold
- H3 (Card Title): 18px, Semi-Bold
- Body Text: 14px, Regular
- Small Text: 12px, Regular
- KPI Value: 36px, Bold

---

## 9. Technical Architecture (High-Level - Phase 1)

### 9.1 Technology Stack

**Frontend:**
- React.js (v18+) with TypeScript
- Chart.js or Recharts for visualizations
- TailwindCSS for styling
- React Router for navigation
- Axios for API calls

**Backend:**
- Node.js with Express.js
- PostgreSQL database
- RESTful API architecture
- JWT authentication

**File Processing:**
- Papa Parse (CSV parsing)
- XLSX.js (Excel file handling)
- Server-side validation

**Hosting:**
- Frontend: Vercel/Netlify
- Backend: AWS EC2 or DigitalOcean
- Database: AWS RDS PostgreSQL

---

### 9.2 API Endpoints (Phase 1)

#### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout

#### Upload
- `POST /api/upload/google-ads` - Upload Google Ads data
- `POST /api/upload/meta-ads` - Upload Meta Ads data
- `POST /api/upload/leads` - Upload lead data
- `GET /api/upload/history` - View upload history

#### Reports
- `GET /api/reports/master-summary?from=YYYY-MM-DD&to=YYYY-MM-DD` - Master dashboard data
- `GET /api/reports/client-deepdive/:clientId?from=YYYY-MM-DD&to=YYYY-MM-DD` - Client report
- `GET /api/reports/source-performance?from=YYYY-MM-DD&to=YYYY-MM-DD` - Source report
- `GET /api/reports/campaign-performance?clientId=X&from=YYYY-MM-DD&to=YYYY-MM-DD` - Campaign report
- [Similar pattern for all 15 reports]

#### Data
- `GET /api/clients` - List all clients
- `GET /api/campaigns?clientId=X` - List campaigns for client
- `GET /api/leads?filters={JSON}` - Get leads with filters

#### Export
- `GET /api/export/excel/:reportType?params={JSON}` - Export report to Excel
- `GET /api/export/pdf/:reportType?params={JSON}` - Export report to PDF

---

## 10. Implementation Plan - Phase 1

### Sprint 1 (Weeks 1-2): Foundation
**Deliverables:**
- Database schema design and implementation
- Authentication system
- Basic UI shell and navigation
- File upload infrastructure (backend only)

### Sprint 2 (Weeks 3-4): Data Upload
**Deliverables:**
- Google Ads upload UI + validation
- Meta Ads upload UI + validation
- Lead data upload UI + validation
- Upload history tracking
- Data processing and storage

### Sprint 3 (Weeks 5-6): Core Reports (1-5)
**Deliverables:**
- Master Summary Dashboard (FR-005)
- Client Deep-Dive Report (FR-006)
- Source Performance Report (FR-007)
- Campaign Performance Report (FR-008)
- Creative Performance Report (FR-009)

### Sprint 4 (Weeks 7-8): Core Reports (6-10)
**Deliverables:**
- Landing Page Performance (FR-010)
- Keyword Performance (FR-011)
- Lead Stage Funnel (FR-012)
- Service/Product Performance (FR-013)
- Location Performance (FR-014)

### Sprint 5 (Weeks 9-10): Advanced Reports (11-15)
**Deliverables:**
- Qualification Analysis (FR-015)
- Platform Comparison (FR-016)
- Cost Variance Analysis (FR-017)
- Revenue Attribution (FR-018)
- Client Executive Summary (FR-019)

### Sprint 6 (Weeks 11-12): Polish & Testing
**Deliverables:**
- Export functionality (Excel, PDF)
- Mobile responsive design
- Performance optimization
- User acceptance testing
- Bug fixes
- Documentation

---

## 11. Success Metrics (Phase 1)

### Product Adoption
- 100% of agency team using the dashboard within 2 weeks of launch
- Average 5+ reports viewed per user per day

### Efficiency Gains
- Time to generate client report: < 5 minutes (vs 45 minutes manual)
- Time to identify top-performing campaign: < 2 minutes (vs 20 minutes manual)
- Data entry errors: < 1% (vs 10% with manual sheets)

### Data Quality
- Lead matching accuracy: > 95% (leads correctly attributed to campaigns)
- Revenue attribution accuracy: 100% (verified against CRM)

### User Satisfaction
- System Usability Score: > 80/100
- Zero training required for basic report access
- Positive feedback from 90%+ of users

---

## 12. Risks & Mitigations

### Risk 1: Data Quality Issues
**Description:** Uploaded data may have inconsistencies, missing fields, or formatting issues  
**Impact:** High - Affects all reports and analytics  
**Probability:** High (especially in Phase 1 with manual uploads)  
**Mitigation:**
- Robust validation on upload with clear error messages
- Template files provided for uploads
- Data quality reports highlighting issues
- Ability to re-upload corrected data

### Risk 2: UTM Parameter Inconsistencies
**Description:** Leads may have inconsistent or missing UTM parameters  
**Impact:** Medium - Affects lead attribution accuracy  
**Probability:** Medium  
**Mitigation:**
- Fuzzy matching algorithm for campaign names
- Manual override capability to assign leads to campaigns
- Documentation on UTM best practices
- Phase 2: Automated UTM builder

### Risk 3: Revenue Data Lag
**Description:** Revenue may be reported weeks/months after lead is generated  
**Impact:** Medium - ROI calculations may be delayed  
**Probability:** High  
**Mitigation:**
- Support for revenue data updates (re-upload lead file with revenue)
- "Pending Revenue" indicator in reports
- Historical ROI reports that include lagged revenue

### Risk 4: Creative Type Identification
**Description:** Naming convention may not be followed consistently  
**Impact:** Low - Only affects creative performance report  
**Probability:** Medium  
**Mitigation:**
- Manual tagging column in upload (optional)
- Default to "Static" if cannot determine
- Phase 2: Platform API detection

### Risk 5: Scale & Performance
**Description:** System may slow down with large datasets (100K+ rows)  
**Impact:** Medium - User experience degrades  
**Probability:** Low (not expected in Phase 1)  
**Mitigation:**
- Database indexing on key fields
- Pagination for large tables
- Data archiving strategy (older than 2 years)
- Phase 2: Caching layer

---

## 13. Future Enhancements (Phase 2 & 3)

### Phase 2 Features
- Automated API integration (Google Ads API, Meta Ads API)
- Custom report builder (drag-drop interface)
- Scheduled reports (email delivery)
- Performance alerts (email/SMS when thresholds breached)
- Predictive analytics (forecast CPL, lead volume)
- A/B test tracking for ads
- Multi-currency support

### Phase 3 Features
- Full CRM functionality (lead management within system)
- Client portal (white-labeled access for clients)
- User roles & permissions (Admin, Manager, Viewer, Client)
- Custom qualification field configuration UI
- Advanced attribution models (multi-touch, time-decay)
- Integration with CRM systems (Zoho, HubSpot, Salesforce)
- Mobile app (iOS/Android)
- AI-powered insights and recommendations

---

## 14. Appendices

### Appendix A: Sample Data Formats

#### Google Ads Upload CSV Format
```
Date,Campaign Name,Campaign ID,Ad Group Name,Ad Group ID,Ad Name,Ad ID,Keyword,Location,Landing Page,Ad Type,Spend,Impressions,Clicks,Conversions,CTR,CPC,CPL
2025-11-01,Campaign_Search_001,12345,AdGroup_A,67890,Ad_001,11111,manufacturing services,Mumbai,https://example.com/services,Search,5000,10000,500,25,5.0,10,200
```

#### Meta Ads Upload CSV Format
```
Date,Campaign Name,Campaign ID,AdSet Name,AdSet ID,Ad Name,Ad ID,Form ID,Platform,Placement,Region,Landing Page,Creative Type,Spend,Impressions,Clicks,Conversions,CTR,CPC,CPL
2025-11-01,Campaign_FB_001,23456,AdSet_B,78901,video_Ad_002,22222,form_123,Facebook,Feed,Maharashtra,https://example.com/services,Video,4500,12000,480,24,4.0,9.38,187.5
```

#### Lead Data Upload CSV Format
```
Lead Date,Lead Name,Email,Phone,City,Source,UTM URL,Campaign ID,Ad Group ID,Keyword,Interested Service,Lead Stage,Lead Sub-Stage,Follow-up Date,Revenue Generated,Remarks,Budget Range,Company Size
2025-11-01,John Doe,john@example.com,9876543210,Mumbai,Google Search,https://example.com/services?utm_source=google&utm_campaign=12345&utm_adgroup=67890&utm_term=manufacturing,12345,67890,manufacturing services,Precision Machining,Qualified,Demo Scheduled,2025-11-05,150000,Hot lead,High,Mid-Market
```

---

### Appendix B: Glossary

**CPL (Cost Per Lead):** Total advertising spend divided by total leads generated

**CPQL (Cost Per Qualified Lead):** Total advertising spend divided by qualified leads only

**CTR (Click-Through Rate):** Percentage of impressions that resulted in clicks

**CPC (Cost Per Click):** Average cost paid for each click

**ROAS (Return on Ad Spend):** Revenue generated per rupee spent on advertising

**ROI (Return on Investment):** Net profit as a percentage of total investment

**Qualified Lead:** Lead that meets predefined criteria and has genuine interest (manually marked by team)

**Junk Lead:** Lead that does not meet criteria or has no genuine interest

**Lead Stage:** Current status of lead in the sales pipeline

**UTM Parameters:** Tags added to URLs to track campaign performance

**Attribution:** Process of assigning credit for conversions/revenue to marketing touchpoints

**Creative:** The visual/text content of an advertisement

**Landing Page (LP):** Web page where users land after clicking an ad

---

### Appendix C: Naming Conventions

**Campaign Naming:**
- Format: `[Platform]_[Type]_[Target]_[Month]`
- Example: `Google_Search_Manufacturing_Nov25`

**Creative Naming (for Type Detection):**
- Video: Include "video", "vid", "reel", "yt"
- Static: Include "static", "image", "carousel"
- Example: `video_machining_services_v1`

**File Upload Naming:**
- Google Ads: `ClientName_GoogleAds_YYYY-MM-DD.csv`
- Meta Ads: `ClientName_MetaAds_YYYY-MM-DD.csv`
- Leads: `ClientName_Leads_YYYY-MM-DD.csv`

---

### Appendix D: Error Handling

**Upload Errors:**
- Missing required fields → Specific field names listed
- Invalid date format → Expected format shown (YYYY-MM-DD)
- Negative values → Row number and field indicated
- Duplicate rows → Count shown with option to skip/replace

**Runtime Errors:**
- No data for selected filters → "No data available for the selected criteria"
- Division by zero (e.g., CPL when leads = 0) → Display "N/A"
- Missing revenue data → Show "Pending" instead of ₹0
- API timeout → Retry with exponential backoff

---

## 15. Acceptance Criteria (Phase 1 Complete)

Phase 1 is considered complete when:

1. ✅ All 15 pre-built reports are functional and displaying correct data
2. ✅ Upload functionality works for all three data types (Google Ads, Meta Ads, Leads)
3. ✅ Date range filtering works across all reports
4. ✅ All KPIs calculate correctly (validated against manual calculations)
5. ✅ Export to Excel and PDF works for all reports
6. ✅ Dashboard loads within 3 seconds with 10,000 rows of data
7. ✅ Zero critical bugs in production
8. ✅ User documentation complete
9. ✅ 90% user satisfaction score from internal team
10. ✅ Mobile responsive design passes on iPad

---

## Document Approval

**Prepared by:** Olio Global AdTech Product Team  
**Review Date:** [To be filled]  
**Approved by:** [To be filled]  
**Version:** 1.0  
**Next Review Date:** [After Phase 1 Sprint 3]

---

**END OF DOCUMENT**
