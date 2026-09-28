---
description: Coding standards enforcement for source code
paths:
  - "**/*.tf"
---

# Coding Standards

## IMPORTANT — Error Handling
- NEVER swallow errors silently. Explicit typed error handling
- Handle ALL promise rejections — no unhandled promises

## Comments & Code Hygiene
- **Do not comment by default.** A comment is the exception, not the habit. Applies to
  every language: Terraform, Python, Bash, YAML, everything.
- Write one ONLY when the code cannot carry the information by itself:
  - a non-obvious constraint (an API that rejects two fields at once, a provider bug)
  - a decision whose alternative looks better until you know why it was rejected
  - a link to an issue or a document that explains the workaround
- NEVER write a comment that restates the code. `ManagedBy = "Terraform"` does not need a
  line above it saying these are the common tags.
- NEVER caption a block with what it obviously is: no `# Variables`, `# Security group`,
  `# Tags applied to every resource`.
- If the code needs explaining, rename the thing before reaching for a comment.
- WHY not WHAT, and only when the WHY is not already evident.
- NEVER leave console.log, debugger, or commented-out code
