#!/bin/sh

#clear folder
rm -r cloud
rm -r large_file

# unzip with overwrite
unzip -o backup*.zip

cd cloud 
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	openssl rsautl -decrypt -inkey ../pems/my_private.pem -in key.bin.enc -out key.bin
	openssl enc -d -pbkdf2 -aes256 -base64 -in large_file.zip.enc   -out large_file.zip -pass file:./key.bin
elif [[ "$OSTYPE" == "darwin"* ]]; then
	openssl rsautl -decrypt -inkey ../pems/my_private.pem -in key.bin.enc -out key.bin
	openssl enc -d -aes-256-cbc -in large_file.zip.enc -out large_file.zip -pass file:./key.bin
fi

unzip -o large_file.zip

cd ..

# clear folder
mv cloud/large_file .
rm -r cloud