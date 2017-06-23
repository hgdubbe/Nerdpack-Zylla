local _, Zylla = ...

local Util = _G['Zylla.Util']
local Trinkets = _G['Zylla.Trinkets']
local Heirlooms = _G['Zylla.Heirlooms']

local GUI = {
	-- Keybinds
	{type = 'header', 	text = 'Keybinds', 										align = 'center'},
	{type = 'text', 	text = 'Left Shift: Pause', 							align = 'center'},
	{type = 'text', 	text = 'Left Ctrl: Transcendence/Transfer', 			align = 'center'},
	{type = 'text', 	text = 'Left Alt: Summon Black Ox Statue @CURSOR',		align = 'center'},
	{type = 'ruler'},	{type = 'spacer'},
	-- General
	{type = 'spacer'},	{type = 'rule'},
	{type = 'header', 	text = 'General', 										align = 'center'},
	{type = 'checkbox', text = 'Automatic Res', 								key = 'auto_res', 		default = true},
	{type = 'checkbox', text = 'Pause Enabled', 								key = 'kPause', 		default = true},
	{type = 'checkbox', text = 'Auto-Target Enemies', 							key = 'kAutoTarget',	default = true},
	-- Survival
	{type = 'spacer'},	{type = 'rule'},
	{type = 'header', 	text = 'Survival',										align = 'center'},
	{type = 'checkbox',	text = 'Enable Self-Heal (Effuse)', 					key = 'kEffuse',		default = false},
	{type = 'spinner', 	text = 'Effuse (HP%)', 									key = 'E_HP',			default = 60},
	{type = 'spinner',	text = 'Healthstone or Healing Potion',					key = 'Health Stone',	default = 45},
	{type = 'spinner',	text = 'Healing Elixir', 								key = 'Healing Elixir',	default = 70},
	{type = 'spinner',	text = 'Expel Harm', 									key = 'Expel Harm',		default = 100},
	{type = 'spinner',	text = 'Fortifying Brew',								key = 'Fortifying Brew',default = 20},
	{type = 'spinner',	text = 'Ironskin Brew',									key = 'Ironskin Brew',	default = 80},
	-- Trinkets + Heirlooms for leveling
	{type = 'checkbox', text = 'Use Trinket #1',								key = 'kT1',			default = false},
	{type = 'checkbox', text = 'Use Trinket #2',								key = 'kT2',			default = false},
	{type = 'checkbox', text = 'Ring of Collapsing Futures',					key = 'kRoCF',			default = true},
	{type = 'checkbox', text = 'Use Heirloom Necks When Below X% HP',			key = 'k_HEIR',			default = true},
	{type = 'spinner',	text = '',												key = 'k_HeirHP',		default = 40},
}

local exeOnLoad=function()
	 Zylla.ExeOnLoad()

	print('|cffADFF2F ---------------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rMonk |cffADFF2FBrewmaster  |r')
	print('|cffADFF2F --- |rRecommended Talents:  COMING SOON...')
	print('|cffADFF2F ---------------------------------------------------------------------------|r')

	NeP.Interface:AddToggle({
		key = 'xTaunt',
		name = 'Taunt',
		text = 'Automatically Taunts your current target when threat gets low.',
		icon = 'Interface\\Icons\\spell_nature_reincarnation',
	})

	NeP.Interface:AddToggle({
		key = 'xCrackle',
		name = 'Crackling Jade Lightning',
		text = 'Use Crackling Jade Lightning.',
		icon = 'Interface\\Icons\\ability_monk_cracklingjadelightning',
	})

end

local Keybinds = {
	{'%pause', 'keybind(lshift)&UI(kPause)'},
	{'!Summon Black Ox Statue', 'talent(4,2)&keybind(lalt)', 'cursor.ground'},
	{'!Transcendence', 'keybind(lcontrol)&!player.buff(Transcendence)'},
	{'!Transcendence: Transfer', 'keybind(lcontrol)&player.buff(Transcendence)'},
	{'!/cancelaura Transcendence', 'keybind(lcontrol)&player.buff(Transcendence)&lastcast(Transcendence: Transfer)'},
}

local Snares = {
	{'Nimble Brew', 'spell.exists(213664)&{player.state.disorient||player.state.stun||player.state.fear||player.state.horror}'},
	{'Tiger\'s Lust', 'talent(2,2)&{player.state.disorient||player.state.stun||player.state.root||player.state.snare}'},
}

local Cooldowns = {
	{'Fortifying Brew', 'player.health<=UI(Fortifying Brew)'},
}

local Mitigations = {
	{'Black Ox Brew', 'player.spell(Purifying Brew).charges<1&player.spell(purifying brew).recharge>2'},
	{'Purifying Brew', '@Zylla.staggered(nil)&player.spell(Purifying Brew).charges>=1'},
	{'Ironskin Brew', 'player.health<=UI(Ironskin Brew)&player.spell(Purifying Brew).charges>=2&!player.buff(Ironskin Brew)'},
	{'Ironskin Brew', '@Zylla.purifyingCapped(nil)&player.health<100&!player.buff(Ironskin Brew)'},
}

