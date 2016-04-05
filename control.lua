require "defines"
local BlueprintString = require "blueprintstring.blueprintstring"
BlueprintString.COMPRESS_STRINGS = true
BlueprintString.LINE_LENGTH = 120

function init_gui(player, ignoretech)
	if (not ignoretech and not player.force.technologies["automated-construction"].researched) then
		return
	end

	if (not player.gui.top["blueprint-string-button"]) then
		player.gui.top.add{type="button", name="blueprint-string-button", style="blueprintstring_button_main"}
	end
end

script.on_init(function()
	for _, player in pairs(game.players) do
		init_gui(player, false)
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	init_gui(game.players[event.player_index], false)
end)

script.on_event(defines.events.on_research_finished, function(event)
	if (event.research.name == "automated-construction") then
		for _, player in pairs(game.players) do
			if (event.research.force.name == player.force.name) then
				init_gui(player, true)
			end
		end
	end
end)

function expand_gui(player)
	local frame = player.gui.left["blueprint-string"]
	if (frame) then
		frame.destroy()
	else
		frame = player.gui.left.add{type="frame", name="blueprint-string"}
		frame.add{type="label", caption={"textbox-caption"}}
		frame.add{type="textfield", name="blueprint-string-text"}
		frame.add{type="button", name="blueprint-string-load", style="blueprintstring_button_load"}
		frame.add{type="button", name="blueprint-string-save-as", style="blueprintstring_button_saveas"}
		frame.add{type="button", name="blueprint-string-save-all", style="blueprintstring_button_saveall"}
	end
end

function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function filter_blueprints(inventory)
	local blueprints = {}
	if (inventory) then
		local total = inventory.get_item_count("blueprint")
		local count = 0
		local i = 1
		while (count < total) do
			if (inventory[i].valid_for_read and inventory[i].type == "blueprint") then
				blueprints[i] = inventory[i]
				count = count + inventory[i].count
			end
			i = i + 1

			assert(i < 999999, "Infinite loop in filter_blueprints")
		end
	end
	return blueprints
end

function find_empty_blueprint(player)
	for _, stack in pairs(filter_blueprints(player.get_inventory(defines.inventory.player_quickbar))) do
		if (not stack.is_blueprint_setup()) then
			return stack
		end
	end

	for _, stack in pairs(filter_blueprints(player.get_inventory(defines.inventory.player_main))) do
		if (not stack.is_blueprint_setup()) then
			return stack
		end
	end

	return nil
end

