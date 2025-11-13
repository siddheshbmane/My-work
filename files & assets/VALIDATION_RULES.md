# Validation Rules & Business Logic

> **Lead Analytics Dashboard - Validation & Calculation Reference**
> Version 1.0 | For Backend Implementation

---

## Table of Contents

1. [Upload Validation Rules](#upload-validation-rules)
2. [Calculation Formulas](#calculation-formulas)
3. [Business Logic Rules](#business-logic-rules)
4. [Data Processing Logic](#data-processing-logic)
5. [Error Handling](#error-handling)

---

## Upload Validation Rules

### 1. Google Ads Upload Validation

#### Required Fields
```javascript
const REQUIRED_FIELDS = [
  'Date',
  'Campaign Name',
  'Campaign ID',
  'Ad Group Name',
  'Ad Group ID',
  'Spend',
  'Impressions',
  'Clicks',
  'Conversions'
];
```

#### Field Validations

| Field | Type | Format | Validation Rule | Example |
|-------|------|--------|-----------------|---------|
| Date | Date | YYYY-MM-DD | Must be valid date, not future | 2025-11-01 |
| Campaign Name | String | Max 255 chars | Required, not empty | "Campaign_Search_001" |
| Campaign ID | String/Number | Alphanumeric | Required, unique identifier | "12345" |
| Ad Group Name | String | Max 255 chars | Required, not empty | "AdGroup_A" |
| Ad Group ID | String/Number | Alphanumeric | Required, unique identifier | "67890" |
| Ad Name | String | Max 255 chars | Optional | "Ad_001" |
| Ad ID | String/Number | Alphanumeric | Optional | "11111" |
| Keyword | String | Max 255 chars | Optional, "N/A" for display/video | "manufacturing services" |
| Location | String | Max 100 chars | Optional | "Mumbai" |
| Landing Page URL | URL | Valid URL | Must be valid HTTP/HTTPS URL | "https://example.com/page" |
| Ad Type | Enum | String | Must be: Search, Display, YouTube, Shopping | "Search" |
| Spend | Decimal | >= 0 | Must be >= 0, max 2 decimals | 5000.50 |
| Impressions | Integer | >= 0 | Must be >= 0 | 10000 |
| Clicks | Integer | >= 0 | Must be >= 0, <= Impressions | 500 |
| Conversions | Integer | >= 0 | Must be >= 0, <= Clicks | 25 |
| CTR | Decimal | 0-100% | Optional (calculated if missing) | 5.0 |
| CPC | Decimal | >= 0 | Optional (calculated if missing) | 10.0 |
| CPL | Decimal | >= 0 | Optional (calculated if missing) | 200.0 |

#### Business Rules

```javascript
// Rule 1: Clicks cannot exceed Impressions
if (clicks > impressions) {
  throw new ValidationError('Clicks cannot exceed Impressions', row);
}

// Rule 2: Conversions cannot exceed Clicks
if (conversions > clicks) {
  throw new ValidationError('Conversions cannot exceed Clicks', row);
}

// Rule 3: Spend must be >= 0
if (spend < 0) {
  throw new ValidationError('Spend cannot be negative', row);
}

// Rule 4: Date cannot be in the future
if (new Date(date) > new Date()) {
  throw new ValidationError('Date cannot be in the future', row);
}

// Rule 5: Campaign hierarchy validation
// If Ad Group ID is provided, Campaign ID must exist in database
const campaign = await Campaign.findById(campaignId);
if (!campaign && adGroupId) {
  throw new ValidationError('Campaign ID not found', row);
}
```

---

### 2. Meta Ads Upload Validation

#### Required Fields
```javascript
const REQUIRED_FIELDS = [
  'Date',
  'Campaign Name',
  'Campaign ID',
  'AdSet Name',
  'AdSet ID',
  'Platform',
  'Spend',
  'Impressions',
  'Clicks',
  'Conversions'
];
```

#### Field Validations

| Field | Type | Format | Validation Rule | Example |
|-------|------|--------|-----------------|---------|
| Date | Date | YYYY-MM-DD | Must be valid date, not future | 2025-11-01 |
| Campaign Name | String | Max 255 chars | Required, not empty | "Campaign_FB_001" |
| Campaign ID | String/Number | Alphanumeric | Required, unique identifier | "23456" |
| AdSet Name | String | Max 255 chars | Required, not empty | "AdSet_B" |
| AdSet ID | String/Number | Alphanumeric | Required, unique identifier | "78901" |
| Ad Name | String | Max 255 chars | Optional | "video_Ad_002" |
| Ad ID | String/Number | Alphanumeric | Optional | "22222" |
| Form ID | String | Alphanumeric | Optional (for lead ads) | "form_123" |
| Platform | Enum | String | Must be: Facebook, Instagram, Messenger, Audience Network | "Facebook" |
| Placement | Enum | String | Must be: Feed, Stories, Reels, Sidebar, etc. | "Feed" |
| Region | String | Max 100 chars | Optional | "Maharashtra" |
| Landing Page URL | URL | Valid URL | Must be valid HTTP/HTTPS URL | "https://example.com/page" |
| Creative Type | Enum | String | Must be: Video, Static, Carousel | "Video" |
| Spend | Decimal | >= 0 | Must be >= 0, max 2 decimals | 4500.50 |
| Impressions | Integer | >= 0 | Must be >= 0 | 12000 |
| Clicks | Integer | >= 0 | Must be >= 0, <= Impressions | 480 |
| Conversions | Integer | >= 0 | Must be >= 0, <= Clicks | 24 |
| CTR | Decimal | 0-100% | Optional (calculated if missing) | 4.0 |
| CPC | Decimal | >= 0 | Optional (calculated if missing) | 9.38 |
| CPL | Decimal | >= 0 | Optional (calculated if missing) | 187.5 |

#### Business Rules

```javascript
// Rule 1: Same as Google Ads (clicks <= impressions)
if (clicks > impressions) {
  throw new ValidationError('Clicks cannot exceed Impressions', row);
}

// Rule 2: Creative Type Detection
// If Creative Type is missing, detect from Ad Name
function detectCreativeType(adName) {
  const name = adName.toLowerCase();
  if (name.includes('video') || name.includes('vid') || name.includes('reel')) {
    return 'Video';
  }
  if (name.includes('carousel')) {
    return 'Carousel';
  }
  return 'Static'; // Default
}

// Rule 3: Platform-Placement Validation
const VALID_PLACEMENTS = {
  'Facebook': ['Feed', 'Stories', 'Sidebar', 'Instant Articles', 'In-Stream Video'],
  'Instagram': ['Feed', 'Stories', 'Reels', 'Explore'],
  'Messenger': ['Inbox', 'Stories', 'Sponsored Messages'],
  'Audience Network': ['Native', 'Banner', 'Interstitial']
};

if (!VALID_PLACEMENTS[platform].includes(placement)) {
  throw new ValidationError(`Invalid placement '${placement}' for platform '${platform}'`, row);
}
```

---

### 3. Leads Upload Validation

#### Required Fields
```javascript
const REQUIRED_FIELDS = [
  'Lead Date',
  'Lead Name',
  'Email',
  'Phone',
  'Source',
  'Campaign ID',
  'Interested Service',
  'Lead Stage'
];
```

#### Field Validations

| Field | Type | Format | Validation Rule | Example |
|-------|------|--------|-----------------|---------|
| Lead Date | Date | YYYY-MM-DD | Must be valid date, not future | 2025-11-01 |
| Lead Name | String | Max 255 chars | Required, not empty | "John Doe" |
| Email | Email | Valid email | Must be valid email format | "john@example.com" |
| Phone | String | 10 digits | Must be 10-digit Indian phone number | "9876543210" |
| City | String | Max 100 chars | Optional | "Mumbai" |
| Source | Enum | String | Must be: Google Search, Google Display, Google YouTube, Meta-FB, Meta-Insta | "Google Search" |
| UTM URL | URL | Valid URL | Must contain utm_source, utm_campaign | "https://example.com?utm_source=google&utm_campaign=12345" |
| Campaign ID | String/Number | Alphanumeric | Required, must exist in campaigns | "12345" |
| Ad Group ID | String/Number | Alphanumeric | Optional, must exist if provided | "67890" |
| Keyword | String | Max 255 chars | Optional | "manufacturing services" |
| Interested Service | String | Max 255 chars | Required | "Precision Machining" |
| Lead Stage | Enum | String | Must be: New, Contacted, Qualified, Converted, Lost | "Qualified" |
| Lead Sub-Stage | String | Max 100 chars | Optional | "Demo Scheduled" |
| Follow-up Date | Date | YYYY-MM-DD | Optional, must be >= Lead Date | 2025-11-05 |
| Revenue Generated | Decimal | >= 0 | Must be >= 0, required if stage = Converted | 150000 |
| Remarks | Text | Max 1000 chars | Optional | "Hot lead" |

#### Custom Fields Support
```javascript
// System should auto-detect custom fields not in standard schema
// Custom fields naming rules:
// - Must not conflict with standard fields
// - Max 50 characters
// - Alphanumeric + underscores only
// - Store in separate custom_fields JSONB column

function detectCustomFields(uploadedColumns, standardColumns) {
  const customFields = uploadedColumns.filter(col =>
    !standardColumns.includes(col)
  );

  // Validate custom field names
  customFields.forEach(field => {
    if (!/^[a-zA-Z0-9_]{1,50}$/.test(field)) {
      throw new ValidationError(`Invalid custom field name: ${field}`);
    }
  });

  return customFields;
}
```

#### Business Rules

```javascript
// Rule 1: Email validation
function validateEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

// Rule 2: Phone validation (Indian format)
function validatePhone(phone) {
  const cleaned = phone.replace(/\D/g, '');
  return cleaned.length === 10 && /^[6-9]\d{9}$/.test(cleaned);
}

// Rule 3: UTM URL parsing
function extractCampaignFromUTM(utmUrl) {
  try {
    const url = new URL(utmUrl);
    const params = new URLSearchParams(url.search);

    const campaignId = params.get('utm_campaign');
    const adGroupId = params.get('utm_adgroup') || params.get('utm_content');
    const keyword = params.get('utm_term');
    const source = params.get('utm_source');

    if (!campaignId) {
      throw new Error('utm_campaign parameter is required');
    }

    return { campaignId, adGroupId, keyword, source };
  } catch (error) {
    throw new ValidationError('Invalid UTM URL format', error.message);
  }
}

// Rule 4: Campaign matching
async function matchLeadToCampaign(campaignId, source) {
  const campaign = await Campaign.findOne({
    where: { campaign_id: campaignId },
    include: [{ model: Client }]
  });

  if (!campaign) {
    // Create unmatched lead record
    return { matched: false, campaignId };
  }

  // Verify source matches platform
  const sourceToPlatform = {
    'Google Search': 'google',
    'Google Display': 'google',
    'Google YouTube': 'google',
    'Meta-FB': 'meta',
    'Meta-Insta': 'meta'
  };

  if (campaign.platform !== sourceToPlatform[source]) {
    throw new ValidationError('Source does not match campaign platform');
  }

  return { matched: true, campaign };
}

// Rule 5: Revenue validation
function validateRevenue(stage, revenue) {
  if (stage === 'Converted' && (!revenue || revenue <= 0)) {
    throw new ValidationError('Revenue is required for Converted leads');
  }

  if (stage !== 'Converted' && revenue > 0) {
    // Warning only, not error
    return { warning: 'Revenue provided for non-converted lead' };
  }

  return { valid: true };
}
```

---

## Calculation Formulas

### 1. Primary Metrics

#### CPL (Cost Per Lead)
```javascript
/**
 * Cost Per Lead
 * Formula: Total Spend / Total Leads
 *
 * @param {number} totalSpend - Total advertising spend
 * @param {number} totalLeads - Total number of leads generated
 * @returns {number} Cost per lead (rounded to 2 decimals)
 */
function calculateCPL(totalSpend, totalLeads) {
  if (totalLeads === 0) return 0;
  return Math.round((totalSpend / totalLeads) * 100) / 100;
}

// Example: ₹5000 spend / 25 leads = ₹200 CPL
```

#### CPQL (Cost Per Qualified Lead)
```javascript
/**
 * Cost Per Qualified Lead
 * Formula: Total Spend / Qualified Leads
 *
 * @param {number} totalSpend - Total advertising spend
 * @param {number} qualifiedLeads - Number of qualified leads only
 * @returns {number} Cost per qualified lead (rounded to 2 decimals)
 */
function calculateCPQL(totalSpend, qualifiedLeads) {
  if (qualifiedLeads === 0) return 0;
  return Math.round((totalSpend / qualifiedLeads) * 100) / 100;
}

// Example: ₹5000 spend / 18 qualified leads = ₹277.78 CPQL
```

#### CTR (Click-Through Rate)
```javascript
/**
 * Click-Through Rate
 * Formula: (Clicks / Impressions) × 100
 *
 * @param {number} clicks - Total clicks
 * @param {number} impressions - Total impressions
 * @returns {number} CTR percentage (rounded to 2 decimals)
 */
function calculateCTR(clicks, impressions) {
  if (impressions === 0) return 0;
  return Math.round((clicks / impressions) * 10000) / 100;
}

// Example: 500 clicks / 10000 impressions = 5.00%
```

#### CPC (Cost Per Click)
```javascript
/**
 * Cost Per Click
 * Formula: Total Spend / Total Clicks
 *
 * @param {number} totalSpend - Total advertising spend
 * @param {number} totalClicks - Total clicks
 * @returns {number} Cost per click (rounded to 2 decimals)
 */
function calculateCPC(totalSpend, totalClicks) {
  if (totalClicks === 0) return 0;
  return Math.round((totalSpend / totalClicks) * 100) / 100;
}

// Example: ₹5000 spend / 500 clicks = ₹10 CPC
```

#### Qualification Rate
```javascript
/**
 * Lead Qualification Rate
 * Formula: (Qualified Leads / Total Leads) × 100
 *
 * @param {number} qualifiedLeads - Number of qualified leads
 * @param {number} totalLeads - Total number of leads
 * @returns {number} Qualification rate percentage (rounded to 1 decimal)
 */
function calculateQualificationRate(qualifiedLeads, totalLeads) {
  if (totalLeads === 0) return 0;
  return Math.round((qualifiedLeads / totalLeads) * 1000) / 10;
}

// Example: 18 qualified / 25 total = 72.0%
```

#### Conversion Rate
```javascript
/**
 * Conversion Rate
 * Formula: (Conversions / Clicks) × 100
 *
 * @param {number} conversions - Total conversions
 * @param {number} clicks - Total clicks
 * @returns {number} Conversion rate percentage (rounded to 2 decimals)
 */
function calculateConversionRate(conversions, clicks) {
  if (clicks === 0) return 0;
  return Math.round((conversions / clicks) * 10000) / 100;
}

// Example: 25 conversions / 500 clicks = 5.00%
```

### 2. Revenue Metrics

#### ROI (Return on Investment)
```javascript
/**
 * Return on Investment
 * Formula: ((Revenue - Spend) / Spend) × 100
 *
 * @param {number} revenue - Total revenue generated
 * @param {number} spend - Total advertising spend
 * @returns {number} ROI percentage (rounded to whole number)
 */
function calculateROI(revenue, spend) {
  if (spend === 0) return 0;
  return Math.round(((revenue - spend) / spend) * 100);
}

// Example: (₹10,000 revenue - ₹5,000 spend) / ₹5,000 = 100% ROI
```

#### ROAS (Return on Ad Spend)
```javascript
/**
 * Return on Ad Spend
 * Formula: Revenue / Spend
 *
 * @param {number} revenue - Total revenue generated
 * @param {number} spend - Total advertising spend
 * @returns {number} ROAS ratio (rounded to 2 decimals)
 */
function calculateROAS(revenue, spend) {
  if (spend === 0) return 0;
  return Math.round((revenue / spend) * 100) / 100;
}

// Example: ₹10,000 revenue / ₹5,000 spend = 2.00x ROAS
```

#### Revenue Per Lead
```javascript
/**
 * Average Revenue Per Lead
 * Formula: Total Revenue / Total Converted Leads
 *
 * @param {number} totalRevenue - Total revenue from all converted leads
 * @param {number} convertedLeads - Number of leads that converted
 * @returns {number} Revenue per lead (rounded to 2 decimals)
 */
function calculateRevenuePerLead(totalRevenue, convertedLeads) {
  if (convertedLeads === 0) return 0;
  return Math.round((totalRevenue / convertedLeads) * 100) / 100;
}

// Example: ₹450,000 revenue / 3 converted leads = ₹150,000 per lead
```

### 3. Variance Calculations

#### Percentage Change
```javascript
/**
 * Calculate percentage change between two periods
 * Formula: ((New Value - Old Value) / Old Value) × 100
 *
 * @param {number} newValue - Current period value
 * @param {number} oldValue - Previous period value
 * @returns {object} { change: number, direction: 'up'|'down'|'neutral' }
 */
function calculatePercentageChange(newValue, oldValue) {
  if (oldValue === 0) {
    return { change: 0, direction: 'neutral' };
  }

  const change = Math.round(((newValue - oldValue) / oldValue) * 1000) / 10;

  let direction = 'neutral';
  if (change > 0) direction = 'up';
  if (change < 0) direction = 'down';

  return { change: Math.abs(change), direction };
}

// Example: New CPL ₹220, Old CPL ₹200
// Change = ((220 - 200) / 200) × 100 = 10% increase
```

#### Week-over-Week Variance
```javascript
/**
 * Calculate week-over-week variance for CPL/CPQL
 *
 * @param {number} currentWeekValue - Current week's metric value
 * @param {number} previousWeekValue - Previous week's metric value
 * @returns {object} { variance: number, alert: boolean }
 */
function calculateWeeklyVariance(currentWeekValue, previousWeekValue) {
  const variance = calculatePercentageChange(currentWeekValue, previousWeekValue);

  // Alert if variance exceeds 20% threshold
  const alert = Math.abs(variance.change) > 20;

  return {
    variance: variance.change,
    direction: variance.direction,
    alert: alert
  };
}

// Example: Current week CPL ₹250, Previous week CPL ₹200
// Variance = 25% increase, Alert = true (exceeds 20%)
```

---

## Business Logic Rules

### 1. Lead Qualification Rules

```javascript
/**
 * Determine if a lead is "Qualified" based on Lead Stage
 *
 * Qualified stages:
 * - Qualified
 * - Converted
 *
 * Not qualified stages:
 * - New
 * - Contacted
 * - Lost
 */
function isLeadQualified(leadStage) {
  const qualifiedStages = ['Qualified', 'Converted'];
  return qualifiedStages.includes(leadStage);
}

/**
 * Determine if a lead is "Junk"
 *
 * Junk = Lost stage
 */
function isLeadJunk(leadStage) {
  return leadStage === 'Lost';
}
```

### 2. Campaign Status Rules

```javascript
/**
 * Determine campaign status based on activity
 *
 * @param {Date} lastActivityDate - Date of last recorded activity
 * @returns {string} 'Active' | 'Paused' | 'Completed'
 */
function determineCampaignStatus(lastActivityDate) {
  const daysSinceActivity = Math.floor(
    (new Date() - new Date(lastActivityDate)) / (1000 * 60 * 60 * 24)
  );

  if (daysSinceActivity <= 7) return 'Active';
  if (daysSinceActivity <= 30) return 'Paused';
  return 'Completed';
}
```

### 3. Platform Comparison Winner

```javascript
/**
 * Determine winning platform based on multiple metrics
 *
 * Priority order:
 * 1. ROI (highest wins)
 * 2. CPQL (lowest wins)
 * 3. Qualification Rate (highest wins)
 */
function determineWinningPlatform(googleMetrics, metaMetrics) {
  const winner = {
    overall: null,
    by_metric: {}
  };

  // ROI comparison
  if (googleMetrics.roi !== metaMetrics.roi) {
    winner.by_metric.roi = googleMetrics.roi > metaMetrics.roi ? 'google' : 'meta';
  }

  // CPQL comparison (lower is better)
  if (googleMetrics.cpql !== metaMetrics.cpql) {
    winner.by_metric.cpql = googleMetrics.cpql < metaMetrics.cpql ? 'google' : 'meta';
  }

  // Qualification rate comparison
  if (googleMetrics.qualificationRate !== metaMetrics.qualificationRate) {
    winner.by_metric.qualificationRate =
      googleMetrics.qualificationRate > metaMetrics.qualificationRate ? 'google' : 'meta';
  }

  // Overall winner (based on ROI)
  winner.overall = winner.by_metric.roi;

  return winner;
}
```

### 4. Alert Threshold Rules

```javascript
/**
 * Define alert thresholds for key metrics
 */
const ALERT_THRESHOLDS = {
  cpl_variance: 20,        // Alert if CPL increases by > 20%
  cpql_variance: 20,       // Alert if CPQL increases by > 20%
  qualification_rate: 50,  // Alert if qualification rate < 50%
  roi: 100,                // Alert if ROI < 100%
  daily_spend: 50000       // Alert if daily spend > ₹50,000
};

/**
 * Check if any alerts should be triggered
 */
function checkAlerts(metrics, previousMetrics) {
  const alerts = [];

  // CPL variance alert
  const cplVariance = calculateWeeklyVariance(metrics.cpl, previousMetrics.cpl);
  if (cplVariance.alert && cplVariance.direction === 'up') {
    alerts.push({
      type: 'cpl_increase',
      severity: 'warning',
      message: `CPL increased by ${cplVariance.variance}% (threshold: 20%)`,
      value: metrics.cpl
    });
  }

  // Qualification rate alert
  if (metrics.qualificationRate < ALERT_THRESHOLDS.qualification_rate) {
    alerts.push({
      type: 'low_qualification_rate',
      severity: 'critical',
      message: `Qualification rate is ${metrics.qualificationRate}% (threshold: 50%)`,
      value: metrics.qualificationRate
    });
  }

  // ROI alert
  if (metrics.roi < ALERT_THRESHOLDS.roi) {
    alerts.push({
      type: 'low_roi',
      severity: 'warning',
      message: `ROI is ${metrics.roi}% (threshold: 100%)`,
      value: metrics.roi
    });
  }

  return alerts;
}
```

---

## Data Processing Logic

### 1. Lead Matching Algorithm

```javascript
/**
 * Match leads to campaigns using multiple strategies
 *
 * Priority order:
 * 1. Campaign ID + Ad Group ID match
 * 2. Campaign ID only match
 * 3. UTM parameter extraction
 * 4. Date + Source fuzzy match
 */
async function matchLeadToCampaign(lead) {
  let campaign = null;
  let matchMethod = null;

  // Strategy 1: Exact Campaign ID + Ad Group ID match
  if (lead.campaign_id && lead.ad_group_id) {
    campaign = await Campaign.findOne({
      where: { campaign_id: lead.campaign_id },
      include: [{
        model: AdGroup,
        where: { ad_group_id: lead.ad_group_id }
      }]
    });

    if (campaign) {
      matchMethod = 'exact_hierarchy';
      return { campaign, matchMethod, confidence: 100 };
    }
  }

  // Strategy 2: Campaign ID only match
  if (lead.campaign_id) {
    campaign = await Campaign.findOne({
      where: { campaign_id: lead.campaign_id }
    });

    if (campaign) {
      matchMethod = 'campaign_id';
      return { campaign, matchMethod, confidence: 90 };
    }
  }

  // Strategy 3: UTM parameter extraction
  if (lead.utm_url) {
    try {
      const utmParams = extractCampaignFromUTM(lead.utm_url);
      campaign = await Campaign.findOne({
        where: { campaign_id: utmParams.campaignId }
      });

      if (campaign) {
        matchMethod = 'utm_extraction';
        return { campaign, matchMethod, confidence: 80 };
      }
    } catch (error) {
      // UTM parsing failed, continue to next strategy
    }
  }

  // Strategy 4: Date + Source fuzzy match
  const sourceToPlatform = {
    'Google Search': 'google',
    'Google Display': 'google',
    'Google YouTube': 'google',
    'Meta-FB': 'meta',
    'Meta-Insta': 'meta'
  };

  const platform = sourceToPlatform[lead.source];
  const leadDate = new Date(lead.lead_date);

  campaign = await Campaign.findOne({
    where: {
      platform: platform,
      // Find campaigns active on lead date
      [Op.and]: [
        { start_date: { [Op.lte]: leadDate } },
        {
          [Op.or]: [
            { end_date: { [Op.gte]: leadDate } },
            { end_date: null }
          ]
        }
      ]
    },
    order: [['spend', 'DESC']], // Prefer highest spending campaign
    limit: 1
  });

  if (campaign) {
    matchMethod = 'fuzzy_match';
    return { campaign, matchMethod, confidence: 50 };
  }

  // No match found
  return { campaign: null, matchMethod: 'unmatched', confidence: 0 };
}
```

### 2. Aggregation Logic

```javascript
/**
 * Aggregate performance data across hierarchy
 * Campaign → Sum of all Ad Groups → Sum of all Ads
 */
async function aggregateCampaignPerformance(campaignId, dateRange) {
  // Get all performance records for campaign hierarchy
  const performanceData = await Performance.findAll({
    where: {
      campaign_id: campaignId,
      date: {
        [Op.between]: [dateRange.from, dateRange.to]
      }
    },
    include: [
      { model: Campaign },
      { model: AdGroup },
      { model: Ad }
    ]
  });

  // Aggregate metrics
  const aggregated = {
    total_spend: 0,
    total_impressions: 0,
    total_clicks: 0,
    total_conversions: 0
  };

  performanceData.forEach(record => {
    aggregated.total_spend += record.spend;
    aggregated.total_impressions += record.impressions;
    aggregated.total_clicks += record.clicks;
    aggregated.total_conversions += record.conversions;
  });

  // Calculate derived metrics
  aggregated.ctr = calculateCTR(aggregated.total_clicks, aggregated.total_impressions);
  aggregated.cpc = calculateCPC(aggregated.total_spend, aggregated.total_clicks);

  // Get lead data
  const leads = await Lead.findAll({
    where: {
      campaign_id: campaignId,
      lead_date: {
        [Op.between]: [dateRange.from, dateRange.to]
      }
    }
  });

  aggregated.total_leads = leads.length;
  aggregated.qualified_leads = leads.filter(l => isLeadQualified(l.lead_stage)).length;
  aggregated.qualification_rate = calculateQualificationRate(
    aggregated.qualified_leads,
    aggregated.total_leads
  );
  aggregated.cpl = calculateCPL(aggregated.total_spend, aggregated.total_leads);
  aggregated.cpql = calculateCPQL(aggregated.total_spend, aggregated.qualified_leads);

  // Calculate revenue and ROI
  const convertedLeads = leads.filter(l => l.lead_stage === 'Converted');
  aggregated.revenue = convertedLeads.reduce((sum, lead) => sum + lead.revenue_generated, 0);
  aggregated.roi = calculateROI(aggregated.revenue, aggregated.total_spend);

  return aggregated;
}
```

### 3. Duplicate Detection

```javascript
/**
 * Detect duplicate leads based on multiple criteria
 */
async function checkDuplicateLead(lead) {
  const duplicates = [];

  // Check 1: Exact email + phone match
  const exactMatch = await Lead.findOne({
    where: {
      email: lead.email,
      phone: lead.phone
    }
  });

  if (exactMatch) {
    duplicates.push({
      type: 'exact',
      lead_id: exactMatch.lead_id,
      confidence: 100
    });
  }

  // Check 2: Email match only (within 30 days)
  const emailMatch = await Lead.findOne({
    where: {
      email: lead.email,
      lead_date: {
        [Op.gte]: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
      }
    }
  });

  if (emailMatch && emailMatch.lead_id !== exactMatch?.lead_id) {
    duplicates.push({
      type: 'email',
      lead_id: emailMatch.lead_id,
      confidence: 80
    });
  }

  // Check 3: Phone match only (within 30 days)
  const phoneMatch = await Lead.findOne({
    where: {
      phone: lead.phone,
      lead_date: {
        [Op.gte]: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
      }
    }
  });

  if (phoneMatch && phoneMatch.lead_id !== exactMatch?.lead_id) {
    duplicates.push({
      type: 'phone',
      lead_id: phoneMatch.lead_id,
      confidence: 70
    });
  }

  return {
    is_duplicate: duplicates.length > 0,
    duplicates: duplicates
  };
}
```

---

## Error Handling

### 1. Upload Error Types

```javascript
const ERROR_TYPES = {
  VALIDATION_ERROR: {
    code: 'VALIDATION_ERROR',
    severity: 'error',
    action: 'reject_row'
  },
  MISSING_REQUIRED_FIELD: {
    code: 'MISSING_REQUIRED_FIELD',
    severity: 'error',
    action: 'reject_row'
  },
  INVALID_FORMAT: {
    code: 'INVALID_FORMAT',
    severity: 'error',
    action: 'reject_row'
  },
  CAMPAIGN_NOT_FOUND: {
    code: 'CAMPAIGN_NOT_FOUND',
    severity: 'warning',
    action: 'import_as_unmatched'
  },
  DUPLICATE_LEAD: {
    code: 'DUPLICATE_LEAD',
    severity: 'warning',
    action: 'skip_or_update'
  },
  CALCULATION_MISMATCH: {
    code: 'CALCULATION_MISMATCH',
    severity: 'info',
    action: 'recalculate'
  }
};
```

### 2. Error Response Format

```javascript
/**
 * Standard error response format
 */
function formatErrorResponse(errors) {
  return {
    success: false,
    error: {
      code: 'VALIDATION_ERROR',
      message: 'Validation failed for uploaded file',
      count: errors.length,
      details: errors.map(err => ({
        row: err.row,
        field: err.field,
        value: err.value,
        error: err.message,
        severity: err.severity
      }))
    }
  };
}
```

### 3. Warning vs Error Handling

```javascript
/**
 * Determine if issue should be error or warning
 */
function classifyIssue(issue) {
  // Critical errors - reject row
  const criticalErrors = [
    'MISSING_REQUIRED_FIELD',
    'INVALID_FORMAT',
    'BUSINESS_RULE_VIOLATION'
  ];

  // Warnings - import with flag
  const warnings = [
    'CAMPAIGN_NOT_FOUND',
    'DUPLICATE_LEAD',
    'CALCULATION_MISMATCH',
    'MISSING_OPTIONAL_FIELD'
  ];

  if (criticalErrors.includes(issue.type)) {
    return { action: 'reject', severity: 'error' };
  }

  if (warnings.includes(issue.type)) {
    return { action: 'import_with_warning', severity: 'warning' };
  }

  return { action: 'import', severity: 'info' };
}
```

---

**End of Validation Rules Document**

For API implementation details, see `API_DOCUMENTATION.md`.
For database schema, see `DATABASE_SCHEMA.sql`.
