---
name: find-skills-x
description: AI驱动的skill发现工具。当用户问"怎么实现X"、"找个X的skill"、"有没有X功能的skill"时使用。
version: 4.0.0
compatibility:
  - Claude Code
  - OpenCode
  - OpenClaw
  - Gemini CLI
  - Cursor
  - Windsurf
  - Trae
  - Codex
---

# Find Skills X

## 工作流程

```
用户输入
  ↓
┌─────────────────────────────────┐
│ 1️⃣ AI 关键词分析                │
│    提取核心词、扩展相关词         │
└─────────────────────────────────┘
  ↓
┌─────────────────────────────────┐
│ 2️⃣ 多渠道并行搜索               │
│    skills.sh API + SkillHub + GH │
└─────────────────────────────────┘
  ↓
┌─────────────────────────────────┐
│ 3️⃣ 结果合并去重                 │
│    按安装量/质量排序             │
└─────────────────────────────────┘
  ↓
输出推荐结果
```

---

## 1️⃣ AI 关键词分析

**目标**：从用户输入中提取最有效的搜索关键词。

### Prompt 模板

```
分析用户输入，提取搜索关键词。

用户输入: "{query}"

输出 JSON:
{
  "core": ["核心关键词"],
  "expanded": {
    "domain": ["领域扩展"],
    "i18n": ["中英文扩展"]
  }
}

示例:
输入: "用户认证"
输出: {
  "core": ["authentication"],
  "expanded": {
    "domain": ["auth", "login", "security","jwt", "oauth", "session", "token"],
    "i18n": ["user authentication", "login"]
  }
}

输入: "安卓开发"
输出: {
  "core": ["android"],
  "expanded": {
    "domain": ["mobile", "kotlin", "java","jetpack", "compose"],
    "i18n": ["android"]
  }
}
```

---

## 2️⃣ 多渠道搜索

### 搜索策略

**优先级：API > CLI > Web**

按 `references/channels.json` 中配置的 `search_method` 执行：

| search_method | 执行方式 | 说明 |
|---------------|----------|------|
| API | `curl {api_endpoint}` | 只返回元数据，不下载代码 |
| CLI | `{cli_command}` | 只返回元数据，不下载代码 |
| Web | librarian agent 或手动访问 | 浏览网页，不下载代码 |
| GitHub | `gh search repos --json` | 只返回仓库元数据（name/desc/url/stars） |

**关键区分**：
- 🔍 **搜索阶段**：只获取元数据（名称、描述、安装量、URL）→ 不下载代码
- ⬇️ **安装阶段**：`npx skills add {owner}/{repo}` → 才下载技能文件到本地

### GitHub 多技能仓库扫描

对于包含多个 skills 的 GitHub 仓库（如 MiniMax-AI/skills），需要扫描目录结构识别每个 skill。

**判断标准**（必须全部满足）：
1. 目录包含 `SKILL.md` 文件
2. `SKILL.md` 包含 `name:` 字段
3. `SKILL.md` 包含 `description:` 字段

**扫描流程**：

```bash
# Step 1: 获取根目录结构
gh api repos/{owner}/{repo}/contents --jq '.[].name'

# Step 2: 递归检查每个子目录是否包含 SKILL.md
gh api repos/{owner}/{repo}/contents/{potential-skill-dir}/{subdir}/SKILL.md

# Step 3: 解析 SKILL.md 获取 name 和 description
gh api repos/{owner}/{repo}/contents/{skill-path}/SKILL.md --jq '.content' | base64 -d | grep -E "^(name|description):"

# Step 4: 确认是有效 skill → 返回
{
  "name": "frontend-dev",
  "description": "Full-stack frontend development...",
  "path": "skills/frontend-dev"
}
```

**示例**：MiniMax-AI/skills 仓库

```bash
# 扫描发现 14 个有效 skills：
✅ frontend-dev (name + description + SKILL.md)
✅ fullstack-dev (name + description + SKILL.md)
✅ minimax-pdf (name + description + SKILL.md)
...

# 输出格式：
📦 MiniMax-AI/skills (14 skills)
   🎯 frontend-dev: Full-stack frontend development...
   🎯 fullstack-dev: Full-stack backend architecture...
   🎯 minimax-pdf: Professional PDF creation...
```

**给 AI 的分析 prompt**：

