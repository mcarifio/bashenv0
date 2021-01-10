openssl x509 -in /home/mcarifio/.config/hexchat/certs/client.pem -outform der | sha1sum -b | cut -d  -f1
