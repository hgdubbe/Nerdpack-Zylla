local _, Zylla = ...

local GUI = {
	--Logo
	{type = 'texture',  texture = 'Interface\\AddOns\\Nerdpack-Zylla\\media\\logo.blp', width = 128, height = 128, offset = 90, y = -60, align = 'center'},
	{type = 'spacer'},{type = 'spacer'},{type = 'spacer'},{type = 'spacer'},
	-- Keybinds
	{type = 'header', text = 'Keybinds', align = 'center'},
	{type = 'text', text = 'Left Shift: Pause', align = 'center'},
	{type = 'text', text = 'Left Ctrl: Cataclysm', align = 'center'},
	{type = 'text', text = 'Left Alt: Rain of Fire', align = 'center'},
	{type = 'text', text = 'Right Alt: ', align = 'center'},
	{type = 'spacer'}, {type = 'ruler'}, {type = 'spacer'},
	-- Settings
	{type = 'header', text = 'Class Settings', align = 'center'},
	{type = 'checkbox', text = 'Pause Enabled', key = 'kPause',	default = true},
	{type = 'checkbox', text = 'Handle Pets (Imp, Doomguard, Infernal)', key = 'kPet',	default = true},
	{type = 'checkbox', text = 'Use Trinket #1 on Cooldown', key = 'trinket1',	default = false},
	{type = 'checkbox', text = 'Use Trinket #2 on Cooldown', key = 'trinket2',	default = false},
	{type = 'spinner', text = 'Immolate Units', key = 'imo_units', align = 'left', width = 55, step = 1, default = 4, max = 20},
	{type = 'spinner', text = 'Soul Harvest - Immolate Units', key = 'SH_units', align = 'left', width = 55, step = 1, default = 3, max = 6},
	{type = 'spinner', text = 'Channel Demonfire - Immolate Units', key = 'SH_units', align = 'left', width = 55, step = 1, default = 3, max = 6},
	{type = 'spacer'},
	{type = 'text', text = 'Grimoire of Supremacy/Sacrifice', align = 'center'},
	{type = 'checkbox', text = 'Use Doomguard as Pet', key = 'kDG',	default = false},
	{type = 'checkbox', text = 'Use Infernal as Pet', key = 'kINF',	default = false},
	{type = 'spacer'}, {type = 'ruler'}, {type = 'spacer'},
	-- Survival
	{type = 'header', text = 'Survival', align = 'center'},
	{type = 'checkbox', text = 'Use Soulstone on yourself', key = 'ss_enable',	default = true},
	{type = 'checkbox', text = 'Use Fear to Interrupt', key = 'k_FEAR',		default = false},
	{type = 'checkspin', text = 'Unending Resolve below HP%', check= true, key = 'UR_HP',		spin = 40},
	{type = 'checkspin', text = 'Cauterize Master below HP%', check= true, key = 'CM_HP',		spin = 65},
	{type = 'checkspin',text = 'Healthstone',	check= true, key = 'HS_HP', spin = 45},
	{type = 'checkspin',text = 'Ancient Healing Potion', check = true, key = 'AHP_HP',	spin = 40},
	{type = 'spinner', text = 'Life Tap above HP%', key = 'k_LTHP',		default = 70},
	{type = 'spinner', text = 'Drain Life below HP%', key = 'k_DLHP',		default = 40},
	{type = 'spacer'},
	{type = 'header', text = 'Health Funnel', align = 'center'},
	{type = 'spinner',	text = 'Health Funnel When PET is below HP%', key = 'k_HFHP', default = 30},
	{type = 'spinner',	text = 'Health Funnel When PLAYER is above HP%', key = 'k_HFHP2', default = 40},
	{type = 'spacer'},
	{type = 'header', text = 'Dark Pact', align = 'center'},
	{type = 'spinner',	text = 'Dark Pact When PET is below HP%', key = 'DP_PETHP', default = 25},
	{type = 'spinner',	text = 'Dark Pact When PLAYER is above HP%', key = 'DP_PHP', default = 40},
	{type = 'spacer'}, {type = 'ruler'}, {type = 'spacer'},
}

