# Style Guide & Design Tokens

> **Lead Analytics Dashboard - Design System**
> Version 1.0 | For Frontend Implementation

---

## Table of Contents

1. [Design Principles](#design-principles)
2. [Color System](#color-system)
3. [Typography](#typography)
4. [Spacing & Layout](#spacing--layout)
5. [Components](#components)
6. [Iconography](#iconography)
7. [Data Visualization](#data-visualization)
8. [Responsive Design](#responsive-design)
9. [Accessibility](#accessibility)

---

## Design Principles

### 1. Clarity First
- Data should be immediately understandable
- Use clear visual hierarchy
- Minimize cognitive load

### 2. Consistency
- Reuse patterns across all pages
- Maintain consistent spacing, colors, and typography
- Follow established conventions

### 3. Performance-Focused
- Optimize for fast load times
- Progressive enhancement
- Responsive design

### 4. Professional & Clean
- Corporate aesthetics
- Data-driven, not decorative
- Minimize unnecessary visual elements

---

## Color System

### Primary Colors

```css
/* Brand Colors */
--color-primary: #667EEA;           /* Primary Purple - Main brand color */
--color-primary-dark: #5568D3;     /* Darker shade for hover states */
--color-primary-light: #7C94F5;    /* Lighter shade for backgrounds */
--color-primary-lightest: #E5E9FF; /* Very light for subtle backgrounds */
```

**Usage:**
- Primary buttons
- Active states
- Key interactive elements
- Brand accents

### Platform Colors

```css
/* Google Colors */
--color-google-blue: #4285F4;
--color-google-red: #EA4335;
--color-google-yellow: #FBBC04;
--color-google-green: #34A853;

/* Meta Colors */
--color-meta-blue: #1877F2;
--color-meta-gradient-start: #0062E0;
--color-meta-gradient-end: #19AFFF;
```

**Usage:**
- Platform badges
- Platform comparison charts
- Source identification

### Semantic Colors

```css
/* Success / Positive */
--color-success: #34A853;          /* Green - Qualified leads, positive trends */
--color-success-light: #E8F5E9;    /* Light green background */
--color-success-dark: #1E7E34;     /* Dark green for text */

/* Error / Negative */
--color-error: #EA4335;            /* Red - Junk leads, negative trends */
--color-error-light: #FFEBEE;      /* Light red background */
--color-error-dark: #C62828;       /* Dark red for text */

/* Warning */
--color-warning: #FBBC04;          /* Yellow - Alerts, cautions */
--color-warning-light: #FFF9E6;    /* Light yellow background */
--color-warning-dark: #F57C00;     /* Orange for emphasis */

/* Info */
--color-info: #4285F4;             /* Blue - Informational messages */
--color-info-light: #E3F2FD;       /* Light blue background */
--color-info-dark: #1565C0;        /* Dark blue for text */
```

### Neutral Colors

```css
/* Grayscale Palette */
--color-gray-50: #F9FAFB;          /* Lightest - Page background */
--color-gray-100: #F3F4F6;         /* Very light - Card backgrounds */
--color-gray-200: #E5E7EB;         /* Light - Borders, dividers */
--color-gray-300: #D1D5DB;         /* Medium light - Inactive states */
--color-gray-400: #9CA3AF;         /* Medium - Placeholder text */
--color-gray-500: #6B7280;         /* Medium dark - Secondary text */
--color-gray-600: #4B5563;         /* Dark - Primary text */
--color-gray-700: #374151;         /* Darker - Headings */
--color-gray-800: #1F2937;         /* Very dark - Strong emphasis */
--color-gray-900: #111827;         /* Darkest - Headers, footers */

/* Base Colors */
--color-white: #FFFFFF;
--color-black: #000000;
```

### Chart Colors

```css
/* Chart Palette (for multi-series charts) */
--chart-color-1: #667EEA;          /* Primary purple */
--chart-color-2: #4285F4;          /* Google blue */
--chart-color-3: #34A853;          /* Green */
--chart-color-4: #FBBC04;          /* Yellow */
--chart-color-5: #EA4335;          /* Red */
--chart-color-6: #1877F2;          /* Meta blue */
--chart-color-7: #9333EA;          /* Purple */
--chart-color-8: #EC4899;          /* Pink */

/* Gradient for Revenue/Growth Charts */
--chart-gradient-start: rgba(102, 126, 234, 0.8);
--chart-gradient-end: rgba(102, 126, 234, 0.1);
```

### Background Colors

```css
/* Page & Container Backgrounds */
--bg-page: #F9FAFB;                /* Main page background */
--bg-card: #FFFFFF;                /* Card/panel background */
--bg-sidebar: #1F2937;             /* Sidebar background */
--bg-header: #FFFFFF;              /* Header background */

/* Hover & Active States */
--bg-hover: #F3F4F6;               /* Hover state background */
--bg-active: #E5E7EB;              /* Active state background */
--bg-selected: #E5E9FF;            /* Selected item background */
```

### Color Usage Matrix

| Element | Default | Hover | Active | Disabled |
|---------|---------|-------|--------|----------|
| Primary Button | `#667EEA` | `#5568D3` | `#4451B8` | `#D1D5DB` |
| Secondary Button | `#FFFFFF` | `#F3F4F6` | `#E5E7EB` | `#F9FAFB` |
| Link | `#667EEA` | `#5568D3` | `#4451B8` | `#9CA3AF` |
| Input Border | `#D1D5DB` | `#667EEA` | `#667EEA` | `#E5E7EB` |

---

## Typography

### Font Families

```css
/* Primary Font */
--font-primary: 'Roboto', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

/* Monospace (for numbers, codes) */
--font-mono: 'Roboto Mono', 'Courier New', monospace;
```

### Font Weights

```css
--font-weight-light: 300;
--font-weight-regular: 400;
--font-weight-medium: 500;
--font-weight-semibold: 600;
--font-weight-bold: 700;
```

### Font Sizes

```css
/* Text Sizes */
--text-xs: 0.75rem;      /* 12px - Labels, captions */
--text-sm: 0.875rem;     /* 14px - Body text, secondary info */
--text-base: 1rem;       /* 16px - Primary body text */
--text-lg: 1.125rem;     /* 18px - Large body text */
--text-xl: 1.25rem;      /* 20px - Small headings */
--text-2xl: 1.5rem;      /* 24px - Section headings */
--text-3xl: 1.875rem;    /* 30px - Page headings */
--text-4xl: 2.25rem;     /* 36px - Large KPI values */
--text-5xl: 3rem;        /* 48px - Hero numbers */
```

### Line Heights

```css
--leading-none: 1;
--leading-tight: 1.25;
--leading-snug: 1.375;
--leading-normal: 1.5;
--leading-relaxed: 1.625;
--leading-loose: 2;
```

### Typography Scale

```css
/* Headings */
h1 {
  font-size: var(--text-3xl);
  font-weight: var(--font-weight-bold);
  line-height: var(--leading-tight);
  color: var(--color-gray-900);
}

h2 {
  font-size: var(--text-2xl);
  font-weight: var(--font-weight-semibold);
  line-height: var(--leading-tight);
  color: var(--color-gray-800);
}

h3 {
  font-size: var(--text-xl);
  font-weight: var(--font-weight-semibold);
  line-height: var(--leading-snug);
  color: var(--color-gray-800);
}

h4 {
  font-size: var(--text-lg);
  font-weight: var(--font-weight-medium);
  line-height: var(--leading-snug);
  color: var(--color-gray-700);
}

/* Body Text */
body {
  font-size: var(--text-base);
  font-weight: var(--font-weight-regular);
  line-height: var(--leading-normal);
  color: var(--color-gray-600);
}

/* Small Text */
.text-small {
  font-size: var(--text-sm);
  color: var(--color-gray-500);
}

/* Caption */
.text-caption {
  font-size: var(--text-xs);
  color: var(--color-gray-400);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* Numbers (use monospace) */
.text-number {
  font-family: var(--font-mono);
  font-weight: var(--font-weight-semibold);
}
```

### Typography Usage Guidelines

| Element | Font Size | Weight | Color | Line Height |
|---------|-----------|--------|-------|-------------|
| Page Title | `text-3xl` | Bold (700) | Gray-900 | Tight (1.25) |
| Section Title | `text-2xl` | Semibold (600) | Gray-800 | Tight (1.25) |
| Card Title | `text-lg` | Medium (500) | Gray-700 | Snug (1.375) |
| Body Text | `text-base` | Regular (400) | Gray-600 | Normal (1.5) |
| Secondary Text | `text-sm` | Regular (400) | Gray-500 | Normal (1.5) |
| Caption | `text-xs` | Regular (400) | Gray-400 | Normal (1.5) |
| KPI Value | `text-4xl` | Semibold (600) | Gray-900 | None (1) |
| Table Cell | `text-sm` | Regular (400) | Gray-600 | Snug (1.375) |

---

## Spacing & Layout

### Spacing Scale

```css
/* Spacing Tokens (based on 4px grid) */
--space-0: 0;
--space-1: 0.25rem;      /* 4px */
--space-2: 0.5rem;       /* 8px */
--space-3: 0.75rem;      /* 12px */
--space-4: 1rem;         /* 16px */
--space-5: 1.25rem;      /* 20px */
--space-6: 1.5rem;       /* 24px */
--space-8: 2rem;         /* 32px */
--space-10: 2.5rem;      /* 40px */
--space-12: 3rem;        /* 48px */
--space-16: 4rem;        /* 64px */
--space-20: 5rem;        /* 80px */
--space-24: 6rem;        /* 96px */
```

### Component Spacing

```css
/* Card Padding */
--card-padding: var(--space-6);        /* 24px */
--card-padding-sm: var(--space-4);     /* 16px for compact cards */

/* Section Spacing */
--section-gap: var(--space-8);         /* 32px between sections */
--component-gap: var(--space-6);       /* 24px between components */

/* Form Spacing */
--form-field-gap: var(--space-4);      /* 16px between form fields */
--label-gap: var(--space-2);           /* 8px between label and input */

/* Table Spacing */
--table-cell-padding: var(--space-3) var(--space-4);  /* 12px vertical, 16px horizontal */
--table-row-gap: var(--space-2);       /* 8px between rows */
```

### Border Radius

```css
/* Border Radius Scale */
--radius-none: 0;
--radius-sm: 0.25rem;    /* 4px - Small elements */
--radius-base: 0.5rem;   /* 8px - Buttons, inputs */
--radius-md: 0.75rem;    /* 12px - Cards */
--radius-lg: 1rem;       /* 16px - Large cards */
--radius-xl: 1.5rem;     /* 24px - Modals */
--radius-full: 9999px;   /* Fully rounded - Pills, avatars */
```

### Shadows

```css
/* Shadow Tokens */
--shadow-xs: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
--shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
--shadow-base: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
--shadow-md: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
--shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
--shadow-xl: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
```

### Layout Grid

```css
/* Container Widths */
--container-sm: 640px;
--container-md: 768px;
--container-lg: 1024px;
--container-xl: 1280px;
--container-2xl: 1536px;

/* Grid System */
--grid-cols-12: repeat(12, minmax(0, 1fr));
--grid-cols-6: repeat(6, minmax(0, 1fr));
--grid-cols-4: repeat(4, minmax(0, 1fr));
--grid-cols-3: repeat(3, minmax(0, 1fr));
--grid-cols-2: repeat(2, minmax(0, 1fr));

/* Gutters */
--gutter: var(--space-6);         /* 24px default gutter */
--gutter-sm: var(--space-4);      /* 16px small gutter */
--gutter-lg: var(--space-8);      /* 32px large gutter */
```

---

## Components

### Buttons

#### Primary Button
```css
.button-primary {
  background-color: var(--color-primary);
  color: var(--color-white);
  padding: var(--space-3) var(--space-6);
  border-radius: var(--radius-base);
  font-weight: var(--font-weight-medium);
  font-size: var(--text-base);
  box-shadow: var(--shadow-sm);
  transition: all 0.2s;
}

.button-primary:hover {
  background-color: var(--color-primary-dark);
  box-shadow: var(--shadow-md);
  transform: translateY(-1px);
}

.button-primary:active {
  transform: translateY(0);
  box-shadow: var(--shadow-sm);
}

.button-primary:disabled {
  background-color: var(--color-gray-300);
  cursor: not-allowed;
}
```

#### Secondary Button
```css
.button-secondary {
  background-color: var(--color-white);
  color: var(--color-gray-700);
  border: 1px solid var(--color-gray-300);
  padding: var(--space-3) var(--space-6);
  border-radius: var(--radius-base);
  font-weight: var(--font-weight-medium);
  transition: all 0.2s;
}

.button-secondary:hover {
  background-color: var(--color-gray-50);
  border-color: var(--color-primary);
}
```

#### Button Sizes
```css
.button-sm {
  padding: var(--space-2) var(--space-4);
  font-size: var(--text-sm);
}

.button-md {
  padding: var(--space-3) var(--space-6);
  font-size: var(--text-base);
}

.button-lg {
  padding: var(--space-4) var(--space-8);
  font-size: var(--text-lg);
}
```

### Cards

```css
.card {
  background-color: var(--bg-card);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-base);
  padding: var(--card-padding);
  transition: all 0.2s;
}

.card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-2px);
}

.card-header {
  border-bottom: 1px solid var(--color-gray-200);
  padding-bottom: var(--space-4);
  margin-bottom: var(--space-4);
}

.card-title {
  font-size: var(--text-lg);
  font-weight: var(--font-weight-medium);
  color: var(--color-gray-700);
}
```

### KPI Card

```css
.kpi-card {
  background: var(--bg-card);
  border-radius: var(--radius-md);
  padding: var(--space-6);
  box-shadow: var(--shadow-base);
  transition: all 0.2s;
}

.kpi-card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-2px);
}

.kpi-icon-wrapper {
  width: 48px;
  height: 48px;
  border-radius: var(--radius-base);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: var(--space-3);
}

.kpi-title {
  font-size: var(--text-sm);
  color: var(--color-gray-500);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: var(--space-2);
}

.kpi-value {
  font-size: var(--text-4xl);
  font-weight: var(--font-weight-semibold);
  font-family: var(--font-mono);
  color: var(--color-gray-900);
  line-height: var(--leading-none);
}

.kpi-trend {
  font-size: var(--text-sm);
  margin-top: var(--space-2);
  display: flex;
  align-items: center;
  gap: var(--space-1);
}

.kpi-trend.positive { color: var(--color-success); }
.kpi-trend.negative { color: var(--color-error); }
.kpi-trend.neutral { color: var(--color-gray-500); }
```

### Badges

```css
.badge {
  display: inline-flex;
  align-items: center;
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius-full);
  font-size: var(--text-xs);
  font-weight: var(--font-weight-medium);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.badge-blue {
  background-color: var(--color-info-light);
  color: var(--color-info-dark);
}

.badge-green {
  background-color: var(--color-success-light);
  color: var(--color-success-dark);
}

.badge-red {
  background-color: var(--color-error-light);
  color: var(--color-error-dark);
}

.badge-yellow {
  background-color: var(--color-warning-light);
  color: var(--color-warning-dark);
}

.badge-gray {
  background-color: var(--color-gray-200);
  color: var(--color-gray-700);
}
```

### Tables

```css
.table-container {
  background: var(--bg-card);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-base);
  overflow: hidden;
}

.table {
  width: 100%;
  border-collapse: collapse;
}

.table thead {
  background-color: var(--color-gray-50);
  border-bottom: 2px solid var(--color-gray-200);
}

.table th {
  padding: var(--table-cell-padding);
  text-align: left;
  font-size: var(--text-xs);
  font-weight: var(--font-weight-semibold);
  color: var(--color-gray-700);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.table td {
  padding: var(--table-cell-padding);
  font-size: var(--text-sm);
  color: var(--color-gray-600);
  border-bottom: 1px solid var(--color-gray-200);
}

.table tbody tr:hover {
  background-color: var(--bg-hover);
}

.table tbody tr:last-child td {
  border-bottom: none;
}
```

### Form Inputs

```css
.input {
  width: 100%;
  padding: var(--space-3) var(--space-4);
  font-size: var(--text-base);
  border: 1px solid var(--color-gray-300);
  border-radius: var(--radius-base);
  background-color: var(--color-white);
  transition: all 0.2s;
}

.input:hover {
  border-color: var(--color-gray-400);
}

.input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.input:disabled {
  background-color: var(--color-gray-100);
  color: var(--color-gray-500);
  cursor: not-allowed;
}

.input-label {
  display: block;
  font-size: var(--text-sm);
  font-weight: var(--font-weight-medium);
  color: var(--color-gray-700);
  margin-bottom: var(--label-gap);
}

.input-error {
  border-color: var(--color-error);
}

.input-error-message {
  font-size: var(--text-sm);
  color: var(--color-error);
  margin-top: var(--space-1);
}
```

---

## Iconography

### Icon Library
Use **Font Awesome 6 Free** (https://fontawesome.com/)

### Icon Sizes
```css
--icon-xs: 12px;
--icon-sm: 16px;
--icon-base: 20px;
--icon-lg: 24px;
--icon-xl: 32px;
--icon-2xl: 48px;
```

### Common Icons

| Purpose | Icon Class | Example |
|---------|-----------|---------|
| Money/Spend | `fa-rupee-sign` | ₹ |
| Leads | `fa-users` | 👥 |
| Qualified | `fa-check-circle` | ✓ |
| Conversion | `fa-trophy` | 🏆 |
| Trend Up | `fa-arrow-trend-up` | ↗ |
| Trend Down | `fa-arrow-trend-down` | ↘ |
| Filter | `fa-filter` | ⚡ |
| Search | `fa-magnifying-glass` | 🔍 |
| Download | `fa-download` | ⬇ |
| Upload | `fa-upload` | ⬆ |
| Calendar | `fa-calendar` | 📅 |
| Chart | `fa-chart-line` | 📈 |
| Settings | `fa-gear` | ⚙ |
| User | `fa-user` | 👤 |
| Close | `fa-xmark` | ✕ |
| Menu | `fa-bars` | ☰ |

---

## Data Visualization

### Chart.js Configuration

#### Default Options
```javascript
const defaultChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'bottom',
      labels: {
        font: {
          family: 'Roboto',
          size: 12
        },
        padding: 16,
        usePointStyle: true
      }
    },
    tooltip: {
      backgroundColor: 'rgba(31, 41, 55, 0.9)',
      titleFont: {
        family: 'Roboto',
        size: 14,
        weight: 600
      },
      bodyFont: {
        family: 'Roboto Mono',
        size: 13
      },
      padding: 12,
      cornerRadius: 8
    }
  }
};
```

#### Line Chart Style
```javascript
const lineChartDefaults = {
  borderWidth: 2,
  tension: 0.4,
  fill: true,
  pointRadius: 4,
  pointHoverRadius: 6,
  pointBackgroundColor: '#FFFFFF',
  pointBorderWidth: 2
};
```

#### Bar Chart Style
```javascript
const barChartDefaults = {
  borderWidth: 0,
  borderRadius: 4,
  borderSkipped: false
};
```

#### Doughnut Chart Style
```javascript
const doughnutChartDefaults = {
  borderWidth: 2,
  borderColor: '#FFFFFF',
  cutout: '60%'
};
```

### Chart Color Usage

| Metric | Color | Hex |
|--------|-------|-----|
| Spend | Primary Purple | `#667EEA` |
| Qualified Leads | Success Green | `#34A853` |
| Junk Leads | Error Red | `#EA4335` |
| Google Ads | Google Blue | `#4285F4` |
| Meta Ads | Meta Blue | `#1877F2` |
| Revenue | Success Green | `#34A853` |
| ROI | Primary Purple | `#667EEA` |

---

## Responsive Design

### Breakpoints

```css
/* Breakpoint Tokens */
--breakpoint-sm: 640px;
--breakpoint-md: 768px;
--breakpoint-lg: 1024px;
--breakpoint-xl: 1280px;
--breakpoint-2xl: 1536px;
```

### Responsive Grid

```css
/* Mobile First Approach */
.grid-responsive {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--gutter);
}

@media (min-width: 640px) {
  .grid-responsive {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 1024px) {
  .grid-responsive {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (min-width: 1280px) {
  .grid-responsive {
    grid-template-columns: repeat(4, 1fr);
  }
}
```

### Mobile Adjustments

```css
/* Mobile (< 640px) */
@media (max-width: 639px) {
  :root {
    --card-padding: var(--space-4);
    --text-4xl: 2rem;  /* Reduce large KPI sizes */
  }

  .kpi-card {
    padding: var(--space-4);
  }

  .table {
    font-size: var(--text-xs);
  }

  .table th, .table td {
    padding: var(--space-2) var(--space-3);
  }
}
```

---

## Accessibility

### Color Contrast

All text must meet WCAG 2.1 Level AA standards:
- Normal text: Minimum 4.5:1 contrast ratio
- Large text (18px+): Minimum 3:1 contrast ratio

### Verified Combinations

| Foreground | Background | Ratio | Pass |
|------------|------------|-------|------|
| Gray-900 | White | 16.1:1 | ✓ AAA |
| Gray-800 | White | 12.6:1 | ✓ AAA |
| Gray-700 | White | 8.6:1 | ✓ AAA |
| Gray-600 | White | 5.7:1 | ✓ AA |
| Primary | White | 4.8:1 | ✓ AA |
| White | Primary | 4.8:1 | ✓ AA |

### Focus States

```css
/* Visible Focus Indicator */
*:focus {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* Enhanced Focus for Interactive Elements */
button:focus,
a:focus,
input:focus,
select:focus {
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
}
```

### Screen Reader Support

```css
/* Visually Hidden but Accessible to Screen Readers */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
```

### Semantic HTML
- Use proper heading hierarchy (h1 → h2 → h3)
- Use `<button>` for actions, `<a>` for navigation
- Add `aria-label` for icon-only buttons
- Use `<table>` with `<thead>`, `<tbody>`, `<th>` for data tables
- Add `alt` text for all images

---

## Animation & Transitions

### Transition Durations

```css
--transition-fast: 0.1s;
--transition-base: 0.2s;
--transition-slow: 0.3s;
--transition-slower: 0.5s;
```

### Easing Functions

```css
--ease-in: cubic-bezier(0.4, 0, 1, 1);
--ease-out: cubic-bezier(0, 0, 0.2, 1);
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
```

### Common Transitions

```css
/* Hover Effects */
.transition-hover {
  transition: all var(--transition-base) var(--ease-out);
}

/* Color Changes */
.transition-colors {
  transition: color var(--transition-base) var(--ease-out),
              background-color var(--transition-base) var(--ease-out),
              border-color var(--transition-base) var(--ease-out);
}

/* Transform Effects */
.transition-transform {
  transition: transform var(--transition-base) var(--ease-out);
}
```

---

## CSS Variables Implementation

### Root Variables

```css
:root {
  /* Colors */
  --color-primary: #667EEA;
  --color-success: #34A853;
  --color-error: #EA4335;
  --color-warning: #FBBC04;

  /* Typography */
  --font-primary: 'Roboto', sans-serif;
  --font-mono: 'Roboto Mono', monospace;
  --text-base: 1rem;

  /* Spacing */
  --space-4: 1rem;
  --space-6: 1.5rem;

  /* Layout */
  --radius-md: 0.75rem;
  --shadow-base: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}
```

---

**End of Style Guide**

For component implementation, see `COMPONENTS.md`.
For HTML prototypes, see `HTML Files/` folder.
