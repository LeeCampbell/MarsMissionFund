# Domain Knowledge

> Accumulated domain knowledge from implementation cycles. Updated by agents as they learn.

## Key Domain Concepts

- **Campaign**: A crowdfunding campaign for a Mars mission project. Has a funding goal (USD cents), deadline, and milestones.
- **Contribution**: A backer's financial contribution to a campaign. Amount in USD integer cents.
- **Escrow**: Segregated holding of campaign funds. One escrow account per campaign. Ledger entries are append-only and immutable.
- **Milestone**: A campaign checkpoint that triggers fund disbursement when verified.
- **Disbursement**: Release of escrowed funds to campaign creator. Requires dual admin approval.

## Financial Rules

- Single currency: USD
- All amounts stored as integer cents (minor units)
- JSON serialisation: amounts as strings, never numbers
- No floating point arithmetic for money — ever
- Escrow ledger is append-only and immutable

## User Roles

- **Backer**: Browses campaigns, makes contributions, tracks funded projects
- **Creator**: Creates and manages campaigns, submits milestones
- **Reviewer**: Reviews campaign proposals against curation criteria before campaigns go live
- **Administrator**: Platform management, campaign moderation
- **Super Administrator**: Full system access, disbursement final approval
