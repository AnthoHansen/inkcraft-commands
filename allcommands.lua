local ESX = nil
local QBCore = nil

CreateThread(function()
    if Config.Framework == 'standalone' then
        print('IC-Commands started in standalone mode - all players can use the command')
        return
    end

    if GetResourceState('es_extended') == 'started' then
        Config.Framework = 'esx'
        ESX = exports['es_extended']:getSharedObject()
    elseif GetResourceState('qb-core') == 'started' then
        Config.Framework = 'qb'
        QBCore = exports['qb-core']:GetCoreObject()
    elseif GetResourceState('qbx-core') == 'started' then
        Config.Framework = 'qb'
        QBCore = exports['qb-core']:GetCoreObject()
    else
        print('Warning: No supported framework detected (ESX, QBox or QB-Core required)')
        return
    end
    print('IC-Commands started with framework: ' .. Config.Framework)
end)

local function isAdmin(source)
    if source == 0 then return true end                      -- Console always has access
    if Config.Framework == 'standalone' then return true end -- In standalone mode, everyone has access

    if Config.Framework == 'esx' then
        if not ESX then return false end
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        local group = xPlayer.getGroup()
        return group == 'admin' or group == 'superadmin'
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        if not QBCore then return false end
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return false end
        return QBCore.Functions.HasPermission(source, 'admin') or QBCore.Functions.HasPermission(source, 'god')
    end
    return false
end

local function isWebhookValid(webhookUrl)
    if not webhookUrl or webhookUrl == '' or webhookUrl == 'YOUR_WEBHOOK_URL' then
        print("Error: Invalid webhook URL. Please configure Config.WebhookUrl in config.lua")
        return false
    end
    return true
end

local function isCommandBlacklisted(commandName)
    for _, prefix in ipairs(Config.BlacklistCommands) do
        if string.find(commandName:lower(), prefix:lower(), 1, true) == 1 then
            return true
        end
    end
    return false
end

local function splitIntoChunks(arr, maxLength)
    local chunks = {}
    local currentChunk = {}
    local currentLength = 0

    for _, item in ipairs(arr) do
        if currentLength + #item + 1 > maxLength then
            table.insert(chunks, table.concat(currentChunk, "\n"))
            currentChunk = { item }
            currentLength = #item
        else
            table.insert(currentChunk, item)
            currentLength = currentLength + #item + 1
        end
    end

    if #currentChunk > 0 then
        table.insert(chunks, table.concat(currentChunk, "\n"))
    end

    return chunks
end

RegisterCommand(Config.Command, function(source, args, rawCommand)
    if not isAdmin(source) then
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0 },
                multiline = true,
                args = { "System", "You don't have permission to use this command." }
            })
        end
        return
    end

    local commandsTable = {}
    local allCommands = GetRegisteredCommands()
    local addedCommands = {}

    for _, command in ipairs(allCommands) do
        if not isCommandBlacklisted(command.name) and not addedCommands[command.name] then
            table.insert(commandsTable, command.name)
            addedCommands[command.name] = true
        end
    end

    table.sort(commandsTable)

    if #commandsTable > 0 then
        TriggerEvent('ic-commands:server:sendDiscord', commandsTable)
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 255, 0 },
                multiline = true,
                args = { "System", "Command list sent to Discord." }
            })
        end
    else
        print("No commands found to send.")
    end
end, true)

RegisterNetEvent('ic-commands:server:sendDiscord', function(commandsTable)
    if type(commandsTable) ~= "table" or #commandsTable == 0 then
        print("Error: Invalid or empty command list")
        return
    end

    local webhookUrl = Config.WebhookUrl

    local messageHeader = "**Available Command List**\n```\n"
    local messageFooter = "\n```"

    local chunks = splitIntoChunks(commandsTable, 1900)

    for i, chunk in ipairs(chunks) do
        local content = messageHeader .. chunk .. messageFooter

        local data = {
            content = content,
            username = 'IC-Commands'
        }

        PerformHttpRequest(webhookUrl, function(err, text, headers)
            print(string.format("Chunk %d sent correctly", i))
        end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })

        Wait(2000)
    end
end)