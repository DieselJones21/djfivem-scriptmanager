--[[
    Discord ID allowlist. Server-only — never add this file to `files`.
    Players must be in FiveM with Discord linked so identifier discord:ID exists.
]]

Access = {
    ready = false,
    count = 0,
    reason = 'not_checked',
}

local allowed = {}

local function digits(value)
    return tostring(value or ''):gsub('%D', '')
end

function Access.Normalize(value)
    local id = digits(value)
    if #id < 15 or #id > 22 then
        return nil
    end
    return id
end

function Access.Load()
    allowed = {}
    local count = 0
    local list = Config.DiscordIds
    if type(list) == 'table' then
        for i = 1, #list do
            local id = Access.Normalize(list[i])
            if id then
                allowed[id] = true
                count = count + 1
            end
        end
    end
    Access.count = count
    Access.ready = count > 0
    Access.reason = count > 0 and 'ok' or 'empty'
    return Access.ready
end

function Access.IsConfigured()
    return Access.ready == true
end

function Access.GetDiscordId(src)
    if not src or src == 0 then
        return nil
    end
    if GetPlayerIdentifierByType then
        local value = GetPlayerIdentifierByType(src, 'discord')
        local id = Access.Normalize(value)
        if id then
            return id
        end
    end
    local n = GetNumPlayerIdentifiers and GetNumPlayerIdentifiers(src) or 0
    for i = 0, n - 1 do
        local value = GetPlayerIdentifier(src, i)
        if value and value:find('discord', 1, true) then
            local id = Access.Normalize(value)
            if id then
                return id
            end
        end
    end
    return nil
end

function Access.IsAllowed(src)
    if src == 0 then
        return true
    end
    if not Access.IsConfigured() then
        return false
    end
    local id = Access.GetDiscordId(src)
    if not id then
        return false
    end
    return allowed[id] == true
end

function Access.DenyReason(src)
    if not Access.IsConfigured() then
        return 'empty_allowlist'
    end
    if not Access.GetDiscordId(src) then
        return 'no_discord'
    end
    return 'not_allowed'
end

function Access.PublicStatus()
    return {
        ready = Access.ready,
        via = 'discord',
    }
end
