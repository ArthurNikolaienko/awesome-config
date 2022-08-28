local wibox = require("wibox")
local beautiful = require("beautiful")
local keys = require("keys")
local awful = require("awful")
local gears = require("gears")

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local mytextclock = wibox.widget.textclock("<b>%H:%M</b>")
local mycalendar = awful.widget.calendar_popup.month()

mycalendar.cell_flags = {
	weekday = {
		border_width = 1,
	},
}

mycalendar:attach(mytextclock, "tr")

local memCommand = 'bash -c "free --human | awk \'NR == 2 {printf \\"%s/%s\\", \\$3, \\$2}\'"'
local myMemWatch = awful.widget.watch(memCommand, 1, function(widget, stdout)
	widget.markup = "<b> " .. stdout .. "</b>"
end)

local mytempCommand = 'bash -c "cat /sys/class/hwmon/hwmon2/temp1_input | awk \'{printf \\"%0.1f °C\\", $1/1000}\'"'

local myTempWatch = awful.widget.watch(mytempCommand, 1, function(widget, stdout)
	widget.markup = "<b>" .. stdout .. "</b>"
end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ keys.modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ keys.modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
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

local function powerline_left(cr, width, height)
	gears.shape.rectangular_tag(cr, width, height, 10)
end

local function powerline_right(cr, width, height)
	gears.shape.transform(gears.shape.powerline):translate(-10, 0)(cr, width, height, 10)
end

local function powerline_right_no_tail(cr, width, height)
	gears.shape.transform(gears.shape.powerline)(cr, width, height, 10)
end

local titleBar = wibox.widget({
	markup = "Title",
	align = "center",
	widget = wibox.widget.textbox,
})

local function createBar(s)
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

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		widget_template = {
			{
				{
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 12,
				right = 10,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		style = {
			shape = powerline_right_no_tail,
		},
		--layout = {
		--    spacing_widget = {
		--        {
		--            forced_height = 30,
		--            color = "#4c566a",
		--            widget = wibox.widget.separator,
		--        },
		--    },
		--    layout = wibox.layout.fixed.horizontal,
		--},
		-- Notice that there is *NO* wibox.wibox prefix, it is a template,
		-- not a widget instance.
		widget_template = {
			widget = wibox.container.background,
			bg = beautiful.palette.fg,
			id = "background_role",
			{
				widget = wibox.container.margin,
				top = 3,
				bottom = 3,
				left = 15,
				right = 15,
				{
					id = "clienticon",
					widget = awful.widget.clienticon,
				},
			},
			nil,
			create_callback = function(self, c, index, objects)
				--luacheck: no unused args
				local children = self:get_children_by_id("clienticon")
				children[1].client = c
			end,
		},
	})
	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			widget = wibox.container.background,
			bg = beautiful.palette.bg_alt,
			shape = powerline_right,
			{
				layout = wibox.layout.fixed.horizontal,
				{
					widget = wibox.widget.background,
					bg = beautiful.palette.bg_alt,
					shape = powerline_right_no_tail,
					{
						widget = wibox.container.margin,
						right = 20,
						s.mytaglist,
					},
				},
				{
					widget = wibox.widget.background,
					bg = beautiful.palette.blue,
					shape = powerline_right_no_tail,
					{
						widget = wibox.container.margin,
						s.mytasklist,
					},
				},
			},
		},
		{
			layout = wibox.layout.flex.horizontal,
			{
				widget = wibox.container.margin,
				right = 20,
				left = 20,
				titleBar,
			},
		},
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = -10,
			{
				widget = wibox.widget.background,
				bg = beautiful.palette.blue,
				shape = powerline_left,
				{
					widget = wibox.container.margin,
					left = 15,
					right = 15,
					mytextclock,
				},
			},
			{
				widget = wibox.widget.background,
				bg = beautiful.palette.orange,
				shape = powerline_left,
				{
					widget = wibox.container.margin,
					left = 15,
					right = 15,
					myTempWatch,
				},
			},
			{
				widget = wibox.widget.background,
				bg = beautiful.palette.green,
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
				bg = beautiful.palette.teal,
				shape = powerline_left,
				{
					widget = wibox.container.margin,
					left = 10,
					right = 5,
					mykeyboardlayout,
				},
			},
			-- {
			-- 	widget = wibox.widget.background,
			-- 	bg = beautiful.palette.black,
			-- 	shape = powerline_left,
			-- 	{
			-- 		widget = wibox.container.margin,
			-- 		left = 15,
			-- 		right = 5,
			-- 		top = 3,
			-- 		bottom = 3,
			-- 		wibox.widget.systray(),
			-- 	},
			-- },
		},
	})
end

return {
	createBar = createBar,
	titleBar = titleBar,
}
