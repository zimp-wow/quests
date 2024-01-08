-- Scale Code for LDoN
local ldon_scaling = {};

---------------------------
-- Normal Scaling Tables --
---------------------------

local normal_ac = {
	0,
	8,
	11,
	14,
	16, -- Level 5
	19,
	22,
	25,
	28,
	31, -- Level 10
	34,
	37,
	40,
	43,
	46, -- Level 15
	52,
	59,
	65,
	72,
	78, -- Level 20
	85,
	91,
	95,
	99,
	103, -- Level 25
	107,
	111,
	115,
	119,
	123, -- Level 30
	127,
	135,
	142,
	150,
	158, -- Level 35
	166,
	173,
	181,
	189,
	196, -- Level 40
	204,
	208, 
	212, 
	217, 
	221, -- Level 45
	225, 
	229, 
	233, 
	237, 
	241, -- Level 50
	245, 
	249, 
	253, 
	257, 
	261, -- Level 55
	266, 
	270, 
	274, 
	278, 
	282, -- Level 60
	286, 
	290, 
	294, 
	299, 
	303, -- Level 65
	307, 
	311, 
	315, 
	319, 
	324, -- Level 70
	328, 
	332, 
	336, 
	340, 
	344, -- Level 75
	348, 
	352, 
	356, 
	360, 
	364  -- Level 80
};

local normal_max_hp = { 
	0, 
	11, 
	27, 
	43, 
	59, -- Level 5
	75, 
	100, 
	125, 
	150, 
	175, -- Level 10
	200, 
	234, 
	268, 
	302, 
	336, -- Level 15
	381, 
	426, 
	471, 
	516, 
	561, -- Level 20
	606, 
	651, 
	712, 
	800, 
	845, -- Level 25
	895, 
	956, 
	1100, 
	1140, 
	1240, -- Level 30
	1350, 
	1450, 
	1550, 
	1650, 
	1750, -- Level 35
	1850, 
	1950, 
	2100, 
	2350, 
	2650, -- Level 40
	2900, 
	3250, 
	3750, 
	4250, 
	5000, -- Level 45
	5600, 
	6000, 
	6500, 
	7500, 
	8500, -- Level 50
	10000, 
	10000, 
	10400, 
	11100, 
	12800, -- Level 55
	13500, 
	15200, 
	16900, 
	17600, 
	18300, -- Level 60
	19000, 
	20909, 
	21818, 
	22727, 
	23636, -- Level 65
	24545, 
	25455, 
	40364, 
	42273, 
	44182, -- Level 70
	46091, 
	48000, 
	49909, 
	51818, 
	53727, -- Level 75
	55636, 
	75000, 
	90000, 
	113000, 
	130000  -- Level 80
};

local normal_accuracy = { 
	0,
	0, 
	0, 
	0, 
	0, -- 5
	0, 
	0, 
	0, 
	0, 
	0, -- 10
	0, 
	0, 
	0, 
	0, 
	0, -- 15
	0, 
	0, 
	0, 
	0, 
	0, -- 20
	0, 
	0, 
	0, 
	0, 
	0, -- 25
	0, 
	0, 
	0, 
	0, 
	0, -- 30
	0, 
	4, 
	8, 
	12, 
	16, -- 35
	20, 
	24, 
	28, 
	32, 
	36, -- 40
	40, 
	42, 
	44, 
	46, 
	48, -- 45
	50, 
	50, 
	50, 
	50, 
	50, -- 50
	50, 
	53, 
	56, 
	59, 
	62, -- 55
	65, 
	68, 
	71, 
	74, 
	77, -- 60
	80, 
	85, 
	91, 
	96, 
	102, -- 65
	107, 
	113, 
	118, 
	124, 
	129, -- 70
	135, 
	140, 
	143, 
	145, 
	148, -- 75
	150, 
	160, 
	170, 
	180, 
	190  -- 80
};

local normal_slow_mitigation = { 
	0, 
	0, 
	0, 
	0, 
	0, -- 5
	0, 
	0, 
	0, 
	0, 
	0, -- 10
	0, 
	0, 
	0, 
	0, 
	0, -- 15
	0, 
	0, 
	0, 
	0, 
	0, -- 20
	0, 
	0, 
	0, 
	0, 
	0, -- 25
	0, 
	0, 
	0, 
	0, 
	0, -- 30
	0, 
	0, 
	0, 
	0, 
	0, -- 35
	0, 
	0, 
	0, 
	0, 
	0, -- 40
	0, 
	0, 
	0, 
	0, 
	0, -- 45
	0, 
	0, 
	0, 
	0, 
	0, -- 50
	0, 
	0, 
	0, 
	0, 
	10, -- 55
	10, 
	10, 
	10, 
	10, 
	10, -- 60
	20, 
	20, 
	20, 
	20, 
	20, -- 65
	25, 
	25, 
	25, 
	25, 
	25, -- 70
	30, 
	30, 
	30, 
	30, 
	30, -- 75
	30, 
	30, 
	30, 
	30, 
	30 -- 80 
};

local normal_atk = { 
	0, 
	0, 
	0, 
	0, 
	0, -- 5
	0, 
	0, 
	0, 
	0, 
	0, -- 10
	0, 
	0, 
	0, 
	0, 
	0, -- 15
	0, 
	0, 
	0, 
	0, 
	0, -- 20
	0, 
	0, 
	0, 
	0, 
	0, -- 25
	0, 
	0, 
	0, 
	0, 
	0, -- 30
	0, 
	4, 
	8, 
	12, 
	16, -- 35
	20, 
	24, 
	28, 
	32, 
	36, -- 40
	40, 
	42, 
	44, 
	46, 
	48, -- 45
	50, 
	50, 
	50, 
	50, 
	50, -- 50
	50, 
	53, 
	56, 
	59, 
	62, -- 55
	65, 
	68, 
	71, 
	74, 
	77, -- 60
	80, 
	84, 
	87, 
	91, 
	95, -- 65
	98, 
	102, 
	105, 
	109, 
	113, -- 70
	116, 
	120, 
	128, 
	135, 
	143, -- 75
	150, 
	160, 
	170, 
	180, 
	190  -- 80
};

