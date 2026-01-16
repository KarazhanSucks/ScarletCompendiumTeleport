-- Mastery Selector Addon
local frame = CreateFrame("Frame")
local targetMastery = nil

-- Roman numeral mapping
local masteryMap = {
    ["1"] = "Mastery I:",
    ["2"] = "Mastery II:",
    ["3"] = "Mastery III:",
    ["4"] = "Mastery IV:"
}

-- Helper: select gossip option by partial text
local function SelectOptionMatching(text)
    local options = { GetGossipOptions() }
    
    for i = 1, #options, 2 do
        local optText = options[i]
        local index = (i + 1) / 2
        if optText and optText:find(text) then
            SelectGossipOption(index)
            return true
        end
    end
    return false
end

frame:RegisterEvent("GOSSIP_SHOW")
frame:SetScript("OnEvent", function()
    if targetMastery then
        if SelectOptionMatching(targetMastery) then
            targetMastery = nil -- Clear after selection
            CloseGossip()       -- Optional: Closes window after clicking
        end
    end
end)

-- Slash Command Setup
SLASH_SETMASTERY1 = "/setmastery"
SlashCmdList["SETMASTERY"] = function(msg)
    msg = msg:trim()
    
    if masteryMap[msg] then
        targetMastery = masteryMap[msg]
        print("|cff00ff00Mastery target set to:|r " .. targetMastery)
        print("Now talk to the NPC to auto-select it.")
    else
        print("|cffff0000Invalid option.|r Use: /setmastery 1, 2, 3, or 4")
    end
end

-- String trim helper if not present
if not string.trim then
    function string.trim(s)
        return s:match("^%s*(.-)%s*$")
    end
end