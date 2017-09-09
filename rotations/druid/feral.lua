local _, Zylla = ...

local Mythic_GUI = _G.Mythic_GUI
local Fel_Explosives = _G.Fel_Explosives
local Logo_GUI = _G.Logo_GUI
local unpack = _G.unpack

local GUI = {
	unpack(Logo_GUI),
	{type = 'header', 	text = 'Keybinds', align = 'center'},
	{type = 'text', 	text = 'Left Shift: Pause', align = 'center'},
	{type = 'text', 	text = 'Left Ctrl: ', align = 'center'},
	{type = 'text', 	text = 'Left Alt: ', align = 'center'},
	{type = 'text', 	text = 'Right Alt: ', align = 'center'},
	{type = 'ruler'},	{type = 'spacer'},
	-- Settings
	{type = 'header', 	text = 'Class Settings',				align = 'center'},
	{type = 'checkbox', text = 'Pause Enabled',					key = 'kPause', 		default = true},
	{type = 'checkbox', text = 'Use Trinket #1', 				key = 'trinket1',		default = true},
	{type = 'checkbox', text = 'Use Trinket #2', 				key = 'trinket2', 		default = true},
	{type = 'ruler'},	{type = 'spacer'},
	-- Survival
	{type = 'header', 	text = 'Survival',						align = 'center'},
	{type = 'checkspin',text = 'Swiftmend', 					key = 'swiftm', 		spin = 85, step = 5, max = 100, check = true},
	{type = 'checkspin',text = 'Survival Instincts', 			key = 'sint', 			spin = 50, step = 5, max = 100, check = true},
	{type = 'ruler'},		{type = 'spacer'},
	unpack(Mythic_GUI),
}

local exeOnLoad = function()
	Zylla.ExeOnLoad()
	Zylla.AFKCheck()

	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rDRUID |cffADFF2FFeral |r')
	print('|cffADFF2F --- |rRecommended Talents: 1/3 - 2/3 - 3/2 - 4/3 - 5/3 - 6/2 - 7/2')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffFFFB2F Configuration: |rRight-click MasterToggle and go to Combat Routines Settings!|r')
	print('| This routine is still in development. Please report any issues found!')

	NeP.Interface:AddToggle({
		key='xStealth',
		name='Auto Stealth',
		text = 'If Enabled we will automatically use Stealth out of combat.',
		icon='Interface\\Icons\\ability_stealth',
	})

	NeP.Interface:AddToggle({
		key = 'xFORM',
		name = 'Handle Forms',
		text = 'Automatically handle player forms',
		icon = 'Interface\\Icons\\inv-mount_raven_54',
	})

	NeP.Interface:AddToggle({
		key = 'xIntRandom',
		name = 'Interrupt Anyone',
		text = 'Interrupt all nearby enemies, without targeting them.',
		icon = 'Interface\\Icons\\inv_ammo_arrow_04',
	})

end

local Keybinds = {
	-- Pause
	{'%pause', 'keybind(lshift)&UI(kPause)'},
}

local Interrupts = {
	{'!Skull Bash', 'player.form>0', 'target'},
	{'!Maim', 'player.combopoints>0&player.spell(Skull Bash).cooldown>gcd&!player.lastcast(Skull Bash)', 'target'},
	{'!Typhoon', 'player.spell(Skull Bash).cooldown>gcd', 'target'},
	{'!Mighty Bash', 'player.spell(Skull Bash).cooldown>gcd', 'target'},
}

local Interrupts_Random = {
	{'!Skull Bash', 'interruptAt(70)&player.form>0&toggle(xIntRandom)&toggle(Interrupts)&inFront&range<14', 'enemies'},
	{'!Maim', 'player.combopoints>0&player.spell(Skull Bash).cooldown>gcd&!player.lastcast(Skull Bash)&infront&inmelee&combat&alive', 'enemies'},
	{'!Typhoon', 'interruptAt(60)&toggle(xIntRandom)&toggle(Interrupts)&player.area(15).enemies.infront.inFront>=1', 'enemies'},
	{'!Mighty Bash', 'interruptAt(75)&toggle(xIntRandom)&toggle(Interrupts)&inMelee&inFront', 'enemies'},
}

-- Pooling START

local Bear_Healing = {
	{'Bear Form', 'form~=1', 'player'},
	{'Frenzied Regeneration', nil, 'player'},
}

local Regrowth_Pool = {
	{'!Regrowth', nil, 'player'},
}

local Moonfire_Pool = {
	{'%pause', 'player.energy<30&!player.buff(Clearcasting)'},
	{'Moonfire', nil, 'target'},
}

local Rake_Pool = {
	{'%pause', 'player.energy<35&!player.buff(Clearcasting)'},
	{'Rake', nil, 'target'},
}

local Rip_Pool = {
	{'%pause', 'player.energy<30&!player.buff(Clearcasting)'},
	{'Rip', nil, 'target'},
}

