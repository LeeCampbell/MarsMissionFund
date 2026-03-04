# Frontend Rules

> Applied to all files in `packages/frontend/src/**`

## Framework

- React 19.x with functional components only
- TypeScript strict mode — no `any` types
- Tailwind CSS for utility layout — semantic tokens via CSS custom properties for all brand values
- TanStack Query for all server state — no Redux, no Zustand
- React Router for client-side routing
- Zod for form validation (shared schemas with backend)
- Native `fetch` via API client — no Axios
- Clerk SDK for authentication — JWT token injection via centralised API client

## Component Rules

- Named exports only (except page-level default exports)
- All props typed with explicit interface
- All props `readonly`
- No business logic in components — delegate to hooks or utilities
- Handle all states: default, empty, loading, error
- Semantic HTML — `<button>` not `<div onClick>`

## Design System Enforcement

- All visual values from `specs/standards/brand.md` (L2-001) — the Brand Application Standard
- Two-tier token architecture: components consume **Tier 2 semantic tokens only** — never reference Tier 1 identity tokens directly
- Colours: Deep Space (foundation), Launch Fire (energy), Metallic Silver (trust), Mission Outcomes (status)
- Dark-first UI — `--color-bg-page` (`--void` / #060A14) is the primary background; no light mode for core app
- Typography: Bebas Neue (`--font-display`) for headings (always uppercase), DM Sans (`--font-body`) for UI text, Space Mono (`--font-data`) for labels/data
- Type scale is a closed set — no custom sizes outside the spec
- Gradients are used extensively — `--gradient-action-primary` for CTAs, `--gradient-surface-card` for cards, etc.
- Shadows are used — `--color-action-primary-shadow` on primary CTAs, `box-shadow` on focus states
- One primary CTA per viewport — never multiple primary buttons
- Status colours: `--color-status-success` for funded/complete, `--color-status-error` for failures, `--color-status-warning` for deadlines
- All animations use semantic motion tokens and respect `prefers-reduced-motion`

## Data Handling

- Monetary amounts displayed via `Intl.NumberFormat` — never manual formatting
- Monetary amounts received from API as strings — never parse to `number`
- Single currency: USD — all amounts in cents (integer minor units) from API
- Dates displayed in user timezone — received as UTC ISO strings

## Testing

- Every component has a `.test.tsx` file
- Test all states (default, empty, loading, error)
- Use Testing Library with accessible queries (`getByRole`, `getByLabel`)
- Realistic test data — no round numbers for monetary values
