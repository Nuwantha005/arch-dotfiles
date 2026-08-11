local vars = require("variables")
local fn   = require("utils.functions")

-- Launcher
-- hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), { release = true })

-- Misc
hl.bind(vars.kbSession, hl.dsp.global("caelestia:session"))
hl.bind("SUPER + I", hl.dsp.global("caelestia:sidebar"))
hl.bind(vars.kbClearNotifs, hl.dsp.global("caelestia:clearNotifs"), { locked = true })
hl.bind("SUPER + U", hl.dsp.global("caelestia:showall"))
hl.bind("SUPER + W", hl.dsp.global("caelestia:lock"))

-- Restore lock
hl.bind(vars.kbRestoreLock, function()
    hl.dispatch(hl.dsp.exec_cmd("caelestia shell -d"))
    hl.dispatch(hl.dsp.global("caelestia:lock"))
end)

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), { locked = true })

-- Media
hl.bind("CTRL + SUPER + Space", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("CTRL + SUPER + Equal", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("CTRL + SUPER + Minus", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.global("caelestia:mediaStop"), { locked = true })

-- Kill/restart
hl.bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("qs -c caelestia kill"), { release = true })
hl.bind(
    "CTRL + SUPER + ALT + R",
    hl.dsp.exec_cmd("qs -c caelestia kill; sleep .1; caelestia shell -d"),
    { release = true }
)

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(vars.kbGoToWs .. " + " .. key, fn.wsaction("focus", "", i))
    hl.bind(vars.kbMoveWinToWs .. " + " .. key, fn.wsaction("move", "", i))
    hl.bind(vars.kbGoToWsGroup .. " + " .. key, fn.wsaction("focus", "group", i))
    hl.bind(vars.kbMoveWinToWsGroup .. " + " .. key, fn.wsaction("move", "group", i))
end

-- Go to workspace -1/+1
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(vars.kbPrevWs, hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind(vars.kbNextWs, hl.dsp.focus({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + Page_down", hl.dsp.focus({ workspace = "+1" }), { repeating = true })

-- Go to workspace group -1/+1
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "-10" }))
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "+10" }))

-- Move window to workspace -1/+1
hl.bind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("CTRL + SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })

-- Move window to/from special workspace
hl.bind("CTRL + SUPER + SHIFT + up", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + down", hl.dsp.window.move({ workspace = "e+0" }))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:special" }))

-- Window groups
hl.bind(vars.kbWindowGroupCycleNext, hl.dsp.window.cycle_next(), { repeating = true })
hl.bind(vars.kbWindowGroupCyclePrev, hl.dsp.window.cycle_next({ next = false }), { repeating = true })
hl.bind("CTRL + ALT + Tab", hl.dsp.group.next(), { repeating = true })
hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.prev(), { repeating = true })
hl.bind(vars.kbToggleGroup, hl.dsp.group.toggle())
hl.bind(vars.kbUngroup, hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active())

-- Window actions
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + Minus", fn.resize_active_window(-10, 0), { repeating = true })
hl.bind("SUPER + Equal", fn.resize_active_window(10, 0), { repeating = true })
hl.bind("SUPER + SHIFT + Minus", fn.resize_active_window(0, -10), { repeating = true })
hl.bind("SUPER + SHIFT + Equal", fn.resize_active_window(0, 10), { repeating = true })
hl.bind("SUPER + ALT + left", fn.resize_active_window(-10, 0), { repeating = true })
hl.bind("SUPER + ALT + right", fn.resize_active_window(10, 0), { repeating = true })
hl.bind("SUPER + ALT + up", fn.resize_active_window(0, -10), { repeating = true })
hl.bind("SUPER + ALT + down", fn.resize_active_window(0, 10), { repeating = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.kbMoveWindow, hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(vars.kbResizeWindow, hl.dsp.window.resize(), { mouse = true })
hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
hl.bind("CTRL + SUPER + ALT + Backslash", hl.dsp.window.resize(fn.resize_by_screen(55, 70)))
hl.bind("CTRL + SUPER + ALT + Backslash", hl.dsp.window.center())
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
hl.bind(vars.kbPinWindow, hl.dsp.window.pin())
hl.bind(vars.kbWindowFullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(vars.kbWindowBorderedFullscreen, hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(vars.kbToggleWindowFloating, hl.dsp.window.float())
-- hl.bind(vars.kbCloseWindow, hl.dsp.window.close())

-- Special workspace toggles (commented out to avoid conflict with user bindings like SUPER+D)
-- hl.bind(vars.kbSpecialWs, fn.toggle("specialws"))
-- hl.bind(vars.kbSystemMonitorWs, fn.toggle("sysmon"))
-- hl.bind(vars.kbMusicWs, fn.toggle("music"))
-- hl.bind(vars.kbCommunicationWs, fn.toggle("communication"))
-- hl.bind(vars.kbTodoWs, fn.toggle("todo"))

-- Apps (commented out to avoid conflict with user app shortcuts)
-- hl.bind(vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal))
-- hl.bind(vars.kbBrowser, hl.dsp.exec_cmd(vars.browser))
-- hl.bind(vars.kbEditor, hl.dsp.exec_cmd(vars.editor))
-- hl.bind(vars.kbFileExplorer, hl.dsp.exec_cmd(vars.fileExplorer))

hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd(vars.audioSettings))

-- Utilities
hl.bind("Print", hl.dsp.exec_cmd("caelestia screenshot"), { locked = true })
-- hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshot"))
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd("caelestia record -s"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("caelestia record"))
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("caelestia record -r"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Volume
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
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

-- Sleep
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd(vars.sleepGestureCmd), { locked = true })

-- Clipboard and emoji picker
hl.bind("SUPER + V", hl.dsp.exec_cmd("~/customScripts/clipboard_picker.sh"))
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))
hl.bind(
    "CTRL + SHIFT + ALT + V",
    hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'),
    { locked = true }
)