local exeOnLoad = function()
	Zylla.ExeOnLoad()
	Zylla.AFKCheck()

	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rWarlock |cffADFF2FDestruction |r')
	print('|cffADFF2F --- |rRecommended Talents: COMING SOON...')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
  print('|cffFFFB2F Configuration: |rRight-click MasterToggle and go to Combat Routines Settings!|r')

	NeP.Interface:AddToggle({
		key = 'xIntRandom',
		name = 'Interrupt Anyone',
		text = 'Interrupt all nearby enemies, without targeting them.',
		icon = 'Interface\\Icons\\inv_ammo_arrow_04',
	})

end

local Keybinds = {
	{'%pause', 'keybind(lshift)&UI(kPause)'},
	{'!Cataclysm', '!player.moving&keybind(lcontrol)', 'cursor.ground'},
	{'!Rain of Fire', 'keybind(lalt)', 'cursor.ground'},
}

local PreCombat = {
	{'Life Tap', 'talent(2,3)&buff(Empowered Life Tap).duration<gcd&health>=95', 'player'},
	{'Grimoire of Sacfifice', 'talent(6,3)&pet.exists'}
}

local Pets = {
	{'Summon Imp', 'xtime>0.5&UI(kPet)&!UI(kDG)&!UI(kINF)&!talent(6,1)&{!pet.exists||pet.dead}'},
	{'Summon Doomguard', 'xtime>0.5&UI(kPet)&UI(kDG)&!UI(kINF)&talent(6,1)&{!pet.exists||pet.dead}'},
	{'Summon Infernal', 'xtime>0.5&UI(kPet)&!UI(kDG)&UI(kINF)&talent(6,1)&{!pet.exists||pet.dead}'},
}

local Survival = {
	{'Life Tap', 'player.moving&player.health>=UI(k_LTHP)', 'player'},
	{'Life Tap', 'talent(2,3)&buff(Empowered Life Tap).duration<gcd', 'player'},
	{'Unending Resolve', 'player.health<=UI(UR_HP_spin)&UI(UR_HP_check)'},
	{'Dark Pact', 'player.health<UI(DP_PHP)&pet.health>=UI(DP_PETHP)'},
	{'Drain Life', 'player.health<=UI(k_DLHP)'},
	{'Health Funnel', 'pet.health<=UI(k_HFHP)&player.health>=UI(k_HFHP2)'},
	{'&119899', 'pet.exists&player.health<=UI(CM_HP_spin)&UI(CM_HP_check)'},
	{'#127834', 'item(127834).usable&item(127834).count>0&player.health<UI(AHP_HP_spin)&UI(AHP_HP_check)'},       -- Ancient Healing Potion
  {'#5512', 'item(5512).usable&item(5512).count==3&player.health<UI(HS_HP_spin)&UI(HS_HP_check)', 'player'},  --Health Stone
}

local Cooldowns = {
	{'Summon Infernal', '!player.moving&toggle(aoe)&UI(kPet)&!talent(6,1)&target.area(10).enemies>2'},
	{'Summon Doomguard', '!player.moving&UI(kPet)&!talent(6,1)&target.area(10).enemies<3'},
	{'Soul Harvest', 'enemies.debuff(Immolate).count.any>=UI(SH_units)'},
	{'Grimoire: Imp', nil, 'target'},
	{'#Trinket1', 'UI(trinket1)'},
	{'#Trinket2', 'UI(trinket2)'},
}

local Interrupts = {
	{'!Fear', '!player.moving&interruptAt(12)&inFront&range<41&UI(k_FEAR)', 'target'},
	{'!Shadowfury', '!player.moving&advanced&interruptAt(12)&inFront&range<31', 'target.ground'},
	{'!Mortal Coil', 'interruptat(70)&inFront&range<21', 'target'},
}

