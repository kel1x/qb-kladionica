local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local PlayerJob = {}

CreateThread(function()
	PlayerData = QBCore.Functions.GetPlayerData
end)

print("qb-kladionica | Kladionica Pokrenuta!")

AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerJob = job
end)

AddEventHandler('onResourceStart', function(resource)--if you restart the resource
    if resource == GetCurrentResourceName() then
        Wait(200)
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

function PomocniText(tekst)
    SetTextComponentFormat("STRING")
    AddTextComponentString(tekst)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

CreateThread(function()
    while true do
        Wait(0)
        local igrac = PlayerPedId()
        local kordinate = GetEntityCoords(igrac)
        local distanca = #(kordinate - Config.Kladionica.Lokacija)
        local spavaj = true
        if distanca < 10 then
            spavaj = false
            DrawMarker(2, Config.Kladionica.Lokacija, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.15, 0.15, 0.15, 200, 0, 50, 230, true, true, 2, true, false, false, false)
            DrawMarker(2, Config.Kladionica.Lokacija, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 150, false, true, 1, true, false, false, false)

            if distanca < 1.5 then
                PomocniText("Pritisnite ~INPUT_VEH_HORN~ da pogledate danasnju ponudu!")
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('qb-kladionica:otvori')
                end
            end
        end

        if spavaj then Wait(2000) end
    end
end)

RegisterNetEvent('qb-kladionica:otvori')
AddEventHandler('qb-kladionica:otvori', function()
    QBCore.Functions.TriggerCallback('qb-kladionica:povuciutakmice', function(utakmicex)
        local tekme = {}
        if PlayerJob.name == Config.Kladionica.VlasnikPosao then
            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 0,
                    header = 'Danasnja ponuda || qb-kladionica',
                    txt = ''
                },
            })

            if utakmicex ~= nil then
                for k, v in pairs(utakmicex) do
                    local IDUtakmice = v.id
                    table.insert(tekme, {
                        id = k,
                        header = 'ID: '..v.id..' | '..v.tim1..' - '..v.tim2..' | '..v.status..'!',
                        txt = '1: '..v.kec..' | X: '..v.x..' | 2: '..v.dvojka..'',
                        params = {
                            event = 'qb-kladionica:ulozi',
                            args = IDUtakmice,
                        }
                    })
                end
                if #tekme ~= 0 then
                    TriggerEvent('nh-context:sendMenu', tekme)
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+1,
                            header = '=================================',
                            txt = ''
                        }
                    })
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+2,
                            header = 'Gazda Meni',
                            txt = 'Upravljajte kladionicom.',
                            params = {
                                event = 'qb-kladionica:otvoriBoss',
                            }
                        },
                    })
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+3,
                            header = 'Isplatite tikete!',
                            txt = '',
                            params = {
                                event = 'qb-kladionica:isplatiulog',
                            }
                        },
                    })
                else
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = 1,
                            header = 'Danas nema nikakvih ponuda!',
                            txt = ''
                        }
                    })
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+1,
                            header = '=================================',
                            txt = ''
                        }
                    })
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+2,
                            header = 'Gazda Meni',
                            txt = 'Upravljajte kladionicom.',
                            params = {
                                event = 'qb-kladionica:otvoriBoss',
                            }
                        },
                    })
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+3,
                            header = 'Isplatite tikete!',
                            txt = '',
                            params = {
                                event = 'qb-kladionica:isplatiulog',
                            }
                        },
                    })
                end
            else
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = 1,
                        header = 'Danas nema nikakvih ponuda!',
                        txt = ''
                    }
                })
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = #tekme+1,
                        header = '=================================',
                        txt = ''
                    }
                })
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = #tekme+2,
                        header = 'Gazda Meni',
                        txt = 'Upravljajte kladionicom.',
                        params = {
                            event = 'qb-kladionica:otvoriBoss',
                        }
                    },
                })
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = #tekme+3,
                        header = 'Isplatite tikete!',
                        txt = '',
                        params = {
                            event = 'qb-kladionica:isplatiulog',
                        }
                    },
                })
            end
            ------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------
        else
            ------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------
            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 0,
                    header = 'Danasnja ponuda || qb-kladionica',
                    txt = ''
                },
            })
            
            if utakmicex ~= nil then
                for k, v in pairs(utakmicex) do
                    local IDUtakmice = v.id
                    table.insert(tekme, {
                        id = k,
                        header = 'ID: '..v.id..' | '..v.tim1..' - '..v.tim2..' | '..v.status..'!',
                        txt = '1: '..v.kec..' | X: '..v.x..' | 2: '..v.dvojka..'',
                        params = {
                            event = 'qb-kladionica:ulozi',
                            args = IDUtakmice,
                        }
                    })
                end
                if #tekme ~= 0 then
                    TriggerEvent('nh-context:sendMenu', tekme)
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+1,
                            header = '=================================',
                            txt = ''
                        }
                    })
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+3,
                            header = 'Isplatite tikete!',
                            txt = '',
                            params = {
                                event = 'qb-kladionica:isplatiulog',
                            }
                        },
                    })
                else
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = 1,
                            header = 'Danas nema nikakvih ponuda!',
                            txt = ''
                        }
                    })
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+1,
                            header = '=================================',
                            txt = ''
                        }
                    })
                    TriggerEvent('nh-context:sendMenu', {
                        {
                            id = #tekme+3,
                            header = 'Isplatite tikete!',
                            txt = '',
                            params = {
                                event = 'qb-kladionica:isplatiulog',
                            }
                        },
                    })
                end
            else
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = 1,
                        header = 'Danas nema nikakvih ponuda!',
                        txt = ''
                    }
                })
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = #tekme+1,
                        header = '=================================',
                        txt = ''
                    }
                })
                TriggerEvent('nh-context:sendMenu', {
                    {
                        id = #tekme+3,
                        header = 'Isplatite tikete!',
                        txt = '',
                        params = {
                            event = 'qb-kladionica:isplatiulog',
                        }
                    },
                })
            end
        end
    end, utakmicex)
