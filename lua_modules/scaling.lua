-- Scale Code for LDoN
local scaling = {}

-- scaling Tables

local ac = { 0, 8, 11, 14, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 52, 59, 65, 72, 78, 85, 91, 95, 99, 103, 107, 111, 115, 119, 123, 127, 135, 142, 150, 158, 166, 173, 181, 189, 196, 204, 208, 212, 217, 221, 225, 229, 233, 237, 241, 245, 249, 253, 257, 261, 266, 270, 274, 278, 282, 286, 290, 294, 299, 303, 307, 311, 315, 319, 324, 328, 332, 336, 340, 344, 348, 352, 356, 360, 364, 368, 372, 376, 380, 384, 388, 392, 396, 400, 404, 408}
local max_hp = { 0, 11, 27, 43, 59, 75, 100, 125, 150, 175, 200, 234, 268, 302, 336, 381, 426, 471, 516, 561, 606, 651, 712, 800, 845, 895, 956, 1100, 1140, 1240, 1350, 1450, 1550, 1650, 1750, 1850, 1950, 2100, 2350, 2650, 2900, 3250, 3750, 4250, 5000, 5600, 6000, 6500, 7500, 8500, 10000, 11700, 13400, 15100, 16800, 18500, 20200, 21900, 23600, 25300, 27000, 28909, 30818, 32727, 34636, 36545, 38455, 40364, 42273, 44182, 46091, 48000, 49909, 51818, 53727, 55636, 75000, 90000, 113000, 130000, 140000, 240000, 340000, 440000, 445000, 450000, 455000, 460000, 465000, 470000, 475000}
local accuracy = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 42, 44, 46, 48, 50, 50, 50, 50, 50, 50, 53, 56, 59, 62, 65, 68, 71, 74, 77, 80, 85, 91, 96, 102, 107, 113, 118, 124, 129, 135, 140, 143, 145, 148, 150, 160, 170, 180, 190, 200, 300, 400, 410, 420, 430, 440, 450, 460, 470, 480}
local slow_mitigation = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 20, 20, 20, 20, 20, 25, 25, 25, 25, 25, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30}
local atk = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 42, 44, 46, 48, 50, 50, 50, 50, 50, 50, 53, 56, 59, 62, 65, 68, 71, 74, 77, 80, 84, 87, 91, 95, 98, 102, 105, 109, 113, 116, 120, 128, 135, 143, 150, 160, 170, 180, 190, 200, 300, 400, 410, 420, 430, 440, 450, 460, 470, 480}
local stats = { 0, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 85, 88, 91, 94, 97, 104, 110, 117, 123, 130, 137, 143, 150, 156, 163, 166, 169, 173, 176, 179, 182, 185, 188, 191, 194, 197, 200, 203, 206, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 240, 244, 247, 250, 253, 256, 259, 262, 265, 268, 271, 274, 277, 280, 283, 286, 289, 292, 295, 298, 301, 304, 307, 310, 313, 316}
local resists = { 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 16, 17, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 24, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 31, 32, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55}
local cor = { 0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8, 8, 9, 10, 10, 11, 11, 12, 12, 13, 14, 14, 15, 16, 16, 17, 18, 18, 19, 20, 22, 23, 25, 26, 27, 29, 30, 32, 33, 34, 35, 35, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 47, 48, 49, 50, 51, 51, 52, 53, 54, 55, 56, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77}
local phr = { 0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140}
local min_hit = { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 4, 6, 7, 7, 8, 8, 9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 33, 34, 34, 35, 36, 44, 51, 59, 66, 74, 78, 81, 85, 89, 93, 96, 100, 104, 107, 111, 128, 145, 162, 179, 196, 213, 230, 247, 264, 281, 298, 305, 312, 318, 325, 400, 500, 594, 650, 720, 800, 900, 1275, 1300, 1359, 1475, 1510, 1610, 1650, 1700}
local max_hit = { 0, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 27, 30, 32, 35, 37, 39, 41, 42, 44, 46, 48, 50, 52, 55, 57, 59, 61, 64, 66, 68, 74, 79, 85, 90, 96, 102, 107, 113, 118, 124, 127, 130, 133, 136, 139, 152, 165, 178, 191, 204, 231, 258, 284, 311, 338, 365, 392, 418, 445, 472, 536, 599, 663, 727, 790, 854, 917, 981, 1045, 1108, 1172, 1193, 1214, 1235, 1256, 1600, 2050, 2323, 2500, 2799, 3599, 4599, 4904, 5100, 5292, 5578, 5918, 6200, 6275, 6350}
local hp_regen = { 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 26, 29, 32, 37, 42, 50, 56, 60, 65, 75, 85, 100, 117, 134, 151, 168, 185, 202, 219, 236, 253, 270, 289, 308, 327, 346, 365, 384, 403, 422, 441, 460, 480, 499, 518, 537, 556, 750, 900, 1130, 1300, 1140, 2400, 3400, 4400, 4450, 4500, 4550, 4600, 4650, 4700, 4750}
local attack_delay = { 0, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 29, 28, 27, 25, 24, 23, 22, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 20, 20, 20, 20, 20, 20, 19, 19, 19, 19, 19, 18, 18, 18, 18, 18, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16}
local spell_scale = { 0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}
local heal_scale = { 0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}
local special_abilities = { "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "8,1", "8,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1"}

function scaling.test(e,npc,desired_level,current_level)
	eq.GM_Message(MT.LightBlue, "[DEBUG] desired_level = [".. desired_level .."]");
	eq.GM_Message(MT.LightBlue, "[DEBUG] current_level = [".. current_level .."]");
	eq.GM_Message(MT.LightBlue, "[DEBUG] Name = [".. npc:GetName() .."]");
end

-- Scale everything about the npc
function scaling.ScaleAll(e,npc,desired_level,current_level)
--	eq.GM_Message(MT.LightBlue, "[DEBUG] Name = [".. npc:GetName() .."]");
	local original_level = npc:GetLevel();

	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end


	-- Set Stats (Adding as sub functions so they can be called outside of the ScaleAll function)
	scaling.SetLevel(npc,desired_level);
	scaling.SetAccuracy(npc,desired_level);
	scaling.SetSlowMit(npc,desired_level);
	scaling.SetAttack(npc,desired_level);
	scaling.SetStrength(npc,desired_level);
	scaling.SetStamina(npc,desired_level);
	scaling.SetDexterity(npc,desired_level);
	scaling.SetAgility(npc,desired_level);
	scaling.SetIntelligence(npc,desired_level);
	scaling.SetWisdom(npc,desired_level);
	scaling.SetCharisma(npc,desired_level);
	scaling.SetMagicResist(npc,desired_level);
	scaling.SetColdResist(npc,desired_level);
	scaling.SetFireResist(npc,desired_level);
	scaling.SetPoisonResist(npc,desired_level);
	scaling.SetDiseaseResist(npc,desired_level);
	scaling.SetCorruptionResist(npc,desired_level);
	scaling.SetPhysicalResist(npc,desired_level);
	scaling.SetMinHit(npc,desired_level);
	scaling.SetMaxHit(npc,desired_level);
	scaling.SetHPRegenRate(npc,desired_level);
	scaling.SetAttackDelay(npc,desired_level);
	scaling.SetAttackSpeed(npc,desired_level);
	scaling.SetSpellScale(npc,desired_level);
	scaling.SetHealScale(npc,desired_level);
	scaling.SetSpecialAbilities(npc,desired_level);
	scaling.SetAvoidance(npc,desired_level);
	scaling.SetAC(npc,desired_level);
	scaling.SetHP(npc,desired_level);
	scaling.SetSpells(npc,desired_level);
	scaling.SetSpellEffects(npc,desired_level,original_level);
end

-- Scale Level
function scaling.SetLevel(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Level
	npc:ModifyNPCStat("level",tostring(desired_level));
end

-- 
function scaling.SetAC(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("ac",tostring(ac[desired_level]));
end

function scaling.SetHP(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("max_hp",tostring(max_hp[desired_level]));
    npc:SetHP(npc:GetMaxHP());
    npc:SetMana(npc:GetMaxMana());
end

function scaling.SetAccuracy(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("accuracy",tostring(accuracy[desired_level]));
end

function scaling.SetSlowMit(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("slow_mitigation",tostring(slow_mitigation[desired_level]));
end

function scaling.SetAttack(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("atk",tostring(atk[desired_level]));
end

function scaling.SetStrength(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("str",tostring(stats[desired_level]));
end

function scaling.SetStamina(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("sta",tostring(stats[desired_level]));
end

function scaling.SetDexterity(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("dex",tostring(stats[desired_level]));
end

function scaling.SetAgility(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("agi",tostring(stats[desired_level]));
end

function scaling.SetIntelligence(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("int",tostring(stats[desired_level]));
end

function scaling.SetWisdom(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("wis",tostring(stats[desired_level]));
end

function scaling.SetCharisma(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("cha",tostring(stats[desired_level]));
end

function scaling.SetMagicResist(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("mr",tostring(resists[desired_level]));
end

function scaling.SetColdResist(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("cr",tostring(resists[desired_level]));
end

function scaling.SetFireResist(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("fr",tostring(resists[desired_level]));
end

function scaling.SetPoisonResist(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("pr",tostring(resists[desired_level]));
end

function scaling.SetDiseaseResist(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("dr",tostring(resists[desired_level]));
end

function scaling.SetCorruptionResist(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("cor",tostring(cor[desired_level]));
end

function scaling.SetPhysicalResist(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("phr",tostring(phr[desired_level]));
end

function scaling.SetMinHit(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("min_hit",tostring(min_hit[desired_level]));
end

function scaling.SetMaxHit(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("max_hit",tostring(max_hit[desired_level]));
end

function scaling.SetHPRegenRate(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("combat_hp_regen",tostring(hp_regen[desired_level]));
end

function scaling.SetAttackDelay(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("attack_delay",tostring(attack_delay[desired_level]));
end

function scaling.SetAttackSpeed(npc,desired_level) -- TODO Why was Xackery setting this to hard 0
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("attack_speed","0");
end

function scaling.SetSpellScale(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("spell_scale",tostring(spell_scale[desired_level]));
end

function scaling.SetHealScale(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("heal_scale",tostring(heal_scale[desired_level]));
end

function scaling.SetSpecialAbilities(npc,desired_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("special_abilities",special_abilities[desired_level]);
end

function scaling.SetAvoidance(npc,desired_level) -- TODO Why was Xackery setting this to hard 0
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end
	-- Set Stats
	npc:ModifyNPCStat("avoidance","0");
end

function scaling.SetSpells(npc,desired_level)
	local spell_id = 0;
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end

	-- If NPC level is below 10, no spells
	if(desired_level < 10) then
		npc:ModifyNPCStat("npc_spells_id",tostring(spell_id));
		return;
	end

	if(npc:GetClass() == Class.CLERIC) then spell_id = 1 -- Cleric
	elseif(npc:GetClass() == Class.PALADIN) then spell_id = 8 -- Paladin
	elseif(npc:GetClass() == Class.RANGER) then spell_id = 10 -- Ranger
	elseif(npc:GetClass() == Class.SHADOWKNIGHT) then spell_id = 9 -- Shadow Knight
	elseif(npc:GetClass() == Class.DRUID) then spell_id = 7 -- Druid
	elseif(npc:GetClass() == Class.BARD) then spell_id = 11 -- Bard
	elseif(npc:GetClass() == Class.SHAMAN) then spell_id = 6 -- Rogue
	elseif(npc:GetClass() == Class.NECROMANCER) then spell_id = 3 -- Shaman
	elseif(npc:GetClass() == Class.WIZARD) then spell_id = 2 -- Necromancer
	elseif(npc:GetClass() == Class.MAGICIAN) then spell_id = 4 -- Magician
	elseif(npc:GetClass() == Class.ENCHANTER) then spell_id = 5 -- Enchanter
	elseif(npc:GetClass() == Class.BEASTLORD) then spell_id = 12 -- Beastlord
	end

	-- Set Spell Set
	npc:ModifyNPCStat("npc_spells_id",tostring(spell_id));
end

function scaling.SetSpellEffects(npc,desired_level, original_level)
	-- Sanity Check
	if(desired_level < 1 or desired_level > 70 or npc:IsClient()) then
		return;
	end

	-- If NPC level is below 10, ignore effects
	if(desired_level < 10) then
		npc:ModifyNPCStat("npc_spells_effects_id","0");
		return;
	end

	-- If NPC desired level is equal to or higher than original level keep assigned effects id
	if(desired_level >= original_level) then
		return;
	end

	-- Set effects
	npc:ModifyNPCStat("npc_spells_effects_id","0");
end

return scaling
