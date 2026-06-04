local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return false
end

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function ()
  hl.exec_cmd("hyprctl plugin load /run/current-system/sw/lib/libhy3.so")
  hl.exec_cmd("hyprctl plugin load /run/current-system/sw/lib/libhypr-dynamic-cursors.so")
  hl.exec_cmd("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE")
  hl.exec_cmd("@DOTFILES@/graphical/wl-autostart")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        border_size = 1,
        -- No gaps
        gaps_in = 0,
        gaps_out = 0,

        col = {
            active_border   = { colors = {"rgba(5388ffee)", "rgba(0053aaee)"}, angle = 45 },
            inactive_border = { colors = {"rgba(505050ee)"}, angle = 45 },
        },

        layout = "hy3",

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,
    },

    decoration = {
        rounding       = 2,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

------------
--- MISC ---
------------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        vrr = 3, -- Enable VRR for videos/games
        focus_on_activate = true,
        font_family = "IBM Plex Sand Bold"
    },

    plugin = {
        dynamic_cursors = {
            mode = "tilt",
            threshold = 4,
            shake = {
                enabled = true,
                threshold = 6.0,
                base = 2.0,
                effects = true,
            },
        },
    }
})


-----------
--- hy3 ---
-----------

hl.config({
    plugin = {
        hy3 = {
            node_collapse_policy = 0,
            tab_first_window = true,
            autotile = { enable = true },
            tabs = {
                height = 20,
                padding = 0,
                border_width = 1,
                blur = false,

                text_center = true,
                text_font = "IBM Plex Sans Bold",

                colors = {
                    active = "rgba(1b68c6aa)",
                    active_border = "rgba(ffffffaa)",
                    active_alt_monitor = "rgba(78aeedaa)",
                    inactive = "rgba(2b303b80)",
                },
            },
        }
    }
})

-------------
--- INPUT ---
-------------

hl.config({
    input = {
        kb_layout = "de",
        kb_variant = "nodeadkeys",
        -- Enable compose key
        kb_options = "compose:menu",
        -- Enable numlock
        numlock_by_default = true,
        -- No following the cursor with focus
        --follow_mouse = 1,
    },
})

-----------------------
----- PERMISSIONS -----
-----------------------

hl.config({
    ecosystem = {
        enforce_permissions = true
    }
})
hl.permission({ binary = "/run/current-system/sw/lib/libhy3.so", type = "plugin", mode = "allow" })
hl.permission({ binary = "/run/current-system/sw/lib/libhypr-dynamic-cursors.so", type = "plugin", mode = "allow" })

hl.permission({ binary = "/nix/store/[a-z0-9]{32}-grim-[0-9.]*/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/nix/store/[a-z0-9]{32}-xdg-desktop-portal-hyprland-[0-9.]*/libexec/.xdg-desktop-portal-hyprland-wrapped", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/nix/store/[a-z0-9]{32}-hyprlock-[0-9.]*/bin/hyprlock", type = "screencopy", mode = "allow" })

hl.permission({ binary = "/nix/store/[a-z0-9]{32}-xdg-desktop-portal-hyprland-[0-9.]*/libexec/.xdg-desktop-portal-hyprland-wrapped", type = "cursorpos", mode = "allow" })

---------------------
---- KEYBINDINGS ----
---------------------

hl.config({ binds = { workspace_back_and_forth = true }})

local mainMod = "SUPER"
local hy3 = hl.plugin.hy3

-- Move focus with mainMod + hjkl and Alacritty on mainMod+Return
-- Move focused window with mainMod+Shift
for key,direction in pairs({ ["H"] = "l", ["J"] = "d", ["K"] = "u", ["L"] = "r"}) do
    hl.bind(mainMod .. " + " .. key, hy3.move_focus(direction))
    hl.bind(mainMod .. " + SHIFT + " .. key, hy3.move_window(direction))
end
hl.bind(mainMod .. " + Return", hl.dsp.focus({ window = "class:Alacritty" }))

-- Split current container
hl.bind(mainMod .. " + T", hy3.change_group("tab"))
hl.bind(mainMod .. " + V", hy3.change_group("v"))
hl.bind(mainMod .. " + B", hy3.change_group("h"))

-- Toggle fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen("fullscreen", "toggle"))

-- Kill active window
hl.bind(mainMod .. " + C", hl.dsp.window.close())

-- Mouse on hy3 tabs
hl.bind("mouse:272", hy3.focus_tab({ index = 0, mouse = "require_hovered" }), { non_consuming = true })
-- Move/resize window with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Floating stuff
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float())
hl.bind(mainMod .. " + Space", hy3.toggle_focus_layer())

