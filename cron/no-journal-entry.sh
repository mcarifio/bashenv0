#!/usr/bin/env bash

# crontab -e and then add a crontab line for this command, like:
# 0 5 * * * ~/bashenv/cron/no-journal-entry.sh



function do1 {
    # echo $1
    rm -vf $1
    
}

# for each unpopulated journal entry, remove it
for f in ~/writing/journal/source/journal*.rst ; do
  let fsize=$(stat --format=%s $f)
  if (( fsize == 249 )) ; then
      do1 $f
  fi
done
