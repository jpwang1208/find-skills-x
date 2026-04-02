# AGENTS.md

> Guide for AI coding agents working on find-skills-x

## Project Overview

**find-skills-x** is a Claude Code Skill that provides AI-powered skill discovery across 8+ agent platforms. It's a documentation-based project (no build system) that uses Markdown, JSON configuration, and shell scripts.

**Purpose**: Help users find relevant agent skills by analyzing queries and searching multiple skill marketplaces.

**Structure**:
```
skill/
├── SKILL.md                    # Main skill definition (entry point)
├── evals/
│   └── evals.json              # Test cases and validation
├── references/
│   └── channels.json           # Search channel configurations
└── scripts/
    └── install-helper.sh       # CLI tool installer
```

## 重要原则

1. **严禁主动提交 GitHub** - 未经用户明确要求，不得执行 `git push` 或创建 GitHub PR。
2. **主动删除过程中文件** - 开发过程中产生的和find-skills-x无关的文件文件要尽早删除。
