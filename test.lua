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
    n = crc:compute(k)
    assert(n == v, string.format("ARC CRC16 failed on string %s. Expected: %X, got: %X", k, v, n))
end
io.write("CRC16 ARC test succesfull\n")
