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
            currentChunk = {item}
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
                color = {255, 255, 0},
                multiline = true,
                args = {"System", "Command list sent to Discord."}
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
            if err then
                print(string.format("Error sending chunk %d: %s", i, err))
            else
                print(string.format("Chunk %d sent correctly", i))
            end
        end, 'POST', json.encode(data), {['Content-Type'] = 'application/json'})
        
        Wait(1000)
    end
end)
