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
	{type = 'header',  	size = 16, text = 'Keybinds',	 																				align = 'center'},
	{type = 'checkbox',	text = 'Left Shift: '..Zylla.ClassColor..'Pause|r',										align = 'left', 		key = 'lshift', 	default = true},
	{type = 'checkbox',	text = 'Left Ctrl: '..Zylla.ClassColor..'Divine Steed|r',							align = 'left', 		key = 'lcontrol',	default = true},
	{type = 'checkbox',	text = 'Left Alt: '..Zylla.ClassColor..'|r',													align = 'left', 		key = 'lalt', 		default = true},
	{type = 'checkbox',	text = 'Right Alt: '..Zylla.ClassColor..'|r',													align = 'left', 		key = 'ralt', 		default = true},
	{type = 'spacer'},
--{type = 'checkbox', text = 'Enable Chatoverlay', 																					key = 'chat', 			width = 55, 			default = true, desc = Zylla.ClassColor..'This will enable some messages as an overlay!|r'},
	unpack(PayPal_GUI),
	{type = 'spacer'},
	unpack(PayPal_IMG),
	{type = 'ruler'},	 	{type = 'spacer'},
	-- Settings
	{type = 'header', 	text = 'Class Settings', 																							align = 'center'},
	{type = 'checkspin',text = 'Light\'s Judgment - Units', 																	key = 'LJ',					spin = 4, step = 1, max = 20, check = true,	desc = Zylla.ClassColor..'World Spell usable on Argus.|r'},
	{type = 'checkbox', text = 'Blessing of Kings', 																					key = 'BoK', 				default = true},
	{type = 'checkbox', text = 'Blessing of Wisdom', 																					key = 'BoW', 				default = true, desc = Zylla.ClassColor..'Check to Enable Blessings on yourself.|r'},
	{type = 'checkbox', text = 'Use Every Man for Himself', 																	key = 'EMfH', 			default = true},
	{type = 'checkbox', text = 'Use Blessing of Freedom', 																		key = 'BoF', 				default = true},
	{type = 'checkbox', text = 'Use Trinket #1', 																							key = 'trinket1',		default = true},
	{type = 'checkbox', text = 'Use Trinket #2', 																							key = 'trinket2', 	default = true,	desc = Zylla.ClassColor..'Trinkets will be used whenever possible!|r'},
	{type = 'ruler'},		{type = 'spacer'},
	-- Survival
	{type = 'header', 	text = 'Survival', 																										align = 'center'},
	{type = 'checkspin',text = 'Use Gift of the Naaru', 																			key = 'GotN', 		spin = 40, step = 5, max = 100, check = true},
	{type = 'checkspin',text = 'Use Lay on Hands', 																						key = 'LoH', 			spin = 10, step = 5, max = 100, check = true},
	{type = 'checkspin',text = 'Use Flash of Light', 																					key = 'FoL', 			spin = 40, step = 5, max = 100, check = true},
	{type = 'checkspin',text = 'Use Shield of Vengeance', 																		key = 'SoV', 			spin = 75, step = 5, max = 100, check = true},
	{type = 'checkspin',text = 'Enable Eye for an Eye', 																			key = 'EfaE', 		spin = 90, step = 5, max = 100, check = true},
	{type = 'checkspin',text = 'Healthstone',																									key = 'HS',				spin = 45, step = 5, max = 100, check = true},
	{type = 'checkspin',text = 'Healing Potion',																							key = 'AHP',			spin = 45, step = 5, max = 100, check = true},
	{type = 'ruler'},		{type = 'spacer'},
	-- Group Assistance
	{type = 'header', 	text = 'Emergency Group Assistance', 																	align = 'center'},
	{type = 'checkspin',text = 'Flash of Light', 																							key = 'G_FoL', 		spin = 35, step = 5, max = 100, check = false},
	{type = 'checkspin',text = 'Lay on Hands', 																								key = 'G_LoH', 		spin = 10, step = 5, max = 100, check = false},
	{type = 'checkspin',text = 'Blessing of Protection', 																			key = 'G_BoP', 		spin = 10, step = 5, max = 100, check = false},
	{type = 'checkbox',	text = 'BoP on Tanks',																				key = 'G_BoP_T', default = false},
	{type = 'checkbox',	text = 'Dispel Party Members',																				key = 'disAll', 	default = true},
	{type = 'checkbox', text = 'Use Blessing of Freedom', 																		key = 'G_BoF', 		default = false},
	{type = 'ruler'},		{type = 'spacer'},
	unpack(Mythic_GUI),
}

