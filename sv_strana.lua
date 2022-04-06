local QBCore = exports['galaxy-core']:GetCoreObject()

print("qb-kladionica | Kladionica Pokrenuta!")


QBCore.Functions.CreateCallback('qb-kladionica:povuciutakmice', function(source, cb)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    MySQL.Async.fetchAll("SELECT * FROM qb_kladionica", {}, function(rezultat)
        local utakmicex = {}
        if rezultat then
            for i = 1, #rezultat, 1 do
                table.insert(utakmicex, {id = rezultat[i].id, tim1 = rezultat[i].tim1, tim2 = rezultat[i].tim2, kec = rezultat[i].kec, x = rezultat[i].x, dvojka = rezultat[i].dvojka, status = rezultat[i].status})
            end
            cb(utakmicex)
        end
    end)
end)

RegisterCommand("postaviutakmicu", function(source, args)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.PlayerData.job.name == Config.Kladionica.VlasnikPosao then
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil and tonumber(args[4]) ~= nil and tonumber(args[5]) ~= nil then
            TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Postavili ste novu utakmicu!", "success")
            MySQL.Async.execute("INSERT INTO qb_kladionica (tim1, tim2, kec, x, dvojka) VALUES (@tim1, @tim2, @kec, @x, @dvojka)", { ["@tim1"] = args[1], ["@tim2"] = args[2], ["@kec"] = tonumber(args[3]), ["@x"] = tonumber(args[4]), ["@dvojka"] = args[5] } )
        else
            TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Tim1, Tim2, [1-Kvota], [X-Kvota], [2-Kvota]", "success")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Niste gazda kladionice!", "error")
    end
end)

