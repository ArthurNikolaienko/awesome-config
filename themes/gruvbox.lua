---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

local dark = {
    bg = "#282828",
    bg_alt = "#3C3836",
    fg = "#ebdbb2",
    fg_alt = "#EBDBB2",
    red = "#cc241d",
    green = "#98971a",
    yellow = "#e79921",
    blue = "#458588",
    purple = "#b16286",
    teal = "#689d6a",
    orange = "#d65d0e",
    gray = "#a89984",
    black = "#1d2021",
    white = "#fbf1c7",
}

local palette = dark;

theme.palette = palette;

theme.font = "Hack Nerd Font 9"

theme.bg_normal = palette.bg
theme.bg_focus = palette.fg
theme.bg_urgent = palette.bg
theme.bg_minimize = palette.gray

theme.bg_systray = palette.black
theme.systray_icon_spacing = dpi(4)

theme.fg_normal = palette.fg
theme.fg_focus =  palette.black
theme.fg_urgent =  palette.red
theme.fg_minimize = palette.gray

theme.useless_gap = dpi(3)
theme.border_width = dpi(2)
theme.border_normal = palette.gray
theme.border_focus =  palette.blue
theme.border_marked = palette.orange

theme.taglist_bg_focus = palette.fg_alt
theme.taglist_fg_focus = palette.bg
theme.taglist_fg_empty = palette.gray
theme.taglist_fg_occupied = palette.yellow
theme.taglist_fg_urgent = theme.fg_urgent

theme.tasklist_bg_urgent = theme.fg_urgent
theme.tasklist_bg_normal = palette.blue
theme.tasklist_bg_focus = palette.teal

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- theme.wallpaper = "/home/kernelpanic/Pictures/nord-wallpapers/kittyboard.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

theme.calendar_style = {
    border_width = 0,
}

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
