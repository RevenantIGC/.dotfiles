#!/usr/bin/env nix-shell
--[[
#!nix-shell -i luajit -p luajit luajitPackages.cjson
--]]
local subscribe_to_window = 'i3-msg -t subscribe \'["window"]\''
local json = require('cjson.safe')
local handle = io.popen(subscribe_to_window)

function print_window_name()
  handle = io.popen(subscribe_to_window)
  local output = handle:read('*a')
  local event = json.decode(output)
  if event then
    print(event["container"]["name"])
  end
end

print_window_name()
while true
do
  print_window_name()
end
