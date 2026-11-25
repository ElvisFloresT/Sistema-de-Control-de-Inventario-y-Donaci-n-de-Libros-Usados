---
name: Institutional Library & Book Donation Network
colors:
  surface: '#f8f9ff'
  surface-dim: '#d0dbed'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e6eeff'
  surface-container-high: '#dee9fc'
  surface-container-highest: '#d9e3f6'
  on-surface: '#121c2a'
  on-surface-variant: '#434655'
  inverse-surface: '#27313f'
  inverse-on-surface: '#eaf1ff'
  outline: '#737686'
  outline-variant: '#c3c6d7'
  surface-tint: '#0053db'
  primary: '#004ac6'
  on-primary: '#ffffff'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#b4c5ff'
  secondary: '#466080'
  on-secondary: '#ffffff'
  secondary-container: '#bfd9fe'
  on-secondary-container: '#455f7e'
  tertiary: '#4e565d'
  on-tertiary: '#ffffff'
  tertiary-container: '#676e76'
  on-tertiary-container: '#eaf1fa'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#d2e4ff'
  secondary-fixed-dim: '#aec9ed'
  on-secondary-fixed: '#001d37'
  on-secondary-fixed-variant: '#2e4867'
  tertiary-fixed: '#dce3ec'
  tertiary-fixed-dim: '#c0c7d0'
  on-tertiary-fixed: '#151c23'
  on-tertiary-fixed-variant: '#40484f'
  background: '#f8f9ff'
  on-background: '#121c2a'
  surface-variant: '#d9e3f6'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.025em
  data-metric:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-mobile: 1rem
  margin: 2rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style
The design system establishes an institutional, accessible, and structured visual language tailored for public administration, educational systems, and regional library networks. Aligned with UN Sustainable Development Goals (SDG 4: Quality Education and SDG 12: Responsible Consumption and Production), the platform projects trust, administrative rigor, and community stewardship.

The aesthetic bridges Modern Corporate SaaS and Civic Digital Government:
- **Clean Structure:** Generous whitespace, precise data tables, and structured modular panels minimize cognitive load for catalogers, administrators, and donors.
- **Formal Modernity:** Deep nautical tones convey stability and official authority, while vibrant interactive blues drive task completion without visual fatigue.
- **Functional Clarity:** Dense operational information (ISBNs, donor lineages, volume condition states) is rendered with immediate legibility, strict contrast compliance (WCAG 2.1 AA/AAA), and quiet visual discipline.

## Colors
The color hierarchy supports high-frequency municipal operations and inventory management through systematic functional roles:

- **Secondary Navy (`#16324F`):** Anchors global chrome, persistent mastheads, high-level navigation sidebars, and top-tier institutional framing.
- **Primary Cobalt (`#2563EB`):** Reserved exclusively for active user intents, focal CTAs (such as "Registrar Donación"), active pagination items, and key navigational highlights.
- **Tertiary Soft Ice (`#EFF6FF`):** Powers container tinting for information banners, selected row highlights in inventory matrices, and active filtering tags.
- **Neutral Charcoal (`#1F2937`):** Primary text and semantic content, ensuring high contrast against stark white cards and subtle canvas backgrounds.
- **Canvas (`#F3F4F6`):** Provides a calm, low-glare backdrop separating elevated white cards, data sheets, and modal workflows.
- **Functional Semantics:**
  - **Success / Available (`#16A34A`):** Cataloged volumes, fulfilled book allocations, verified donor records.
  - **Warning / Pending (`#D97706`):** Triage backlogs, routing holds, low stock thresholds.
  - **Critical / Rejected (`#DC2626`):** Unusable book conditions, cancelled routing orders, system errors.

## Typography
Typography relies entirely on Inter to deliver systematic neutral rhythm, structural clarity, and high legibility across complex administrative screens:

- **Tabular Figures:** For catalog IDs, ISBN strings, stock tallies, and inventory dates, apply CSS OpenType features (`font-feature-settings: 'tnum' 1, 'cv05' 1`) to preserve tabular column alignment.
- **Hierarchy in Data Surfaces:** `label-sm` (uppercase, bold tracking) is designated for table header metadata and badge identifiers. `data-metric` provides prominent visual anchor points for summary KPI metric cards without requiring decorative display typefaces.
- **Readability Rules:** Line lengths for text-heavy editorial descriptions and donor condition notes are constrained to a maximum of 68 characters per line.

## Layout & Spacing
The layout follows a fluid 12-column grid system optimized for desktop administrative desks, with responsive consolidation down to 4 columns on mobile views:

