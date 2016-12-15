#! /usr/bin/env lua5.1
local crc16 = require "crc16"

ARCTestTable = {    ["AA"]          = 0x60F0,
                    ["1AFXJbsJNW"]  = 0x1888,
                    ["ILAiD5XOlJ"]  = 0xC287,
                    ["QoCTLeRKKm"]  = 0x213F,
                    ["3VrgJLJEGD"]  = 0xC29C
                }

crc = crc16.new("ARC")
for k,v in pairs(ARCTestTable) do
    -- Compute test
    n = crc:compute(k)
    assert(n == v, string.format("ARC CRC16 compute function failed on string %s. Expected: %X, got: %X\n", k, v, n))
    -- Add test
    sum = 0
    for c in k:gmatch"." do
        sum = crc:add(sum, c)
    end
    assert(sum == v, string.format("ARC CRC16 add function failed on string %s. Expected: %X, got: %X\n", k, v, sum))
end
io.write("CRC16 ARC test succesfull\n")