```
分析目录结构，识别潜在的 skill 目录：

验证步骤：
1. 检查目录是否包含 SKILL.md 文件
2. 解析 SKILL.md 是否有 name 和 description 字段
3. 确认是有效 skill

目录结构：
{gh_api_contents_json}

返回：
{
  "valid_skills": [
    {
      "name": "{skill-name}",
      "description": "{skill-description}",
      "path": "{owner}/{repo}/{skill-path}"
    }
  ]
}
```

### 并行搜索示例

```bash
# 关键词: "authentication"

# 1. skills.sh API
curl "https://skills.sh/api/search?q=authentication&limit=20"

# 2. SkillHub CLI
skillhub search authentication

# 3. GitHub
gh search repos "authentication" --topic claude-skill --limit 10
```

---

## 3️⃣ 结果处理

### 去重

按 `name` 字段去重，保留安装量最高的。

### 排序

优先级：
1. **官方认证** - 大厂维护
2. **安装量** - 社区验证
3. **更新时间** - 维护活跃度

### 输出格式

#### 安装命令规则

**统一使用 skills 命令安装**（支持所有来源）：

| 技能来源 | 安装命令格式 |
|---------|-------------|
| skills.sh 单技能仓库 | `npx skills add {owner}/{repo}` |
| skills.sh 多技能仓库 | `npx skills add {owner}/{repo}/{skill-id}` |
| GitHub 单技能仓库 | `npx skills add {owner}/{repo}` |
| GitHub 多技能仓库 | `npx skills add {owner}/{repo}/{skill-id}` |

**原则**：`npx skills add` 命令统一支持从 GitHub 或 skills.sh 安装。多技能仓库需指定具体 skill-id。

**多技能仓库示例**：
```
仓库: legout/data-platform-agent-skills
包含技能:
  - data-science-eda
  - data-science-visualization
  - data-science-feature-engineering

安装命令:
  npx skills add legout/data-platform-agent-skills/data-science-eda
  npx skills add legout/data-platform-agent-skills/data-science-visualization
```

#### 单个结果

```
🎯 {skill-name}
   {一句话描述}

📦 {来源} ｜ 📊 {安装量}
安装方式:npx skills add {完整路径}
```

**完整路径格式**：
- 单技能仓库：`{owner}/{repo}`
- 多技能仓库：`{owner}/{repo}/{skill-id}`

#### 多个结果

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 搜索结果：{关键词}（共 N 个）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟢 官方认证
───────────────────────────────────────
🎯 {skill-1}
   {描述}
   📦 skills.sh ｜ 📊 50,000+
   安装方式:npx skills add {owner}/{repo}/{skill-id}

⭐ 社区推荐
───────────────────────────────────────
🎯 {skill-2}
   {描述}
   📦 GitHub ｜ ⭐ 1,000+
   安装方式:npx skills add {owner}/{repo}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
🎯 {skill-name}
   {一句话描述}

📦 {来源} ｜ 📊 {安装量}
安装方式:{安装命令}
```

#### 多个结果

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 搜索结果：{关键词}（共 N 个）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟢 官方认证
───────────────────────────────────────
🎯 {skill-1}
   {描述}
   📦 skills.sh ｜ 📊 50,000+
   安装方式:/install skills.sh:xxx

⭐ 社区推荐
───────────────────────────────────────
🎯 {skill-2}
   {描述}
   📦 SkillHub ｜ 📊 10,000+
   安装方式:/install skillhub:xxx

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 渠道配置

> 📋 **完整配置**：`references/channels.json`

### 搜索方式优先级

**API > CLI > Web**

按配置文件中的 `search_method` 字段执行搜索。

---

## 官方优先原则

大厂官方技能优先展示：

- **Anthropic** - Claude官方
- **MiniMax** - 国内AI大厂
- **字节跳动** - 抖音/飞书官方
- **阿里Qwen** - 通义千问官方
- **Vercel Labs** - Next.js官方

输出时使用 🟢 标识官方技能。

---

## 安装辅助

```bash
# 查看工具状态
./scripts/install-helper.sh status

# 安装所有工具
./scripts/install-helper.sh all

# 安装单个工具
./scripts/install-helper.sh gh        # GitHub CLI
./scripts/install-helper.sh skillhub  # SkillHub CLI
```