local normal_stats = { 
	0, 
	8, 
	11, 
	14, 
	17, -- 5
	20, 
	23, 
	26, 
	29, 
	32, -- 10
	35, 
	38, 
	42, 
	45, 
	48, -- 15
	51, 
	54, 
	57, 
	60, 
	63, -- 20
	66, 
	69, 
	72, 
	75, 
	78, -- 25
	81, 
	85, 
	88, 
	91, 
	94, -- 30
	97, 
	104, 
	110, 
	117, 
	123, -- 35
	130, 
	137, 
	143, 
	150, 
	156, -- 40
	163, 
	166, 
	169, 
	173, 
	176, -- 45
	179, 
	182, 
	185, 
	188, 
	191, -- 50
	194, 
	197, 
	200, 
	203, 
	206, -- 55
	210, 
	213, 
	216, 
	219, 
	222, -- 60
	225, 
	228, 
	231, 
	234, 
	237, -- 65
	240, 
	244, 
	247, 
	250, 
	253, -- 70
	256, 
	259, 
	262, 
	265, 
	268, -- 75
	271, 
	274, 
	277, 
	280, 
	283  --80
};

local normal_resists = { 
	0, 
	1, 
	1, 
	2, 
	2, -- 5
	2, 
	2, 
	3, 
	3, 
	4, -- 10
	4, 
	5, 
	5, 
	6, 
	6, -- 15
	6, 
	7, 
	7, 
	7, 
	7, -- 20
	8, 
	8, 
	8, 
	9, 
	9, -- 25
	10, 
	10, 
	11, 
	11, 
	12, -- 30
	12, 
	13, 
	14, 
	15, 
	16, -- 35
	17, 
	17, 
	18, 
	19, 
	20, -- 40
	21, 
	22, 
	22, 
	23, 
	23, -- 45
	24, 
	24, 
	25, 
	25, 
	26, -- 50
	26, 
	27, 
	27, 
	28, 
	28, -- 55
	29, 
	29, 
	30, 
	30, 
	31, -- 60
	31, 
	32, 
	32, 
	33, 
	33, -- 65
	34, 
	34, 
	35, 
	35, 
	36, -- 70
	36, 
	37, 
	38, 
	39, 
	39, -- 75
	40, 
	41, 
	42, 
	43, 
	44  -- 80
};

local normal_cor = { 
	0, 
	1, 
	2, 
	2, 
	3, -- 5
	3, 
	4, 
	4, 
	5, 
	5, -- 10
	6, 
	7, 
	8, 
	8, 
	9, -- 15
	10, 
	10, 
	11, 
	11, 
	12, -- 20
	12, 
	13, 
	14, 
	14, 
	15, -- 25
	16, 
	16, 
	17, 
	18, 
	18, -- 30
	19, 
	20, 
	22, 
	23, 
	25, -- 35
	26, 
	27, 
	29, 
	30, 
	32, -- 40
	33, 
	34, 
	35, 
	35, 
	36, -- 45
	37, 
	38, 
	39, 
	39, 
	40, -- 50
	41, 
	42, 
	43, 
	43, 
	44, -- 55
	45, 
	46, 
	47, 
	47, 
	48, -- 60
	49, 
	50, 
	51, 
	51, 
	52, -- 65
	53, 
	54, 
	55, 
	56, 
	56, -- 70
	57, 
	58, 
	59, 
	60, 
	61, -- 75
	62, 
	63, 
	64, 
	65, 
	66  -- 80
};

local normal_phr = { 
	0, 
	10, 
	10, 
	10, 
	10, -- 5
	10, 
	10, 
	10, 
	10, 
	10, -- 10
	10, 
	10, 
	10, 
	10, 
	10, -- 15
	10, 
	10, 
	10, 
	10, 
	10, -- 20
	10, 
	10, 
	10, 
	10, 
	10, -- 25
	10, 
	10, 
	10, 
	10, 
	10, -- 30
	10, 
	10, 
	10, 
	10, 
	10, -- 35
	10, 
	10, 
	10, 
	10, 
	10, -- 40
	10, 
	10, 
	10, 
	10, 
	10, -- 45
	10, 
	10, 
	10, 
	10, 
	10, -- 50
	10, 
	11, 
	12, 
	13, 
	14, -- 55
	15, 
	16, 
	17, 
	18, 
	19, -- 60
	20, 
	24, 
	28, 
	32, 
	36, -- 65
	40, 
	44, 
	48, 
	52, 
	56, -- 70
	60, 
	64, 
	68, 
	72, 
	76, -- 75
	80, 
	84, 
	88, 
	92, 
	96 -- 80
};

local normal_min_hit = { 
	0, 
	1, 
	1, 
	1, 
	1, -- 5
	1, 
	1, 
	1, 
	1, 
	1, -- 10
	1, 
	3, 
	4, 
	6, 
	7, -- 15
	7, 
	8, 
	8, 
	9, 
	9, -- 20
	10, 
	10, 
	10, 
	10, 
	11, -- 25
	11, 
	11, 
	11, 
	12, 
	12, -- 30
	12, 
	14, 
	16, 
	18, 
	20, -- 35
	22, 
	24, 
	26, 
	28, 
	30, -- 40
	32, 
	33, 
	34, 
	34, 
	35, -- 45
	36, 
	44, 
	51, 
	59, 
	66, -- 50
	74, 
	78, 
	81, 
	85, 
	89, -- 55
	93, 
	96, 
	100, 
	104, 
	107, -- 60
	111, 
	128, 
	145, 
	162, 
	179, -- 65
	196, 
	213, 
	230, 
	247, 
	264, -- 70
	281, 
	298, 
	305, 
	312, 
	318, -- 75
	325, 
	400, 
	500, 
	594, 
	650  -- 80
};

