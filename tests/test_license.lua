-- Standalone crypto self-test (no FiveM).
dofile('server/sha256.lua')

local function fail(msg)
    io.stderr:write('FAIL: ' .. msg .. '\n')
    os.exit(1)
end

local abc = Sha256.hash('abc')
if abc ~= 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad' then
    fail('sha256(abc) = ' .. abc)
end

local empty = Sha256.hash('')
if empty ~= 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' then
    fail('sha256(empty) = ' .. empty)
end

local fox = Sha256.hash('The quick brown fox jumps over the lazy dog')
if fox ~= 'd7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592' then
    fail('sha256(fox) = ' .. fox)
end

local hmac = Sha256.hmac('key', 'The quick brown fox jumps over the lazy dog')
if hmac ~= 'f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8' then
    fail('hmac = ' .. hmac)
end

local secret = 'djsm.v1.dd1e9aff069bc38ed4f7270a79285031'
local nonce = 'A7F3C91B'
local msg = ('DJSM|v1|%s|*'):format(nonce)
local mac = Sha256.hmac(secret, msg):sub(1, 8):upper()
if mac ~= 'CF541C80' then
    fail('license mac = ' .. mac)
end

print('ok')