function load_blueprint(player)
	local blueprint = find_empty_blueprint(player)
	if (not blueprint) then
		player.print({"no-empty-blueprint"})
		return
	end

	local data = trim(player.gui.left["blueprint-string"]["blueprint-string-text"].text)
	player.gui.left["blueprint-string"]["blueprint-string-text"].text = ""

	if (data == "") then
		player.print({"no-string"})
		return
	end

	local blueprint_format = BlueprintString.fromString(data)
	if (not blueprint_format or type(blueprint_format) ~= "table") then
		player.print({"unknown-format"})
		return
	end

	if (not blueprint_format.icons or type(blueprint_format.icons) ~= "table" or #blueprint_format.icons < 1) then
		player.print({"unknown-format"})
		return
	end

	status, result = pcall(blueprint.set_blueprint_entities, blueprint_format.entities)
	if (not status) then
		player.print({"blueprint-api-error", result})
		blueprint.set_blueprint_entities({})
		return
	end

	status, result = pcall(blueprint.set_blueprint_tiles, blueprint_format.tiles)
	if (not status) then
		player.print({"blueprint-api-error", result})
		blueprint.set_blueprint_entities({})
		return
	end

	if (blueprint.is_blueprint_setup()) then
		status, result = pcall(function() blueprint.blueprint_icons = blueprint_format.icons end)
		if (not status) then
			player.print({"blueprint-icon-error", result})
			blueprint.set_blueprint_entities({})
			return
		end
	end

end

local blueprints_saved = 0
function save_blueprint(player, stack, filename)
	local icons = stack.blueprint_icons
	local entities = stack.get_blueprint_entities()
	local tiles = stack.get_blueprint_tiles()
	local blueprint_format = {entities=entities, icons=icons, tiles=tiles}

	local data = BlueprintString.toString(blueprint_format)

	if (#game.players > 1 and player.name and player.name ~= "") then
		local name = player.name
		filename = name .. "-" .. filename
	end

	filename = filename:gsub("[/\\:*?\"<>|]", "_")

	game.write_file("blueprint-string/" .. filename .. ".txt", data)

	blueprints_saved = blueprints_saved + 1
end

function save_blueprint_as(player, filename)
	blueprints_saved = 0

	if (not holding_blueprint(player)) then
		player.print({"no-blueprint-in-hand"})
		return
	end

	if (not filename or filename == "") then
		player.print({"no-filename"})
		return
	end

	save_blueprint(player, player.cursor_stack, filename)

	player.gui.center["blueprint-string-filename-prompt"].destroy()

	if (blueprints_saved > 0) then
		player.print({"blueprint-saved-as", filename})
	else
		player.print({"blueprints-not-saved"})
	end
end

function save_blueprints(player)
	blueprints_saved = 0

	for position, stack in pairs(filter_blueprints(player.get_inventory(defines.inventory.player_quickbar))) do
		if (stack.is_blueprint_setup()) then
			save_blueprint(player, stack, "toolbar-"..position)
		end
	end

	for position, stack in pairs(filter_blueprints(player.get_inventory(defines.inventory.player_main))) do
		if (stack.is_blueprint_setup()) then
			save_blueprint(player, stack, "inventory-"..position)
		end
	end

	if (blueprints_saved > 0) then
		player.print({"blueprints-saved", blueprints_saved})
	else
		player.print({"blueprints-not-saved"})
	end
end

function holding_blueprint(player)
	return (player.cursor_stack.valid_for_read and player.cursor_stack.type == "blueprint" and player.cursor_stack.is_blueprint_setup())
end

function prompt_for_filename(player)
	if (not holding_blueprint(player)) then
		player.print({"no-blueprint-in-hand"})
		return
	end

	local frame = player.gui.center["blueprint-string-filename-prompt"]
	if (frame) then
		frame.destroy()
	end
	
	frame = player.gui.center.add{type="frame", direction="vertical", name="blueprint-string-filename-prompt"}
	local line1 = frame.add{type="flow", direction="horizontal"}
	line1.add{type="label", caption={"save-as-2"}}
	frame.add{type="textfield", name="blueprint-string-filename"}
	local line2 = frame.add{type="flow", direction="horizontal"}
	line2.add{type="button", name="blueprint-string-filename-save", caption={"save"}, font_color=white, style="blueprintstring_button_style"}
	line2.add{type="button", name="blueprint-string-filename-cancel", caption={"cancel"}, font_color=white, style="blueprintstring_button_style"}
end

script.on_event(defines.events.on_gui_click, function(event) 
	local player = game.players[event.element.player_index]
	local name = event.element.name
	if (name == "blueprint-string-load") then
		load_blueprint(player)
	elseif (name == "blueprint-string-save-all") then
		save_blueprints(player)
	elseif (name == "blueprint-string-save-as") then
		prompt_for_filename(player)
	elseif (name == "blueprint-string-filename-save") then
		save_blueprint_as(player, player.gui.center["blueprint-string-filename-prompt"]["blueprint-string-filename"].text)
	elseif (name == "blueprint-string-filename-cancel") then
		player.gui.center["blueprint-string-filename-prompt"].destroy()
	elseif (name == "blueprint-string-button") then
		expand_gui(player)
	end
end)

script.on_event(defines.events.on_robot_built_entity, function(event) 
	local entity = event.created_entity
	if (entity and entity.type == "assembling-machine" and entity.recipe and not entity.recipe.enabled) then
		entity.recipe = nil
	end
end)
