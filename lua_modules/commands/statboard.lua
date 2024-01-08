local class_list		= {"ALL", "BRD", "BST", "BER", "CLR", "DRU", "ENC", "MAG", "MNK", "NEC", "PAL", "RNG", "ROG", "SHD", "SHM", "WAR", "WIZ"};
local order_list		= {"AA", "AC", "HP", "MANA"};
local class_converstion = {
	[1]		= {"BRD","8"},
	[2]		= {"BST","15"},
	[3]		= {"BER","16"},
	[4]		= {"CLR","2"},
	[5]		= {"DRU","6"},
	[6]		= {"ENC","14"},
	[7]		= {"MAG","13"},
	[8]		= {"MNK","7"},
	[9]		= {"NEC","11"},
	[10]	= {"PAL","3"},
	[11]	= {"RNG","4"},
	[12]	= {"ROG","9"},
	[13]	= {"SHD","5"},
	[14]	= {"SHM","10"},
	[15]	= {"WAR","1"},
	[16]	= {"WIZ","12"}
};

local sort_conversion	= {
	AA		= {"aa_points"},
	AC		= {"ac"},
	HP		= {"hp"},
	MANA	= {"mana"}
};

local function statboard(e)
	local valid_class	= false;
	local valid_order	= false;

	for v in pairs(class_list) do
		if e.args[1] == class_list[v] then
			valid_class = true;
			break;
		end
	end

	if valid_class then
		for v in pairs(order_list) do
			if e.args[2] == order_list[v] then
				valid_order = true;
				break;
			end
		end
	end

	local class_links = {
		ALL		= eq.say_link("#statboard ALL", true, "ALL"),
		BRD		= eq.say_link("#statboard BRD", true, "BRD"),
		BST		= eq.say_link("#statboard BST", true, "BST"),
		BER		= eq.say_link("#statboard BER", true, "BER"),
		CLR		= eq.say_link("#statboard CLR", true, "CLR"),
		DRU		= eq.say_link("#statboard DRU", true, "DRU"),
		ENC		= eq.say_link("#statboard ENC", true, "ENC"),
		MAG		= eq.say_link("#statboard MAG", true, "MAG"),
		MNK		= eq.say_link("#statboard MNK", true, "MNK"),
		NEC		= eq.say_link("#statboard NEC", true, "NEC"),
		PAL		= eq.say_link("#statboard PAL", true, "PAL"),
		RNG		= eq.say_link("#statboard RNG", true, "RNG"),
		ROG		= eq.say_link("#statboard ROG", true, "ROG"),
		SHD		= eq.say_link("#statboard SHD", true, "SHD"),
		SHM		= eq.say_link("#statboard SHM", true, "SHM"),
		WAR		= eq.say_link("#statboard WAR", true, "WAR"),
		WIZ		= eq.say_link("#statboard WIZ", true, "WIZ")
	};

	if valid_class and valid_order then
		show_stats(e,e.args[1], e.args[2]);
	elseif valid_class and not valid_order then
		local stat_links = {
			AA		= eq.say_link("#statboard " ..  e.args[1] .. " AA", true, "AA"),
			AC		= eq.say_link("#statboard " ..  e.args[1] .. " AC", true, "AC"),
			HP		= eq.say_link("#statboard " ..  e.args[1] .. " HP", true, "HP"),
			MANA	= eq.say_link("#statboard " ..  e.args[1] .. " MANA", true, "MANA")
		};

		e.self:Message(MT.White, "#statboard " .. e.args[1] .. " [" .. stat_links.AA .. "|" .. stat_links.AC .. "|" .. stat_links.HP .. "|" .. stat_links.MANA .. "] - Select Stat Order");
	elseif not valid_class then
		e.self:Message(MT.White, "#statboard [" .. class_links.ALL .. "|" .. class_links.BRD .. "|" .. class_links.BST .. "|" .. class_links.BER .. "|" .. class_links.CLR .. "|" .. class_links.DRU .. "|" .. class_links.ENC .. "|" .. class_links.MAG .. "|" .. class_links.MNK .. "] - Select Class Filter");
		e.self:Message(MT.White, "#statboard [" .. class_links.NEC .. "|" .. class_links.PAL .. "|" .. class_links.RNG .. "|" .. class_links.ROG .. "|" .. class_links.SHD .. "|" .. class_links.SHM .. "|" .. class_links.WAR .. "|" .. class_links.WIZ .. "] - Select Class Filter");
	end
end

function show_stats(client, class_filter, sort_filter)
	local mysql			= require("luasql_ext");
	local query			= "SELECT name, class, level, aa_points, ac, hp, mana FROM character_stats_record WHERE status < '50' ";
	local class_name	= nil;
	local row_number	= 0;
	local popup_table	= "";

	for v = 1, #class_converstion do
		if class_filter == class_converstion[v][1] then
			query = query .. "AND class = " .. class_converstion[v][2];
			break;
		end
	end

	for v in pairs(sort_conversion) do
		if sort_filter == v then
			query = query .. " ORDER BY " .. sort_conversion[v][1] .. " DESC LIMIT 15"
			break;
		end
	end

	popup_table = popup_table .. eq.popup_table_row(
		eq.popup_table_cell(eq.popup_color_message("white", "#")) ..
		eq.popup_table_cell(eq.popup_color_message("white", "Name")) ..
		eq.popup_table_cell(eq.popup_color_message("white", "Class")) ..
		eq.popup_table_cell(eq.popup_color_message("white", "Level")) ..
		eq.popup_table_cell(eq.popup_color_message("lime_green", "AA")) ..
		eq.popup_table_cell(eq.popup_color_message("yellow", "AC")) ..
		eq.popup_table_cell(eq.popup_color_message("red", "HP")) ..
		eq.popup_table_cell(eq.popup_color_message("cyan", "MANA"))
	);

	for name, class, level, aa_points, ac, hp, mana in mysql.rows(con,string.format(query)) do
		row_number = row_number + 1;

		for v = 1, #class_converstion do
			if class == class_converstion[v][2] then
				class_name = class_converstion[v][1];
				break;
			end
		end

		popup_table = popup_table .. eq.popup_table_row(
			eq.popup_table_cell(eq.popup_color_message("white", tostring(row_number))) ..
			eq.popup_table_cell(eq.popup_color_message("white", tostring(name))) ..
			eq.popup_table_cell(eq.popup_color_message("white", tostring(class_name))) ..
			eq.popup_table_cell(eq.popup_color_message("white", tostring(level))) ..
			eq.popup_table_cell(eq.popup_color_message("lime_green", tostring(aa_points))) ..
			eq.popup_table_cell(eq.popup_color_message("yellow", tostring(ac))) ..
			eq.popup_table_cell(eq.popup_color_message("red", tostring(hp))) ..
			eq.popup_table_cell(eq.popup_color_message("cyan", tostring(mana)))
		);
	end

	popup_table = eq.popup_table(popup_table)

	eq.popup("Stat Leaderboard (Sorted by ".. string.lower(sort_filter) ..")", popup_table)
end

return statboard;