local normal_max_hit = { 
	0, 
	4,
	6, 
	8, 
	10, -- 5 
	12, 
	14, 
	16, 
	18, 
	20, -- 10
	22, 
	24, 
	27, 
	30, 
	32, -- 15
	35, 
	37, 
	39, 
	41, 
	42, -- 20
	44, 
	46, 
	48, 
	50, 
	52, -- 25
	55, 
	57, 
	59, 
	61, 
	64, -- 30
	66, 
	68, 
	74, 
	79, 
	85, -- 35
	90, 
	96, 
	102, 
	107, 
	109,-- 40
	113, 
	118, 
	124, 
	127, 
	130, -- 45
	133, 
	136, 
	139, 
	142,
	152, -- 50
	165, 
	178, 
	191, 
	204, 
	212, -- 55
	231, 
	258, 
	284, 
	311, 
	338, -- 60
	365, 
	392, 
	418, 
	445, 
	472, -- 65
	536, 
	599, 
	663, 
	727, 
	790, -- 70
	854, 
	917, 
	981, 
	1045, 
	1108, -- 75
	1172, 
	1193, 
	1214, 
	1235, 
	1256  -- 80
};

local normal_hp_regen = { 
	0, 
	1, 
	1, 
	1, 
	1, -- 5
	1, 
	1, 
	2, 
	2, 
	2, -- 10
	2, 
	2, 
	3, 
	3, 
	3, -- 15
	4, 
	4, 
	5, 
	5, 
	6, -- 20
	6, 
	7, 
	7, 
	8, 
	8, -- 25
	9, 
	10, 
	10, 
	11, 
	12, -- 30 
	13, 
	13, 
	13, 
	13, 
	13, -- 35
	14, 
	14, 
	15, 
	15, 
	16, -- 40
	17, 
	17, 
	18, 
	19, 
	20, -- 45
	20, 
	21, 
	22, 
	23, 
	24, -- 50
	24, 
	24, 
	24, 
	24, 
	25, -- 55
	26, 
	27, 
	28, 
	29, 
	30, -- 60
	31, 
	32, 
	33, 
	34, 
	35, -- 65
	36, 
	37, 
	38, 
	39, 
	40, -- 70
	41, 
	42, 
	43, 
	44, 
	45, -- 75
	46, 
	47, 
	48, 
	49, 
	50  -- 80 
};

local normal_attack_delay = { 
	0, 
	30, 
	30, 
	30, 
	30, -- 5
	30, 
	30, 
	30, 
	30, 
	30, -- 10
	30, 
	30, 
	30, 
	30, 
	30, -- 15
	30, 
	30, 
	30, 
	30, 
	30, -- 20
	30, 
	30, 
	30, 
	30, 
	30, -- 25
	30, 
	30, 
	30, 
	30, 
	30, -- 30
	30, 
	30, 
	30, 
	29, 
	28, -- 35
	27, 
	25, 
	24, 
	23, 
	22, -- 40
	21, 
	21, 
	21, 
	21, 
	21, -- 45
	21, 
	21, 
	21, 
	21, 
	21, -- 50
	21, 
	20, 
	20, 
	20, 
	20, -- 55
	20, 
	20, 
	19, 
	19, 
	19, -- 60
	19, 
	19, 
	18, 
	18, 
	18, -- 65
	18, 
	18, 
	17, 
	17, 
	17, -- 70
	17, 
	17, 
	17, 
	17, 
	17, -- 75
	17, 
	17, 
	17, 
	17, 
	17  -- 80
};

local normal_spell_scale = { 
	0, 
	100, 
	100, 
	100, 
	100, -- 5
	100, 
	100, 
	100, 
	100, 
	100, -- 10
	100, 
	100, 
	100, 
	100, 
	100, -- 15
	100, 
	100, 
	100, 
	100, 
	100, -- 20
	100, 
	100, 
	100, 
	100, 
	100, -- 25
	100, 
	100, 
	100, 
	100, 
	100, -- 30
	100, 
	100, 
	100, 
	100, 
	100, -- 35
	100, 
	100, 
	100, 
	100, 
	100, -- 40
	100, 
	100, 
	100, 
	100, 
	100, -- 45
	100, 
	100, 
	100, 
	100, 
	100, -- 50
	100, 
	100, 
	100, 
	100, 
	100, -- 55
	100, 
	100, 
	100, 
	100, 
	100, -- 60
	100, 
	100, 
	100, 
	100, 
	100, -- 65
	100, 
	100, 
	100, 
	100, 
	100, -- 70
	100, 
	100, 
	100, 
	100, 
	100, -- 75
	100, 
	100, 
	100, 
	100, 
	100  -- 80
};

local normal_heal_scale = { 
	0, 
	100, 
	100, 
	100, 
	100, -- 5
	100, 
	100, 
	100, 
	100, 
	100, -- 10
	100, 
	100, 
	100, 
	100, 
	100, -- 15
	100, 
	100, 
	100, 
	100, 
	100, -- 20
	100, 
	100, 
	100, 
	100, 
	100, -- 25
	100, 
	100, 
	100, 
	100, 
	100, -- 30
	100, 
	100, 
	100, 
	100, 
	100, -- 35
	100, 
	100, 
	100, 
	100, 
	100, -- 40
	100, 
	100, 
	100, 
	100, 
	100, -- 45
	100, 
	100, 
	100, 
	100, 
	100, -- 50
	100, 
	100, 
	100, 
	100, 
	100, -- 55
	100, 
	100, 
	100, 
	100, 
	100, -- 60
	100, 
	100, 
	100, 
	100, 
	100, -- 65
	100, 
	100, 
	100, 
	100, 
	100, -- 70
	100, 
	100, 
	100, 
	100, 
	100, -- 75
	100, 
	100, 
	100, 
	100, 
	100  -- 80
};

