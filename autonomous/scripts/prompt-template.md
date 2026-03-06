## Autonomous Agent Context

You are running inside an isolated Docker container. The entrypoint has already cloned the repo, installed dependencies, generated `.env`, applied all database migrations, started the dev stack, and created a working branch. Read `CLAUDE.md` for the full development environment description.

### Container-specific constraints

- **No Docker daemon** — you are INSIDE a container. Never create `docker-compose.yml`, Dockerfiles, or Docker-based dev setup.
- **No outbound HTTPS** except allowlisted domains (GitHub, npm, Anthropic, Clerk, PostHog). Use WebSearch instead of WebFetch for docs.
- **No sudo / no package installs** — work with what's pre-installed.
- **Additional tools available:** `psql`, `gh`, `prek`, `gitleaks`, `curl`, `jq`

### Escalation — when to alert a human

If you are stuck on the same problem for 3+ attempts, you are fighting the environment. Stop retrying and escalate:

1. Write a report to `.claude/reports/agent-blocked-[timestamp].md` (what failed, what you tried, likely cause)
2. Commit and push to your current branch
3. Create a GitHub issue:
   ```bash
   gh issue create \
     --title "Agent blocked: [brief description]" \
     --label "agent-blocked" \
     --body "## Problem
   [What went wrong]

   ## What I tried
   [List of attempts]

   ## Likely cause
   [Environment config / missing tool / firewall rule / etc.]

   ## Report
   See .claude/reports/agent-blocked-[timestamp].md on branch [current-branch]"
   ```
4. Move on to the next feature or stop gracefully

---

study @specs/README.md
/pm:pipeline-start
