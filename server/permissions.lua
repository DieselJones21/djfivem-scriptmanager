Permissions = {}

local qbCore
local esx
local frameworkName

local function detectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end
    if GetResourceState('qbx_core') == 'started' then
        return 'qbx'
    end
    if GetResourceState('qb-core') == 'started' then
        return 'qb'
    end
    if GetResourceState('es_extended') == 'started' then
        return 'esx'
    end
    return 'standalone'
end

CreateThread(function()
    Wait(250)
    frameworkName = detectFramework()
    if frameworkName == 'qb' or frameworkName == 'qbx' then
        qbCore = exports['qb-core'] and exports['qb-core']:GetCoreObject() or nil
    elseif frameworkName == 'esx' then
        esx = exports['es_extended'] and exports['es_extended']:getSharedObject() or nil
    end
end)

function Permissions.GetIdentifier(src)
    local license = GetPlayerIdentifierByType(src, 'license2') or GetPlayerIdentifierByType(src, 'license')
    return license or ('src:%s'):format(src)
end

function Permissions.GetName(src)
    return GetPlayerName(src) or ('ID %s'):format(src)
end

function Permissions.IsAdmin(src)
    if src == 0 then
        return true
    end
    if not License.IsValid() then
        return false
    end
    if IsPlayerAceAllowed(src, Config.AdminAce) then
        return true
    end
    if Config.Command and IsPlayerAceAllowed(src, 'command.' .. Config.Command) then
        return true
    end

    local identifier = Permissions.GetIdentifier(src)
    for i = 1, #(Config.AdminIdentifiers or {}) do
        local allowed = Config.AdminIdentifiers[i]
        if allowed == identifier then
            return true
        end
        for _, idType in ipairs({ 'license', 'license2', 'discord', 'fivem', 'steam' }) do
            local value = GetPlayerIdentifierByType(src, idType)
            if value and value == allowed then
                return true
            end
        end
    end

    if frameworkName == 'qbx' then
        if GetResourceState('qbx_core') == 'started' then
            for i = 1, #Config.QBAdminPermissions do
                local ok, allowed = pcall(function()
                    return exports.qbx_core:HasPermission(src, Config.QBAdminPermissions[i])
                end)
                if ok and allowed then
                    return true
                end
            end
        end
        if qbCore and qbCore.Functions.HasPermission then
            for i = 1, #Config.QBAdminPermissions do
                if qbCore.Functions.HasPermission(src, Config.QBAdminPermissions[i]) then
                    return true
                end
            end
        end
    elseif frameworkName == 'qb' and qbCore and qbCore.Functions.HasPermission then
        for i = 1, #Config.QBAdminPermissions do
            if qbCore.Functions.HasPermission(src, Config.QBAdminPermissions[i]) then
                return true
            end
        end
    elseif frameworkName == 'esx' and esx then
        local player = esx.GetPlayerFromId(src)
        if player then
            local group = player.getGroup and player.getGroup() or player.group
            for i = 1, #Config.ESXAdminGroups do
                if group == Config.ESXAdminGroups[i] then
                    return true
                end
            end
        end
    end

    return false
end
