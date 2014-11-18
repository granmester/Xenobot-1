-----SETTINGS---------------------------------------------------------------
local ManaID = 238 --- Which mana potions are you using? 
local MinMana = 100 --- How many mana potions until you leave the hunt.
local MaxMana = 250 --- How many mana potions you begin the hunt with.
local ManaPrice = 120 --- What is the price of your selected mana potions?
local HealthID = 3155 --- Which health potions are you using?
local MinHealth = 150 --- How many health potions until you leave the hunt.
local MaxHealth = 1500 --- How many health potions you begin the hunt with.
local HealthPrice = 108 --- What is the price of your selected mana potions?

--CAP--
local MinCap = 5 --- Leaves spawn when character reaches this cap.

--AUTOSELLING--
local sellitems = true --- Set this on true if you want to sell Double Axe and Steel Helmets.

--BP SETUP--
local MainBp  = "backpack of holding" ----- Main Backpack
local GoldBp  = "beach backpack" ---- Backpack to put gold in
local PotionBp  = "jewelled backpack" ---- Potion Bp


-----END OF SETTINGS-------------------------------------------------------
-----DO NOT EDIT BELOW HERE IF YOU DONT KNOW WHAT TO DO--------------------

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
local info = [[
BANUTA HARDCORE By Mathia]]
    print([[
BANUTA HARDCORE By Mathia]])
    wait(5000)
	
--FUNCTIONS--
function NpcConv(...)
    for _, str in ipairs(arg) do
        wait((tostring(str):len() / 125) * 60000 * math.random(1.1, 1.8))
        Self.SayToNpc(str)
    end
end

function buyitems(item, count)
	count = tonumber(count) or 1
	repeat
		local amnt = math.min(count, 100)
		if(Self.ShopBuyItem(item, amnt) == 0)then
			return printf("ERROR: failed to buy item: %s", tostring(item))
		end
        wait(200,500)
		count = (count - amnt)
	until count <= 0
end

