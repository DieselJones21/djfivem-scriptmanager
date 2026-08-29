Utils = {}

function Utils.Trim(value)
    return tostring(value or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

function Utils.Clamp(n, min, max)
    n = tonumber(n)
    if not n then return min end
    if n < min then return min end
    if n > max then return max end
    return n
end

function Utils.IsSafeToken(value, maxLen)
    value = Utils.Trim(value)
    maxLen = maxLen or 48
    if value == '' or #value > maxLen then
        return false
    end
    return value:match('^[%w%._%-]+$') ~= nil
end

function Utils.SanitizeToken(value, maxLen)
    if not Utils.IsSafeToken(value, maxLen) then
        return nil
    end
    return Utils.Trim(value)
end

function Utils.HexToRgb(hex)
    hex = tostring(hex or ''):gsub('#', '')
    if #hex ~= 6 then
        return 225, 6, 0
    end
    return tonumber(hex:sub(1, 2), 16) or 225, tonumber(hex:sub(3, 4), 16) or 6, tonumber(hex:sub(5, 6), 16) or 0
end

function Utils.BuildTheme(theme)
    theme = theme or Config.Theme
    local r, g, b = Utils.HexToRgb(theme.accent)
    return {
        appName = theme.appName or 'DJ FiveM',
        appTag = theme.appTag or 'Script OS',
        accent = theme.accent,
        accentHot = theme.accentHot,
        ember = theme.ember,
        crimson = theme.crimson,
        ink = theme.ink,
        muted = theme.muted,
        screen = theme.screen,
        paper = theme.paper,
        wash = theme.wash,
        panel = theme.panel,
        card = theme.card,
        card2 = theme.card2,
        line = theme.line,
        bezelTop = theme.bezelTop,
        bezelMid = theme.bezelMid,
        bezelBottom = theme.bezelBottom,
        accentRgb = ('%s, %s, %s'):format(r, g, b),
    }
end

function Utils.FindCatalog(id)
    for i = 1, #Catalog do
        if Catalog[i].id == id then
            return Catalog[i]
        end
    end
end

function Utils.FindAction(script, actionId)
    if not script or not script.actions then
        return nil
    end
    for i = 1, #script.actions do
        if script.actions[i].id == actionId then
            return script.actions[i]
        end
    end
end
