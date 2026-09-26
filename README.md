# ScaffTech — Enterprise Visual GIS Scaffolding & HSE Compliance Platform

![ScaffTech Platform](https://img.shields.io/badge/ScaffTech-Enterprise%20GIS-0284c7?style=for-the-badge&logo=shield)
![Status](https://img.shields.io/badge/Status-Production%20Ready-10b981?style=for-the-badge)
![HSE Standard](https://img.shields.io/badge/Compliance-OSHA%20%7C%20BS%20EN%2012811-amber?style=for-the-badge)
![Supabase Realtime](https://img.shields.io/badge/Database-Supabase%20Cloud%20Realtime-3ecf8e?style=for-the-badge&logo=supabase)

**ScaffTech** is an enterprise-grade web platform engineered for heavy industrial facilities, petrochemical refineries, EPC infrastructure, and power plants. It eliminates unmapped scaffolding hazards by bridging **GIS-style Greenfield Route Plan visual mapping** with an **auditable, real-time relational database** powered by Supabase.

---

## 🌟 Core Features

### 1. Visual Spatial GIS Mapping (`mapping.html`)
- **AutoCAD/GIS Vertical Rail Dock (64px)**: Minimalist left-hand dock housing navigation tools, drawing modes, layer controls, and cloud utilities.
- **Multi-Point Linear Route Drawing**: Plot continuous pipe racks, suspended catwalks, and long-span scaffolds with slim, symmetrical 2.0px vectors that inherit real-time HSE status colors.
- **Point Tower Pinning**: Drop independent tower pins directly at verified plant landmarks with sub-meter coordinate precision ($0.0\% - 100.0\%$).
- **7-Day Inspection Expiry Alert Engine**: Visual beacon rings pulse amber when inspection is due within 2 days, and pulse red with an alert halo when expired (>7 days).
- **Fast Landmark Jump**: Quick-focus camera panning to substations (`SUB 524`, `SUB 520`), process trains (`UNIT 542`, `UNIT 543`), utility facilities, and access gates.
- **Layer Visibility & Presets**: Toggle landmark labels, towers, spans, and tags, or switch instantly to *Zen Mode* or *HSE Focus Mode*.

### 2. Tabular Audit & Register (`database.html`)
- **Real-Time KPI Dashboard**: Live counts of Active Green Tags, Erection / Building units, Yellow Warning Tags, and Critical/Expired units.
- **Compact Icon Action Cluster**: High-efficiency one-click actions:
  - 🟢 **Pass Inspection (`check-circle`)**: Instantly resets 7-day validity counter and stamps today's date.
  - 🔵 **View on Map (`compass`)**: Direct deep link to view scaffold position on GIS map.
  - 🟣 **Edit Record (`pencil`)**: Safely modify permits, structure dimensions, or inspector assignments with locked coordinates.
  - 🔴 **Delete Record (`trash-2`)**: Delete record with multi-device cloud synchronization.
- **Excel Hub**: Full SheetJS import/export with customizable templates and coordinate auto-fill.

### 3. Supabase Cloud Integration (`supabase_schema.sql`)
- **Multi-User Realtime Replication**: Live PostgreSQL change broadcast (`INSERT`, `UPDATE`, `DELETE`) across all field tablets and desktop workstations.
- **Row-Level Security (RLS)**: Client-side integration using safe Publishable Keys without leaking service-role credentials.

---

## 🚀 Quick Start

No build steps, bundlers, or Node.js environment required. The platform runs natively in any modern web browser:

1. Clone or download this repository:
   ```bash
   git clone https://github.com/semonpungkot-hsse/ScaffTech.git
   ```
2. Open either application directly in your browser:
   - Double-click **`mapping.html`** for visual GIS route tracking.
   - Double-click **`database.html`** for tabular management and HSE audits.
3. Configure your Supabase project in the Cloud settings modal or use the preconfigured project.

---

## 📁 Repository Structure

```
├── mapping.html                         # Interactive GIS canvas, visual route plotting & tracking
├── database.html                        # Tabular scaffold registry, HSE audit log & CRUD center
├── supabase_schema.sql                  # PostgreSQL table definitions, RLS policies & triggers
├── SCAFFTECH_RULES_AND_ARCHITECTURE.md  # Detailed operational specifications & business rules
├── README.md                            # Project overview & documentation
└── .gitignore                           # Git ignore rules
```

---

## 🛡️ HSE Compliance Standards
- **OSHA 1926.451** — Scaffolding safety requirements & load criteria.
- **BS EN 12811-1** — Temporary works equipment & access scaffolds.
- **PERMENAKER 01/1980** — Construction safety & weekly inspection mandates.

---

## 📄 License
Enterprise Commercial License. Developed for Industrial HSE Operations.
