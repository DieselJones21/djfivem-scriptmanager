local open = false

local function nui(action, payload)
    SendNUIMessage({
        action = action,
        payload = payload or {},
    })
end

local function closeTablet()
    if not open then
        nui('close')
        SetNuiFocus(false, false)
        return
    end
    open = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    nui('close')
end

local function notify(message, kind)
    if GetResourceState('ox_lib') == 'started' then
        lib.notify({
            title = Config.Notify.title,
            description = message,
            type = kind or 'inform',
            position = Config.Notify.position,
        })
        return
    end
    BeginTextCommandThefeedDisplay('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedDisplayTicker(false, true)
end

local function openTablet()
    if IsPauseMenuActive() then
        return
    end
    local data = lib.callback.await('djsm:open', false)
    if not data or not data.ok then
        notify((data and data.locale) or Config.Locale.no_permission, 'error')
        return
    end
    open = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    nui('open', data)
end

RegisterCommand(Config.Command, function()
    if open then
        closeTablet()
        return
    end
    openTablet()
end, false)

if Config.Keybind and Config.Keybind ~= '' then
    RegisterKeyMapping(Config.Command, Config.KeybindDescription, 'keyboard', Config.Keybind)
end

RegisterNetEvent('djsm:client:notify', function(message, kind)
    notify(message, kind)
end)

RegisterNetEvent('djsm:client:runCommand', function(command)
    if type(command) ~= 'string' or command == '' or #command > 180 then
        return
    end
    if command:find('[;\n\r]', 1, false) then
        return
    end
    ExecuteCommand(command)
end)

RegisterNUICallback('close', function(_, cb)
    closeTablet()
    cb({ ok = true })
end)

RegisterNUICallback('refresh', function(_, cb)
    local data = lib.callback.await('djsm:refresh', false)
    cb(data or { ok = false })
end)

RegisterNUICallback('run', function(body, cb)
    local data = lib.callback.await('djsm:run', false, body)
    cb(data or { ok = false })
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        closeTablet()
    end
end)