local exeOnLoad = function()
	Zylla.ExeOnLoad()
	Zylla.AFKCheck()
	print(Zylla.ClassColor..' ----------------------------------------------------------------------|r')
	print(Zylla.ClassColor..' --- |rPaladin: |cfff58cbaRETRIBUTION|r')
	print(Zylla.ClassColor..' --- |rTalents: 1/2 - 2/2 - 3/1 - 4/2 - 5/2 - 6/1 - 7/2|r')
	print(Zylla.ClassColor..' ----------------------------------------------------------------------|r')
	print('|cffff0000 Configuration: |rRight-click the MasterToggle and go to Combat Routines Settings|r')

	NeP.Interface:AddToggle({
		-- Dispels
		key = 'dispels',
		name = 'Cleanse Toxin',
		text = 'Enable/Disable: Automatic removal of Poison and Diseases',
		icon = 'Interface\\ICONS\\spell_holy_renew',
	})

	NeP.Interface:AddToggle({
		-- Group Healing
		key = 'groupAssist',
		name = 'Group Assistance',
		text = 'Enable/Disable: Automatic LoH/BoP/FoL on Party Members',
		icon = 'Interface\\ICONS\\spell_shadow_darksummoning',
	})

	NeP.Interface:AddToggle({
	 key = 'xIntRandom',
	 name = 'Interrupt Anyone',
	 text = 'Interrupt all nearby enemies, without targeting them.',
	 icon = 'Interface\\Icons\\inv_ammo_arrow_04',
 })

end

local Keybinds = {
	{'%pause', 'keybind(lshift)&UI(lshift)'},
	{'Divine Steed', 'keybind(lcontrol)', 'player'}
}

local Survival = {
	{'!Flash of Light', 'player.movingfor<0.75&UI(FoL_check)&health<=UI(FoL_spin)', 'player'},
	{'!Lay on Hands', 'UI(LoH_check)&health<=UI(LoH_spin)', 'player'},
	{'!Shield of Vengeance', 'UI(SoV_check)&health<=UI(SoV_spin)', 'player'},
	{'Eye for an Eye', 'UI(EfaE_check)&health<=UI(EfaE_spin)', 'player'},
	{'&Every Man for Himself', 'UI(EMfH)&state(stun)', 'player'},
	{'!Blessing of Freedom', 'UI(BoF)&{state(root)||state(snare)}' ,'player'},
	{'&Gift of the Naaru', 'UI(GotN_check)&health<=UI(GotN_spin)' ,'player'},
	{'#127834', 'item(127834).usable&item(127834).count>0&health<=UI(AHP_spin)&UI(AHP_check)'}, 		-- Ancient Healing Potion
	{'#5512', 'item(5512).usable&item(5512).count>0&health<=UI(HS_spin)&UI(HS_check)', 'player'} 		--Health Stone
}

local Group = {
	{'!Flash of Light', 'UI(G_FoL_check)&health<=UI(G_FoL_spin)', 'lowest'},
	{'!Lay on Hands', 'UI(G_LoH_check)&health<=UI(G_LoH_spin)', 'lowest'},
	{'!Blessing of Protection', 'UI(G_BoP_check)&health<=UI(G_BoP_spin)&UI(G_BoP_T}', 'lowest'},
	{'!Blessing of Protection', 'UI(G_BoP_check)&health<=UI(G_BoP_spin)&!UI(G_BoP_T}&!lowest.role(tank)', 'lowest'},
	{'!Blessing of Freedom', 'player.ingroup&target.ingroup&range<41&UI(G_BoF)&{state(root)||state(snare)}' ,'friendly'},
}

