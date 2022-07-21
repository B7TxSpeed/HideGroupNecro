-- Global definitions
HideGroupNecro = HideGroupNecro or {
	name = "HideGroupNecro",
	version = "1.0.0",
}
local HG = HideGroupNecro
local EM = EVENT_MANAGER
local isNecro = GetUnitClassId('player') == 5

-- Utility variables
local groupIsHidden = false
local debug = false

--- Debug function
local function debugMessage(message)
	if debug then
		d("HideGroupNecro: "..message)
	end
end

--- Picked from Wheels HideGroup 2.1
local function hideMembers(enable)
	if enable then
		debugMessage("HideGroup")
		SetCrownCrateNPCVisible(true)
		groupIsHidden = true
		if HG.savedVariables.HideState ~= enable then
			d("HideGroupNecro: Hiding group members")
			HG.savedVariables.GroupMemberNameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES)
			HG.savedVariables.GroupMemberHealthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS)
		end
		SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(NAMEPLATE_CHOICE_NEVER))
		SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(NAMEPLATE_CHOICE_NEVER))
	else
		debugMessage("ShowGroup")
		SetCrownCrateNPCVisible(false)
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
	if HG.savedVariables.HideState then
		hideMembers(HG.savedVariables.HideState)
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
		hideMembers(true)
	elseif arg == "false" or arg == "0" then
		hideMembers(false)
	elseif arg == nil or arg == "" then
		hideMembers(not HG.savedVariables.HideState)
	else
		hideMembers(false)
	end
end

function HG.toggleHide()
	hideMembers(not HG.savedVariables.HideState)
end

function HG.init(event, addon)
	if addon ~= HG.name then return end
	
	EM:UnregisterForEvent(HG.name.."Init", EVENT_ADD_ON_LOADED)
	HG.defaults = {
		["GroupMemberNameplates"] = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES),
		["GroupMemberHealthBars"] = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS),
		["HideState"] = false,
	}
	HG.savedVariables = ZO_SavedVars:New("HideGroupNecroSavedVars", 1, nil, HG.defaults, GetWorldName())
	
	ZO_CreateStringId('SI_BINDING_NAME_HIDEGROUPNECRO_TOGGLE', 'Show/Hide Group Members')
	SLASH_COMMANDS["/hidegroup"] = HG.switchCommand

	EM:RegisterForEvent(HG.name.."PlayerActivated", EVENT_PLAYER_ACTIVATED, playerActivatedHandler)
	EM:RegisterForEvent(HG.name.."PlayerCombatState", EVENT_PLAYER_COMBAT_STATE, playerCombatStateHandler)
end

EM:RegisterForEvent(HG.name.."Init", EVENT_ADD_ON_LOADED, HG.init)
