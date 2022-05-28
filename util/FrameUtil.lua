FrameUtil = {}

function FrameUtil:IterateFrame(ParentFrame, Callback, Recursive)
    if ParentFrame ~= nil and not ParentFrame:IsForbidden() then
        local ChildCount = select("#", ParentFrame:GetChildren())

        if not ParentFrame:IsForbidden() then
            Callback(ParentFrame)
        end

        for i = 1, ChildCount do
            local ChildFrame = select(i, ParentFrame:GetChildren())

            if ChildFrame ~= nil then
                if Recursive then
                    FrameUtil:IterateFrame(ChildFrame, Callback, Recursive)
                else
                    if not ChildFrame:IsForbidden() then
                        Callback(ChildFrame)
                    end
                end
            end
        end
    end
end