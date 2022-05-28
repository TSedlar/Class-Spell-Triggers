local GameLoadFrame = CreateFrame("Frame")
GameLoadFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local SpellWidgets = {}
local Auras = {}
local AuraStackCounts = {}
local PlayerAuraTypes = {}
local TargetAuraTypes = {}
local Totems = {}

local LastSpellCastTime = nil
local LastAuraChangeTime = nil

local function AddSharedTriggers()
    -- "Cure Disease" is a spell for both shamans and priests
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Cure Disease", "Disease")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Cure Disease", "Disease")
end

local function AddShamanTriggers()
    -- Show stack count on aura-related spells
    SpellAuraUtil:HandleWidgetStackCount(SpellWidgets, AuraStackCounts, "Lightning Shield", "Lightning Shield")
    SpellAuraUtil:HandleWidgetStackCount(SpellWidgets, AuraStackCounts, "Water Shield", "Water Shield")

    -- Keep lightning/water shield buffs up
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, Auras, "Lightning Shield", {"Lightning Shield", "Water Shield"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, Auras, "Water Shield", {"Lightning Shield", "Water Shield"})

    -- Show shock spells when shamanistic focus is up
    SpellAuraUtil:HandleWidgetActiveGlow(SpellWidgets, Auras, "Earth Shock", "Focused")
    SpellAuraUtil:HandleWidgetActiveGlow(SpellWidgets, Auras, "Flame Shock", "Focused")
    SpellAuraUtil:HandleWidgetActiveGlow(SpellWidgets, Auras, "Frost Shock", "Focused")

    -- Show cleansing spells when the ability is there to remove
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Purge", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Cure Poison", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Cure Poison", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Poison Cleansing Totem", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Poison Cleansing Totem", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Disease Cleansing Totem", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Disease Cleansing Totem", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Cleanse Spirit", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Cleanse Spirit", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Purify Spirit", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Purify Spirit", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Purify Spirit", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Purify Spirit", "Magic")

    -- Show a darkened spell overlay when totems are active
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Searing Totem", "Searing Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Windfury Totem", "Windfury Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Strength of Earth Totem", "Strength of Earth Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Healing Stream Totem", "Healing Stream Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Grace of Air Totem", "Grace of Air Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Fire Nova Totem", "Fire Nova Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Stoneskin Totem", "Stoneskin Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Mana Spring Totem", "Mana Spring Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Enamored Water Spirit", "Ancient Mana Spring Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Tremor Totem", "Tremor Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Earthbind Totem", "Earthbind Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Stoneclaw Totem", "Stoneclaw Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Windwall Totem", "Windwall Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Tranquil Air Totem", "Tranquil Air Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Magma Totem", "Magma Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Disease Cleansing Totem", "Disease Cleansing Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Poison Cleansing Totem", "Poison Cleansing Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Sentry Totem", "Sentry Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Flametongue Totem", "Flametongue Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Fire Resistance Totem", "Fire Resistance Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Frost Resistance Totem", "Frost Resistance Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, "Nature Resistance Totem", "Nature Resistance Totem")
end

local function AddMageTriggers()
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Remove Curse", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Remove Curse", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Spellsteal", "Magic")
end

local function AddPaladinTriggers()
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Cleanse", "Disease")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Cleanse", "Disease")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Cleanse", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Cleanse", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Cleanse", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Cleanse", "Poison")
end

local function AddPriestTriggers()
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Purify", "Disease")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Purify", "Disease")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Purify", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Purify", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Dispel Magic", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Dispel Magic", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Mass Dispel", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Mass Dispel", "Magic")
end

local function AddDruidTriggers()
    -- Keep buffs up
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, Auras, "Gift of the Wild", {"Gift of the Wild", "Mark of the Wild"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, Auras, "Mark of the Wild", {"Gift of the Wild", "Mark of the Wild"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, Auras, "Thorns", {"Thorns", "Brambles"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, Auras, "Brambles", {"Thorns", "Brambles"})

    -- Cure Debuffs
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Remove Corruption", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Remove Corruption", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Remove Corruption", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Remove Corruption", "Poison")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Nature's Cure", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Nature's Cure", "Magic")
end

local function AddHunterTriggers()
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Spirit Shock", "Magic")
end

local function AddWarlockTriggers()
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Devour Magic", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, TargetAuraTypes, "Singe Magic", "Magic")
end

local function AddWarriorTriggers()
    -- Keep buffs up
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, Auras, "Battle Shout", {"Battle Shout"})
end

local function AddDwarfTriggers()
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Stoneform", "Curse")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Stoneform", "Disease")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Stoneform", "Magic")
    SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, PlayerAuraTypes, "Stoneform", "Poison")
end

local function UpdateAuraDecorations()
    Auras = SpellAuraUtil:GetAuras("player")
    AuraStackCounts = SpellAuraUtil:GetAuraStacks("player")
    PlayerAuraTypes = SpellAuraUtil:GetAuraTypes("player")
    TargetAuraTypes = SpellAuraUtil:GetAuraTypes("target")
    Totems = SpellAuraUtil:GetTotems()

    AddSharedTriggers()
    AddShamanTriggers()
    AddMageTriggers()
    AddPaladinTriggers()
    AddPriestTriggers()
    AddDruidTriggers()
    AddHunterTriggers()
    AddWarlockTriggers()
    AddDwarfTriggers()
end

local AuraWatcher = CreateFrame("Frame")
AuraWatcher:RegisterUnitEvent("UNIT_AURA", "player") -- Update auras when buffs are changed
AuraWatcher:RegisterEvent("PLAYER_TOTEM_UPDATE") -- Update auras when a totem is used

AuraWatcher:HookScript("OnEvent", function()
    LastAuraChangeTime = time() -- track aura timestamps
    UpdateAuraDecorations()
end)

GameLoadFrame:HookScript("OnEvent", function(...)
    SpellWidgets = SpellWidgetUtil:GenerateSpellWidgets() -- Generate spell mapping when game loads
    UpdateAuraDecorations()
end)