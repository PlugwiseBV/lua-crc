
#ifndef CRC16_ARC_INCLUDED
#define CRC16_ARC_INCLUDED

#include <stdlib.h> //For size_t
#include <stdint.h> //For uint16_t
/**
 * @brief Adds a single byte to the currently existing crc value
 * @param crc The crc calculated so far
 * @param byte The byte you want to add to the existing crc
 * @return The new CRC value
 */
uint16_t crc16_arc_add(uint16_t crc, const char* byte);

/**
 * @brief Calculates the ARC CRC 16 of a given string
 * @param Data the string you want to turn into
 * @param Len the length of the data
 */
uint16_t crc16_arc_compute(const char* data, size_t len);

#endif
