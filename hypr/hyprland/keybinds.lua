local vars = require("variables")
local fn   = require("utils.functions")

----------------------------------------------
-- 1. Core Apps & Launchers
----------------------------------------------
hl.bind(vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.kbFileExplorer, hl.dsp.exec_cmd(vars.fileExplorer))
hl.bind(vars.kbLauncher, hl.dsp.global("caelestia:launcher"))
hl.bind(vars.kbQuickDir, hl.dsp.exec_cmd('kitty --class floating_search_qd zsh -c "~/customScripts/qd.sh"'))
hl.bind(vars.kbSearch, hl.dsp.exec_cmd('kitty --class floating_search zsh -c "~/customScripts/hsearch"'))
hl.bind(vars.kbGoogleSearch, hl.dsp.exec_cmd("foot --app-id=google-search --font=monospace:size=12 -e /home/nuwa/customScripts/google-popup/google_search.sh"))

----------------------------------------------
-- 2. Window Actions & Layout
----------------------------------------------
hl.bind(vars.kbCloseWindow, hl.dsp.window.close())
hl.bind(vars.kbCloseWindowAlt, hl.dsp.window.close())
hl.bind(vars.kbToggleWindowFloating, hl.dsp.window.float())
hl.bind(vars.kbWindowFullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(vars.kbPseudo, hl.dsp.exec_cmd("hyprctl dispatch pseudo"))
hl.bind(vars.kbToggleSplit, hl.dsp.exec_cmd("hyprctl dispatch layoutmsg togglesplit"))
hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
hl.bind("CTRL + SUPER + ALT + Backslash", hl.dsp.window.resize(fn.resize_by_screen(55, 70)))
hl.bind(vars.kbWindowPip, function()
    local a = hl.get_active_window()
    if a then
        local pip = fn.move_actions(a) or {}
        if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
        table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))

        for _, x in ipairs(pip) do
            hl.dispatch(x)
        end
    end
end)

----------------------------------------------
-- 3. Window Groups
----------------------------------------------
hl.bind(vars.kbWindowGroupCycleNext, hl.dsp.window.cycle_next(), { repeating = true })
hl.bind(vars.kbWindowGroupCyclePrev, hl.dsp.window.cycle_next({ next = false }), { repeating = true })
hl.bind("CTRL + ALT + Tab", hl.dsp.group.next(), { repeating = true })
hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.prev(), { repeating = true })
hl.bind(vars.kbToggleGroup, hl.dsp.group.toggle())
hl.bind(vars.kbUngroup, hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active())