-- Lock
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("@DOTFILES@/scripts/hypr-lock"))

-- Switch workspace with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + I", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + O", hl.dsp.focus({ workspace = "next" }))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "previous" }))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ workspace = "next" }))
hl.bind(mainMod .. " + S", function()
    local ws = hl.get_active_workspace()
    -- Find monitors that are not eDP-1
    local monitors = {}
    for _, mon in pairs(hl.get_monitors()) do
      if mon.name ~= "eDP-1" then
        table.insert(monitors, mon.name)
      end
    end
    if #monitors ~= 2 then
      hl.notification.create({ text = "Not exactly 2 monitors", duration = 2000, icon = "warning" })
      return
    end
    -- Do the actual swap
    hl.dispatch(hl.dsp.workspace.swap_monitors({ monitor1 = monitors[1], monitor2 = monitors[2] }))
    hl.dispatch(hl.dsp.focus({ workspace = ws }))
end)

-- Rename workspace
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("@DOTFILES@/scripts/hypr-renameworkspace"))

-- Scratchpad
hl.bind(mainMod .. " + Q", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.move({ workspace = "special:magic" }))

-- Launchers
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("@DOTFILES@/scripts/hypr-windowmenu"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("@DOTFILES@/scripts/power-menu"), { non_consuming = true })
hl.bind(mainMod .. " + SHIFT + CTRL + ALT + L", hl.dsp.exec_cmd("firefox https://linkedin.com"))

-- XF86
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("busctl --user call org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlayPause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("busctl --user call org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("busctl --user call org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("busctl --user call org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Next"), { locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("@DOTFILES@/scripts/volume up"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("@DOTFILES@/scripts/volume down"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("@DOTFILES@/scripts/volume toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("xbacklight_tee='sudo tee' @DOTFILES@/scripts/xbacklight +"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("xbacklight_tee='sudo tee' @DOTFILES@/scripts/xbacklight -"), { locked = true, repeating = true })
hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("@DOTFILES@/scripts/hypr-lock"))

-- MX Master 3s
hl.bind("mouse:275", hl.dsp.exec_cmd("busctl --user call org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Previous"), { locked = true })
hl.bind("mouse:276", hl.dsp.exec_cmd("busctl --user call org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Next"), { locked = true })
hl.bind("mouse:277", hl.dsp.exec_cmd("busctl --user call org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlayPause"), { locked = true })
-- mainMod+Wheel for volume. Swapped for some reason
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd("@DOTFILES@/scripts/volume up"), { locked = true })
hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd("@DOTFILES@/scripts/volume down"), { locked = true })

-- Dunst
hl.bind(mainMod .. " + code:34", hl.dsp.exec_cmd("dunstctl history-pop")) -- ü
hl.bind(mainMod .. " + code:47", hl.dsp.exec_cmd("dunstctl close")) -- ö
hl.bind(mainMod .. " + code:48", hl.dsp.exec_cmd("dunstctl action")) -- ä

-- Resize mode
hl.bind(mainMod .. " + E", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind(mainMod .. " + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + K", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + J", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Passthru mode
hl.bind(mainMod .. " + P", hl.dsp.submap("passthru"))
hl.define_submap("passthru", function()
    hl.bind(mainMod .. " + Return", hl.dsp.submap("reset"))
end)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    -- No animation when opening the Telegram media viewer
    name = "no-telegram-media-animation",
    match = {
        class = "org.telegram.desktop",
        title = "Media viewer",
    },

    no_anim = true,
    fullscreen = true,
})

hl.window_rule({
    -- Flameshot fixes
    name = "flameshot-fixes",
    match = {
        title = "^(flameshot)$",
    },

    no_anim = true,
    float = true,
    move = {0, 0},
    monitor = 0,
    pin = true
})

hl.window_rule({
    -- Flameshot pin fixes
    name = "flameshot-pin",
    match = {
        title = "^(flameshot-pin)$",
    },

    border_size = 0,
    no_shadow = true,
    no_blur = true,
    float = true,
})

hl.window_rule({
    -- Forces focus onto Pinentry
    name = "pinentry",
    match = {
        class = "org.gnupg.pinentry-qt",
    },

    dim_around = true,
    stay_focused = true,
})

if file_exists("@DOTFILES@/local/hyprland.lua") then
    loadfile("@DOTFILES@/local/hyprland.lua")()
end

hl.notification.create({ text = "Reloaded", duration = 1000, icon = "ok" })
