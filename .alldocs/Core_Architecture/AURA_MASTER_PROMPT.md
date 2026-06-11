# OpenCode Enhanced - Master Prompt for Coding Agent

## Overview

You are building **OpenCode Enhanced** - an enhanced fork of OpenCode that integrates Claude Code's architectural features. This is a TypeScript Node.js project that provides an AI coding agent with 30+ tools, a skills framework, parallel sub-agents (buddy system), advanced query engine, IDE bridge, and task coordination.

## What's Already Built (39 Source Files)

### Project Structure
```
opencode-enhanced/
├── package.json           # Dependencies and scripts
├── tsconfig.json          # TypeScript config (ES2024, NodeNext)
├── README.md              # Full documentation
├── scripts/
│   └── build.js           # esbuild bundler script
└── src/
    ├── types/index.ts     # All TypeScript type definitions
    ├── index.ts           # Main library entry point
    ├── cli.ts             # CLI interface (commander)
    ├── tools/
    │   ├── registry.ts    # Tool registration & execution engine
    │   ├── AgentTool/         # Sub-agent spawning
    │   ├── AskUserQuestionTool/ # User interaction
    │   ├── BashTool/          # Shell execution with safety
    │   ├── BriefTool/         # Code summarization
    │   ├── ConfigTool/        # Configuration management
    │   ├── EnterPlanModeTool/ # Read-only mode
    │   ├── FileEditTool/      # Precise file editing (replace/insert/delete/regex)
    │   ├── FileReadTool/      # File reading with line ranges & syntax detection
    │   ├── FileWriteTool/     # File writing with diff preview
    │   ├── GlobTool/          # File globbing with filters
    │   ├── GrepTool/          # Regex search with context
    │   ├── LSPTool/           # Language Server Protocol
    │   ├── MCPTool/           # Model Context Protocol
    │   ├── NotebookEditTool/  # Jupyter notebook editing
    │   ├── PowerShellTool/    # Windows PowerShell
    │   ├── REPLTool/          # Interactive REPL (node/python/ruby)
    │   ├── RemoteTriggerTool/ # HTTP/webhook triggers
    │   ├── ScheduleCronTool/  # Cron scheduling
    │   ├── SendMessageTool/   # Messaging
    │   ├── SkillTool/         # Skills loading
    │   ├── SleepTool/         # Execution pause
    │   └── TaskCreateTool/    # Task management
    ├── skills/
    │   └── framework.ts     # 8 built-in domain skills
    ├── buddy/
    │   └── system.ts        # Sub-agent spawning & coordination
    ├── query/
    │   └── engine.ts        # Intent analysis, semantic search, planning
    ├── bridge/
    │   └── system.ts        # IDE integration via WebSocket
    └── coordinator/
        └── engine.ts        # Task decomposition & parallel execution
```

### What Was Added (Enhancements Over OpenCode)

1. **30+ Tool System** (OpenCode has ~10) - Full tool registry with validation, permissions, middleware, history tracking, and 22 individual tools covering filesystem, search, execution, MCP, notebooks, scheduling, communication, analysis, and meta operations.

2. **Skills Framework** - 8 built-in domain skills (React, API Design, Testing, Database, DevOps, Security, TypeScript, Refactoring) with auto-detection based on workspace file patterns and intent analysis. Skills provide contextual prompt augmentation.

3. **Buddy System** - Parallel sub-agent spawning. Up to 5 concurrent buddies, each with their own toolset and read-only mode. Auto-suggests parallelization strategies based on task analysis.

4. **Query Engine** - Intent classification (search/modify/analyze/debug/test), multi-step query planning, semantic relevance scoring, related file discovery via import analysis.

5. **Bridge System** - WebSocket-based IDE integration. Supports VS Code, Zed. Can open files, send diffs, focus locations, broadcast messages.