end)

RegisterNetEvent('qb-kladionica:otvoriBoss')
AddEventHandler('qb-kladionica:otvoriBoss', function()
    QBCore.Functions.TriggerCallback('qb-kladionica:povuciutakmice', function(utakmicex)
        if PlayerJob.name == Config.Kladionica.VlasnikPosao then
            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 0,
                    header = 'Gazda Meni || qb-kladionica',
                    txt = ''
                },
            })

            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 1,
                    header = 'Zapocnite utakmicu',
                    txt = 'Pokrenite utakmicu.',
                    params = {
                        event = 'qb-kladionica:pokreniteutakmicu',
                    }
                },
            })

            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 2,
                    header = '=================================',
                    txt = '',
                    params = {
                        event = '',
                    }
                },
            })

            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 3,
                    header = 'Dodajte utakmicu',
                    txt = 'Dodajte novu utakmicu na ponudu.',
                    params = {
                        event = 'qb-kladionica:novautakmica',
                    }
                },
            })

            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 4,
                    header = 'Uredite utakmicu',
                    txt = 'Uredite rezultat.',
                    params = {
                        event = 'qb-kladionica:urediteutakmicu',
                    }
                },
            })

            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 5,
                    header = 'Obrisite utakmicu',
                    txt = 'Sklonite utakmicu s ponude.',
                    params = {
                        event = 'qb-kladionica:obrisiteutakmicu',
                    }
                },
            })

            TriggerEvent('nh-context:sendMenu', {
                {
                    id = 6,
                    header = '< Natrag',
                    txt = '',
                    params = {
                        event = 'qb-kladionica:otvori',
                    }
                },
            })
            ------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------
        else
            ESX.ShowNotification("qb-kladionica | Niste gazda kladionice!")
        end
    end, utakmicex)
end)

RegisterNetEvent('qb-kladionica:novautakmica')
AddEventHandler('qb-kladionica:novautakmica', function()
    local novautakmica = exports['zf_dialog']:DialogInput({
        header = "Kladionica", 
        rows = {
            {
                id = 0, 
                txt = "Tim 1"
            },
            {
                id = 1, 
                txt = "Tim 2"
            },
            {
                id = 2, 
                txt = "1 [Kvota]"
            },
            {
                id = 3, 
                txt = "X [Kvota]"
            },
            {
                id = 4, 
                txt = "2 [Kvota]"
            },
        }
    })
    if novautakmica ~= nil then
        -- print(novautakmica[1].input)
        if novautakmica[1].input == nil or novautakmica[2].input == nil or novautakmica[3].input == nil or novautakmica[4].input == nil or novautakmica[5].input == nil then
            QBCore.Functions.Notify('qb-kladionica | Neispravan unos.', "error")
        else
            ExecuteCommand("postaviutakmicu "..novautakmica[1].input.." "..novautakmica[2].input.." "..novautakmica[3].input.." "..novautakmica[4].input.." "..novautakmica[5].input.."")
        end
    end
end)

