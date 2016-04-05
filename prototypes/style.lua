--Fonts
data:extend(
{
	{
		type = "font",
		name = "blueprintstring_font",
		from = "default",
		size = 12
	}
}
)
--[[
data.raw["gui-style"].default["blueprintstring_button_style"] =
{
		type = "button_style",
		parent = "button_style",
		top_padding = 3,
		right_padding = 3,
		bottom_padding = 3,
		left_padding = 3,
		font = "blueprintstring_font",
		hovered_font_color = {r=0.1, g=0.1, b=0.1},
		default_graphical_set =
		{
		type = "monolith",
		monolith_image =
		{
		filename = "__blueprint-string__/graphics/gui.png",
		priority = "extra-high-no-scale",
		width = 32,
		height = 32,
		x = 0
		}
		},
		hovered_graphical_set =
		{
		type = "monolith",
		monolith_image =
		{
		filename = "__blueprint-string__/graphics/gui.png",
		priority = "extra-high-no-scale",
		width = 32,
		height = 32,
		x = 32
		}
		},
		clicked_graphical_set =
		{
		type = "monolith",
		monolith_image =
		{
		filename = "__blueprint-string__/graphics/gui.png",
		width = 32,
		height = 32,
		x = 0
		}
		}
}
]]--

data.raw["gui-style"].default["blueprintstring_button_style"] =
{
	type = "button_style",
	font = "default-button",
	default_font_color={r=1, g=1, b=1},
	align = "center",
	default_graphical_set =
	{
		type = "composition",
		filename = "__core__/graphics/gui.png",
		priority = "extra-high-no-scale",
		corner_size = {3, 3},
		position = {0, 0}
	},
	hovered_font_color={r=1, g=1, b=1},
	hovered_graphical_set =
	{
		type = "composition",
		filename = "__core__/graphics/gui.png",
		priority = "extra-high-no-scale",
		corner_size = {3, 3},
		position = {0, 8}
	},
	clicked_font_color={r=1, g=1, b=1},
	clicked_graphical_set =
	{
		type = "composition",
		filename = "__core__/graphics/gui.png",
		priority = "extra-high-no-scale",
		corner_size = {3, 3},
		position = {0, 16}
	},
	disabled_font_color={r=0.5, g=0.5, b=0.5},
	disabled_graphical_set =
	{
		type = "composition",
		filename = "__core__/graphics/gui.png",
		priority = "extra-high-no-scale",
		corner_size = {3, 3},
		position = {0, 0}
	},
	pie_progress_color = {r=1, g=1, b=1},
	left_click_sound =
	{
		filename = "__core__/sound/gui-click.ogg",
		volume = 1
	}
}

data.raw["gui-style"].default["blueprintstring_button_main"] =
{
	type = "button_style",
	parent = "button_style",
	width = 36,
	height = 36,
	font = "blueprintstring_font",
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 72,
			height = 72,
			x = 0,
			y = 0,
		}
	},
	hovered_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 72,
			height = 72,
			x = 0,
			y = 72,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 72,
			height = 72,
			x = 0,
			y = 72,
		}
	},
	left_click_sound =
	{
		filename = "__core__/sound/gui-click.ogg",
		volume = 1
	},
}

data.raw["gui-style"].default["blueprintstring_button_load"] =
{
	type = "button_style",
	parent = "button_style",
	width = 36,
	height = 36,
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 72,
			height = 72,
			x = 216,
			y = 0,
		}
	},
	hovered_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 72,
			height = 72,
			x = 216,
			y = 72,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 72,
			height = 72,
			x = 216,
			y = 72,
		}
	},
	left_click_sound =
	{
		filename = "__core__/sound/gui-click.ogg",
		volume = 1
	},
}

data.raw["gui-style"].default["blueprintstring_button_saveas"] =
{
	type = "button_style",
	parent = "button_style",
	width = 36,
	height = 36,
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 72,
			height = 72,
			x = 72,
			y = 0,
		}
	},
	hovered_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 72,
			height = 72,
			x = 72,
			y = 72,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 72,
			height = 72,
			x = 72,
			y = 72,
		}
	},
	left_click_sound =
	{
		filename = "__core__/sound/gui-click.ogg",
		volume = 1
	},
}

data.raw["gui-style"].default["blueprintstring_button_saveall"] =
{
	type = "button_style",
	parent = "button_style",
	width = 36,
	height = 36,
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 72,
			height = 72,
			x = 144,
			y = 0,
		}
	},
	hovered_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 72,
			height = 72,
			x = 144,
			y = 72,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 72,
			height = 72,
			x = 144,
			y = 72,
		}
	},
	left_click_sound =
	{
		filename = "__core__/sound/gui-click.ogg",
		volume = 1
	},
}
