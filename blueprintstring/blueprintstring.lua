--[[
Blueprint String

This library helps you convert blueprints to text strings, and text strings to blueprints.

Saving Blueprints
-----------------
local BlueprintString = require "blueprintstring.blueprintstring"
local blueprint_table = {}
blueprint_table.icons = blueprint.blueprint_icons
blueprint_table.entities = blueprint.get_blueprint_entities()
blueprint_table.myfield = "Add some extra fields if you want"
local str = BlueprintString.toString(blueprint_table)

Loading Blueprints
------------------
local BlueprintString = require "blueprintstring.blueprintstring"
local blueprint_table = BlueprintString.fromString(str)
blueprint.set_blueprint_entities(blueprint_table.entities)
blueprint.blueprint_icons = blueprint_table.icons

]]--



local serpent = require "serpent0272"
local inflate = require "deflatelua"
local deflate = require "zlib-deflate"
local base64 = require "base64"

function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function item_count(t) 
	local count = 0
	if (#t >= 2) then return 2 end
	for k,v in pairs(t) do count = count + 1 end
	return count
end

function fix_entities(array)
	if (not array or type(array) ~= "table") then return {} end
	local entities = {}
	local count = 1
	for _, entity in ipairs(array) do
		if (type(entity) == 'table') then
			entity.entity_number = count
			entities[count] = entity
			count = count + 1
		end
	end
	return entities
end

function fix_icons(array)
	if (not array or type(array) ~= "table") then return {} end
	if (#array > 1000) then return {} end
	local icons = {}
	local count = 1
	for _, icon in pairs(array) do
		if (count > 4) then break end
		if (type(icon) == 'string') then
			table.insert(icons, {index = count, name = icon})
			count = count + 1
		elseif (type(icon) == 'table' and icon.name) then
			table.insert(icons, {index = count, name = icon.name})
			count = count + 1
		end
	end
	return icons
end

function remove_useless_fields(entities)
	if (not entities or type(entities) ~= "table") then return end
	for _, entity in ipairs(entities) do
		if (type(entity) ~= "table") then entity = {} end

		-- Entity_number is calculated in fix_entities()
		entity.entity_number = nil
		
		if (item_count(entity) == 0) then entity = nil end
	end
end

function reformat_icons(array)
	local icons = {}
	local count = 1
	if (array[0]) then
		table.insert(icons, {index=count, name=array[0].name})
		count = count + 1
	end
	for _, icon in ipairs(array) do
		if (count > 4) then break end
		table.insert(icons, {index=count, name=icon.name})
		count = count + 1
	end
	return icons
end

-- ====================================================
-- Public API

local M = {}

M.COMPRESS_STRINGS = true  -- Compress saved strings. Format is gzip + base64.
M.LINE_LENGTH = 120  -- Length of lines in compressed string. 0 means unlimited length.

M.toString = function(blueprint_table)
	remove_useless_fields(blueprint_table.entities)
	blueprint_table.icons = reformat_icons(blueprint_table.icons)
	local str = serpent.dump(blueprint_table)
	if (M.COMPRESS_STRINGS) then
		str = deflate.gzip(str)
		str = base64.enc(str)
		if (M.LINE_LENGTH > 0) then
			str = str:gsub( ("%S"):rep(M.LINE_LENGTH), "%1\n" )
		end
	end
	str = str .. "\n"
	return str
end

M.fromString = function(data)
	data = trim(data)
	if (string.sub(data, 1, 8) ~= "do local") then
		-- Decompress string
		local output = {}
		local input = base64.dec(data)
		local status, result = pcall(inflate.gunzip, { input = input, output = function(byte) output[#output+1] = string.char(byte) end })
		if (status) then
			data = table.concat(output)
		else
			--game.player.print(result)
			return nil
		end
	end

	local status, result = serpent.load(data)
	if (not status) then
		--game.player.print(result)
		return nil
	end

	result.entities = fix_entities(result.entities)
	result.icons = fix_icons(result.icons)

	return result
end

return M
