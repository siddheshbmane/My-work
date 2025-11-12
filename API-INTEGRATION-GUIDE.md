# 📊 API Integration Guide
## Getting Real Data from Google Ads & Facebook Ads

This guide provides step-by-step instructions for integrating your Lead Analytics Dashboard with Google Ads and Facebook (Meta) Ads APIs to fetch real campaign data.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Google Ads API Integration](#google-ads-api-integration)
3. [Facebook (Meta) Ads API Integration](#facebook-meta-ads-api-integration)
4. [Data Format & Mapping](#data-format--mapping)
5. [Backend Implementation](#backend-implementation)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Accounts & Access
- ✅ Google Ads account with API access
- ✅ Facebook Business Manager account
- ✅ Developer accounts on both platforms
- ✅ Backend server (Node.js, Python, or PHP recommended)
- ✅ SSL certificate for your domain (HTTPS required)

### Technical Requirements
- Programming knowledge (JavaScript, Python, or PHP)
- Understanding of REST APIs
- OAuth 2.0 authentication knowledge
- Database for storing tokens (optional but recommended)

---

## Google Ads API Integration

### Step 1: Create Google Cloud Project

1. **Go to Google Cloud Console**
   - Visit: https://console.cloud.google.com/
   - Sign in with your Google account

2. **Create New Project**
   ```
   Project Name: Lead Analytics Dashboard
   Organization: Your Company
   ```

3. **Enable Google Ads API**
   - Navigate to "APIs & Services" > "Library"
   - Search for "Google Ads API"
   - Click "Enable"

### Step 2: Create OAuth 2.0 Credentials

1. **Go to Credentials Page**
   - Navigate to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth client ID"

2. **Configure OAuth Consent Screen**
   ```
   App name: Lead Analytics Dashboard
   User support email: your-email@company.com
   Authorized domains: yourdomain.com
   Developer contact: your-email@company.com
   ```

3. **Create OAuth Client**
   ```
   Application type: Web application
   Name: Dashboard Backend
   Authorized redirect URIs: https://yourdomain.com/oauth/callback
   ```

4. **Save Credentials**
   - Download JSON file with:
     - Client ID
     - Client Secret
   - Store securely (never commit to Git!)

### Step 3: Get Developer Token

1. **Apply for Developer Token**
   - Visit: https://ads.google.com/
   - Go to Tools & Settings > API Center
   - Fill out the application form

2. **Wait for Approval** (typically 24-48 hours)

3. **Note Your Developer Token**
   ```
   Developer Token: YOUR_DEVELOPER_TOKEN
   ```

### Step 4: Link Google Ads Account

1. **Get Your Customer ID**
   - In Google Ads, top right corner
   - Format: 123-456-7890
   - Remove hyphens for API: 1234567890

2. **Verify API Access**
   - Ensure account has API access enabled
   - Admin must grant permission if needed

### Step 5: Implement Authentication (Node.js Example)

```javascript
const {google} = require('googleapis');
const OAuth2 = google.auth.OAuth2;

// Configuration
const oauth2Client = new OAuth2(
  'YOUR_CLIENT_ID',
  'YOUR_CLIENT_SECRET',
  'https://yourdomain.com/oauth/callback'
);

// Generate auth URL
const authUrl = oauth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: ['https://www.googleapis.com/auth/adwords']
});

// Redirect user to authUrl
// After authorization, you'll receive a code

// Exchange code for tokens
async function getTokens(code) {
  const {tokens} = await oauth2Client.getToken(code);
  oauth2Client.setCredentials(tokens);

  // Store tokens in database
  await saveTokens({
    access_token: tokens.access_token,
    refresh_token: tokens.refresh_token,
    expiry_date: tokens.expiry_date
  });

  return tokens;
}
```

### Step 6: Fetch Campaign Data

```javascript
const {GoogleAdsApi} = require('google-ads-api');

// Initialize client
const client = new GoogleAdsApi({
  client_id: 'YOUR_CLIENT_ID',
  client_secret: 'YOUR_CLIENT_SECRET',
  developer_token: 'YOUR_DEVELOPER_TOKEN'
});

// Create customer
const customer = client.Customer({
  customer_id: '1234567890',
  refresh_token: 'YOUR_REFRESH_TOKEN'
});

// Query campaign data
async function getCampaignData(dateFrom, dateTo) {
  const query = `
    SELECT
      campaign.id,
      campaign.name,
      campaign.status,
      campaign.advertising_channel_type,
      metrics.impressions,
      metrics.clicks,
      metrics.ctr,
      metrics.cost_micros,
      metrics.conversions,
      metrics.conversions_value
    FROM campaign
    WHERE segments.date BETWEEN '${dateFrom}' AND '${dateTo}'
    ORDER BY campaign.name
  `;

  const campaigns = await customer.query(query);

  // Transform to your format
  return campaigns.map(row => ({
    id: row.campaign.id,
    name: row.campaign.name,
    platform: 'Google Ads',
    status: row.campaign.status,
    type: row.campaign.advertising_channel_type,
    impressions: row.metrics.impressions,
    clicks: row.metrics.clicks,
    ctr: row.metrics.ctr,
    spend: row.metrics.cost_micros / 1000000, // Convert micros to currency
    leads: row.metrics.conversions,
    revenue: row.metrics.conversions_value
  }));
}
```

### Google Ads API Response Example

```json
{
  "results": [
    {
      "campaign": {
        "id": "12345678",
        "name": "Search_Campaign_Nov_2024",
        "status": "ENABLED",
        "advertisingChannelType": "SEARCH"
      },
      "metrics": {
        "impressions": "55420",
        "clicks": "2890",
        "ctr": 0.0521,
        "costMicros": "125000000000",
        "conversions": 95,
        "conversionsValue": 6200000
      }
    }
  ]
}
```

---

## Facebook (Meta) Ads API Integration

### Step 1: Create Meta App

1. **Go to Meta for Developers**
   - Visit: https://developers.facebook.com/
   - Sign in with your Facebook account

2. **Create New App**
   ```
   App Type: Business
   App Name: Lead Analytics Dashboard
   Contact Email: your-email@company.com
   ```

3. **Add Marketing API Product**
   - In App Dashboard, click "Add Product"
   - Select "Marketing API"

### Step 2: Get Access Tokens

1. **Create System User** (Recommended for production)
   - Go to Business Settings > System Users
   - Click "Add" > Create system user
   - Assign necessary permissions

2. **Generate Access Token**
   - Go to System User > Assets > Apps
   - Select your app
   - Generate token with these permissions:
     ```
     - ads_read
     - ads_management
     - business_management
     - pages_read_engagement
     ```

3. **Get Long-Lived Token** (doesn't expire)
   ```
   curl -X GET "https://graph.facebook.com/v18.0/oauth/access_token?
     grant_type=fb_exchange_token&
     client_id=YOUR_APP_ID&
     client_secret=YOUR_APP_SECRET&
     fb_exchange_token=YOUR_SHORT_LIVED_TOKEN"
   ```

### Step 3: Get Ad Account ID

1. **Find Your Ad Account ID**
   - Go to Meta Business Suite > All Tools > Ads Manager
   - Top left corner: Account ID
   - Format: `act_1234567890`

2. **Verify API Access**
   - Ensure Business Manager owns the ad account
   - System user has been assigned to the account

### Step 4: Implement Authentication (Node.js Example)

```javascript
const axios = require('axios');

const FB_API_VERSION = 'v18.0';
const BASE_URL = `https://graph.facebook.com/${FB_API_VERSION}`;

class FacebookAdsAPI {
  constructor(accessToken, adAccountId) {
    this.accessToken = accessToken;
    this.adAccountId = adAccountId; // format: act_1234567890
  }

  async request(endpoint, params = {}) {
    try {
      const response = await axios.get(`${BASE_URL}${endpoint}`, {
        params: {
          ...params,
          access_token: this.accessToken
        }
      });
      return response.data;
    } catch (error) {
      console.error('Facebook API Error:', error.response?.data);
      throw error;
    }
  }
}
```

### Step 5: Fetch Campaign Data

```javascript
async function getCampaignData(api, dateFrom, dateTo) {
  // Get campaigns
  const campaigns = await api.request(`/${api.adAccountId}/campaigns`, {
    fields: [
      'id',
      'name',
      'status',
      'objective',
      'created_time',
      'updated_time'
    ].join(','),
    time_range: JSON.stringify({
      since: dateFrom,
      until: dateTo
    })
  });

  // Get insights for each campaign
  const campaignsWithInsights = await Promise.all(
    campaigns.data.map(async (campaign) => {
      const insights = await api.request(`/${campaign.id}/insights`, {
        fields: [
          'impressions',
          'clicks',
          'ctr',
          'spend',
          'actions', // Contains conversions
          'action_values' // Contains conversion values
        ].join(','),
        time_range: JSON.stringify({
          since: dateFrom,
          until: dateTo
        })
      });

      // Extract conversion data
      const leads = insights.data[0]?.actions?.find(
        a => a.action_type === 'lead'
      )?.value || 0;

      const revenue = insights.data[0]?.action_values?.find(
        a => a.action_type === 'offsite_conversion.fb_pixel_purchase'
      )?.value || 0;

      return {
        id: campaign.id,
        name: campaign.name,
        platform: 'Meta Ads',
        status: campaign.status,
        type: campaign.objective,
        impressions: parseInt(insights.data[0]?.impressions || 0),
        clicks: parseInt(insights.data[0]?.clicks || 0),
        ctr: parseFloat(insights.data[0]?.ctr || 0),
        spend: parseFloat(insights.data[0]?.spend || 0),
        leads: parseInt(leads),
        revenue: parseFloat(revenue)
      };
    })
  );

  return campaignsWithInsights;
}

// Usage
const api = new FacebookAdsAPI(
  'YOUR_ACCESS_TOKEN',
  'act_1234567890'
);

const data = await getCampaignData(api, '2024-11-01', '2024-11-30');
console.log(data);
```

### Facebook Ads API Response Example

```json
{
  "data": [
    {
      "campaign_id": "123456789",
      "campaign_name": "Meta_FB_Manufacturing_Nov25",
      "impressions": "234560",
      "clicks": "8110",
      "ctr": "3.46",
      "spend": "95000.00",
      "actions": [
        {
          "action_type": "lead",
          "value": "78"
        }
      ],
      "action_values": [
        {
          "action_type": "offsite_conversion.fb_pixel_purchase",
          "value": "3500000"
        }
      ]
    }
  ]
}
```

---

## Data Format & Mapping

### Your Dashboard's Expected JSON Format

```json
{
  "campaigns": [
    {
      "id": "camp_001",
      "name": "Campaign Name",
      "platform": "Google Ads" | "Meta Ads",
      "status": "Active" | "Paused" | "Ended",
      "type": "Search" | "Display" | "Video" | "Lead Gen",
      "startDate": "2024-11-01",
      "budget": 150000,
      "spend": 145000,
      "impressions": 558920,
      "clicks": 28900,
      "ctr": 5.17,
      "leads": 95,
      "qualified": 72,
      "qualificationRate": 75.8,
      "cpl": 1526,
      "cpql": 2014,
      "revenue": 6200000,
      "roi": 328
    }
  ]
}
```

### Mapping Google Ads to Dashboard Format

```javascript
function mapGoogleAdsToDashboard(googleData) {
  return {
    id: `ga_${googleData.campaign.id}`,
    name: googleData.campaign.name,
    platform: 'Google Ads',
    status: mapGoogleStatus(googleData.campaign.status),
    type: mapGoogleType(googleData.campaign.advertisingChannelType),
    startDate: googleData.campaign.startDate,
    budget: googleData.campaign.budgetAmount / 1000000,
    spend: googleData.metrics.costMicros / 1000000,
    impressions: parseInt(googleData.metrics.impressions),
    clicks: parseInt(googleData.metrics.clicks),
    ctr: googleData.metrics.ctr * 100,
    leads: googleData.metrics.conversions,
    revenue: googleData.metrics.conversionsValue
  };
}

function mapGoogleStatus(status) {
  const statusMap = {
    'ENABLED': 'Active',
    'PAUSED': 'Paused',
    'REMOVED': 'Ended'
  };
  return statusMap[status] || status;
}

function mapGoogleType(type) {
  const typeMap = {
    'SEARCH': 'Search',
    'DISPLAY': 'Display',
    'VIDEO': 'Video',
    'SHOPPING': 'Shopping',
    'MULTI_CHANNEL': 'Multi-Channel'
  };
  return typeMap[type] || type;
}
```

### Mapping Facebook Ads to Dashboard Format

```javascript
function mapFacebookAdsToDashboard(fbData, insights) {
  const leads = insights.actions?.find(
    a => a.action_type === 'lead'
  )?.value || 0;

  const revenue = insights.action_values?.find(
    a => a.action_type === 'offsite_conversion.fb_pixel_purchase'
  )?.value || 0;

  return {
    id: `fb_${fbData.id}`,
    name: fbData.name,
    platform: 'Meta Ads',
    status: mapFacebookStatus(fbData.status),
    type: mapFacebookObjective(fbData.objective),
    startDate: fbData.created_time.split('T')[0],
    spend: parseFloat(insights.spend || 0),
    impressions: parseInt(insights.impressions || 0),
    clicks: parseInt(insights.clicks || 0),
    ctr: parseFloat(insights.ctr || 0),
    leads: parseInt(leads),
    revenue: parseFloat(revenue)
  };
}

function mapFacebookStatus(status) {
  const statusMap = {
    'ACTIVE': 'Active',
    'PAUSED': 'Paused',
    'ARCHIVED': 'Ended',
    'DELETED': 'Ended'
  };
  return statusMap[status] || status;
}

function mapFacebookObjective(objective) {
  const objectiveMap = {
    'OUTCOME_LEADS': 'Lead Gen',
    'OUTCOME_SALES': 'Conversion',
    'OUTCOME_TRAFFIC': 'Traffic',
    'OUTCOME_AWARENESS': 'Awareness',
    'OUTCOME_ENGAGEMENT': 'Engagement'
  };
  return objectiveMap[objective] || objective;
}
```

---

## Backend Implementation

### Complete Backend Example (Node.js/Express)

```javascript
const express = require('express');
const cors = require('cors');
const {GoogleAdsApi} = require('google-ads-api');
const axios = require('axios');

const app = express();
app.use(cors());
app.use(express.json());

// Configuration
const config = {
  google: {
    client_id: process.env.GOOGLE_CLIENT_ID,
    client_secret: process.env.GOOGLE_CLIENT_SECRET,
    developer_token: process.env.GOOGLE_DEVELOPER_TOKEN,
    customer_id: process.env.GOOGLE_CUSTOMER_ID,
    refresh_token: process.env.GOOGLE_REFRESH_TOKEN
  },
  facebook: {
    access_token: process.env.FB_ACCESS_TOKEN,
    ad_account_id: process.env.FB_AD_ACCOUNT_ID
  }
};

// Google Ads Client
const googleAdsClient = new GoogleAdsApi({
  client_id: config.google.client_id,
  client_secret: config.google.client_secret,
  developer_token: config.google.developer_token
});

const googleCustomer = googleAdsClient.Customer({
  customer_id: config.google.customer_id,
  refresh_token: config.google.refresh_token
});

// Facebook Ads Client
class FacebookAdsAPI {
  constructor(accessToken, adAccountId) {
    this.accessToken = accessToken;
    this.adAccountId = adAccountId;
    this.baseUrl = 'https://graph.facebook.com/v18.0';
  }

  async request(endpoint, params = {}) {
    const response = await axios.get(`${this.baseUrl}${endpoint}`, {
      params: {
        ...params,
        access_token: this.accessToken
      }
    });
    return response.data;
  }
}

const fbApi = new FacebookAdsAPI(
  config.facebook.access_token,
  config.facebook.ad_account_id
);

// API Endpoints
app.get('/api/campaigns', async (req, res) => {
  try {
    const {dateFrom, dateTo, platform} = req.query;

    let campaigns = [];

    // Fetch Google Ads data
    if (!platform || platform === 'Google Ads') {
      const googleCampaigns = await fetchGoogleCampaigns(dateFrom, dateTo);
      campaigns = campaigns.concat(googleCampaigns);
    }

    // Fetch Facebook Ads data
    if (!platform || platform === 'Meta Ads') {
      const fbCampaigns = await fetchFacebookCampaigns(dateFrom, dateTo);
      campaigns = campaigns.concat(fbCampaigns);
    }

    res.json({
      success: true,
      data: {
        campaigns,
        summary: calculateSummary(campaigns)
      }
    });
  } catch (error) {
    console.error('Error fetching campaigns:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

async function fetchGoogleCampaigns(dateFrom, dateTo) {
  const query = `
    SELECT
      campaign.id,
      campaign.name,
      campaign.status,
      campaign.advertising_channel_type,
      metrics.impressions,
      metrics.clicks,
      metrics.ctr,
      metrics.cost_micros,
      metrics.conversions,
      metrics.conversions_value
    FROM campaign
    WHERE segments.date BETWEEN '${dateFrom}' AND '${dateTo}'
    ORDER BY campaign.name
  `;

  const results = await googleCustomer.query(query);

  return results.map(row => ({
    id: `ga_${row.campaign.id}`,
    name: row.campaign.name,
    platform: 'Google Ads',
    status: mapGoogleStatus(row.campaign.status),
    type: row.campaign.advertising_channel_type,
    spend: row.metrics.cost_micros / 1000000,
    impressions: parseInt(row.metrics.impressions),
    clicks: parseInt(row.metrics.clicks),
    ctr: row.metrics.ctr * 100,
    leads: row.metrics.conversions,
    revenue: row.metrics.conversions_value
  }));
}

async function fetchFacebookCampaigns(dateFrom, dateTo) {
  const campaigns = await fbApi.request(`/${fbApi.adAccountId}/campaigns`, {
    fields: 'id,name,status,objective',
    time_range: JSON.stringify({since: dateFrom, until: dateTo})
  });

  const campaignsWithInsights = await Promise.all(
    campaigns.data.map(async (campaign) => {
      const insights = await fbApi.request(`/${campaign.id}/insights`, {
        fields: 'impressions,clicks,ctr,spend,actions,action_values',
        time_range: JSON.stringify({since: dateFrom, until: dateTo})
      });

      const data = insights.data[0] || {};
      const leads = data.actions?.find(a => a.action_type === 'lead')?.value || 0;
      const revenue = data.action_values?.find(
        a => a.action_type === 'offsite_conversion.fb_pixel_purchase'
      )?.value || 0;

      return {
        id: `fb_${campaign.id}`,
        name: campaign.name,
        platform: 'Meta Ads',
        status: mapFacebookStatus(campaign.status),
        type: campaign.objective,
        spend: parseFloat(data.spend || 0),
        impressions: parseInt(data.impressions || 0),
        clicks: parseInt(data.clicks || 0),
        ctr: parseFloat(data.ctr || 0),
        leads: parseInt(leads),
        revenue: parseFloat(revenue)
      };
    })
  );

  return campaignsWithInsights;
}

function calculateSummary(campaigns) {
  const summary = campaigns.reduce((acc, campaign) => {
    acc.totalSpend += campaign.spend;
    acc.totalImpressions += campaign.impressions;
    acc.totalClicks += campaign.clicks;
    acc.totalLeads += campaign.leads;
    acc.revenue += campaign.revenue;
    return acc;
  }, {
    totalSpend: 0,
    totalImpressions: 0,
    totalClicks: 0,
    totalLeads: 0,
    revenue: 0
  });

  summary.ctr = (summary.totalClicks / summary.totalImpressions * 100).toFixed(2);
  summary.cpl = Math.round(summary.totalSpend / summary.totalLeads);
  summary.roi = Math.round((summary.revenue / summary.totalSpend - 1) * 100);

  return summary;
}

function mapGoogleStatus(status) {
  return {
    'ENABLED': 'Active',
    'PAUSED': 'Paused',
    'REMOVED': 'Ended'
  }[status] || status;
}

function mapFacebookStatus(status) {
  return {
    'ACTIVE': 'Active',
    'PAUSED': 'Paused',
    'ARCHIVED': 'Ended'
  }[status] || status;
}

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API server running on port ${PORT}`);
});
```

### Environment Variables (.env)

```bash
# Google Ads
GOOGLE_CLIENT_ID=your_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_client_secret
GOOGLE_DEVELOPER_TOKEN=your_developer_token
GOOGLE_CUSTOMER_ID=1234567890
GOOGLE_REFRESH_TOKEN=your_refresh_token

# Facebook Ads
FB_ACCESS_TOKEN=your_long_lived_access_token
FB_AD_ACCOUNT_ID=act_1234567890

# Server
PORT=3000
```

---

## Troubleshooting

### Google Ads Issues

**Issue: "Developer token is not approved"**
- Solution: Apply for developer token at ads.google.com/aw/apicenter
- Wait 24-48 hours for approval

**Issue: "Customer ID not found"**
- Solution: Verify customer ID format (remove hyphens: 123-456-7890 → 1234567890)
- Ensure you have access to the account

**Issue: "Insufficient permissions"**
- Solution: Account admin must grant API access
- Check OAuth scopes include 'adwords' scope

### Facebook Ads Issues

**Issue: "Invalid access token"**
- Solution: Generate new long-lived token
- Check token hasn't expired
- Verify app has necessary permissions

**Issue: "Ad account not found"**
- Solution: Verify ad account ID format (act_1234567890)
- Ensure system user has access to ad account
- Check Business Manager ownership

**Issue: "Rate limit exceeded"**
- Solution: Implement exponential backoff
- Cache data to reduce API calls
- Use batch requests when possible

### Common Integration Issues

**CORS Errors**
```javascript
// Add CORS headers to your backend
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'https://yourdomain.com');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});
```

**Token Refresh**
```javascript
// Automatically refresh expired tokens
async function refreshTokenIfNeeded(tokens) {
  if (Date.now() >= tokens.expiry_date) {
    const newTokens = await oauth2Client.refreshAccessToken();
    await saveTokens(newTokens.credentials);
    return newTokens.credentials;
  }
  return tokens;
}
```

---

## 📚 Additional Resources

### Official Documentation
- **Google Ads API**: https://developers.google.com/google-ads/api/docs/start
- **Meta Marketing API**: https://developers.facebook.com/docs/marketing-apis

### Libraries & SDKs
- **Google Ads Node.js**: https://www.npmjs.com/package/google-ads-api
- **Facebook Business SDK (Node.js)**: https://www.npmjs.com/package/facebook-nodejs-business-sdk
- **Python Google Ads**: https://pypi.org/project/google-ads/

### Community Support
- **Google Ads API Forum**: https://groups.google.com/g/adwords-api
- **Meta Developers Community**: https://developers.facebook.com/community/

---

## 🎯 Next Steps

1. **Set up backend server** with Node.js/Express
2. **Obtain API credentials** from both platforms
3. **Implement authentication** flows
4. **Test with sample date ranges**
5. **Store data** in your format (JSON or database)
6. **Connect dashboard** to your backend API
7. **Schedule automated data fetching** (cron jobs)

---

## 💡 Pro Tips

1. **Cache API responses** to reduce costs and improve performance
2. **Use webhooks** for real-time updates when available
3. **Implement error logging** to track API issues
4. **Set up monitoring** for token expiration
5. **Document your field mappings** for future reference
6. **Test thoroughly** with different date ranges
7. **Consider rate limits** when fetching large datasets

---

**Need Help?** Check the official documentation or community forums linked above!
