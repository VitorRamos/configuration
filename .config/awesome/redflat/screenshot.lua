local awful = require("awful")
local naughty = require("naughty")

local screenshot_widget = {}

timers = { 5,10 }
screenshot = os.getenv("HOME") .. "/Pictures/scrot/$(date +%F_%T).png"

local function scrot(cmd , callback, args)
    awful.util.spawn_with_shell(cmd)
    callback(args)
end
local function scrot_callback(text)
    naughty.notify({
        text = text,
        timeout = 0.5
    })
end

function screenshot_widget:scrot_full()
    scrot("scrot " .. screenshot .. " -e 'xclip -selection c -t image/png < $f', scrot_callback", scrot_callback, "Take a screenshot of entire screen")
end

function screenshot_widget:scrot_selection()
    scrot("sleep 0.5 && scrot -s " .. screenshot .. " -e 'xclip -selection c -t image/png < $f'", scrot_callback, "Take a screenshot of selection")
end

function screenshot_widget:scrot_window()
    scrot("scrot -u " .. screenshot .. " -e 'xclip -selection c -t image/png < $f'", scrot_callback, "Take a screenshot of focused window")    
end

function screenshot_widget:scrot_delay()
    items={}
    for key, value in ipairs(timers)  do
        items[#items+1]={tostring(value) , "scrot -d ".. value.." " .. screenshot .. " -e 'xclip -selection c -t image/png < $f'","Take a screenshot of delay" }
    end
    awful.menu.new(
    {
        items = items
    }
    ):show({keygrabber= true})
    scrot_callback()
end


return screenshot_widget