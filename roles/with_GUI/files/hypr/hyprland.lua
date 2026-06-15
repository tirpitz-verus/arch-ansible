-- #######################################################################################
-- HYPRLAND LUA CONFIG
-- #######################################################################################

--------------------
---- DRACULA COLORS ----
--------------------

local background       = "rgb(282A36)"
local foreground       = "rgb(F8F8F2)"
local selection        = "rgb(44475A)"
local comment          = "rgb(6272A4)"
local red              = "rgb(FF5555)"
local orange           = "rgb(FFB86C)"
local yellow           = "rgb(F1FA8C)"
local green            = "rgb(50FA7B)"
local purple           = "rgb(BD93F9)"
local cyan             = "rgb(8BE9FD)"
local pink             = "rgb(FF79C6)"

------------------
---- MONITORS ----
------------------

require("hyprland-monitors")

-- hl.monitor({
--     output   = "HDMI-A-1",
--     mode     = "1920x1080@60.00",
--     position = "0x0",
--     scale    = 1,
-- })
--
-- -- skyzone cobra
-- hl.monitor({
--     output   = "DP-3",
--     mode     = "preferred",
--     position = "auto",
--     scale    = 1,
--     mirror   = "HDMI-A-1",
-- })

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "wofi --show drun"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    -- basic
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd(terminal, { workspace = "1 silent" })
    hl.exec_cmd("obsidian", { workspace = "8 silent" })
    -- activity watching
    hl.exec_cmd("aw-qt")
    -- clipboard history manager
    hl.exec_cmd("wl-paste --type text --watch cliphist store")   -- stores only text
    hl.exec_cmd("wl-paste --type image --watch cliphist store")  -- stores only images
    -- xdg-desktop-portal-hyprland
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,

        col = {
            active_border         = { colors = {selection, "rgb(bd93f9)"}, angle = 90 },
            inactive_border       = "rgba(44475aaa)",
            nogroup_border        = "rgba(282a36dd)",
            nogroup_border_active = { colors = {"rgb(bd93f9)", "rgb(44475a)"}, angle = 90 },
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 60,
            render_power = 3,
            color        = "rgba(1E202966)",
            offset       = {1, 2},
            scale        = 0.97,
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

    group = {
        groupbar = {
            col = {
                active   = { colors = {"rgb(bd93f9)", selection}, angle = 90 },
                inactive = "rgba(282a36dd)",
            },
        },
    },
})

-- XWayland windows get red border
hl.window_rule({
    name  = "xwayland-red-border",
    match = { xwayland = true },
    border_color = red,
})

-- Default curves and animations
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

-- "Smart gaps" / "No gaps when only"
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name  = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name  = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "pl",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse  = 1,
        mouse_refocus = true,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.config({
    debug = {
        disable_logs = false,
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- definitions 
local my_bindings = {
    -- run apps and commands
    { mainMod .. " + F1", hl.dsp.exec_cmd("echo 'key bindings' | wofi --dmenu"), {}, "list and search key bindings" }, -- to be overwritten below
    { mainMod .. " + Q", hl.dsp.exec_cmd(terminal), {},  "run terminal (kitty)" },
    { mainMod .. " + E", hl.dsp.exec_cmd(fileManager), {},  "run finle manager (dolphin)" },
    { mainMod .. " + R", hl.dsp.exec_cmd(menu), {}, "run menu (wofi)" },
    { mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"), {}, "lock screen" },
    { mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu --pre-display-cmd \"echo '%s' | cut -f 2\" | cliphist decode | wl-copy"), {}, "list clipboard history" },
    -- manipulate windows
    { mainMod .. " + C", hl.dsp.window.close(), {}, "close window" },
    { mainMod .. " + B", hl.dsp.window.float({ action = "toggle" }), {}, "toggle floating window" },
    { mainMod .. " + F", hl.dsp.window.fullscreen({ internal = 2, client = 2, action = "toggle" }), {}, "toggle foolscrean" },
    { mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }, "move window (RMB)" },
    { mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }, "resize window (LMB)" },
    -- window groups
    { mainMod .. " + G", hl.dsp.group.toggle(), {}, "toggle group" },
    { mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l", group_aware = true }), {}, "move window into group left" },
    { mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r", group_aware = true }), {}, "move window into group right" },
    { mainMod .. " + TAB", hl.dsp.group.next(), {}, "switch to next window in a group" },
    -- special workspace (scratchpad)
    { mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), {}, "toggle special workspace" },
    { mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), {}, "move window into active workspace" },
    -- multimedia keys
    { "XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true }, "volume up (knob)" },
    { "XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true }, "volume down (know)" },
    { "XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true }, "mute audio (knob press)" },
}

-- gather descriptions
local key_bindings_acc = {};
for i_binding, binding in ipairs(my_bindings) do
    table.insert(key_bindings_acc, binding[1] .. " - " .. binding[4])
end
-- bind helper / overwrite what was set in the loop above for F1
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("echo '" .. table.concat(key_bindings_acc, "\n") .. "'" .. " | wofi --dmenu"))

-- bind keys
for i_binding, binding in ipairs(my_bindings) do
    if i_binding ~= 1 then
        hl.bind(binding[1], binding[2], binding[3])
    end
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
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
    name = "bind-brave-browser-to-workspace-2",
    match = { class = "brave-browser" },
    workspace = 2,
})

hl.window_rule({
    name = "bind-firefox-to-workspace-2",
    match = { class = "firefox" },
    workspace = 2,
})

hl.window_rule({
    name = "bind-steam-to-workspace-3",
    match = { class = "steam" },
    workspace = 3,
})

hl.window_rule({
    name = "bind-discord-to-workspace-4",
    match = { class = "discord" },
    workspace = 4,
})

hl.window_rule({
    name = "bind-jetbrains-idea-to-workspace-7",
    match = { class = "jetbrains-idea" },
    workspace = 7,
})
