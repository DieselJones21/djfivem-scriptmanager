local RESOURCE = GetCurrentResourceName()
local failedAuth = {}
local actionWindow = {}
local auditLog = {}

local function nowMs()
    return GetGameTimer()
end

local function punch(src)
    local t = nowMs()
    local bucket = actionWindow[src]
    if not bucket or t - bucket.started > (Config.RateLimit.windowMs or 4000) then
        actionWindow[src] = { started = t, count = 1 }
        return true
    end
    bucket.count = bucket.count + 1
    return bucket.count <= (Config.RateLimit.maxActions or 8)
end

local function noteAuthFail(src)
    failedAuth[src] = (failedAuth[src] or 0) + 1
    if Config.DropOnExploit and failedAuth[src] >= (Config.RateLimit.maxFailedAuth or 6) then
        DropPlayer(src, 'Unauthorized Script Manager access')
    end
end

local function notify(src, key, kind)
    TriggerClientEvent('djsm:client:notify', src, Config.Locale[key] or key, kind or 'error')
end

local function webhook(title, description, color)
    local url = Config.AuditWebhook
    if type(url) ~= 'string' or url == '' then
        return
    end
    PerformHttpRequest(url, function() end, 'POST', json.encode({
        username = 'DJ Script Manager',
        embeds = {{
            title = title,
            description = description,
            color = color or 14745600,
            footer = { text = os.date('!%Y-%m-%d %H:%M:%S UTC') },
        }},
    }), { ['Content-Type'] = 'application/json' })
end

