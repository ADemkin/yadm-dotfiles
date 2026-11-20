---
name: OpenCode
description: Use this guide as the starting point for any work or question involving OpenCode itself — configuration, agents, commands, skills, plugins, MCP servers, keybinds, CLI, SDK, API, or troubleshooting.
---

# OpenCode

Use this guide as the starting point for work involving OpenCode itself. It
covers the core concepts needed to configure and customize OpenCode, extend it
with plugins, and build integrations with the OpenCode SDK, clients, and API.

Full documentation is available at <https://opencode.ai/docs/>. This overview is
only an index of core concepts. Before answering a question about a topic below,
fetch the URL named in that section and use the full page as the source of
truth. Follow links from that page when the question needs more detail. Fetch
<https://opencode.ai/docs/> first when you need to discover the relevant
documentation page.

A machine-readable documentation index is available at
<https://opencode.ai/docs/llms.txt>.

## Version policy

Always answer for OpenCode V2 unless the user explicitly asks about V1,
legacy OpenCode, or migrating from V1.

Use only <https://opencode.ai/docs/> documentation as the source of truth for V2.
Do not use general web search to resolve a V2 documentation question when the V2
docs or linked pages cover it. The schema served from
<https://opencode.ai/config.json> accepts both V2 fields and deprecated V1
fields. Never recommend a field it marks deprecated. If V2 documentation is
missing or contradictory, state the uncertainty or ask for clarification instead
of falling back to V1.

## [CLI](https://opencode.ai/docs/cli)