local normal_special_abilities = { 
	"", 
	"", 
	"", 
	"", 
	"", -- 5
	"", 
	"", 
	"", 
	"", 
	"", -- 10
	"", 
	"", 
	"", 
	"", 
	"", -- 15
	"", 
	"", 
	"", 
	"", 
	"", -- 20
	"", 
	"", 
	"", 
	"", 
	"", -- 25
	"", 
	"", 
	"", 
	"", 
	"", -- 30
	"", 
	"", 
	"", 
	"", 
	"", -- 35
	"", 
	"", 
	"", 
	"", 
	"", -- 40
	"", 
	"", 
	"", 
	"", 
	"", -- 45
	"", 
	"", 
	"", 
	"", 
	"", -- 50
	"", 
	"", 
	"", 
	"", 
	"", -- 55
	"", 
	"", 
	"", 
	"", 
	"", -- 60
	"", 
	"14,1", 
	"14,1", 
	"14,1", 
	"14,1", -- 65
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", -- 70
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", -- 75
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1"  -- 80
};

-------------------------
-- Hard Scaling Tables --
-------------------------

local hard_ac = {
	0,
	8,
	11,
	14,
	16, -- Level 5
	19,
	22,
	25,
	28,
	31, -- Level 10
	34,
	37,
	40,
	43,
	46, -- Level 15
	52,
	59,
	65,
	72,
	78, -- Level 20
	85,
	91,
	95,
	99,
	103, -- Level 25
	107,
	111,
	115,
	119,
	123, -- Level 30
	127,
	135,
	142,
	150,
	158, -- Level 35
	166,
	173,
	181,
	189,
	196, -- Level 40
	204,
	208, 
	212, 
	217, 
	221, -- Level 45
	225, 
	229, 
	233, 
	237, 
	241, -- Level 50
	245, 
	249, 
	253, 
	257, 
	261, -- Level 55
	266, 
	270, 
	274, 
	278, 
	282, -- Level 60
	286, 
	290, 
	294, 
	299, 
	303, -- Level 65
	307, 
	311, 
	315, 
	319, 
	324, -- Level 70
	328, 
	332, 
	336, 
	340, 
	344, -- Level 75
	348, 
	352, 
	356, 
	360, 
	364  -- Level 80
};

local hard_max_hp = { 
	0, 
	7,
	11,
	20, 
	27, -- 5 
	43,
	50, 
	59, 
	75, 
	100, -- 10
	125, 
	150, 
	175, 
	200, 
	234, -- 15
	248, 
	268, 
	302, 
	336, 
	381, -- 20
	400, 
	426, 
	471, 
	516, 
	561, -- 25
	606,
	638, 
	651, 
	712, 
	800, -- 30
	845, 
	895, 
	956, 
	1100, 
	1140, -- 35
	1240, 
	1350, 
	1450, 
	1550, 
	1650, -- 40
	1750, 
	1850, 
	1950, 
	2100, 
	2350, -- 45
	2650, 
	2900, 
	3250, 
	3750, 
	4250, -- 50
	5000, 
	5600, 
	6000, 
	6500, 
	7500, -- 55
	8500, 
	10000, 
	11700, 
	13400, 
	15100, -- 60
	16800, 
	18500, 
	20200, 
	21900, 
	23600, -- 65
	25300, 
	27000, 
	28909, 
	30818, 
	32727, -- 70
	34636, 
	36545, 
	38455, 
	40364, 
	42273, -- 75
	44182,
	46091, 
	48000, 
	49909, 
	51818  -- 80
};

local hard_accuracy = { 
	0,
	0, 
	0, 
	0, 
	0, -- 5
	0, 
	0, 
	0, 
	0, 
	0, -- 10
	0, 
	0, 
	0, 
	0, 
	0, -- 15
	0, 
	0, 
	0, 
	0, 
	0, -- 20
	0, 
	0, 
	0, 
	0, 
	0, -- 25
	0, 
	0, 
	0, 
	0, 
	0, -- 30
	0, 
	4, 
	8, 
	12, 
	16, -- 35
	20, 
	24, 
	28, 
	32, 
	36, -- 40
	40, 
	42, 
	44, 
	46, 
	48, -- 45
	50, 
	50, 
	50, 
	50, 
	50, -- 50
	50, 
	53, 
	56, 
	59, 
	62, -- 55
	65, 
	68, 
	71, 
	74, 
	77, -- 60
	80, 
	85, 
	91, 
	96, 
	102, -- 65
	107, 
	113, 
	118, 
	124, 
	129, -- 70
	135, 
	140, 
	143, 
	145, 
	148, -- 75
	150, 
	160, 
	170, 
	180, 
	190  -- 80
};

local hard_slow_mitigation = { 
	0, 
	0, 
	0, 
	0, 
	0, -- 5
	0, 
	0, 
	0, 
	0, 
	0, -- 10
	0, 
	0, 
	0, 
	0, 
	0, -- 15
	0, 
	0, 
	0, 
	0, 
	0, -- 20
	0, 
	0, 
	0, 
	0, 
	0, -- 25
	0, 
	0, 
	0, 
	0, 
	0, -- 30
	0, 
	0, 
	0, 
	0, 
	0, -- 35
	0, 
	0, 
	0, 
	0, 
	0, -- 40
	0, 
	0, 
	0, 
	0, 
	0, -- 45
	0, 
	0, 
	0, 
	0, 
	0, -- 50
	0, 
	0, 
	0, 
	0, 
	10, -- 55
	10, 
	10, 
	10, 
	10, 
	10, -- 60
	20, 
	20, 
	20, 
	20, 
	20, -- 65
	25, 
	25, 
	25, 
	25, 
	25, -- 70
	30, 
	30, 
	30, 
	30, 
	30, -- 75
	30, 
	30, 
	30, 
	30, 
	30 -- 80 
};