local function audit(src, action, detail, ok)
    local entry = {
        time = os.time(),
        src = src,
        name = src == 0 and 'console' or Permissions.GetName(src),
        identifier = src == 0 and 'console' or Permissions.GetIdentifier(src),
        action = action,
        detail = detail,
        ok = ok and true or false,
    }
    auditLog[#auditLog + 1] = entry
    if #auditLog > 80 then
        table.remove(auditLog, 1)
    end
    local line = ('[djsm] %s (%s) %s %s %s'):format(
        entry.name,
        entry.identifier,
        ok and 'OK' or 'DENY',
        action,
        detail or ''
    )
    print(line)
    if Config.AuditWebhook and Config.AuditWebhook ~= '' then
        webhook(action, line, ok and 3066993 or 15158332)
    end
end

local function allowedResource(name)
    if CatalogByResource[name] then
        return true
    end
    for i = 1, #(Config.ExtraResources or {}) do
        if Config.ExtraResources[i] == name then
            return true
        end
    end
    return false
end

local function resourceState(name)
    local state = GetResourceState(name)
    if state == 'missing' then
        return 'missing'
    end
    if state == 'started' then
        return 'started'
    end
    if state == 'starting' or state == 'stopping' then
        return state
    end
    return 'stopped'
end

local function onlinePlayers()
    local list = {}
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        list[#list + 1] = {
            id = src,
            name = Permissions.GetName(src),
        }
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end

local function buildScripts()
    local scripts = {}
    for i = 1, #Catalog do
        local item = Catalog[i]
        local state = resourceState(item.resource)
        scripts[#scripts + 1] = {
            id = item.id,
            resource = item.resource,
            label = item.label,
            tag = item.tag,
            category = item.category,
            icon = item.icon,
            description = item.description,
            locked = item.locked == true,
            state = state,
            installed = state ~= 'missing',
            running = state == 'started',
            actions = item.actions or {},
        }
    end

    for i = 1, #(Config.ExtraResources or {}) do
        local name = Config.ExtraResources[i]
        if name and not CatalogByResource[name] then
            local state = resourceState(name)
            scripts[#scripts + 1] = {
                id = name,
                resource = name,
                label = name,
                tag = 'Custom',
                category = 'system',
                icon = 'box',
                description = 'Extra resource from Config.ExtraResources.',
                locked = name == RESOURCE,
                state = state,
                installed = state ~= 'missing',
                running = state == 'started',
                actions = {},
            }
        end
    end
    return scripts
end

local function statsFrom(scripts)
    local installed, running, stopped, missing = 0, 0, 0, 0
    for i = 1, #scripts do
        local s = scripts[i]
        if s.state == 'missing' then
            missing = missing + 1
        else
            installed = installed + 1
            if s.running then
                running = running + 1
            else
                stopped = stopped + 1
            end
        end
    end
    return {
        installed = installed,
        running = running,
        stopped = stopped,
        missing = missing,
        players = #GetPlayers(),
    }
end

local function snapshot(src)
    local scripts = buildScripts()
    return {
        ok = true,
        player = {
            id = src,
            name = Permissions.GetName(src),
        },
        theme = Utils.BuildTheme(Config.Theme),
        access = Access.PublicStatus(),
        stats = statsFrom(scripts),
        scripts = scripts,
        players = onlinePlayers(),
        logs = auditLog,
        allowResourceControl = Config.AllowResourceControl == true,
        command = Config.Command,
        closeKey = Config.CloseKey,
    }
end

local function guard(src)
    if not Access.IsAllowed(src) then
        local reason = Access.DenyReason(src)
        noteAuthFail(src)
        audit(src, 'auth', reason, false)
        return false, reason
    end
    if not punch(src) then
        audit(src, 'auth', 'rate', false)
        return false, 'rate_limited'
    end
    return true
end

local function fillCommand(template, fields, args)
    local cmd = template
    args = args or {}
    fields = fields or {}

    if not cmd:find('{', 1, true) then
        if next(args) then
            return nil, 'bad_args'
        end
        return cmd
    end

    for i = 1, #fields do
        local field = fields[i]
        local raw = args[field.name]
        local token

        if field.type == 'player' then
            local id = tonumber(raw)
            if not id or not GetPlayerName(id) then
                return nil, 'player_offline'
            end
            token = tostring(id)
        elseif field.type == 'number' then
            local n = tonumber(raw)
            if not n then
                return nil, 'bad_args'
            end
            n = Utils.Clamp(n, field.min or 0, field.max or 1000000)
            token = tostring(math.floor(n))
        elseif field.type == 'select' then
            local value = Utils.SanitizeToken(raw, 32)
            if not value then
                return nil, 'bad_args'
            end
            local ok = false
            for o = 1, #(field.options or {}) do
                if field.options[o] == value then
                    ok = true
                    break
                end
            end
            if not ok then
                return nil, 'bad_args'
            end
            token = value
        else
            token = Utils.SanitizeToken(raw, field.max or 48)
            if not token then
                return nil, 'bad_args'
            end
        end

        cmd = cmd:gsub('{' .. field.name .. '}', token, 1)
    end

    if cmd:find('{', 1, true) then
        return nil, 'bad_args'
    end
    return cmd
end

local function runResource(src, script, control)
    if script.locked or script.resource == RESOURCE then
        return false, 'invalid_action'
    end
    if not Config.AllowResourceControl then
        return false, 'resource_busy'
    end
    if not allowedResource(script.resource) then
        return false, 'invalid_action'
    end

    local state = resourceState(script.resource)
    if control ~= 'stop' and state == 'missing' then
        return false, 'missing_resource'
    end

    if control == 'start' then
        StartResource(script.resource)
    elseif control == 'stop' then
        StopResource(script.resource)
    elseif control == 'restart' then
        if state == 'started' then
            StopResource(script.resource)
            Wait(350)
        end
        StartResource(script.resource)
    else
        return false, 'invalid_action'
    end

    audit(src, 'resource.' .. control, script.resource, true)
    return true
end

CreateThread(function()
    Access.Load()
    lib.callback.register('djsm:open', function(source)
        local ok, reason = guard(source)
        if not ok then
            return { ok = false, reason = reason, locale = Config.Locale[reason] }
        end
        audit(source, 'open', nil, true)
        return snapshot(source)
    end)

    lib.callback.register('djsm:refresh', function(source)
        local ok, reason = guard(source)
        if not ok then
            return { ok = false, reason = reason, locale = Config.Locale[reason] }
        end
        return snapshot(source)
    end)

    lib.callback.register('djsm:run', function(source, payload)
        local ok, reason = guard(source)
        if not ok then
            return { ok = false, reason = reason, locale = Config.Locale[reason] }
        end

        if type(payload) ~= 'table' then
            return { ok = false, reason = 'invalid_action', locale = Config.Locale.invalid_action }
        end

        local script = Utils.FindCatalog(payload.scriptId)
        if not script then
            for i = 1, #(Config.ExtraResources or {}) do
                if Config.ExtraResources[i] == payload.scriptId then
                    script = {
                        id = payload.scriptId,
                        resource = payload.scriptId,
                        locked = payload.scriptId == RESOURCE,
                        actions = {},
                    }
                    break
                end
            end
        end
        if not script or not allowedResource(script.resource) then
            audit(source, 'run', 'unknown_script', false)
            return { ok = false, reason = 'invalid_action', locale = Config.Locale.invalid_action }
        end

        local kind = payload.kind
        if kind == 'start' or kind == 'stop' or kind == 'restart' then
            local success, fail = runResource(source, script, kind)
            if not success then
                return { ok = false, reason = fail, locale = Config.Locale[fail] }
            end
            Wait(200)
            return snapshot(source)
        end

        if kind ~= 'command' then
            return { ok = false, reason = 'invalid_action', locale = Config.Locale.invalid_action }
        end

        local action = Utils.FindAction(script, payload.actionId)
        if not action or type(action.command) ~= 'string' then
            audit(source, 'run', 'unknown_action', false)
            return { ok = false, reason = 'invalid_action', locale = Config.Locale.invalid_action }
        end

        local command, fail = fillCommand(action.command, action.fields, payload.args)
        if not command then
            return { ok = false, reason = fail, locale = Config.Locale[fail] }
        end

        -- Player-scoped commands run as the admin so the original resource ACE still applies.
        TriggerClientEvent('djsm:client:runCommand', source, command)
        audit(source, 'command.' .. action.id, command, true)
        local snap = snapshot(source)
        snap.ok = true
        snap.ran = command
        return snap
    end)
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= RESOURCE then
        return
    end

    if not Access.Load() then
        print('^1[djfivem-scriptmanager] No Discord IDs in Config.DiscordIds. Tablet is locked.^7')
        print('^1[djfivem-scriptmanager] Add staff Discord user IDs in config.lua and restart.^7')
        return
    end

    print(('^2[djfivem-scriptmanager] Discord access ready (%s IDs). Command /%s^7'):format(Access.count, Config.Command))
end)

AddEventHandler('playerDropped', function()
    local src = source
    failedAuth[src] = nil
    actionWindow[src] = nil
end)
