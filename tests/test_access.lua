dofile('server/access.lua')

local function fail(msg)
    io.stderr:write('FAIL: ' .. msg .. '\n')
    os.exit(1)
end

if Access.Normalize('discord:123456789012345678') ~= '123456789012345678' then
    fail('prefix')
end
if Access.Normalize(' 123456789012345678 ') ~= '123456789012345678' then
    fail('spaces')
end
if Access.Normalize('abc') ~= nil then
    fail('short')
end

Config = {
    DiscordIds = {
        'discord:123456789012345678',
        '987654321098765432',
        'nope',
    },
}

if not Access.Load() then
    fail('load')
end
if Access.count ~= 2 then
    fail('count ' .. tostring(Access.count))
end

print('ok')
