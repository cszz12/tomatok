#!/bin/sh

# clear folder
rm -r cloud
rm *.zip

# gen public key
DIR="pems/"
if [ ! -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "Gen public key in ${DIR}..."
  mkdir pems
  openssl genrsa -aes128 -out pems/my_private.pem 1024
  openssl rsa -in pems/my_private.pem -pubout > pems/my_public.pem
fi

# to-encrypt files are put in large_file
DIR="large_file/"
if [ ! -d "$DIR" ]; then
  mkdir ${DIR}
  echo "no file to encrypt!"
  exit 1
fi

zip -r large_file.zip large_file
openssl rand -base64 32 > key.bin

# current_time=$(date "+%Y.%m.%d-%H.%M.%S")
current_time=$(date "+%Y%m%d%H%M")

# detect os
# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "enc in Ubuntu!"
  mkdir cloud

  openssl enc -e -pbkdf2 -aes256 -base64 -in large_file.zip \
  -out cloud/large_file.zip.enc -pass file:./key.bin
  
  openssl rsautl -encrypt -inkey pems/my_public.pem -pubin -in key.bin -out cloud/key.bin.enc
  
  zip -r backup${current_time}.zip cloud/ pems/

  shred -u key.bin large_file.zip
	rm -r large_file cloud
  exit 1
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "enc in Mac OSX!"
  mkdir cloud

	openssl enc -aes-256-cbc -salt  -in large_file.zip   -out cloud/large_file.zip.enc -pass file:./key.bin
	openssl rsautl -encrypt -inkey pems/my_public.pem -pubin -in key.bin -out cloud/key.bin.enc

	zip -r backup${current_time}.zip cloud/ pems/
	rm -P -r large_file key.bin large_file.zip cloud
fi

# upload backup.zip to baidu cloud