local Savage_Roar_Pool = {
	{'%pause', 'player.energy<40&!player.buff(Clearcasting)'},
	{'Savage Roar', nil, 'target'},
}

local Ferocious_Bite_Pool = {
	{'%pause', 'player.energy<25&!player.buff(Clearcasting)'},
	{'Ferocious Bite', nil, 'target'},
}

local Thrash_Pool = {
	{'%pause', 'player.energy<50&!player.buff(Clearcasting)'},
	{'Thrash', nil, 'target'},
}

local Swipe_Pool = {
	{'%pause', 'player.energy<45&!player.buff(Clearcasting)'},
	{'Swipe', nil, 'target'},
}

-- Pool END

local PreCombat = {
	{'Travel Form', 'toggle(xFORM)&movingfor>0.75&!indoors&!buff&!buff(Prowl)', 'player'},
	{Regrowth_Pool, 'talent(7,2)&target.enemy&target.alive&!player.buff(Prowl)&!player.lastcast(Regrowth)&player.buff(Bloodtalons).stack<2'},
	{'Cat Form', 'toggle(xFORM)&movingfor>0.75&indoors&!buff&!buff(Travel Form)&!buff(Prowl)', 'player'},
	{'Prowl', 'toggle(xFORM)&toggle(xStealth)&!buff', 'player'},
	{'Rake', 'player.buff(Prowl)&inMelee&inFront', 'target'},
}

local SBT_Opener = {
	--# Hard-cast a Regrowth for Bloodtalons buff. Use Dash to re-enter Cat Form.
	{Regrowth_Pool, 'talent(7,2)&player.combopoints==5&!player.buff(Bloodtalons)&!target.dot(Rip).ticking'},
	--# Force use of Tiger's Fury before applying Rip.
	{'Tiger\'s Fury', '!target.dot(Rip).ticking&combopoints==5', 'player'},
}

local Cooldowns = {
	{'Rake', 'player.buff(Prowl)||player.buff(Shadowmeld)', 'target'},
	{'Berserk', 'buff(Tiger\'s Fury)', 'player'},
	{'Incarnation: King of the Jungle', 'spell(Tiger\'s Fury).cooldown<gcd', 'player'},
	{'Incarnation: King of the Jungle', 'energy.time_to_max>1&energy>25', 'player'},
	{'Tiger\'s Fury', '{!buff(Clearcasting)&energy.deficit>50}||energy.deficit>70', 'player'},
	{'Survival Instincts', 'player.health<=UI(sint_spin)&UI(sint_check)', 'player'},
	{Ferocious_Bite_Pool, 'target.dot(Rip).ticking&target.dot(Rip)remains<3&target.time_to_die>3&{target.health<25||talent(6,1)}'},
	{Regrowth_Pool, 'talent(7,2)&player.buff(Predatory Swiftness)&{player.combopoints>4||player.buff(Predatory Swiftness).remains<1.5||{talent(7,2)&player.combopoints==2&!player.buff(Bloodtalons)&player.spell(Ashamane\'s Frenzy).cooldown<gcd}}'},
	{SBT_Opener, 'talent(6,1)&xtime<20'},
	{Regrowth_Pool, 'equipped(137024)&talent(7,2)&player.buff(Predatory Swiftness).stack>1&!player.buff(Bloodtalons)'},	-- Ailuro Pouncers Legendary.
}

local Finisher = {
	{Savage_Roar_Pool, 'talent(6,3)&!player.buff(Savage Roar)&player.combopoints==5}'},
	{Thrash_Pool, 'target.dot(Thrash).remains<=target.dot(Thrash).duration*0.3&player.area(8).enemies.infront>4'},
	{Swipe_Pool, 'player.area(8).enemies.infront>7'},
	{Rip_Pool, '{!target.dot(Rip).ticking||{target.dot(Rip).remains<8&target.health>25&!talent(6,1)}&{target.dot(Rip).remains>dot(Rip).tick_time*4&player.combopoints==5}}&{energy.time_to_max<1||player.buff(Berserk)||player.buff(Incarnation: King of the Jungle)||player.spell(Tiger\'s Fury).cooldown<3||{talent(6,2)&player.buff(Clearcasting)}||talent(5,1)||!target.dot(Rip).ticking||{target.dot(Rake).remains<1.5&player.area(8).enemies.infront<6}}'},
	{Savage_Roar_Pool, 'talent(6,3)&{{{player.buff(Savage Roar).duration<20.5&talent(5,3)}||{player.buff(Savage Roar).duration<8.2&!talent(5,3)}}&player.combopoints==5&{energy.time_to_max<1||player.buff(Berserk)||player.buff(Incarnation: King of the Jungle)||player.spell(Tiger\'s Fury).cooldown<3||player.buff(Clearcasting)||talent(5,1)||!target.debuff(Rip)||{target.debuff(Rake).duration<1.5&player.area(8).enemies.infront<6}}}'},
	{'Swipe', 'player.combopoints==5&{player.area(8).enemies.infront>5||{player.area(8).enemies.infront>2&!talent(7,2)}}&player.combopoints==5&{energy.time_to_max<1||player.buff(Berserk)||player.buff(Incarnation: King of the Jungle)||player.spell(Tiger\'s Fury).cooldown<3||{talent(6,2)&player.buff(Clearcasting)}}'},
	{'Ferocious Bite', 'energy.deficit==0&player.combopoints==5&{energy.time_to_max<1||player.buff(Berserk)||player.buff(Incarnation: King of the Jungle)||player.spell(Tiger\'s Fury).cooldown<3||{talent(6,2)&player.buff(Clearcasting)}}', 'target'},
}

