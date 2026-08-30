# The 305 Command OS

In-game **admin tablet** branded for **The 305**. One Discord-locked UI for DJ FiveM scripts plus official **JG Mechanic**, **JG Advanced Garages**, and **JG Dealerships** commands.

Access is a **Discord user ID list** in `config.lua`. The NUI cannot grant access.

## Install

1. Place this folder in `resources/[djfivem]/djfivem-scriptmanager`
2. `ensure ox_lib` then `ensure djfivem-scriptmanager` in `server.cfg`
3. Enable Discord identifiers on the FiveM server
4. Put staff Discord IDs in `config.lua`

Turn on Discord Developer Mode, right-click a user, **Copy User ID**:

```lua
Config.DiscordIds = {
    '123456789012345678',
    'discord:987654321098765432',
}
```

An empty list **locks the tablet for everyone**. Restart the resource after edits. Staff must launch FiveM with Discord linked so the `discord:` identifier exists.

If you renamed a JG folder, map it:

```lua
Config.ResourceOverrides = {
    ['jg-garages'] = 'your-garage-folder',
}
```

## Open

- Command: `/305admin` (change with `Config.Command`)
- Default key: `F10`

`/djadmin` is left for the DJ Booth admin screen so the two tablets do not collide.

Only Discord IDs on the list can open it. ACE / QB / ESX admin groups are **not** enough.

## Theme

The 305 wordmark lives at `html/images/logo.png`. The Miami night banner at `html/images/banner.jpg` is the screen wallpaper. Swap those files or change `Config.Theme.logo` / `Config.Theme.banner`.

Default preset is **vice305** (magenta → purple → cyan). Accents are multi-stop gradients:

```lua
Config.Theme.preset = 'vice305' -- vice305 | vice | chrome | lava | gold | ice | sunset

-- Or a custom blend:
Config.Theme.preset = ''
Config.Theme.gradient = {
    angle = 115,
    colors = { '#ff4ad2', '#e11d8b', '#7a5cff', '#00e5ff' },
    inkOnAccent = '#ffffff',
    glow = '#ff2bd6',
}
```

| Key | What it tints |
| --- | --- |
| `preset` / `gradient.colors` | Buttons, active tabs, glows |
| `gradient.inkOnAccent` | Text on those fills |
| `screen` / `paper` / `card` / `panel` | Surfaces |
| `ink` / `muted` / `line` | Text and borders |
| `bezelTop` / `bezelMid` / `bezelBottom` | Tablet chassis |
| `appName` / `appTag` / `logo` / `banner` | Brand |

Open `html/index.html` in a browser to preview. The chips swap 305 / Vice / Chrome / Gold / Ice / Lava without restarting FiveM.

## Layout

The tablet is a command center, not a flat app grid:

- **Home** — 305 lockup, live stats, featured JG vehicle cards, then the rest of the stack
- **Vehicles** — Mechanic / Garages / Dealerships in three columns with every allowlisted JG command
- **Scripts** — searchable catalog with start / stop / restart
- **Audit** — server-side action log
- **Right dock** — selected resource controls + live players (click a player to pre-fill the next ID field)

## JG commands

Allowlisted only. The NUI never sends a free-form shell string. JG’s own ACE still applies because commands run as the admin.

**Mechanic** (`jg-mechanic`): `/tablet`, `/mechanicadmin`, `/vfix`

**Garages** (`jg-advancedgarages`, also detects `jg-garages`): `/iv`, `/vplate`, `/admincar`, `/privategarages`, `/dvdb`, `/vreturn [plate]`, `/setjobvehicle [job] [grade]`, `/removejobvehicle [id]`, `/setgangvehicle [gang] [grade]`, `/removegangvehicle [id]`

**Dealerships** (`jg-dealerships`): `/dealeradmin`, `/directsale`, `/myfinance`

Plate fields accept up to 12 A–Z / 0–9 characters. Job and gang names are token-sanitized.

## DJ FiveM catalog

DJ Booth, Donator, Shops, Black Market, Drugs, Gambling, Fishing, Pets, Wings, Head Cosmetics, Back Bling, Spray Paint, Doorlock, Stash Creator, Gang Management, Gangs / Territories, Robbery, Arena, plus placeholders for empty repos.

Add renamed resources with `Config.ExtraResources`.

## Anti-exploit

- Discord IDs are checked **server-side** on every open / refresh / run. The allowlist is assigned only inside `IsDuplicityVersion()` so the client never receives it.
- Players with no `discord:` identifier are denied even if they trigger the NUI.
- Rate limit (`Config.RateLimit`) and optional `Config.DropOnExploit`.
- Resource control cannot target this manager itself.
- Command templates fill `{player}` / `{amount}` / `{species}` / `{plate}` / `{job}` / `{gang}` after type checks. Player ids must be online. Select fields must match the option list.
- Original resource ACE still applies because commands run as the admin via `ExecuteCommand`, not as console.
- Optional Discord audit: `Config.AuditWebhook`.

## Preview

```bash
python3 -m http.server 8765 --directory html
```

Open http://localhost:8765 — the tablet loads with mock data so you can click Home, Vehicles, Scripts, player dock, plate/job modals, and theme chips.
