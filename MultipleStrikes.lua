--[[Mages Multiple Strike Spells]]--  
local targets = {"Sea Serpent", "Young Sea Serpent"} 
-- Just change below to suit your needs.
    local spells = {}
    spells[1] = { spell = "exori ico" } --Max spell
    spells[2] = { spell = "exori hur" } --Gran spell
    spells[3] = { spell = "exori hur" } --Nooby spell (This will be the only spell cast after Target <= 35% HP)  
Module.New("Multiple Strike Spells", function(module)
for _, data in ipairs(spells) do
    local c = Creature.GetByID(Self.TargetID())
        if table.contains(targets, c:Name()) then
            if c:DistanceFromSelf() <= 3 then
                if Self.TargetID() ~= 0 then
                        for x=1, #spells do
                            if Self.CanCastSpell(data.spell) then
                                Self.Say(data.spell)
                                wait(500, 1500)
                            end
                        end
                    end
                end
            end
        end
    module:Delay(1000)
end)