local Generator = {
	{'Brutal Slash', 'player.combopoints<5', 'target'},
	{'!Ashamane\'s Frenzy', 'player.combopoints<3&toggle(Cooldowns)&{talent(7,2&player.buff(Bloodtalons)||!talent(7,2)}&{talent(6,3&player.buff(Savage Roar)||!talent(6,3)}', 'target'},
	{'Elune\'s Guidance', 'player.combopoints==0&player.energy<action(Ferocious Bite).cost+25-energy.regen*player.spell(Elune\'s Guidance).cooldown', 'player'},
	{'Elune\'s Guidance', 'player.combopoints==0&player.energy>=action(Ferocious Bite).cost+25', 'player'},
	{Thrash_Pool, 'talent(7,1)&player.area(8).enemies.infront>8'},
	{Swipe_Pool, 'player.area(8).enemies.infront>5'},
	{Rake_Pool, 'player.combopoints<5&{!target.dot(Rake).ticking||{!talent(7,2)&target.dot(Rake).remains<target.dot(Rake).duration*0.3}||{talent(7,2)&player.buff(Bloodtalons)&{!talent(5,1)&target.dot(Rake).remains<8||target.dot(Rake).remains<6}}}&target.dot(Rake).remains>dot(Rake).tick_time'},
	{Moonfire_Pool, 'talent(1,2)&player.combopoints<5&target.dot(Moonfire).remains<5.2&target.dot(Moonfire).remains>dot(Moonfire).tick_time*2'},
	{Thrash_Pool, 'target.dot(Thrash).remains<=target.dot(Thrash).duration*0.3&player.area(8).enemies.infront>1'},
	{'Swipe', 'player.combopoints<5&player.area(8).enemies.infront>2', 'target'},
	{'Shred', 'player.combopoints<5&{player.area(8).enemies.infront<3||talent(7,1)}', 'target'},
}

local xCombat = {
	{Finisher},
	{Generator},
}

local Survival = {
	{Bear_Healing, 'talent(3,2)&player.incdmg(5)>player.health.max*0.20&!player.buff(Frenzied Regeneration)'},
	--{'/run CancelShapeshiftForm()', 'form>0&talent(3,3)&!player.buff(Rejuvenation)'},
	--{'Rejuvenation', 'talent(3,3)&!player.buff(Rejuvenation)', 'player'},
	{'/run CancelShapeshiftForm()', 'cooldown(Swiftmend).up.&form>0&talent(3,3)&player.health<=UI(swiftm_spin)&UI(swiftm_check)'},
	{'Swiftmend', 'talent(3,3)&health<=UI(swiftm_spin)&UI(swiftm_check)', 'player'}
}

local inCombat = {
	{Fel_Explosives, 'inMelee'},
	{Keybinds},
	{Interrupts, 'target.interruptAt(70)&toggle(Interrupts)&target.inFront&target.inMelee'},
	{Interrupts_Random},
	{Survival, 'player.health<100'},
	{'Cat Form', 'toggle(xFORM)&!buff(Frenzied Regeneration)&!buff&!buff(Travel Form)', 'player'},
	{Cooldowns, '!player.buff(Frenzied Regeneration)&toggle(Cooldowns)'},
	{Moonfire_Pool, 'talent(1,2)&!target.inMelee&target.range<50&target.inFront&!player.buff(Prowl)&!target.debuff(Moonfire)'},
	{xCombat, '!player.buff(Frenzied Regeneration)&target.inMelee&target.inFront'},
}

local outCombat = {
	{Keybinds},
	{PreCombat},
	{Interrupts, 'target.interruptAt(70)&toggle(Interrupts)&target.inFront&target.inMelee'},
	{Interrupts_Random},
}

NeP.CR:Add(103, {
	name = '[|cff'..Zylla.addonColor..'Zylla\'s|r] Druid - Feral',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	gui_st = {title='Zylla\'s Combat Routines', width='256', height='520', color='A330C9'},
	ids = Zylla.SpellIDs[Zylla.Class],
	wow_ver = Zylla.wow_ver,
	nep_ver = Zylla.nep_ver,
	load = exeOnLoad
})