local Interrupts = {
	{'!Rebuke', 'inFront&inMelee', 'target'},
	{'!Hammer of Justice', '!equipped(137065)&range<20&player.spell(Rebuke).cooldown>gcd&!player.lastgcd(Rebuke)', 'target'},
	{'!Hammer of Justice', 'equipped(137065)&health>74&range<20&player.spell(Rebuke).cooldown>gcd&!player.lastgcd(Rebuke)', 'target'},
	{'!Blinding Light', 'range<20&spell(Rebuke).cooldown>gcd&!player.lastgcd(Rebuke)', 'target'},
	{'!Arcane Torrent', 'inMelee&spell(Rebuke).cooldown>gcd&!player.lastgcd(Rebuke)', 'target'}
}

local Interrupts_Random = {
	{'!Rebuke', 'inFront&inMelee', 'enemies'},
	{'!Hammer of Justice', '!equipped(137065)&range<20&player.spell(Rebuke).cooldown>gcd&!player.lastgcd(Rebuke)', 'enemies'},
	{'!Hammer of Justice', 'equipped(137065)&health>74&range<20&player.spell(Rebuke).cooldown>gcd&!player.lastgcd(Rebuke)', 'enemies'},
	{'!Blinding Light', 'player.spell(Rebuke).cooldown>gcd&!prev_gcd(Rebuke)&!immune(Stun)&inFront&range<20', 'enemies'},
	{'!Arcane Torrent', 'player.spell(Rebuke).cooldown>gcd&!prev_gcd(Rebuke)&!immune(Stun)&inFront&inMelee', 'enemies'}
}

local Dispel = {
	{'%dispelSelf'},
	{'%dispelAll', 'UI(DisAll)'}
}

local Blessings = {
	{'Greater Blessing of Kings', 'UI(BoK)&!buff', 'player'},
	{'Greater Blessing of Wisdom', 'UI(BoW)&!buff', 'player'}
}

local Cooldowns = {
	{'&Arcane Torrent', 'player.holypower<=4&{player.buff(Crusade)||player.buff(Avenging Wrath)||xtime<2}', 'target'},
	{'Holy Wrath', 'toggle(aoe)&player.area(8).enemies>=2&player.health<51', 'target'},
	{'&Avenging Wrath', nil, 'target'},
	{'&Crusade', 'holypower>=5&!equipped(137048)||{{equipped(137048)||race(Blood Elf)}&holypower>=2}', 'player'},
	{'Light\'s Judgment', 'UI(LJ_check)&range<61&area(15).enemies>=UI(LJ_spin)', 'enemies.ground'}
}

