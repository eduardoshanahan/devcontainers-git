# Rule: Project Settings Management

## Description

All project-wide settings and configuration files must be properly organized and
maintained in standard locations to ensure consistency and ease of maintenance.

## Structure

Project settings should be organized as follows:

- `.cursor/` - Cursor-specific settings and rules
- `.vscode/` - VS Code workspace settings
- `.gitignore` - Git ignore patterns
- `package.json` - Node.js project configuration (if applicable)
- `tsconfig.json` - TypeScript configuration (if applicable)
- `.env.example` - Example environment variables template
- `.editorconfig` - Editor configuration for consistent coding styles

## Examples

Good settings organization:

```text
project-root/
  ├── .cursor/
  │   └── rules/
  ├── .vscode/
  │   ├── settings.json
  │   └── extensions.json
  ├── .gitignore
  ├── package.json
  └── .editorconfig
```

Bad settings organization:

```text
project-root/
  ├── settings/
  │   └── vscode-config.json
  ├── config.json
  └── workspace-settings.json
```

## Enforcement

- All configuration files must be in the project root or appropriate
  subdirectories
- Configuration files must use standard naming conventions
- No custom/non-standard locations for config files
- All settings files must be version controlled (except for local/personal
  settings)
- Sensitive information must not be committed (use environment variables
  instead)