6. **Task Coordinator** - Automatic task decomposition, dependency graph building, parallel group identification (Kahn's algorithm), buddy-based execution.

7. **Advanced Tools from Claude Code**: NotebookEdit (Jupyter), ScheduleCron (recurring tasks), REPL (interactive coding), RemoteTrigger (webhooks), FileEdit (multi-operation editing), Brief (code summarization).

## Build & Test Instructions

### Step 1: Install Dependencies
```bash
cd opencode-enhanced
npm install zod chalk axios execa globby highlight.js ignore marked picomatch semver strip-ansi tree-kill ws commander diff @anthropic-ai/sdk @modelcontextprotocol/sdk typescript esbuild @types/node @types/react @types/ws @types/diff tsx
```

If npm install fails due to cache issues:
```bash
rm -rf node_modules package-lock.json
npm cache clean --force
npm install <packages...>
```

### Step 2: Type Check
```bash
npx tsc --noEmit
```
Fix ALL type errors before proceeding. Common issues:
- Missing `declare module` for packages without types
- Import path issues (must use `.js` extensions for ESM)
- `import.meta.dirname` - use `const __dirname = new URL(".", import.meta.url).pathname;`

### Step 3: Build
```bash
npm run build
```
This runs esbuild to bundle `src/index.ts` and `src/cli.ts` into `dist/`.

If esbuild fails:
```bash
npx esbuild src/index.ts src/cli.ts --bundle --platform=node --target=node20 --format=esm --outdir=dist --sourcemap --external:zod --external:chalk --external:axios --external:execa --external:globby --external:highlight.js --external:ignore --external:marked --external:picomatch --external:semver --external:strip-ansi --external:tree-kill --external:ws --external:commander --external:diff --external:@anthropic-ai/sdk --external:@modelcontextprotocol/sdk
```

### Step 4: Test CLI
```bash
node dist/cli.js --help
node dist/cli.js tools
node dist/cli.js skills
node dist/cli.js tool FileRead --args '{"path": "package.json", "limit": 20}' --workspace .
```

### Step 5: Verify All Imports Work
```bash
node -e "import('./dist/index.js').then(m => console.log('Exports:', Object.keys(m)))"
```

## Known Issues & How To Fix

### Issue 1: npm install cache corruption
**Symptom**: ENOTEMPTY errors during install  
**Fix**: `rm -rf node_modules package-lock.json && npm cache clean --force && npm install`

### Issue 2: import.meta.dirname not available
**Symptom**: `TypeError: Cannot read properties of undefined (reading 'dirname')`  
**Fix**: Replace `import.meta.dirname` with:
```typescript
const __dirname = new URL(".", import.meta.url).pathname;
```

### Issue 3: ESM import paths need .js extension
**Symptom**: `Cannot find module` for local imports  
**Fix**: All local imports must end with `.js`:
```typescript
import { toolRegistry } from "../tools/registry.js";
```

### Issue 4: Missing type declarations
**Symptom**: `Could not find a declaration file for module 'X'`  
**Fix**: Add to `src/types/index.ts` or create declaration files:
```typescript
declare module "package-name" {
  export = any;
}
```

### Issue 5: esbuild external dependencies
**Symptom**: Bundled dependencies causing runtime errors  
**Fix**: The build script already externalizes all deps. If adding new deps, add them to the `external` array in `scripts/build.js`.

### Issue 6: Bundling `diff` package
**Symptom**: `createTwoFilesPatch` not found  
**Fix**: Import is `import { createTwoFilesPatch } from "diff";`. If this fails, use dynamic import:
```typescript
const { createTwoFilesPatch } = await import("diff");
```

## Testing Checklist

Run these tests in order:

1. **Type Checking**: `npx tsc --noEmit` - must pass zero errors
2. **Build**: `npm run build` - must produce `dist/index.js` and `dist/cli.js`
3. **CLI Help**: `node dist/cli.js --help` - must show commands
4. **Tools List**: `node dist/cli.js tools` - must show 30+ tools
5. **Skills List**: `node dist/cli.js skills` - must show 8 skills
6. **FileRead Tool**: `node dist/cli.js tool FileRead --args '{"path": "README.md", "limit": 10}' --workspace .` - must read file
7. **Grep Tool**: `node dist/cli.js tool Grep --args '{"pattern": "Tool", "path": ".", "maxResults": 5}' --workspace .` - must find matches
8. **Library Import**: `node -e "import('./dist/index.js').then(m => console.log(typeof m.EnhancedOpenCode))"` - must output "function"

## If Build Fails - Iteration Strategy

1. Run `npx tsc --noEmit` first - fix ALL TypeScript errors
2. Check all `.js` extensions on local imports
3. Verify no circular dependencies
4. Try building with `npx esbuild src/index.ts --bundle --platform=node --format=esm --outfile=dist/test.js --external:*` to test
5. Add `--log-level=debug` to esbuild for verbose output
6. Check Node version: `node --version` (must be >= 20)

## Architecture Decisions

- **TypeScript strict mode**: All code must be type-safe
- **ESM only**: No CommonJS, use `.js` extensions on imports
- **Node 20+**: Use modern Node APIs
- **No bundled dependencies**: Externalize all runtime deps
- **Model-neutral**: Works with any LLM provider (Anthropic, OpenAI, etc.)
- **MIT licensed**: Clean room implementation, no proprietary code

## Extending The Project

To add a new tool:
1. Create `src/tools/MyTool/index.ts` exporting a `ToolDefinition`
2. Import and register in `src/tools/registry.ts`
3. Add to the default tools array

To add a new skill:
1. Add to `registerBuiltInSkills()` in `src/skills/framework.ts`

To add a new CLI command:
1. Add to `src/cli.ts` using Commander.js
