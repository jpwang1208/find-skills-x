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
│   ├── channels.json           # Search channel configurations
│   ├── platforms.json          # Platform compatibility config
│   └── quality-assessment.md   # Quality criteria
└── scripts/
    └── install-helper.sh       # CLI tool installer
```

## Commands

### Testing

No automated test runner. Test manually via:

```bash
# Test skills.sh API
curl -s "https://skills.sh/api/search?q=react&limit=5" | jq '.skills[:3]'

# Test GitHub search
gh search repos "skill" --topic claude-skill --limit 10 --json name,description

# Test skill installation
npx skills add jpwang1208/find-skills-x --list

# Verify channels
curl -s "https://skills.sh/api/search?q=authentication&limit=3" | jq '.skills | length'
```

### Validation

```bash
# Check JSON syntax
cat skill/references/channels.json | jq . > /dev/null && echo "✓ Valid JSON"

# Validate YAML frontmatter in SKILL.md
grep -E "^---$" skill/SKILL.md | wc -l  # Should be 2

# Check test case format
cat skill/evals/evals.json | jq '.test_cases[0]' > /dev/null
```

### Git Workflow

```bash
# Check status
git status

# Commit changes
git add skill/SKILL.md skill/evals/evals.json
git commit -m "feat: enhance keyword analysis"

# Push to GitHub
git push origin master

# Verify remote
git remote -v
```

### Installation Helper

```bash
# Check CLI tools status
./skill/scripts/install-helper.sh status

# Install all tools
./skill/scripts/install-helper.sh all

# Install specific tool
./skill/scripts/install-helper.sh gh
./skill/scripts/install-helper.sh skillhub
```

## Code Style Guidelines

### Markdown (SKILL.md)

**Structure**:
```markdown
---
name: skill-name
description: One-line description
version: x.x.x
compatibility:
  - Platform1
  - Platform2
---

# Main Title

## Section Header

### Subsection

**Bold** for important terms
`code` for commands, URLs, file paths
- Lists for multiple items

```

**Rules**:
- YAML frontmatter: `name`, `description`, `version`, `compatibility`
- Use emoji headers (1️⃣, 2️⃣, 3️⃣) for workflow steps
- Include examples for complex logic
- Chinese and English both acceptable
- Tables for structured data (commands, configs)

### JSON Configuration

**Format**:
```json
{
  "key": "value",
  "array": [
    {
      "id": "unique-id",
      "name": "Display Name",
      "property": "value"
    }
  ]
}
```

**Rules**:
- 2-space indentation
- Quote all keys
- Use descriptive keys (`search_method`, `api_endpoint`)
- Include `priority` for ordering
- Add `count` or `skills_count` for metrics

### Shell Scripts

**Style**:
```bash
#!/bin/bash
set -e

# Constants
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}ℹ${NC} $1"; }

# Main logic
main() {
    local action="${1:-default}"
    case "$action" in
        status) show_status ;;
        *) echo "Usage: $0 [status|all]" ;;
    esac
}

main "$@"
```

**Rules**:
- Always `set -e` for error handling
- Use functions for reusability
- Color codes for output (GREEN, RED, YELLOW)
- `local` for function variables
- `case` statements for argument parsing
- Show usage on invalid input

### File Naming

```
SKILL.md              # Main skill file (uppercase)
channels.json         # Lowercase with dashes
install-helper.sh     # Lowercase with dashes
quality-assessment.md # Lowercase with dashes
```

## Configuration Patterns

### Adding a Search Channel

Edit `skill/references/channels.json`:

```json
{
  "id": "channel-id",
  "name": "Display Name",
  "skills_count": "1000+",
  "search_method": "API|CLI|Web|GitHub",
  "api_endpoint": "https://api.example.com/search?q=<query>",
  "cli_command": "tool search <query>",
  "url": "https://example.com",
  "priority": 1
}
```

**Priority**: 1 = high, 2 = medium, 3 = low

### Adding a Test Case

Edit `skill/evals/evals.json`:

```json
{
  "id": "test-N",
  "description": "Test description",
  "input": "user query",
  "expected": {
    "min_results": 3,
    "keywords_to_search": ["keyword1", "keyword2"],
    "should_contain_skills": ["skill-name"],
    "note": "Expected behavior"
  }
}
```

### Modifying Keyword Analysis

Update the Prompt template in `skill/SKILL.md`:

```markdown
### Prompt 模板