local hard_atk = { 
	0, 
	0, 
	0, 
	0, 
	0, -- 5
	0, 
	0, 
	0, 
	0, 
	0, -- 10
	0, 
	0, 
	0, 
	0, 
	0, -- 15
	0, 
	0, 
	0, 
	0, 
	0, -- 20
	0, 
	0, 
	0, 
	0, 
	0, -- 25
	0, 
	0, 
	0, 
	0, 
	0, -- 30
	0, 
	4, 
	8, 
	12, 
	16, -- 35
	20, 
	24, 
	28, 
	32, 
	36, -- 40
	40, 
	42, 
	44, 
	46, 
	48, -- 45
	50, 
	50, 
	50, 
	50, 
	50, -- 50
	50, 
	53, 
	56, 
	59, 
	62, -- 55
	65, 
	68, 
	71, 
	74, 
	77, -- 60
	80, 
	84, 
	87, 
	91, 
	95, -- 65
	98, 
	102, 
	105, 
	109, 
	113, -- 70
	116, 
	120, 
	128, 
	135, 
	143, -- 75
	150, 
	160, 
	170, 
	180, 
	190  -- 80
};

local hard_stats = { 
	0, 
	8, 
	11, 
	14, 
	17, -- 5
	20, 
	23, 
	26, 
	29, 
	32, -- 10
	35, 
	38, 
	42, 
	45, 
	48, -- 15
	51, 
	54, 
	57, 
	60, 
	63, -- 20
	66, 
	69, 
	72, 
	75, 
	78, -- 25
	81, 
	85, 
	88, 
	91, 
	94, -- 30
	97, 
	104, 
	110, 
	117, 
	123, -- 35
	130, 
	137, 
	143, 
	150, 
	156, -- 40
	163, 
	166, 
	169, 
	173, 
	176, -- 45
	179, 
	182, 
	185, 
	188, 
	191, -- 50
	194, 
	197, 
	200, 
	203, 
	206, -- 55
	210, 
	213, 
	216, 
	219, 
	222, -- 60
	225, 
	228, 
	231, 
	234, 
	237, -- 65
	240, 
	244, 
	247, 
	250, 
	253, -- 70
	256, 
	259, 
	262, 
	265, 
	268, -- 75
	271, 
	274, 
	277, 
	280, 
	283  --80
};

local hard_resists = { 
	0, 
	1, 
	1, 
	2, 
	2, -- 5
	2, 
	2, 
	3, 
	3, 
	4, -- 10
	4, 
	5, 
	5, 
	6, 
	6, -- 15
	6, 
	7, 
	7, 
	7, 
	7, -- 20
	8, 
	8, 
	8, 
	9, 
	9, -- 25
	10, 
	10, 
	11, 
	11, 
	12, -- 30
	12, 
	13, 
	14, 
	15, 
	16, -- 35
	17, 
	17, 
	18, 
	19, 
	20, -- 40
	21, 
	22, 
	22, 
	23, 
	23, -- 45
	24, 
	24, 
	25, 
	25, 
	26, -- 50
	26, 
	27, 
	27, 
	28, 
	28, -- 55
	29, 
	29, 
	30, 
	30, 
	31, -- 60
	31, 
	32, 
	32, 
	33, 
	33, -- 65
	34, 
	34, 
	35, 
	35, 
	36, -- 70
	36, 
	37, 
	38, 
	39, 
	39, -- 75
	40, 
	41, 
	42, 
	43, 
	44  -- 80
};

local hard_cor = { 
	0, 
	1, 
	2, 
	2, 
	3, -- 5
	3, 
	4, 
	4, 
	5, 
	5, -- 10
	6, 
	7, 
	8, 
	8, 
	9, -- 15
	10, 
	10, 
	11, 
	11, 
	12, -- 20
	12, 
	13, 
	14, 
	14, 
	15, -- 25
	16, 
	16, 
	17, 
	18, 
	18, -- 30
	19, 
	20, 
	22, 
	23, 
	25, -- 35
	26, 
	27, 
	29, 
	30, 
	32, -- 40
	33, 
	34, 
	35, 
	35, 
	36, -- 45
	37, 
	38, 
	39, 
	39, 
	40, -- 50
	41, 
	42, 
	43, 
	43, 
	44, -- 55
	45, 
	46, 
	47, 
	47, 
	48, -- 60
	49, 
	50, 
	51, 
	51, 
	52, -- 65
	53, 
	54, 
	55, 
	56, 
	56, -- 70
	57, 
	58, 
	59, 
	60, 
	61, -- 75
	62, 
	63, 
	64, 
	65, 
	66  -- 80
};

local hard_phr = { 
	0, 
	10, 
	10, 
	10, 
	10, -- 5
	10, 
	10, 
	10, 
	10, 
	10, -- 10
	10, 
	10, 
	10, 
	10, 
	10, -- 15
	10, 
	10, 
	10, 
	10, 
	10, -- 20
	10, 
	10, 
	10, 
	10, 
	10, -- 25
	10, 
	10, 
	10, 
	10, 
	10, -- 30
	10, 
	10, 
	10, 
	10, 
	10, -- 35
	10, 
	10, 
	10, 
	10, 
	10, -- 40
	10, 
	10, 
	10, 
	10, 
	10, -- 45
	10, 
	10, 
	10, 
	10, 
	10, -- 50
	10, 
	11, 
	12, 
	13, 
	14, -- 55
	15, 
	16, 
	17, 
	18, 
	19, -- 60
	20, 
	24, 
	28, 
	32, 
	36, -- 65
	40, 
	44, 
	48, 
	52, 
	56, -- 70
	60, 
	64, 
	68, 
	72, 
	76, -- 75
	80, 
	84, 
	88, 
	92, 
	96 -- 80
};

local hard_min_hit = { 
	0, 
	1, 
	1, 
	1, 
	1, -- 5
	1, 
	1, 
	1, 
	1, 
	1, -- 10
	1, 
	3, 
	4, 
	6, 
	7, -- 15
	7, 
	8, 
	8, 
	9, 
	9, -- 20
	10, 
	10, 
	10, 
	10, 
	11, -- 25
	11, 
	11, 
	11, 
	12, 
	12, -- 30
	12, 
	14, 
	16, 
	18, 
	20, -- 35
	22, 
	24, 
	26, 
	28, 
	30, -- 40
	32, 
	33, 
	34, 
	34, 
	35, -- 45
	36, 
	44, 
	51, 
	59, 
	66, -- 50
	74, 
	78, 
	81, 
	85, 
	89, -- 55
	93, 
	96, 
	100, 
	104, 
	107, -- 60
	111, 
	128, 
	145, 
	162, 
	179, -- 65
	196, 
	213, 
	230, 
	247, 
	264, -- 70
	281, 
	298, 
	305, 
	312, 
	318, -- 75
	325, 
	400, 
	500, 
	594, 
	650  -- 80
};

