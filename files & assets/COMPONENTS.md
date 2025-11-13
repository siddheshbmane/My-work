# Component Library Documentation

> **Lead Analytics Dashboard - Reusable UI Components**
> Version 1.0 | For React/TypeScript Implementation

---

## Overview

This document describes all reusable UI components extracted from the HTML prototype. Use this as a reference to build your React component library.

---

## 1. KPI Card Component

### Description
Displays a single key performance indicator with icon, value, trend indicator, and optional breakdown.

### Visual Reference
See `HTML Files/index.html` - Lines with class `kpi-card`

### Props/Interface
```typescript
interface KPICardProps {
  title: string;              // e.g., "Total Spend"
  value: string | number;     // Main value to display
  icon: string;               // FontAwesome icon class
  iconBgColor?: string;       // Background color for icon (default: bg-blue-100)
  iconColor?: string;         // Icon color (default: text-blue-600)
  trend?: {
    direction: 'up' | 'down' | 'neutral';
    value: number;           // Percentage change
    label: string;           // e.g., "vs last period"
  };
  breakdown?: {
    label: string;
    value: string | number;
  }[];
  isCurrency?: boolean;      // Format as currency
  isPercentage?: boolean;    // Format as percentage
}
```

### Example Usage
```typescript
<KPICard
  title="Total Spend"
  value={1245000}
  icon="fa-rupee-sign"
  iconBgColor="bg-blue-100"
  iconColor="text-blue-600"
  isCurrency={true}
  trend={{
    direction: 'up',
    value: 12.5,
    label: 'vs last period'
  }}
/>
```

### Styling
```css
.kpi-card {
  background: white;
  border-radius: 0.75rem;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  padding: 1.5rem;
  transition: transform 0.2s, box-shadow 0.2s;
}

.kpi-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0,0,0,0.1);
}
```

---

## 2. Chart Component

### Description
Wrapper component for Chart.js charts with consistent styling and configuration.

### Props/Interface
```typescript
interface ChartProps {
  type: 'line' | 'bar' | 'doughnut' | 'radar' | 'pie';
  data: ChartData;
  options?: ChartOptions;
  height?: number;          // Default: 300
  title?: string;
  showLegend?: boolean;     // Default: true
  legendPosition?: 'top' | 'bottom' | 'left' | 'right';
}

interface ChartData {
  labels: string[];
  datasets: Dataset[];
}

interface Dataset {
  label: string;
  data: number[];
  backgroundColor?: string | string[];
  borderColor?: string;
  borderWidth?: number;
  tension?: number;        // For line charts
  fill?: boolean;
}
```

### Example Usage
```typescript
<Chart
  type="bar"
  title="Lead Quality by Platform"
  data={{
    labels: ['Google Ads', 'Meta Ads'],
    datasets: [
      {
        label: 'Qualified',
        data: [342, 270],
        backgroundColor: '#34A853'
      },
      {
        label: 'Junk',
        data: [123, 112],
        backgroundColor: '#EA4335'
      }
    ]
  }}
  options={{
    scales: {
      x: { stacked: true },
      y: { stacked: true, beginAtZero: true }
    }
  }}
  legendPosition="bottom"
/>
```

### Standard Chart Configurations
```typescript
// Line Chart (Trends)
const lineChartDefaults = {
  tension: 0.4,
  fill: true,
  pointRadius: 4,
  pointHoverRadius: 6
};

// Bar Chart (Comparisons)
const barChartDefaults = {
  borderWidth: 0,
  borderRadius: 4
};

// Doughnut Chart (Distributions)
const doughnutChartDefaults = {
  borderWidth: 2,
  borderColor: '#fff',
  cutout: '60%'
};
```

---

## 3. Data Table Component

### Description
Interactive table with sorting, filtering, search, and expandable rows.

