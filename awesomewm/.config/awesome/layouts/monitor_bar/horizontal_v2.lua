local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local widget = require('util.widgets')
local font = require("util.font")

-- for the top
local ram = require("widgets.ram")({ 
  mode = "progressbar", layout = "vertical", bar_size = 40,
  title = { "RAM", "#aaff99" },
  bar_colors = "#3e7f80"
})

local volume = require("widgets.volume")({ 
  mode = "progressbar", layout = "vertical", bar_size = 40, 
  title = { "VOL", "#daffe9" },
  bar_colors = "#3e6a80"
})

local brightness = require("widgets.brightness")({ 
  mode = "progressbar", layout = "vertical", bar_size = 40,
  title = { "BRI", "#aaffe9" },
  bar_colors = "#473e80"
})

local battery = require("widgets.battery")({
  mode = "progressbar", layout = "vertical",  bar_size = 40,
  title = { "BAT", "#9afff9" },
  bar_colors = "#673e80"
})

-- bottom (monitor bar)
local cpu = require("widgets.cpu")({ 
  title = { "CPU", "#ff99bb" },
  mode = "dotsbar", layout = "vertical"
})

local disk = require("widgets.disks")({
  mode = "block", layout = "vertical",
  title = { "FS", "#efea8a" },
  bar_colors = { "#855789", "#7155a9", "#3f63a0" }
})

local network = require("widgets.network")({
  mode = "block", layout = "vertical",
  title = { "NET", "#aafa66" }, title_size = 20,
  bar_colors = { M.x.primary , M.x.secondary }
})

-- init tables
local mybar = class()

-- {{{ Wibar
function mybar:init(s)

  -- bottom bar
  s.monitor_bar = awful.wibar({ position = "bottom", width = dpi(1320), height = dpi(80), screen = s, type = "splash" })
  s.monitor_bar.bg = beautiful.wibar_bg

  -- widget to decorate 
  local boxes = function(w)
    return wibox.widget {
      { -- margin top, bottom
        { -- left
          font.caption("", M.x.primary), nil, nil, -- top
          layout = wibox.layout.align.vertical
        },
        { -- center
          w,
          left = 20,
          right = 20,
          widget = wibox.container.margin
        },
        { -- right
          font.caption("", M.x.secondary), nil, nil, -- top
          layout = wibox.layout.align.vertical
        },
        layout = wibox.layout.align.horizontal
      },
      top = 2, bottom = 2,
      left = 8, right = 8,
      widget = wibox.container.margin
    }
  end

  s.monitor_bar:setup {
    nil,
    {
      boxes(cpu),
      boxes(network),
      boxes(volume),
      boxes(disk),
      boxes(ram),
      boxes(battery),
      boxes(brightness),
      --spacing = beautiful.widget_spacing,
      expand = "none",
      layout = wibox.layout.fixed.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
  }
end

return mybar
