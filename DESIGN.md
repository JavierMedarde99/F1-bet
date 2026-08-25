---
name: Grid Dynamic
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c4c9ae'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#8e937a'
  outline-variant: '#444934'
  surface-tint: '#a9d600'
  primary: '#ffffff'
  on-primary: '#283500'
  primary-container: '#c4f42b'
  on-primary-container: '#556d00'
  inverse-primary: '#506600'
  secondary: '#ffb4a8'
  on-secondary: '#680100'
  secondary-container: '#ff5540'
  on-secondary-container: '#5c0100'
  tertiary: '#ffffff'
  on-tertiary: '#003731'
  tertiary-container: '#a9f0e2'
  on-tertiary-container: '#266f65'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#c4f42b'
  primary-fixed-dim: '#a9d600'
  on-primary-fixed: '#161f00'
  on-primary-fixed-variant: '#3b4d00'
  secondary-fixed: '#ffdad4'
  secondary-fixed-dim: '#ffb4a8'
  on-secondary-fixed: '#410100'
  on-secondary-fixed-variant: '#930200'
  tertiary-fixed: '#a9f0e2'
  tertiary-fixed-dim: '#8dd4c6'
  on-tertiary-fixed: '#00201c'
  on-tertiary-fixed-variant: '#005047'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-race:
    fontFamily: Anybody
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: 0.05em
  headline-lg:
    fontFamily: Anybody
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: 0.02em
  headline-lg-mobile:
    fontFamily: Anybody
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.2'
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  data-mono:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1.0'
    letterSpacing: 0.02em
  odds-lg:
    fontFamily: Anybody
    fontSize: 20px
    fontWeight: '800'
    lineHeight: '1.0'
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '700'
    lineHeight: '1.0'
    letterSpacing: 0.1em
spacing:
  unit: 4px
  gutter: 16px
  margin: 24px
  container-max: 1280px
---

## Brand & Style
The design system is engineered for a high-stakes, high-octane Formula 1 betting environment, specifically tailored for the Spanish market. The brand personality is aggressive, technical, and hyper-focused on performance telemetry.

The visual style, **Grid Dynamic**, leverages a "Cockpit" aesthetic. It utilizes a high-contrast dark mode foundation inspired by carbon fiber and asphalt, overlaid with precision-engineered data visualizations. The UI evokes the sensation of an F1 steering wheel—dense with information but organized for split-second decision-making. 

Key stylistic pillars include:
- **Technical Minimalism:** Removing all non-essential decorative elements to prioritize speed and data clarity.
- **Glassmorphism:** Subtle translucent layers represent HUD (Heads-Up Display) elements, creating depth without losing the dark, grounded feel of the track.
- **Kinetic Energy:** Use of diagonal lines, italicized headers, and vibrant neon accents to simulate velocity and the "live" nature of the sport.

## Colors
The palette is built on a "Tarmac" foundation with high-visibility accents representing the two titans of Spanish motorsport.

- **Primary (Aston Lime):** Used for primary actions, Alonso-specific data, and active betting selections. High visibility against dark backgrounds.
- **Secondary (Rosso Corsa):** Used for "Live" status indicators, Sainz-specific data, and critical alerts.
- **Tertiary (British Racing Green):** A deep, desaturated green used for subtle branding and structural elements to provide relief from pure black.
- **Neutral (Carbon & Asphalt):** A range of near-black grays (`#0a0a0a` to `#1e1e1e`) providing the chassis for the UI.

**Race Status Tokens:**
- **Live:** Pulsing Rosso Corsa.
- **Upcoming:** Neutral white with high tracking.
- **Finished:** Muted Asphalt grey.

## Typography
The typography system prioritizes legibility under "vibration" and high-speed scrolling.

- **Headlines:** Use **Anybody** with wide tracking and uppercase transformations to mimic the typography seen on trackside sponsorship and car liveries.
- **Body:** **Hanken Grotesk** provides a clean, contemporary sans-serif feel for news and descriptions, ensuring long-form content is readable.
- **Data & Labels:** **JetBrains Mono** is utilized for betting odds, telemetry data, and lap times. The monospaced nature ensures that shifting numbers (odds) don't cause layout jumps.

All headlines should be slightly italicized (8 degrees) where possible to reinforce the sensation of forward motion.

## Layout & Spacing
The layout follows a strict 12-column **Fluid Grid** that snaps to 4px increments, ensuring a "calculated" feel.

- **Mobile:** 4-column grid with 16px margins. Content is stacked in "cards" that resemble dashboard modules.
- **Desktop:** 12-column grid. The layout utilizes a "Side-Pod" navigation system on the left, with the primary "Telemetry/Race" feed in the center and "Betting Slip" on the right.
- **Density:** High density is encouraged. Elements should be tightly packed but separated by clear technical dividers (1px lines) to mimic physical hardware interfaces.

## Elevation & Depth
Elevation is not achieved through traditional shadows, but through **Tonal Layering** and **Material Contrast**.

- **Base Layer:** Pure black or deep carbon texture (`#0a0a0a`).
- **Mid Layer (Cards):** Asphalt grey (`#1e1e1e`) with 1px borders in a slightly lighter grey (`#333333`).
- **Top Layer (Overlays):** Glassmorphism with a 12px backdrop blur and 10% opacity white fill.
- **Outlines:** Instead of drop shadows, use thin, vibrant outlines in Primary Lime or Secondary Red to indicate "Active" or "Focused" states, simulating a glowing LED or screen highlight.

## Shapes
This design system uses a **Sharp** (0px) roundedness profile. 

To maintain the technical, aggressive look of F1 engineering, all corners are strictly 90 degrees. Angled "chamfered" corners (45-degree cuts) may be used on buttons or header tags to further the aerospace/motorsport aesthetic, but soft curves are strictly prohibited.

## Components
- **Buttons:** Sharp-edged, high-contrast blocks. Primary buttons use the Aston Lime background with black text. Secondary buttons are ghost-style with a 2px white border.
- **Odds Cards:** Use a split-module design. Left side contains the driver/team info; right side contains a high-visibility block with the JetBrains Mono "odds-lg" text.
- **Race Progress Bar:** A thin 4px line. The "Live" segment should use a Rosso Corsa gradient to represent the lead car.
- **Chips:** Used for "Sector Times" or "Compound Type" (Soft/Medium/Hard). These are small, rectangular blocks with monospaced text.
- **Input Fields:** Minimalist. Only a bottom border that glows in Aston Lime when focused.
- **Telemetry Visuals:** Simple line charts using neon primary/secondary colors against a grid-patterned background (16px grid lines).
- **Betting Slip:** A fixed-position "Glass" drawer that slides from the right, blurring the race data behind it.