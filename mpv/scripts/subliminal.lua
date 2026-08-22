local mp = require 'mp'

local function download_subtitles()
    local path = mp.get_property("path")
    if not path or path == "" or path:find("^https?://") then
        mp.osd_message("Subliminal: Invalid file or stream", 3)
        return
    end

    mp.osd_message("Searching English subtitles...", 5)

    local cmd = {
        name = "subprocess",
        args = {"subliminal", "download", "-l", "en", path},
        playback_only = false,
        capture_stdout = true,
        capture_stderr = true
    }

    local res = mp.command_native(cmd)

    if res.status == 0 then
        mp.osd_message("Subtitles downloaded & reloaded!", 3)
        mp.commandv("rescan-external-files", "reselect")
    else
        mp.osd_message("No subtitles found or error occurred", 4)
    end
end

-- Keybindings
mp.add_key_binding("ctrl+shift+s", "download_subs_chord", download_subtitles)
