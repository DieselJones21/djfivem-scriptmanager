--[[
    Product license gate. This file is server-only — never add it to `files` or
    `shared_scripts`. Change License.ProductSecret before you distribute builds,
    then generate keys with `tools/generate_license.py` or `djsm_makelicense`.
]]

License = {
    valid = false,
    reason = 'not_checked',
    bound = false,
}

-- HMAC secret used to sign keys. Change this before selling / leaking a build.
License.ProductSecret = 'djsm.v1.dd1e9aff069bc38ed4f7270a79285031'

local function trim(value)
    return tostring(value or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

local function normalizeKey(value)
    return trim(value):upper():gsub('%s+', '')
end

local function parseKey(raw)
    local key = normalizeKey(raw)
    local a, b, c, d = key:match('^DJSM%-([A-F0-9][A-F0-9][A-F0-9][A-F0-9])%-([A-F0-9][A-F0-9][A-F0-9][A-F0-9])%-([A-F0-9][A-F0-9][A-F0-9][A-F0-9])%-([A-F0-9][A-F0-9][A-F0-9][A-F0-9])$')
    if not a then
        return nil
    end
    return {
        nonce = a .. b,
        mac = c .. d,
        display = ('DJSM-%s-%s-%s-%s'):format(a, b, c, d),
    }
end

local function expectedMac(nonce, bind)
    local msg = ('DJSM|v1|%s|%s'):format(nonce:upper(), bind)
    return Sha256.hmac(License.ProductSecret, msg):sub(1, 8):upper()
end

local function timingSafeEqual(a, b)
    if type(a) ~= 'string' or type(b) ~= 'string' or #a ~= #b then
        return false
    end
    local diff = 0
    for i = 1, #a do
        diff = diff | (a:byte(i) ~ b:byte(i))
    end
    return diff == 0
end

function License.ServerBindValue()
    if not Config.BindLicenseToServer then
        return '*'
    end
    local sv = trim(GetConvar('sv_licenseKey', ''))
    if sv == '' then
        return nil
    end
    return sv
end

function License.MakeKey(bind)
    local nonce = Sha256.hash(('djsm:%s:%s'):format(os.time(), tostring(math.random()))):sub(1, 8):upper()
    local mac = expectedMac(nonce, bind or '*')
    return ('DJSM-%s-%s-%s-%s'):format(nonce:sub(1, 4), nonce:sub(5, 8), mac:sub(1, 4), mac:sub(5, 8))
end

function License.Verify(raw, bind)
    local parsed = parseKey(raw)
    if not parsed then
        return false, 'invalid_format'
    end
    if not bind or bind == '' then
        return false, 'missing_server_bind'
    end
    local mac = expectedMac(parsed.nonce, bind)
    if not timingSafeEqual(parsed.mac, mac) then
        return false, 'invalid_signature'
    end
    return true, parsed.display
end

function License.Check()
    local raw = Config.License
    if type(raw) ~= 'string' or trim(raw) == '' or trim(raw) == 'PUT-YOUR-LICENSE-HERE' then
        License.valid = false
        License.reason = 'missing'
        return false
    end

    local bind = License.ServerBindValue()
    if Config.BindLicenseToServer and not bind then
        License.valid = false
        License.reason = 'no_sv_licenseKey'
        return false
    end

    local ok, detail = License.Verify(raw, bind or '*')
    License.valid = ok
    License.reason = ok and 'ok' or detail
    License.bound = Config.BindLicenseToServer == true
    return ok
end

function License.IsValid()
    return License.valid == true
end

function License.PublicStatus()
    return {
        valid = License.valid,
        reason = License.reason,
        bound = License.bound,
    }
end
