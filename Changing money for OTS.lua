function useCoins(id) 
local cont = Container.GetFirst() 
 
while (cont:isOpen()) do
for spot = 0, cont:ItemCount() do
local item = cont:GetItemData(spot) 
if (item.id == id) then
if (item.count == 100) then
cont:UseItem(spot, True)
sleep(500)
return true
end
end
end
 
cont = cont:GetNext() 
end
 
return false
end
 
while (true) do
useCoins(3031)--gold
sleep(500)
useCoins(3035)--platinum
sleep(500)
end