For questions about the terminal interface, command-line invocation, `run`,
`mini`, terminal providers, or other CLI behavior, fetch the
[CLI guide](https://opencode.ai/docs/cli) and the relevant page linked from
that section.

CLI and TUI preferences are separate from OpenCode's server and project
configuration. They live in the global `~/.config/opencode/cli.json`, or
`$XDG_CONFIG_HOME/opencode/cli.json` when `XDG_CONFIG_HOME` is set. There is no
project-local CLI configuration. Set `OPENCODE_CLI_CONFIG_CONTENT` to merge
inline JSON over the global settings. Most preferences can also be changed from
the TUI by pressing `Ctrl+P` and selecting **Open settings**.

### [Settings](https://opencode.ai/docs/cli/config)

Fetch the full [CLI settings reference](https://opencode.ai/docs/cli/config)
before editing `cli.json`. It documents every terminal-only setting, accepted
values, and examples, including themes, input, sessions, tabs, diffs, alerts,
Mini, keybindings, terminal plugins, and debugging. Do not put these settings in
`opencode.json(c)`.

### [Keybinds](https://opencode.ai/docs/cli/keybinds)

Configure keybindings under `keybinds` in `cli.json`. The leader key is the
`keybinds.leader` entry; leader timing is configured separately under
`leader.timeout`. Bindings can use a string, an array of strings, or an object
when event behavior such as `preventDefault` is required. Disable a binding with
`"none"` or `false`.

Never guess a command ID, default binding, or accepted key syntax. Fetch the
full [keybind reference](https://opencode.ai/docs/cli/keybinds), which lists the
current IDs and defaults, before answering or editing a binding.

## [OpenCode configuration](https://opencode.ai/docs/config)

OpenCode's server and project configuration uses JSON or JSONC. Include the
published schema so the user's editor can validate fields and provide
autocomplete:

```jsonc
{
  "$schema": "https://opencode.ai/config.json"
}
```

Global configuration lives at `~/.config/opencode/opencode.json(c)` and applies
to every project for that user. Project configuration can live in any directory
as `opencode.json(c)` or `.opencode/opencode.json(c)`, including nested packages
in a monorepo.

During ordinary project discovery, OpenCode searches the current directory and
every ancestor through the filesystem root, including directories above the
detected project or repository root. It merges direct `opencode.json(c)` files
from the farthest ancestor to the current directory, then does the same for
`.opencode/opencode.json(c)` files. This means every discovered `.opencode`
config overrides every discovered direct config. Global filesystem
configuration has lower precedence than these discovered documents.

Common configuration fields include `model`, `default_agent`, `permissions`,
`agents`, `commands`, `plugins`, `providers`, `mcp`, `skills`, `instructions`,
`references`, `formatter`, and `lsp`.

This configuration is distinct from `cli.json`. Use the
[CLI settings reference](https://opencode.ai/docs/cli/config) for terminal
preferences, especially themes and keybindings.

Config changes apply without a restart. OpenCode watches config files and
reloads agents, commands, skills, MCP servers, and plugins after a save. The TUI
does the same for `cli.json`. To force a full reload, use `/reload`. Don't tell
the user to restart OpenCode after editing config.

Do not guess field names or shapes. Fetch the V2 configuration guide and its
linked topic guide as the source of truth, and preserve unrelated settings when
editing an existing file. Keep the published `$schema` URL in configuration
examples, but do not fetch it to determine the V2 configuration shape.

See the [full configuration guide](https://opencode.ai/docs/config) for every
field, examples, config locations, and links to dedicated feature guides.

## [Agents](https://opencode.ai/docs/agents)

Agents combine a system prompt, model preference, permissions, and display
details into a named profile. Add one as a Markdown file:

- Global: `~/.config/opencode/agents/<name>.md`
- Project: `.opencode/agents/<name>.md`

The YAML frontmatter accepts `description`, `mode` (`primary`, `subagent`, or
`all`), `model` (`provider/model#variant`), `permissions` (ordered rule list,
last match wins), `steps`, `hidden`, `color`, `disabled`, and `request`. The
Markdown body becomes the agent's system prompt. Agents can also be defined
under `agents` in any `opencode.json(c)`.

## [Skills](https://opencode.ai/docs/skills)

Skills give an agent reusable instructions for a task. Put a `SKILL.md` in
`.opencode/skills/<skill-id>/` (project) or `~/.config/opencode/skills/<skill-id>/`
(global). OpenCode also reads compatibility sources: `~/.claude/skills`,
`~/.agents/skills`, `.claude/skills`, `.agents/skills`.

Frontmatter: `name` (display label), `description` (drives discovery — skills
without one are not advertised), and `metadata.opencode/autoinvoke: false` (or
`disable-model-invocation: true`) to register without advertising.

The skill ID comes from the path, not the frontmatter name. Load a skill by
mentioning `@skill-id` in a prompt, or let the model load it via the `skill`
tool when relevant. `skills` arrays in config can add extra local directories or
HTTP catalogs.

## [MCP servers](https://opencode.ai/docs/mcp-servers)

Configure MCP servers under `mcp.servers`. Prefer the CLI because it preserves
unrelated configuration. Use `--global` when the user asks to set up a service
for themselves without limiting it to the current project; omit it when they
explicitly want project-local configuration.

```sh
opencode mcp add <name> --global --url <remote-url>
opencode mcp list
```

Remote servers use OAuth by default. If `mcp list` reports that a server needs
authentication, tell the user to run `/mcps`, select the server, and sign in.
Do not run `opencode mcp auth` through the shell tool: it starts an interactive
flow whose authorization link can be hidden in background process output. Use
the user-facing MCP interface instead.

Report the server as configured but awaiting sign-in until its connection
status confirms it is connected.

OAuth credentials are stored outside the OpenCode configuration. Do not ask for
or store an API key when the server supports OAuth. Use header-based credentials
only when OAuth is unavailable, and use an environment substitution such as
`{env:MCP_API_KEY}` instead of writing a secret into configuration.

## [Plugins](https://opencode.ai/docs/build/plugins)

For questions about creating, configuring, loading, publishing, or migrating
plugins, fetch the full plugins guide before answering. Plugins hook into
sessions, tools, permissions, and the TUI. TypeScript plugins live in
`~/.config/opencode/plugins/` (global) or `.opencode/plugins/` (project).

## [Service](https://opencode.ai/docs/troubleshooting#check-the-background-service)

OpenCode uses a client-server architecture. Interfaces such as the TUI connect
to a background OpenCode service, which owns sessions, configuration, plugins,
permissions, and tool execution.

OpenCode normally discovers or starts the shared background service
automatically. Restart it only if it is stuck or unhealthy, not to apply
configuration changes:

```sh
opencode service restart
```

Check its status after restarting:

```sh
opencode service status
```

## [API](https://opencode.ai/docs/api)

OpenCode exposes an HTTP API from its server. The API is described by an OpenAPI
document available from the running server at `/openapi.json`. Call endpoints
with the SDK clients or inspect them with:

```sh
opencode api get /api/info
```

## [Troubleshooting](https://opencode.ai/docs/troubleshooting)

OpenCode runs a client and a background server. Start by determining whether a
problem belongs to the client, the shared server, or one project.

- Check the service with `opencode service status` and verify the API with
  `opencode api get /api/info`.
- Compare with `opencode --standalone`, which runs the TUI with a private
  server, to isolate shared-service issues.
- Inspect `~/.local/share/opencode/log/opencode.log`. Filter `role=cli` for
  client startup and `role=server` for sessions, providers, plugins,
  permissions, and tools.
- Run one reproduction with `OPENCODE_LOG_LEVEL=DEBUG` when normal logs are not
  sufficient.
- Do not delete or edit the database, service registration, or service config
  while diagnosing a problem. Back up persistent data before inspecting it with
  external tools.
- Redact API keys, authorization headers, prompts, file contents, and other
  sensitive data before sharing diagnostics.
