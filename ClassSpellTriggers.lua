local GameLoadFrame = CreateFrame("Frame")
GameLoadFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local SpellWidgets = {}
local PlayerAuras = {}
local TargetAuras = {}
local AuraStackCounts = {}
local PlayerAuraTypes = {}
local TargetAuraTypes = {}
local Totems = {}

local LastSpellCastTime = nil
local LastAuraChangeTime = nil

local function AddBidirectionalDebuffGlow(SpellName, AuraType)
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, SpellName, AuraType)
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, SpellName, AuraType)
end

local function AddBidirectionalWidgetInactiveGlow(SpellName, AuraNames)
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, SpellName, AuraNames)
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, TargetAuras, SpellName, AuraNames)
end

local function AddSharedTriggers()
    -- "Cure Disease" is a spell for both shamans and priests
    AddBidirectionalDebuffGlow("Cure Disease", "Disease")
end

local function AddShamanTriggers()
    -- Show stack count on aura-related spells
    SpellAuraUtil:HandleWidgetStackCount(SpellWidgets, AuraStackCounts, "Lightning Shield", "Lightning Shield")
    SpellAuraUtil:HandleWidgetStackCount(SpellWidgets, AuraStackCounts, "Water Shield", "Water Shield")

    -- Keep lightning/water shield buffs up
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Lightning Shield", {"Lightning Shield", "Water Shield"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Water Shield", {"Lightning Shield", "Water Shield"})

    -- Show shock spells when shamanistic focus is up
    SpellAuraUtil:HandleWidgetActiveGlow(SpellWidgets, PlayerAuras, "Earth Shock", "Focused")
    SpellAuraUtil:HandleWidgetActiveGlow(SpellWidgets, PlayerAuras, "Flame Shock", "Focused")
    SpellAuraUtil:HandleWidgetActiveGlow(SpellWidgets, PlayerAuras, "Frost Shock", "Focused")

    -- Cure debuffs
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Purge", "Magic")
    AddBidirectionalDebuffGlow("Cure Poison", "Poison")
    AddBidirectionalDebuffGlow("Poison Cleansing Totem", "Poison")
    AddBidirectionalDebuffGlow("Disease Cleansing Totem", "Disease")
    AddBidirectionalDebuffGlow("Cleanse Spirit", "Curse")
    AddBidirectionalDebuffGlow("Purify Spirit", "Curse")
    AddBidirectionalDebuffGlow("Purify Spirit", "Magic")

    -- Show a darkened spell overlay when totems are active
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Searing Totem", "Searing Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Windfury Totem", "Windfury Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Strength of Earth Totem", "Strength of Earth Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Healing Stream Totem", "Healing Stream Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Grace of Air Totem", "Grace of Air Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Fire Nova Totem", "Fire Nova Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Stoneskin Totem", "Stoneskin Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Mana Spring Totem", "Mana Spring Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Enamored Water Spirit", "Ancient Mana Spring Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Tremor Totem", "Tremor Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Earthbind Totem", "Earthbind Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Stoneclaw Totem", "Stoneclaw Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Windwall Totem", "Windwall Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Tranquil Air Totem", "Tranquil Air Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Magma Totem", "Magma Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Disease Cleansing Totem", "Disease Cleansing Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Poison Cleansing Totem", "Poison Cleansing Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Sentry Totem", "Sentry Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Flametongue Totem", "Flametongue Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Fire Resistance Totem", "Fire Resistance Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Frost Resistance Totem", "Frost Resistance Totem")
    SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, PlayerAuras, Totems, "Nature Resistance Totem", "Nature Resistance Totem")
end

local function AddMageTriggers()
    -- Keep buffs up
    AddBidirectionalWidgetInactiveGlow("Arcane Brilliance", {"Arcane Brilliance", "Arcane Intellect"})
    AddBidirectionalWidgetInactiveGlow("Arcane Intellect", {"Arcane Brilliance", "Arcane Intellect"})

    -- Cure debuffs
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Spellsteal", "Magic")
    AddBidirectionalDebuffGlow("Remove Curse", "Curse")
end

