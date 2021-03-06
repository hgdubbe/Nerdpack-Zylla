local _, Zylla = ...
local NeP = _G.NeP
local _G = _G

local UIParent = _G.UIParent
local CreateFrame = _G.CreateFrame
local C_Timer = _G.C_Timer
local GetTime = _G.GetTime
local GetSpecialization = _G.GetSpecialization
local PlaySound = _G.PlaySound
local UnitClass = _G.UnitClass
local GetSpecializationInfo = _G.GetSpecializationInfo

-- Splash stuff
local Splash_Frame = CreateFrame("Frame", "Zylla_SPLASH", UIParent)

Splash_Frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
});

Splash_Frame:SetBackdropColor(0,0,0,1);
Splash_Frame:Hide()

local texture = Splash_Frame:CreateTexture()
texture:SetPoint("LEFT",-4,0)
texture:SetSize(100,100)

local text = Splash_Frame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont");
text:SetPoint("RIGHT",-4,0)

local callTime = 0

C_Timer.NewTicker(0.01, (function()
	if Splash_Frame:IsShown() then
		if GetTime()-callTime>=5 then
			local Alpha = Splash_Frame:GetAlpha()
			Splash_Frame:SetAlpha(Alpha-.01)
			if Alpha<=0 then
				Splash_Frame:Hide()
				Splash_Frame:SetAlpha(1)
			end
		end
	end
end), nil)

local AddonInfo = '|cff'..Zylla.addonColor..Zylla.Name

function Zylla.Splash()
	Splash_Frame:SetAlpha(1)
	Splash_Frame:Show()
	PlaySound(124, "SFX");
	local color = NeP.Core:ClassColor('player', 'hex')
	local currentSpec = GetSpecialization()
	local _, SpecName, _, icon, _ = GetSpecializationInfo(currentSpec)
	local class = UnitClass('player')
	texture:SetTexture(icon)
	text:SetText(AddonInfo..'\n|cff'..color..class..' - '..SpecName..' \n|cffD11E0E--- Version: '..Zylla.Version..' ---\n|cff0e89d1'..Zylla.Branch..'')
	callTime = GetTime()
	local Width = text:GetStringWidth()+texture:GetWidth()+8
	Splash_Frame:SetSize(Width,100)
	Splash_Frame:SetPoint("CENTER",0,335	)
end