### Props/Interface
```typescript
interface DataTableProps<T> {
  data: T[];
  columns: Column<T>[];
  searchable?: boolean;
  sortable?: boolean;
  filterable?: boolean;
  expandable?: boolean;
  pagination?: {
    enabled: boolean;
    pageSize: number;
    currentPage: number;
    onPageChange: (page: number) => void;
  };
  onRowClick?: (row: T) => void;
  loading?: boolean;
  emptyState?: React.ReactNode;
}

interface Column<T> {
  key: keyof T;
  header: string;
  sortable?: boolean;
  render?: (value: any, row: T) => React.ReactNode;
  width?: string;
  align?: 'left' | 'center' | 'right';
}
```

### Example Usage
```typescript
<DataTable
  data={campaigns}
  columns={[
    {
      key: 'campaign_name',
      header: 'Campaign Name',
      sortable: true,
      render: (name) => <span className="font-medium">{name}</span>
    },
    {
      key: 'platform',
      header: 'Platform',
      render: (platform) => (
        <Badge color={platform === 'google' ? 'blue' : 'indigo'}>
          {platform}
        </Badge>
      )
    },
    {
      key: 'spend',
      header: 'Spend',
      sortable: true,
      align: 'right',
      render: (spend) => formatCurrency(spend)
    },
    {
      key: 'roi',
      header: 'ROI',
      sortable: true,
      render: (roi) => <Badge color="green">{roi}%</Badge>
    }
  ]}
  searchable
  sortable
  pagination={{
    enabled: true,
    pageSize: 50,
    currentPage: 1,
    onPageChange: (page) => setCurrentPage(page)
  }}
/>
```

### Features to Implement
```typescript
// Search functionality
const handleSearch = (query: string) => {
  const filtered = data.filter(row =>
    Object.values(row).some(value =>
      String(value).toLowerCase().includes(query.toLowerCase())
    )
  );
  setFilteredData(filtered);
};

// Sorting functionality
const handleSort = (columnKey: string) => {
  const sorted = [...data].sort((a, b) => {
    const aVal = a[columnKey];
    const bVal = b[columnKey];
    
    // Numeric sort
    if (typeof aVal === 'number' && typeof bVal === 'number') {
      return sortDirection === 'asc' ? aVal - bVal : bVal - aVal;
    }
    
    // String sort
    return sortDirection === 'asc' 
      ? String(aVal).localeCompare(String(bVal))
      : String(bVal).localeCompare(String(aVal));
  });
  
  setSortedData(sorted);
  setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc');
};

// Expandable rows
const handleRowExpand = (rowId: string) => {
  setExpandedRows(prev => 
    prev.includes(rowId)
      ? prev.filter(id => id !== rowId)
      : [...prev, rowId]
  );
};
```

---

## 4. Filter Bar Component

### Description
Filter controls for date range, client selection, platform, and custom filters.

### Props/Interface
```typescript
interface FilterBarProps {
  dateRange?: {
    from: Date;
    to: Date;
    onChange: (from: Date, to: Date) => void;
    presets?: DatePreset[];
  };
  clientSelector?: {
    clients: Client[];
    selected: string | null;
    onChange: (clientId: string) => void;
  };
  platformFilter?: {
    options: PlatformOption[];
    selected: string;
    onChange: (platform: string) => void;
  };
  customFilters?: CustomFilter[];
  onSearch?: (query: string) => void;
  onReset?: () => void;
}

interface DatePreset {
  label: string;
  value: string;  // 'today', 'yesterday', '7days', '30days', etc.
  from: Date;
  to: Date;
}

interface PlatformOption {
  value: string;
  label: string;
}

interface CustomFilter {
  key: string;
  label: string;
  type: 'select' | 'multiselect' | 'range';
  options?: any[];
  value: any;
  onChange: (value: any) => void;
}
```