local hard_max_hit = { 
	0, 
	6, 
	8, 
	10, 
	12, -- 5 
	14, 
	16, 
	18, 
	20, 
	22, -- 10
	24, 
	27, 
	30, 
	32, 
	35, -- 15
	37, 
	39, 
	41, 
	42, 
	44, -- 20
	46, 
	48, 
	50, 
	52, 
	55, -- 25
	57, 
	59, 
	61, 
	64, 
	66, -- 30
	68, 
	74, 
	79, 
	85, 
	90, -- 35
	96, 
	102, 
	107, 
	113, 
	118, -- 40
	124, 
	127, 
	130, 
	133, 
	136, -- 45
	139, 
	152, 
	165, 
	178, 
	191, -- 50
	204, 
	231, 
	258, 
	284, 
	311, -- 55
	338, 
	365, 
	392, 
	418, 
	445, -- 60
	472, 
	536, 
	599, 
	663, 
	727, -- 65
	790, 
	854, 
	917, 
	981, 
	1045, -- 70
	1108, 
	1172, 
	1193, 
	1214, 
	1235, -- 75
	1256, 
	1600, 
	2050, 
	2323, 
	2500  -- 80
};

local hard_hp_regen = { 
	0, 
	1, 
	1, 
	1, 
	1, -- 5
	1, 
	1, 
	2, 
	2, 
	2, -- 10
	2, 
	2, 
	3, 
	3, 
	3, -- 15
	4, 
	4, 
	5, 
	5, 
	6, -- 20
	6, 
	7, 
	7, 
	8, 
	8, -- 25
	9, 
	10, 
	10, 
	11, 
	12, -- 30 
	13, 
	14, 
	15, 
	16, 
	17, -- 35
	18, 
	19, 
	21, 
	23, 
	26, -- 40
	27, 
	28, 
	29, 
	30, 
	31, -- 45
	32, 
	33, 
	34, 
	35, 
	36, -- 50
	37, 
	38, 
	39, 
	40, 
	40, -- 55
	41, 
	42, 
	43, 
	44, 
	45, -- 60
	46, 
	47, 
	48, 
	49, 
	50, -- 65
	51, 
	52, 
	53, 
	54, 
	55, -- 70
	56, 
	57, 
	58, 
	59, 
	60, -- 75
	61, 
	62, 
	63, 
	64, 
	65  -- 80 
};

local hard_attack_delay = { 
	0, 
	30, 
	30, 
	30, 
	30, -- 5
	30, 
	30, 
	30, 
	30, 
	30, -- 10
	30, 
	30, 
	30, 
	30, 
	30, -- 15
	30, 
	30, 
	30, 
	30, 
	30, -- 20
	30, 
	30, 
	30, 
	30, 
	30, -- 25
	30, 
	30, 
	30, 
	30, 
	30, -- 30
	30, 
	30, 
	30, 
	29, 
	28, -- 35
	27, 
	25, 
	24, 
	23, 
	22, -- 40
	21, 
	21, 
	21, 
	21, 
	21, -- 45
	21, 
	21, 
	21, 
	21, 
	21, -- 50
	21, 
	20, 
	20, 
	20, 
	20, -- 55
	20, 
	20, 
	19, 
	19, 
	19, -- 60
	19, 
	19, 
	18, 
	18, 
	18, -- 65
	18, 
	18, 
	17, 
	17, 
	17, -- 70
	17, 
	17, 
	17, 
	17, 
	17, -- 75
	17, 
	17, 
	17, 
	17, 
	17  -- 80
};

local hard_spell_scale = { 
	0, 
	100, 
	100, 
	100, 
	100, -- 5
	100, 
	100, 
	100, 
	100, 
	100, -- 10
	100, 
	100, 
	100, 
	100, 
	100, -- 15
	100, 
	100, 
	100, 
	100, 
	100, -- 20
	100, 
	100, 
	100, 
	100, 
	100, -- 25
	100, 
	100, 
	100, 
	100, 
	100, -- 30
	100, 
	100, 
	100, 
	100, 
	100, -- 35
	100, 
	100, 
	100, 
	100, 
	100, -- 40
	100, 
	100, 
	100, 
	100, 
	100, -- 45
	100, 
	100, 
	100, 
	100, 
	100, -- 50
	100, 
	100, 
	100, 
	100, 
	100, -- 55
	100, 
	100, 
	100, 
	100, 
	100, -- 60
	100, 
	100, 
	100, 
	100, 
	100, -- 65
	100, 
	100, 
	100, 
	100, 
	100, -- 70
	100, 
	100, 
	100, 
	100, 
	100, -- 75
	100, 
	100, 
	100, 
	100, 
	100  -- 80
};

local hard_heal_scale = { 
	0, 
	100, 
	100, 
	100, 
	100, -- 5
	100, 
	100, 
	100, 
	100, 
	100, -- 10
	100, 
	100, 
	100, 
	100, 
	100, -- 15
	100, 
	100, 
	100, 
	100, 
	100, -- 20
	100, 
	100, 
	100, 
	100, 
	100, -- 25
	100, 
	100, 
	100, 
	100, 
	100, -- 30
	100, 
	100, 
	100, 
	100, 
	100, -- 35
	100, 
	100, 
	100, 
	100, 
	100, -- 40
	100, 
	100, 
	100, 
	100, 
	100, -- 45
	100, 
	100, 
	100, 
	100, 
	100, -- 50
	100, 
	100, 
	100, 
	100, 
	100, -- 55
	100, 
	100, 
	100, 
	100, 
	100, -- 60
	100, 
	100, 
	100, 
	100, 
	100, -- 65
	100, 
	100, 
	100, 
	100, 
	100, -- 70
	100, 
	100, 
	100, 
	100, 
	100, -- 75
	100, 
	100, 
	100, 
	100, 
	100  -- 80
};

