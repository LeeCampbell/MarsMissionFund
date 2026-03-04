# /pm:spec-plan

## Usage
```
/pm:spec-plan --vision specs/product-vision-and-mission.md
/pm:spec-plan --continue
```

## Description
Runs the Spec Track only — generates the feature backlog and specs without starting implementation. Use this to pre-populate specs before an overnight build run, or with `--continue` to spec the next unspecced feature.

## Steps

### Mode: Initial (--vision)

Run this when the backlog is empty or needs regenerating from the vision.

1. **Read inputs:**
   - Read `CLAUDE.md`
   - Read `specs/product-vision-and-mission.md`
   - Read `specs/standards/brand.md`
   - Read `.claude/backlog.md` — check current state
   - Scan `packages/` — understand what already exists

2. **Run Product Strategist:**
   - Read `.claude/agents/product-strategist.md`
   - Decompose the product vision into feature briefs
   - Write briefs to `.claude/prds/feat-XXX-[name].md`
   - Write prioritised backlog to `.claude/backlog.md`

3. **For each of the top 3 priority features (or until done):**
   - Run **Spec Researcher** → `.claude/prds/feat-XXX-research.md`
   - Run **Spec Writer** → `.claude/prds/feat-XXX-spec.md`
   - Run **Design Speccer** → `.claude/prds/feat-XXX-design.md`
   - Run **Spec Validator** → `.claude/prds/feat-XXX-validation.md`
   - If PASS: update backlog to "✅ SPECCED"
   - If FAIL: re-run failing agent, re-validate

4. **Commit:**
   ```bash
   git add .claude/
   git commit -m "chore: spec track — populated backlog and specced [N] features"
   ```

5. **Report:**
   - Print backlog summary showing specced vs unspecced features
   - Print which features are ready for implementation

### Mode: Continue (--continue)

Run this to spec the next unspecced feature in the backlog.

1. **Read `.claude/backlog.md`**
   - Find the highest-priority feature with status "🔲 TODO"

2. **If no unspecced features remain:**
   - Report "All features are specced or in progress"
   - Exit

3. **Run the spec track for that feature:**
   - Update backlog status to "📐 SPECCING"
   - Run Spec Researcher → research doc
   - Run Spec Writer → feature spec
   - Run Design Speccer → design spec
   - Run Spec Validator → validation report
   - If PASS: update to "✅ SPECCED"
   - If FAIL: re-run, re-validate

4. **Commit:**
   ```bash
   git add .claude/
   git commit -m "chore: spec track — specced feat-XXX [name]"
   ```

5. **Report:**
   - Print spec validation summary
   - Print updated backlog status
