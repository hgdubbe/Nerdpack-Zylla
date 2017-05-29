local _, Zylla = ...

local GUI = {
	{type = 'header', 	text = 'Keybinds', align = 'center'},
	{type = 'text', 	text = 'Left Shift: Pause', align = 'center'},
	{type = 'text', 	text = 'Left Ctrl: ', align = 'center'},
	{type = 'text', 	text = 'Left Alt: ', align = 'center'},
	{type = 'text', 	text = 'Right Alt: ', align = 'center'},
	{type = 'checkbox', text = 'Pause Enabled', key = 'kPause', default = true},
	
} 

local exeOnLoad = function()
	 Zylla.ExeOnLoad()

	print("|cffADFF2F ---------------------------------------------------------------------------|r")
	print("|cffADFF2F --- |rDEATH KNIGHT |cffADFF2FFrost (MACHINEGUN =v required talets v=) |r")
	print("|cffADFF2F --- |rIf you want use MACHINEGUN =v required talents v= AND enable toggle button) |r")
	print("|cffADFF2F --- |rRecommended Talents:  1/2 - 2/2 - 3/3 - 4/X - 5/X - 6/1 - 7/3")
	print("|cffADFF2F ---------------------------------------------------------------------------|r")

	NeP.Interface:AddToggle({
		key = 'xMACHINEGUN',
		name = 'MACHINEGUN',
		text = 'ON/OFF using MACHINEGUN rotation',
		icon = 'Interface\\Icons\\Inv_misc_2h_farmscythe_a_01',
	})

end

local _Zylla = {
    {'/targetenemy [dead][noharm]', '{target.dead||!target.exists}&!player.area(40).enemies=0'},
}

local Util = {
	-- ETC.
	{'%pause' , 'player.debuff(200904)||player.debuff(Sapped Soul)'}, -- Vault of the Wardens, Sapped Soul
}

local PreCombat = {

}

local Survival = {
	{'Death Strike', 'player.health<=80&player.buff(Dark Succor)'},
}

local BoS_check = {
	{'Horn of Winter', 'talent(2,2)&talent(7,2)&cooldown(Breath of Sindragosa).remains>15'},
	{'Horn of Winter', 'talent(2,2)&!talent(7,2)'},
	{'Frost Strike', 'talent(7,2)&cooldown(Breath of Sindragosa).remains>15'},
	{'Frost Strike', '!talent(7,2)'},
	{'Empower Rune Weapon', 'talent(7,2)&cooldown(Breath of Sindragosa).remains>15&runes<1'},
	{'Empower Rune Weapon', '!talent(7,2)&runes<1'},
	{'Hungering Rune Weapon', 'talent(3,2)&talent(7,2)&cooldown(Breath of Sindragosa).remains>15'},
	{'Hungering Rune Weapon', 'talent(3,2)&!talent(7,2)'},
}

local Cooldowns = {
	{'Blood Fury', '!talent(7,2)||target.dot(Breath of Sindragosa).ticking'},
	{'Berserking', 'player.buff(Pillar of Frost)'},
	{'Pillar of Frost'},
	{'Sindragosa\'s Fury', 'player.buff(Pillar of Frost)&target.debuff(Razorice).count>=5'},
	{'Obliteration'},
	{'Breath of Sindragosa', 'talent(7,2)&runic_power>=50'},
	{BoS_check},
}

local Core = {
	{'Frostscythe', 'talent(6,1)&!talent(7,2)&{player.buff(Killing Machine)||player.area(8).enemies>=4}'},
	{'Remorseless Winter', 'artifact(Frozen Soul).enabled'},
	{'Glacial Advance', 'talent(7,3)'},
	{'Frost Strike', 'player.buff(Obliteration)&!player.buff(Killing Machine)'},
	{'Remorseless Winter', 'player.area(8).enemies>=2||talent(6,3)'},
	{'Obliterate', 'player.buff(Killing Machine)'},
	{'Obliterate'},
	{'Remorseless Winter'},
	{'Frostscythe', 'talent(6,1)&talent(2,2)'},
	{'Howling Blast', 'talent(2,2)'},
}

