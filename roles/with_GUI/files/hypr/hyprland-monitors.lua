-- #######################################################################################
-- HYPRLAND LUA CONFIG
-- MONITORS
-- #######################################################################################

-- default
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60.00",
    position = "0x0",
    scale    = 1,
})

-- skyzone cobra
hl.monitor({
    output   = "DP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
    mirror   = "HDMI-A-1",
})