local Trinkets = {
	{{
	--Trinket 1
	--voct
	{'#trinket1', '{player.buff(Crusade).count>=15||{!player.buff(Crusade)&spell(Crusade).cooldown>=40}}&!combat(player).time<5&trinket.id(13) == 147011&target.range<8&target.infront'},
	--{'#trinket1', '!boss&trinket1.id == 147011&target.range<8&target.infront'},
	--moonglaives
	{'#trinket1', '{player.buff(Crusade).count>=15||player.area(5).enemies>=3}&trinket.id(13) == 147012'},
	--generic trinket wait for crusade
	{'#trinket1', 'player.spell(Crusade).cooldown>=60&!{trinket.id(13) == 147011||trinket.id(13) == 147012}}',
	},'UI(trinket1)'},
	{{
	--Trinket 2
	--voct
	{'#trinket2', '{player.buff(Crusade).count>=15||{!player.buff(Crusade)&spell(Crusade).cooldown>=40}}&!combat(player).time<5&trinket.id(14) == 147011&target.range<8&target.infront'},
	--{'#trinket2', '!boss&trinket2.id == 147011&target.range<8&target.infront'},
	--moonglaives
	{'#trinket2', '{player.buff(Crusade).count>=15||player.area(5).enemies>=3}&trinket.id(14) == 147012'},
	--generic trinket wait for crusade
	{'#trinket2', 'player.spell(Crusade).cooldown>=60&!{trinket.id(14) == 147011||trinket.id(14) == 147012}'},
	},'UI(trinket2)'}
}
local DS_Castable = {
	{'Divine Storm', 'toggle(aoe)&.debuff(Judgment)&player.buff(Divine Purpose).duration<gcd*2', 'target'},
	{'Divine Storm', 'toggle(aoe)&.debuff(Judgment)&player.holypower>=5&player.buff(Divine Purpose)', 'target'},
	{'Divine Storm', 'toggle(aoe)&.debuff(Judgment)&player.holypower>=5&{!talent(7,2)||player.buff(Crusade).duration>gcd*3}', 'target'},
	{'Divine Storm', 'toggle(aoe)&player.spell(Wake of Ashes).cooldown<gcd*2', 'target'},
	{'Divine Storm', 'toggle(aoe)&player.buff(Whisper of the Nathrezim).duration<gcd*1.5&{!talent(7,2)||player.buff(Crusade).duration>gcd*3}', 'target'},
	{'Divine Storm', 'toggle(aoe)&player.buff(Divine Purpose)', 'target'},	-- Might Get removed...
	{'Divine Storm', 'toggle(aoe)&player.buff(The Fires of Justice)&{!talent(7,2)||player.buff(Crusade).duration>gcd*3}', 'target'},
	{'Divine Storm', 'toggle(aoe)&player.holypower>=3&{player.spell(Judgment).cooldown&!debuff(Judgment)}', 'target'} -- Attempt to fix target-issue with Judgment
}

local Templar = {
	{'Templar\'s Verdict', 'debuff(Judgment)&player.buff(Divine Purpose).duration<gcd*2', 'target'},
	{'Templar\'s Verdict', 'debuff(Judgment)&player.holypower>=5&player.buff(Divine Purpose)', 'target'},
	{'Templar\'s Verdict', 'debuff(Judgment)&player.holypower>=3&{player.buff(Crusade).stack<15|||player.buff(137048)}', 'target'},
	{'Templar\'s Verdict', 'debuff(Judgment)&player.holypower>=5&{!equipped(137048)||{equipped(137048)&||player.race(Blood Elf)}}', 'target'},
	{'Templar\'s Verdict', '{equipped(137020)||debuff(Judgment)}&player.spell(Wake of Ashes).cooldown<gcd*2&{!talent(7,2)||player.buff(Crusade).duration>gcd*3}', 'target'},
	{'Templar\'s Verdict', 'debuff(Judgment)&player.buff(Whisper of the Nathrezim).duration<gcd*1.5&{{!talent(7,2)||player.buff(Crusade).duration>gcd*3}}', 'target'},
	{'Templar\'s Verdict', 'player.holypower>=3&{player.spell(Judgment).cooldown&!debuff(Judgment)}', 'target'} -- Attempt to fix target-issue with Judgment
}


local Combat = {
	{DS_Castable, 'player.area(6).enemies>=2||{player.buff(Scarlet Inquisitor\'s Expurgation).stack>=29}&{player.buff(Avenging Wrath)||{player.buff(Crusade).stack>=15}||{player.spell(Crusade).cooldown>15&!player.buff(Crusade)}||player.spell(Avenging Wrath).cooldown>15}'},
	{Templar},
	{'Execution Sentence','player.area(6).enemies<=3&{player.spell(Judgment).cooldown<gcd*4.5||debuff(Judgment).duration>gcd*4.5}', 'target'},
	{'Divine Storm', 'toggle(aoe)&debuff(Judgment)&player.area(6).enemies>=2&player.holypower>=3&{player.buff(Crusade).stack<15||player.buff(137048)}', 'target'},
	{'Justicar\'s Vengeance', 'debuff(Judgment)&player.buff(Divine Purpose)&!equipped(137020)', 'target'},
	{'Justicar\'s Vengeance', 'debuff(Judgment)&player.holypower>=5&player.buff(Divine Purpose)&!equipped(137020)', 'target'},
	{'Judgment', 'debuff(Execution Sentence).duration<gcd*2&debuff(Judgment).duration<gcd*2', 'target'},
	{'Consecration', 'toggle(aoe)&{player.spell(Blade of Justice).cooldown>gcd*2||player.spell(Divine Hammer).cooldown>gcd*2}'},
	{'Wake of Ashes', 'toggle(aoe)&{player.holypower==0||player.holypower==1&{player.spell(Blade of Justice).cooldown>gcd||player.spell(Divine Hammer).cooldown>gcd}||player.holypower==2&{{player.spell(Zeal).charges<=0.65||player.spell(Crusader Strike).charges<=0.65}}}', 'target'},
	{'Blade of Justice', 'player.holypower<=3-set_bonus(T20)', 'target'},
	{'Divine Hammer', 'toggle(aoe)&player.holypower<=3-set_bonus(T20)', 'target'},
	{'Hammer of Justice', 'equipped(137065)&health>=75&player.holypower<=4', 'target'},
	{'Hammer of Justice', 'player.holypower<=5&equipped(137065)&health>74', 'target'},
	{'Zeal', 'player.spell(Zeal).charges>=1.65&player.holypower<=4&{player.spell(Blade of Justice).cooldown>gcd*2||player.spell(Divine Hammer).cooldown>gcd*2}&debuff(Judgment).duration>gcd', 'target'},
	{'Zeal', 'player.holypower<=4||{player.spell(Judgment).cooldown&!debuff(Judgment)}', 'target'},
	{'Crusader Strike', 'player.spell(Crusader Strike).charges>=1.65-talent(2,1).enabled*0.25&player.holypower<=4&{player.spell(Blade of Justice).cooldown>gcd*2||player.spell(Divine Hammer).cooldown>gcd*2}&debuff(Judgment).duration>gcd', 'target'},
	{'Crusader Strike', 'player.holypower<=4||{player.spell(Judgment).cooldown&!debuff(Judgment)}', 'target'}
}

local Opener = {
	{'Judgment', 'enemy&range<=30&inFront', 'target'},
	{'Blade of Justice', 'enemy&range<=12&inFront&{equipped(137048)||player.race(Blood Elf)||player.spell(Wake of Ashes).cooldown}' ,'target'},
	{'Divine Hammer', 'toggle(aoe)&inMelee&inFront&enemy&{equipped(137048)||player.race(Blood Elf)||player.spell(Wake of Ashes).cooldown}', 'target'},
	{'Wake of Ashes', 'toggle(aoe)&inMelee&inFront', 'target'}
}

local inCombat = {
	{Keybinds},
	{Dispel, 'toggle(dispels)&!player.spell(Cleanse Toxins).cooldown'},
	{Survival},
	{Blessings},
	{Opener, 'inMelee&inFront&xtime<2&{player.spell(Judgment).cooldown<gcd||player.spell(Blade of Justice).cooldown<gcd||player.spell(Wake of Ashes).cooldown<gcd}'},
	{Mythic_Plus, 'inMelee'},
	{Trinkets},
	{Combat, 'enemy&inMelee&inFront'},
	{Group, 'player.movingfor<0.75&inGroup&toggle(groupAssist)'},
	{Interrupts_Random, 'toggle(xIntRandom)&toggle(interrupts)&interruptAt(70)'},
	{Interrupts, 'toggle(interrupts)&interruptAt(70)'},
	{Cooldowns, 'toggle(cooldowns)&inMelee'}
}

local outCombat = {
	{Keybinds},
	{Dispel, 'toggle(dispels)&!spell(Cleanse Toxins).cooldown'},
	{Interrupts_Random},
	{Interrupts, 'toggle(interrupts)&inFront&interruptAt(70)'},
	{Blessings},
	{Group, 'player.movingfor<0.75&inGroup&toggle(groupAssist)'},
	{'Flash of Light', 'player.movingfor<0.75&player.health<90&UI(FoL_check)', 'player'}
}

NeP.CR:Add(70, {
	name = '[|cff'..Zylla.addonColor..'Zylla\'s|r] Paladin - Retribution',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	gui_st = {title='Zylla\'s Combat Routines', width='256', height='760', color='A330C9'},
	ids = Zylla.SpellIDs[Zylla.Class],
	wow_ver = Zylla.wow_ver,
	nep_ver = Zylla.nep_ver,
	load = exeOnLoad
})
