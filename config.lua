Config = {}

--[[
    LICENSE (required)

    This key is read on the SERVER only. Do not add config.lua to the `files`
    list. Generate a key with:

      python3 tools/generate_license.py
      (or from the live console) djsm_makelicense

    Paste the printed key below. An empty / placeholder key stops the tablet.
]]
if IsDuplicityVersion() then
    Config.License = 'PUT-YOUR-LICENSE-HERE'
end

-- When true, the key is tied to this machine's sv_licenseKey convar.
Config.BindLicenseToServer = false

-- Open the tablet
Config.Command = 'djadmin'
Config.Keybind = 'F10'
Config.KeybindDescription = 'Open DJ FiveM Script Manager'
Config.CloseKey = 'Escape'

-- ACE: add_ace group.admin djmanager.admin allow
Config.AdminAce = 'djmanager.admin'
Config.AdminIdentifiers = {
    -- 'license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
}
Config.QBAdminPermissions = { 'god', 'admin' }
Config.ESXAdminGroups = { 'admin', 'superadmin', 'god' }
Config.Framework = 'auto' -- auto | esx | qb | qbx | standalone

-- Resource start / stop / restart from the tablet (allowlisted catalog only)
Config.AllowResourceControl = true

-- Extra resource names that may appear besides the built-in DJ FiveM catalog
Config.ExtraResources = {
    -- 'my-renamed-shops',
}

Config.RateLimit = {
    windowMs = 4000,
    maxActions = 8,
    maxFailedAuth = 6,
}

-- Kick players who spam unauthorized admin events
Config.DropOnExploit = false

-- Optional Discord audit log (leave blank to disable)
Config.AuditWebhook = ''

Config.Notify = {
    title = 'DJ Script Manager',
    position = 'top-right',
}

--[[
    Tablet look. Every color is pushed into CSS variables when the UI opens,
    so you can retheme without editing html/style.css.

    The default palette matches the Lumina tablet (dark bezel, red glow).
]]
Config.Theme = {
    appName = 'DJ FiveM',
    appTag = 'Script OS',
    accent = '#e10600',
    accentHot = '#ff3b1f',
    ember = '#ff6a2b',
    crimson = '#b30000',
    ink = '#f5f5f5',
    muted = '#8a8a8a',
    screen = '#0b0b0b',
    paper = '#161616',
    wash = '#101010',
    panel = '#141414',
    card = '#1a1a1a',
    card2 = '#202020',
    line = 'rgba(255, 255, 255, 0.08)',
    bezelTop = '#2a2a2a',
    bezelMid = '#141414',
    bezelBottom = '#0a0a0a',
}

Config.Locale = {
    no_license = 'Script Manager is not licensed. Set Config.License.',
    no_permission = 'You do not have access to Script Manager.',
    opened = 'Script Manager opened',
    closed = 'Script Manager closed',
    action_ok = 'Action sent',
    action_denied = 'Action blocked',
    missing_resource = 'That resource is not installed',
    resource_busy = 'Resource control is disabled',
    invalid_action = 'Unknown or blocked action',
    rate_limited = 'Slow down — too many admin actions',
    player_offline = 'That player is not online',
    bad_args = 'Invalid arguments',
}
