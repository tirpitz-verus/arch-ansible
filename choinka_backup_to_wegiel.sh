#!/usr/bin/env bash

read -p "do you want to perform a backup to wegiel? (Yes|no)" -n 1 -r -e
answer=${REPLY:-y}
if [[ $answer =~ ^[Yy]$ ]]; then
  echo "doing backup"
  rsync --recursive --perms --times --executability --links --progress --owner --group --human-readable --delete --force --delete-after --stats \
    /home/marek/Dropbox \
    /home/marek/Documents \
    /home/marek/Projects \
    marek@{{ wegiel_ip }}:choinka
else
  echo "not doing any backup"
fi
