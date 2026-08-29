# DJ FiveM Script Manager

Licensed in-game **admin tablet** for every DJ FiveM resource. One UI, allowlisted commands, resource start/stop/restart, and a license key in `config.lua`.

The tablet chrome matches the Lumina DJ Booth OS (bezel, notch, sidebar glow, bottom transport). Colors are **not hardcoded** — they come from `Config.Theme`.

## Install

1. Place this folder in `resources/[djfivem]/djfivem-scriptmanager`
2. `ensure ox_lib` then `ensure djfivem-scriptmanager` in `server.cfg`
3. Copy ACE from `install/permissions.cfg`
4. Generate a license and paste it into `config.lua`

```bash
python3 tools/generate_license.py
```

Or from the live **server console** (not in-game chat):

```
djsm_makelicense
```

Then:

```lua
Config.License = 'DJSM-XXXX-XXXX-XXXX-XXXX'
```

Restart the resource. An empty or placeholder key **disables the tablet**.

The stock `License.ProductSecret` accepts this example key (rotate the secret before you ship):

```lua
Config.License = 'DJSM-A7F3-C91B-CF54-1C80'
```

## Open

- Command: `/djadmin` (change with `Config.Command`)
- Default key: `F10`
- ACE: `djmanager.admin`

Only licensed **and** ACE/framework admins can open it. The NUI cannot grant access by itself.

## Theme

Edit `Config.Theme` in `config.lua`. Every value is pushed into CSS variables when the tablet opens:

| Key | What it tints |
| --- | --- |
| `accent` / `accentHot` / `ember` / `crimson` | Buttons, active nav, glows, progress |
| `screen` / `paper` / `card` / `panel` | Surfaces |
| `ink` / `muted` / `line` | Text and borders |
| `bezelTop` / `bezelMid` / `bezelBottom` | Tablet chassis |
| `appName` / `appTag` | Sidebar brand |

Open `html/index.html` in a browser to preview. The top chips swap Red / Blue / Gold / Mint without restarting FiveM.

## What it controls

The catalog in `shared/catalog.lua` covers:

DJ Booth, Donator, Shops, Black Market, Drugs, Gambling, Fishing, Pets, Wings, Head Cosmetics, Back Bling, Spray Paint, Doorlock, Stash Creator, Gang Management, Gangs / Territories, Robbery, Arena, plus placeholders for empty repos (Dab Pen, Boost Events).

Each running resource can be started / stopped / restarted. Admin tools are **allowlisted commands only** (for example `/djadmin`, `/givecoins`, `/givepet`, `/doorlock`). NUI never sends a free-form shell string.

Add renamed resources with `Config.ExtraResources`.

## Anti-exploit

- License HMAC is verified **server-side** (`server/license.lua`). The key is assigned only inside `IsDuplicityVersion()` so the client does not receive it.
- Every open / refresh / run callback checks license + ACE / QB / QBX / ESX admin + identifier allowlist.
- Rate limit (`Config.RateLimit`) and optional `Config.DropOnExploit`.
- Resource control cannot target this manager itself.
- Command templates fill `{player}` / `{amount}` / `{species}` after type checks. Player ids must be online. Select fields must match the option list.
- Original resource ACE still applies because commands run as the admin via `ExecuteCommand`, not as console.
- Optional Discord audit: `Config.AuditWebhook`.

This is not FiveM escrow. If you sell the script, change `License.ProductSecret` in `server/license.lua`, generate new keys, and escrow that file. A public GitHub copy of the secret can mint keys — rotate it before distribution.

## Bind to one server

```lua
Config.BindLicenseToServer = true
```

```bash
python3 tools/generate_license.py --bind YOUR_SV_LICENSE_KEY
```

The key then only validates on a machine whose `sv_licenseKey` matches.

## Preview

```bash
python3 -m http.server 8765 --directory html
```

Open http://localhost:8765 — the tablet loads with mock data so you can click Home, Scripts, Players, and theme chips.
