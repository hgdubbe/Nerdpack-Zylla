local _, Zylla = ...

Zylla.Version = '1.9'
Zylla.Branch = 'RELEASE'
Zylla.Name = 'NerdPack - Zylla\'s Rotations'
Zylla.Author = 'Zylla'
Zylla.addonColor = '8801c0'
Zylla.wow_ver = '7.3.0'
Zylla.nep_ver = '1.8'
Zylla.spell_timers = {}
Zylla.isAFK = false;

local Parse = NeP.DSL.Parse
--local Fetch = NeP.Interface.fetchKey

local Zframe = CreateFrame('GameTooltip', 'Zylla_ScanningTooltip', UIParent, 'GameTooltipTemplate')

Zylla.Class = select(3,UnitClass("player"))

-- Toggles off the CR if the player becomes AFK.
-- And toggle back on when player is un-AFKed.
function Zylla.onFlagChange()
  if (UnitIsAFK("player") and not Zylla.isAFK) then
    -- Player has become AFK
    if (C_PetBattles.IsInBattle()==false) then
      -- This should contain the stuff to execute when player is flagged AFK
      NeP.Interface:toggleToggle('mastertoggle')
    end
    DEFAULT_CHAT_FRAME:AddMessage("Player is AFK. Stopping Zylla's Rotation.");
    Zylla.isAFK = true;
  elseif (not UnitIsAFK("player") and Zylla.isAFK) then
    -- Player has been flagged un-AFK
    -- This should contain the stuff to execute when player is flagged as not AFK
    NeP.Interface:toggleToggle('mastertoggle')
    DEFAULT_CHAT_FRAME:AddMessage("Player is unAFK. Restarting Zylla's Rotation.")
    Zylla.isAFK = false;
  -- else
  -- Player's flag change concerned DND, not becoming AFK or un-AFK
  end
end

function Zylla.AFKCheck()
  local frame = CreateFrame("FRAME", "AfkFrame");
  frame:RegisterEvent("PLAYER_FLAGS_CHANGED"); -- "PLAYER_FLAGS_CHANGED" This will trigger when the player becomes unAFK and unDND
  frame:SetScript("OnEvent", Zylla.onFlagChange);
end

--[[
 --Different Classes Taunt Abilities
local classTaunt = {
  [1] = 'Taunt',
  [2] = 'Hand of Reckoning',
  [6] = 'Dark Command',
  [10] = 'Provoke',
  [11] = 'Growl',
  [12] = 'Torment'
}
]]--

function Zylla.ExeOnLoad()
  print('|cffFFFB2F ----------------------------------------------------------------------|r')
  print('|cffFFFB2F Thank you for selecting Zylla\'s Combat Routines for NerdPack!|r')
  print('|cffFFFB2F Some routines require tweaking the settings to perform optimal.|r')
  print('|cffFFFB2F If you encounter errors, bugs, or you simply have a suggestion,|r')
  print('|cffFFFB2F i recommend that you visit the GitHub repo.|r')
  print('|cffFFFB2F You can also get support from the NerdPack community on Discord.|r')
  print('|cffFFFB2F ----------------------------------------------------------------------|r')

	Zylla.Splash() -- Call the Splash-screen on all CR's...

end

function Zylla.ExeOnUnload()
  print('|cffFFFB2F Thank you for using Zylla\'s Combat Routines.|r')
end

