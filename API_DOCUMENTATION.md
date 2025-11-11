# API Documentation

> **Lead Analytics Dashboard - REST API Specification**
> Version 1.0 | Phase 1 MVP

---

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Report Endpoints](#report-endpoints)
4. [Upload Endpoints](#upload-endpoints)
5. [Client Management](#client-management)
6. [Campaign Management](#campaign-management)
7. [Lead Management](#lead-management)
8. [Error Handling](#error-handling)
9. [Rate Limiting](#rate-limiting)

---

## Overview

### Base URL
```
Production: https://api.leadanalytics.olioglobal.com/v1
Staging: https://staging-api.leadanalytics.olioglobal.com/v1
Development: http://localhost:3000/api/v1
```

### Content Type
```
Content-Type: application/json
```

### Date Formats
```
Date: YYYY-MM-DD (ISO 8601)
DateTime: YYYY-MM-DDTHH:mm:ssZ (ISO 8601 with timezone)
```

---

## Authentication

### Login

**Endpoint:** `POST /auth/login`

**Description:** Authenticate user and receive JWT token

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "user_id": "USR001",
    "email": "user@example.com",
    "name": "Agency Manager",
    "role": "admin",
    "permissions": [
      "view_all_clients",
      "upload_data",
      "export_reports"
    ]
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600
}
```

**Response (401 Unauthorized):**
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid credentials"
  }
}
```

### Token Refresh

**Endpoint:** `POST /auth/refresh`

**Headers:**
```
Authorization: Bearer <old_token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600
}
```

### Logout

**Endpoint:** `POST /auth/logout`

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Logout successful"
}
```

---

## Report Endpoints

### 1. Master Summary Dashboard

**Endpoint:** `GET /reports/master-summary`

**Description:** Get aggregated performance metrics across all clients

**Query Parameters:**
```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
platform (optional): 'google' | 'meta' | 'all' (default: 'all')
```

**Example Request:**
```
GET /reports/master-summary?from=2025-10-12&to=2025-11-11&platform=all
```

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "date_range": {
    "from": "2025-10-12",
    "to": "2025-11-11"
  },
  "data": {
    "kpis": {
      "total_spend": 1245000,
      "total_leads": 847,
      "qualified_leads": 612,
      "qualification_rate": 72.3,
      "average_cpl": 1470,
      "average_cpql": 2034,
      "total_revenue": 4567500,
      "overall_roi": 267
    },
    "trends": {
      "spend_change": 12.5,
      "leads_change": 8.3,
      "roi_change": 15.3
    },
    "platform_breakdown": {
      "google_ads": {
        "spend": 720000,
        "leads": 465,
        "qualified": 342,
        "revenue": 2650000
      },
      "meta_ads": {
        "spend": 525000,
        "leads": 382,
        "qualified": 270,
        "revenue": 1917500
      }
    },
    "clients": [
      {
        "client_id": "CLT001",
        "client_name": "Tech Manufacturing Ltd",
        "industry": "Manufacturing",
        "total_spend": 385000,
        "total_leads": 285,
        "qualified_leads": 218,
        "junk_leads": 67,
        "qualification_rate": 76.5,
        "cpl": 1351,
        "cpql": 1766,
        "revenue": 1540000,
        "roi": 300,
        "best_platform": "Google Ads"
      }
    ],
    "charts": {
      "lead_quality_by_platform": {
        "google_ads": {"qualified": 342, "junk": 123},
        "meta_ads": {"qualified": 270, "junk": 112}
      },
      "qualification_trend": {
        "dates": ["2025-10-12", "2025-10-15", "2025-10-18"],
        "rates": [68, 70, 71]
      }
    }
  }
}
```

### 2. Client Deep-Dive Report

**Endpoint:** `GET /reports/client-deepdive/:client_id`

**Description:** Detailed performance analysis for a single client

**Path Parameters:**
```
client_id (required): Client identifier
```

**Query Parameters:**
```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
platform (optional): 'google' | 'meta' | 'all' (default: 'all')
```

**Example Request:**
```
GET /reports/client-deepdive/CLT001?from=2025-10-12&to=2025-11-11
```

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "success": true,
  "client": {
    "client_id": "CLT001",
    "client_name": "Tech Manufacturing Ltd",
    "industry": "Manufacturing",
    "date_created": "2025-01-15",
    "status": "Active",
    "logo_url": null
  },
  "kpis": {
    "total_spend": 385000,
    "spend_breakdown": {
      "google_ads": 230000,
      "meta_ads": 155000
    },
    "total_leads": 285,
    "qualified_leads": 218,
    "qualification_rate": 76.5,
    "revenue": 1540000,
    "roi": 300,
    "avg_cpl": 1351,
    "avg_cpql": 1766
  },
  "funnel": {
    "new": 285,
    "contacted": 268,
    "qualified": 218,
    "converted": 98,
    "lost": 187
  },
  "campaigns": [
    {
      "campaign_id": "CMP001",
      "campaign_name": "Google_Search_Manufacturing_Nov25",
      "platform": "google",
      "spend": 145000,
      "impressions": 55000,
      "clicks": 2890,
      "ctr": 5.2,
      "cpc": 50.17,
      "leads": 95,
      "qualified": 72,
      "qualification_rate": 75.8,
      "cpl": 1526,
      "cpql": 2014,
      "revenue": 620000,
      "roi": 328,
      "status": "Active",
      "adgroups": [
        {
          "adgroup_id": "ADG001",
          "adgroup_name": "Precision Machining Keywords",
          "spend": 80000,
          "clicks": 1560,
          "leads": 52,
          "qualified": 38,
          "cpql": 2105
        }
      ]
    }
  ]
}
```

### 3. Platform Comparison

**Endpoint:** `GET /reports/platform-comparison`

**Description:** Compare Google Ads vs Meta Ads performance

**Query Parameters:**
```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
client_id (optional): Filter by specific client
```

**Example Request:**
```
GET /reports/platform-comparison?from=2025-10-12&to=2025-11-11
```

**Response (200 OK):**
```json
{
  "success": true,
  "google_ads": {
    "total_spend": 720000,
    "total_impressions": 245000,
    "total_clicks": 11760,
    "avg_ctr": 4.8,
    "avg_cpc": 61.22,
    "total_leads": 465,
    "qualified_leads": 342,
    "qualification_rate": 73.5,
    "cpl": 1548,
    "cpql": 2105,
    "revenue": 2650000,
    "roi": 268
  },
  "meta_ads": {
    "total_spend": 525000,
    "total_impressions": 315000,
    "total_clicks": 11655,
    "avg_ctr": 3.7,
    "avg_cpc": 45.05,
    "total_leads": 382,
    "qualified_leads": 270,
    "qualification_rate": 70.7,
    "cpl": 1374,
    "cpql": 1944,
    "revenue": 1917500,
    "roi": 266
  },
  "winner": {
    "overall": "google",
    "by_metric": {
      "cpl": "meta",
      "cpql": "meta",
      "qualification_rate": "google",
      "ctr": "google",
      "revenue": "google",
      "roi": "google"
    }
  }
}
```

### 4. Campaign Performance Report

**Endpoint:** `GET /reports/campaign-performance`

**Description:** Hierarchical campaign → adset/adgroup → ad performance

**Query Parameters:**
```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
client_id (optional): Filter by client
platform (optional): 'google' | 'meta'
campaign_id (optional): Filter by specific campaign
```

**Example Request:**
```
GET /reports/campaign-performance?from=2025-10-12&to=2025-11-11&client_id=CLT001
```

**Response (200 OK):**
```json
{
  "success": true,
  "campaigns": [
    {
      "campaign_id": "CMP001",
      "campaign_name": "Google_Search_Manufacturing_Nov25",
      "platform": "google",
      "spend": 145000,
      "clicks": 2890,
      "leads": 95,
      "qualified": 72,
      "cpl": 1526,
      "cpql": 2014,
      "roi": 328,
      "adgroups": [
        {
          "adgroup_id": "ADG001",
          "adgroup_name": "Precision Machining Keywords",
          "spend": 80000,
          "clicks": 1560,
          "leads": 52,
          "qualified": 38,
          "cpl": 1538,
          "cpql": 2105,
          "ads": [
            {
              "ad_id": "AD001",
              "ad_name": "Ad_Precision_001",
              "spend": 40000,
              "clicks": 800,
              "leads": 28,
              "qualified": 20,
              "cpl": 1429,
              "cpql": 2000
            }
          ]
        }
      ]
    }
  ]
}
```

### 5. Lead Stage Funnel

**Endpoint:** `GET /reports/lead-stage-funnel`

**Description:** Lead progression through stages

**Query Parameters:**
```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
client_id (optional): Filter by client
platform (optional): Filter by platform
```

**Response (200 OK):**
```json
{
  "success": true,
  "funnel": {
    "new": {
      "count": 847,
      "percentage": 100
    },
    "contacted": {
      "count": 789,
      "percentage": 93.2,
      "drop_off": 58
    },
    "qualified": {
      "count": 612,
      "percentage": 72.3,
      "drop_off": 177
    },
    "converted": {
      "count": 278,
      "percentage": 32.8,
      "drop_off": 334
    },
    "lost": {
      "count": 235,
      "percentage": 27.7
    }
  },
  "avg_time_in_stage": {
    "new_to_contacted": 2.5,
    "contacted_to_qualified": 4.8,
    "qualified_to_converted": 12.3
  }
}
```

### 6. Revenue Attribution

**Endpoint:** `GET /reports/revenue-attribution`

**Description:** Revenue breakdown by campaigns and sources

**Query Parameters:**
```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
client_id (optional): Filter by client
```

**Response (200 OK):**
```json
{
  "success": true,
  "total_revenue": 4567500,
  "by_platform": {
    "google_ads": 2650000,
    "meta_ads": 1917500
  },
  "by_campaign": [
    {
      "campaign_id": "CMP001",
      "campaign_name": "Google_Search_Manufacturing_Nov25",
      "revenue": 620000,
      "percentage": 13.6,
      "converted_leads": 28
    }
  ],
  "by_source": {
    "Google Search": 1850000,
    "Google YouTube": 800000,
    "Meta-FB": 1320000,
    "Meta-Insta": 597500
  }
}
```

### 7. Creative Performance

**Endpoint:** `GET /reports/creative-performance`

**Description:** Static vs Video creative comparison

**Query Parameters:**
```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
client_id (optional): Filter by client
platform (optional): 'meta' (only Meta Ads have creative types)
```

**Response (200 OK):**
```json
{
  "success": true,
  "comparison": {
    "video": {
      "total_ads": 45,
      "spend": 285000,
      "impressions": 420000,
      "clicks": 15800,
      "ctr": 3.76,
      "leads": 198,
      "cpl": 1439,
      "qualification_rate": 74.2,
      "performance_score": 87
    },
    "static": {
      "total_ads": 63,
      "spend": 240000,
      "impressions": 380000,
      "clicks": 12400,
      "ctr": 3.26,
      "leads": 184,
      "cpl": 1304,
      "qualification_rate": 67.4,
      "performance_score": 82
    }
  },
  "winner": "video",
  "top_creatives": [
    {
      "ad_id": "AD005",
      "ad_name": "video_Ad_Manufacturing_001",
      "creative_type": "Video",
      "spend": 12500,
      "leads": 18,
      "cpl": 694,
      "roi": 445,
      "performance_score": 95
    }
  ]
}
```

### 8. Cost Variance Report

**Endpoint:** `GET /reports/cost-variance`

**Description:** Week-by-week CPL/CPQL variance analysis

**Query Parameters:**
```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
client_id (optional): Filter by client
metric (optional): 'cpl' | 'cpql' | 'both' (default: 'both')
```

**Response (200 OK):**
```json
{
  "success": true,
  "weekly_data": [
    {
      "week_start": "2025-10-12",
      "week_end": "2025-10-18",
      "cpl": 1420,
      "cpql": 1980,
      "cpl_variance": null,
      "cpql_variance": null,
      "alerts": []
    },
    {
      "week_start": "2025-10-19",
      "week_end": "2025-10-25",
      "cpl": 1580,
      "cpql": 2145,
      "cpl_variance": 11.3,
      "cpql_variance": 8.3,
      "alerts": []
    },
    {
      "week_start": "2025-10-26",
      "week_end": "2025-11-01",
      "cpl": 1890,
      "cpql": 2580,
      "cpl_variance": 19.6,
      "cpql_variance": 20.3,
      "alerts": ["cpql_increase"]
    }
  ],
  "summary": {
    "avg_cpl": 1630,
    "avg_cpql": 2235,
    "max_variance_week": "2025-10-26",
    "total_alerts": 3
  }
}
```

---

## Upload Endpoints

### 1. Upload Google Ads Data

**Endpoint:** `POST /upload/google-ads`

**Description:** Upload Google Ads CSV file

**Headers:**
```
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

**Form Data:**
```
file (required): CSV file
client_id (required): Client identifier
```

**Example Request:**
```bash
curl -X POST https://api.leadanalytics.olioglobal.com/v1/upload/google-ads \
  -H "Authorization: Bearer <token>" \
  -F "file=@GoogleAds_Nov2025.csv" \
  -F "client_id=CLT001"
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Google Ads data uploaded successfully",
  "summary": {
    "rows_imported": 1247,
    "rows_failed": 0,
    "campaigns_found": 15,
    "date_range": {
      "from": "2025-11-01",
      "to": "2025-11-11"
    }
  },
  "errors": [],
  "warnings": [
    {
      "row": 245,
      "field": "keyword",
      "message": "Keyword field empty for display ad, set to N/A"
    }
  ]
}
```

**Response (400 Bad Request - Validation Errors):**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed for uploaded file",
    "count": 2,
    "details": [
      {
        "row": 5,
        "field": "date",
        "value": "2025-13-01",
        "error": "Invalid date format. Expected YYYY-MM-DD",
        "severity": "error"
      },
      {
        "row": 12,
        "field": "spend",
        "value": "-500",
        "error": "Spend cannot be negative",
        "severity": "error"
      }
    ]
  }
}
```

### 2. Upload Meta Ads Data

**Endpoint:** `POST /upload/meta-ads`

**Description:** Upload Meta Ads CSV file

**Headers:**
```
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

**Form Data:**
```
file (required): CSV file
client_id (required): Client identifier
```

**Response:** Same format as Google Ads upload

### 3. Upload Leads Data

**Endpoint:** `POST /upload/leads`

**Description:** Upload leads CSV file with custom field support

**Headers:**
```
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

**Form Data:**
```
file (required): CSV file
client_id (required): Client identifier
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Lead data uploaded successfully",
  "summary": {
    "rows_imported": 285,
    "rows_failed": 3,
    "matched_campaigns": 268,
    "unmatched_campaigns": 17,
    "custom_fields_detected": ["Budget_Range", "Company_Size", "Timeline"]
  },
  "errors": [
    {
      "row": 45,
      "field": "utm_url",
      "message": "Invalid UTM URL format, could not extract campaign_id",
      "severity": "error"
    }
  ],
  "custom_fields": [
    {
      "field_name": "Budget_Range",
      "sample_values": ["Low", "Medium", "High"],
      "unique_values": 3
    }
  ]
}
```

### 4. Get Upload History

**Endpoint:** `GET /upload/history`

**Description:** Get upload history for a client

**Query Parameters:**
```
client_id (optional): Filter by client
upload_type (optional): 'google_ads' | 'meta_ads' | 'leads'
limit (optional): Number of records (default: 50, max: 100)
offset (optional): Pagination offset (default: 0)
```

**Example Request:**
```
GET /upload/history?client_id=CLT001&limit=10
```

**Response (200 OK):**
```json
{
  "success": true,
  "uploads": [
    {
      "upload_id": "UPL001",
      "upload_type": "google_ads",
      "client_id": "CLT001",
      "file_name": "GoogleAds_Nov2025.csv",
      "uploaded_by": "USR001",
      "uploaded_at": "2025-11-11T10:30:00Z",
      "rows_imported": 1247,
      "rows_failed": 0,
      "status": "completed"
    }
  ],
  "pagination": {
    "total": 45,
    "limit": 10,
    "offset": 0,
    "has_more": true
  }
}
```

---

## Client Management

### 1. List All Clients

**Endpoint:** `GET /clients`

**Description:** Get list of all clients

**Query Parameters:**
```
status (optional): 'active' | 'inactive' | 'all' (default: 'active')
industry (optional): Filter by industry
limit (optional): Number of records (default: 50)
offset (optional): Pagination offset
```

**Response (200 OK):**
```json
{
  "success": true,
  "clients": [
    {
      "client_id": "CLT001",
      "client_name": "Tech Manufacturing Ltd",
      "industry": "Manufacturing",
      "status": "Active",
      "date_created": "2025-01-15",
      "total_campaigns": 8,
      "total_spend_ytd": 1250000,
      "total_leads_ytd": 845
    }
  ],
  "pagination": {
    "total": 3,
    "limit": 50,
    "offset": 0
  }
}
```

### 2. Get Client Details

**Endpoint:** `GET /clients/:client_id`

**Description:** Get detailed information for a specific client

**Response (200 OK):**
```json
{
  "success": true,
  "client": {
    "client_id": "CLT001",
    "client_name": "Tech Manufacturing Ltd",
    "industry": "Manufacturing",
    "status": "Active",
    "date_created": "2025-01-15",
    "contact_email": "contact@techmanufacturing.com",
    "contact_phone": "9876543210",
    "logo_url": null,
    "total_campaigns": 8,
    "active_campaigns": 5,
    "total_spend_ytd": 1250000,
    "total_leads_ytd": 845,
    "qualified_leads_ytd": 612
  }
}
```

### 3. Create Client

**Endpoint:** `POST /clients`

**Description:** Create a new client

**Request Body:**
```json
{
  "client_name": "New Client Ltd",
  "industry": "Technology",
  "contact_email": "contact@newclient.com",
  "contact_phone": "9876543210",
  "status": "Active"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Client created successfully",
  "client": {
    "client_id": "CLT004",
    "client_name": "New Client Ltd",
    "industry": "Technology",
    "status": "Active",
    "date_created": "2025-11-11"
  }
}
```

### 4. Update Client

**Endpoint:** `PUT /clients/:client_id`

**Description:** Update client information

**Request Body:**
```json
{
  "client_name": "Updated Client Name",
  "status": "Inactive"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Client updated successfully",
  "client": {
    "client_id": "CLT001",
    "client_name": "Updated Client Name",
    "status": "Inactive"
  }
}
```

### 5. Delete Client

**Endpoint:** `DELETE /clients/:client_id`

**Description:** Soft delete a client (marks as inactive)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Client deleted successfully"
}
```

---

## Campaign Management

### 1. List Campaigns

**Endpoint:** `GET /campaigns`

**Description:** Get list of campaigns

**Query Parameters:**
```
client_id (optional): Filter by client
platform (optional): 'google' | 'meta'
status (optional): 'active' | 'paused' | 'completed'
from (optional): Filter campaigns active after date
to (optional): Filter campaigns active before date
```

**Response (200 OK):**
```json
{
  "success": true,
  "campaigns": [
    {
      "campaign_id": "CMP001",
      "campaign_name": "Google_Search_Manufacturing_Nov25",
      "client_id": "CLT001",
      "client_name": "Tech Manufacturing Ltd",
      "platform": "google",
      "status": "Active",
      "start_date": "2025-10-01",
      "end_date": null,
      "total_spend": 145000,
      "total_leads": 95,
      "roi": 328
    }
  ]
}
```

### 2. Get Campaign Details

**Endpoint:** `GET /campaigns/:campaign_id`

**Description:** Get detailed campaign information with hierarchy

**Query Parameters:**
```
from (optional): Date range filter
to (optional): Date range filter
```

**Response (200 OK):**
```json
{
  "success": true,
  "campaign": {
    "campaign_id": "CMP001",
    "campaign_name": "Google_Search_Manufacturing_Nov25",
    "client_id": "CLT001",
    "platform": "google",
    "status": "Active",
    "metrics": {
      "spend": 145000,
      "impressions": 55000,
      "clicks": 2890,
      "ctr": 5.2,
      "leads": 95,
      "qualified": 72,
      "roi": 328
    },
    "adgroups": [
      {
        "adgroup_id": "ADG001",
        "adgroup_name": "Precision Machining Keywords",
        "spend": 80000,
        "leads": 52
      }
    ]
  }
}
```

---

## Lead Management

### 1. List Leads

**Endpoint:** `GET /leads`

**Description:** Get list of leads with filtering

**Query Parameters:**
```
client_id (optional): Filter by client
campaign_id (optional): Filter by campaign
stage (optional): 'new' | 'contacted' | 'qualified' | 'converted' | 'lost'
source (optional): Filter by source
from (optional): Lead date from
to (optional): Lead date to
limit (optional): Number of records (default: 50, max: 100)
offset (optional): Pagination offset
```

**Response (200 OK):**
```json
{
  "success": true,
  "leads": [
    {
      "lead_id": "LED001",
      "lead_name": "John Doe",
      "email": "john@example.com",
      "phone": "9876543210",
      "city": "Mumbai",
      "source": "Google Search",
      "campaign_id": "CMP001",
      "interested_service": "Precision Machining",
      "lead_stage": "Qualified",
      "lead_date": "2025-11-01",
      "revenue_generated": 150000
    }
  ],
  "pagination": {
    "total": 285,
    "limit": 50,
    "offset": 0,
    "has_more": true
  }
}
```

### 2. Get Lead Details

**Endpoint:** `GET /leads/:lead_id`

**Description:** Get detailed lead information

**Response (200 OK):**
```json
{
  "success": true,
  "lead": {
    "lead_id": "LED001",
    "lead_name": "John Doe",
    "email": "john@example.com",
    "phone": "9876543210",
    "city": "Mumbai",
    "source": "Google Search",
    "utm_url": "https://example.com/services?utm_source=google&utm_campaign=12345",
    "campaign_id": "CMP001",
    "campaign_name": "Google_Search_Manufacturing_Nov25",
    "ad_group_id": "ADG001",
    "keyword": "manufacturing services",
    "interested_service": "Precision Machining",
    "lead_stage": "Qualified",
    "lead_sub_stage": "Demo Scheduled",
    "lead_date": "2025-11-01",
    "follow_up_date": "2025-11-05",
    "revenue_generated": 150000,
    "remarks": "Hot lead",
    "custom_fields": {
      "Budget_Range": "High",
      "Company_Size": "Mid-Market",
      "Timeline": "Immediate"
    }
  }
}
```

### 3. Update Lead Stage

**Endpoint:** `PUT /leads/:lead_id/stage`

**Description:** Update lead stage and sub-stage

**Request Body:**
```json
{
  "lead_stage": "Converted",
  "lead_sub_stage": "Deal Closed",
  "revenue_generated": 200000,
  "remarks": "Successfully closed deal"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Lead stage updated successfully",
  "lead": {
    "lead_id": "LED001",
    "lead_stage": "Converted",
    "lead_sub_stage": "Deal Closed",
    "revenue_generated": 200000
  }
}
```

---

## Error Handling

### Standard Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": "Additional error context (optional)"
  }
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| UNAUTHORIZED | 401 | Missing or invalid authentication token |
| FORBIDDEN | 403 | User lacks required permissions |
| NOT_FOUND | 404 | Resource not found |
| VALIDATION_ERROR | 400 | Request validation failed |
| DUPLICATE_RESOURCE | 409 | Resource already exists |
| RATE_LIMIT_EXCEEDED | 429 | Too many requests |
| INTERNAL_SERVER_ERROR | 500 | Server error |
| SERVICE_UNAVAILABLE | 503 | Service temporarily unavailable |

