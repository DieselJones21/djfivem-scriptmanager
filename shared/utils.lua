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

function Utils.LinearGradient(angle, colors)
    angle = tonumber(angle) or 90
    if type(colors) ~= 'table' or #colors == 0 then
        colors = { '#e10600' }
    end
    local parts = {}
    local last = math.max(#colors - 1, 1)
    for i = 1, #colors do
        local pct = math.floor(((i - 1) / last) * 100 + 0.5)
        parts[#parts + 1] = ('%s %s%%'):format(colors[i], pct)
    end
    return ('linear-gradient(%sdeg, %s)'):format(angle, table.concat(parts, ', '))
end

function Utils.ResolveGradient(theme)
    theme = theme or Config.Theme
    local grad = theme.gradient or {}
    local name = theme.preset
    if type(name) == 'string' and name ~= '' and theme.Presets and theme.Presets[name] then
        grad = theme.Presets[name]
    end
    local colors = grad.colors or { grad.ember, grad.accent, grad.crimson }
    local cleaned = {}
    for i = 1, #colors do
        if type(colors[i]) == 'string' and colors[i] ~= '' then
            cleaned[#cleaned + 1] = colors[i]
        end
    end
    if #cleaned == 0 then
        cleaned = { '#ff6a2b', '#e10600', '#7a00c8' }
    end
    local glow = grad.glow or cleaned[math.max(1, math.ceil(#cleaned / 2))]
    return {
        angle = grad.angle or 90,
        colors = cleaned,
        inkOnAccent = grad.inkOnAccent or '#ffffff',
        glow = glow,
        preset = (type(name) == 'string' and name ~= '') and name or 'custom',
    }
end

function Utils.BuildTheme(theme)
    theme = theme or Config.Theme
    local grad = Utils.ResolveGradient(theme)
    local r, g, b = Utils.HexToRgb(grad.glow)
    local startColor = grad.colors[1]
    local midColor = grad.colors[math.max(1, math.ceil(#grad.colors / 2))]
    local endColor = grad.colors[#grad.colors]
    return {
        appName = theme.appName or 'DJ FiveM',
        appTag = theme.appTag or 'Scripts',
        logo = theme.logo or 'images/logo.png',
        preset = grad.preset,
        gradientAngle = grad.angle,
        gradientColors = grad.colors,
        onAccent = grad.inkOnAccent,
        glow = grad.glow,
        accent = midColor,
        accentHot = startColor,
        ember = startColor,
        crimson = endColor,
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
        accentFill = Utils.LinearGradient(grad.angle, grad.colors),
        accentFillV = Utils.LinearGradient(180, grad.colors),
        presets = theme.Presets,
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
