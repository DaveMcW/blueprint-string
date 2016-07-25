local BlueprintString = require "blueprintstring.blueprintstring"
BlueprintString.COMPRESS_STRINGS = false
BlueprintString.LINE_LENGTH = 120

function init_gui(player)
	if (not player.force.technologies["automated-construction"].researched) then
		return
	end

	if (not player.gui.top["blueprint-string-button"]) then
		player.gui.top.add{type="button", name="blueprint-string-button", style="blueprintstring_button_main"}
	end
end

script.on_init(function()
	for _, player in pairs(game.players) do
		init_gui(player)
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	init_gui(game.players[event.player_index])
end)

script.on_event(defines.events.on_research_finished, function(event)
	if (event.research.name == "automated-construction") then
		for _, player in pairs(game.players) do
			if (event.research.force.name == player.force.name) then
				init_gui(player)
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
		frame.add{type="button", name="blueprint-string-save", style="blueprintstring_button_saveas"}
		frame.add{type="button", name="blueprint-string-save-all", style="blueprintstring_button_saveall"}
		frame.add{type="button", name="blueprint-string-upgrade", style="blueprintstring_button_upgrade"}
	end
end

function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function filter(inventory, type)
	local stacks = {}
	if (inventory) then
		for i = 1, #inventory do
			if (inventory[i].valid_for_read and inventory[i].type == type) then
				stacks[i] = inventory[i]
			end
		end
	end
	return stacks
end

function book_inventory(book)
	local blueprints = {}
	local active = book.get_inventory(defines.inventory.item_active)
	local main = book.get_inventory(defines.inventory.item_main)

	if (active[1].valid_for_read and active[1].type == "blueprint") then 
		blueprints[1] = active[1]
	end

	for i = 1, #main do
		if (main[i].valid_for_read and main[i].type == "blueprint") then
			blueprints[i+1] = main[i]
		end
	end

	return blueprints
end

function holding_blueprint(player)
	return (player.cursor_stack.valid_for_read and player.cursor_stack.type == "blueprint")
end

function holding_valid_blueprint(player)
	return (holding_blueprint(player) and player.cursor_stack.is_blueprint_setup())
end

function holding_book(player)
	return (player.cursor_stack.valid_for_read and player.cursor_stack.type == "blueprint-book")
end

function find_empty_blueprint(player, no_crafting)
	local main = player.get_inventory(defines.inventory.player_main)
	local quickbar = player.get_inventory(defines.inventory.player_quickbar)

	if (holding_blueprint(player)) then
		if (player.cursor_stack.is_blueprint_setup()) then
			player.cursor_stack.set_blueprint_entities(nil)
			player.cursor_stack.set_blueprint_tiles(nil)
			player.cursor_stack.label = "" 
		end
		return player.cursor_stack
	end

	local stacks = filter(quickbar, "blueprint")
	for i, stack in pairs(filter(main, "blueprint")) do
		stacks[#quickbar+i] = stack
	end
	for _, stack in pairs(stacks) do
		if (not stack.is_blueprint_setup()) then
			return stack
		end
	end

	if (no_crafting) then
		return nil
	end
	
	-- Craft a new blueprint
	if (player.can_insert("blueprint") and player.get_item_count("advanced-circuit") >= 1) then
		player.remove_item{name="advanced-circuit", count=1}
		if (player.insert("blueprint") == 1) then
			return find_empty_blueprint(player, true)
		end
	end

	return nil
end

function find_empty_book(player, slots, no_crafting)
	if (holding_book(player)) then
		for _, page in pairs(book_inventory(book)) do
			if (page.is_blueprint_setup()) then
				page.set_blueprint_entities(nil)
				page.set_blueprint_tiles(nil)
				page.label = "" 
			end
		end
		return player.cursor_stack
	end

	local advanced_circuits = player.get_item_count("advanced-circuit")
	local main = player.get_inventory(defines.inventory.player_main)
	local quickbar = player.get_inventory(defines.inventory.player_quickbar)
	local first_empty_book = nil
	local books = filter(quickbar, "blueprint-book")
	for i, book in pairs(filter(main, "blueprint-book")) do
		books[#quickbar+i] = book
	end
	for _, book in pairs(books) do
		local empty = true
		local pages = 0
		for _, page in pairs(book_inventory(book)) do
			if (page.is_blueprint_setup()) then
				empty = false
			end
			pages = pages + 1
		end
		if (empty) then
			if (pages + advanced_circuits >= slots) then
				return book
			end
			if (not first_empty_book) then
				first_empty_book = book
			end
		end
	end

	if (first_empty_book) then
		-- We can't afford to craft all the blueprints, but at least we have an empty book
		return first_empty_book
	end
	
	if (no_crafting) then
		return nil
	end
	
	-- Craft a new book
	if (player.can_insert("blueprint-book") and advanced_circuits >= 15 + slots) then
		player.remove_item{name="advanced-circuit", count=15}
		if (player.insert("blueprint-book") == 1) then
			return find_empty_book(player, slots, true)
		end
	end
	
	return nil
end

function load_blueprint(player)
	local textbox = player.gui.left["blueprint-string"]["blueprint-string-text"]
	local data = trim(textbox.text)
	if (data == "") then
		player.print({"no-string"})
		return
	end

	local blueprint_format = BlueprintString.fromString(data)
	if (not blueprint_format or type(blueprint_format) ~= "table") then
		textbox.text = ""
		player.print({"unknown-format"})
		return
	end

	local blueprint
	if (blueprint_format.book) then
		if (type(blueprint_format.book) ~= "table" or #blueprint_format.book < 1) then
			player.print({"unknown-format"})
			return
		end
		blueprint = find_empty_book(player, #blueprint_format.book)
		if (not blueprint) then
			player.print({"no-empty-blueprint"})
			return
		end
		local advanced_circuits = #blueprint_format.book - #book_inventory(blueprint)
		if (advanced-circuits > player.get_item_count("advanced-circuit")) then
			player.print({"need-advanced-circuit", advanced_circuits})
			return
		end
	else
		blueprint = find_empty_blueprint(player)
		if (not blueprint) then
			player.print({"no-empty-blueprint"})
			return
		end
	end

	textbox.text = ""

	if (not blueprint_format.icons or type(blueprint_format.icons) ~= "table" or #blueprint_format.icons < 1) then
		player.print({"unknown-format"})
		return
	end

	status, result = pcall(blueprint.set_blueprint_entities, blueprint_format.entities)
	if (not status) then
		player.print({"blueprint-api-error", result})
		blueprint.set_blueprint_entities(nil)
		return
	end

	status, result = pcall(blueprint.set_blueprint_tiles, blueprint_format.tiles)
	if (not status) then
		player.print({"blueprint-api-error", result})
		blueprint.set_blueprint_entities(nil)
		return
	end

	if (blueprint.is_blueprint_setup()) then
		status, result = pcall(function() blueprint.blueprint_icons = blueprint_format.icons end)
		if (not status) then
			player.print({"blueprint-icon-error", result})
			blueprint.set_blueprint_entities(nil)
			blueprint.set_blueprint_tiles(nil)
			return
		end
	end

	blueprint.label = blueprint_format.name or ""
end

local duplicate_filenames
function fix_filename(player, filename)
	if (#game.players > 1 and player.name and player.name ~= "") then
		local name = player.name
		filename = name .. "-" .. filename
	end

	filename = filename:gsub("[/\\:*?\"<>|]", "_")

	local lowercase = filename:lower()
	if (duplicate_filenames[lowercase]) then
		duplicate_filenames[lowercase] = duplicate_filenames[lowercase] + 1
		filename = filename .. "-" .. duplicate_filenames[lowercase]
	else
		duplicate_filenames[lowercase] = 1
	end
	
	return filename
end

local blueprints_saved
function blueprint_to_file(player, stack, filename)
	local blueprint_format = {
		entities = stack.get_blueprint_entities(),
		tiles = stack.get_blueprint_tiles(),
		icons = stack.blueprint_icons,
		name = stack.label,
	}
	
	local data = BlueprintString.toString(blueprint_format)
	filename = fix_filename(player, filename)
	game.write_file("blueprint-string/" .. filename .. ".txt", data)
	blueprints_saved = blueprints_saved + 1
end

function book_to_file(player, book, filename)
	local blueprint_format = { book = {} }
	
	for position, stack in pairs(book_inventory(book)) do 
		if (stack.is_blueprint_setup()) then
			blueprint_format.book[position] = {
				entities = stack.get_blueprint_entities(),
				tiles = stack.get_blueprint_tiles(),
				icons = stack.blueprint_icons,
				name = stack.label,
			}
		end
	end

	local data = BlueprintString.toString(blueprint_format)
	filename = fix_filename(player, filename)
	game.write_file("blueprint-string/" .. filename .. ".txt", data)
	blueprints_saved = blueprints_saved + 1
end

function save_blueprint_as(player, filename)
	blueprints_saved = 0

	if (not holding_valid_blueprint(player) and not holding_book(player)) then
		player.print({"no-blueprint-in-hand"})
		return
	end

	if (not filename or filename == "") then
		player.print({"no-filename"})
		return
	end

	filename = filename:sub(1,100)

	if (player.cursor_stack.type == "blueprint") then
		blueprint_to_file(player, player.cursor_stack, filename)
	elseif (player.cursor_stack.type == "blueprint-book") then
		book_to_file(player, player.cursor_stack, filename)
	end

	local prompt = player.gui.center["blueprint-string-filename-prompt"]
	if (prompt) then prompt.destroy() end

	if (blueprints_saved > 0) then
		player.print({"blueprint-saved-as", filename})
	else
		player.print({"blueprints-not-saved"})
	end
end

function save_blueprint(player)
	if (not holding_valid_blueprint(player) and not holding_book(player)) then
		player.print({"no-blueprint-in-hand"})
		return
	end

	if (player.cursor_stack.label) then
		save_blueprint_as(player, player.cursor_stack.label)
	else
		prompt_for_filename(player)
	end
end

function save_all(player)
	blueprints_saved = 0
	duplicate_filenames = {}

	local main = player.get_inventory(defines.inventory.player_main)
	local quickbar = player.get_inventory(defines.inventory.player_quickbar)

	for position, stack in pairs(filter(quickbar, "blueprint")) do
		if (stack.is_blueprint_setup()) then
			local filename = "toolbar-"..position
			if (stack.label) then
				filename = stack.label
			end
			blueprint_to_file(player, stack, filename)
		end
	end

	for position, stack in pairs(filter(main, "blueprint")) do
		if (stack.is_blueprint_setup()) then
			local filename = "inventory-"..position
			if (stack.label) then
				filename = stack.label
			end
			blueprint_to_file(player, stack, filename)
		end
	end

	-- TODO: Add blueprint books
	
	if (blueprints_saved > 0) then
		player.print({"blueprints-saved", blueprints_saved})
	else
		player.print({"blueprints-not-saved"})
	end
end

function prompt_for_filename(player)
	local frame = player.gui.center["blueprint-string-filename-prompt"]
	if (frame) then
		frame.destroy()
	end
	
	frame = player.gui.center.add{type="frame", direction="vertical", name="blueprint-string-filename-prompt"}
	local line1 = frame.add{type="flow", direction="horizontal"}
	line1.add{type="label", caption={"save-as"}}
	frame.add{type="textfield", name="blueprint-string-filename"}
	local line2 = frame.add{type="flow", direction="horizontal"}
	line2.add{type="button", name="blueprint-string-filename-save", caption={"save"}, font_color=white, style="blueprintstring_button_style"}
	line2.add{type="button", name="blueprint-string-filename-cancel", caption={"cancel"}, font_color=white, style="blueprintstring_button_style"}
end

function contains_entities(blueprint, entities)
	if not blueprint.entities then
		return false 
	end
	
	for _,e in pairs(blueprint.entities) do
		if entities[e.name] then
			return true
		end
    end

	return false
end

function upgrade_blueprint(player)
	if (not holding_valid_blueprint(player)) then
		player.print({"no-blueprint-in-hand"})
		return
	end

	local entities = player.cursor_stack.get_blueprint_entities()
	local tiles = player.cursor_stack.get_blueprint_tiles()
	
	local offset = { x=-0.5, y=-0.5 }
	local rail_entities = {}
	rail_entities["straight-rail"] = true
	rail_entities["curved-rail"]=true
	rail_entities["rail-signal"]=true
	rail_entities["rail-chain-signal"]=true
	rail_entities["train-stop"]=true
	rail_entities["smart-train-stop"]=true
	if contains_entities(entities, rail_entities) then
		offset = { x = -1, y = -1 }
	end

	if (entities) then
		for _, entity in pairs(entities) do
			entity.position = {x = entity.position.x + offset.x, y = entity.position.y + offset.y}
		end
		player.cursor_stack.set_blueprint_entities(entities)
	end
	if (tiles) then
		for _, entity in pairs(tiles) do
			tile.position = {x = tile.position.x + offset.x, y = tile.position.y + offset.y}
		end
		player.cursor_stack.set_blueprint_tiles(tiles)
    end
end

script.on_event(defines.events.on_gui_click, function(event) 
	local player = game.players[event.element.player_index]
	local name = event.element.name
	if (name == "blueprint-string-load") then
		load_blueprint(player)
	elseif (name == "blueprint-string-save-all") then
		save_all(player)
	elseif (name == "blueprint-string-save") then
		save_blueprint(player)
	elseif (name == "blueprint-string-filename-save") then
		save_blueprint_as(player, player.gui.center["blueprint-string-filename-prompt"]["blueprint-string-filename"].text)
	elseif (name == "blueprint-string-filename-cancel") then
		player.gui.center["blueprint-string-filename-prompt"].destroy()
	elseif (name == "blueprint-string-button") then
		expand_gui(player)
	elseif (name == "blueprint-string-upgrade") then
		upgrade_blueprint(player)
	end
end)

script.on_event(defines.events.on_robot_built_entity, function(event) 
	local entity = event.created_entity
	if (entity and entity.type == "assembling-machine" and entity.recipe and not entity.recipe.enabled) then
		entity.recipe = nil
	end
end)
