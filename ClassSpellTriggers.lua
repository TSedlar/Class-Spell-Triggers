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
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, SpellName, AuraNames)
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, TargetAuras, SpellName, AuraNames)
end

local function AddSharedTriggers()
    -- "Cure Disease" is a spell for both shamans and priests
    AddBidirectionalDebuffGlow("Cure Disease", "Disease")

    -- Mages, priests, and druids have clear casting states
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Arcane Blast", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Arcane Explosion", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Arcane Missiles", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Blast Wave", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Blizzard", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Cone of Cold", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Dragon's Breath", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Fire Blast", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Fireball", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Flamestrike", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Frost Nova", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Frostbolt", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Ice Lance", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Pyroblast", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Scorch", "Clearcasting")

    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Binding Heal", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Flash Heal", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Greater Heal", "Clearcasting")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Flash of Light", "Clearcasting")

    -- Literally everything for druids can be clearcasted, combat texts make it obvious enough
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Regrowth", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Deft Touch", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Bash", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Claw", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Demoralizing Roar", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Entangling Roots", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Feral Charge", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Ferocious Bite", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Healing Touch", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Hurricane", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Insect Swarm", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Maul", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Moonfire", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Nature's Grasp", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Pounce", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Rake", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Ravage", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Rejuvenation", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Rip", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Shred", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Starfire", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Swiftmend", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Swipe", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Thorns", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Tranquility", "Clearcasting")
    -- SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Wrath", "Clearcasting")
end

local function AddDeathKnightTriggers()
    -- Keep a presence buff up
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Blood Presence", {"Blood Presence", "Frost Presence"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Frost Presence", {"Blood Presence", "Frost Presence"})

    -- Prioritize Blood Boil when target has Blood Plague
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, TargetAuras, "Blood Boil", "Blood Plague")
    -- Prioritize Plague Strike when target does not have Blood Plague
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, TargetAuras, "Plague Strike", {"Blood Plague"}, "target")
end

local function AddShamanTriggers()
    -- Show stack count on aura-related spells
    SpellAuraUtil:HandleWidgetStackCount(SpellWidgets, AuraStackCounts, "Lightning Shield", "Lightning Shield")
    SpellAuraUtil:HandleWidgetStackCount(SpellWidgets, AuraStackCounts, "Water Shield", "Water Shield")

    -- Keep lightning/water shield buffs up
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Lightning Shield", {"Lightning Shield", "Water Shield"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Water Shield", {"Lightning Shield", "Water Shield"})

    -- Keep weapon buffs up
    SpellAuraUtil:HandleInactiveMainHandEnchantGlow(SpellWidgets, "Windfury Weapon")
    SpellAuraUtil:HandleInactiveOffHandEnchantGlow(SpellWidgets, "Windfury Weapon")
    SpellAuraUtil:HandleInactiveMainHandEnchantGlow(SpellWidgets, "Frostbrand Weapon")
    SpellAuraUtil:HandleInactiveOffHandEnchantGlow(SpellWidgets, "Frostbrand Weapon")
    SpellAuraUtil:HandleInactiveMainHandEnchantGlow(SpellWidgets, "Flametongue Weapon")
    SpellAuraUtil:HandleInactiveOffHandEnchantGlow(SpellWidgets, "Flametongue Weapon")
    SpellAuraUtil:HandleInactiveMainHandEnchantGlow(SpellWidgets, "Rockbiter Weapon")
    SpellAuraUtil:HandleInactiveOffHandEnchantGlow(SpellWidgets, "Rockbiter Weapon")

    -- Show shock spells when shamanistic focus is up
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Earth Shock", "Focused")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Flame Shock", "Focused")
    SpellAuraUtil:HandleActiveGlow(SpellWidgets, PlayerAuras, "Frost Shock", "Focused")

    -- Cure debuffs
    SpellAuraUtil:HandleDebuffGlow(SpellWidgets, TargetAuras, TargetAuraTypes, "Purge", "Magic")
    AddBidirectionalDebuffGlow("Cure Poison", "Poison")
    AddBidirectionalDebuffGlow("Poison Cleansing Totem", "Poison")
    AddBidirectionalDebuffGlow("Disease Cleansing Totem", "Disease")
    AddBidirectionalDebuffGlow("Cleanse Spirit", "Curse")
    AddBidirectionalDebuffGlow("Purify Spirit", "Curse")
    AddBidirectionalDebuffGlow("Purify Spirit", "Magic")

    -- Show a darkened spell overlay when totems are active
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Searing Totem", "Searing Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Windfury Totem", "Windfury Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Strength of Earth Totem", "Strength of Earth Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Healing Stream Totem", "Healing Stream Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Grace of Air Totem", "Grace of Air Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Fire Nova Totem", "Fire Nova Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Stoneskin Totem", "Stoneskin Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Mana Spring Totem", "Mana Spring Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Enamored Water Spirit", "Ancient Mana Spring Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Tremor Totem", "Tremor Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Earthbind Totem", "Earthbind Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Stoneclaw Totem", "Stoneclaw Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Windwall Totem", "Windwall Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Tranquil Air Totem", "Tranquil Air Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Magma Totem", "Magma Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Disease Cleansing Totem", "Disease Cleansing Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Poison Cleansing Totem", "Poison Cleansing Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Sentry Totem", "Sentry Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Flametongue Totem", "Flametongue Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Fire Resistance Totem", "Fire Resistance Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Frost Resistance Totem", "Frost Resistance Totem")
    SpellAuraUtil:HandleOverlay(SpellWidgets, PlayerAuras, Totems, "Nature Resistance Totem", "Nature Resistance Totem")