local hard_special_abilities = { 
	"", 
	"", 
	"", 
	"", 
	"", -- 5
	"", 
	"", 
	"", 
	"", 
	"", -- 10
	"", 
	"", 
	"", 
	"", 
	"", -- 15
	"", 
	"", 
	"", 
	"", 
	"", -- 20
	"", 
	"", 
	"", 
	"", 
	"", -- 25
	"", 
	"", 
	"", 
	"", 
	"", -- 30
	"", 
	"", 
	"", 
	"", 
	"", -- 35
	"", 
	"", 
	"", 
	"", 
	"", -- 40
	"", 
	"", 
	"", 
	"", 
	"", -- 45
	"", 
	"", 
	"", 
	"", 
	"", -- 50
	"", 
	"", 
	"", 
	"", 
	"", -- 55
	"", 
	"", 
	"", 
	"", 
	"", -- 60
	"", 
	"14,1", 
	"14,1^6,1", 
	"14,1^6,1", 
	"14,1^6,1", -- 65
	"14,1^6,1", 
	"14,1^6,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", -- 70
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", -- 75
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1", 
	"14,1^8,1"  -- 80
};

function ldon_scaling.test(e,npc,desired_level,current_level)
	eq.GM_Message(MT.LightBlue, "[DEBUG] desired_level = [".. desired_level .."]");
	eq.GM_Message(MT.LightBlue, "[DEBUG] current_level = [".. current_level .."]");
	eq.GM_Message(MT.LightBlue, "[DEBUG] Name = [".. npc:GetName() .."]");
end

-- Scale everything about the npc
-- NPC = Entity
-- desired_level = What to scale to
-- current_level = what the mob was prior to scaling
-- difficulty = 1/Normal - 2/Hard
-- isboss = 0/Not a boss - 1/Is a Boss
-- charmable = 0/Not Charmable - 1/Charmable - 2/Charmable and Snareable
function ldon_scaling.ScaleAll(e,npc,desired_level,current_level,difficulty,isboss,charmable)
	local original_level = npc:GetLevel();

	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end

	-- 1 = Normal
	-- 2 = Hard
	if difficulty < 1 or difficulty > 2 then
		return;
	end


	-- Set Stats (Adding as sub functions so they can be called outside of the ScaleAll function)
	ldon_scaling.SetLevel(npc,desired_level);
	ldon_scaling.SetAccuracy(npc,desired_level,difficulty,isboss);
	ldon_scaling.SetSlowMit(npc,desired_level,difficulty);
	ldon_scaling.SetAttack(npc,desired_level,difficulty);
	ldon_scaling.SetStrength(npc,desired_level,difficulty);
	ldon_scaling.SetStamina(npc,desired_level,difficulty);
	ldon_scaling.SetDexterity(npc,desired_level,difficulty);
	ldon_scaling.SetAgility(npc,desired_level,difficulty);
	ldon_scaling.SetIntelligence(npc,desired_level,difficulty);
	ldon_scaling.SetWisdom(npc,desired_level,difficulty);
	ldon_scaling.SetCharisma(npc,desired_level,difficulty);
	ldon_scaling.SetMagicResist(npc,desired_level,difficulty);
	ldon_scaling.SetColdResist(npc,desired_level,difficulty);
	ldon_scaling.SetFireResist(npc,desired_level,difficulty);
	ldon_scaling.SetPoisonResist(npc,desired_level,difficulty);
	ldon_scaling.SetDiseaseResist(npc,desired_level,difficulty);
	ldon_scaling.SetCorruptionResist(npc,desired_level,difficulty);
	ldon_scaling.SetPhysicalResist(npc,desired_level,difficulty);
	ldon_scaling.SetMinHit(npc,desired_level,difficulty);
	ldon_scaling.SetMaxHit(npc,desired_level,difficulty);
	ldon_scaling.SetHPRegenRate(npc,desired_level,difficulty);
	ldon_scaling.SetAttackDelay(npc,desired_level,difficulty);
	ldon_scaling.SetAttackSpeed(npc,desired_level,difficulty);
	ldon_scaling.SetSpellScale(npc,desired_level,difficulty);
	ldon_scaling.SetHealScale(npc,desired_level,difficulty);
	ldon_scaling.SetSpecialAbilities(npc,desired_level,difficulty,isboss,charmable);
	ldon_scaling.SetAvoidance(npc,desired_level,difficulty);
	ldon_scaling.SetAC(npc,desired_level,difficulty);
	ldon_scaling.SetHP(npc,desired_level,difficulty);
	ldon_scaling.SetSpells(npc,desired_level,difficulty);
	ldon_scaling.SetSpellEffects(npc,desired_level,original_level,difficulty);
end

-- Scale Level
function ldon_scaling.SetLevel(npc,desired_level)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	-- Set Level
	npc:ModifyNPCStat("level",tostring(desired_level));
end

