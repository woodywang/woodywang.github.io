---
layout: post
title: "Two MCP Plugins That Doubled My Claude Code Productivity: Solving Stale Docs and Single-Model Limitations"
description: "Recommending Context7 and Zen MCP -- two practical MCP plugins that solve the pain points of outdated documentation and single-model limitations in AI programming, with installation guides and usage tips."
date: 2025-09-05 10:30:00 +0800
categories: [tech]
tags: [claude-code, mcp, ai-tools, productivity]
comments: true
mermaid: true
lang: en
permalink: /tech/2025/09/05/claude-code-mcp-recommendations.html
---

I recently saw some Claude Code MCP discussions on Twitter, which reminded me of two MCP plugins I've been using daily. As a security engineer who reviews code constantly, these tools genuinely solve real pain points in my workflow. Here's my experience with them.

## Pain Point #1: AI-Generated Code Is Always Outdated

I remember writing Ethereum smart contracts with Cursor and needing the ethers library for on-chain interactions. The AI kept generating v5 syntax, but our project was on v6. The ethers library underwent massive API restructuring in v6 -- method names and calling conventions were completely different.

```mermaid
graph TD
    A[需要使用 ethers 库] --> B[AI 生成代码]
    B --> C[使用 v5 语法]
    C --> D[运行报错]
    D --> E[手动查 v6 文档]
    E --> F[告诉 AI 正确写法]
    F --> G[重新生成代码]
    G --> H{还有错误?}
    H -->|是| D
    H -->|否| I[终于能用]

    style D fill:#ffcccc
    style E fill:#fff2cc
    style I fill:#d4edda
```

Every single time, it was the same loop: AI generates code, runtime error, manually check docs, teach the AI the correct approach, regenerate. When you need to call dozens of different methods, this cycle is absolutely maddening.

Then I discovered **Context7 MCP** -- a genuine lifesaver.

### Context7: Real-Time Access to Latest Documentation

The core idea is simple but effective: fetch the latest content from official documentation in real time and inject it directly into the AI's context. No more worrying about the AI's "knowledge" being outdated.

```mermaid
graph LR
    A[用户请求] --> B[Context7 MCP]
    B --> C[实时抓取官方文档]
    C --> D[注入到 AI 上下文]
    D --> E[AI 基于最新文档生成代码]
    E --> F[一次写对!]

    subgraph "支持的文档源"
        G[OpenZeppelin]
        H[Symbiotic Protocol]
        I[ethers.js]
        J[React/Next.js]
        K[更多...]
    end

    C --> G
    C --> H
    C --> I
    C --> J
    C --> K

    style F fill:#d4edda
```

**Installation:**
```bash
claude mcp add --transport http context7 https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: YOUR_API_KEY"
```

**Usage couldn't be simpler:** Just add "use context7" to your prompt.

The documentation coverage is impressive. Beyond mainstream frameworks like React and Next.js, it even covers niche Web3 domains:
- **OpenZeppelin Contracts**: Essential smart contract security library docs for DeFi projects
- **Symbiotic Protocol**: A relatively new shared security protocol -- I was surprised to see it supported
- **Major blockchain SDKs**: Full coverage from ethers to viem

Now my code compiles on the first try. The AI generates accurate code based on the latest APIs, completely eliminating version mismatches.

## Pain Point #2: A Single Model Has Its Limits

During code audits, I often need to uncover potential vulnerabilities. In practice, I've noticed an interesting pattern:
- **Claude Code** is a "workhorse" for coding -- it implements features quickly
- **GPT-5** excels at deep analysis, especially in scenarios requiring logical reasoning

For example, when auditing DeFi contracts:
- GPT-5 can dissect economic models and discover subtle attack vectors
- Claude Code is great at writing test cases to verify those vulnerabilities

Previously, I had to constantly switch between tools, copying and pasting -- terribly inefficient.

### Zen MCP: Multi-Model Orchestration

**Zen MCP** solves this perfectly by letting Claude call on other models' capabilities.

