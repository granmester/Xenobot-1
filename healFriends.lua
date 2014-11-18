--[[
Auto Healer
Version 1.02
Created by Syntax
]]

local config = {
	WhiteList = {"Kesiek", "Bucham Mlekiem", "Jorion Holius", "Szwagru", "Sezerp", "Sylart Flin", "Mati Ora Ekiem", "Perfect Ek"},
	healWhiteList = true, -- heal players specified in the whitelist
	healParty = true, -- heal party members
	healAlly = true, -- heal war allies

	range = 6, -- max distance to heal players
	mana = 140, -- minimum mana needed to cast
	health = 75, -- % of friend's health to heal at

	method = "exura sio" -- this is the only method currently, rune healing will be added later
}

local function sio(name)
	if(Self.Mana() >= config.mana)then
		Self.Say("exura sio \""..name)
		sleep(math.random(200,600))
	end
end

local function think()
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if (creature:isValid()) then
			if (creature:isOnScreen() and creature:isVisible() and creature:isAlive()) then
				local name = creature:Name()
				if(creature:isWarAlly() and config.healAlly) or (creature:isPartyMember() and config.healParty) or (table.find(config.WhiteList, name, false) and config.healWhiteList)then
					if(creature:DistanceFromSelf() <= config.range) and (creature:HealthPercent() <= config.health)then
						if(config.method == "exura sio")then
							sio(name)
						else
							displayInformationMessage("Unsupported method type in Auto Healer Script!")
						end
					end
				end
			end
		end
	end
	sleep(math.random(100,300))
	think()
end

local function display()
	local display = "Auto Healer by Syntax (v1.02)\n------------------\n\nMethod: " .. config.method .. "\nHeal Party: " .. tostring(config.healParty) .. "\n" .. "Heal War Allies: " .. tostring(config.healAlly)
	if(config.healWhiteList)then
		display = display .. "\n" .. "Heal Players:" .. table.concat(config.WhiteList, ", ")
	end
	displayInformationMessage(display)
end

display()
think()