--[[
Instructions:
Attacks are prioritized least to greatest.

Required parameters:
words = spell words or rune id
min = minimum monster amount to trigger spell/rune
distance = the max range of the attack

Optional parameters:
max = the max monsters the spell will attack
mana = the minimum mana you want to have before casting
padding = the extra sqm's to check for players PAST the attack distance (default is 0)
needsTarget = the attack needs a target (exori hur, etc)
needsDirection = spells most effective when facing target (exori min)
multiFloor = check for players above/below (stairhop skulling)
ignoreParty = ignore player checks for party members
whiteList = table of players to ignore
targetList = table of monsters to attack, to attack all do not specify this option

]]


attack = {}
	attack[1] = {words="exori gran", min=5, distance=1, padding=2, multiFloor=true, ignoreParty=false, whiteList={"Syntax", "DarkstaR"}}
	attack[2] = {words="exori min", min=3, mana=100, needsDirection=true, distance=1, padding=2, multiFloor=true, ignoreParty=true, targetList={"Lizard Chosen, Sea Serpents"}}
	attack[3] = {words="exori", min=3, distance=1, padding=2, multiFloor=true, ignoreParty=true}
	attack[4] = {words="exori hur", min=1, max=1, needsTarget=true, distance=3, padding=0, multiFloor=false, ignoreParty=true}
	attack[4] = {words="exori ico", min=1, max=1, needsTarget=true, distance=1, padding=0, multiFloor=false, ignoreParty=true}


function getTargetCount(distance, padding, multiFloor, ignoreParty, whiteList, targetList)
	local n = 0
	padding = padding or 0
	whiteList = whiteList or {}
	targetList = targetList or {}
	for i = CREATURES_LOW, CREATURES_HIGH do
		local cid = Creature.GetFromIndex(i)
		local checkPad = cid:isPlayer() and padding or 0
		if(cid:isValid() and cid:isVisible() and cid:isAlive() and getDistanceBetween(cid:Position(), Self.Position()) <= (distance + checkPad) and not cid:isSelf())then
			if(getSelfPosition().z == cid:Position().z or (multiFloor and cid:isPlayer()))then
				if(cid:isPlayer() and (not cid:isPartyMember() or not ignoreParty) and not table.find(whiteList, cid:Name(), false))then
					return 0
				elseif(cid:isMonster() and (table.find(targetList, cid:Name(), false) or #targetList<1))then
					n = n + 1
				end
			end
		end
	end
	return n
end

function main()
	for i = 1, #attack do
		local atk = attack[i]
		local count = getTargetCount(atk.distance, atk.padding, atk.multiFloor, atk.ignoreParty, atk.whiteList, atk.targetList)
		if(count > 0)then
			if(count >= atk.min and count <= ((atk.max == nil) and count or atk.max))then
				if(type(atk.words) == 'number')then
					Self.UseItemWithMe(atk.words)
					wait(900, 1200)
				elseif(Self.CanCastSpell(atk.words) and (not atk.mana or Self.Mana() >= atk.mana))then
					local target = Creature.GetByID(Self.TargetID())
					if(atk.needsTarget or atk.needsDirection)then
						if(target:isOnScreen() and target:isVisible() and target:isAlive())then
							if(getDistanceBetween(target:Position(), Self.Position()) <= atk.distance)then
								if(atk.needsDirection)then
									local pos, toPos = getSelfPosition(), target:Position()
									local dir = pos.x > toPos.x and WEST or pos.x < toPos.x and EAST or pos.y > toPos.y and NORTH or SOUTH
									Self.Turn(dir)
									wait(100, 200)
								else
									Self.Say(atk.words)
								end
							end
						end
					end
					if(not atk.needsTarget)then
						Self.Say(atk.words)
					end
					wait(600, 1000)
				end
			end
		end
	end
	sleep(1000)
end

print([[
Name: Auto Area Attack
Description: Shoots area spells/rune on certain conditions
Author: Cavitt Glover (Syntax)
Version: 5.0.00 (updated 11.26.2012)]])
wait(2000)

registerEventListener(TIMER_TICK, "main")