RegisterCommand("zapocniutakmicu", function(source, args)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.PlayerData.job.name == Config.Kladionica.VlasnikPosao then
        MySQL.Async.fetchAll("SELECT * FROM qb_kladionica WHERE id = @id", { ["@id"] = tonumber(args[1]) }, function(rezultat)
            if tonumber(args[1]) ~= nil then
                if rezultat then
                    for i = 1, #rezultat, 1 do
                        if rezultat[i].status == 'Nije Pocelo' then
                            if tonumber(args[1]) == tonumber(rezultat[i].id) then
                                TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Zapoceli ste utakmicu "..args[1].."!", "success")
                                MySQL.Sync.execute("UPDATE qb_kladionica SET status = @status WHERE id = @id", { ["@id"] = tonumber(args[1]), ["@status"] = 'U tijeku' })
                            else
                                TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Ta utakmica ne postoji!", "error")
                            end
                        else
                            TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Utakmica je vec zapoceta!", "error")
                        end
                    end
                else
                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Ta utakmica ne postoji!", "error")
                end
            else
                TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | ID Utakmice", "success")
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Niste gazda kladionice!", "error")
    end
end)

RegisterCommand("urediutakmicu", function(source, args)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.PlayerData.job.name == Config.Kladionica.VlasnikPosao then
        MySQL.Async.fetchAll("SELECT * FROM qb_kladionica WHERE id = @id", { ["@id"] = tonumber(args[1]) }, function(rezultat)
            if rezultat then
                for i = 1, #rezultat, 1 do
                    if tonumber(args[1]) ~= nil and args[2] ~= nil and (args[2] == "X" or args[2] == "x" or args[2] == "1" or args[2] == "2") then
                        MySQL.Sync.execute("UPDATE qb_kladionica SET status = @status WHERE id = @id", { ["@id"] = tonumber(args[1]), ["@status"] = args[2] })
                    else
                        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | ID, 1/X/2", "success")
                    end
                end
            else
                TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Ta utakmica ne postoji!", "error")
            end
        end)    
    else
        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Niste gazda kladionice!", "error")
    end
end)

RegisterCommand("obrisiutakmicu", function(source, args)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.PlayerData.job.name == Config.Kladionica.VlasnikPosao then
        MySQL.Async.fetchAll("SELECT * FROM qb_kladionica WHERE id = @id", { ["@id"] = tonumber(args[1]) }, function(rezultat)
            if rezultat then
                for i = 1, #rezultat, 1 do
                    if tonumber(args[1]) ~= nil then
                        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Obrisali ste utakmicu broj: "..tonumber(args[1]).."!", "success")
                        MySQL.Async.execute("DELETE FROM qb_kladionica WHERE id LIKE @id", {
                            ["@id"] = tonumber(args[1]),
                        })
                    else
                        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | ID Utakmice", "success")
                    end
                end
            else
                TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Ta utakmica ne postoji!", "error")
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Niste gazda kladionice!", "error")
    end
end)

RegisterCommand("isplatiulog", function(source, args)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if tonumber(args[1]) ~= nil then
        MySQL.Async.fetchAll("SELECT * FROM qb_kladionica WHERE id = @id", { ["@id"] = tonumber(args[1]) }, function(rezultat)
            if rezultat then
                for i = 1, #rezultat, 1 do
                    MySQL.Async.fetchAll("SELECT * FROM qb_kladjenja WHERE igrac = @igrac ", { ["@igrac"] = xPlayer.PlayerData.citizenid }, function(ulog)
                        if ulog then
                            for i = 1, #ulog, 1 do
                                if rezultat[i] then
                                    if rezultat[i].status ~= 'Nije Pocelo' and rezultat[i].status ~= 'U tijeku' then
                                        if ulog[i] then
                                            if rezultat[i].status == 'X' then
                                                if (rezultat[i].id and rezultat[i].status) == (ulog[i].tekma and ulog[i].x12) then
                                                    MySQL.Async.execute('DELETE from qb_kladjenja WHERE igrac = @igrac AND tekma = @tekma', {
                                                        ['@igrac'] = xPlayer.PlayerData.citizenid,
                                                        ['@tekma'] = tonumber(args[1])
                                                    })
                                                    xPlayer.Functions.AddMoney('cash', ulog[i].ulog * rezultat[i].x)
                                                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Isplatili ste $"..(ulog[i].ulog * rezultat[i].x).." od utakmice: "..args[1].."!", "success")    
                                                else
                                                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Niste dobili nista na kladionici. Izgubili ste $"..json.encode(tonumber(ulog[i].ulog)).."!", "success")
                                                    MySQL.Async.execute('DELETE from qb_kladjenja WHERE igrac = @igrac AND tekma = @tekma', {
                                                        ['@igrac'] = xPlayer.PlayerData.citizenid,
                                                        ['@tekma'] = tonumber(args[1])
                                                    })
                                                end
                                            elseif rezultat[i].status == 'x' then
                                                if (rezultat[i].id and rezultat[i].status) == (ulog[i].tekma and ulog[i].x12) then
                                                    xPlayer.Functions.AddMoney('cash', ulog[i].ulog * rezultat[i].x)
                                                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Isplatili ste $"..ulog[i].ulog * rezultat[i].x.." od utakmice: "..args[1].."!", "success")
                                                    MySQL.Async.execute('DELETE from qb_kladjenja WHERE igrac = @igrac AND tekma = @tekma', {
                                                        ['@igrac'] = xPlayer.PlayerData.citizenid,
                                                        ['@tekma'] = tonumber(args[1])
                                                    })
                                                else
                                                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Niste dobili nista na kladionici. Izgubili ste $"..json.encode(tonumber(ulog[i].ulog)).."!", "success")
                                                    MySQL.Async.execute('DELETE from qb_kladjenja WHERE igrac = @igrac AND tekma = @tekma', {
                                                        ['@igrac'] = xPlayer.PlayerData.citizenid,
                                                        ['@tekma'] = tonumber(args[1])
                                                    })
                                                end
                                            elseif rezultat[i].status == '1' then
                                                if (json.encode(rezultat[i].id) and json.encode(rezultat[i].status)) == (json.encode(ulog[i].tekma) and json.encode(ulog[i].x12)) then
                                                    xPlayer.Functions.AddMoney('cash', ulog[i].ulog * rezultat[i].kec)
                                                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Isplatili ste $"..ulog[i].ulog * rezultat[i].kec.." od utakmice: "..args[1].."!", "success")
                                                    MySQL.Async.execute('DELETE from qb_kladjenja WHERE igrac = @igrac AND tekma = @tekma', {
                                                        ['@igrac'] = xPlayer.PlayerData.citizenid,
                                                        ['@tekma'] = tonumber(args[1])
                                                    })
                                                else
                                                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Niste dobili nista na kladionici. Izgubili ste $"..json.encode(tonumber(ulog[i].ulog)).."!", "success")
                                                    MySQL.Async.execute('DELETE from qb_kladjenja WHERE igrac = @igrac AND tekma = @tekma', {
                                                        ['@igrac'] = xPlayer.PlayerData.citizenid,
                                                        ['@tekma'] = tonumber(args[1])
                                                    })
                                                end
                                            elseif rezultat[i].status == '2' then
                                                if (rezultat[i].id and rezultat[i].status) == (ulog[i].tekma and ulog[i].x12) then
                                                    xPlayer.Functions.AddMoney('cash', ulog[i].ulog * rezultat[i].dvojka)
                                                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Isplatili ste $"..ulog[i].ulog * rezultat[i].dvojka.." od utakmice: "..args[1].."!", "success")
                                                    MySQL.Async.execute('DELETE from qb_kladjenja WHERE igrac = @igrac AND tekma = @tekma', {
                                                        ['@igrac'] = xPlayer.PlayerData.citizenid,
                                                        ['@tekma'] = tonumber(args[1])
                                                    })
                                                else
                                                    TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Niste dobili nista na kladionici. Izgubili ste $"..json.encode(tonumber(ulog[i].ulog)).."!", "success")
                                                    MySQL.Async.execute('DELETE from qb_kladjenja WHERE igrac = @igrac AND tekma = @tekma', {
                                                        ['@igrac'] = xPlayer.PlayerData.citizenid,
                                                        ['@tekma'] = tonumber(args[1])
                                                    })
                                                end
                                            end
                                        end
                                    else
                                        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | Ne mozete isplatiti ulog jer utakmica nije zavrsena!", "error")
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', source, "qb-kladionica | ID Utakmice", "success")
    end
end)

RegisterCommand("kladise", function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    MySQL.Async.fetchAll("SELECT * FROM qb_kladionica WHERE id = @id", { ["@id"] = args[1] }, function(rezultat)
        if rezultat then
            MySQL.Async.fetchAll("SELECT * FROM qb_kladjenja WHERE igrac = @igrac ", { ["@igrac"] = xPlayer.PlayerData.citizenid }, function(ulog)
                if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil and args[3] ~= nil and (args[3] == "X" or args[3] == "x" or args[3] == "1" or args[3] == "2") then
                    for i = 1, #rezultat, 1 do
                        if tonumber(args[1]) == rezultat[i].id then
                            if rezultat[i].status == 'Nije Pocelo' then
                                local max = MySQL.Sync.fetchScalar("SELECT COUNT(tekma) FROM qb_kladjenja WHERE tekma = @tekma AND igrac = @igrac", { ["@tekma"] = tonumber(args[1]), ["@igrac"] = xPlayer.PlayerData.citizenid} )
                                if max < 1 then
                                    if tonumber(args[2]) <= Config.Kladionica.MaxUlog and tonumber(args[2]) >= Config.Kladionica.MinUlog then
                                        if xPlayer.Functions.GetMoney('cash') >= tonumber(args[2]) then
                                            xPlayer.Functions.RemoveMoney("cash", tonumber(args[2]), "Kladionica")
                                            print(args[2])
                                            MySQL.Async.execute("INSERT INTO qb_kladjenja (igrac, imeigraca, tekma, ulog, x12) VALUES (@igrac, @imeigraca, @tekma, @ulog, @x12)", { ["@igrac"] = xPlayer.PlayerData.citizenid, ["@imeigraca"] = GetPlayerName(src), ["@tekma"] = tonumber(args[1]), ["@ulog"] = tonumber(args[2]), ["@x12"] = args[3] } )
                                            TriggerClientEvent('QBCore:Notify', src, "qb-kladionica | Stavili ste $"..tonumber(args[2]).." na "..args[3]..", utakmica broj: "..tonumber(args[1]).."!", "success")
                                        else
                                            TriggerClientEvent('QBCore:Notify', src, "qb-kladionica | Nemate dovoljno novca!", "error")
                                        end
                                    else
                                        TriggerClientEvent('QBCore:Notify', src, "qb-kladionica | Ulog ne moze biti manji od $100 i veci od $50000!", "error")
                                    end
                                else
                                    TriggerClientEvent('QBCore:Notify', src, "qb-kladionica | Vec ste se kladili na tu utakmicu!", "error")
                                end
                            else
                                TriggerClientEvent('QBCore:Notify', src, "qb-kladionica | Ne mozete se trenutno kladiti na ovu utakmicu!", "error")
                            end
                        else
                            TriggerClientEvent('QBCore:Notify', src, "qb-kladionica | Ta utakmica ne postoji!", "error")
                        end
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, "qb-kladionica | ID Utakmice, Kolicina, 1/X/2!", "error")
                end
            end)
        end
    end)
end)