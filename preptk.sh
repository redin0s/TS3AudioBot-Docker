#!/bin/sh
tar cvzf tokens.tar.gz ./tokens.env
openssl enc  -aes-256-cbc -pbkdf2 -md sha512 -salt -iter 10000 -in "tokens.tar.gz" -out "tokensenc.tar.gz"
