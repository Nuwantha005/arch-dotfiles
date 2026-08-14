local scheme = require("scheme.current")

return {
    ------------------
    ---- HYPRLAND ----
    ------------------

    -- Apps
    terminal                   = "kitty",
    browser                    = "firefox-nightly",
    editor                     = "nvim",
    fileExplorer               = "dolphin",
    audioSettings              = "pavucontrol",

    -- Touchpad
    touchpadDisableTyping      = true,
    touchpadScrollFactor       = 0.3,
    gestureFingers             = 3,
    workspaceSwipeFingers      = 4,
    gestureFingersMore         = 4,

    -- Blur
    blurEnabled                = true,
    blurSpecialWs              = false,
    blurPopups                 = true,
    blurInputMethods           = true,
    blurSize                   = 8,
    blurPasses                 = 2,
    blurXray                   = false,

    -- Shadow
    shadowEnabled              = true,
    shadowRange                = 15,
    shadowRenderPower          = 4,
    shadowColour               = "rgba(" .. scheme.inversePrimary .. "10)",

    -- Gaps
    workspaceGaps              = 10,
    windowGapsIn               = 2,
    windowGapsOut              = 5,
    singleWindowGapsOut        = 5,

    -- Window styling
    windowOpacity              = 0.95,
    windowRounding             = 15,
    windowBorderSize           = 1,
    activeWindowBorderColour   = "rgba(" .. scheme.primary .. "e6)",
    inactiveWindowBorderColour = "rgba(" .. scheme.onSurfaceVariant .. "11)",

    -- Misc
    volumeStep                 = 10,
    volumeMax                  = 100,
    cursorTheme                = "sweet-cursors",
    cursorSize                 = 24,
    sleepGestureCmd            = "systemctl suspend-then-hibernate",

    ------------------
    ---- KEYBINDS ----
    ------------------

    -- Workspaces
    kbMoveWinToWs              = "SUPER + SHIFT",
    kbMoveWinToWsGroup         = "CTRL + SUPER + ALT",
    kbGoToWs                   = "SUPER",
    kbGoToWsGroup              = "CTRL + SUPER",
    kbSwapWs                   = "SUPER + ALT",
    kbNextWs                   = "CTRL + SUPER + Right",
    kbPrevWs                   = "CTRL + SUPER + Left",
    kbFocusMonitor             = "SUPER + Tab",
    kbSwapActiveWorkspaces     = "SUPER + X",
    kbGrabRogueWindows         = "SUPER + SHIFT + G",

    -- Window Group
    kbWindowGroupCycleNext     = "ALT + TAB",
    kbWindowGroupCyclePrev     = "SHIFT + ALT + TAB",
    kbUngroup                  = "SUPER + U",
    kbToggleGroup              = "SUPER + Comma",

    -- Window Action
    kbCloseWindow              = "SUPER + F",
    kbCloseWindowAlt           = "ALT + Q",
    kbToggleWindowFloating     = "SUPER + B",
    kbWindowFullscreen         = "SUPER + G",
    kbPseudo                   = "SUPER + P",
    kbToggleSplit              = "SUPER + N",
    kbWindowPip                = "SUPER + ALT + backslash",

    -- Special Workspaces & Pyprland
    kbSpecialWs                = "SUPER + S",
    kbMoveWinToSpecialWs       = "SUPER + SHIFT + S",
    kbPyprTerm                 = "SUPER + R",
    kbPyprMusic                = "SUPER + Q",
    kbPyprTaskbar              = "SUPER + T",
    kbPyprExpose               = "SUPER + C",

    -- Apps & Launchers
    kbTerminal                 = "SUPER + D",
    kbBrowser                  = "SUPER + W",
    kbEditor                   = "SUPER + C",
    kbFileExplorer             = "SUPER + E",
    kbLauncher                 = "SUPER + space",
    kbQuickDir                 = "ALT + space",
    kbSearch                   = "SUPER + ALT + space",
    kbGoogleSearch             = "SUPER + SHIFT + space",

    -- System, Audio & Utilities
    kbSession                  = "CTRL + ALT + Delete",
    kbShowSidebar              = "SUPER + N",
    kbClearNotifs              = "CTRL + ALT + C",
    kbShowPanels               = "SUPER + K",
    kbLock                     = "SUPER + O",
    kbRestoreLock              = "SUPER + ALT + L",
    kbEmergencyUnlock          = "SUPER + CTRL + ALT + BackSpace",
    kbAudioMuteToggle          = "SUPER + SHIFT + M",
    kbWayscriber               = "SUPER + Z",
    kbExpoToggle               = "SUPER + A",
    kbMergeToFirefox           = "SUPER + M",
}

