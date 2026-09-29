# ScaffTech Pro - Industrial Scaffolding Visual Tracker & HSE Management Platform

## 1. Executive Summary & Overview
**ScaffTech Pro** is an enterprise-grade scaffolding management and HSE compliance application built for heavy industrial construction, petrochemical plants, and infrastructure projects. It eliminates unmapped scaffolding hazards by bridging **GIS-style visual route plan plotting** with a **real-time relational database (Supabase PostgreSQL)**, **printable QR Scafftag generator**, and **live camera field inspection scanner**.

The system is deployed as a unified full-stack web platform:
1. [**`index.html`**](file:///c:/Users/Rully/Documents/Rully%20Beriandi/Scaffolding/index.html) — **Executive Command Portal**: High-level real-time KPI overview synchronized with Supabase, universal search bar, live camera QR scanner, and direct deep-linking launchers.
2. [**`mapping.html`**](file:///c:/Users/Rully/Documents/Rully%20Beriandi/Scaffolding/mapping.html) — **GIS Visual Mapping**: Interactive Greenfield Traffic Route Plan map canvas with pan/zoom navigation, live multi-point linear scaffold drawing, point pinning, beacon HSE status pulsing, layer controls, and bi-directional Supabase cloud replication.
3. [**`database.html`**](file:///c:/Users/Rully/Documents/Rully%20Beriandi/Scaffolding/database.html) — **HSE Audit & Database Center**: Tabular management center providing real-time multi-user CRUD operations, HSE 7-day inspection tracking, quick inspection approvals, printable physical Scafftag QR cards, Excel `.xlsx` import/export, and coordinate integrity locking.
4. [**`server.js`**](file:///c:/Users/Rully/Documents/Rully%20Beriandi/Scaffolding/server.js) — **Zero-Dependency Production HTTP Server**: Built-in Node.js server with `/api/health` monitoring, security headers, and static file streaming.

---

## 2. Core Business Rules & Operational Specifications

### 2.1 Guaranteed Anti-Duplicate Numbering Engine
To guarantee zero collisions across hundreds of scaffolding units:
- **Point Tower Scaffolds:** Follows the standard pattern `SCF-26-XXXX` (e.g., `SCF-26-0001`, `SCF-26-0002`).
- **Linear Route Scaffolds:** Follows the span pattern `SCF-LIN-26-XXXX` (e.g., `SCF-LIN-26-0001`).
- **Validation Engine:** Both `database.html` and `mapping.html` evaluate the unique ID list before saving. If an ID is already registered in local state or Supabase, the system rejects the entry with an explicit warning banner and prompts for a unique identifier.

### 2.2 Printable Physical Scafftag QR Engine
Standard field compliance requires physical Scafftag cards attached to access ladders:
- **Field Card Template:** Compliant with OSHA 1926.451 and ADNOC Safety guidelines.
- **Dynamic Color Banners:**
  - 🟢 **GREEN TAG (ACTIVE / SAFE FOR WORK):** Displays permit validity, inspector name, load rating, and inspection timestamp.
  - 🟡 **YELLOW TAG (UNDER ERECTION / MODIFICATION):** Indicates work in progress with specific safety precautions.
  - 🔴 **RED TAG (DO NOT USE / DANGER):** Displayed when inspection has expired (>7 days) or scaffold is tagged unsafe.
- **High-Resolution QR Code:** Encodes the direct URL or unique Scaffold ID for instant field scanning.
- **Print Optimization (`@media print`):** Formatted for direct 1-click printing (`window.print()`) sized perfectly for standard plastic Scafftag holders.

### 2.3 Live Camera QR Code Scanner
- Inspectors in the field can scan physical Scafftags directly using their smartphone/tablet camera.
- Integrated `Html5Qrcode` scanner automatically extracts the scaffold ID from the QR code and instantly jumps to:
  - **GIS Map View:** Centers and zooms into the unit with a pulsating highlight halo.
  - **Audit Register:** Filters and opens the inspection history for immediate re-certification.

### 2.4 Strict Map Coordinate Accuracy Rule
Every scaffolding unit in the database **MUST** have verified coordinates mapped on the Greenfield route plan canvas:
- **Point Scaffolds:** Fixed normalized coordinates $(x, y)$ expressed as percentages ($0.0\% - 100.0\%$) relative to the master route plan image.
- **Linear Scaffolds:** Ordered sequence of point vertices $[(x_1, y_1), (x_2, y_2), \dots, (x_n, y_n)]$ stored as a JSON array representing the exact route path.
- In `database.html`, saving a new scaffold or modifying location coordinates automatically binds the position to the physical coordinate system of the chosen landmark to guarantee zero unmapped entries.

### 2.5 Strict HSE 7-Day Inspection Cycle Rule
Under international construction standards (OSHA 1926.451 / BS EN 12811 / PERMENAKER 01/1980):
- Scaffolding inspections are legally valid for **maximum 7 calendar days**.
- Every unit records `installDate` (erection date) and `lastInspection` (date of most recent inspection).
- **Inspection Status Hierarchy:**
  1. **ACTIVE (Green Tag):** $\Delta \text{days} \le 5 \text{ days}$. Safe for worker access.
  2. **URGENT ATTENTION (Amber Warning):** $5 < \Delta \text{days} \le 7 \text{ days}$ ($\le 2 \text{ days remaining}$). HSE inspectors are alerted with high-visibility pulsing beacon badges.
  3. **EXPIRED (Red Tag):** $\Delta \text{days} > 7 \text{ days}$ or explicitly tagged `EXPIRED`. **Access strictly prohibited**; beacon pulses with red alert ring and dashed warning border.
  4. **DISMANTLED:** Scaffolding dismantled and archived. Excluded from active inspection count.
- **1-Click "Pass Inspection":** Updates `lastInspection` to the current date ($+7 \text{ days}$ of validity) and restores `ACTIVE` status in both local memory and Supabase cloud.

---

## 3. Architecture & File Structure

```
├── index.html                           # Executive Portal & Launcher (Route '/')
├── mapping.html                         # Interactive GIS Spatial Route & Site Plan
├── database.html                        # Tabular HSE Inspection Registry & Scafftag Hub
├── server.js                            # Production Zero-Dependency Node.js Server + /api/health
├── package.json                         # NPM Configuration (scripts: start, dev, test, serve)
├── vercel.json                          # Zero-config deployment file for Vercel
├── netlify.toml                         # Configuration for Netlify deployment
├── Dockerfile & .dockerignore           # Containerized build (Docker / Cloud Run / Render)
├── supabase_schema.sql                  # PostgreSQL table definitions, RLS, indexes & triggers
├── SCAFFTECH_RULES_AND_ARCHITECTURE.md  # Detailed operational specifications & business rules
└── README.md                            # Complete platform overview & user guide
```

---

## 4. Supabase Database Schema

### Table: `public.scaffolds`
| Column Name | SQL Type | Nullable | Default | Description |
| :--- | :--- | :---: | :---: | :--- |
| `id` | `TEXT` | **NO** | Primary Key | Unique scaffold identifier (e.g., `SCF-26-0001`, `SCF-101`) |
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

## 5. Deployment Options

- **Local:** `npm start` or `node server.js` (runs on `http://localhost:3000`).
- **Vercel (1-Click):** Directly import repository; `vercel.json` and `index.html` work out-of-the-box.
- **Netlify:** Connect repo; `netlify.toml` handles routing and security headers.
- **Docker / Cloud Run:** Build with `docker build -t scafftech . && docker run -p 3000:3000 scafftech`.
