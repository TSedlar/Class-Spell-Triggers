ArrayUtil = {}

function ArrayUtil:Has(Items, Item)
    for _, ArrayItem in ipairs(Items) do
        if ArrayItem == Item then
            return true
        end
    end
    return false
end

function ArrayUtil:ContainsString(Items, Item)
    for _, ArrayItem in ipairs(Items) do
        if string.find(ArrayItem, Item) then
            return true
        end
    end
    return false
end