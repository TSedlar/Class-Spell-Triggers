SpellWidgetUtil = {}

function SpellWidgetUtil:InjectOverlay(SpellWidget)
    -- Inject the masks on each spell widget
    if not SpellWidget.text then
        SpellWidget.tex = SpellWidget:CreateTexture(nil, "ARTWORK")
        SpellWidget.tex:SetAllPoints(SpellWidget)
        SpellWidget.tex:SetColorTexture(0, 0, 0, 0.0)
    end

    if not SpellWidget.mask then
        SpellWidget.mask = SpellWidget:CreateMaskTexture()
        SpellWidget.mask:SetAllPoints(SpellWidget.tex)
        SpellWidget.mask:SetTexture("Interface/ICONS/6BFBlackrockNova", "CLAMPTOBLACK", "CLAMPTOBLACKADDITIVE")
        SpellWidget.tex:AddMaskTexture(SpellWidget.mask)
    end

    -- Inject the stack counter
    if not SpellWidget.stacks then
        local StackFont = "GameFontHighlightLarge"

        SpellWidget.stacksOutline1 = SpellWidget:CreateFontString(nil, "OVERLAY", StackFont)
        SpellWidget.stacksOutline1:SetPoint("BOTTOMRIGHT", SpellWidget, "BOTTOMRIGHT", -5, 4)
        SpellWidget.stacksOutline1:SetTextColor(0, 0, 0, 1)

        SpellWidget.stacksOutline2 = SpellWidget:CreateFontString(nil, "OVERLAY", StackFont)
        SpellWidget.stacksOutline2:SetPoint("BOTTOMRIGHT", SpellWidget, "BOTTOMRIGHT", -5, 2)
        SpellWidget.stacksOutline2:SetTextColor(0, 0, 0, 1)

        SpellWidget.stacksOutline3 = SpellWidget:CreateFontString(nil, "OVERLAY", StackFont)
        SpellWidget.stacksOutline3:SetPoint("BOTTOMRIGHT", SpellWidget, "BOTTOMRIGHT", -4, 3)
        SpellWidget.stacksOutline3:SetTextColor(0, 0, 0, 1)

        SpellWidget.stacksOutline4 = SpellWidget:CreateFontString(nil, "OVERLAY", StackFont)
        SpellWidget.stacksOutline4:SetPoint("BOTTOMRIGHT", SpellWidget, "BOTTOMRIGHT", -6, 3)
        SpellWidget.stacksOutline4:SetTextColor(0, 0, 0, 1)

        SpellWidget.stacks = SpellWidget:CreateFontString(nil, "OVERLAY", StackFont)
        SpellWidget.stacks:SetPoint("BOTTOMRIGHT", SpellWidget, "BOTTOMRIGHT", -5, 3)
        SpellWidget.stacks:SetTextColor(1, 1, 1, 1)
    end
end

function SpellWidgetUtil:GenerateSpellWidgets()
    local LocalSpellWidgets = {}

    FrameUtil:IterateFrame(UIParent, function(UIFrame)
        local FrameName = UIFrame:GetName()
        if FrameName then
            -- Collect Bartender 4 slots
            local FrameSlot = string.match(FrameName, "BT4Button(%d+)$")
            if FrameSlot ~= nil then
                local SpellName = SpellAuraUtil:GetSpellName(FrameSlot)

                if SpellName ~= nil then
                    SpellWidgetUtil:InjectOverlay(UIFrame)
                    LocalSpellWidgets[SpellName] = FrameName
                end
            end
        end
    end, true)

    return LocalSpellWidgets
end