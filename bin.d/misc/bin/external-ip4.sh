#!/usr/bin/env bash
# https://www.cyberciti.biz/faq/how-to-find-public-ip-address-aws-ec2-or-lightsail-vm/
# ec2 instance: curl http://checkip.amazonaws.com/ # works elsewhere
dig +short myip.opendns.com @resolver1.opendns.com.