-- Global Variables used on many if not all routines.
--[[
_G['Zylla.Blacklist'] = {
units = {"UNIT_ID", ####},
buffs = {{name = "special_buff", count = 2}, "special_buff", ####},
debuff = {####, ####, ####}
--]]
_G['Zylla.Trinkets'] = {
  {'#trinket1', 'UI(kT1)'},
  {'#trinket2', 'UI(kT2)'},
  {'#142173', 'equipped(142173)&!player.debuff(Temptation)&UI(kRoCF)', 'target'},  --Ring of Collapsing Futures
}

_G['Zylla.Heirlooms'] = {
  {'#122664', 'equipped(122664)&UI(k_HEIR)&player.health<=UI(k_HeirHP)'},
  {'#122663', 'equipped(122663)&UI(k_HEIR)&player.health<=UI(k_HeirHP)'},
  {'#122666', 'equipped(122666)&UI(k_HEIR)&player.health<=UI(k_HeirHP)'},
  {'#122667', 'equipped(122667)&UI(k_HEIR)&player.health<=UI(k_HeirHP)'},
  {'#122668', 'equipped(122668)&UI(k_HEIR)&player.health<=UI(k_HeirHP)'},
  {'#128318', 'equipped(128318)&UI(k_HEIR)&player.area(8).enemies>=3'},
  {'#122530', 'equipped(122530)&UI(k_HEIR)&player.incdmg(2.5)>player.health.max*0.50'},
  {'#44098', 'equipped(44098)&UI(k_HEIR)&{player.state.incapacitate||player.state.stun||player.state.fear||player.state.horror||player.state.sleep||player.state.charm}'},
  {'#44097', 'equipped(44097)&UI(k_HEIR)&{player.state.incapacitate||player.state.stun||player.state.fear||player.state.horror||player.state.sleep||player.state.charm}'},
  {'#126949', 'equipped(126949)&UI(k_HEIR)&{player.incdmg(2.5)>player.health.max*0.50}||{player.health<=20}'},
  {'#126948', 'equipped(126948)&UI(k_HEIR)&{player.incdmg(2.5)>player.health.max*0.50}||{player.health<=20}'},
}

_G['Zylla.Util'] = {
  {'%pause' , 'player.debuff(200904)||player.debuff(Sapped Soul)'}, -- Vault of the Wardens, Sapped Soul
}

function Zylla.Taunt(eval, args)
  local spell = NeP.Engine:Spell(args)
  if not spell then return end
  for i=1,#NeP.OM['unitEnemie'] do
    local Obj = NeP.OM['unitEnemie'][i]
    local Threat = UnitThreatSituation('player', Obj.key)
    if Threat and Threat >= 0 and Threat < 3 and Obj.distance <= 30 then
      eval.spell = spell
      eval.target = Obj.key
      return NeP.Engine:STRING(eval)
    end
  end
end

function Zylla.Round(num, idp)
  if num then
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
  else
    return 0
  end
end

function Zylla.ShortNumber(number)
  local affixes = { "", "k", "m", "b", }
  local affix = 1
  local dec = 0
  local num1 = math.abs(number)
  while num1 >= 1000 and affix < #affixes do
    num1 = num1 / 1000
    affix = affix + 1
  end
  if affix > 1 then
    dec = 2
    local num2 = num1
    while num2 >= 10 do
      num2 = num2 / 10
      dec = dec - 1
    end
  end
  if number < 0 then
    num1 = - num1
  end
  return string.format("%."..dec.."f"..affixes[affix], num1)
end

--------------------------------------------------------------------------------
------------------------------ Auto Dotting ------------------------------------
--------------------------------------------------------------------------------
--/dump GetSpellInfo('Frostbolt')
--/dump UnitDebuff('target', 'Moonfire', "",'PLAYER')
--/dump UnitDebuff('target', 'Chilled', "",'PLAYER')
--spell='Rake', debuff='Infected Wound'

--local _,_,_,_,_,_,debuffDuration = UnitDebuff(Obj.key, debuff, '', 'PLAYER')
--if debuffDuration == nil then debuffDuration = 0 end
--if (debuffDuration - GetTime() < NeP.DSL:Get('gcd')()) then
--print('target: '..Obj.key..'duration: '..NeP.DSL:Get('debuff.duration')(Obj.key, debuff))

function Zylla.AutoDoT(debuff,spellx)
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
    if UnitExists(Obj.key) then
      if (NeP.DSL:Get('combat')(Obj.key) or Obj.isdummy) then
        local objRange = NeP.DSL:Get('range')(Obj.key)
        local _,_,_, cast_time_ms, minRange, maxRange = GetSpellInfo(spellx)
        local cast_time_sec = cast_time_ms / 1000
        if maxRange == 0 then maxRange = 5 end
        --print('spell: '..spellx..' skill range: '..minRange..', '..maxRange..' obj range: '..objRange)
        if (NeP.DSL:Get('infront')(Obj.key) and objRange >= minRange and objRange <= maxRange) then
          local travel_time = Zylla.Round((NeP.DSL:Get('travel_time')(Obj.key, spellx)), 3)
          local _, _, _, lagWorld = GetNetStats()
          local latency = ((((lagWorld / 1000) * 1.1) + (travel_time * 1.25)))
          local debuffDuration = NeP.DSL:Get('debuff.duration')(Obj.key, debuff)
          if (debuffDuration < (NeP.DSL:Get('gcd')() + latency + cast_time_sec)) then
            --print('debuff: '..debuff..' key: '..Obj.key..' duration: '..debuffDuration)
            --print(' lag: '..(lagWorld / 1000)..' traveltime: '..travel_time..' latency: '..latency)
            C_Timer.After(latency, function ()
              if (debuffDuration < (NeP.DSL:Get('gcd')() + cast_time_sec)) then
                --print('/run CastSpellByName("'..spellx..'","'..Obj.key..'")')
                RunMacroText('/run CastSpellByName("'..spellx..'","'..Obj.key..'")')
                --NeP:Queue(debuff, Obj.key)
                return true
              end
            end)
          end
        end
      end
    end
  end
end

--[[
function Zylla.AutoDoT2(debuff)
for _, Obj in pairs(NeP.OM:Get('Enemy')) do
if UnitExists(Obj.key) then
if (NeP.DSL:Get('combat')(Obj.key) or Obj.isdummy) then
local objRange = NeP.DSL:Get('range')(Obj.key)
local _,_,_,_, minRange, maxRange = GetSpellInfo(debuff)
if (NeP.DSL:Get('infront')(Obj.key) and objRange >= minRange and objRange <= maxRange) then
if (NeP.DSL:Get('debuff.duration')(Obj.key, debuff) < NeP.DSL:Get('gcd')()) then
local _, _, _, lagWorld = GetNetStats()
local latency = lagWorld / 1000
C_Timer.After(latency, function ()
if (NeP.DSL:Get('debuff.duration')(Obj.key, debuff) < NeP.DSL:Get('gcd')()) then
NeP:Queue(debuff, Obj.key)
return true
end
end)
end
end
end
end
end
end
--]]
--------------------------------------------------------------------------------
----------------------------------ToolTips--------------------------------------
--------------------------------------------------------------------------------

--/dump Zylla.Scan_SpellCost('Rake')
function Zylla.Scan_SpellCost(spell)
  local spellID = NeP.Core:GetSpellID(spell)
  Zframe:SetOwner(UIParent, 'ANCHOR_NONE')
  Zframe:SetSpellByID(spellID)
  for i = 2, Zframe:NumLines() do
    local tooltipText = _G['Zylla_ScanningTooltipTextLeft' .. i]:GetText()
    return tooltipText
  end
  return false
end

--/dump Zylla.Scan_IgnorePain()
function Zylla.Scan_IgnorePain()
  for i = 1, 40 do
    local qqq = select(11,UnitBuff('player', i))
    if qqq == 190456 then
      Zframe:SetOwner(UIParent, 'ANCHOR_NONE')
      Zframe:SetUnitBuff('player', i)
      local tooltipText = _G['Zylla_ScanningTooltipTextLeft2']:GetText()
      local match = tooltipText:lower():match('of the next.-$')
      return gsub(match, '%D', '') + 0
    end
  end
  return false
end

--------------------------------------------------------------------------------
-------------------------------NeP HoT / DoT API -------------------------------
--------------------------------------------------------------------------------

local function oFilter(owner, spell, spellID, caster)
  if not owner then
    if spellID == tonumber(spell) and (caster == 'player' or caster == 'pet') then
      return false
    end
  elseif owner == 'any' then
    if spellID == tonumber(spell) then
      return false
    end
  end
  return true
end

function Zylla.UnitHot(target, spell, owner)
  local name, count, caster, expires, spellID
  if tonumber(spell) then
    local go, i = true, 0
    while i <= 40 and go do
      i = i + 1
      name,_,_,count,_,duration,expires,caster,_,_,spellID = _G['UnitBuff'](target, i)
      go = oFilter(owner, spell, spellID, caster)
    end
  else
    name,_,_,count,_,duration,expires,caster = _G['UnitBuff'](target, spell)
  end
  -- This adds some random factor
  return name, count, expires, caster
end

function Zylla.UnitDot(target, spell, owner)
  local name, count, caster, expires, spellID, power
  if tonumber(spell) then
    local go, i = true, 0
    while i <= 40 and go do
      i = i + 1
      name,_,_,count,_,duration,expires,caster,_,_,spellID,_,_,_,power = _G['UnitDebuff'](target, i)
      go = oFilter(owner, spell, spellID, caster)
    end
  else
    name,_,_,count,_,duration,expires,caster = _G['UnitDebuff'](target, spell)
  end
  -- This adds some random factor
  return name, count, _, expires, caster, power
end

--------------------------------------------------------------------------------
-------------------------------- WARRIOR ---------------------------------------
--------------------------------------------------------------------------------

--/dump Zylla.getIgnorePain()
function Zylla.getIgnorePain()
  --output
  local matchTooltip = false
  --Rage
  local curRage = UnitPower('player')
  local costs = GetSpellPowerCost(190456)
  local minRage = costs[1].minCost or 20
  local maxRage = costs[1].cost or 60
  local calcRage = math.max(minRage, math.min(maxRage, curRage))

  --attack power
  local apBase, apPos, apNeg = UnitAttackPower('player')

  --Versatility rating
  local vers = 1 + ((GetCombatRatingBonus(29) + GetVersatilityBonus(30)) / 100)

  --Dragon Scales
  local scales = UnitBuff('player', GetSpellInfo(203581)) and 1.6 or 1

  --Never Surrender
  local curHP = UnitHealth('player')
  local maxHP = UnitHealthMax('player')
  local misPerc = (maxHP - curHP) / maxHP
  local nevSur = select(4, GetTalentInfo(5, 2, 1))
  local nevSurPerc = nevSur and (1 + 0.75 * misPerc) or 1

  --Indomitable
  local indom = select(4, GetTalentInfo(5, 3, 1)) and 1.25 or 1

  --T18
  local t18 = UnitBuff("player", GetSpellInfo(12975)) and Zylla.GetNumberSetPieces("T18") >= 4 and 2 or 1

  local curIP = select(17, UnitBuff('player', GetSpellInfo(190456))) or 0
  if matchTooltip then
    curIP = curIP / 0.9 --get the tooltip value instead of the absorb
  end

  local maxIP = (apBase + apPos + apNeg) * 18.6 * vers * indom * scales
  if not matchTooltip then --some TODO notes so i wont forget fix it:
    --maxIP = Zylla.Round(maxIP * 0.9) - missing dragon skin arti passive -> * trait!!! missing 0.02-0.06
    maxIP = Zylla.Round(maxIP * 1.04) -- tooltip value my test with 2/3 dragon skin
    --maxIP = Zylla.Round((maxIP * 0.9) * trait) -- need enable after got arti lib again
  end

  local newIP = Zylla.Round(maxIP * (calcRage / maxRage) * 1 * nevSurPerc * t18) --*t18 *trait instead 1

  local cap = Zylla.Round(maxIP * 3)
  if nevSur then
    cap = cap * 1.75
  end

  local diff = cap - curIP

  local castIP = math.min(diff, newIP)

  local castPerc = Zylla.Round((castIP / cap) * 100)
  local curPerc = Zylla.Round((curIP / cap) * 100)

  return cap, diff, curIP, curPerc, castIP, castPerc, maxIP, newIP, minRage, maxRage, calcRage
    --maxIP = 268634.7
end

--set bonuses
--/dump Zylla.GetNumberSetPieces('T18', 'WARRIOR')
function Zylla.GetNumberSetPieces(set, class)
  class = class or select(2, UnitClass("player"))
  local pieces = Zylla.sets[class][set] or {}
  local counter = 0
  for _, itemID in ipairs(pieces) do
    if IsEquippedItem(itemID) then
      counter = counter + 1
    end
  end
  return counter
end

Zylla.sets = {
  ["WARRIOR"] = {
    ["T18"] = {
      124319,
      124329,
      124334,
      124340,
      124346,
    },
  },
}

--------------------------------------------------------------------------------
-------------------------------- WARLOCK ---------------------------------------
--------------------------------------------------------------------------------

Zylla.durations = {}
Zylla.durations["Wild Imp"] = 12
Zylla.durations["Dreadstalker"] = 12
Zylla.durations["Imp"] = 25
Zylla.durations["Felhunter"] = 25
Zylla.durations["Succubus"] = 25
Zylla.durations["Felguard"] = 25
Zylla.durations["Darkglare"] = 12
Zylla.durations["Doomguard"] = 25
Zylla.durations["Infernal"] = 25
Zylla.durations["Voidwalker"] = 25

Zylla.active_demons = {}
Zylla.empower = 0
Zylla.demon_count = 0

Zylla.minions = {"Wild Imp", "Dreadstalker", "Imp", "Felhunter", "Succubus", "Felguard", "Darkglare", "Doomguard", "Infernal", "Voidwalker"}

function Zylla.update_demons()
  --print('Zylla.update_demons')
  for key,_ in pairs(Zylla.active_demons) do
    if (Zylla.is_demon_dead(Zylla.active_demons[key].name, Zylla.active_demons[key].time)) then
      Zylla.active_demons[key] = nil
      Zylla.demon_count = Zylla.demon_count - 1
      --Zylla.sort_demons()
    end
  end
end

function Zylla.is_demon_empowered(guid)
  --print('Zylla.is_demon_empowered')
  if (Zylla.active_demons[guid].empower_time ~= 0 and GetTime() - Zylla.active_demons[guid].empower_time <= 12) then
    return true
  end
  return false
end

function Zylla.count_active_demon_type(demon)
  --print('Zylla.count_active_demon_type')
  local count = 0
  for _,v in pairs(Zylla.active_demons) do
    if v.name == demon then
      count = count + 1
    end
  end
  return count
end

function Zylla.remaining_duration(demon)
  --print('Zylla.remaining_duration')
  for _,v in pairs(Zylla.active_demons) do
    if v.name == demon then
      return Zylla.get_remaining_time(v.name, v.time)
    end
  end
end

function Zylla.implosion_cast()
  --print('Zylla.implosion_cast')
  for key,_ in pairs(Zylla.active_demons) do
    if (Zylla.active_demons[key].name == "Wild Imp") then
      Zylla.active_demons[key] = nil
      Zylla.demon_count = Zylla.demon_count - 1
      --Zylla.sort_demons()
    end
  end
end

function Zylla.is_demon_dead(name, spawn)
  --print('Zylla.is_demon_dead')
  if (Zylla.get_remaining_time(name, spawn) <= 0) then
    return true
  end
  return false
end

function Zylla.get_remaining_time(name, spawn)
  --print('Zylla.get_remaining_time')
  if name == 'Empower' then
    return 12 - (GetTime() - spawn)
  else
    return Zylla.durations[name] - (GetTime() - spawn)
  end
end

function Zylla.IsMinion(name)
  --print('Zylla.IsMinion')
  for i = 1, #Zylla.minions do
    if (name == Zylla.minions[i]) then
      return true
    end
  end
  return false
end

--------------------------------------------------------------------------------
--------------------------------- PRIEST ---------------------------------------
--------------------------------------------------------------------------------

Zylla.Voidform_Summary = true
Zylla.S2M_Summary = true

--Zylla.Voidform_Drain_Stacks = 0
--Zylla.Voidform_Current_Drain_Rate = 0
--Zylla.SA_TOTAL = 0

function Zylla.SA_Cleanup(guid)
  if Zylla.SA_STATS[guid] then
    Zylla.SA_TOTAL = Zylla.SA_TOTAL - Zylla.SA_STATS[guid].Count
    if Zylla.SA_TOTAL < 0 then
      Zylla.SA_TOTAL = 0
    end
    Zylla.SA_STATS[guid].Count = nil
    Zylla.SA_STATS[guid].LastUpdate = nil
    Zylla.SA_STATS[guid] = nil
    Zylla.SA_NUM_UNITS = Zylla.SA_NUM_UNITS - 1
    if Zylla.SA_NUM_UNITS < 0 then
      Zylla.SA_NUM_UNITS = 0
    end
  end
end

NeP.Listener:Add('Zylla.SA', 'COMBAT_LOG_EVENT_UNFILTERED', function(_,combatevent,_,sourceGUID,_,_,_,destGUID,_,_,_,spellid,_,_,_,_,_,_,_,_,_,_,_,_,_)
  if Zylla.class == 5 then
    local CurrentTime = GetTime()
    Zylla.SA_NUM_UNITS = Zylla.SA_NUM_UNITS or 0
    Zylla.SA_TOTAL     = Zylla.SA_TOTAL or 0
    -- Stats buffer
    Zylla.SA_STATS     = Zylla.SA_STATS or {}
    Zylla.SA_DEAD      = Zylla.SA_DEAD or {}
    Zylla.LAST_CONTINUITY_CHECK = Zylla.LAST_CONTINUITY_CHECK or GetTime()
    if sourceGUID == UnitGUID("player") then
      if spellid == 147193 and combatevent == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
        if not Zylla.SA_STATS[destGUID] or Zylla.SA_STATS[destGUID] == nil then
          Zylla.SA_STATS[destGUID]       = {}
          Zylla.SA_STATS[destGUID].Count = 0
          Zylla.SA_NUM_UNITS             = Zylla.SA_NUM_UNITS + 1
      end
      Zylla.SA_TOTAL = Zylla.SA_TOTAL + 1
      --print('SA spawn :'..Zylla.SA_TOTAL..' remaining SA')
      Zylla.SA_STATS[destGUID].Count      = Zylla.SA_STATS[destGUID].Count + 1
      Zylla.SA_STATS[destGUID].LastUpdate = CurrentTime
      elseif spellid == 148859 and combatevent == "SPELL_DAMAGE" then --Auspicious Spirit Hit
        if Zylla.SA_TOTAL < 0 then
          Zylla.SA_TOTAL = 0
      else
        Zylla.SA_TOTAL = Zylla.SA_TOTAL - 1
      end
      --print('SA hit :'..Zylla.SA_TOTAL..' remaining SA')
      if Zylla.SA_STATS[destGUID] and Zylla.SA_STATS[destGUID].Count > 0 then
        Zylla.SA_STATS[destGUID].Count      = Zylla.SA_STATS[destGUID].Count - 1
        Zylla.SA_STATS[destGUID].LastUpdate = CurrentTime
        if Zylla.SA_STATS[destGUID].Count <= 0 then
          Zylla.SA_Cleanup(destGUID)
        end
      end
      end
    end
    if Zylla.SA_TOTAL < 0 then
      Zylla.SA_TOTAL = 0
    end
    for guid,_ in pairs(Zylla.SA_STATS) do
      if (CurrentTime - Zylla.SA_STATS[guid].LastUpdate) > 10 then
        --If we haven't had a new SA spawn in 10sec, that means all SAs that are out have hit the target (usually), or, the target disappeared.
        Zylla.SA_Cleanup(guid)
      end
    end
    if (combatevent == "UNIT_DIED" or combatevent == "UNIT_DESTROYED" or combatevent == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
      Zylla.SA_Cleanup(destGUID)
    end

    if UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player") or not InCombatLockdown() then -- We died, or, exited combat, go ahead and purge the list
      for guid,_ in pairs(Zylla.SA_STATS) do
        Zylla.SA_Cleanup(guid)
    end
    Zylla.SA_STATS     = {}
    Zylla.SA_NUM_UNITS = 0
    Zylla.SA_TOTAL     = 0
    end
    if CurrentTime - Zylla.LAST_CONTINUITY_CHECK > 10 then --Force check of unit count every 10sec
      local newUnits = 0
      for _,_ in pairs(Zylla.SA_STATS) do
        newUnits = newUnits + 1
      end
      Zylla.SA_NUM_UNITS          = newUnits
      Zylla.LAST_CONTINUITY_CHECK = CurrentTime
    end
    if Zylla.SA_NUM_UNITS > 0 then
      local totalSAs = 0
      for guid,_ in pairs(Zylla.SA_STATS) do
        if Zylla.SA_STATS[guid].Count <= 0 or (UnitIsDeadOrGhost(guid)) then
          Zylla.SA_DEAD[guid] = true
        else
          totalSAs = totalSAs + Zylla.SA_STATS[guid].Count
        end
      end
      if totalSAs > 0 and Zylla.SA_TOTAL > 0 then
        return true
      end
    end
    return false
  end
end)

NeP.Listener:Add('Zylla_VF_S2M', 'COMBAT_LOG_EVENT_UNFILTERED', function(_,combatevent,_,sourceGUID,_,_,_,destGUID,_,_,_,spellid,_,_,_,_,_,_,_,_,_,_,_,_,_)
  if Zylla.class == 5 then
    local CurrentTime = GetTime()
    Zylla.Voidform_Total_Stacks        = Zylla.Voidform_Total_Stacks or 0
    Zylla.Voidform_Previous_Stack_Time = Zylla.Voidform_Previous_Stack_Time or 0
    Zylla.Voidform_Drain_Stacks        = Zylla.Voidform_Drain_Stacks or 0
    Zylla.Voidform_VoidTorrent_Stacks  = Zylla.Voidform_VoidTorrent_Stacks or 0
    Zylla.Voidform_Dispersion_Stacks   = Zylla.Voidform_Dispersion_Stacks or 0
    Zylla.Voidform_Current_Drain_Rate  = Zylla.Voidform_Current_Drain_Rate or 0
    if Zylla.Voidform_Total_Stacks >= 100 then
      if (CurrentTime - Zylla.Voidform_Previous_Stack_Time) >= 1 then
        Zylla.Voidform_Previous_Stack_Time  = CurrentTime
        Zylla.Voidform_Total_Stacks         = Zylla.Voidform_Total_Stacks + 1
        if Zylla.Voidform_VoidTorrent_Start == nil and Zylla.Voidform_Dispersion_Start == nil then
          Zylla.Voidform_Drain_Stacks       = Zylla.Voidform_Drain_Stacks + 1
          -- print('Zylla.Voidform_Drain_Stacks1: '..Zylla.Voidform_Drain_Stacks)
          Zylla.Voidform_Current_Drain_Rate = (9.0 + ((Zylla.Voidform_Drain_Stacks - 1) / 2))
          -- print('Zylla.Voidform_Current_Drain_Rate1: '..Zylla.Voidform_Current_Drain_Rate)
        elseif Zylla.Voidform_VoidTorrent_Start ~= nil then
          Zylla.Voidform_VoidTorrent_Stacks = Zylla.Voidform_VoidTorrent_Stacks + 1
        else
          Zylla.Voidform_Dispersion_Stacks  = Zylla.Voidform_Dispersion_Stacks + 1
        end
      end
    end
    if sourceGUID == UnitGUID("player") then
      if spellid == 194249 then
        if combatevent == "SPELL_AURA_APPLIED" then -- Entered Voidform
          Zylla.Voidform_Previous_Stack_Time = CurrentTime
          Zylla.Voidform_VoidTorrent_Start   = nil
          Zylla.Voidform_Dispersion_Start    = nil
          Zylla.Voidform_Drain_Stacks        = 1
          Zylla.Voidform_Start_Time          = CurrentTime
          Zylla.Voidform_Total_Stacks        = 1
          Zylla.Voidform_VoidTorrent_Stacks  = 0
          Zylla.Voidform_Dispersion_Stacks   = 0
        elseif combatevent == "SPELL_AURA_APPLIED_DOSE" then -- New Voidform Stack
          Zylla.Voidform_Previous_Stack_Time  = CurrentTime
          Zylla.Voidform_Total_Stacks         = Zylla.Voidform_Total_Stacks + 1
          if Zylla.Voidform_VoidTorrent_Start == nil and Zylla.Voidform_Dispersion_Start == nil then
            Zylla.Voidform_Drain_Stacks       = Zylla.Voidform_Drain_Stacks + 1
            -- print('Zylla.Voidform_Drain_Stacks2: '..Zylla.Voidform_Drain_Stacks)
            Zylla.Voidform_Current_Drain_Rate = (9.0 + ((Zylla.Voidform_Drain_Stacks - 1) / 2))
            -- print('Zylla.Voidform_Current_Drain_Rate2: '..Zylla.Voidform_Current_Drain_Rate)
          elseif Zylla.Voidform_VoidTorrent_Start ~= nil then
            Zylla.Voidform_VoidTorrent_Stacks = Zylla.Voidform_VoidTorrent_Stacks + 1
          else
            Zylla.Voidform_Dispersion_Stacks  = Zylla.Voidform_Dispersion_Stacks + 1
          end
        elseif combatevent == "SPELL_AURA_REMOVED" then -- Exited Voidform
          if Zylla.Voidform_Summary == true then
            print("Voidform Info:")
            print("--------------------------")
            print(string.format("Voidform Duration: %.2f seconds", (CurrentTime-Zylla.Voidform_Start_Time)))
            if Zylla.Voidform_Total_Stacks > 100 then
              print(string.format("Voidform Stacks: 100 (+%.0f)", (Zylla.Voidform_Total_Stacks - 100)))
            else
              print(string.format("Voidform Stacks: %.0f", Zylla.Voidform_Total_Stacks))
            end
            print(string.format("Dispersion Stacks: %.0f", Zylla.Voidform_Dispersion_Stacks))
            print(string.format("Void Torrent Stacks: %.0f", Zylla.Voidform_VoidTorrent_Stacks))
            print("Final Drain: "..Zylla.Voidform_Drain_Stacks.." stacks, "..Zylla.Voidform_Current_Drain_Rate.." / sec")
        end
        Zylla.Voidform_VoidTorrent_Start  = nil
        Zylla.Voidform_Dispersion_Start   = nil
        Zylla.Voidform_Drain_Stacks       = 0
        Zylla.Voidform_Current_Drain_Rate = 0
        Zylla.Voidform_Start_Time         = nil
        Zylla.Voidform_Total_Stacks       = 0
        Zylla.Voidform_VoidTorrent_Stacks = 0
        Zylla.Voidform_Dispersion_Stacks  = 0
        end

      elseif spellid == 205065 then
        if combatevent == "SPELL_AURA_APPLIED" then -- Started channeling Void Torrent
          Zylla.Voidform_VoidTorrent_Start = CurrentTime
        elseif combatevent == "SPELL_AURA_REMOVED" and Zylla.Voidform_VoidTorrent_Start ~= nil then -- Stopped channeling Void Torrent
          Zylla.Voidform_VoidTorrent_Start = nil
        end

      elseif spellid == 47585 then
        if combatevent == "SPELL_AURA_APPLIED" then -- Started channeling Dispersion
          Zylla.Voidform_Dispersion_Start  = CurrentTime
        elseif combatevent == "SPELL_AURA_REMOVED" and Zylla.Voidform_Dispersion_Start ~= nil then -- Stopped channeling Dispersion
          Zylla.Voidform_Dispersion_Start  = nil
        end

      elseif spellid == 212570 then
        if combatevent == "SPELL_AURA_APPLIED" then -- Gain Surrender to Madness
          Zylla.Voidform_S2M_Activated     = true
          Zylla.Voidform_S2M_Start         = CurrentTime
        elseif combatevent == "SPELL_AURA_REMOVED" then -- Lose Surrender to Madness
          Zylla.Voidform_S2M_Activated     = false
        end
      end

    elseif destGUID == UnitGUID("player") and (combatevent == "UNIT_DIED" or combatevent == "UNIT_DESTROYED" or combatevent == "SPELL_INSTAKILL") and Zylla.Voidform_S2M_Activated == true then
      Zylla.Voidform_S2M_Activated = false
      if Zylla.S2M_Summary == true then
        print("Surrender to Madness Info:")
        print("--------------------------")
        print(string.format("S2M Duration: %.2f seconds", (CurrentTime-Zylla.Voidform_S2M_Start)))
        print(string.format("Voidform Duration: %.2f seconds", (CurrentTime-Zylla.Voidform_Start_Time)))
        if Zylla.Voidform_Total_Stacks > 100 then
          print(string.format("Voidform Stacks: 100 (+%.0f)", (Zylla.Voidform_Total_Stacks - 100)))
        else
          print(string.format("Voidform Stacks: %.0f", Zylla.Voidform_Total_Stacks))
        end
        print(string.format("Dispersion Stacks: %.0f", Zylla.Voidform_Dispersion_Stacks))
        print(string.format("Void Torrent Stacks: %.0f", Zylla.Voidform_VoidTorrent_Stacks))
        print("Final Drain: "..Zylla.Voidform_Drain_Stacks.." stacks, "..Zylla.Voidform_Current_Drain_Rate.." / sec")
      end
      Zylla.Voidform_S2M_Start          = nil
      Zylla.Voidform_VoidTorrent_Start  = nil
      Zylla.Voidform_Dispersion_Start   = nil
      Zylla.Voidform_Drain_Stacks       = 0
      Zylla.Voidform_Current_Drain_Rate = 0
      Zylla.Voidform_Start_Time         = nil
      Zylla.Voidform_Total_Stacks       = 0
      Zylla.Voidform_VoidTorrent_Stacks = 0
      Zylla.Voidform_Dispersion_Stacks  = 0
    end
  end
end)

--------------------------------------------------------------------------------
--------------------------------- DRUID ----------------------------------------
--------------------------------------------------------------------------------

--Feral

Zylla.f_pguid = UnitGUID("player")
Zylla.f_cp = 0
Zylla.f_cleanUpTimer = nil
Zylla.f_lastUpdate = 0
Zylla.f_nextUpdateDmg = nil

Zylla.f_buffs = {
  ["tigersFury"]  = 0,
  ["savageRoar"]  = 0,
  ["bloodtalons"] = 0,
  ["incarnation"] = 0,
  ["prowl"]       = 1,
  ["shadowmeld"]  = 1,
}

Zylla.f_events = {
  ["SPELL_AURA_APPLIED"] = true,
  ["SPELL_AURA_REFRESH"] = true,
  ["SPELL_AURA_REMOVED"] = true,
  ["SPELL_CAST_SUCCESS"] = true,
  ["SPELL_MISSED"]       = true,
}

Zylla.f_buffID = {
  [5217]   = "tigersFury",
  [52610]  = "savageRoar",
  [145152] = "bloodtalons",
  [102543] = "incarnation",
  [5215]   = "prowl",
  [102547] = "prowl",
  [58984]  = "shadowmeld",
}

Zylla.f_debuffID = {
  [163505] = "rake", --stun effect
  [1822]   = "rake", --initial dmg
  [1079]   = "rip",
  [106830] = "thrash",
  [155722] = "rake", --dot
  [155625] = "moonfire",
}

--Initialize tables to hold all snapshot data
Zylla.f_Snapshots = {
  ["rake"]     = {},
  ["rip"]      = {},
  ["thrash"]   = {},
  ["moonfire"] = {},
}

--Create localization strings
Zylla.f_strings = {
  ["tigersFury"]  = GetSpellInfo(5217) or "Tiger's Fury",
  ["savageRoar"]  = GetSpellInfo(52610) or "Savage Roar",
  ["bloodtalons"] = GetSpellInfo(145152) or "Bloodtalons",
  ["incarnation"] = GetSpellInfo(102543) or "Incarnation: King of the Jungle",
  ["prowl"]       = GetSpellInfo(5215) or "Prowl",
  ["shadowmeld"]  = GetSpellInfo(58984) or "Shadowmeld",
}

--Create update function for checking for buffs
function Zylla.f_update()
  local b = Zylla.f_buffs
  local s = Zylla.f_strings
  local now = GetTime()
  Zylla.f_lastUpdate = now

  b.tigersFury  = select(7,UnitBuff("player", s.tigersFury)) or b.tigersFury
  b.savageRoar  = select(7,UnitBuff("player", s.savageRoar)) or b.savageRoar
  b.bloodtalons = select(7,UnitBuff("player", s.bloodtalons)) or b.bloodtalons
  b.incarnation = select(7,UnitBuff("player", s.incarnation)) or b.incarnation
  b.prowl       = select(7,UnitBuff("player", s.prowl)) or b.prowl
  b.shadowmeld  = select(7,UnitBuff("player", s.shadowmeld)) or b.shadowmeld
  Zylla.f_updateDmg()
end

--Create update function for calculating current snapshot strength
function Zylla.f_updateDmg()
  local b = Zylla.f_buffs
  local now = GetTime()
  local dmgMulti = 1
  local rakeMulti = 1
  local bloodtalonsMulti = 1
  local currentCP = UnitPower("player",4)
  if currentCP ~= 0 then
    Zylla.f_cp = currentCP
  end
  if b.tigersFury > now then dmgMulti = dmgMulti * 1.15 end
  if b.savageRoar > now then dmgMulti = dmgMulti * 1.25 end
  if b.bloodtalons > now then bloodtalonsMulti = 1.5 end
  if b.incarnation > now or b.prowl > now or b.shadowmeld > now then rakeMulti=2
  elseif b.prowl == 0 or b.shadowmeld == 0 then rakeMulti=2 end
  Zylla.f_Snapshots.rip.current      = dmgMulti*bloodtalonsMulti*Zylla.f_cp
  Zylla.f_Snapshots.rip.current5CP   = dmgMulti*bloodtalonsMulti*5
  Zylla.f_Snapshots.rake.current     = dmgMulti*bloodtalonsMulti*rakeMulti
  Zylla.f_Snapshots.thrash.current   = dmgMulti*bloodtalonsMulti
  Zylla.f_Snapshots.moonfire.current = dmgMulti
end

--Create function for handling clean up of the snapshot table
function Zylla.f_cleanUp()
  --Cancel existing scheduled cleanup first if there is one
  if Zylla.f_cleanUpTimer then Zylla.f_cancelCleanUp() end
  Zylla.f_cleanUpTimer = C_Timer.NewTimer(30,function()
    if UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player") or not InCombatLockdown() then
      --if not UnitAffectingCombat("player") then
      Zylla.f_Snapshots = {
        ["rake"]     = {},
        ["rip"]      = {},
        ["thrash"]   = {},
        ["moonfire"] = {}
      }
    end
  end)
end

--Create clean up function
function Zylla.f_cancelCleanUp()
  if Zylla.f_cleanUpTimer then
    Zylla.f_cleanUpTimer:Cancel()
    Zylla.f_cleanUpTimer = nil
  end
end

NeP.Listener:Add('Zylla_f_update1', 'ZONE_CHANGED_NEW_AREA', function()
  if Zylla.class == 11 then
    Zylla.f_update()
  end
end)

NeP.Listener:Add('Zylla_f_update2', 'ACTIVE_TALENT_GROUP_CHANGED', function()
  if Zylla.class == 11 then
    Zylla.f_update()
  end
end)

NeP.Listener:Add('Zylla_f_updateDmg', 'UNIT_POWER', function(unit, type)
  if Zylla.class == 11 then
    if unit == "player" and type == "COMBO_POINTS" then
      Zylla.f_updateDmg()
    end
  end
end)

NeP.Listener:Add('Zylla_f_Snapshot', 'COMBAT_LOG_EVENT_UNFILTERED', function(_, combatevent, _, sourceGUID, _,_,_, destGUID, _,_,_, spellID)
  if Zylla.class == 11 then
    --This trigger listens for bleed events to record snapshots.
    --This trigger also listens for changes in buffs to recalculate bleed damage.

    --Check for only relevant player events
    if not Zylla.f_buffID[spellID] and not Zylla.f_debuffID[spellID] then return end
    if not Zylla.f_events[combatevent] then return end
    if sourceGUID ~= Zylla.f_pguid then return end

    --Handle AURA_APPLY and AURA_REFRESH as the same event type
    if combatevent == "SPELL_AURA_REFRESH" then combatevent = "SPELL_AURA_APPLIED" end

    --Convert rake stun events into rake casts to handle corner case with prowl+rake
    if spellID == 163505 and (combatevent=="SPELL_MISSED" or combatevent=="SPELL_AURA_APPLIED") then
      spellID = 1822
      combatevent = "SPELL_CAST_SUCCESS"
    end

    --Listen for buff changes on player that affect snapshots
    if destGUID == Zylla.f_pguid then
      if combatevent == "SPELL_AURA_APPLIED" then Zylla.f_update() return
      elseif combatevent == "SPELL_AURA_REMOVED" then
        local spellName = Zylla.f_buffID[spellID]
        local dur = 0
        --Add small timing window for buffs that can expire before cast
        if spellName == "bloodtalons" then dur    = 0.1
        elseif spellName == "prowl" then dur      = 0.1
        elseif spellName == "shadowmeld" then dur = 0.1
        end

        if spellName then
          Zylla.f_buffs[spellName] = GetTime() + dur
          Zylla.f_nextUpdateDmg    = GetTime() + dur + 0.01
          return
        end
      end
    end

    -- The following code handles application and expiration of bleeds

    -- 1. Snapshot dmg on spell cast success
    local fs = Zylla.f_Snapshots
    if combatevent == "SPELL_CAST_SUCCESS" then
      local spellName
      if spellID == 1822 then spellName       = "rake"
      elseif spellID == 1079 then spellName   = "rip"
      elseif spellID == 106830 then spellName = "thrash"
      elseif spellID == 155625 then spellName = "moonfire"
      end

      if spellName then
        Zylla.f_update()
        fs[spellName]["onCast"] = fs[spellName]["current"]
        return
      end

      --2. Record snapshot for target if and when the bleed is applied
    elseif combatevent == "SPELL_AURA_APPLIED" then
      local spellName
      if spellID == 155722 then spellName     = "rake"
      elseif spellID == 1079 then spellName   = "rip"
      elseif spellID == 106830 then spellName = "thrash"
      elseif spellID == 155625 then spellName = "moonfire"
      end

      if spellName then
        fs[spellName][destGUID] = fs[spellName]["onCast"]
        return
      end

      --3. Remove snapshot for target when bleed expires
    elseif combatevent == "SPELL_AURA_REMOVED" then
      local spellName
      if spellID == 155722 then spellName     = "rake"
      elseif spellID == 1079 then spellName   = "rip"
      elseif spellID == 106830 then spellName = "thrash"
      elseif spellID == 155625 then spellName = "moonfire"
      end

      if spellName then
        fs[spellName][destGUID] = nil
        return
      end
    end
  end
end)

NeP.Listener:Add('Zylla_OutOfCombat', 'PLAYER_REGEN_ENABLED', function()
  if Zylla.class == 9 then
    --This trigger manages clean up of snapshots when it is safe to do so
    --1. Schedule cleanup of snapshots when combat ends
    Zylla.f_cleanUp()
  end
end)

NeP.Listener:Add('Zylla_InCombat', 'PLAYER_REGEN_DISABLED', function()
  if Zylla.class == 9 then
    --2. Check for and cancel scheduled cleanup when combat starts
    Zylla.f_cancelCleanUp()

    C_Timer.NewTicker(1.5, (function()
      --This trigger runs the update function if there have been no updates recently
      --due to a lack of relevant combat events.
      if not UnitIsDeadOrGhost("player") and (UnitAffectingCombat("player") or InCombatLockdown()) then
        if GetTime() - Zylla.f_lastUpdate >= 3 then Zylla.f_update() end
        --if GetTime() - Zylla.lastDmgUpdate >= 0.045 then Zylla.f_updateDmg() end
        if Zylla.f_nextUpdateDmg and GetTime() > Zylla.f_nextUpdateDmg then
          Zylla.f_nextUpdateDmg = nil
          Zylla.f_updateDmg()
        end
      end
    end), nil)
  end
end)

--Guardian--

--------------------------------------------------------------------------------
-------------------------------- TRAVEL SPEED-----------------------------------
--------------------------------------------------------------------------------

-- List of known spells travel-speed. Non charted spells will be considered traveling 40 yards/s
-- To recover travel speed, open up /eventtrace, calculate difference between SPELL_CAST_SUCCESS and SPELL_DAMAGE events

local Travel_Chart = {
  [116]    = 23.174,  -- Frostbolt
  [228597] = 23.174,  -- Frostbolt
  [133]    = 45.805,  -- Fireball
  [11366]  = 52,      -- Pyroblast
  [29722]  = 18,      -- Incinerate
  [30455]  = 25.588,  -- Ice Lance
  [105174] = 33,      -- Hand of Gul'dan
  [120644] = 10,      -- Halo
  [122121] = 25,      -- Divine Star
  [127632] = 19,      -- Cascade
  [210714] = 38,      -- Icefury
  [51505]  = 38.090,  -- Lava Burst
  [205181] = 32.737,  -- Shadowflame
}

-- Return the time a spell will need to travel to the current target
function Zylla.TravelTime(unit, spell)
  local spellID = NeP.Core:GetSpellID(spell)
  if Travel_Chart[spellID] then
    TravelSpeed = Travel_Chart[spellID]
    return NeP.DSL:Get("distance")(unit) / TravelSpeed
  else
    return 0
  end
end

-------------------------
-- Gabbz fake units + misc
---------------------------

function Zylla.dynEval(condition, spell)
  return Parse(condition, spell or '')
end

function Zylla.GetPredictedHealth(unit)
  return UnitHealth(unit)-(UnitGetTotalHealAbsorbs(unit) or 0)+(UnitGetIncomingHeals(unit) or 0)
end

-- Lowest
NeP.FakeUnits:Add('healingCandidate', function(nump)
  local tempTable = {}
  local num = nump or 1

  for _, Obj in pairs(NeP.OM:Get('Friendly')) do
    if UnitPlayerOrPetInParty(Obj.key) or UnitIsUnit('player', Obj.key) then
      local healthRaw = Zylla.GetPredictedHealth(Obj.key)
      local maxHealth = UnitHealthMax(Obj.key)
      local healthPercent =  (healthRaw / maxHealth) * 100
      tempTable[#tempTable+1] = {
        key = Obj.key,
        health = healthPercent,
      }
    end
  end
  table.sort( tempTable, function(a,b) return a.health < b.health end )
  print("Zylla Unit: " ..tempTable[num].key .." Health: " ..tempTable[num].health)
  return tempTable[num].key
end)


NeP.DSL:Register("area.enemiesheals", function(unit, distance)
  local total = 0
  if not UnitExists(unit) then return total end
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
    if NeP.DSL:Get('combat')(Obj.key) and NeP.Protected.Distance(unit, Obj.key) <= tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

function Zylla.NrHealsAroundFriendly(healthp, distance, unit)
  local health = healthp
  local range = distance
  local total = 0
  if not UnitExists(unit) then return total end
  for _, Obj in pairs(NeP.OM:GetRoster()) do
    if NeP.Protected.Distance(unit, Obj.key) <= tonumber(range) and Obj.health < health then
      total = total +1
    end
  end
  return total
end

-------------------------
-- Gabbz END
-------------------------

function Zylla.tt()
  if NeP.Unlocked and UnitAffectingCombat('player') and not NeP.DSL:Get('casting')('player', 'Fists of Fury') then
    NeP:Queue('Transcendence: Transfer', 'player')
  end
end

function Zylla.ts()
  if NeP.Unlocked and UnitAffectingCombat('player') and not NeP.DSL:Get('casting')('player', 'Fists of Fury') then
    NeP:Queue('Transcendence', 'player')
  end
end

NeP.FakeUnits:Add('Zylla_sck', function(debuff)
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
    if UnitExists(Obj.key) then
      if (NeP.DSL:Get('combat')(Obj.key) or Obj.isdummy) then
        if (NeP.DSL:Get('infront')(Obj.key) and NeP.DSL:Get('inMelee')(Obj.key)) then
          local _,_,_,_,_,_,debuffDuration = UnitDebuff(Obj.key, debuff, nil, 'PLAYER')
          if not debuffDuration or debuffDuration - GetTime() < 1.5 then
            --print("Zylla_sck: returning "..Obj.name.." ("..Obj.key.." - "..Obj.guid..' :'..time()..")");
            return Obj.key
          end
        end
      end
    end
  end
end)

NeP.Library:Add('Zylla', {

  hitcombo = function(_, spell)
    local HitComboLastCast = ''
    if not spell then return true end
    local _, _, _, _, _, _, spellID = GetSpellInfo(spell)
    if NeP.DSL:Get('buff')('player', 'Hit Combo') then
      -- We're using hit-combo and we need to check if the spell we've passed is in the list
      if HitComboLastCast == spellID then
        -- If the passed spell is in the list as flagged, we need to return false and exit
        --print('hitcombo('..spell..') and it is was flagged ('..HitComboLastCast..'), returning false');
        return false
      end
    end
    return true
  end,

	face = function(target)
		local ax, ay = ObjectPosition('player')
		local bx, by = ObjectPosition(target)
		if not ax or not bx then return end
		local angle = rad(atan2(by - ay, bx - ax))
		if angle < 0 then
			UnitSetFacing(rad(atan2(by - ay, bx - ax) + 360))
		else
			UnitSetFacing(angle)
		end
	end,
--[[
  sef = function()
    local SEF_Fixate_Casted = false
    if NeP.DSL:Get('buff')('player', 'Storm, Earth, and Fire') then
      if SEF_Fixate_Casted then
        return false
      else
        SEF_Fixate_Casted = true
        return true
      end
    else
      SEF_Fixate_Casted = false
    end
    return false
  end,
]]--
  staggered = function()
    local stagger = UnitStagger("player");
    local percentOfHealth = (100/UnitHealthMax("player")*stagger);
    -- TODO: We are targetting 4.5% stagger value - too low?  I think we used 25% or heavy stagger before as the trigger
    if (percentOfHealth > 4.5) or UnitDebuff("player", GetSpellInfo(124273)) then
      return true
    end
    return false
  end,

  purifyingCapped = function()
    local MaxBrewCharges = 3
    if NeP.DSL:Get('talent')(nil, '3,1') then
      MaxBrewCharges = MaxBrewCharges + 1
    end
    if (NeP.DSL:Get('spell.charges')('player', 'Purifying Brew') == MaxBrewCharges) or ((NeP.DSL:Get('spell.charges')('player', 'Purifying Brew') == MaxBrewCharges - 1) and NeP.DSL:Get('spell.recharge')('player', 'Purifying Brew') < 3 ) then
      return true
    end
    return false
  end,

	rollingbones = function()
		local int = 0
    local bearing = false
    local shark = false
    -- Shark Infested Waters
    if UnitBuff('player', GetSpellInfo(193357)) then
        shark = true
        int = int + 1
    end
    -- True Bearing
    if UnitBuff('player', GetSpellInfo(193359)) then
        bearing = true
        int = int + 1
    end
    -- Jolly Roger
    if UnitBuff('player', GetSpellInfo(199603)) then
        int = int + 1
    end
    -- Grand Melee
    if UnitBuff('player', GetSpellInfo(193358)) then
        int = int + 1
    end
    -- Buried Treasure
    if UnitBuff('player', GetSpellInfo(199600)) then
        int = int + 1
    end
    -- Broadsides
    if UnitBuff('player', GetSpellInfo(193356)) then
        int = int + 1
    end
    -- If all six buffs are active:
    if int == 6 then
        return true --"LEEEROY JENKINS!"
    -- If two or Shark/Bearing and AR/Curse active:
    elseif int == 2 or int == 3 or ((bearing or shark) and ((UnitBuff("player", GetSpellInfo(13750)) or UnitDebuff("player", GetSpellInfo(202665))))) then
        return true --"Keep."
	-- If only Shark or True Bearing and CDs ready
    elseif (bearing or shark) and ((GetSpellCooldown(13750) == 0) or (GetSpellCooldown(202665) == 0)) then
        return true --"AR/Curse NOW and keep!"
	--if we have only ONE bad buff BUT AR/curse is active:
    elseif int ==1 and ((UnitBuff("player", GetSpellInfo(13750)) or UnitDebuff("player", GetSpellInfo(202665)))) then
        return true
	-- If only one bad buff:
    else return false	--"Reroll now!"
    end
	end,

})
