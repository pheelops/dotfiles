local wibox = require("wibox")
local awful = require("awful")
local gtable = require("gears.table")
local widget = require("util.widgets")
local separator = require("util.separators")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local font = require("util.font")
local btext = require("util.mat-button")

-- beautiful var
local fg = "#ffffff"
local bg = "#651030"
local l = "horizontal"

local pad = separator.pad(3)

-- Setting titles
local monitors_title = font.body_title('Monitors', M.x.on_surface, M.t.high)
monitors_title.align = "left"
local settings_title = font.body_title('Settings', M.x.on_surface, M.t.high)
settings_title.align = "left"

-- import widgets
local vol = require("widgets.volume")({ mode = "slider" })
local brightness = require("widgets.brightness")({ mode = "slider" })
local cpu = require("widgets.cpu")({ mode = "arcchart" })
local ram = require("widgets.ram")({ mode = "arcchart" })
local disks = require("widgets.disks")({ mode = "arcchart" })

local mybar = class()

function mybar:init(s)

  s.monitor_bar = awful.wibar({ stretch = false, visible = false, type = "dock", screen = s })
  s.monitor_bar.bg = M.x.surface

  -- add an exit button
  local hide_monitor = function ()
    exit_screen_show()
    s.monitor_bar.visible = false
  end
  local exit = btext({ fg_icon = "on_error", icon = "",
    font_icon = M.f.button,
    fg_text = "on_error", text = "LOGOUT",
    bg = "error", mode = "contained",
    spacing = 10,
    overlay = "on_error", command = hide_monitor, layout = "horizontal"
  })

  local wibar_pos = beautiful.wibar_position or "top"
  -- place the sidebar at the right position
  if wibar_pos == "left" then
    s.monitor_bar.x = beautiful.wibar_size
    s.monitor_bar.y = 0
    s.monitor_bar.position = "left"
  elseif wibar_pos == "right" then
    s.monitor_bar.position = "right"
  end

  s.monitor_bar.height = awful.screen.focused().geometry.height
  s.monitor_bar.width = dpi(230)

  local textclock = wibox.widget {
    format = '<span foreground="'..M.x.on_surface..'" font="22.5">%H:%M</span>',
    refresh = 60,
    widget = wibox.widget.textclock,
    forced_height = dpi(88),
    forced_width = dpi(90)
  }

  -- a middle click to hide the sidebar
  s.monitor_bar:buttons(gtable.join(
    awful.button({ }, 2, function() 
      s.monitor_bar.visible = false
    end)
  ))

  -- setup
  s.monitor_bar:setup {
    { -- bg
      { -- margin
        widget.centered(textclock), -- top
        { -- center
          monitors_title,
          cpu,
          ram,
          disks,
          spacing = dpi(10),
          layout = wibox.layout.fixed.vertical
        },
        { -- bottom
          settings_title,
          vol,
          brightness,
          widget.centered(exit),
          spacing = 6,
          layout = wibox.layout.fixed.vertical
        },
        layout = wibox.layout.align.vertical
      },
      margins = 12,
      widget = wibox.container.margin
    },
    bg = M.x.on_surface .. M.e.dp01,
    widget = wibox.container.background
  }
end

return mybar
