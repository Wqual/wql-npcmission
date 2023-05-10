RegisterNetEvent("SearchMandante", function ()
    local item = {"valigia"}
    exports.ox_inventory:AddItem(source, "valigia", 1)
end)

RegisterNetEvent("vendita_missione", function()
    exports.ox_inventory:RemoveItem(source, "valigia", 1)
    exports.ox_inventory:AddItem(source, "black_money", math.random(13000, 23000))
end)