```mermaid
graph TD
    A[安全代码审核任务] --> B[Claude Code + Zen MCP]

    B --> C[调用 GPT-5 深度分析]
    C --> D[发现潜在风险点]

    B --> E[Claude Code 编写测试用例]
    D --> E
    E --> F[验证安全隐患]

    B --> G[调用 Gemini 生成报告]
    F --> G
    G --> H[结构化审核报告]

    subgraph "多模型协作"
        I[GPT-5: 深度思考分析]
        J[Claude: 代码编写执行]
        K[Gemini: 文档报告生成]
    end

    C -.-> I
    E -.-> J
    G -.-> K

    style H fill:#d4edda
```

I chose to connect via **OpenRouter** -- one configuration gives you access to multiple models: GPT-5, Gemini, various Claude versions, DeepSeek, and more. You can also configure individual platform APIs separately.

**Typical Workflow:**
1. **Deep analysis**: Call GPT-5 to identify code risk areas
2. **Vulnerability verification**: Claude writes test cases based on the analysis
3. **Report generation**: Use Gemini to produce a structured report

This division of labor lets each model play to its strengths: GPT-5 handles the "thinking," Claude handles the "doing" -- seamlessly connected.

### Installation and Configuration

**Option B: Instant Setup (Recommended)**

Add the following to `~/.claude/settings.json` or `.mcp.json`:

```json
{
  "mcpServers": {
    "zen": {
      "command": "bash",
      "args": ["-c", "for p in $(which uvx 2>/dev/null) $HOME/.local/bin/uvx /opt/homebrew/bin/uvx /usr/local/bin/uvx uvx; do [ -x \"$p\" ] && exec \"$p\" --from git+https://github.com/BeehiveInnovations/zen-mcp-server.git zen-mcp-server; done; echo 'uvx not found' >&2; exit 1"],
      "env": {
        "PATH": "/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin:~/.local/bin",
        "OPENROUTER_API_KEY": "your-key-here",
        "DISABLED_TOOLS": "analyze,refactor,testgen,secaudit,docgen,tracer",
        "DEFAULT_MODEL": "auto"
      }
    }
  }
}
```

Once configured, you can flexibly invoke various models from within Claude. It supports both OpenRouter API and individually configured platform API keys.

```mermaid
graph LR
    A[Claude Code] --> B[Zen MCP]
    B --> C[OpenRouter API]

    subgraph "可调用的模型"
        D[GPT-5/o3]
        E[Gemini Pro]
        F[Claude 各版本]
        G[DeepSeek]
        H[其他模型...]
    end

    C --> D
    C --> E
    C --> F
    C --> G
    C --> H

    style A fill:#e1f5fe
    style C fill:#f3e5f5
```

## Practical Tips

### Context7 Tips:
- **API key is optional**: It works without one, but having a key increases your rate limits
- **Use the topic parameter wisely**: Specify the documentation scope when focusing on a particular feature
- **Retry on network issues**: Failed doc fetches are usually caused by transient network hiccups

### Zen MCP Tips:
- **Don't overuse it**: For simple tasks, just use Claude directly
- **Define clear roles**: Analysis with GPT-5, coding with Claude
- **Manage costs**: Choose models on OpenRouter based on task importance

## Before and After

| Scenario          | Before                          | After                           |
|-------------------|---------------------------------|---------------------------------|
| API doc lookup    | Manual search, teach AI, retry  | "use context7" and it just works |
| Code auditing     | Switching between tools         | Analysis, coding, and reporting in one flow |
| Learning new tech | Risk of learning outdated patterns | Real-time access to best practices |
| Dev efficiency    | Constant debugging and rework   | Significantly less rework       |

## Conclusion

These two MCPs tackle core pain points head-on:
- **Context7** permanently solves the stale documentation problem
- **Zen MCP** breaks through single-model limitations

For developers working with complex tech stacks, these tools are genuine productivity multipliers. No flashy gimmicks -- just solid, tangible improvements to the development experience.

If you're using Claude, I strongly recommend giving these two MCPs a try. You'll wonder how you ever managed without them.

---

**Resources:**
- [Context7 GitHub](https://github.com/upstash/context7)
- [Zen MCP GitHub](https://github.com/BeehiveInnovations/zen-mcp-server)
- [Claude Code MCP Documentation](https://docs.anthropic.com/en/docs/claude-code/mcp)
