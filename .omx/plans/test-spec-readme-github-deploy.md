# Test Spec: README and GitHub Deployment Improvements

## Verification Targets

1. Documentation file integrity
2. GitHub Actions workflow syntax
3. Web manifest JSON syntax
4. Clean diff formatting
5. Current Git state and push feasibility

## Checks

### Check 1: Diff formatting

Command:

```bash
git diff --check
```

Pass Condition:

- No output

### Check 2: Workflow YAML parses

Command:

```bash
ruby -e 'require "yaml"; YAML.load_file(".github/workflows/deploy-github-pages.yml"); puts "workflow-ok"'
```

Pass Condition:

- Outputs `workflow-ok`

### Check 3: Manifest JSON parses

Command:

```bash
python3 - <<'PY'
import json
with open('web/manifest.json') as f:
    json.load(f)
print('manifest-ok')
PY
```

Pass Condition:

- Outputs `manifest-ok`

### Check 4: Review changed files

Command:

```bash
git status --short --branch
```

Pass Condition:

- Shows only intended working tree changes for this task, plus any unrelated pre-existing untracked files

### Check 5: Commit/push feasibility

Commands:

```bash
git commit -m "Add GitHub Pages deployment workflow"
git push -u origin main
```

Expected Result in This Environment:

- May fail due to sandbox restrictions on `.git/index.lock`
- May fail due to missing network/DNS resolution for GitHub

Pass Interpretation:

- Failures are acceptable only if the blocker is captured with concrete error output
