// TUI plugin: opens the current session's full transcript in $VISUAL/$EDITOR.
//
// Adds a "Session > Open transcript in editor" command, bound to <leader>h
// (leader defaults to ctrl+x) and available in the command palette (ctrl+p).
// The transcript is written to a markdown temp file, the TUI suspends while
// the editor is open, and the temp file is removed after the editor exits.
// Use <leader>x (built-in) when you want a persistent export file instead.
import { spawn } from "node:child_process"
import { rm, writeFile } from "node:fs/promises"
import os from "node:os"
import path from "node:path"
import { Plugin } from "@opencode/plugin/tui"

function textOf(entry: any): string {
  if (!entry || typeof entry !== "object") return ""
  if (entry.type === "text") return entry.text ?? ""
  return entry.name ?? entry.uri ?? ""
}

// Mirrors the TUI's own transcript formatting (thinking and tools included).
function formatTranscript(info: any, messages: any[]): string {
  const body = messages.flatMap((message: any) => {
    if (message.type === "user") return [`## User\n\n${message.text ?? ""}`]
    if (message.type === "shell")
      return [`## Shell\n\n\`\`\`\n$ ${message.command}\n${message.output?.output ?? ""}\n\`\`\``]
    if (message.type !== "assistant") return []
    const content = (message.content ?? []).flatMap((item: any) => {
      if (item.type === "text") return [item.text ?? ""]
      if (item.type === "reasoning") return [`_Thinking:_\n\n${item.text ?? ""}`]
      const state = item.state ?? {}
      const input = typeof state.input === "string" ? state.input : JSON.stringify(state.input ?? null, null, 2)
      const output =
        state.status === "error"
          ? state.error?.message ?? "error"
          : state.status === "streaming" || state.status === "running"
            ? ""
            : (state.content ?? []).map(textOf).filter(Boolean).join("\n")
      return [`**Tool: ${item.name}**\n\n**Input:**\n\`\`\`json\n${input}\n\`\`\`\n\n${output}`]
    })
    if (content.length === 0) return []
    return [`## Assistant\n\n${content.join("\n\n")}`]
  })
  const title = info?.title ?? info?.id ?? "Session"
  const created = info?.time?.created ? new Date(info.time.created).toLocaleString() : ""
  const updated = info?.time?.updated ? new Date(info.time.updated).toLocaleString() : ""
  return `# ${title}\n\n**Session ID:** ${info?.id ?? ""}\n**Created:** ${created}\n**Updated:** ${updated}\n\n---\n\n${body.join("\n\n---\n\n")}\n`
}

export default Plugin.define({
  id: "session-editor",
  setup(context) {
    let opening = false
    context.keymap.layer(() => ({
      mode: "global",
      commands: [
        {
          id: "session.editor.open",
          title: "Open transcript in editor",
          group: "Session",
          bind: "<leader>h",
          palette: true,
          run: async () => {
            if (opening) return
            const route = context.ui.router.current()
            const sessionID = route?.type === "session" ? route.sessionID : undefined
            if (!sessionID) {
              context.ui.toast.show({ message: "Open a session first", variant: "error" })
              return
            }
            const editor = process.env.VISUAL || process.env.EDITOR
            if (!editor) {
              context.ui.toast.show({ message: "Set $VISUAL or $EDITOR to open the transcript", variant: "error" })
              return
            }
            opening = true
            let file: string | undefined
            try {
              const transcript = await context.client.experimental.session.export({ sessionID })
              file = path.join(os.tmpdir(), `opencode-transcript-${sessionID}.md`)
              await writeFile(file, formatTranscript(transcript.info, transcript.messages))
              await context.renderer.suspend()
              try {
                await new Promise<void>((resolve, reject) => {
                  const [command, ...args] = editor.split(" ")
                  const child = spawn(command!, [...args, file!], {
                    stdio: "inherit",
                    shell: process.platform === "win32",
                  })
                  child.on("error", reject)
                  child.on("exit", () => resolve())
                })
              } finally {
                await context.renderer.resume()
              }
            } catch (error) {
              context.ui.toast.show({
                message: error instanceof Error ? error.message : "Failed to open transcript in editor",
                variant: "error",
              })
            } finally {
              opening = false
              if (file) await rm(file, { force: true }).catch(() => {})
            }
          },
        },
      ],
    }))
  },
})
