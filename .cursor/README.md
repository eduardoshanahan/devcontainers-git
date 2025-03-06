# Cursor Configuration Directory

This directory contains configuration files and rules for the Cursor IDE
environment.

## Directory Structure

```text
.cursor/
├── README.md           # This file
└── rules/             # Cursor-specific rules and guidelines
    ├── README.md      # Overview of all rules
    ├── branch-naming.md
    ├── code-review.md
    ├── commit-messages.md
    ├── no-emojis.md
    ├── organization.md
    ├── project-settings.md
    └── versioning.md
```

## Purpose

The `.cursor` directory serves as a central location for Cursor IDE-specific
configurations and guidelines. It helps maintain consistency in development
practices and ensures all team members follow the same standards.

## Rules

The `rules/` directory contains markdown files that define various development
guidelines:

- **Branch Naming**: Standards for Git branch naming conventions
- **Code Review**: Guidelines for conducting code reviews
- **Commit Messages**: Standards for writing commit messages
- **No Emojis**: Policy on avoiding emoji usage in code and documentation
- **Organization**: Project structure and organization guidelines
- **Project Settings**: IDE and project-specific settings
- **Versioning**: Version control and release management guidelines

Each rule file contains detailed explanations and examples to help maintain
consistency across the project.

## Usage

These rules are automatically loaded by Cursor IDE and should be followed by all
team members. They help maintain code quality and consistency throughout the
project.

## Contributing

When adding new rules or modifying existing ones:

1. Create or update the appropriate markdown file in the `rules/` directory
2. Update the main `rules/README.md` to reflect any changes
3. Ensure all rules are clear, concise, and well-documented