### Example Usage
```typescript
<FilterBar
  dateRange={{
    from: new Date('2025-10-12'),
    to: new Date('2025-11-11'),
    onChange: (from, to) => handleDateChange(from, to),
    presets: [
      { label: 'Last 7 Days', value: '7days', from: ..., to: ... },
      { label: 'Last 30 Days', value: '30days', from: ..., to: ... },
      { label: 'This Month', value: 'thismonth', from: ..., to: ... }
    ]
  }}
  clientSelector={{
    clients: clientList,
    selected: selectedClientId,
    onChange: (id) => setSelectedClientId(id)
  }}
  platformFilter={{
    options: [
      { value: 'all', label: 'All Platforms' },
      { value: 'google', label: 'Google Ads' },
      { value: 'meta', label: 'Meta Ads' }
    ],
    selected: 'all',
    onChange: (platform) => setPlatform(platform)
  }}
  onSearch={(query) => handleSearch(query)}
/>
```

---

## 5. Loading States Component

### Description
Loading indicators for different scenarios.

### Props/Interface
```typescript
interface LoadingStateProps {
  type: 'spinner' | 'skeleton' | 'progress';
  message?: string;
  size?: 'sm' | 'md' | 'lg';
}

interface SkeletonProps {
  count?: number;
  height?: number;
  width?: string | number;
  borderRadius?: number;
}
```

### Example Usage
```typescript
// Spinner
<LoadingState
  type="spinner"
  message="Loading client data..."
  size="lg"
/>

// Skeleton (for table rows)
<Skeleton count={5} height={40} />

// Progress bar
<LoadingState type="progress" message="Uploading file..." />
```

### Skeleton Implementation
```typescript
const Skeleton: React.FC<SkeletonProps> = ({ count = 1, height = 20, width = '100%', borderRadius = 4 }) => {
  return (
    <>
      {Array.from({ length: count }).map((_, i) => (
        <div
          key={i}
          className="skeleton"
          style={{
            height: `${height}px`,
            width,
            borderRadius: `${borderRadius}px`,
            background: 'linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%)',
            backgroundSize: '200% 100%',
            animation: 'loading 1.5s infinite'
          }}
        />
      ))}
    </>
  );
};
```

---

## 6. Empty State Component

### Description
Display when no data is available.

### Props/Interface
```typescript
interface EmptyStateProps {
  icon: string;              // FontAwesome icon
  title: string;
  message: string;
  action?: {
    label: string;
    onClick: () => void;
  };
}
```

### Example Usage
```typescript
<EmptyState
  icon="fa-inbox"
  title="No Client Selected"
  message="Please select a client from the dropdown above to view their performance data."
  action={{
    label: "Select Client",
    onClick: () => openClientSelector()
  }}
/>
```

---

## 7. Error State Component

### Description
Display for error scenarios with retry capability.

### Props/Interface
```typescript
interface ErrorStateProps {
  icon?: string;             // Default: 'fa-exclamation-triangle'
  title: string;
  message: string;
  errorCode?: string;
  onRetry?: () => void;
  onDismiss?: () => void;
}
```

### Example Usage
```typescript
<ErrorState
  title="Error Loading Data"
  message="Unable to load client performance data. Please try again."
  errorCode="ERR_NETWORK_FAILURE"
  onRetry={() => loadClientData()}
/>
```

---

## 8. Badge Component

### Description
Small label for statuses, categories, and tags.

### Props/Interface
```typescript
interface BadgeProps {
  children: React.ReactNode;
  color?: 'blue' | 'green' | 'red' | 'yellow' | 'purple' | 'gray';
  size?: 'sm' | 'md' | 'lg';
  variant?: 'filled' | 'outlined' | 'pill';
}
```

### Example Usage
```typescript
<Badge color="green" variant="pill">Active</Badge>
<Badge color="blue">Google Ads</Badge>
<Badge color="red" variant="outlined">Junk</Badge>
```

---

## 9. Button Component

### Description
Primary and secondary action buttons.