----------------------------------------------
-- 4. Focus & Navigation
----------------------------------------------
-- Directional Focus (Vim keys & Arrows)
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- Window Movement (Alt + Arrows & Super + Shift + Arrows)
hl.bind("ALT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("ALT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("ALT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("ALT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Window Resizing & Mouse Controls
hl.bind("SUPER + Minus", fn.resize_active_window(-10, 0), { repeating = true })
hl.bind("SUPER + Equal", fn.resize_active_window(10, 0), { repeating = true })
hl.bind("SUPER + SHIFT + Minus", fn.resize_active_window(0, -10), { repeating = true })
hl.bind("SUPER + SHIFT + Equal", fn.resize_active_window(0, 10), { repeating = true })
hl.bind("SUPER + ALT + left", fn.resize_active_window(-10, 0), { repeating = true })
hl.bind("SUPER + ALT + right", fn.resize_active_window(10, 0), { repeating = true })
hl.bind("SUPER + ALT + up", fn.resize_active_window(0, -10), { repeating = true })
hl.bind("SUPER + ALT + down", fn.resize_active_window(0, 10), { repeating = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

----------------------------------------------
-- 5. Workspaces & Monitors
----------------------------------------------
-- 1..10 Workspaces Loop
for i = 1, 10 do
    local key = i % 10
    hl.bind(vars.kbGoToWs .. " + " .. key, fn.wsaction("focus", "", i))
    hl.bind(vars.kbMoveWinToWs .. " + " .. key, fn.wsaction("move", "", i))
    hl.bind(vars.kbSwapWs .. " + " .. key, hl.dsp.exec_cmd("~/.config/hypr/Scripts/swap_workspaces.sh " .. i))
    hl.bind(vars.kbGoToWsGroup .. " + " .. key, fn.wsaction("focus", "group", i))
    hl.bind(vars.kbMoveWinToWsGroup .. " + " .. key, fn.wsaction("move", "group", i))
end

-- Workspace Navigation (-1 / +1)
hl.bind("SUPER + Left", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + Right", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(vars.kbPrevWs, hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind(vars.kbNextWs, hl.dsp.focus({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + Page_down", hl.dsp.focus({ workspace = "+1" }), { repeating = true })

-- Monitor & Multi-monitor Split Workspace Controls
hl.bind(vars.kbFocusMonitor, hl.dsp.focus({ monitor = "+1" }))
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "-10" }))
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "+10" }))
hl.bind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("CTRL + SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })

for i = 1, 5 do
    hl.bind(
        "SUPER + CTRL + " .. i,
        hl.dsp.exec_cmd('hyprctl --batch "dispatch focusmonitor +1; dispatch split:workspace ' .. i .. '"')
    )
end

hl.bind(vars.kbGrabRogueWindows, hl.dsp.exec_cmd("hyprctl dispatch split:grabroguewindows"))
hl.bind(vars.kbSwapActiveWorkspaces, hl.dsp.exec_cmd("hyprctl dispatch split:swapactiveworkspaces current +1"))

----------------------------------------------
-- 6. Special Workspaces & Pyprland Scratchpads
----------------------------------------------
hl.bind(vars.kbSpecialWs, fn.toggle("specialws"))
hl.bind(vars.kbMoveWinToSpecialWs, hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + up", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + down", hl.dsp.window.move({ workspace = "e+0" }))

-- Pyprland Toggles
hl.bind(vars.kbPyprTerm, hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(vars.kbPyprMusic, hl.dsp.exec_cmd("pypr toggle music"))
hl.bind(vars.kbPyprTaskbar, hl.dsp.exec_cmd("pypr toggle taskbar"))
hl.bind(vars.kbPyprExpose, hl.dsp.exec_cmd("pypr expose"))

----------------------------------------------
-- 7. System, Lock, Session & Sleep
----------------------------------------------
hl.bind(vars.kbLock, hl.dsp.exec_cmd("caelestia lock"))
hl.bind(vars.kbSession, hl.dsp.global("caelestia:session"))
hl.bind("SUPER + I", hl.dsp.global("caelestia:sidebar"))
hl.bind(vars.kbClearNotifs, hl.dsp.global("caelestia:clearNotifs"), { locked = true })
hl.bind("SUPER + U", hl.dsp.global("caelestia:showall"))
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd(vars.sleepGestureCmd), { locked = true })

-- Kill/restart Caelestia shell
hl.bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("qs -c caelestia kill"), { release = true })
hl.bind(
    "CTRL + SUPER + ALT + R",
    hl.dsp.exec_cmd("qs -c caelestia kill; sleep .1; caelestia shell -d"),
    { release = true }
)

----------------------------------------------
-- 8. Screenshots & Media Controls
----------------------------------------------
hl.bind("Print", hl.dsp.exec_cmd("caelestia screenshot"), { locked = true })
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshot"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/Screenshots/"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m active -m output -o ~/Screenshots/"))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("~/customScripts/latexocr-shot"))

-- Brightness Controls
hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), { locked = true })

-- Audio & Volume Controls
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(vars.kbAudioMuteToggle, hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l " ..
        (vars.volumeMax / 100) .. " @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%+"
    ),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%-"
    ),
    { locked = true, repeating = true }
)
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd(vars.audioSettings))

-- Media Playback
hl.bind("CTRL + SUPER + Space", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("CTRL + SUPER + Equal", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("CTRL + SUPER + Minus", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.global("caelestia:mediaStop"), { locked = true })

-- Recording Controls
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd("caelestia record -s"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("caelestia record"))
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("caelestia record -r"))

----------------------------------------------
-- 9. Clipboard & Utilities
----------------------------------------------
hl.bind("SUPER + V", hl.dsp.exec_cmd("~/customScripts/clipboard_picker.sh"))
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))
hl.bind(
    "CTRL + SHIFT + ALT + V",
    hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'),
    { locked = true }
)
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

----------------------------------------------
-- 10. Display & Plugins
----------------------------------------------
hl.bind(vars.kbWayscriber, hl.dsp.exec_cmd("wayscriber --daemon-toggle"))
hl.bind(vars.kbExpoToggle, hl.dsp.exec_cmd("hyprctl dispatch hyprexpo:expo toggle"))
hl.bind(vars.kbMergeToFirefox, hl.dsp.exec_cmd("/home/nuwa/customScripts/google-popup/merge_to_firefox.sh"))

-- Hyprsunset Blue Light Filter
hl.bind("SUPER + Prior", hl.dsp.exec_cmd("hyprctl hyprsunset temperature +100"))
hl.bind("SUPER + Next", hl.dsp.exec_cmd("hyprctl hyprsunset temperature -100"))
hl.bind("SUPER + Home", hl.dsp.exec_cmd("hyprctl hyprsunset reset temperature"))

----------------------------------------------
-- 11. Local Private Keybindings (Gitignored)
----------------------------------------------
pcall(require, "keybinds-private")





