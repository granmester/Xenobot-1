local tool = 9016 -- Obsidian knife
local items = { 8895, 8896 } -- ice cubes

--[[ DO NOT TOUCH BELOW THIS LINE ]]--
Module.New("Module:UseItemWithContainerItem", function(mod)
   
    local toolspot = -1
    -- Containers
    for contIndex, cont in Container.iContainers() do
        -- Items in container
        for itemIndex, item in cont:iItems() do
            -- Found tool
            if (item.id == tool) then
                toolspot = itemIndex
                break
            end
        end
        if (toolspot ~= -1) then
            break
        end
    end
     
	local droped = { 3358, 3359, 3377, 3370}
						for i=1, #droped do
							local xd = Self.DropItem(Self.Position().x, Self.Position().y, Self.Position().z, droped[i], 100)
							wait(1000)
						end
	 
    -- Make sure we have found our tool
    if (toolspot ~= -1) then
        -- Containers
        for contIndexs, cont in Container.iContainers() do
            -- Items in container
            for itemIndexs, item in cont:iItems() do
                -- Compare aganist table of IDs
                for _, id in ipairs(items) do
                    -- Found id
                    if (item.id == id) then
                        -- Use tool on item
                        local xx = Container:UseItemWithContainerItem(toolspot, contIndexs, itemIndexs)
						wait(2000)
                    end
                end
            end
        end
    end
    mod:Delay(1000)
end)