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
	width = 33,
	height = 33,
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 36,
			height = 36,
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
			width = 36,
			height = 36,
			x = 36,
			y = 0,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 36,
			height = 36,
			x = 36,
			y = 0,
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
	width = 33,
	height = 33,
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 36,
			height = 36,
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
			width = 36,
			height = 36,
			x = 108,
			y = 0,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 36,
			height = 36,
			x = 108,
			y = 0,
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
	width = 33,
	height = 33,
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 36,
			height = 36,
			x = 0,
			y = 36,
		}
	},
	hovered_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 36,
			height = 36,
			x = 36,
			y = 36,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 36,
			height = 36,
			x = 36,
			y = 36,
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
	width = 33,
	height = 33,
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 36,
			height = 36,
			x = 72,
			y = 36,
		}
	},
	hovered_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 36,
			height = 36,
			x = 108,
			y = 36,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 36,
			height = 36,
			x = 108,
			y = 36,
		}
	},
	left_click_sound =
	{
		filename = "__core__/sound/gui-click.ogg",
		volume = 1
	},
}

data.raw["gui-style"].default["blueprintstring_button_upgrade"] =
{
	type = "button_style",
	parent = "button_style",
	width = 33,
	height = 33,
	default_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			priority = "extra-high-no-scale",
			width = 36,
			height = 36,
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
			width = 36,
			height = 36,
			x = 144,
			y = 0,
		}
	},
	clicked_graphical_set =
	{
		type = "monolith",
		monolith_image =
		{
			filename = "__blueprint-string__/graphics/gui.png",
			width = 36,
			height = 36,
			x = 144,
			y = 0,
		}
	},
	left_click_sound =
	{
		filename = "__core__/sound/gui-click.ogg",
		volume = 1
	},
}