end

local function AddMageTriggers()
    -- Keep buffs up
    -- AddBidirectionalWidgetInactiveGlow("Arcane Brilliance", {"Arcane Brilliance", "Arcane Intellect"})
    -- AddBidirectionalWidgetInactiveGlow("Arcane Intellect", {"Arcane Brilliance", "Arcane Intellect"})

    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Arcane Intellect", {"Arcane Brilliance", "Arcane Intellect"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Arcane Brilliance", {"Arcane Brilliance", "Arcane Intellect"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Frost Armor", {"Frost Armor"})

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

    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Crusader Aura", PaladinAuras)
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Concentration Aura", PaladinAuras)
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Devotion Aura", PaladinAuras)
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Retribution Aura", PaladinAuras)
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Fire Resistance Aura", PaladinAuras)
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Shadow Resistance Aura", PaladinAuras)
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Frost Resistance Aura", PaladinAuras)

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
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Prayer of Fortitude", {"Prayer of Fortitude", "Power Word: Fortitude"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Power Word: Fortitude", {"Prayer of Fortitude", "Power Word: Fortitude"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Prayer of Spirit", {"Prayer of Spirit"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Inner Fire", {"Inner Fire"})

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
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Gift of the Wild", {"Gift of the Wild", "Mark of the Wild"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Mark of the Wild", {"Gift of the Wild", "Mark of the Wild"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Thorns", {"Thorns", "Brambles"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Brambles", {"Thorns", "Brambles"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Omen of Clarity", {"Omen of Clarity"})

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
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Battle Shout", {"Battle Shout"})
    SpellAuraUtil:HandleInactiveGlow(SpellWidgets, PlayerAuras, "Commanding Shout", {"Commanding Shout"})
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
    AddDeathKnightTriggers()
    AddShamanTriggers()
    AddMageTriggers()
    AddPaladinTriggers()
    AddPriestTriggers()
    AddDruidTriggers()
    AddHunterTriggers()
    AddWarlockTriggers()
    AddWarriorTriggers()
    AddDwarfTriggers()
end

local AuraWatcher = CreateFrame("Frame")
AuraWatcher:RegisterUnitEvent("UNIT_AURA", "player") -- Update auras when buffs are changed
AuraWatcher:RegisterUnitEvent("UNIT_AURA", "target") -- Update auras when buffs are changed
AuraWatcher:RegisterEvent("PLAYER_TOTEM_UPDATE") -- Update auras when a totem is used
AuraWatcher:RegisterEvent("UNIT_INVENTORY_CHANGED") -- Update auras when weapon enchants are changed
AuraWatcher:RegisterEvent("PLAYER_TARGET_CHANGED") -- Update auras when target changes
AuraWatcher:RegisterEvent("SPELL_UPDATE_COOLDOWN") -- Update auras when cooldowns change

AuraWatcher:HookScript("OnEvent", function()
    LastAuraChangeTime = time() -- track aura timestamps
    UpdateAuraDecorations()
end)

local ActionBarWatcher = CreateFrame("Frame")
-- ActionBarWatcher:RegisterEvent("ACTIONBAR_SLOT_CHANGED") -- Update when spells are rearranged")

ActionBarWatcher:HookScript("OnEvent", function()
    print("ClassSpellTriggers: Regenerating spell cache (ActionBarSlotChanged)")
    SpellWidgetUtil:Reset(SpellWidgets)
    SpellWidgets = SpellWidgetUtil:GenerateSpellWidgets() -- Regenerate spell mapping when action bar is changed
    UpdateAuraDecorations()
end)

GameLoadFrame:HookScript("OnEvent", function()
    print("ClassSpellTriggers: Regenerating spell cache (GameLoad)")
    SpellWidgets = SpellWidgetUtil:GenerateSpellWidgets() -- Generate spell mapping when game loads
    UpdateAuraDecorations()
end)