Self.ReachDepot = function (tries)
	local tries = tries or 3
	setWalkerEnabled(false)
	local DepotIDs = {3497, 3498, 3499, 3500}
	local DepotPos = {}
	for i = 1, #DepotIDs do
		local dps = Map.GetUseItems(DepotIDs[i])
		for j = 1, #dps do
			table.insert(DepotPos, dps[j])
		end
	end
	local function gotoDepot()
		local pos = Self.Position()
		print("Depots found: " .. tostring(#DepotPos))
		for i = 1, #DepotPos do
			location = DepotPos[i]
			Self.UseItemFromGround(location.x, location.y, location.z)
			wait(1000, 2000)
			if Self.DistanceFromPosition(pos.x, pos.y, pos.z) >= 1 then
				wait(5000, 6000)
				if Self.DistanceFromPosition(location.x, location.y, location.z) == 1 then
					setWalkerEnabled(true)
					return true
				end
			else
				print("Something is blocking the path. Trying next depot.")
			end
		end
		return false
	end
	
	repeat
		reachedDP = gotoDepot()
		if reachedDP then
			return true
		end
		tries = tries - 1
		sleep(100)
		print("Attempt to reach depot was unsuccessfull. " .. tries .. " tries left.")
	until tries <= 0

	return false
end

Map.GetUseItems = function (id)
    if type(id) == "string" then
        id = Item.GetID(id)
    end
    local pos = Self.Position()
    local store = {}
    for x = -7, 7 do
        for y = -5, 5 do
            if Map.GetTopUseItem(pos.x + x, pos.y + y, pos.z).id == id then
                itemPos = {x = pos.x + x, y = pos.y + y, z = pos.z}
                table.insert(store, itemPos)
            end
        end
    end
    return store
end

Self.ReachNpc = function(name, tries)
        local npc = Creature.GetByName(name)
        if (npc:DistanceFromSelf() > 3) then
                tries =  tries or 15
                repeat
                        local nposi = npc:Position()
                        Self.UseItemFromGround(nposi.x, nposi.y, nposi.z)
                        wait(1500)
                        tries = tries - 1
                until (npc:DistanceFromSelf() <= 3) or (tries == 0)
        end
end  

function Self.ShopSellItemsDownTo(item, count)
	wait(300, 1700)
	Self.ShopSellItem(item, Self.ShopGetItemSaleCount(item))
	wait(900, 1200)
end

setTargetingEnabled(true)
setLooterEnabled(true)

-----------------------------------------------------------------
function onWalkerSelectLabel(labelName)
----------------------------------------------------------------------------------------------------
    if (labelName == "Backpacks") then
            	setWalkerEnabled(false)
            Self.CloseContainers()
            Self.OpenMainBackpack(true):OpenChildren({GoldBp, true},{PotionBp, true})
		setWalkerEnabled(true) 
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
    elseif (labelName == "Bank") then
			local withdrawManas = (MaxMana-Self.ItemCount(ManaID))*ManaPrice
			local withdrawHealths = (MaxHealth-Self.ItemCount(HealthID))*HealthPrice
			setWalkerEnabled(false)
			Self.SayToNpc({"hi", "deposit all", "yes"}, 65)
			if (withdrawManas > 0) then
                Self.SayToNpc({"withdraw " .. withdrawManas, "yes"}, 65)
            end
            if (withdrawHealths > 0) then
                Self.SayToNpc({"withdraw " .. withdrawHealths, "yes",}, 65)
            end
            Self.SayToNpc({"balance"}, 65)
            setWalkerEnabled(true)
		sleep(math.random(600, 1100))
----------------------------------------------------------------------------------------------------
    elseif (labelName == "PotionCheck") then
			       	setWalkerEnabled(false)	
		if (Self.ItemCount(ManaID) < MaxMana) or (Self.ItemCount(HealthID) < MaxHealth) then
						print("Failed buying pots - Trying again")
				setWalkerEnabled(true) 
			            gotoLabel("Start")
			else
				        print("GoToHunt")
				setWalkerEnabled(true) 
						gotoLabel("GoToHunt")
			end

----------------------------------------------------------------------------------------------------
    elseif (labelName == "PotionBuy") then
		setWalkerEnabled(false)
		Creature.Follow("Sigurd")
		if (Self.ItemCount(ManaID) < MaxMana or Self.ItemCount(HealthID) < MaxHealth) then
			Self.SayToNpc({"hi", "flasks", "yes", "yes", "trade"}, 65)
		sleep(math.random(600, 1100))
			if (Self.ItemCount(ManaID) < MaxMana) then
				Self.ShopBuyItem(ManaID, (MaxMana - Self.ItemCount(ManaID)))
		sleep(math.random(600, 1100))
			end
			if (Self.ItemCount(HealthID) < MaxHealth) then
				Self.ShopBuyItem(HealthID, (MaxHealth - Self.ItemCount(HealthID)))
		sleep(math.random(600, 1100))
			end
		sleep(math.random(600, 1100))
		end
		setWalkerEnabled(true)
----------------------------------------------------------------------------------------------------
   elseif (labelName == "DepositItems") then
		setWalkerEnabled(false)
            Self.ReachDepot()
            Self.DepositItems(
		{5879, 0}, 	-- 
		{5880, 0}, 	-- 
		{9632, 0}, 	-- 
		{10309, 0}, 	-- 
		{9694, 0}, 	-- 
		{10313, 0}, 	-- 
		{7386, 1}, 	-- 
		{812, 2}, 	-- 
		{811, 3}, 	-- 
		{3381, 4}, 	-- PROFIT
		{3436, 5},	-- 
		{11680, 0}, 	-- 
		{9632, 0}, 	-- 
		{9302, 1}, 	-- 
		{3081, 6}, 	-- 
		{10390, 7}, 	--
		{3315, 11}, 	-- 
		{3392, 8}, 	-- 
		{8074, 9}, 	-- 
		{7402, 7}, 	-- 
		{3079, 8}, 	-- 
		{7456, 10} 	-- 
		)
		sleep(math.random(600, 1100))
		setWalkerEnabled(true)
 ----------------------------------------------------------------------------------------------------
     elseif (labelName == "Check") then
       	setWalkerEnabled(false)	
		if (Self.Cap() > MinCap and Self.ItemCount(ManaID) > MinMana) and (Self.ItemCount(HealthID) > MinHealth) then
				print("Hunt again")
							setWalkerEnabled(true) 
			gotoLabel("Hunt")
		else
			gotoLabel("Refill")	
				print("Leaving to refill")
			setWalkerEnabled(true) 
				end	
----------------------------------------------------------------------------------------------------
  elseif (labelName == "TargetingOff") then 
       	setTargetingEnabled(false)	
        wait(900, 1200)
----------------------------------------------------------------------------------------------------
 elseif (labelName == "TargetingOn") then 
       	setTargetingEnabled(true)	
         wait(900, 1200)
----------------------------------------------------------------------------------------------------
    elseif (labelName == "Pompan") then 
       	setWalkerEnabled(false)	
		if (sellitems==true) then
	Self.SayToNpc({"Hi", "Trade"}, 65)
	wait(900, 1200)
	Self.ShopSellItemsDownTo(10409, 0)
	wait(900, 1200)
	end
	setWalkerEnabled(true) 
----------------------------------------------------------------------------------------------------
end
end