-- Global definitions
HideGroupNecro = HideGroupNecro or {
	name = "HideGroupNecro",
	label = "HideGroup|c5050ffNecro|r",
	author = "|c00fffe@B7TxSpeed|r",
	version = "1.2.6",
}
local HG = HideGroupNecro
local EM = EVENT_MANAGER
local SM = SCENE_MANAGER
local isNecro = GetUnitClassId('player') == 5

-- Utility variables
local groupIsHidden = false

--- Debug function
local function debugMessage(message)
	if HG.savedVariables.Debug then
		d("HideGroupNecro: "..message)
	end
end

function HG.nameplateChoice(hide)
    if hide then
        return tostring(NAMEPLATE_CHOICE_NEVER)
    else
        return tostring(NAMEPLATE_CHOICE_ALWAYS)
    end
end

-- Picked from SpeedRun
local function ForceGroupVisible()
	if not IsPlayerActivated() then return end
	local scene = SM.currentScene:GetName()
	if scene == "stats" then return end
	SM:Show("stats")
	zo_callLater(function()
	  SetCrownCrateNPCVisible(false)
	  if scene == "hudui" then SM:Show("hud")
	  else
		if scene ~= "" then SM:Show(scene) end
	  end
	end, 20)
  end

--- Picked from Wheels HideGroup 2.1
function HG.hideMembers(enable)
	if enable then
		debugMessage("HideGroup")
		SetCrownCrateNPCVisible(true)
		groupIsHidden = true
		if HG.savedVariables.HideState ~= enable then
			d("HideGroupNecro: Hiding group members")
			HG.savedVariables.GroupMemberNameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES)
			HG.savedVariables.GroupMemberHealthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS)
		end
		SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, HG.nameplateChoice(HG.savedVariables.HideNameplates))
		SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, HG.nameplateChoice(HG.savedVariables.HideHealthBars))
	else
		debugMessage("ShowGroup")
		ForceGroupVisible()
		groupIsHidden = false
		if HG.savedVariables.HideState ~= enable then
			d("HideGroupNecro: Showing group members")
			SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(HG.savedVariables.GroupMemberNameplates))
			SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(HG.savedVariables.GroupMemberHealthBars))
		end
	end
	HG.savedVariables.HideState = enable
end

local function playerActivatedHandler()
	if HG.savedVariables.HideState and not IsUnitInCombat("player") then
		HG.hideMembers(HG.savedVariables.HideState)
	end
end

local function playerCombatStateHandler(_, inCombat)
	-- Player's combat state has changed
	if inCombat and HG.savedVariables.HideState and isNecro and groupIsHidden then
		debugMessage("ShowGroup for necro")
		SetCrownCrateNPCVisible(false)
		groupIsHidden = false
	end
end

function HG.switchCommand(arg)
	if arg == "true" or arg == "1" then
		HG.hideMembers(true)
	elseif arg == "false" or arg == "0" then
		HG.hideMembers(false)
	elseif arg == nil or arg == "" then
		HG.hideMembers(not HG.savedVariables.HideState)
	else
		HG.hideMembers(false)
	end
end

function HG.toggleHide()
	HG.hideMembers(not HG.savedVariables.HideState)
end

function HG.init(event, addon)
	if addon ~= HG.name then return end
	
	EM:UnregisterForEvent(HG.name.."Init", EVENT_ADD_ON_LOADED)
	HG.defaults = {
		["GroupMemberNameplates"] = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES),
		["GroupMemberHealthBars"] = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS),
		["HideNameplates"] = true,
		["HideHealthBars"] = true,
		["HideState"] = false,
		["Debug"] = false,
	}
	HG.savedVariables = ZO_SavedVars:New("HideGroupNecroSavedVars", 1, nil, HG.defaults, GetWorldName())
	
	ZO_CreateStringId('SI_BINDING_NAME_HIDEGROUPNECRO_TOGGLE', 'Show/Hide Group Members')
	SLASH_COMMANDS["/hidegroup"] = HG.switchCommand

	EM:RegisterForEvent(HG.name.."PlayerActivated", EVENT_PLAYER_ACTIVATED, playerActivatedHandler)
	EM:RegisterForEvent(HG.name.."PlayerCombatState", EVENT_PLAYER_COMBAT_STATE, playerCombatStateHandler)

	-- Load Menu
	HG.loadMenu()
end

EM:RegisterForEvent(HG.name.."Init", EVENT_ADD_ON_LOADED, HG.init)
