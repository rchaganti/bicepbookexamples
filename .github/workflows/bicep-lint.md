---
name: Bicep Schema and Feature Check
description: >
  Checks all .bicep files in the repository for schema issues, linting errors,
  and feature updates based on the latest Azure Bicep release.

on:
  schedule: "weekly"
  pull_request:
    paths:
      - "**/*.bicep"
      - "**/*.bicepparam"
      - "**/bicepconfig.json"
  push:
    branches:
      - main
    paths:
      - "**/*.bicep"
      - "**/*.bicepparam"
      - "**/bicepconfig.json"
  workflow_dispatch:

permissions:
  contents: read
  issues: read
  pull-requests: read

steps:
  - name: Install Bicep CLI
    run: |
      curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64
      chmod +x ./bicep
      sudo mv ./bicep /usr/local/bin/bicep
      bicep --version

tools:
  edit:
  bash:
    - "bicep *"
    - "find *"
    - "jq *"
    - "cat *"
    - "echo *"
    - "ls *"
    - "diff *"
    - "python3 *"
    - "chmod *"
    - "bash *"
  web-fetch:
  github:
    toolsets: [repos, issues, pull_requests]

network:
  allowed:
    - "defaults"
    - "github"

safe-outputs:
  allowed-github-references: ["repo"]
  create-issue:
    title-prefix: "[Bicep Lint] "
    labels: ["bicep", "automated"]
    max: 1
    close-older-issues: true
    footer: true
---

# Bicep Schema and Feature Check

You are a Bicep linting and schema validation agent. The Bicep CLI has already been pre-installed for you. Your job is to check all `.bicep` files in this repository for issues and report on available feature updates.

## Step 1: Verify Bicep CLI

Run `bicep --version` to confirm the CLI is available and record the version for the report.

## Step 2: Check the latest Bicep release

Use `web_fetch` to get release information from `https://api.github.com/repos/Azure/bicep/releases/latest`. Extract:

- The latest version tag
- The release date
- Key highlights from the release notes (new features, deprecations, breaking changes)

## Step 3: Lint all Bicep files

Find all `.bicep` files in the repository and run `bicep build` on each one to catch schema and linting issues.

For each file, run:

```
bicep build <file-path> --stdout 2>&1
```

Capture the output. Record any warnings or errors per file.

**Important**: Some files reference external modules (Azure Container Registry, template specs) or use experimental features. If a build fails due to a missing external module or registry reference, note it as an **external dependency** rather than a schema error. Focus on issues that can be resolved within the repository.

## Step 4: Check for bicepconfig.json issues

Locate all `bicepconfig.json` files in the repository and review them for:

- Deprecated configuration options
- Experimental features that have been promoted to stable in the latest Bicep release
- Missing recommended linting rules
- Invalid or outdated analyzer rule names

## Step 5: Check for API version currency

For each `.bicep` file, examine the resource declarations and check if the API versions used are current. Flag any resources using API versions that are more than 2 years old as candidates for update.

## Step 6: Generate the report

Create a summary issue with the following sections:

### Report Structure

1. **Bicep Version**: The installed Bicep CLI version and latest release highlights
2. **Linting Results Summary**: Total files scanned, files with errors, files with warnings, clean files
3. **Errors**: List each file with errors, including the specific error messages
4. **Warnings**: List each file with warnings, including the specific warning messages
5. **External Dependencies**: Files that reference external modules or registries
6. **Configuration Review**: Findings from bicepconfig.json analysis
7. **API Version Updates**: Resources using outdated API versions with recommended updates
8. **Feature Opportunities**: New Bicep features from recent releases that could benefit this codebase (e.g., new decorators, improved type system features, new built-in functions)

### Formatting Guidelines

- Use tables for file-level summaries
- Use code blocks for specific error/warning messages
- Group findings by chapter/directory for readability
- Include actionable recommendations where possible
- If this is a pull request, also add a summary comment on the PR

If there are no issues found, still create the report confirming all files passed validation, and include any relevant feature update opportunities.
