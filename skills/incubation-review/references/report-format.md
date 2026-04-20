# Report Format

The review report is a single cohesive document. Structure:

## Title and header

- Title: `<Project> — Stage <N> Review`
- Header block: PR link, applicant, repo link, date
- Opening line: mention OpenRail and link to the specific stage criteria page (e.g. `https://openrailassociation.org/tech/incubation/process/#stage-1-onboarded`)

## Project summary

Brief description of what the project does, tech stack, license, production usage.

## Project vitals (in Repository inspection section)

Key repo metrics: number of commits, time span (first to last commit), number of contributors, stars/forks. Brief interpretation (e.g. single-developer early-stage project).

## Criteria evaluation

One subsection per criterion with ✅/⚠️/❌ verdict. Each includes evidence and reasoning. Short paragraph per criterion.

## Repository inspection

Findings organized by topic:
- Project vitals
- Security findings (with concrete details: actual values, specific files, line numbers)
- Code and structure
- AI-assisted development (if applicable — note presence of CLAUDE.md, AGENTS.md etc.)
- REUSE compliance
- Secrets scan results
- Vulnerability scan results
- License enumeration
- Interesting dependencies

File/directory references are hyperlinks to the public GitHub repo.

## Overall assessment

One-line verdict (positive / conditionally positive / negative), followed by:

- **Recommendations for onboarding** — numbered list, includes community health files
- **Open questions for the applicant** — numbered list, specific and answerable

## Appendices

- **Appendix A: Community health files** — table: File, Status (✅/❌), Notes
- **Appendix B: Dependency licenses** — raw output from compliance-assistant licensing list, plus notes on components with missing data
- **Appendix C: Automated scans** — table: Tool, Version, Status, Notes. Version only for tools that ran. "⏭️ Deferred" for tools not run (no mention of install status).

## Style

- Don't mention tool version numbers for tools that weren't run
- Don't flag AI config files as concerns — note them as development context
- Include concrete details (actual secrets, specific IPs, exact file paths)
- Keep the document self-contained