\`\`\`
分析用户输入，提取搜索关键词。

用户输入: "{query}"

**关键规则**：
- 规则1
- 规则2

输出 JSON:
{
  "core": ["keywords"],
  "expanded": {
    "domain": ["expansions"],
    "i18n": ["translations"]
  }
}
\`\`\`
```

## Testing Strategy

### Manual Testing Process

1. **Keyword Extraction**: Verify AI extracts all keywords from compound queries
2. **API Calls**: Test each channel endpoint manually
3. **Result Quality**: Check if returned skills are relevant
4. **Edge Cases**: Test Chinese input, multi-language, fuzzy queries

### Test Case Categories

- **test-1 to test-3**: Single keyword searches (baseline)
- **test-4**: Fuzzy intent understanding
- **test-5 to test-6**: Compound keywords (critical)
- **test-7 to test-8**: Domain-specific queries

### Validation Checklist

```bash
# 1. JSON valid?
cat skill/references/channels.json | jq . > /dev/null

# 2. SKILL.md has frontmatter?
head -5 skill/SKILL.md | grep -E "^---$"

# 3. Test case has required fields?
cat skill/evals/evals.json | jq '.test_cases[] | keys'

# 4. Scripts executable?
ls -la skill/scripts/*.sh | grep -E "^-rwx"

# 5. Git clean?
git status --short
```

## Git Commit Conventions

Use conventional commits:

```
feat: add new feature
fix: fix bug or error
docs: documentation changes
refactor: code restructuring
test: add/update tests
chore: maintenance tasks
```

**Examples**:
```bash
git commit -m "feat: enhance keyword analysis for compound queries"
git commit -m "fix: handle Chinese domain words correctly"
git commit -m "docs: update examples in SKILL.md"
git commit -m "test: add test case for Java backend queries"
```

## Common Patterns

### Error Handling in Prompts

```markdown
**关键规则**：
- 提取所有重要关键词，不要遗漏
- 对领域词进行合理的英文转换
- 每个核心关键词都独立有价值，需要分别搜索
```

### Multi-language Support

```json
{
  "core": ["keyword"],
  "expanded": {
    "domain": ["technical-terms"],
    "i18n": ["中英文变体"]
  }
}
```

### Channel Priority Logic

```
API > CLI > Web
Priority 1 > Priority 2 > Priority 3
```

## Platform Compatibility

When adding new features, ensure compatibility with:

- ✅ Claude Code
- ✅ OpenCode
- ✅ Cursor
- ✅ Gemini CLI
- ✅ Windsurf
- ✅ Trae
- ✅ Codex

Test installation: `npx skills add jpwang1208/find-skills-x`

## Quick Reference

**Project Files**:
- `skill/SKILL.md` - Main skill logic
- `skill/evals/evals.json` - Test cases
- `skill/references/*.json` - Configuration
- `skill/scripts/*.sh` - Utilities

**Key Concepts**:
- AI keyword analysis
- Multi-channel parallel search
- Result deduplication
- Priority-based ranking

**Common Tasks**:
- Add channel → Edit `channels.json`
- Add test → Edit `evals.json`
- Update logic → Edit `SKILL.md`
- Install tools → Run `install-helper.sh`

---

**Last Updated**: 2026-04-02
**Version**: 4.0.0
**Maintainer**: Jensen <jpwang@vip.qq.com>