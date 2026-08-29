Config = {}

--[[
    ACCESS (required)

    Only these Discord user IDs can open the tablet. Read on the SERVER only.
    Enable Discord in the FiveM server and have staff link Discord to FiveM.

    Right-click the user in Discord → Copy User ID (Developer Mode on).
    Snowflakes or discord:123 work. An empty list locks the tablet for everyone.
]]
if IsDuplicityVersion() then
    Config.DiscordIds = {
        -- '123456789012345678',
        -- 'discord:123456789012345678',
    }
end

-- Open the tablet
Config.Command = 'djadmin'
Config.Keybind = 'F10'
Config.KeybindDescription = 'Open DJ FiveM Script Manager'
Config.CloseKey = 'Escape'

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
    Tablet look. Values are pushed into CSS variables when the UI opens.

    `preset` picks a named multi-stop gradient from Config.Theme.Presets.
    Leave preset = '' and fill `gradient` yourself for a fully custom blend.
    `inkOnAccent` is the text/icon color sitting on gradient fills
    (use a dark color on chrome/gold, white on neon).
]]
Config.Theme = {
    appName = 'DJ FiveM',
    appTag = 'Scripts',
    logo = 'images/logo.png',
    preset = 'chrome', -- chrome | lava | vice | gold | ice | sunset | ''

    gradient = {
        angle = 125,
        colors = { '#f8f8f8', '#c9c9c9', '#8d8d8d', '#ffffff', '#4c4c4c' },
        inkOnAccent = '#111111',
        glow = '#d8d8d8',
    },

    Presets = {
        chrome = {
            angle = 125,
            colors = { '#ffffff', '#d4d4d4', '#8a8a8a', '#f4f4f4', '#3a3a3a' },
            inkOnAccent = '#111111',
            glow = '#e8e8e8',
        },
        lava = {
            angle = 90,
            colors = { '#ffb347', '#e10600', '#7a00c8' },
            inkOnAccent = '#ffffff',
            glow = '#e10600',
        },
        vice = {
            angle = 110,
            colors = { '#ff2bd6', '#7a5cff', '#00e5ff' },
            inkOnAccent = '#ffffff',
            glow = '#7a5cff',
        },
        gold = {
            angle = 120,
            colors = { '#fff3c4', '#f5c542', '#c4841d', '#7a4a00' },
            inkOnAccent = '#1a1204',
            glow = '#f5c542',
        },
        ice = {
            angle = 100,
            colors = { '#d9fbff', '#5ad0ff', '#2563eb', '#0b1b4a' },
            inkOnAccent = '#ffffff',
            glow = '#5ad0ff',
        },
        sunset = {
            angle = 95,
            colors = { '#ffe08a', '#ff6a2b', '#e10600', '#6b0030' },
            inkOnAccent = '#ffffff',
            glow = '#ff6a2b',
        },
    },

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
    empty_allowlist = 'Script Manager has no Discord IDs in config.lua.',
    no_discord = 'Your Discord is not linked to FiveM.',
    not_allowed = 'Your Discord ID is not on the Script Manager list.',
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
