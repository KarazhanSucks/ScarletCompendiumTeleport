-- Scarlet Compendium Teleport Addon
-- Version 3.0 — Works with item macros

local debugMode = false
local frame = CreateFrame("Frame")
frame:RegisterEvent("GOSSIP_SHOW")

-- Helper: select gossip option by partial text
local function SelectOptionMatching(text)
    local options = { GetGossipOptions() }
    if debugMode then
        print("|cff00ffff[SCT Debug]|r Gossip options detected:")
        for i = 1, #options, 2 do
            print("  ", i/2, options[i])
        end
    end

    for i = 1, #options, 2 do
        local optText = options[i]
        local index = (i + 1) / 2
        if optText and optText:find(text) then
            if debugMode then
                print("|cff00ffff[SCT Debug]|r Selecting option:", optText)
            end
            SelectGossipOption(index)
            return true
        end
    end
    return false
end

frame:SetScript("OnEvent", function(self)
    if not selectedDestination then return end

    -- Step 1: Show teleport options
    if SelectOptionMatching("Show teleport options") then return end

    -- Step 2: Select the destination city
    if SelectOptionMatching(selectedDestination) then
        if debugMode then
            print("|cff00ffff[SCT Debug]|r Destination reached:", selectedDestination)
        end
        selectedDestination = nil -- Reset after teleport
    end
end)

-- Optional debug toggle: /sct debug
SLASH_SCARLETCOMPENDIUM1 = "/sct"
SlashCmdList["SCARLETCOMPENDIUM"] = function(msg)
    msg = msg:lower():trim()
    if msg == "debug" then
        debugMode = not debugMode
        print("|cff00ff00[SCT Debug]|r Debug mode", debugMode and "enabled" or "disabled")
    end
end

-- String trim helper (Lua 5.1)
if not string.trim then
    function string.trim(s)
        return s:match("^%s*(.-)%s*$")
    end
end