### Example Error Responses

**401 Unauthorized:**
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication required",
    "details": "Please provide a valid JWT token in the Authorization header"
  }
}
```

**404 Not Found:**
```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Client not found",
    "details": "Client with ID CLT999 does not exist"
  }
}
```

**400 Validation Error:**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request parameters",
    "details": [
      {
        "field": "from",
        "error": "Date must be in YYYY-MM-DD format"
      },
      {
        "field": "platform",
        "error": "Must be one of: google, meta, all"
      }
    ]
  }
}
```

---

## Rate Limiting

### Rate Limit Rules

**Authentication Endpoints:**
- 5 requests per minute per IP address
- Header: `X-RateLimit-Limit: 5`

**Report Endpoints:**
- 60 requests per minute per user
- Header: `X-RateLimit-Limit: 60`

**Upload Endpoints:**
- 10 requests per minute per user
- Header: `X-RateLimit-Limit: 10`

**Other Endpoints:**
- 100 requests per minute per user
- Header: `X-RateLimit-Limit: 100`

### Rate Limit Headers

All API responses include rate limit headers:

```
X-RateLimit-Limit: 60          // Maximum requests allowed
X-RateLimit-Remaining: 45      // Requests remaining in window
X-RateLimit-Reset: 1699876543  // Unix timestamp when limit resets
```

