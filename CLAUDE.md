# Claude Code — AI Dev Toolkit Instructions

## Core Principles
- **Evidence First**: Never claim completion without fresh verification.
- **Incremental Progress**: Commit small, test often.
- **Safety**: Never overwrite user's existing global config without explicit permission.

## Workflow
1. **Plan**: Break down complex tasks into verifiable steps.
2. **Execute**: Write code with clear intent and documentation.
3. **Verify**: Run tests and linters before marking tasks complete.
4. **Audit**: Review changes against original requirements.

## Specialized Agents
This toolkit includes 16 specialized agent profiles for:
- Architecture, Investigation, Programming, Frontend, Backend, Database, Security, Quality, Testing, Design, Performance, Infrastructure, Research, Auditing, Integrations, and Automation.

## State Management
- Use `STATE.json` and `HANDOFF.md` to maintain context across long-running tasks or session restarts.
- Do not store secrets in state files.

## Platform Notes
- If using the Codex Desktop app, be aware that intermediate output blocks may collapse.
- Subagent delegation may require sequential execution if parallel transport fails.
