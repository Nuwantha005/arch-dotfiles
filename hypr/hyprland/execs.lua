local vars = require("variables")
local fn   = require("utils.functions")

hl.on("hyprland.start", function()
    -- Environment & portals
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland QT_QPA_PLATFORM=wayland")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Keyring and auth
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("/usr/bin/kwalletd6")

    -- Services & Daemons
    hl.exec_cmd("kanshi")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep .5 && ~/.config/hypr/Scripts/wallpaper-restore.sh")
    hl.exec_cmd("rm -f $XDG_RUNTIME_DIR/hypr/*/.pyprland.sock 2>/dev/null; pypr")
    hl.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 0")
    hl.exec_cmd("sleep 2 && akonadictl start")

    -- Custom User Scripts & Daemons
    hl.exec_cmd("~/customScripts/start_aw.sh")
    hl.exec_cmd("~/customScripts/startup.sh")
    hl.exec_cmd("hyprsunset")
    --hl.exec_cmd("wayscriber --daemon")
    hl.exec_cmd("python3 /home/nuwa/customScripts/google-popup/popup_server.py")
    hl.exec_cmd("/home/nuwa/customScripts/google-popup/hypr-popup-handler.sh")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Auto delete trash 30 days old
    hl.exec_cmd("trash-empty 30")

    -- Cursors
    hl.exec_cmd("hyprctl setcursor Future-Cyan-Hyprcursor_Theme 36")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Future-Cyan-Hyprcursor_Theme")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 36")

    -- Location provider and night light
    hl.exec_cmd("/usr/lib/geoclue-2.0/demos/agent")
    hl.exec_cmd("sleep 1 && gammastep")

    -- Forward bluetooth media commands to MPRIS
    hl.exec_cmd("mpris-proxy")

    -- Start shell
    hl.exec_cmd("~/.local/bin/caelestia shell -d")
end)

-- Resizer listener
hl.on("window.title", function(win)
    local d = {
        hl.dsp.window.float({ action = "on", window = win }),
        hl.dsp.window.center({ window = win }),
    }
    local pip = fn.move_actions(win) or {}

    fn.resizer(win, "Bitwarden", 20, 54, d, true)
    fn.resizer(win, "Picture[- ]in[- ][Pp]icture", 0, 0, pip, false)
end)

hl.on("window.open", function(win)
    local d = {
        hl.dsp.window.float({ action = "on", window = win }),
        hl.dsp.window.center({ window = win }),
    }
    local pip = fn.move_actions(win) or {}

    fn.resizer(win, "Bitwarden", 20, 54, d, true)
    fn.resizer(win, "Picture[- ]in[- ][Pp]icture", 0, 0, pip, false)
end)