local function AddPaladinTriggers()
    -- Keep buffs up
    local PaladinBuffs = {
        "Blessing of Salvation", "Blessing of Protection", "Blessing of Freedom", "Blessing of Sacrifice", "Blessing of Wisdom",
        "Blessing of Might", "Blessing of Light", "Greater Blessing of Kings", "Greater Blessing of Wisdom",
        "Greater Blessing of Might", "Greater Blessing of Sanctuary", "Greater Blessing of Salvation",
        "Greater Blessing of Light",
    }

    local PaladinAuras = {
        "Crusader Aura", "Concentration Aura", "Devotion Aura", "Retribution Aura", "Fire Resistance Aura",
        "Shadow Resistance Aura", "Frost Resistance Aura"
    }

    AddBidirectionalWidgetInactiveGlow("Blessing of Salvation", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Blessing of Protection", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Blessing of Freedom", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Blessing of Sacrifice", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Blessing of Wisdom", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Blessing of Might", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Blessing of Light", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Greater Blessing of Kings", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Greater Blessing of Wisdom", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Greater Blessing of Might", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Greater Blessing of Sanctuary", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Greater Blessing of Salvation", PaladinBuffs)
    AddBidirectionalWidgetInactiveGlow("Greater Blessing of Light", PaladinBuffs)

    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Crusader Aura", PaladinAuras)
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Concentration Aura", PaladinAuras)
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Devotion Aura", PaladinAuras)
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Retribution Aura", PaladinAuras)
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Fire Resistance Aura", PaladinAuras)
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Shadow Resistance Aura", PaladinAuras)
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Frost Resistance Aura", PaladinAuras)

    -- Cure debuffs
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Cleanse", "Disease")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Cleanse", "Disease")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Cleanse", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Cleanse", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Cleanse", "Poison")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Cleanse", "Poison")
end

local function AddPriestTriggers()
    -- Keep buffs up
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Prayer of Fortitude", {"Prayer of Fortitude", "Power Word: Fortitude"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Power Word: Fortitude", {"Prayer of Fortitude", "Power Word: Fortitude"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Prayer of Spirit", {"Prayer of Spirit"})

    -- Cure debuffs
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Purify", "Disease")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Purify", "Disease")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Purify", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Purify", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Dispel Magic", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Dispel Magic", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Mass Dispel", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Mass Dispel", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Abolish Disease", "Disease")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Abolish Disease", "Disease")

    -- Cure explicit debuffs
    SpellAuraUtil:HandleDebuffGlowExplicit(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Fear Ward", "Magic", "Fear")
    SpellAuraUtil:HandleDebuffGlowExplicit(SpellWidgets, PlayerAuras, TargetAuraTypes, "Fear Ward", "Magic", "Fear")
end

local function AddDruidTriggers()
    -- Keep buffs up
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Gift of the Wild", {"Gift of the Wild", "Mark of the Wild"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Mark of the Wild", {"Gift of the Wild", "Mark of the Wild"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Thorns", {"Thorns", "Brambles"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Brambles", {"Thorns", "Brambles"})

    -- Cure Debuffs
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Remove Corruption", "Curse")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Remove Corruption", "Curse")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Remove Corruption", "Poison")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Remove Corruption", "Poison")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Nature's Cure", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Nature's Cure", "Magic")
end

local function AddHunterTriggers()
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Spirit Shock", "Magic")
end

local function AddWarlockTriggers()
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Devour Magic", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Singe Magic", "Magic")
end

local function AddWarriorTriggers()
    -- Keep buffs up
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Battle Shout", {"Battle Shout"})
    SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, PlayerAuras, "Commanding Shout", {"Commanding Shout"})
end

local function AddDwarfTriggers()
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Stoneform", "Curse")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Stoneform", "Disease")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Stoneform", "Magic")
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, PlayerAuras, PlayerAuraTypes, "Stoneform", "Poison")
end

local function UpdateAuraDecorations()
    PlayerAuras = SpellAuraUtil:GetAuras("player")
    TargetAuras = SpellAuraUtil:GetAuras("target")
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