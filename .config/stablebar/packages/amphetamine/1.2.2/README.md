# Amphetamine

Shows the current Amphetamine session in your bar: Off, Awake, or the minutes remaining. Click the icon or text to start the selected duration, or end an active session.

Hover to reveal the inline duration slider, like StableBar’s volume control. The slider selects
15–240 minutes in 15-minute steps. Past a notch at its end, ∞ keeps the Mac awake indefinitely.
Releasing it during an active session restarts the session with that choice; otherwise it sets the
choice for your next session.

Set click behavior to **controls** to open the popup, with the same slider, a button that starts the chosen session and an end-session button.

Requires StableBar **0.10.0-beta.20261101132945.557** or later, the first with a slider stop past its range. Use the beta update channel until a stable release has it.

Install and open the Amphetamine app before using this package. Allow StableBar to control Amphetamine when macOS asks for Automation access.

## Settings

- **Default session:** 15, 30, 60, 120, or 240 minutes (default: 60). Changing this setting resets the slider's saved selection.
- **Display sleep during sessions:** allow (default) or prevent. Applies when starting or adjusting a session.
- **Bar display:** status text (default) or icon only.
- **Click the bar widget to:** toggle the session (default) or open the controls.

Starting a session replaces the current session, including a trigger session. Ending a trigger session does not disable its trigger, so it may restart.

The widget checks the session every five seconds and remembers the slider selection in `amphetamine-duration` beside your configuration. Hover backgrounds and the slider's look follow the theme, and animations respect Reduce Motion. Closed-display settings remain controlled by Amphetamine.
