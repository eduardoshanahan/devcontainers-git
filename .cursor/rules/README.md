# Cursor Rules

This directory contains all Cursor rules for the project. Each rule is defined
in its own markdown file and follows a consistent structure.

## Rule Files

- [branch-naming.md](branch-naming.md) - Standards for Git branch naming
  conventions

- [code-review.md](code-review.md) - Guidelines for conducting code reviews

- [commit-messages.md](commit-messages.md) - Standards for writing commit
  messages

- [markdown-formatting.md](markdown-formatting.md) - Comprehensive markdown
  formatting standards

- [no-emojis.md](no-emojis.md) - Policy on avoiding emoji usage in code and
  documentation

- [organization.md](organization.md) - Project structure and organization
  guidelines

- [project-settings.md](project-settings.md) - IDE and project-specific settings

- [versioning.md](versioning.md) - Version control and release management
  guidelines

## Creating New Rules

1. Create a new markdown file in this directory
2. Use kebab-case for the file name (e.g., `my-new-rule.md`)
3. Follow the structure defined in [organization.md](organization.md)
4. Add the rule to this README
5. Ensure the rule follows our
   [markdown formatting standards](markdown-formatting.md)

## Structure

Each rule file should follow this structure:

```markdown
# Rule: [Rule Name]

## Overview

[Brief description of the rule and its purpose]

## Requirements

[Detailed requirements and specifications]

## Examples

[Provide clear examples of good and bad practices]

## Implementation

[Describe how the rule should be implemented and enforced]

## Benefits

[List the benefits of following this rule]

## Common Issues and Solutions

[Address common problems and their solutions]
```

## Contributing

When adding or modifying rules:

1. Follow the markdown formatting standards
2. Include clear examples
3. Provide implementation details
4. Update this README
5. Ensure all links are working
6. Test the rule's clarity and completeness

## Enforcement

Rules are enforced through:

- Pre-commit hooks

- Automated linting

- Code review guidelines

- Documentation checks

- Team practices