- **Desktop (1024px+):** Fixed 260px administrative navigation sidebar alongside an adaptive 12-column workspace with `1.5rem` gutters and `2rem` outer margins.
- **Tablet (768px - 1023px):** Sidebar collapses to an icon rail (64px) or off-canvas drawer; main canvas operates on an 8-column layout with `1.25rem` gutters.
- **Mobile (<768px):** Single-column stack with `1rem` margins and gutters. Multi-column inventory tables wrap into vertical card lists.
- **Density Standard:** Operational screens (data grids, batch processing) utilize compact component padding (`space-xs` and `space-sm`), whereas public donation workflows and KPI dashboards leverage relaxed spacing (`space-md` through `space-xl`).

## Elevation & Depth
Depth is achieved via subtle contrast shifts and refined, neutral drop shadows rather than heavy skeuomorphism or glass textures:

- **Base Canvas:** `#F3F4F6` provides a flat, glare-free baseline for operational workflows.
- **Surface Elevation 1 (Cards, Modules, Forms):** `#FFFFFF` surfaces bounded by an imperceptible 1px structural stroke (`#E5E7EB`) and a soft, grounded shadow: `0 1px 3px 0 rgba(0, 0, 0, 0.05), 0 1px 2px -1px rgba(0, 0, 0, 0.05)`.
- **Surface Elevation 2 (Dropdowns, Flyouts, Popovers):** High-contrast pop-outs floating over data tables using `0 4px 6px -1px rgba(0, 0, 0, 0.07), 0 2px 4px -2px rgba(0, 0, 0, 0.05)`.
- **Surface Elevation 3 (Modals, Overlays):** Administrative modal dialogs centered over a 40% `#16324F` dimmed backdrop blur, lifted by `0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.04)`.

## Shapes
The design system adopts a balanced rounded geometry (`roundedness: 2`):
- Standard interactive elements (buttons, inputs, alerts, chips) employ `0.5rem` (8px) corner radii, creating a modern, accessible, and approachable public-service interface.
- Core content containers, analytical KPI cards, and modals use `rounded-lg` (`1rem` / 16px) or `rounded-xl` (`1.5rem` / 24px) to soften analytical data surfaces and separate functional sections cleanly.
- Status badges and metadata counters use fully circular pill geometry (`9999px`) to immediately distinguish contextual statuses from interactive rectangular buttons.

## Components

### Buttons
- **Primary:** Background `#2563EB`, text `#FFFFFF`, radius `0.5rem`, padding `0.5rem 1rem`. Focus ring: 2px offset with `#2563EB`. Hover: `#1D4ED8`.
- **Secondary / Institutional:** Background `#16324F`, text `#FFFFFF`, radius `0.5rem`. Used for system-level actions (e.g., "Generar Informe Municipal").
- **Outline / Ghost:** Border `1px solid #D1D5DB`, background transparent, text `#1F2937`. Hover: `#F9FAFB`.

### Form Fields & Inputs
- **Text Inputs & Selects:** Height `40px`, background `#FFFFFF`, border `1px solid #D1D5DB`, radius `0.5rem`, padding `0.5rem 0.75rem`, placeholder `#9CA3AF`. Active focus: border `#2563EB`, box-shadow `0 0 0 3px rgba(37, 99, 235, 0.15)`.
- **Error States:** Border `#DC2626`, accompanying helper text in `#DC2626` using `body-sm`.

### Status Badges & Chips
- Fully rounded (`rounded-full`), padding `0.25rem 0.625rem`, font `label-sm`.
- **Available / Completed:** Background `#DCFCE7`, text `#166534`.
- **In Triage / Pending:** Background `#FEF3C7`, text `#92400E`.
- **Rejected / Damaged:** Background `#FEE2E2`, text `#991B1B`.
- **Category Filter Chips:** Active state `#EFF6FF` with `#2563EB` border and text; default state `#F3F4F6` with `#4B5563` text.

### Data Tables (Catalog & Inventory)
- **Header:** Background `#F9FAFB`, text `#4B5563`, border-bottom `1px solid #E5E7EB`, height `44px`, font `label-sm`.
- **Rows:** Background `#FFFFFF`, height `52px`, border-bottom `1px solid #F3F4F6`, alternating selection highlight `#EFF6FF`.
- **Alignment:** Text left-aligned; numerical values, ISBN codes, and stock levels right-aligned with tabular figures.

### Cards & KPI Tiles
- **KPI Summary Card:** Background `#FFFFFF`, border `1px solid #E5E7EB`, radius `1rem`, padding `1.25rem`. Houses metric titles in `label-md` (`#6B7280`), metrics in `data-metric` (`#16324F`), and positive/negative trends flagged via semantic badges.
- **Book Item Card:** Structured cover thumbnail container, title (`headline-sm`), author/publisher (`body-sm`), barcode/ISBN tag, and condition badge aligned along the lower edge.