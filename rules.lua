local beautiful = require('beautiful')
local keys = require('keys')
local awful = require('awful')

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
local rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.client_keys,
            buttons = keys.client_buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {type = { "normal", "dialog" }},
        properties = { titlebars_enabled = false }
    },

    {
        rule_any = {
            { class = {'Firefox', 'Chromium'} },
        },
        properties = {
            maximized = true,
            fullscreen = true,
            floating = false,
        }
    },

    {
        rule = { instance = "splash" },
        properties = {
            floating = true,
            maximized = false,
            placement = awful.placement.centered,
        }
    },

    {
        rule = { instance = "Devtools" },
        properties = {
            maximized = false,
            floating = true,
            ontop = true,
        }
    },
    {
        rule = { instance = "kitty" },
        properties = {
            width = 1024,
            height = 600,
            maximized = false,
            floating = true,
            placement = awful.placement.centered,
        }
    },
    {
        rule = { class = "KeePassXC" },
        properties = {
            maximized = false,
            floating = true,
            placement = awful.placement.centered,
        }
    }
}

return rules
