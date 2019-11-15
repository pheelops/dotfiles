local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local separators = require('util.separators')
local widget = require('util.widgets')

-- widgets load
local pad = separators.pad
local mpc = require("widgets.button_only_mpc")
local change_theme = require("widgets.button_change_theme")
local desktop_ctrl = require("widgets.desktop-control")
local scrot = require("widgets.scrot")
local layouts = require("widgets.layouts")

-- for the top
local ram = require("widgets.ram")({ mode = "progressbar", bar_size = 100 })
local volume = require("widgets.volume")({ mode = "progressbar", bar_size = 100 })
local brightness = require("widgets.brightness")({ mode = "progressbar", bar_size = 100 })
local battery = require("widgets.battery")({ mode = "progressbar", bar_size = 100 })

-- bottom (monitor bar)
local cpu = require("widgets.cpu")({ mode = "dotsbar" })
local disk = require("widgets.disks")({ mode = "block" })
local network = require("widgets.network")({ mode = "block" })

-- {{{ Wibar
awful.screen.connect_for_each_screen(function(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create a tasklist widget for each screen
  s.mytasklist = require("widgets.tasklist")(s)

  -- Create a taglist widget for each screen
  s.mytaglist = require("widgets.taglist")(s, { mode = "line", want_layout = 'flex' })

  -- Create the wibox with default options
  s.mywibox = awful.wibar({ position = beautiful.wibar_position, height = beautiful.wibar_size, bg = beautiful.wibar_bg })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layouts, -- left
    s.mytasklist, -- middle
    change_theme, -- right
    expand ="none",
    layout = wibox.layout.align.horizontal
  }

  -- tagslist bar
  s.mywibox_tags = awful.wibar({ screen = s, position = "bottom", height = dpi(5), bg = beautiful.wibar_bg })
  awful.placement.maximize_horizontally(s.mywibox_tags)

  s.mywibox_tags:setup {
    widget = s.mytaglist
  }

  -- bottom bar
  s.mywiboxbottom = awful.wibar({ position = "bottom", height = dpi(80), bg = beautiful.wibar_bg })

  -- widget to decorate 
  local boxes = function(w, size)
    local s = size or 200
    return wibox.widget {
      { -- margin top, bottom
        { -- left
          widget.create_title("", beautiful.primary, 16), nil, nil, -- top
          layout = wibox.layout.align.vertical
        },
        { -- center
          w,
          top = 7, left = 17, right = 17,
          forced_width = dpi(s),
          widget = wibox.container.margin
        },
        { -- right
          widget.create_title("", beautiful.secondary, 16), nil, nil, -- top
          layout = wibox.layout.align.vertical
        },
        layout = wibox.layout.align.horizontal
      },
      top = 2, bottom = 2,
      widget = wibox.container.margin
    }
  end
  local w1 = wibox.widget {
    ram,
    brightness,
    forced_height = 30,
    layout = wibox.layout.fixed.horizontal
  }
  local w2 = wibox.widget {
    volume,
    battery,
    forced_height = 30,
    layout = wibox.layout.fixed.horizontal
  }

  s.mywiboxbottom:setup {
    { -- Left widgets
      boxes(cpu),
      boxes(disk, 250),
      spacing = beautiful.widget_spacing,
      layout = wibox.layout.fixed.horizontal
    },
    boxes(widget.box('vertical', { w1, w2 }), 300),
    { -- Right widgets
      boxes(network),
      layout = wibox.layout.fixed.horizontal
    },
    expand ="none",
    layout = wibox.layout.align.horizontal
  }
  
end)
