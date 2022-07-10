-- Global definitions
local HG = HideGroup
local EM = EVENT_MANAGER
local isNecro = GetUnitClassId('player') == 5
local refreshOnlyOnBoss = false
-- Utility variables
local requiresUpdate = false
local isPlayerInCombat = false

local function HideGroupNecroHandler(_, inCombat)
	-- Player's combat state has changed
	if isPlayerInCombat ~= inCombat then
		-- Player is in combat
		if inCombat then
			isPlayerInCombat = true
			if  HG.savedVariables.HideState and isNecro and (not refreshOnlyOnBoss or refreshOnlyOnBoss and DoesUnitExist('boss1')) then
                -- Disable HideGroup to display corpses during combat
				SetCrownCrateNPCVisible(false)
				requiresUpdate = true
			end
		-- Player has potentially left combat, asynchronous trigger to ensure combat state has changed
		else
			zo_callLater(function()
                -- Player is out of combat
				if not IsUnitInCombat('player') then
					isPlayerInCombat = false
					if requiresUpdate then
						requiresUpdate = false
                        -- Enable HideGroup to hide other players
						SetCrownCrateNPCVisible(true)
					end
				end
			end, 1000)
		end
	end
end

EM:RegisterForEvent(HG.name.."NecroHandler", EVENT_PLAYER_COMBAT_STATE, HideGroupNecroHandler)
