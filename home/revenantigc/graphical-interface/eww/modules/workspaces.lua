#!/usr/bin/env nix-shell
--[[
#! nix-shell -i luajit -p luajit luajitPackages.cjson luajitPackages.inspect
--]]
local json = require('cjson.safe')
local inspect = require('inspect')
local handle = io.popen('i3-msg -t subscribe \'["workspace"]\' > /dev/null && i3-msg -t get_workspaces')
local mapping_table = {
  ['1'] = '1',
  ['2'] = '2',
  ['3'] = '3',
  ['4'] = '4',
  ['5'] = '5',
  ['6'] = '6',
  ['7'] = '7',
  ['8'] = '8',
  ['9'] = '9',
  ['10'] = '10'
}

local mapped = {}
local output = ''
local workspaces = {}

function print_workspaces()
  mapped = {}
  handle = io.popen('i3-msg -t get_workspaces')
  output = handle:read('*a')
  workspaces = json.decode(output)
  if workspaces then
    for k, v in ipairs(workspaces) do
      v['label'] = mapping_table[v['name']]
      mapped[k] = v
    end
    print(json.encode(mapped))
  end
end

function print_workspaces_watch()
  mapped = {}
  handle = io.popen('i3-msg -t subscribe \'["workspace"]\' > /dev/null && i3-msg -t get_workspaces')
  output = handle:read('*a')
  workspaces = json.decode(output)
  if workspaces then
    for k, v in ipairs(workspaces) do
      v['label'] = mapping_table[v['name']]
      mapped[k] = v
    end
    print(json.encode(mapped))
  end
end


print_workspaces()
while true
do
  print_workspaces_watch()
end