-- Testing
hl.bind(
    "SUPER + ALT + F12",
    hl.dsp.exec_cmd(
        "notify-send -u low -i dialog-information-symbolic 'Test notification' " ..
        [["Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!"]] ..
        " -a 'Shell' -A 'Test1=I got it!' -A 'Test2=Another action'"
    )
)

----------------------------------------------
-- Custom User Keybindings (from hyprland.conf)
----------------------------------------------
local mainMod = "SUPER"

-- Core Apps
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + F", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + B", hl.dsp.window.float())
hl.bind(mainMod .. " + space", hl.dsp.global("caelestia:launcher"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprctl dispatch pseudo"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg togglesplit"))
hl.bind(mainMod .. " + G", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Focus movements (h, j, k, l)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Window movements (Alt + Arrow keys)
hl.bind("ALT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("ALT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("ALT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("ALT + down", hl.dsp.window.move({ direction = "down" }))

-- Monitor focus
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ monitor = "+1" }))

-- Workspaces 1..10 (focus & move window)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, fn.wsaction("focus", "", i))
    hl.bind(mainMod .. " + SHIFT + " .. key, fn.wsaction("move", "", i))
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.exec_cmd("~/.config/hypr/Scripts/swap_workspaces.sh " .. i))
end

hl.bind(mainMod .. " + Left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ workspace = "+1" }))

for i = 1, 5 do
    hl.bind(
        mainMod .. " + CTRL + " .. i,
        hl.dsp.exec_cmd('hyprctl --batch "dispatch focusmonitor +1; dispatch split:workspace ' .. i .. '"')
    )
end

hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("hyprctl dispatch split:grabroguewindows"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))

-- Screenshots
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/Screenshots/"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m window -o ~/Screenshots/"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m active -m output -o ~/Screenshots/"))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("~/customScripts/latexocr-shot"))

-- Lock screen & special workspace
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("~/.local/share/quickshell-lockscreen/lock.sh"))
hl.bind(mainMod .. " + S", fn.toggle("specialws"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("hyprctl dispatch split:swapactiveworkspaces current +1"))

-- Scripts & UI Toggles
hl.bind("ALT + Tab", hl.dsp.exec_cmd("wlogout -b 2"))
hl.bind("ALT + W", hl.dsp.exec_cmd("~/.config/hypr/Scripts/wallpaper.sh"))
hl.bind("ALT + R", hl.dsp.exec_cmd("~/.config/swaync/refresh.sh"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("~/.config/hypr/Scripts/move_external_workspaces_to_laptop.sh"))

-- Theme management
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/Scripts/theme-switcher.sh"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("~/.config/hypr/Scripts/lockscreen-picker.sh"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.config/hypr/Scripts/pfp-picker.sh"))

-- Pypr scratchpads
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("pypr toggle music"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("pypr toggle taskbar"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("pypr expose"))

-- Utilities & Search
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("wayscriber --daemon-toggle"))
hl.bind("ALT + Space", hl.dsp.exec_cmd('kitty --class floating_search_qd zsh -c "~/customScripts/qd.sh"'))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd('kitty --class floating_search zsh -c "~/customScripts/hsearch"'))

-- Hyprsunset
hl.bind(mainMod .. " + Prior", hl.dsp.exec_cmd("hyprctl hyprsunset temperature +100"))
hl.bind(mainMod .. " + Next", hl.dsp.exec_cmd("hyprctl hyprsunset temperature -100"))
hl.bind(mainMod .. " + Home", hl.dsp.exec_cmd("hyprctl hyprsunset reset temperature"))

-- Plugins
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("hyprctl dispatch hyprexpo:expo toggle"))

-- Google Search Popup
hl.bind(
    mainMod .. " + SHIFT + Space",
    hl.dsp.exec_cmd("foot --app-id=google-search --font=monospace:size=12 -e /home/nuwa/customScripts/google-popup/google_search.sh")
)
hl.bind("ALT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("/home/nuwa/customScripts/google-popup/merge_to_firefox.sh"))



