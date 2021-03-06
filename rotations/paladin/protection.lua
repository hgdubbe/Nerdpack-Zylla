local _, Zylla = ...

local Mythic_GUI = _G.Mythic_GUI
local Mythic_Plus = _G.Mythic_Plus
local Logo_GUI = _G.Logo_GUI
local PayPal_GUI = _G.PayPal_GUI
local PayPal_IMG = _G.PayPal_IMG
local unpack = _G.unpack

local GUI = {
	unpack(Logo_GUI),
	-- Header
	{type = 'header',  	size = 16, text = 'Keybinds',	 														align = 'center'},
	{type = 'checkbox',	text = 'Left Shift: '..Zylla.ClassColor..'Pause|r',				align = 'left', 			key = 'lshift', 	default = true},
	{type = 'checkbox',	text = 'Left Ctrl: '..Zylla.ClassColor..'|r',							align = 'left', 			key = 'lcontrol',	default = true},
	{type = 'checkbox',	text = 'Left Alt: '..Zylla.ClassColor..'|r',							align = 'left', 			key = 'lalt', 		default = true},
	{type = 'checkbox',	text = 'Right Alt: '..Zylla.ClassColor..'|r',							align = 'left', 			key = 'ralt', 		default = true},
	{type = 'spacer'},
--{type = 'checkbox', text = 'Enable Chatoverlay', 															key = 'chat', 				width = 55, 			default = true, desc = Zylla.ClassColor..'This will enable some messages as an overlay!|r'},
	unpack(PayPal_GUI),
	{type = 'spacer'},
	unpack(PayPal_IMG),
	{type = 'ruler'},	{type = 'spacer'},
	-- Settings
  -- Survival
  {type='spacer'}, 	{type='rule'},
  {type = 'header', text = 'Survival', 																					align = 'center'},
  {type='checkbox', text = 'Enable Self-Heal (Flash of Light)',									key='kFoL', default=false},
  {type='spinner', 	text = 'Flash of Light (HP%)', key='E_FoL', 								default=60},
	unpack(Mythic_GUI),
}

local exeOnLoad = function()
  Zylla.ExeOnLoad()
  Zylla.AFKCheck()

  print('|cffADFF2F ----------------------------------------------------------------------|r')
  print('|cffADFF2F --- |rPALADIN |cffADFF2FProtection |r')
  print('|cffADFF2F --- |rRecommended Talents: 1/2 - 2/2 - 3/3 - 4/1 - 5/2 - 6/2 - 7/3')
  print('|cffADFF2F ----------------------------------------------------------------------|r')

  NeP.Interface:AddToggle({
  key = 'AutoTaunt',
  name = 'Auto Taunt',
  text = 'Automatically taunt nearby enemies.',
  icon = 'Interface\\Icons\\spell_nature_shamanrage.png',
  })
end

local Keybinds = {
  {'%pause', 'keybind(lshift)&UI(lshift)'},
}

local Interrupts = {
  {'!Rebuke'},
  {'!Hammer of Justice', 'cooldown(Rebuke).remains>gcd'},
  {'!Arcane Torrent', 'target.inMelee&spell(Rebuke).cooldown>gcd&!prev_gcd(Rebuke)'},
}

local Survival ={
  {'Flash of Light', 'player.health<=UI(E_FoL)&player.lastmoved>0&UI(kFoL)', 'player'},
  {'Light of the Protector', 'player.health<78&player.buff(Consecration)'},
}

local PreCombat = {
}

local EyeofTyr = {
  {'Divine Steed', 'talent(5,2)'},
  {'Eye of Tyr'},
  {'Aegis of Light', 'talent(6,1)'},
  {'Guardian of Ancient Kings'},
  {'Divine Shield'},
  {'Ardent Defender'},
}
local Cooldowns = {
  {'Seraphim', 'talent(7,2)&spell(Shield of the Righteous).charges>1', 'player'},
  {'Shield of the Righteous', 'inMelee&inFront&{!talent(7,2)||spell(Shield of the Righteous).charges>2}&!{player.buff(Eye of Tyr)&player.buff(Aegis of Light)&player.buff(Ardent Defender)&player.buff(Guardian of Ancient Kings)&player.buff(Divine Shield)}', 'target'},
  {'Bastion of Light', 'talent(2,2)&spell(Shield of the Righteous).charges<1', 'player'},
  {'Light of the Protector', 'player.health<40', 'player'},
  {'Hand of the Protector', 'talent(5,1)&health<40', 'player'},
  {'Light of the Protector', '{incdmg(10)>health.max*1.25}&health<55&talent(7,1)', 'player'},
  {'Light of the Protector', '{incdmg(13)>health.max*1.6}&health<55', 'player'},
  {'Hand of the Protector', 'talent(5,1)&{incdmg(6)>health.max*0.7}&health<55&talent(7,1)', 'player'},
  {'Hand of the Protector', 'talent(5,1)&{incdmg(9)>health.max*1.2}&health<55', 'player'},
  {EyeofTyr, 'player.incdmg(2.5)>player.health.max*0.40&!{player.buff(Eye of Tyr)||player.buff(Aegis of Light)||player.buff(Ardent Defender)||player.buff(Guardian of Ancient Kings)||player.buff(Divine Shield)}'},
  {'Lay on Hands', 'health<15', 'player'},
  {'Avenging Wrath', '!talent(7,2)||talent(7,2)&buff(Seraphim)', 'player'}
}

local AoE = {
  {'Avenger\'s Shield'},
  {'Blessed Hammer'},
  {'Judgment'},
  {'Consecration', 'target.range<7'},
  {'Hammer of the Righteous', '!talent(1,2)'},
}

local ST = {
  {'Judgment'},
  {'Blessed Hammer'},
  {'Avenger\'s Shield'},
  {'Consecration', 'target.range<7'},
  {'Blinding Light'},
  {'Hammer of the Righteous', '!talent(1,2)'},
}

local inCombat = {
  {Keybinds},
  {Survival, 'player.health<100'},
  {Interrupts, 'target.interruptAt(70)&toggle(Interrupts)&target.inFront&target.inMelee'},
  {Cooldowns, 'toggle(Cooldowns)'},
  {'%taunt(Hand of Reckoning)', 'toggle(aoe)'},
  {'Shield of the Righteous', '!player.buff&{player.health<60||spell.count>1}', 'target'},
  {AoE, 'toggle(AoE)&player.area(8).enemies>2'},
	{Mythic_Plus, 'inMelee'},
  {ST, 'target.inFront&target.inMelee'}
}

local outCombat = {
  {Keybinds},
  {PreCombat}
}

NeP.CR:Add(66, {
  name = '[|cff'..Zylla.addonColor..'Zylla\'s|r] Paladin - Protection',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	gui_st = {title='Zylla\'s Combat Routines', width='256', height='520', color='A330C9'},
	ids = Zylla.SpellIDs[Zylla.Class],
	wow_ver = Zylla.wow_ver,
	nep_ver = Zylla.nep_ver,
	load = exeOnLoad
})
