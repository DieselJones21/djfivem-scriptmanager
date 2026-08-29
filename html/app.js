(() => {
    const IN_FIVEM = typeof GetParentResourceName === 'function';
    const resourceName = IN_FIVEM ? GetParentResourceName() : 'djfivem-scriptmanager';

    const state = {
        view: 'home',
        selectedId: null,
        query: '',
        payload: null,
        toastTimer: 0,
    };

    const $ = (id) => document.getElementById(id);

    const icons = {
        home: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 10.5 12 4l8 6.5V20a1 1 0 0 1-1 1h-5v-6H10v6H5a1 1 0 0 1-1-1z"/></svg>',
        apps: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="4" width="7" height="7" rx="2"/><rect x="13" y="4" width="7" height="7" rx="2"/><rect x="4" y="13" width="7" height="7" rx="2"/><rect x="13" y="13" width="7" height="7" rx="2"/></svg>',
        users: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4v2"/><circle cx="9.5" cy="7" r="3"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>',
        logs: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M8 6h13M8 12h13M8 18h13"/><circle cx="4" cy="6" r="1.2"/><circle cx="4" cy="12" r="1.2"/><circle cx="4" cy="18" r="1.2"/></svg>',
        tablet: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="3" width="14" height="18" rx="3"/><path d="M10 18h4"/></svg>',
        music: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="8" cy="18" r="3"/><circle cx="18" cy="16" r="3"/><path d="M11 18V6l10-2v12"/></svg>',
        store: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 9h16l-1.2 11H5.2L4 9z"/><path d="M8 9V7a4 4 0 0 1 8 0v2"/></svg>',
        bag: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 8h12l1 13H5L6 8z"/><path d="M9 8V7a3 3 0 0 1 6 0v1"/></svg>',
        skull: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="11" r="1"/><circle cx="15" cy="11" r="1"/><path d="M8 16h8M7 20h10a6 6 0 0 0 6-8c0-5-4-9-9-9S5 7 5 12a6 6 0 0 0 6 8z"/></svg>',
        flask: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 3h6M10 3v6L5 20h14L14 9V3"/><path d="M8 14h8"/></svg>',
        dice: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="4" width="16" height="16" rx="3"/><circle cx="9" cy="9" r="1"/><circle cx="15" cy="15" r="1"/><circle cx="15" cy="9" r="1"/></svg>',
        fish: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12s4-6 10-6 8 6 8 6-2 6-8 6-10-6-10-6z"/><circle cx="16" cy="12" r="1"/><path d="M4 12l4 4v-8z"/></svg>',
        paw: '<svg viewBox="0 0 24 24" fill="currentColor"><circle cx="7" cy="8" r="2"/><circle cx="12" cy="6" r="2"/><circle cx="17" cy="8" r="2"/><circle cx="9" cy="12" r="1.6"/><path d="M8 16c0-2 8-2 8 0 0 3-2.2 5-4 5s-4-2-4-5z"/></svg>',
        wing: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 14c6-1 8-8 16-9-2 6-8 9-16 9z"/><path d="M6 16c5 0 8 3 12 5"/></svg>',
        crown: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 18h18l-1-10-5 4-3-7-3 7-5-4z"/></svg>',
        sword: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 4l6 6M8 20l4-4M4 20l4-1 9-9-3-3-9 9z"/></svg>',
        spray: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="8" y="8" width="8" height="12" rx="2"/><path d="M10 8V5h4v3M16 5c2-1 4 0 5 2"/></svg>',
        lock: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/></svg>',
        box: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 8l9-5 9 5-9 5z"/><path d="M3 8v8l9 5 9-5V8M12 13v8"/></svg>',
        map: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 4l6 2 5-2v16l-5 2-6-2-5 2V6z"/><path d="M9 4v16M15 6v16"/></svg>',
        mask: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 10c0-5 4-7 8-7s8 2 8 7c0 6-4 10-8 10S4 16 4 10z"/><path d="M8 12c.5 1 1.5 2 4 2s3.5-1 4-2"/></svg>',
        target: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="4"/><circle cx="12" cy="12" r="1"/></svg>',
        cloud: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M7 18h10a4 4 0 0 0 0-8 6 6 0 0 0-11-1A4 4 0 0 0 7 18z"/></svg>',
        bolt: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M13 2 4 14h8l-1 8 9-12h-8z"/></svg>',
        play: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>',
        stop: '<svg viewBox="0 0 24 24" fill="currentColor"><rect x="6" y="6" width="12" height="12" rx="2"/></svg>',
        restart: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12a8 8 0 1 0 2.2-5.5"/><path d="M4 4v6h6"/></svg>',
        close: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 6l12 12M18 6 6 18"/></svg>',
    };

    function icon(name) {
        return icons[name] || icons.box;
    }

    function hexToRgb(hex) {
        const h = String(hex || '').replace('#', '');
        if (h.length !== 6) return '232, 232, 232';
        return [0, 2, 4].map((i) => parseInt(h.slice(i, i + 2), 16)).join(', ');
    }

    function gradientFrom(theme) {
        const colors = (theme.gradientColors && theme.gradientColors.length)
            ? theme.gradientColors
            : [theme.ember, theme.accent, theme.crimson].filter(Boolean);
        const list = colors.length ? colors : ['#ffffff', '#8a8a8a', '#3a3a3a'];
        const angle = theme.gradientAngle || 90;
        const stops = list.map((c, i) => `${c} ${Math.round((i / Math.max(list.length - 1, 1)) * 100)}%`).join(', ');
        const glow = theme.glow || list[Math.floor(list.length / 2)] || list[0];
        return {
            fill: `linear-gradient(${angle}deg, ${stops})`,
            fillV: `linear-gradient(180deg, ${stops})`,
            rgb: theme.accentRgb || hexToRgb(glow),
            ink: theme.onAccent || '#ffffff',
            start: list[0],
            mid: list[Math.floor(list.length / 2)],
            end: list[list.length - 1],
        };
    }

    function applyTheme(theme) {
        if (!theme) return;
        const root = document.documentElement.style;
        const map = {
            ink: '--ink',
            muted: '--muted',
            line: '--line',
            paper: '--paper',
            wash: '--wash',
            screen: '--screen',
            panel: '--panel',
            card: '--card',
            card2: '--card-2',
            bezelTop: '--bezel-top',
            bezelMid: '--bezel-mid',
            bezelBottom: '--bezel-bottom',
        };
        Object.keys(map).forEach((key) => {
            if (theme[key]) root.setProperty(map[key], theme[key]);
        });
        const g = gradientFrom(theme);
        root.setProperty('--accent', theme.accentFill || g.fill);
        root.setProperty('--accent-v', theme.accentFillV || g.fillV);
        root.setProperty('--accent-rgb', g.rgb);
        root.setProperty('--on-accent', g.ink);
        root.setProperty('--red', g.mid);
        root.setProperty('--red-hot', g.start);
        root.setProperty('--ember', g.start);
        root.setProperty('--crimson', g.end);
        if (theme.appName) $('appName').textContent = theme.appName;
        if (theme.appTag) $('appTag').textContent = theme.appTag;
        const logo = $('brandLogo');
        if (logo && theme.logo) logo.src = theme.logo;
    }

    function nui(name, data) {
        if (!IN_FIVEM) {
            return Promise.resolve({ ok: true, preview: true });
        }
        return fetch(`https://${resourceName}/${name}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data || {}),
        }).then((res) => res.json()).catch(() => ({ ok: false }));
    }

    function toast(text) {
        const el = $('toast');
        el.hidden = false;
        el.textContent = text;
        clearTimeout(state.toastTimer);
        state.toastTimer = setTimeout(() => { el.hidden = true; }, 2400);
    }

    function tickClock() {
        const d = new Date();
        $('clock').textContent = d.toTimeString().slice(0, 5);
    }

    function selected() {
        const scripts = (state.payload && state.payload.scripts) || [];
        return scripts.find((s) => s.id === state.selectedId) || scripts[0] || null;
    }

    function badge(script) {
        if (!script || script.state === 'missing') return '<span class="badge miss"><i class="dot"></i>Missing</span>';
        if (script.running) return '<span class="badge on"><i class="dot"></i>Running</span>';
        return '<span class="badge off"><i class="dot"></i>Stopped</span>';
    }

    function nav() {
        const items = [
            ['home', 'Home', icons.home],
            ['scripts', 'Scripts', icons.apps],
            ['players', 'Players', icons.users],
            ['logs', 'Audit log', icons.logs],
        ];
        $('nav').innerHTML = items.map(([id, label, svg]) => (
            `<button data-view="${id}" class="${state.view === id || (state.view === 'detail' && id === 'scripts') ? 'active' : ''}">${svg}<span>${label}</span></button>`
        )).join('');
        $('nav').querySelectorAll('button').forEach((btn) => {
            btn.onclick = () => {
                state.view = btn.dataset.view;
                render();
            };
        });
    }

    function renderSidebarCard() {
        const script = selected();
        if (!script) {
            $('stackName').textContent = 'No script selected';
            $('stackMeta').textContent = 'Choose a DJ FiveM resource';
            return;
        }
        $('stackName').textContent = script.label;
        $('stackMeta').textContent = `${script.resource} · ${script.state}`;
    }

    function renderHome() {
        const p = state.payload;
        const stats = p.stats || {};
        const scripts = p.scripts || [];
        const logo = (p.theme && p.theme.logo) || 'images/logo.png';
        const preset = (p.theme && p.theme.preset) || 'custom';
        $('page').innerHTML = `
            <div class="lockup">
                <img src="${logo}" alt="DJ FiveM Scripts" />
                <div class="theme-strip" title="${preset} gradient"></div>
            </div>
            <div class="page-head">
                <div>
                    <p class="eyebrow">Command center</p>
                    <h1>Home</h1>
                    <p>Every DJ FiveM script under one Discord-locked tablet.</p>
                </div>
            </div>
            <div class="stats">
                <article class="stat"><span>Installed</span><strong>${stats.installed || 0}</strong></article>
                <article class="stat"><span>Running</span><strong>${stats.running || 0}</strong></article>
                <article class="stat"><span>Stopped</span><strong>${stats.stopped || 0}</strong></article>
                <article class="stat"><span>Players</span><strong>${stats.players || 0}</strong></article>
            </div>
            <div class="grid">
                ${scripts.map((s) => `
                    <button class="app-tile" data-id="${s.id}">
                        <div class="glyph">${icon(s.icon)}</div>
                        <div>
                            <h3>${s.label}</h3>
                            <p>${s.tag}</p>
                        </div>
                        ${badge(s)}
                    </button>
                `).join('')}
            </div>
        `;
        $('page').querySelectorAll('.app-tile').forEach((btn) => {
            btn.onclick = () => {
                state.selectedId = btn.dataset.id;
                state.view = 'detail';
                render();
            };
        });
    }

    function renderScripts() {
        const q = state.query.toLowerCase();
        const scripts = ((state.payload && state.payload.scripts) || []).filter((s) => {
            if (!q) return true;
            return `${s.label} ${s.resource} ${s.tag}`.toLowerCase().includes(q);
        });
        $('page').innerHTML = `
            <div class="page-head">
                <div>
                    <p class="eyebrow">Catalog</p>
                    <h1>Scripts</h1>
                    <p>Start, stop, restart, and run allowlisted admin tools.</p>
                </div>
                <label class="search">
                    ${icons.apps}
                    <input id="scriptSearch" placeholder="Search scripts" value="${state.query.replace(/"/g, '&quot;')}" />
                </label>
            </div>
            <div class="list">
                ${scripts.map((s) => `
                    <article class="track">
                        <div class="cover">${icon(s.icon)}</div>
                        <div>
                            <h4>${s.label}</h4>
                            <p>${s.resource} · ${s.tag}</p>
                        </div>
                        <div class="track-actions">
                            ${badge(s)}
                            <button class="icon-btn" data-open="${s.id}" title="Open">${icons.play}</button>
                        </div>
                    </article>
                `).join('') || '<div class="empty"><div class="blob"></div>No scripts match.</div>'}
            </div>
        `;
        const search = $('scriptSearch');
        if (search) {
            search.oninput = () => {
                state.query = search.value;
                renderScripts();
                renderFooter();
            };
        }
        $('page').querySelectorAll('[data-open]').forEach((btn) => {
            btn.onclick = () => {
                state.selectedId = btn.dataset.open;
                state.view = 'detail';
                render();
            };
        });
    }

    function renderDetail() {
        const script = selected();
        if (!script) {
            state.view = 'scripts';
            return renderScripts();
        }
        const actions = script.actions || [];
        $('page').innerHTML = `
            <div class="page-head">
                <div>
                    <p class="eyebrow">${script.category}</p>
                    <h1>${script.label}</h1>
                    <p>${script.description}</p>
                </div>
                ${badge(script)}
            </div>
            <div class="hero">
                <div class="hero-art">${icon(script.icon)}</div>
                <div class="hero-copy">
                    <h2>${script.resource}</h2>
                    <p class="author">${script.tag} · ${script.state}</p>
                    <div class="composer">
                        <button class="btn btn-ghost" data-back>Back to scripts</button>
                        <button class="btn btn-primary" data-ctrl="start" ${script.locked || !script.installed || script.running ? 'disabled' : ''}>Start</button>
                        <button class="btn btn-ghost" data-ctrl="restart" ${script.locked || !script.installed ? 'disabled' : ''}>Restart</button>
                        <button class="btn btn-danger" data-ctrl="stop" ${script.locked || !script.running ? 'disabled' : ''}>Stop</button>
                    </div>
                </div>
            </div>
            <h3 style="margin:0 0 10px;font-size:14px;color:var(--muted)">Admin tools</h3>
            <div class="list">
                ${actions.length ? actions.map((a) => `
                    <article class="track">
                        <div class="cover">${icons.play}</div>
                        <div>
                            <h4>${a.label}</h4>
                            <p>${a.hint || a.command}</p>
                        </div>
                        <div class="track-actions">
                            <button class="btn btn-primary" data-action="${a.id}">Run</button>
                        </div>
                    </article>
                `).join('') : '<div class="empty"><div class="blob"></div>No admin commands for this script. Use resource controls above.</div>'}
            </div>
        `;
        $('page').querySelector('[data-back]').onclick = () => {
            state.view = 'scripts';
            render();
        };
        $('page').querySelectorAll('[data-ctrl]').forEach((btn) => {
            btn.onclick = () => run({ kind: btn.dataset.ctrl, scriptId: script.id });
        });
        $('page').querySelectorAll('[data-action]').forEach((btn) => {
            btn.onclick = () => {
                const action = actions.find((a) => a.id === btn.dataset.action);
                if (!action) return;
                if (action.fields && action.fields.length) {
                    openModal(script, action);
                } else {
                    run({ kind: 'command', scriptId: script.id, actionId: action.id, args: {} });
                }
            };
        });
    }

    function renderPlayers() {
        const players = (state.payload && state.payload.players) || [];
        $('page').innerHTML = `
            <div class="page-head">
                <div>
                    <p class="eyebrow">Server</p>
                    <h1>Players</h1>
                    <p>Online ids used by give/remove tools.</p>
                </div>
            </div>
            <div class="list">
                ${players.length ? players.map((p) => `
                    <article class="track">
                        <div class="cover">${icons.users}</div>
                        <div>
                            <h4>${p.name}</h4>
                            <p>ID ${p.id}</p>
                        </div>
                    </article>
                `).join('') : '<div class="empty"><div class="blob"></div>No players online.</div>'}
            </div>
        `;
    }

    function renderLogs() {
        const logs = (state.payload && state.payload.logs) || [];
        $('page').innerHTML = `
            <div class="page-head">
                <div>
                    <p class="eyebrow">Security</p>
                    <h1>Audit log</h1>
                    <p>Server-side record of tablet opens and allowlisted actions.</p>
                </div>
            </div>
            <div class="list">
                ${logs.length ? logs.slice().reverse().map((l) => `
                    <article class="log-row">
                        <time>${new Date((l.time || 0) * 1000).toLocaleTimeString()}</time>
                        <div>
                            <strong>${l.name}</strong>
                            <p style="color:var(--muted);font-size:12px">${l.action} ${l.detail || ''}</p>
                        </div>
                        <span class="${l.ok ? 'log-ok' : 'log-no'}">${l.ok ? 'OK' : 'DENY'}</span>
                    </article>
                `).join('') : '<div class="empty"><div class="blob"></div>No admin actions yet.</div>'}
            </div>
        `;
    }

    function renderFooter() {
        const script = selected();
        const stats = (state.payload && state.payload.stats) || {};
        const runningPct = stats.installed ? Math.round((stats.running / stats.installed) * 100) : 0;
        $('player').innerHTML = `
            <div class="player-inner">
                <div class="now-mini">
                    <div class="cover">${icon(script && script.icon)}</div>
                    <div>
                        <h4>${script ? script.label : 'No selection'}</h4>
                        <p>${script ? script.resource : 'Pick a script'}</p>
                    </div>
                </div>
                <div class="transport">
                    <button class="icon-btn" data-ctrl="start" title="Start" ${!script || script.locked || script.running || !script.installed ? 'disabled' : ''}>${icons.play}</button>
                    <button class="play-main" data-ctrl="restart" title="Restart" ${!script || script.locked || !script.installed ? 'disabled' : ''}>${icons.restart}</button>
                    <button class="icon-btn" data-ctrl="stop" title="Stop" ${!script || script.locked || !script.running ? 'disabled' : ''}>${icons.stop}</button>
                </div>
                <div class="progress">
                    <span>${stats.running || 0}</span>
                    <div class="bar"><i style="width:${runningPct}%"></i></div>
                    <span>${stats.installed || 0}</span>
                </div>
            </div>
        `;
        $('player').querySelectorAll('[data-ctrl]').forEach((btn) => {
            btn.onclick = () => {
                if (!script) return;
                run({ kind: btn.dataset.ctrl, scriptId: script.id });
            };
        });
    }

    function openModal(script, action) {
        const players = (state.payload && state.payload.players) || [];
        const fields = action.fields.map((f) => {
            if (f.type === 'player') {
                return `<div class="field"><label>${f.label}</label><select name="${f.name}">
                    ${players.map((p) => `<option value="${p.id}">${p.id} — ${p.name}</option>`).join('') || '<option value="">No players</option>'}
                </select></div>`;
            }
            if (f.type === 'select') {
                return `<div class="field"><label>${f.label}</label><select name="${f.name}">
                    ${(f.options || []).map((o) => `<option value="${o}">${o}</option>`).join('')}
                </select></div>`;
            }
            return `<div class="field"><label>${f.label}</label><input name="${f.name}" type="number" min="${f.min || 0}" max="${f.max || 1000000}" value="${f.default || 0}" /></div>`;
        }).join('');

        $('modalRoot').innerHTML = `
            <div class="modal">
                <h2>${action.label}</h2>
                <p>${action.hint || ''}</p>
                ${fields}
                <div class="modal-actions">
                    <button class="btn btn-ghost" id="modalCancel">Cancel</button>
                    <button class="btn btn-primary" id="modalRun">Run</button>
                </div>
            </div>
        `;
        $('modalCancel').onclick = () => { $('modalRoot').innerHTML = ''; };
        $('modalRun').onclick = () => {
            const args = {};
            action.fields.forEach((f) => {
                const input = $('modalRoot').querySelector(`[name="${f.name}"]`);
                args[f.name] = input ? input.value : '';
            });
            $('modalRoot').innerHTML = '';
            run({ kind: 'command', scriptId: script.id, actionId: action.id, args });
        };
    }

    function applyPayload(payload) {
        state.payload = payload;
        applyTheme(payload.theme);
        const pill = $('accessPill');
        if (pill) {
            if (payload.access && payload.access.ready) {
                pill.textContent = 'Discord';
            } else {
                pill.textContent = 'Locked';
            }
        }
        if (!state.selectedId && payload.scripts && payload.scripts[0]) {
            state.selectedId = payload.scripts[0].id;
        }
        render();
    }

    function render() {
        nav();
        renderSidebarCard();
        if (state.view === 'home') renderHome();
        else if (state.view === 'scripts') renderScripts();
        else if (state.view === 'detail') renderDetail();
        else if (state.view === 'players') renderPlayers();
        else renderLogs();
        renderFooter();
    }

    async function run(body) {
        if (!IN_FIVEM) {
            toast(`Preview: ${body.kind} ${body.scriptId || ''} ${body.actionId || ''}`);
            return;
        }
        const data = await nui('run', body);
        if (!data || !data.ok) {
            toast((data && data.locale) || 'Action blocked');
            return;
        }
        applyPayload(data);
        toast(data.ran ? `Ran /${data.ran}` : 'Updated');
    }

    function openUi(payload) {
        document.body.classList.toggle('fivem', IN_FIVEM);
        $('stage').hidden = false;
        $('stage').classList.add('is-open');
        applyPayload(payload);
    }

    function closeUi() {
        $('stage').classList.remove('is-open');
        $('stage').hidden = true;
        $('modalRoot').innerHTML = '';
        nui('close');
    }

    $('statusClose').onclick = closeUi;
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') closeUi();
    });

    window.addEventListener('message', (event) => {
        const data = event.data || {};
        if (data.action === 'open') openUi(data.payload || {});
        if (data.action === 'close') {
            $('stage').classList.remove('is-open');
            $('stage').hidden = true;
        }
    });

    const previewThemes = {
        chrome: {
            gradientAngle: 125,
            gradientColors: ['#ffffff', '#d4d4d4', '#8a8a8a', '#f4f4f4', '#3a3a3a'],
            onAccent: '#111111',
            glow: '#e8e8e8',
            preset: 'chrome',
        },
        lava: {
            gradientAngle: 90,
            gradientColors: ['#ffb347', '#e10600', '#7a00c8'],
            onAccent: '#ffffff',
            glow: '#e10600',
            preset: 'lava',
        },
        vice: {
            gradientAngle: 110,
            gradientColors: ['#ff2bd6', '#7a5cff', '#00e5ff'],
            onAccent: '#ffffff',
            glow: '#7a5cff',
            preset: 'vice',
        },
        gold: {
            gradientAngle: 120,
            gradientColors: ['#fff3c4', '#f5c542', '#c4841d', '#7a4a00'],
            onAccent: '#1a1204',
            glow: '#f5c542',
            preset: 'gold',
        },
        ice: {
            gradientAngle: 100,
            gradientColors: ['#d9fbff', '#5ad0ff', '#2563eb', '#0b1b4a'],
            onAccent: '#ffffff',
            glow: '#5ad0ff',
            preset: 'ice',
        },
        sunset: {
            gradientAngle: 95,
            gradientColors: ['#ffe08a', '#ff6a2b', '#e10600', '#6b0030'],
            onAccent: '#ffffff',
            glow: '#ff6a2b',
            preset: 'sunset',
        },
    };

    $('previewBar').querySelectorAll('button').forEach((btn) => {
        btn.onclick = () => {
            $('previewBar').querySelectorAll('button').forEach((b) => b.classList.remove('active'));
            btn.classList.add('active');
            const next = Object.assign({}, (state.payload && state.payload.theme) || {}, previewThemes[btn.dataset.preview]);
            delete next.accentFill;
            delete next.accentFillV;
            applyTheme(next);
            if (state.payload && state.payload.theme) {
                state.payload.theme = next;
            }
            render();
        };
    });

    function mockPayload() {
        return {
            ok: true,
            player: { id: 1, name: 'Diesel' },
            theme: {
                appName: 'DJ FiveM',
                appTag: 'Scripts',
                logo: 'images/logo.png',
                preset: 'chrome',
                gradientAngle: 125,
                gradientColors: ['#ffffff', '#d4d4d4', '#8a8a8a', '#f4f4f4', '#3a3a3a'],
                onAccent: '#111111',
                glow: '#e8e8e8',
            },
            access: { ready: true, via: 'discord' },
            stats: { installed: 16, running: 11, stopped: 5, missing: 2, players: 3 },
            players: [
                { id: 1, name: 'Diesel' },
                { id: 12, name: 'Nova' },
                { id: 44, name: 'Rico' },
            ],
            logs: [
                { time: Date.now() / 1000, name: 'Diesel', action: 'open', ok: true },
                { time: Date.now() / 1000, name: 'Diesel', action: 'command.admin', detail: 'djadmin', ok: true },
            ],
            scripts: [
                { id: 'djbooth', resource: 'djbooth', label: 'DJ Booth', tag: 'Lumina', category: 'entertainment', icon: 'music', description: 'Booth placement and live playback.', state: 'started', installed: true, running: true, actions: [{ id: 'admin', label: 'Open booth admin', hint: '/djadmin', command: 'djadmin' }] },
                { id: 'donator', resource: 'dj-donator', label: 'Donator Store', tag: 'Rebel Coins', category: 'economy', icon: 'store', description: 'Coin shop and listings.', state: 'started', installed: true, running: true, actions: [{ id: 'givecoins', label: 'Give coins', hint: '/givecoins', command: 'givecoins {player} {amount}', fields: [{ name: 'player', type: 'player', label: 'Player' }, { name: 'amount', type: 'number', label: 'Amount', min: 1, max: 1000000, default: 100 }] }] },
                { id: 'shops', resource: 'djfivem-shops', label: 'Shops', tag: 'Retail', category: 'economy', icon: 'bag', description: 'Ped shops.', state: 'started', installed: true, running: true, actions: [] },
                { id: 'blackmarket', resource: 'djfivem-blackmarket', label: 'Black Market', tag: 'Chiliad', category: 'crime', icon: 'skull', description: 'Mountain dealer.', state: 'stopped', installed: true, running: false, actions: [] },
                { id: 'drugs', resource: 'djfivem-drugs', label: 'Drugs', tag: 'Trap', category: 'crime', icon: 'flask', description: 'Harvest and trap.', state: 'started', installed: true, running: true, actions: [{ id: 'trap', label: 'Toggle trap', hint: '/trap', command: 'trap' }] },
                { id: 'fishing', resource: 'djfivem-fishing', label: 'Fishing', tag: 'Angler', category: 'jobs', icon: 'fish', description: 'Fishing and tackle.', state: 'started', installed: true, running: true, actions: [{ id: 'kit', label: 'Give test kit', hint: '/fishingkit', command: 'fishingkit' }] },
                { id: 'pets', resource: 'djfivem-pets', label: 'Pets', tag: 'Companions', category: 'cosmetics', icon: 'paw', description: 'Walkable pets.', state: 'started', installed: true, running: true, actions: [{ id: 'givepet', label: 'Give pet', hint: '/givepet', command: 'givepet {player} {species}', fields: [{ name: 'player', type: 'player', label: 'Player' }, { name: 'species', type: 'select', label: 'Species', options: ['rottweiler', 'husky', 'cat'] }] }] },
                { id: 'gangs', resource: 'gangs', label: 'Gangs', tag: 'Zones', category: 'crime', icon: 'map', description: 'Territories and wars.', state: 'missing', installed: false, running: false, actions: [{ id: 'zones', label: 'Zone editor', hint: '/zoneeditor', command: 'zoneeditor' }] },
            ],
        };
    }

    tickClock();
    setInterval(tickClock, 15000);

    if (!IN_FIVEM) {
        $('previewBar').hidden = false;
        $('previewBar').classList.add('is-open');
        openUi(mockPayload());
    }
})();