### Rate Limit Exceeded Response

**429 Too Many Requests:**
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded",
    "details": "Maximum 60 requests per minute. Please try again in 45 seconds."
  },
  "retry_after": 45
}
```

---

## Pagination

### Standard Pagination Parameters

```
limit (optional): Number of records per page (default: 50, max: 100)
offset (optional): Number of records to skip (default: 0)
```

### Pagination Response Format

```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "total": 285,
    "limit": 50,
    "offset": 0,
    "has_more": true
  }
}
```

### Cursor-Based Pagination (for large datasets)

**Request:**
```
GET /leads?limit=50&cursor=eyJsZWFkX2lkIjoiTEVEMDUwIn0=
```

**Response:**
```json
{
  "success": true,
  "leads": [...],
  "pagination": {
    "next_cursor": "eyJsZWFkX2lkIjoiTEVEMTAwIn0=",
    "has_more": true
  }
}
```

---

## Filtering & Sorting

### Date Range Filtering

All report endpoints support date range filtering:

```
from (required): Start date (YYYY-MM-DD)
to (required): End date (YYYY-MM-DD)
```

**Example:**
```
GET /reports/master-summary?from=2025-10-01&to=2025-10-31
```

### Sorting

List endpoints support sorting:

```
sort_by (optional): Field name to sort by
sort_order (optional): 'asc' | 'desc' (default: 'desc')
```

**Example:**
```
GET /leads?sort_by=lead_date&sort_order=desc
```

### Multi-Field Filtering

Use query parameters for multiple filters:

```
GET /leads?client_id=CLT001&stage=qualified&source=Google Search
```

---

## Export Endpoints

### 1. Export Report to Excel

**Endpoint:** `POST /export/excel`

**Description:** Export report data to Excel file

**Request Body:**
```json
{
  "report_type": "master_summary",
  "from": "2025-10-12",
  "to": "2025-11-11",
  "filters": {
    "client_id": "CLT001",
    "platform": "google"
  }
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "download_url": "https://api.leadanalytics.olioglobal.com/downloads/report_12345.xlsx",
  "expires_at": "2025-11-11T18:00:00Z"
}
```

### 2. Export Report to PDF

**Endpoint:** `POST /export/pdf`

**Description:** Export report to PDF format

**Request Body:** Same as Excel export

**Response:** Same format with `.pdf` file

---

**End of API Documentation**

For validation rules, see `VALIDATION_RULES.md`.
For database schema, see `DATABASE_SCHEMA.sql`.
For component library, see `COMPONENTS.md`.
