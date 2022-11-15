

cd cloud 
openssl rsautl -decrypt -inkey ../pems/my_private.pem -in key.bin.enc -out key.bin

openssl enc -d -aes-256-cbc -in large_file.zip.enc   -out large_file.zip -pass file:./key.bin

unzip large_file.zip

cd ..