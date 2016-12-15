#! /usr/bin/env lua5.1
local crc16 = require "crc16"

print(crc16)
crc = crc16.new("ARC")
print(crc:compute("lalala"))
print(crc:compute("lalal"))
