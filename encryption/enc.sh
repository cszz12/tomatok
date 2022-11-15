#!/bin/sh

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
  echo "no file to encrypt!"
  exit 1
fi

# detect os
# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "function not implemented yet!"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
	zip -r large_file.zip large_file

	openssl rand -base64 32 > key.bin
	openssl enc -aes-256-cbc -salt  -in large_file.zip   -out cloud/large_file.zip.enc -pass file:./key.bin
	openssl rsautl -encrypt -inkey pems/my_public.pem -pubin -in key.bin -out cloud/key.bin.enc

	# current_time=$(date "+%Y.%m.%d-%H.%M.%S")
	current_time=$(date "+%Y%m%d%H%M")
	zip -r backup${current_time}.zip cloud/ pems/
	# upload backup.zip to baidu cloud

	# mv *.enc cloud/
	rm -P -r large_file key.bin large_file.zip
fi