-- 
function ldon_scaling.SetAC(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("ac",tostring(normal_ac[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("ac",tostring(hard_ac[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetHP(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("max_hp",tostring(normal_max_hp[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("max_hp",tostring(hard_max_hp[desired_level]));
	else
		return;
	end

	npc:SetHP(npc:GetMaxHP());
    npc:SetMana(npc:GetMaxMana());
end

function ldon_scaling.SetAccuracy(npc,desired_level,difficulty,isboss)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("accuracy","0");
	elseif difficulty == 2 then
		npc:ModifyNPCStat("accuracy","0");
	else
		return;
	end

	if isboss == 1 then
		npc:ModifyNPCStat("accuracy",tostring(normal_accuracy[desired_level]));
	end
end

function ldon_scaling.SetSlowMit(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("slow_mitigation",tostring(normal_slow_mitigation[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("slow_mitigation",tostring(hard_slow_mitigation[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetAttack(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("atk",tostring(normal_atk[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("atk",tostring(hard_atk[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetStrength(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("str",tostring(normal_stats[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("str",tostring(hard_stats[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetStamina(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("sta",tostring(normal_stats[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("sta",tostring(hard_stats[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetDexterity(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("dex",tostring(normal_stats[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("dex",tostring(hard_stats[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetAgility(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("agi",tostring(normal_stats[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("agi",tostring(hard_stats[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetIntelligence(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("int",tostring(normal_stats[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("int",tostring(hard_stats[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetWisdom(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("wis",tostring(normal_stats[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("wis",tostring(hard_stats[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetCharisma(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("cha",tostring(normal_stats[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("cha",tostring(hard_stats[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetMagicResist(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("mr",tostring(normal_resists[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("mr",tostring(hard_resists[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetColdResist(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("cr",tostring(normal_resists[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("cr",tostring(hard_resists[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetFireResist(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("fr",tostring(normal_resists[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("fr",tostring(hard_resists[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetPoisonResist(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("pr",tostring(normal_resists[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("pr",tostring(hard_resists[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetDiseaseResist(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("dr",tostring(normal_resists[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("dr",tostring(hard_resists[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetCorruptionResist(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("cor",tostring(normal_cor[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("cor",tostring(hard_cor[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetPhysicalResist(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("phr",tostring(normal_phr[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("phr",tostring(hard_phr[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetMinHit(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("min_hit",tostring(normal_min_hit[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("min_hit",tostring(hard_min_hit[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetMaxHit(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("max_hit",tostring(normal_max_hit[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("max_hit",tostring(hard_max_hit[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetHPRegenRate(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("combat_hp_regen",tostring(normal_hp_regen[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("combat_hp_regen",tostring(hard_hp_regen[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetAttackDelay(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("attack_delay",tostring(normal_attack_delay[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("attack_delay",tostring(hard_attack_delay[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetAttackSpeed(npc,desired_level,difficulty) -- TODO Why was Xackery setting this to hard 0
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("attack_speed","0");
	elseif difficulty == 2 then
		npc:ModifyNPCStat("attack_speed","0");
	else
		return;
	end
end

function ldon_scaling.SetSpellScale(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("spell_scale",tostring(normal_spell_scale[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("spell_scale",tostring(hard_spell_scale[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetHealScale(npc,desired_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("heal_scale",tostring(normal_heal_scale[desired_level]));
	elseif difficulty == 2 then
		npc:ModifyNPCStat("heal_scale",tostring(hard_heal_scale[desired_level]));
	else
		return;
	end
end

function ldon_scaling.SetSpecialAbilities(npc,desired_level,difficulty,isboss,charmable)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end

	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("special_abilities",normal_special_abilities[desired_level]);
	elseif difficulty == 2 then
		npc:ModifyNPCStat("special_abilities",hard_special_abilities[desired_level]);
	else
		return;
	end

	if charmable == 1 then
		npc:SetSpecialAbility(SpecialAbility.uncharmable,0);	-- Make Charmable
		npc:SetSpecialAbility(SpecialAbility.unsnareable,1);	-- Make UnSnareable
	elseif charmable == 2 then
		npc:SetSpecialAbility(SpecialAbility.uncharmable,0);	-- Make Charmable
	end

	if isboss == 1 then
		npc:SetSpecialAbility(SpecialAbility.summon,1);			-- Add Summoning
		npc:SetSpecialAbility(SpecialAbility.unmezable,1);		-- Make UnMezable
	end
end

function ldon_scaling.SetAvoidance(npc,desired_level,difficulty) -- TODO Why was Xackery setting this to hard 0
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end
	-- Set Stats
	if difficulty == 1 then
		npc:ModifyNPCStat("avoidance","0");
	elseif difficulty == 2 then
		npc:ModifyNPCStat("avoidance","0");
	else
		return;
	end
end

function ldon_scaling.SetSpells(npc,desired_level,difficulty)
	local spell_id = 0;
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
		return;
	end

	-- If NPC level is below 10, no spells
	if(desired_level < 10) then
		npc:ModifyNPCStat("npc_spells_id",tostring(spell_id));
		return;
	end

	if(npc:GetClass() == Class.CLERIC) then spell_id = 1 			-- Cleric
	elseif(npc:GetClass() == Class.PALADIN) then spell_id = 8 		-- Paladin
	elseif(npc:GetClass() == Class.RANGER) then spell_id = 10 		-- Ranger
	elseif(npc:GetClass() == Class.SHADOWKNIGHT) then spell_id = 9 		-- Shadow Knight
	elseif(npc:GetClass() == Class.DRUID) then spell_id = 3331 	-- Druid
	elseif(npc:GetClass() == Class.BARD) then spell_id = 11 		-- Bard
	elseif(npc:GetClass() == Class.SHAMAN) then spell_id = 3332 	-- Shaman
	elseif(npc:GetClass() == Class.NECROMANCER) then spell_id = 3 		-- Necromancer
	elseif(npc:GetClass() == Class.WIZARD) then spell_id = 2 		-- Wizard
	elseif(npc:GetClass() == Class.MAGICIAN) then spell_id = 4 		-- Magician
	elseif(npc:GetClass() == Class.ENCHANTER) then spell_id = 5 		-- Enchanter
	elseif(npc:GetClass() == Class.BEASTLORD) then spell_id = 12 	-- Beastlord
	end

	-- Set Spell Set
	npc:ModifyNPCStat("npc_spells_id",tostring(spell_id));
end

function ldon_scaling.SetSpellEffects(npc,desired_level, original_level,difficulty)
	-- Sanity Check
	if desired_level == nil or desired_level < 1 or desired_level > 70 or npc:IsClient() then
		return;
	end
	if difficulty < 1 or difficulty > 2 then
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

return ldon_scaling
