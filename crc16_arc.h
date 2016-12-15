/**
 * @brief adds a single byte to the currently existing crc value
 * @param crc The crc calculated so far
 * @param byte The byte you want to add to the existing crc
 * @return The new CRC value
 */
unsigned crc16_arc_add(unsigned crc, unsigned byte);

/**
 * @brief Calculates the ARC CRC 16 of a given string
 * @param Data the string you want to turn into
 */
unsigned crc16_arc_compute(const char* data, size_t len);