local IcyTalons = {
	{'Frost Strike', 'player.buff(Icy Talons).remains<1.5'},
	{'Howling Blast', '!target.dot(Frost Fever).ticking'},
	{'Howling Blast', 'player.buff(Rime)'},
	{'Frost Strike', 'runic_power>=80||player.buff(Icy Talons).stack<3'},
	{Core},
	{BoS_check},
}

local BoS = {
	{'Howling Blast', '!target.dot(Frost Fever).ticking'},
	{Core},
	{'Horn of Winter', 'talent(2,3)'},
	{'Empower Rune Weapon', 'runic_power<=70'},
	{'Hungering Rune Weapon', 'talent(3,2)'},
	{'Howling Blast', 'player.buff(Rime)'},
}

local Generic = {
	{'Howling Blast', '!target.dot(Frost Fever).ticking'},
	{'Howling Blast', 'player.buff(Rime)'},
	{'Frost Strike', 'runic_power>=80'},
	{Core},
	{BoS_check},
}

local Shatter = {
	{'Frost Strike', ''},
	{'Howling Blast', ''},
	{'Howling Blast', ''},
	{'Frost Strike', ''},
	{Core},
	{BoS_check},
}

local MACHINEGUN = {
	{'Frost Strike', 'player.buff(Icy Talons).remains<1.5'},
	{'Howling Blast', '!target.dot(Frost Fever).ticking'},
	{'Howling Blast', 'player.buff(Rime)'},
	{'Frost Strike', 'runic_power>=80||player.buff(Icy Talons).stack<3'},
	{'Frostscythe', 'talent(6,1)&!talent(7,2)&{player.buff(Killing Machine)||player.area(8).enemies>=4}'},
	{'Remorseless Winter', 'artifact(Frozen Soul).enabled'},
	{'Glacial Advance', 'talent(7,3)'},
	{'Frost Strike', 'player.buff(Obliteration)&!player.buff(Killing Machine)'},
	{'Remorseless Winter', 'player.area(8).enemies>=2||talent(6,3)'},
	{'Remorseless Winter'},
	{'Obliterate', '!talent(6,1)&player.buff(Killing Machine)'},
	{'Obliterate', 'talent(6,1)&!player.buff(Killing Machine)'},
	{'Frostscythe', 'talent(6,1)&talent(2,2)'},
}

local xCombat = {
	{BoS, 'target.dot(Breath of Sindragosa).ticking'},
	{Shatter, 'talent(1,1)'},
	{IcyTalons, 'talent(1,2)'},
	{Generic, '!talent(1,1)&!talent(1,2)'},
}

local Keybinds = {
	-- Pause
	{'%pause', 'keybind(lshift)&UI(kPause)'},
}

local Interrupts = {
	{'Mind Freeze'},
	{'Arcane Torrent', 'target.range<=8&spell(Mind Freeze).cooldown>gcd&!prev_gcd(Mind Freeze)'},
}

local inCombat = {
	{_Zylla, 'toggle(AutoTarget)'},
	{Util},
	{Keybinds},
	{Interrupts, 'target.interruptAt(50)&toggle(Interrupts)&target.infront&target.range<=15'},
	{Survival, 'player.health<100'},
	{Cooldowns, 'toggle(Cooldowns)&target.range<8'},
	{MACHINEGUN, 'toggle(xMACHINEGUN)&target.range<8&target.infront'},
	{xCombat, '!toggle(xMACHINEGUN)&target.range<8&target.infront'}
}

local outCombat = {
	{Keybinds},
	{PreCombat},
}
NeP.CR:Add(251, {
	name = '[|cff'..Zylla.addonColor..'Zylla\'s|r] Death Knight - Frost',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