local Survival = {
	{'Healing Elixir', 'player.spell(Healing Elixir).charges>=2||{player.spell(Healing Elixir).charges=1&player.spell(Healing Elixir).cooldown<3}&!lastcast(Healing Elixir)&player.health<=UI(Healing Elixir)', 'player'},
	{'#Healthstone', 'player.health<=UI(Health Stone)', 'player'},
	{'#Ancient Healing Potion', 'player.health<=UI(Healthstone)', 'player'},
	{'Expel Harm', 'player.health<=UI(Expel Harm)&player.spell(Expel Harm).count>=1', 'player'},
	{'Effuse', 'player.health<=UI(E_HP)&player.lastmoved>=1&UI(kEffuse)', 'player'},
}

local Interrupts = {
	{'!Spear Hand Strike'},
	{'!Paralysis', '!target.immune(incapacitate)&target.range<=20&player.energy=>20&spell(Spear Hand Strike).cooldown>gcd&!lastcast(Spear Hand Strike)'},
	{'!Paralysis', '!immune(incapacitate)&range<=20&player.energy=>20&player.area(20).enemies>=2', 'endebuff(Paralysis)'},
	{'!Ring of Peace', 'talent(4,1)&!target.debuff(Spear Hand Strike)&spell(Spear Hand Strike).cooldown>gcd&!lastcast(Spear Hand Strike)'},
	{'!Leg Sweep', '!target.immune(stun)&talent(4,3)&spell(Spear Hand Strike).cooldown>gcd&target.inMelee&!lastcast(Spear Hand Strike)'},
	{'!Quaking Palm', '!target.immune(incapacitate)&!target.debuff(Spear Hand Strike)&spell(Spear Hand Strike).cooldown>gcd&!lastcast(Spear Hand Strike)'},
}

local Artifact = {
	{'Exploding Keg', 'target.range<=40&{{target.area(8).enemies>=3}||{player.incdmg(5)>=health.max*0.70}}', 'target.ground'},
}

local Crackle = {
	{'Crackling Jade Lightning', '!player.moving&toggle(xCrackle)'},
}

local Taunts = {
	{'Provoke', 'target.range<=35&target.combat&target.threat<=99&toggle(xTaunt)'},
}

local xCombat = {
	{'Blackout Strike', 'target.inMelee&target.inFront&talent(7,2)&!player.buff(Blackout Combo)&{player.spell(Keg Smash).cooldown>3||player.spell(Keg Smash).cooldown<1.5}'},
	{'Keg Smash', 'target.range<=15&target.inFront&talent(7,2)&{player.buff(Blackout Combo)||@Zylla.purifyingCapped(nil)}'},
	{'Keg Smash', 'target.range<=15&target.inFront&!talent(7,2)'},
	{{
		{'Blackout Strike', 'target.inMelee&target.inFront&!player.buff(Blackout Combo)&talent(7,2)&player.area(10).enemies>=1'},
		{'Breath of Fire', 'target.range<=12&target.inFront&player.buff(Blackout Combo)&talent(7,2)&player.area(10).enemies>=1'},
		{'Blackout Strike', 'target.inMelee&talent(7,2)&!player.buff(Blackout Combo)&{player.energy>=45||player.spell(Keg Smash).cooldown>3}'},
		{'Tiger Palm', 'target.inMelee&target.inFront&talent(7,2)&player.buff(Blackout Combo)'},
		{'Blackout Strike', 'target.inMelee&target.inFront&'},
		{'Breath of Fire', 'target.range<=12&target.inFront&target.debuff(Keg Smash)&!talent(7,2)&player.area(10).enemies>=1'},
		{'Chi Burst', 'talent(1,1)&target.inFront&player.area(40).enemies>=1'},
		{'Chi Wave', 'target.range<=40&target.inFront&player.area(10).enemies>=2', 'target.enemy'},
		{'Rushing Jade Wind', 'talent(6,1)&player.area(8).enemies>=2'},
		{'Tiger Palm', 'target.inMelee&target.inFront&!talent(7,2)||{target.inMelee&target.inFront&player.energy>=70&{player.energy>=55||player.spell(Keg Smash).cooldown>3}}'},
	},	{'player.spell(Keg Smash).cooldown>=0.5||{!talent(7,2)&!player.buff(Blackout Combo)&player.spell(Keg Smash).cooldown>=2&@Zylla.purifyingCapped(nil)}'}},
}

local inCombat = {
	{Util},
	{Trinkets},
	{Heirlooms},
	{Artifact},
	{Keybinds},
	{Snares},
	{Survival, 'player.health<100'},
	{Interrupts, 'target.interruptAt(80)&target.inMelee'},
	{Mitigations, 'target.inMelee&{!talent(7,2)||!player.buff(Blackout Combo)||player.spell(Keg Smash).cooldown>=2.5}'},
	{Cooldowns, 'toggle(Cooldowns)'},
	{xCombat},
	{Crackle, '!target.inMelee&target.inRanged'},
}

local outCombat={
	{Keybinds},
	{'%ressdead(Resuscitate)', 'UI(auto_res)'},
	{'Effuse', 'player.health<=50&player.lastmoved>=1', 'player'},
}

NeP.CR:Add(268, {
	name='[|cff'..Zylla.addonColor..'Zylla\'s|r] Monk - Brewmaster',
	ic=inCombat,
	ooc=outCombat,
	gui=GUI,
	load=exeOnLoad
})
