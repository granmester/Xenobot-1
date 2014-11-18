local config = {
    ['Demon'] = {"exori max frigo", "exori gran frigo", "exori frigo"},
    ['Massive Fire Elemental'] = {"exori max frigo", "exori gran frigo", "exori frigo"},
	['Hero'] = {"exori max frigo", "exori gran frigo", "exori mort"}
}
while (true) do
    local targ = Creature.GetByID(Self.TargetID())
    if targ:isAlive() then
        for name, spells in pairs(config) do
            if targ:Name() == name and targ:isAlive() and targ:DistanceFromSelf() <= 3 then
                for x=1, #spells do
                    if Self.CanCastSpell(spells[x]) then
                        Self.Say(spells[x])
                    end
                end
            end
        end
    end
    wait(50)
end