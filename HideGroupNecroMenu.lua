local HG = HideGroupNecro
local LAM = LibAddonMenu2

--- Menu
function HG.loadMenu()
    local panelData = {
        type = "panel",
        name = HG.name,
        author = HG.author,
        version = HG.version,
    }
    local panel = LAM:RegisterAddonPanel(HG.name.."Menu", panelData)

    local optionsData = {
        {
            type = "header",
            name = function() return GetString(HG_MENU_GLOBAL_SETTINGS) end,
        },
        {
            reference = "HideGroupEnabled",
            type = "checkbox",
            name = function()
                return string.format(HG.savedVariables.HideState and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HG_MENU_ENABLED))
            end,
            default = false,
            getFunc = function()
                return HG.savedVariables.HideState
            end,
            setFunc = function(value)
                HG.hideMembers(value)
                HideGroupEnabled.label:SetText(string.format(HG.savedVariables.HideState and "|c00FF00%s|r" or "|cFF0000%s|r", GetString(HG_MENU_ENABLED)))
            end,
        },
        {
            type = "header",
            name = function() return GetString(HG_MENU_OPTIONAL_SETTINGS) end,
        },
        {
            type = "checkbox",
            name = function() return GetString(HG_MENU_HIDE_NAMEPLATES) end,
            getFunc = function() return HG.savedVariables.HideNameplates end,
            setFunc = function(value) HG.savedVariables.HideNameplates = value end,
            width = "half",
        },
        {
            type = "checkbox",
            name = function() return GetString(HG_MENU_HIDE_HEALTHBARS) end,
            getFunc = function() return HG.savedVariables.HideHealthBars end,
            setFunc = function(value) HG.savedVariables.HideHealthBars = value end,
            width = "half",
        },
    }
    LAM:RegisterOptionControls(HG.name.."Menu", optionsData)
end
