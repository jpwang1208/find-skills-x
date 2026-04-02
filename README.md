# Find Skills X 🎯

[中文文档](README_CN.md) | **English**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Compatible](https://img.shields.io/badge/Platforms-8%2B-blue.svg)](https://github.com/jpwang1208/find-skills-x)

**AI-powered skill discovery tool that helps you find the perfect agent skills for your needs.**

## 📖 Overview

Find Skills X is an intelligent skill discovery system that analyzes your requirements and automatically searches across multiple platforms to find the most relevant agent skills. It supports **8+ AI agent platforms** including Claude Code, OpenCode, Gemini CLI, Cursor, Windsurf, Trae, and Codex.

## 🚀 Features

- **AI Keyword Analysis**: Extracts core keywords and expands search terms across domains and languages
- **Multi-Channel Search**: Parallel search across skills.sh API, SkillHub, GitHub, and official vendor repositories
- **Smart Deduplication**: Merges results and prioritizes by official certification, installation count, and update frequency
- **Cross-Platform Support**: Works with 8+ AI agent platforms
- **Official Priority**: Highlights skills from Anthropic, MiniMax, ByteDance, Alibaba Qwen, and other major vendors

## 🔧 Supported Platforms

| Platform | Skills Directory | Config File | Install Command |
|----------|------------------|-------------|-----------------|
| Claude Code | `~/.claude/skills/` | CLAUDE.md | `npx skills add {skill} -g -y` |
| OpenCode | `~/.config/opencode/skills/` | OPENCODE.md | `npx skills add {skill} -y` |
| Gemini CLI | `~/.gemini/skills/` | GEMINI.md | `npx skills add {skill} -g -y` |
| Cursor | `~/.cursor/skills/` | .cursor/skills.json | `npx skills add {skill} -g -y` |
| Windsurf | `~/.windsurf/skills/` | .windsurf/skills.json | `npx skills add {skill} -g -y` |
| Trae | `~/.trae/skills/` | .trae/skills.json | `npx skills add {skill} -g -y` |
| Kiro | `~/.kiro/skills/` | KIRO.md | `npx skills add {skill} -g -y` |
| Codex | `~/.codex/skills/` | CODEX.md | `npx skills add {skill} -g -y` |

## 📦 Installation

### Quick Install

```bash
npx skills add jpwang1208/find-skills-x
```

### Manual Install

1. Clone the repository:
```bash
git clone https://github.com/jpwang1208/find-skills-x.git
```

2. Copy the skill directory to your platform's skills folder:
```bash
# For Claude Code
cp -r find-skills-x/skill ~/.claude/skills/find-skills-x

# For OpenCode
cp -r find-skills-x/skill ~/.config/opencode/skills/find-skills-x
```

## 🎯 Usage

### Trigger Keywords

The skill automatically activates when you ask:
- "How do I implement X?"
- "Find a skill for X"
- "Is there a skill that can..."
- "I need a skill for..."

### Example Workflow

```
User: "How do I implement user authentication?"

AI Analysis:
├── Core: ["authentication"]
├── Expanded: ["auth", "login", "jwt", "oauth", "session"]
└── Search Channels: skills.sh, GitHub, SkillHub

Results:
🎯 authentication-gateway
   Enterprise-grade authentication with JWT/OAuth support
   📦 skills.sh | 📊 50,000+
   Install: npx skills add anthropic/authentication-gateway

🎯 auth-flow-manager
   Complete authentication flow management
   📦 GitHub | ⭐ 1,200+
   Install: npx skills add minimax/auth-flow-manager
```

## 🗂️ Project Structure

```
find-skills-x/
├── skill/                   # Core skill files
│   ├── SKILL.md            # Skill definition and workflow
│   ├── evals/              # Evaluation tests
│   ├── references/         # Configuration files
│   │   └── channels.json   # Search channels config
│   └── scripts/            # Helper scripts
├── README.md               # This file
├── README_CN.md            # Chinese documentation
├── LICENSE                 # MIT License
└── .gitignore
```

## 🔍 Search Channels

The skill searches across 15+ channels:

| Channel | Skills Count | Method | Priority |
|---------|--------------|--------|----------|
| skills.sh | 86,000+ | API | ⭐⭐⭐ |
| Tencent SkillHub | 25,000+ | CLI | ⭐⭐⭐ |
| SkillsMP | 71,000+ | Web | ⭐⭐⭐ |
| Anthropic Official | 50+ | GitHub | ⭐⭐⭐ |
| MiniMax Official | - | GitHub | ⭐⭐⭐ |
| ByteDance Official | - | GitHub | ⭐⭐⭐ |
| Alibaba Qwen | - | GitHub | ⭐⭐⭐ |
| GitHub Topics | - | CLI | ⭐⭐⭐ |
| CocoLoop | 5,000+ | Web | ⭐⭐⭐ |
| ClawHub | 50+ | CLI | ⭐⭐ |
| OpenClaw Directory | Curated | Web | ⭐⭐ |
| GitHub Code Search | - | CLI | ⭐⭐ |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 Documentation

- [Skill Workflow Documentation](skill/SKILL.md)
- [Search Channels Configuration](skill/references/channels.json)

## 🌐 Links

- **Repository**: https://github.com/jpwang1208/find-skills-x
- **Skills Marketplace**: https://skills.sh
- **Report Issues**: https://github.com/jpwang1208/find-skills-x/issues

## 📝 Changelog

### v4.0.0 (2026-04-02)
- Initial public release
- AI-powered skill discovery across 8+ platforms
- Multi-channel search with 15+ sources
- Support for Chinese and English documentation

---

**Made with ❤️ by [jpwang1208](https://github.com/jpwang1208)**