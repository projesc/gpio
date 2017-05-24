
sysfs="/sys/class/gpio"

kv={}

function file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end

function readf(file)
  local f = io.open(file, "rb")
  if f == nil then 
    io.close(f) 
    log("erro reading "..file)
    return ""
  end
  io.input(f)
  local content = io.read("*a")
  io.close(f)
  return string.sub(content,1,-2)
end

function writef(file,content)
  local f = io.open(file, "w")
  io.output(f)
  io.write(content)
  io.close(f)
end

-- only if we have gpio
if not file_exists(sysfs) then
  return
end

-- export gpio if not already
for i=2,27 do
  if not file_exists(sysfs.."/gpio"..i) then
    writef(sysfs.."/export",i)
  end
end

on("*","gpio_is_in",function(msg) 
    log(msg.from.." gpio"..msg.payload.." direction IN")
end)

on("*","gpio_is_out",function(msg) 
    log(msg.from.." gpio"..msg.payload.." direction IN")
end)

on("*","gpio_is_high",function(msg) 
    log(msg.from.." gpio"..msg.payload.." value HIGH")
end)

on("*","gpio_is_low",function(msg) 
    log(msg.from.." gpio"..msg.payload.." value LOW")
end)

on("*","set_gpio_low",function(msg)
  i = msg.payload
  local direction_file=sysfs.."/gpio"..i.."/direction"
  writef(direction_file,"out")
  local value_file=sysfs.."/gpio"..i.."/value"
  writef(value_file,"0")
end)

on("*","set_gpio_high",function(msg)
  i = msg.payload
  local direction_file=sysfs.."/gpio"..i.."/direction"
  writef(direction_file,"out")
  local value_file=sysfs.."/gpio"..i.."/value"
  writef(value_file,"1")
end)

on("*","set_gpio_in",function(msg)
  i = msg.payload
  local direction_file=sysfs.."/gpio"..i.."/direction"
  writef(direction_file,"in")
end)

on("*","set_gpio_out",function(msg)
  i = msg.payload
  local direction_file=sysfs.."/gpio"..i.."/direction"
  writef(direction_file,"out")
end)

tick(1,function()
  for i=2,27 do
    local direction_file=sysfs.."/gpio"..i.."/direction"
    local direction=readf(direction_file)
    local direction_key=self().."/gpio"..i.."/direction"

    if kv[direction_key] ~= direction then
      kv[direction_key]=direction
      send("gpio_is_"..direction,i)
      send("gpio_"..i.."_direction_is",direction)
    end

    local value_file=sysfs.."/gpio"..i.."/value"
    local value_n=readf(value_file)

    local value="high"
    if value_n == "1" then
      value="high"
    else
      value="low"
    end
    local value_key=self().."/gpio"..i.."/value"
    if kv[value_key] ~= value then
      kv[value_key]=value
      send("gpio_"..i.."_value_is",value)
      sendEvent("gpio_is_"..value,i)
    end
  end
  return true
end)

