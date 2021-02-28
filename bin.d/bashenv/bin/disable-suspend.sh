#!/usr/bin/env bash

# suspend has been broken in linux forever
# https://ostechnix.com/linux-tips-disable-suspend-and-hibernation
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target  # undo
systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target
