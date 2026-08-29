Permissions = {}

function Permissions.GetIdentifier(src)
    local discord = Access.GetDiscordId(src)
    if discord then
        return 'discord:' .. discord
    end
    local license = GetPlayerIdentifierByType(src, 'license2') or GetPlayerIdentifierByType(src, 'license')
    return license or ('src:%s'):format(src)
end

function Permissions.GetName(src)
    return GetPlayerName(src) or ('ID %s'):format(src)
end

function Permissions.IsAdmin(src)
    return Access.IsAllowed(src)
end
