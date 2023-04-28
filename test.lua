#! /usr/bin/env lua5.1
local crc16 = require "crc16"

local sFmt = string.format

local c, e = pcall(crc16.new, "ABC")
if c then
    assert(false, "CRC lib should have crashed on incorrect CRC 16 name, but it did not")
else
    print("Falsification test successful")
end

local cases = {
    ARC = {
        ["AA"]          = 0x60F0,
        ["1AFXJbsJNW"]  = 0x1888,
        ["ILAiD5XOlJ"]  = 0xC287,
        ["QoCTLeRKKm"]  = 0x213F,
        ["3VrgJLJEGD"]  = 0xC29C,
    },
    XMODEM = {
        ["AA"]          = 0x6618,
        ["1AFXJbsJNW"]  = 0xCF5C,
        ["ILAiD5XOlJ"]  = 0xB1AD,
        ["QoCTLeRKKm"]  = 0xBE06,
        ["3VrgJLJEGD"]  = 0xC52F,
    },
    CCITT = {
        ["AA"]          = 0x7B17,
        ["1AFXJbsJNW"]  = 0x2E65,
        ["ILAiD5XOlJ"]  = 0x5094,
        ["QoCTLeRKKm"]  = 0x5F3F,
        ["3VrgJLJEGD"]  = 0x2416,
    },
}

for name, samples in pairs(cases) do
    local crc = crc16.new(name)
    for k,v in pairs(samples) do
        -- Compute test
        n = crc:compute(k)
        assert(n == v, sFmt("%s CRC16 compute function failed on string %s. Expected: %X, got: %X", name, k, v, n))
        local l = #k
        local lengthened = k.."...."
        n = crc:compute(lengthened, l)
        assert(n == v, sFmt("%s CRC16 compute function failed on string %s. Expected: %X, got: %X", name, k, v, n))
        -- Add test
        sum = 0
        for c in k:gmatch"." do
            sum = crc:add(sum, c)
        end
        assert(sum == v, sFmt("%s CRC16 add function failed on string %s. Expected: %X, got: %X", name, k, v, sum))
    end
    print(sFmt("CRC16 %s test successful", name))
end
