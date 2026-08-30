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

-- Open the tablet. Not /djadmin — that stays the DJ Booth admin command.
Config.Command = '305admin'
Config.Keybind = 'F10'
Config.KeybindDescription = 'Open The 305 Command OS'
Config.CloseKey = 'Escape'

Config.Framework = 'auto' -- auto | esx | qb | qbx | standalone

-- Resource start / stop / restart from the tablet (allowlisted catalog only)
Config.AllowResourceControl = true

-- Extra resource names that may appear besides the built-in DJ FiveM catalog
Config.ExtraResources = {
    -- 'my-renamed-shops',
}

-- If you renamed a catalog resource, map catalog id or default folder → your folder
Config.ResourceOverrides = {
    -- ['jg-garages'] = 'jg-advancedgarages',
    -- ['jg-mechanic'] = 'jg-mechanic',
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
    title = 'The 305',
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
    appName = 'The 305',
    appTag = 'Command OS',
    logo = 'images/logo.png',
    banner = 'images/banner.jpg',
    preset = 'vice305', -- vice305 | vice | chrome | lava | gold | ice | sunset | ''
    cyan = '#00e5ff',

    gradient = {
        angle = 115,
        colors = { '#ff4ad2', '#e11d8b', '#7a5cff', '#00e5ff' },
        inkOnAccent = '#ffffff',
        glow = '#ff2bd6',
    },

    Presets = {
        vice305 = {
            angle = 115,
            colors = { '#ff4ad2', '#e11d8b', '#7a5cff', '#00e5ff' },
            inkOnAccent = '#ffffff',
            glow = '#ff2bd6',
        },
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

    ink = '#f6f3ff',
    muted = '#9aa3c7',
    screen = '#070614',
    paper = '#0c1024',
    wash = '#08081a',
    panel = '#10162c',
    card = '#141b34',
    card2 = '#1b2444',
    line = 'rgba(255, 74, 210, 0.16)',
    bezelTop = '#2a1a33',
    bezelMid = '#12091c',
    bezelBottom = '#07040d',
}

Config.Locale = {
    empty_allowlist = 'The 305 Command OS has no Discord IDs in config.lua.',
    no_discord = 'Your Discord is not linked to FiveM.',
    not_allowed = 'Your Discord ID is not on The 305 Command OS list.',
    no_permission = 'You do not have access to The 305 Command OS.',
    opened = 'The 305 Command OS opened',
    closed = 'The 305 Command OS closed',
    action_ok = 'Action sent',
    action_denied = 'Action blocked',
    missing_resource = 'That resource is not installed',
    resource_busy = 'Resource control is disabled',
    invalid_action = 'Unknown or blocked action',
    rate_limited = 'Slow down — too many admin actions',
    player_offline = 'That player is not online',
    bad_args = 'Invalid arguments',
}
