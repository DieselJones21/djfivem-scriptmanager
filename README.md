# DJ FiveM Script Manager

In-game **admin tablet** for every DJ FiveM resource. One UI, allowlisted commands, resource start/stop/restart. Access is a **Discord user ID list** in `config.lua` — not a license key.

The tablet chrome matches the Lumina DJ Booth OS (bezel, notch, sidebar glow, bottom transport). Colors are **not hardcoded** — they come from `Config.Theme`.

## Install

1. Place this folder in `resources/[djfivem]/djfivem-scriptmanager`
2. `ensure ox_lib` then `ensure djfivem-scriptmanager` in `server.cfg`
3. Enable Discord identifiers on the FiveM server (`set discord_token` / Discord as a connection method)
4. Put staff Discord IDs in `config.lua`

Turn on Discord Developer Mode, right-click a user, **Copy User ID**:

```lua
Config.DiscordIds = {
    '123456789012345678',
    'discord:987654321098765432',
}
```

An empty list **locks the tablet for everyone**. Restart the resource after edits. Staff must launch FiveM with Discord linked so the `discord:` identifier exists.

## Open

- Command: `/djadmin` (change with `Config.Command`)
- Default key: `F10`

Only Discord IDs on that list can open it. The NUI cannot grant access by itself. ACE / QB / ESX admin groups are **not** enough.

## Theme

The DJ FiveM Scripts logo is baked into the tablet (sidebar + home lockup). Swap the file at `html/images/logo.png` or change `Config.Theme.logo`.

Accents are **multi-stop gradients**, not a single solid. Pick a named blend or write your own:

```lua
Config.Theme.preset = 'chrome' -- chrome | lava | vice | gold | ice | sunset

-- Or a custom blend:
Config.Theme.preset = ''
Config.Theme.gradient = {
    angle = 135,
    colors = { '#00e5ff', '#7a5cff', '#ff2bd6' },
    inkOnAccent = '#ffffff', -- text/icons sitting on the gradient
    glow = '#7a5cff',
}
```

| Key | What it tints |
| --- | --- |
| `preset` / `gradient.colors` | Buttons, active nav, progress, glows |
| `gradient.inkOnAccent` | Text on those fills (dark on chrome/gold) |
| `screen` / `paper` / `card` / `panel` | Surfaces |
| `ink` / `muted` / `line` | Text and borders |
| `bezelTop` / `bezelMid` / `bezelBottom` | Tablet chassis |
| `appName` / `appTag` / `logo` | Sidebar brand |

Open `html/index.html` in a browser to preview. The top chips swap Chrome / Lava / Vice / Gold / Ice / Sunset without restarting FiveM.

## What it controls

The catalog in `shared/catalog.lua` covers:

DJ Booth, Donator, Shops, Black Market, Drugs, Gambling, Fishing, Pets, Wings, Head Cosmetics, Back Bling, Spray Paint, Doorlock, Stash Creator, Gang Management, Gangs / Territories, Robbery, Arena, plus placeholders for empty repos (Dab Pen, Boost Events).

Each running resource can be started / stopped / restarted. Admin tools are **allowlisted commands only** (for example `/djadmin`, `/givecoins`, `/givepet`, `/doorlock`). NUI never sends a free-form shell string.

Add renamed resources with `Config.ExtraResources`.

## Anti-exploit

- Discord IDs are checked **server-side** on every open / refresh / run. The allowlist is assigned only inside `IsDuplicityVersion()` so the client never receives it.
- Players with no `discord:` identifier are denied even if they trigger the NUI.
- Rate limit (`Config.RateLimit`) and optional `Config.DropOnExploit`.
- Resource control cannot target this manager itself.
- Command templates fill `{player}` / `{amount}` / `{species}` after type checks. Player ids must be online. Select fields must match the option list.
- Original resource ACE still applies because commands run as the admin via `ExecuteCommand`, not as console.
- Optional Discord audit: `Config.AuditWebhook`.

## Preview

```bash
python3 -m http.server 8765 --directory html
```

Open http://localhost:8765 — the tablet loads with mock data so you can click Home, Scripts, Players, and theme chips.