### Props/Interface
```typescript
interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  icon?: string;             // FontAwesome icon
  iconPosition?: 'left' | 'right';
  loading?: boolean;
  disabled?: boolean;
  onClick?: () => void;
  type?: 'button' | 'submit' | 'reset';
}
```

### Example Usage
```typescript
<Button
  variant="primary"
  icon="fa-upload"
  iconPosition="left"
  onClick={() => handleUpload()}
>
  Upload File
</Button>

<Button
  variant="outline"
  icon="fa-file-excel"
  iconPosition="left"
  loading={isExporting}
>
  Export Excel
</Button>
```

---

## 10. Expandable Row Component

### Description
Table row that expands to show child content.

### Props/Interface
```typescript
interface ExpandableRowProps {
  level: number;             // Hierarchy level (1, 2, 3)
  isExpanded: boolean;
  onToggle: () => void;
  children: React.ReactNode;
  expandedContent?: React.ReactNode;
}
```

### Example Usage
```typescript
<ExpandableRow
  level={1}
  isExpanded={isExpanded}
  onToggle={() => toggleExpand(campaignId)}
  expandedContent={
    <AdGroupsTable campaignId={campaignId} />
  }
>
  <td>Campaign Name</td>
  <td>{spend}</td>
  <td>{leads}</td>
</ExpandableRow>
```

---

## Utility Functions

### Currency Formatting
```typescript
export const formatCurrency = (value: number, currency = 'INR'): string => {
  if (currency === 'INR') {
    return `₹${value.toLocaleString('en-IN')}`;
  }
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: currency
  }).format(value);
};
```

### Percentage Formatting
```typescript
export const formatPercentage = (value: number, decimals = 1): string => {
  return `${value.toFixed(decimals)}%`;
};
```

### Number Abbreviation
```typescript
export const abbreviateNumber = (value: number): string => {
  if (value >= 10000000) return `₹${(value / 10000000).toFixed(2)}Cr`;
  if (value >= 100000) return `₹${(value / 100000).toFixed(2)}L`;
  if (value >= 1000) return `₹${(value / 1000).toFixed(2)}K`;
  return `₹${value}`;
};
```

### Date Formatting
```typescript
export const formatDate = (date: Date, format = 'MMM DD, YYYY'): string => {
  // Use date-fns or similar library
  return format(date, format);
};
```

---

## Component Architecture Best Practices

### 1. Atomic Design
```
Atoms: Badge, Button, Icon, Input
Molecules: KPICard, FilterDropdown, SearchBox
Organisms: DataTable, FilterBar, Chart
Templates: DashboardLayout, ReportLayout
Pages: MasterSummary, ClientDeepDive, etc.
```

### 2. State Management
```typescript
// Use Context for global state
const DashboardContext = createContext({
  dateRange: { from: Date, to: Date },
  selectedClient: string | null,
  filters: Filters
});

// Use component state for local UI state
const [isExpanded, setIsExpanded] = useState(false);
```

### 3. Error Boundaries
```typescript
class ErrorBoundary extends React.Component {
  componentDidCatch(error, errorInfo) {
    logErrorToService(error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return <ErrorState title="Something went wrong" />;
    }
    return this.props.children;
  }
}
```

---

## Testing Guidelines

### Component Tests
```typescript
describe('KPICard', () => {
  it('displays correct value and title', () => {
    render(<KPICard title="Total Spend" value={1245000} />);
    expect(screen.getByText('Total Spend')).toBeInTheDocument();
    expect(screen.getByText('₹12,45,000')).toBeInTheDocument();
  });
  
  it('shows trend indicator when provided', () => {
    render(
      <KPICard
        title="ROI"
        value={267}
        trend={{ direction: 'up', value: 15.3, label: 'vs last period' }}
      />
    );
    expect(screen.getByText('↑ 15.3%')).toBeInTheDocument();
  });
});
```

---

**End of Component Documentation**

For implementation questions, refer to the HTML prototype in `HTML Files/` folder.
