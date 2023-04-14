/*
 *  myaes.h
 *  YouChatMe
 *
 *  Created by Song on 11/23/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *  V20110404
 */
#include <stdint.h>

void myaes_encrypt(const int8_t *src, uint32_t len, uint8_t *key, uint8_t *dest, uint32_t *destLen);

void myaes_decrypt(const int8_t *src, uint32_t len, uint8_t *key, uint8_t *dest, uint32_t *destLen);

void myaes_encrypt_16(const int8_t *src, uint32_t len, uint8_t *key, uint8_t *dest, uint32_t *destLen);

void myaes2_encrypt(const int8_t *src, uint32_t len, uint8_t *key, uint8_t *dest, uint32_t *destLen);

void myaes2_decrypt(const int8_t *src, uint32_t len, uint8_t *key, uint8_t *dest, uint32_t *destLen);

void myaes2_encrypt_16(const int8_t *src, uint32_t len, uint8_t *key, uint8_t *dest, uint32_t *destLen);

char* itoa(int value, char* result, int base);

