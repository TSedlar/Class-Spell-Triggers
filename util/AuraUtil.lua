SpellAuraUtil = {}

function SpellAuraUtil:GetSpellName(FrameSlot)
    local ActionType, ActionSpellID = GetActionInfo(FrameSlot)
    local SpellName = nil

    if ActionType == "macro" then
        local MacroSpellID = GetMacroSpell(ActionSpellID)
        ActionSpellID = MacroSpellID
    end

    if ActionType == "item" then
        SpellName = GetItemInfo(ActionSpellID)
    elseif ActionType == "spell" or (ActionType == "macro" and ActionSpellID) then
        SpellName = GetSpellInfo(ActionSpellID)
    end

    return SpellName
end

function SpellAuraUtil:GetAuras(Unit)
    local Auras = {}
    local Aura = true
    local AuraIndex = 1
    while Aura ~= nil do
        if not Aura then
            break
        end
        Aura = UnitAura(Unit, AuraIndex)
        if Aura ~= nil then
            table.insert(Auras, Aura)
        end
        AuraIndex = AuraIndex + 1
    end
    return Auras
end

function SpellAuraUtil:HasAura(Auras, Aura)
    return ArrayUtil:Has(Auras, Aura)
end

function SpellAuraUtil:GetAuraStacks(Unit)
    local AuraStacks = {}
    local CurrentAura = true
    local AuraIndex = 1
    while CurrentAura ~= nil do
        local Aura, _, StackCount = UnitAura(Unit, AuraIndex)
        if not Aura then
            break
        end
        if StackCount ~= nil and StackCount > 0 then
            AuraStacks[Aura] = StackCount
        end
        AuraIndex = AuraIndex + 1
        CurrentAura = Aura
    end
    return AuraStacks
end

function SpellAuraUtil:GetAuraStackCount(AuraStackCounts, Aura)
    if AuraStackCounts[Aura] ~= nil then
        return AuraStackCounts[Aura]
    end

    return 0
end

function SpellAuraUtil:GetAuraTypes(Unit)
    local AuraTypes = {}
    local AuraIndex = 1
    local CurrentAuraType = true

    while CurrentAuraType ~= nil do
        if not CurrentAuraType then
            break
        end
        local _, _, _, AuraType = UnitAura(Unit, AuraIndex)
        if AuraType ~= nil and not ArrayUtil:Has(AuraTypes, AuraType) then
            table.insert(AuraTypes, AuraType)
        end
        AuraIndex = AuraIndex + 1
        CurrentAuraType = AuraType
    end
    return AuraTypes
end

function SpellAuraUtil:HasAuraType(AuraTypes, AuraType)
    return ArrayUtil:Has(AuraTypes, AuraType)
end

function SpellAuraUtil:GetTotems()
    local _, fireTotemName, _, _ = GetTotemInfo(1)
    local _, earthTotemName, _, _ = GetTotemInfo(2)
    local _, waterTotemName, _, _ = GetTotemInfo(3)
    local _, airTotemName, _, _ = GetTotemInfo(4)

    return { fireTotemName, earthTotemName, waterTotemName, airTotemName }
end

function SpellAuraUtil:HasTotem(Totems, Totem)
    return ArrayUtil:ContainsString(Totems, Totem)
end

function SpellAuraUtil:HandleWidgetStackCount(SpellWidgets, AuraStackCounts, SpellName, AuraName)
    local WidgetName = SpellWidgets[SpellName]
    if WidgetName ~= nil then
        local SpellWidget = _G[WidgetName]
        if SpellWidget ~= nil then
            if SpellWidget.tex == nil then
                SpellWidgetUtil.InjectOverlay(SpellWidget)
            end

            local StackCount = AuraStackCounts[AuraName]
            if StackCount ~= nil and StackCount > 0 then
                SpellWidget.stacks:SetText(tostring(StackCount))
                SpellWidget.stacksOutline1:SetText(tostring(StackCount))
                SpellWidget.stacksOutline2:SetText(tostring(StackCount))
                SpellWidget.stacksOutline3:SetText(tostring(StackCount))
                SpellWidget.stacksOutline4:SetText(tostring(StackCount))
            else
                SpellWidget.stacks:SetText("")
                SpellWidget.stacksOutline1:SetText("")
                SpellWidget.stacksOutline2:SetText("")
                SpellWidget.stacksOutline3:SetText("")
                SpellWidget.stacksOutline4:SetText("")
            end
        end
    end
end

function SpellAuraUtil:HandleWidgetActiveGlow(SpellWidgets, Auras, SpellName, AuraName)
    local WidgetName = SpellWidgets[SpellName]
    if WidgetName ~= nil then
        local SpellWidget = _G[WidgetName]
        if SpellWidget ~= nil then
            if SpellWidget.tex == nil then
                SpellWidgetUtil.InjectOverlay(SpellWidget)
            end

            if SpellAuraUtil:HasAura(Auras, AuraName) then
                ActionButton_ShowOverlayGlow(SpellWidget)
            else
                ActionButton_HideOverlayGlow(SpellWidget)
            end
        end
    end
end

function SpellAuraUtil:HandleWidgetInactiveGlow(SpellWidgets, Auras, SpellName, AuraNames)
    local WidgetName = SpellWidgets[SpellName]
    if WidgetName ~= nil then
        local SpellWidget = _G[WidgetName]
        if SpellWidget ~= nil then
            if SpellWidget.tex == nil then
                SpellWidgetUtil.InjectOverlay(SpellWidget)
            end

            local HasAnyAura = false
            for _,AuraName in ipairs(AuraNames) do
                if SpellAuraUtil:HasAura(Auras, AuraName) then
                    HasAnyAura = true
                end
            end

            if not HasAnyAura then
                ActionButton_ShowOverlayGlow(SpellWidget)
            else
                ActionButton_HideOverlayGlow(SpellWidget)
            end
        end
    end
end

function SpellAuraUtil:HandleWidgetDebuffGlow(SpellWidgets, Auras, AuraTypes, SpellName, AuraName)
    local WidgetName = SpellWidgets[SpellName]
    if WidgetName ~= nil then
        local SpellWidget = _G[WidgetName]
        if SpellWidget ~= nil then
            if SpellWidget.tex == nil then
                SpellWidgetUtil.InjectOverlay(SpellWidget)
            end

            if SpellAuraUtil:HasAuraType(AuraTypes, AuraName) then
                ActionButton_ShowOverlayGlow(SpellWidget)
            else
                ActionButton_HideOverlayGlow(SpellWidget)
            end
        end
    end
end

function SpellAuraUtil:HandleWidgetOverlay(SpellWidgets, Auras, Totems, SpellName, AuraName)
    local WidgetName = SpellWidgets[SpellName]
    if WidgetName ~= nil then
        local SpellWidget = _G[WidgetName]
        if SpellWidget ~= nil then
            if SpellWidget.tex == nil then
                SpellWidgetUtil.InjectOverlay(SpellWidget)
            end

            if SpellAuraUtil:HasAura(Auras, AuraName) or SpellAuraUtil:HasTotem(Totems, AuraName) then
                SpellWidget.tex:SetColorTexture(0, 0, 0, 0.9)
            else
                SpellWidget.tex:SetColorTexture(0, 0, 0, 0.0)
            end
        end
    end
end