# ScaffTech Pro — Enterprise Full-Stack GIS Scaffolding Visual Tracker & HSE Suite

![ScaffTech Platform](https://img.shields.io/badge/ScaffTech-Enterprise%20GIS%20Suite-0284c7?style=for-the-badge&logo=shield)
![Status](https://img.shields.io/badge/Status-Production%20Ready-10b981?style=for-the-badge)
![HSE Standard](https://img.shields.io/badge/Compliance-OSHA%20%7C%20ADNOC%20%7C%20BS%20EN%2012811-amber?style=for-the-badge)
![Supabase Realtime](https://img.shields.io/badge/Database-Supabase%20Cloud%20Postgres-3ecf8e?style=for-the-badge&logo=supabase)
![Full-Stack](https://img.shields.io/badge/Stack-Node.js%20%7C%20React%20%7C%20PostgreSQL-blueviolet?style=for-the-badge)

**ScaffTech Pro** is an enterprise-grade full-stack web platform engineered for heavy industrial facilities, petrochemical refineries, EPC infrastructure, and power plants. It eliminates unmapped scaffolding hazards by bridging **GIS Greenfield Site Plan visual mapping** with an **auditable, real-time relational database** powered by Supabase PostgreSQL, physical **QR Scafftag generation**, and live **camera inspection scanners**.

---

## 🌟 Architecture & Core Modules

### 1. Executive Operations Portal (`index.html`)
- **Central Mission Control**: Real-time KPI counters dynamically synchronized with Supabase PostgreSQL (Safe Active Scaffolds, Under Erection, Overdue / Red Tags, Total Fleet).
- **Universal Quick Search & Scanner Bar**: Fast query by ID (`SCF-101`, `SCF-26-0001`) or Tag Number with built-in camera QR scanner.
- **Deep-Link Launchers**: Instant routing with query parameters to either the GIS Spatial Map or the HSE Database.

### 2. Visual Spatial GIS Mapping (`mapping.html`)
- **Dual Construction Plottings**:
  - **Point Tower Scaffold**: Single independent tower pinned with sub-meter coordinate precision ($0.0\% - 100.0\%$).
  - **Multi-Point Linear Span**: Continuous pipe racks, catwalks, and cable trays rendered with thin 2.0px vector paths and directional node markers.
- **Automated 7-Day Inspection Engine**: Real-time status evaluation tagging overdue scaffolds as `EXPIRED` (Red Tag) with pulsating alert rings.
- **Dynamic Camera Pan & Zoom**: Smooth matrix zoom (0.4x - 5.0x) with deep-link autofocus to jump directly to any scaffold or landmark.
- **Physical QR Scafftag Generator**: Displays printable physical Scafftag cards compliant with OSHA / ADNOC standards.
- **Live Camera QR Scanner**: Scans physical Scafftags directly in the field using device cameras.

### 3. Tabular HSE Audit & Registry (`database.html`)
- **Asset Master Table**: Full pagination, multi-column sorting (by ID, Tag, Last Inspection, Install Date, Status), and status filtering.
- **Guaranteed Anti-Duplicate ID Generator**: Enforces unique numbering (`SCF-26-XXXX` for point towers and `SCF-LIN-26-XXXX` for linear spans) to ensure zero ID collisions.
- **Action Cluster**:
  - 🟢 **Pass Inspection**: Instant 7-day validity re-certification with inspector timestamp.
  - 🏷️ **Print Scafftag**: Generates high-resolution printable QR cards formatted for standard field plastic holders.
  - 🗺️ **Jump to Map**: Direct deep-linking to the exact position on `mapping.html`.
  - ✏️ **Edit & Delete**: Instant CRUD synchronized directly to Supabase cloud.
- **Excel Spreadsheet Hub**: Import/Export with SheetJS (`.xlsx`).

### 4. Supabase Cloud Database (`supabase_schema.sql`)
- **PostgreSQL Table `public.scaffolds`**: Schema with indexed columns, timestamp triggers, and JSONB spatial coordinate support.
- **Multi-Device Realtime Sync**: Immediate websocket broadcast of all `INSERT`, `UPDATE`, and `DELETE` operations across field tablets and control rooms.
- **Zero-Trust Row Level Security (RLS)**: Publicly readable and writable via client-safe publishable key without leaking service role privileges.

---

## 🚀 Deployment & Running Options

ScaffTech is packaged as a **Full-Stack, Zero-Dependency** application that can be launched locally or deployed to any major cloud provider in under 60 seconds:

### Option A: Local Dev Server (Node.js)
```bash
# Clone the repository
git clone https://github.com/semonpungkot-hsse/ScaffTech.git
cd ScaffTech

# Start the built-in production server
npm start
# or: node server.js
```
Open **`http://localhost:3000`** in your browser.

---

### Option B: Deploy to Vercel (1-Click)
The repository includes a ready-to-use `vercel.json`:
1. Push your repository to GitHub.
2. Go to [Vercel](https://vercel.com) and click **"Add New Project"**.
3. Select your repository and click **Deploy**.
4. Vercel automatically deploys `index.html` at the root URL with zero configuration.

---

### Option C: Deploy to Netlify
The repository includes `netlify.toml`:
1. Connect your repository on [Netlify](https://netlify.com).
2. Set publish directory to `.` (current directory).
3. Click **Deploy Site**.

---

### Option D: Docker Container / Cloud Run / Render / Railway
Run `server.js` directly in any containerized or Linux environment:
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

---

## 📁 Project Directory Structure

```
├── index.html                           # Executive Operations Portal & Central Launcher
├── mapping.html                         # Interactive GIS Canvas & Visual Route Plotted Plan
├── database.html                        # Tabular Scaffold Registry, HSE Audit & QR Generator
├── server.js                            # Production zero-dependency Node.js HTTP server
├── package.json                         # NPM configuration & deployment scripts
├── vercel.json                          # Zero-config deployment file for Vercel
├── netlify.toml                         # Configuration for Netlify deployment
├── supabase_schema.sql                  # PostgreSQL table definitions, RLS & triggers
├── SCAFFTECH_RULES_AND_ARCHITECTURE.md  # Detailed operational specifications & business rules
└── README.md                            # Complete platform documentation
```

---

## 🛡️ HSE Compliance Standards
- **OSHA 1926.451** — Scaffolding safety requirements, load ratings, and inspection protocols.
- **ADNOC Safety Standard** — Industrial scaffold tagging, 7-day inspection intervals, and physical Scafftag colors.
- **BS EN 12811-1** — Temporary works equipment and access scaffold design.
- **PERMENAKER 01/1980** — Construction safety & mandatory periodic inspection records.

---

## 📄 License
Enterprise Commercial License. Engineered for Industrial HSE Operations.
