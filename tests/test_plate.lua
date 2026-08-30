Config = { Theme = {} }
dofile('shared/utils.lua')

local function fail(msg)
    io.stderr:write('FAIL: ' .. msg .. '\n')
    os.exit(1)
end

if Utils.SanitizePlate('ab 123') ~= 'AB123' then
    fail('spaces/case')
end
if Utils.SanitizePlate('ABC-12') ~= nil then
    fail('hyphen')
end
if Utils.SanitizePlate('THISPLATEISTOOLONG') ~= nil then
    fail('length')
end
if Utils.SanitizePlate('305VICE') ~= '305VICE' then
    fail('ok')
end
if Utils.SanitizeToken('police', 32) ~= 'police' then
    fail('job')
end
if Utils.SanitizeToken('police;stop', 32) ~= nil then
    fail('inject')
end

print('ok')