RegisterNetEvent('qb-kladionica:isplatiulog')
AddEventHandler('qb-kladionica:isplatiulog', function()
    local isplatiulog = exports['zf_dialog']:DialogInput({
        header = "Kladionica", 
        rows = {
            {
                id = 0, 
                txt = "ID Utakmice"
            },
        }
    })
    if isplatiulog ~= nil then
        -- print(isplatiulog[1].input)
        if isplatiulog[1].input == nil then
            QBCore.Functions.Notify('qb-kladionica | Neispravan unos.', "error")
        else
            ExecuteCommand("isplatiulog "..isplatiulog[1].input.."")
        end
    end
end)

RegisterNetEvent('qb-kladionica:urediteutakmicu')
AddEventHandler('qb-kladionica:urediteutakmicu', function()
    local urediteutakmicu = exports['zf_dialog']:DialogInput({
        header = "Kladionica", 
        rows = {
            {
                id = 0, 
                txt = "ID Utakmice"
            },
            {
                id = 1, 
                txt = "1 / X / 2"
            },
        }
    })
    if urediteutakmicu ~= nil then
        -- print(urediteutakmicu[1].input)
        if urediteutakmicu[1].input == nil or urediteutakmicu[2].input == nil then
            QBCore.Functions.Notify('qb-kladionica | Neispravan unos.', "error")
        else
            ExecuteCommand("urediutakmicu "..urediteutakmicu[1].input.." "..urediteutakmicu[2].input.."")
        end
    end
end)

RegisterNetEvent('qb-kladionica:obrisiteutakmicu')
AddEventHandler('qb-kladionica:obrisiteutakmicu', function()
    local obrisiteutakmicu = exports['zf_dialog']:DialogInput({
        header = "Kladionica", 
        rows = {
            {
                id = 0, 
                txt = "ID Utakmice"
            },
        }
    })
    if obrisiteutakmicu ~= nil then
        -- print(obrisiteutakmicu[1].input)
        if obrisiteutakmicu[1].input == nil then
            QBCore.Functions.Notify('qb-kladionica | Neispravan unos.', "error")
        else
            ExecuteCommand("obrisiutakmicu "..obrisiteutakmicu[1].input.."")
        end
    end
end)

RegisterNetEvent('qb-kladionica:pokreniteutakmicu')
AddEventHandler('qb-kladionica:pokreniteutakmicu', function()
    local pokreniteutakmicu = exports['zf_dialog']:DialogInput({
        header = "Kladionica", 
        rows = {
            {
                id = 0, 
                txt = "ID Utakmice"
            },
        }
    })
    if pokreniteutakmicu ~= nil then
        -- print(pokreniteutakmicu[1].input)
        if pokreniteutakmicu[1].input == nil then
            QBCore.Functions.Notify('qb-kladionica | Neispravan unos.', "error")
        else
            ExecuteCommand("zapocniutakmicu "..pokreniteutakmicu[1].input.."")
        end
    end
end)

RegisterNetEvent('qb-kladionica:ulozi')
AddEventHandler('qb-kladionica:ulozi', function(IDUtakmice)
    -- print(IDUtakmice)
    local ovastvar = exports['zf_dialog']:DialogInput({
        header = "Kladionica", 
        rows = {
            {
                id = 0, 
                txt = "1 / X / 2"
            },
            {
                id = 1, 
                txt = "Kolicina? ($100 - $50.000)"
            },
        }
    })
    if ovastvar ~= nil then
        if ovastvar[1].input == nil or ovastvar[2].input == nil then
            QBCore.Functions.Notify('qb-kladionica | Neispravan unos.', "error")
        else
            ExecuteCommand("kladise "..IDUtakmice.." "..ovastvar[2].input.." "..ovastvar[1].input.."")
        end
    end
end)
