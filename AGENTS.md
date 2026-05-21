# Agent Instructions

AI toolkit for OpenRail Association work. Contains skills for recurring operational tasks.

## Skills

| Skill | When to use |
|---|---|
| `skills/incubation-review/SKILL.md` | Reviewing a project application to the OpenRail incubation process |
| `skills/archive-playground-repo/SKILL.md` | User asks to archive a repo in OpenRail-Playground (opens a notice PR; does NOT immediately archive) |
| `skills/archive-check/SKILL.md` | Checking whether any archive notice PRs have passed the one-week waiting period and are ready to finalize |

## Key rules

- **"Archive this repo" means run the `archive-playground-repo` skill**, not `gh repo archive`. The skill implements a one-week notice period via PR.
- **"Check archives" or "archive check" means run the `archive-check` skill** to find and finalize repos past the notice period.
- Load the relevant `SKILL.md` before executing any skill. Follow its steps and constraints exactly.
