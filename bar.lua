-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local mytextclock = wibox.widget.textclock('<b>%H:%M</b>')
local mycalendar = awful.widget.calendar_popup.month()

mycalendar.cell_flags = {
    weekday = {
        border_width = 1,
    }
}

mycalendar:attach( mytextclock, "tr" )


local memCommand = "bash -c \"free --human | awk 'NR == 2 {printf \\\"%s/%s\\\", \\$3, \\$2}'\""
local myMemWatch = awful.widget.watch(memCommand, 1, function(widget, stdout)
    widget.markup = '<b> ' .. stdout .. '</b>'
end)


-- Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu({ 
    items = { 
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

local mylauncher = awful.widget.launcher({ 
    image = beautiful.awesome_icon,
    menu = mymainmenu 
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ keys.modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ keys.modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)


local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


function powerline_left(cr, width, height)
    gears.shape.rectangular_tag(cr, width, height, 10)
end

function powerline_right(cr, width, height)
    gears.shape.transform(gears.shape.powerline):translate(-10, 0)(cr, width, height, 10)
end
function powerline_right_no_tail(cr, width, height)
    gears.shape.transform(gears.shape.powerline)(cr, width, height, 10)
end

function createBar(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.

    awful.tag.add(" ", {
        screen = s,
        layout = awful.layout.layouts[1],
        selected = true,
        -- icon = gears.filesystem.get_configuration_dir() .. "img/code.svg"
    })

    awful.tag.add(" ", {
        screen = s,
        layout = awful.layout.layouts[1],
    })

    awful.tag.add(" ", {
        screen = s,
        layout = awful.layout.layouts[1],
    })

    awful.tag.add(" ", {
        screen = s,
        layout = awful.layout.layouts[1],
    })


    awful.tag.add(" ", {
        screen = s,
        layout = awful.layout.layouts[1],
    })
    
    awful.tag.add(" ", {
        screen = s,
        layout = awful.layout.layouts[1],
    })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end))
    )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 18,
                right = 14,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        style = {
            shape = gears.shape.rounded_bar,
        },
        layout   = {
            spacing_widget = {
                {
                    forced_width  = 1,
                    forced_height = 24,
                    thickness     = 1,
                    color         = '#4c566aR',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 2,
            layout  = wibox.layout.fixed.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            widget = wibox.widget.background,
            id = "background_role",
            {
                margins = 3,
                widget  = wibox.container.margin,
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
        },
    }
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = -20,
            {
                widget = wibox.widget.background,
                bg = "#3b4252",
                shape = powerline_right,
                {
                    widget = wibox.container.margin,
                    left = 15,
                    right = 30,
                    s.mytaglist,
                }
            },
            {
                widget = wibox.widget.background,
                bg = "#4c566a",
                shape = powerline_right_no_tail,
                {
                    widget = wibox.container.margin,
                    left = 15,
                    right = 15,
                    top = 2,
                    bottom = 2,
                    s.mytasklist,
                }
            },
        },
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = -10,
            {
                widget = wibox.widget.background,
                bg = "#ebcb8b",
                fg = "#333",
                shape = powerline_left,
                {
                    widget = wibox.container.margin,
                    left = 15,
                    right = 15,
                    mytextclock,
                },
            },
            -- {
            --     widget = wibox.widget.background,
            --     bg = "#434c5e",
            --     shape = powerline_left,
            --     {
            --         widget = wibox.container.margin,
            --         left = 20,
            --         right = 20,
            --         wibox.widget.systray(),
            --     },
            -- },
            {
                widget = wibox.widget.background,
                bg = "#d08770",
                shape = powerline_left,
                {
                    widget = wibox.container.margin,
                    left = 15,
                    right = 15,
                    myMemWatch,
                },
            },
            {
                widget = wibox.widget.background,
                bg = "#5e81ac",
                shape = powerline_left,
                {
                    widget = wibox.container.margin,
                    left = 15,
                    right = 10,
                    mykeyboardlayout,
                },
            },
        },
    }
end

return {
    createBar = createBar
}
