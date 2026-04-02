# Find Skills X 🎯

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Supported Platforms](https://img.shields.io/badge/Platforms-8%20支持-blue.svg)](https://github.com/jpwang1208/find-skills-x)

**AI驱动的技能发现系统，帮助你找到最合适的Agent技能**

## 📖 简介

Find Skills X 是一个智能技能发现工具，通过AI分析用户需求，跨多个平台并行搜索，找到最相关的Agent技能。支持 **8+ AI Agent平台**，包括 Claude Code、OpenCode、Gemini CLI、Cursor、Windsurf、Trae、Kiro、Codex。

## 🚀 核心特性

- **AI关键词分析**：提取核心关键词，智能扩展领域词和中英文变体
- **多渠道并行搜索**：同时搜索 skills.sh API、SkillHub、GitHub官方仓库等
- **智能去重排序**：合并结果，按官方认证、安装量、更新频率优先排序
- **跨平台支持**：兼容 8+ 主流 AI Agent 平台
- **官方优先原则**：优先展示 Anthropic、MiniMax、字节跳动、阿里Qwen 等大厂官方技能

## 🔧 支持的平台

| 平台 | 技能目录位置 | 配置文件 | 安装命令 |
|------|--------------|----------|----------|
| Claude Code | `~/.claude/skills/` | CLAUDE.md | `npx skills add {skill} -g -y` |
| OpenCode | `~/.config/opencode/skills/` | OPENCODE.md | `npx skills add {skill} -y` |
| Gemini CLI | `~/.gemini/skills/` | GEMINI.md | `npx skills add {skill} -g -y` |
| Cursor | `~/.cursor/skills/` | .cursor/skills.json | `npx skills add {skill} -g -y` |
| Windsurf | `~/.windsurf/skills/` | .windsurf/skills.json | `npx skills add {skill} -g -y` |
| Trae | `~/.trae/skills/` | .trae/skills.json | `npx skills add {skill} -g -y` |
| Kiro | `~/.kiro/skills/` | KIRO.md | `npx skills add {skill} -g -y` |
| Codex | `~/.codex/skills/` | CODEX.md | `npx skills add {skill} -g -y` |

## 📦 安装方法

### 快速安装

```bash
npx skills add jpwang1208/find-skills-x
```

### 手动安装

1. 克隆仓库
```bash
git clone https://github.com/jpwang1208/find-skills-x.git
```

2. 复制 skill 目录到你的平台技能文件夹
```bash
# Claude Code
cp -r find-skills-x/skill ~/.claude/skills/find-skills-x

# OpenCode
cp -r find-skills-x/skill ~/.config/opencode/skills/find-skills-x
```

## 🎯 使用方法

### 触发关键词

当你问以下问题时，技能会自动激活：
- "怎么实现X？"
- "找个X的skill"
- "有没有X功能的skill？"
- "我需要一个skill..."

### 使用示例

```
用户: "怎么实现用户认证？"

AI分析:
├── 核心词: ["authentication"]
├── 扩展词: ["auth", "login", "jwt", "oauth", "session"]
└── 搜索: skills.sh、GitHub、SkillHub

返回结果:
🎯 authentication-gateway
   企业级认证解决方案，支持JWT/OAuth
   📦 skills.sh ｜ 📊 50,000+ 安装
   安装: npx skills add anthropic/authentication-gateway

🎯 auth-flow-manager
   完整的用户认证流程管理
   📦 GitHub ｜ ⭐ 1,200+
   安装: npx skills add minimax/auth-flow-manager
```

## 📁 项目结构

```
find-skills-x/
├── skill/                   # 核心技能文件
│   ├── SKILL.md             # 技能定义和工作流程
│   ├── evals/               # 评估测试
│   ├── references/          # 配置参考
│   │   ├── channels.json    # 搜索渠道配置
│   │   ├── platforms.json   # 平台兼容性
│   │   └ quality-assessment.md
│   └── scripts/             # 辅助脚本
├── README.md                # 英文文档
├── README_CN.md             # 中文文档
├── LICENSE                  # MIT 许可证
└── .gitignore
```

## 🔍 搜索渠道

技能会从 10+ 个渠道并行搜索：

| 渠道 | 技能数量 | 搜索方式 | 优先级 |
|------|----------|----------|--------|
| skills.sh | 86,000+ | API | ⭐⭐⭐⭐ |
| 腾讯 SkillHub | 25,000+ | CLI | ⭐⭐⭐ |
| SkillsMP | 71,000+ | Web | ⭐⭐⭐ |
| Anthropic 官方 | 50+ | GitHub | ⭐⭐⭐ |
| MiniMax 官方 | - | GitHub | ⭐⭐⭐ |
| 字节跳动官方 | - | GitHub | ⭐⭐⭐ |
| 阿里 Qwen 官方 | - | GitHub | ⭐⭐⭐ |
| GitHub Topics | - | CLI | ⭐⭐⭐ |
| CocoLoop | 5,000+ | Web | ⭐⭐ |
| ClawHub | 50+ | CLI | ⭐⭐ |
| OpenClaw Directory | 精选 | Web | ⭐⭐ |
| GitHub Code Search | - | CLI | ⭐⭐ |

## 🤝 贡献指南

欢迎贡献！请随时提交 Pull Request。

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 📚 文档链接

- [技能工作流程详解](skill/SKILL.md)
- [平台兼容性指南](skill/references/platforms.json)
- [搜索渠道配置](skill/references/channels.json)
- [质量评估标准](skill/references/quality-assessment.md)

## 🌐 相关链接

- **GitHub仓库**: https://github.com/jpwang1208/find-skills-x
- **技能市场**: https://skills.sh
- **问题反馈**: https://github.com/jpwang1208/find-skills-x/issues

---

**Made with ❤️ by [jpwang1208](https://github.com/jpwang1208)**