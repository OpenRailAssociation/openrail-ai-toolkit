# Report Format

The review report is a single cohesive document. Structure:

## Title and header

- **Disclaimer** (bottom of first page, italic, smaller font): state that this is an AI-assisted review and name the person who ran it. Example: *This review was conducted with AI assistance (Kiro) by Cornelius Schumacher, OpenRail Technical Committee.* Use a raw typst block with `#v(1fr)` to push it to the bottom of the page.
- Title: `<Project> — Stage <N> Review`
- Header block: PR link, applicant, repo link, date
- Opening line: mention OpenRail and link to the specific stage criteria page (e.g. `https://openrailassociation.org/tech/incubation/process/#stage-1-onboarded`)

## Project summary

Brief description of what the project does, primary programming language, tech stack, license, production usage. If the project publishes to package registries (crates.io, PyPI, NuGet, npm, etc.), list them with URLs. Only mention registries when they exist; do not note their absence.

If the project summary does not fit on the first page together with the header block and disclaimer, add a page break before it so it starts on the next page.

## Questionnaire review (when a draft or submitted questionnaire exists)

When a draft questionnaire exists in the repo or has been submitted as a PR, add a dedicated section reviewing the answers. Structure:

- Note where the questionnaire is located and its status (draft, submitted, etc.)
- Table with each question, a brief assessment (✅/⚠️), and notes on what needs fixing
- List of concrete items to address before formal submission

Review each answer for: completeness, accuracy (do claims match what's in the repo?), items marked "pending" or "to be confirmed", and factual errors (wrong file paths, tools listed but not present).

## Criteria evaluation

One subsection per criterion with ✅/⚠️/❌ verdict. Each includes evidence and reasoning. Short paragraph per criterion.

## Repository inspection

Findings organized by topic:
- Project vitals
- Security findings (with concrete details: actual values, specific files, line numbers)
- Code and structure
- Documentation quality (when the project has architecture docs, ADRs, or other notable documentation beyond the README, give them a dedicated subsection describing their content and quality)
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
- The disclaimer uses a raw typst block with `#text(size: 8pt, fill: rgb("#888888"), style: "italic")[...]` — use the scoped `#text()[]` form, never `#set text()`, which bleeds into subsequent content
- OpenRail does not have legal counsel. When raising licensing questions, ask generically whether something "has been checked" rather than referencing legal review.
- OpenRail uses distributed copyright under permissive licenses with DCO. Copyright belongs to the employers of contributors. There is no copyright assignment to the OpenRail Association. Never suggest copyright assignment as a path.
- For the Apache 2.0 LICENSE file: the appendix at the end of the license text ("How to apply...") is a per-file header template, not meant to be filled into the LICENSE file itself. If a project has done this, note it and recommend keeping the LICENSE file as the unmodified license text only.
- For projects that are primarily documentation, YAML, or other non-code content, recommend `REUSE.toml` with glob patterns for license declarations rather than per-file SPDX headers. Per-file headers are impractical for Markdown and YAML files.
- When community health files (CODE_OF_CONDUCT, CONTRIBUTING, GOVERNANCE, MAINTAINERS) exist in the repo, compare them against the TC project templates and note specific gaps (missing sections, wrong contact email, missing DCO mention, missing MVG attribution, etc.). Do not just say "align with templates" — enumerate what differs.