local Interrupts_Random = {
	{'!Fear', '!player.moving&interruptAt(12)&inFront&range<41&UI(k_FEAR)&UI(xIntRandom)&combat&alive', 'enemies'},
	{'!Shadowfury', '!player.moving&interruptAt(70)&advanced&range<31&combat&alive', 'enemies.ground'},
	{'!Mortal Coil', 'interruptAt(5)&inFront&range<21&UI(xIntRandom)&combat&alive', 'enemies'},
}

local xCombat = {
	{'Shadowburn', 'player.buff(Conflagration of Chaos).duration<=action(Chaos Bolt.cast_time)'},
	{'Shadowburn', 'player.soul_shard<5&{{player.spell(Shadowburn).charges==1&set_bonus(T19)==4&player.spell(Shadowburn).recharge<action(Chaos Bolt).cast_time}||{player.spell(Shadowburn).charges==2}&set_bonus(T19)==4}}'},
	{'Havoc', 'toggle(aoe)&player.area(40).enemies>1&!debuff(Havoc)&!is(target)&combat&alive', 'enemies'},
	{'Chaos Bolt', '!player.moving&player.soulshards==5', 'target'},
	{'Chaos Bolt', '!player.moving&player.area(40).enemies<4&enemies.debuff(Havoc).duration>player.spell(Chaos Bolt).casttime&!target.debuff(Havoc)', 'target'},
	{'Chaos Bolt', '!player.moving&player.area(40).enemies<3&target.ttd<11', 'target'},
	{'Dimensional Rift', '{player.spell(Dimensional Rift).charges>2}||{player.movingfor>0.3&player.soulshards<5}', 'target'},
	{'Dimensional Rift', 'equipped(144369)&player.buff(Lessons of Spacetime).duration<gcd&{{!talent(6,1)&player.spell(Summon Doomguard).duration<gcd}||{talent(4,3)&player.spell(Soul Harvest).cooldown<gcd}}', 'target'},
	{'Channel Demonfire', '!player.moving&debuff(Immolate).duration>3&debuff(Immolate).count.any>=UI(cd_units)&range<41&combat&alive', 'enemies'},
	{'Rain of Fire', '!player.moving&advanced&toggle(aoe)&area(10).enemies>2&combat&alive', 'enemies.ground'},
	{'Conflagrate', 'debuff(Immolate)&player.soulshards<5', 'target'},
	{'Incinerate', '!player.moving&player.soulshards<5&debuff(Immolate)', 'target'},
	{'Cataclysm', 'advanced&target.area(8).enemies>2', 'target.ground'},
	{'Immolate', '!player.moving&combat&alive&debuff.count.any<=UI(umi_units)&debuff.duration<2.5', 'enemies'},
	{Pets},
}

local inCombat = {
	{Keybinds},
	{Interrupts, 'toggle(interrupts)'},
	{Interrupts_Random},
	{Survival, 'player.health<100'},
	{Cooldowns, 'toggle(Cooldowns)'},
	{xCombat, 'range<41&inFront'},
}

local outCombat = {
	{PreCombat},
	{Keybinds},
	{Interrupts, 'toggle(interrupts)'},
	{Interrupts_Random},
	{Pets},
	{'Create Healthstone', 'item(5512).count<=2&!lastcast(Create Healthstone)'},
	{'Soulstone', 'UI(ss_enable)&!buff', 'player'},
}

NeP.CR:Add(267, {
	name = '[|cff'..Zylla.addonColor..'Zylla\'s|r] Warlock - Destruction',
	ic =  {{inCombat, '!player.channeling(Channel Demonfire)'}},
	ooc = outCombat,
	gui = GUI,
	gui_st = {title='Zylla\'s Combat Routines', width='256', height='690', color='A330C9'},
	--ids = Zylla.SpellIDs[Zylla.Class],
	wow_ver = Zylla.wow_ver,
	nep_ver = Zylla.nep_ver,
	load = exeOnLoad
})
