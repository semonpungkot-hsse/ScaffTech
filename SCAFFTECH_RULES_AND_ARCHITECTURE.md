# ScaffTech - Industrial Scaffolding Visual Tracker & HSE Management Platform

## 1. Executive Summary & Overview
**ScaffTech** is an enterprise-grade scaffolding management and HSE compliance application built for heavy industrial construction, petrochemical plants, and infrastructure projects. It eliminates unmapped scaffolding hazards by bridging **GIS-style visual route plan plotting** with a **real-time relational database (Supabase)**.

The system is deployed as two synchronized web applications:
1. [**`mapping.html`**](file:///c:/Users/Rully/Documents/Rully%20Beriandi/Scaffolding/mapping.html) — **ScaffTech Mapping**: Interactive Greenfield Traffic Route Plan map canvas with pan/zoom navigation, live multi-point linear scaffold drawing, point pinning, beacon HSE status pulsing, layer controls, and bi-directional Supabase cloud replication.
2. [**`database.html`**](file:///c:/Users/Rully/Documents/Rully%20Beriandi/Scaffolding/database.html) — **ScaffTech Database**: Tabular management center providing real-time multi-user CRUD operations, HSE 7-day inspection tracking, quick inspection approvals, Excel `.xlsx` import/export, and coordinate integrity locking.

---

## 2. Core Business Rules & Operational Specifications

### 2.1 100% Mandatory Greenfield Landmark Rule
To eliminate discrepancies between physical site locations, project engineering drawings, and database records, arbitrary text locations are prohibited.

- **Point Scaffolds (Towers):**
  - Location **MUST** be chosen from the verified Greenfield Traffic Route Plan landmarks (`MAP_RED_LOCATIONS`).
  - Predefined landmarks include electrical substations (`SUB 524`, `SUB 520`, `SUB 513`, `SUB 521`, `SUB 580`, `SUB 522`), process units (`UNIT 542`, `UNIT 543`, `UNIT 544`, `UNIT 537`, `UNIT 566`, `UNIT 571`, `UNIT 500`, `UNIT 518/517/516`), utility areas (`U-562`, `U-567`, `IES-514`), medical facilities (`CLINIC`, `JV AMBULANCE PARKING`), and security access gates (`GATE-02`, `GATE-02A`, `GATE-03`, `GATE-03A`).
  
- **Linear Scaffolds (Pipe Racks & Spans):**
  - Scaffolds traversing multiple zones **MUST** explicitly state origin and destination using the **"From Landmark $\rightarrow$ To Landmark"** syntax (e.g., `UNIT 543 -> UNIT 544`).
  - Both origin and destination are selected via mandatory dropdown pickers.

### 2.2 Strict Map Coordinate Accuracy Rule
Every scaffolding unit in the database **MUST** have verified coordinates mapped on the Greenfield route plan canvas:
- **Point Scaffolds:** Fixed normalized coordinates $(x, y)$ expressed as percentages ($0.0\% - 100.0\%$) relative to the master route plan image.
- **Linear Scaffolds:** Ordered sequence of point vertices $[(x_1, y_1), (x_2, y_2), \dots, (x_n, y_n)]$ stored as a JSON array representing the exact route path.
- In `database.html`, saving a new scaffold or modifying location coordinates automatically binds the position to the physical coordinate system of the chosen landmark to guarantee zero unmapped entries.

### 2.3 Strict HSE 7-Day Inspection Cycle Rule
Under international construction standards (OSHA 1926.451 / BS EN 12811 / PERMENAKER 01/1980):
- Scaffolding inspections are legally valid for **maximum 7 calendar days**.
- Every unit records `installDate` (erection date) and `lastInspection` (date of most recent inspection).
- **Inspection Status Hierarchy:**
  1. **ACTIVE (Green Tag):** $\Delta \text{days} \le 5 \text{ days}$. Safe for worker access.
  2. **URGENT ATTENTION (Amber Warning):** $5 < \Delta \text{days} \le 7 \text{ days}$ ($\le 2 \text{ days remaining}$). HSE inspectors are alerted with high-visibility pulsing beacon badges.
  3. **EXPIRED (Red Tag):** $\Delta \text{days} > 7 \text{ days}$ or explicitly tagged `EXPIRED`. **Access strictly prohibited**; beacon pulses with red alert ring and dashed warning border.
  4. **DISMANTLED:** Scaffolding dismantled and archived. Excluded from active inspection count.
- **1-Click "Loloskan Inspeksi" (Pass Inspection):** Updates `lastInspection` to the current date ($+7 \text{ days}$ of validity) and restores `ACTIVE` status in both local memory and Supabase cloud.

---

## 3. Architecture & File Structure

```
c:\Users\Rully\Documents\Rully Beriandi\Scaffolding\
├── mapping.html               # ScaffTech Mapping (Visual GIS canvas, plotting & tracking)
├── database.html              # ScaffTech Database (Tabular data, full CRUD & HSE audit)
├── supabase_schema.sql        # Supabase PostgreSQL DDL, RLS policies & triggers
└── SCAFFTECH_RULES_AND_ARCHITECTURE.md  # System specification & architectural manual
```

### Technology Stack:
- **Runtime:** Native browser execution (Zero npm/Node build steps, run directly via browser or web server).
- **Frontend Core:** React 18 (via UMD), ReactDOM 18, Babel Standalone.
- **Styling & Design System:** Tailwind CSS CDN customized with curated Sky/Brand palettes (`#0284c7`, `#0369a1`) and clean GIS vertical rail architecture.
- **Language & Localization:** 100% English interface across all tooltips, labels, modals, KPI badges, table headers, and status indicators.
- **Icons & UI Actions:** Lucide Icons CDN with compact, high-efficiency icon action clusters (`Pass`, `Map`, `Edit`, `Delete`) with descriptive tooltips for clean, uncluttered layout.
- **Data Exchange:** SheetJS (`xlsx.full.min.js`) for full Excel `.xlsx` report export and multi-record import.
- **Backend & Cloud Replication:** Supabase JS v2 Client (`@supabase/supabase-js@2`) with PostgreSQL Realtime change listeners.

---

## 4. Supabase Database Schema

### Table: `public.scaffolds`
| Column Name | SQL Type | Nullable | Default | Description |
| :--- | :--- | :---: | :---: | :--- |
| `id` | `TEXT` | **NO** | Primary Key | Unique scaffold identifier (e.g., `SCF-101`) |
| `tag_number` | `TEXT` | **NO** | — | Physical tag number on site (e.g., `TAG-GRN-001`) |
| `location` | `TEXT` | **NO** | `''` | Landmark or route span (e.g., `UNIT 543 -> UNIT 544`) |
| `type` | `TEXT` | **NO** | `'POINT'` | Type of structure (`POINT` or `LINEAR`) |
| `status` | `TEXT` | **NO** | `'BUILDING'` | HSE tag status (`ACTIVE`, `BUILDING`, `REQUESTED`, `EXPIRED`, `DISMANTLED`) |
| `x` | `DOUBLE PRECISION`| YES | `NULL` | X-coordinate on master plan ($0 - 100\%$) |
| `y` | `DOUBLE PRECISION`| YES | `NULL` | Y-coordinate on master plan ($0 - 100\%$) |
| `points` | `JSONB` | YES | `NULL` | Array of path coordinates `[{"x": 34.2, "y": 42.3}, ...]` |
| `install_date` | `TEXT` | YES | `NULL` | Initial erection date (`YYYY-MM-DD`) |
| `last_inspection` | `TEXT` | YES | `NULL` | Most recent HSE inspection date (`YYYY-MM-DD`) |
| `target_dismantle_date` | `TEXT`| YES| `NULL` | Target scheduled removal date |
| `actual_dismantle_date` | `TEXT`| YES| `NULL` | Actual removal completion date |
| `inspector` | `TEXT` | YES | `''` | Name or badge of the HSE inspector |
| `notes` | `TEXT` | YES | `''` | Field inspection notes, load capacity, permits |
| `structure_type` | `TEXT` | YES | `''` | Scaffolding category (e.g., `Independent Tower`, `Pipe Rack`) |
| `height_meters` | `TEXT` | YES | `''` | Structural height (e.g., `12m`) |
| `length_meters` | `TEXT` | YES | `''` | Linear span length (e.g., `65 meter`) |
| `created_at` | `TIMESTAMPTZ` | **NO** | `NOW()` | Timestamp of record creation |
| `updated_at` | `TIMESTAMPTZ` | **NO** | `NOW()` | Automatically updated via PostgreSQL trigger |

---

## 5. Security & Multi-User Realtime Integration

### Configuration:
- **Project URL:** `https://zlstjvxirzxaghbcmbod.supabase.co`
- **Publishable Key:** `sb_publishable_6ROp0xv_X1sMtNGGaLsrsg_bPfe_xtA`
- **Security Rule:** Secret Service Role keys (`sb_secret_...`) are strictly excluded from client-facing HTML files to preserve project security.
- **Row Level Security (RLS):** Enabled on `public.scaffolds` with open public CRUD policies for authenticated and anonymous site inspectors.
- **Realtime Replication:** Configured with `ALTER PUBLICATION supabase_realtime ADD TABLE public.scaffolds;` to push immediate `INSERT`, `UPDATE`, and `DELETE` changes across multiple connected tablets or desktop workstations simultaneously.

---

## 6. User Guide: Plotting and Managing Scaffolds

### How to Plot Scaffolds on the Map (`mapping.html`):
1. **Left Vertical Navigation Rail:**
   - **Database Link (`Table` icon):** Jump directly to `database.html`.
   - **Pointer / Pan Mode (`Mouse-Pointer` icon):** Drag and inspect the blueprint canvas.
   - **Point Scaffold Pin (`Map-Pin-Plus` icon):** Activate point plotting mode. Click on canvas to drop a tower pin, select a mandatory landmark from the dropdown, fill inspection dates, and save.
   - **Linear Route Mode (`Git-Commit` icon):** Activate multi-point linear plotting. Click consecutive nodes along the pipe rack corridor, click **"Finish Route"**, select **From Landmark** and **To Landmark**, and save.
   - **Layers Popover (`Sliders-Horizontal` icon):** Toggle landmark labels, point pins, linear spans, ID labels, alarm pulses, tooltips, or switch quickly between presets (**All Active**, **Zen Mode**, **HSE Focus**).
   - **Reset View (`Maximize-2` icon):** Instantly reset canvas scale to 100%.
   - **Upload Custom Blueprint (`Image-Up` icon):** Load custom site CAD or drone aerial layouts.
   - **Restore Official Greenfield Plan (`Rotate-CCW` icon):** Reset canvas to the master traffic route plan.
   - **Excel Hub, JSON Backup, Supabase Cloud & Clear:** Located at the bottom of the vertical rail.

2. **Top Header & Search:**
   - **Fast Landmark Jump:** Select any substation, unit, or gate to pan and zoom straight to that zone.
   - **Register Sidebar Toggle:** Collapsible side register for browsing active scaffolds with quick search and filters.

### How to Inspect and Audit in the Database (`database.html`):
1. **Compact Action Icons:**
   - **Pass Inspection (`Check` green icon):** Instantly verifies the unit, stamps today's date, and resets 7-day inspection validity to ACTIVE.
   - **View on Map (`Compass` blue icon):** Direct deep-link to view the scaffold on the GIS map.
   - **Edit Record (`Pencil` indigo icon):** Modify inspector, permits, remarks, or structure dimensions with locked coordinates.
   - **Delete Record (`Trash` rose icon):** Remove scaffold record with automatic cloud deletion.
2. **Filtering & Search:** Real-time search across ID, tag, location, and inspector, with KPI overview cards and status tabs.
3. **Data Exchange:** One-click **Export Excel** (`.xlsx`), **Import Excel**, and **Supabase Cloud Sync**.
