#!/bin/bash
#set -x
here=$(readlink -f $(dirname $BASH_SOURCE))

function untranslated {
  po=${1:?-'expecting a po file, none received'}
  let msgids=$( msgattrib --untranslated $po | grep -c msgid )
  if (( msgids == 0 )) ; then 
			echo 0
  else
			echo $(( msgids - 1 ))
  fi
}


function fuzzy {
  po=${1:?-'expecting a po file, none received'}
  let msgids=$( msgattrib --only-fuzzy $po | grep -c msgid )
  if (( msgids == 0 )) ; then 
			echo 0
  else
			echo $(( msgids - 1 ))
  fi
}


#usage: accept-translations.sh languages.list directory*

# language.list contains the list of supported languages for this transl task
language_list=$1
# bring in the list of languages
languages=$(< $language_list ) ; shift


status=0 # assume nothing's wrong until something's wrong

# each directory(a pkg name) contains a list of po files
for pkg in $*; do
  # are we missing any po files?
  for po in $languages; do
      file=$pkg/$po.po # expected file
			if [[ ! -f $file ]] ; then
			  echo "expecting $file; not found"
				status=1
      fi
  done

	# did we get any unexpected po files?
  for po in $pkg/*.po; do
			if ! grep -q $(basename $po .po) $language_list ; then
				echo "$po unexpected"
				status=1
      fi
  done
done

# all po files should msgfmt -c without error
for pkg in $*; do
  for po in $(find $pkg -name \*.po); do
    if ! msgfmt -c $po ; then
	    echo "$po doesn't check"
      status=1
    fi

    # no po file should contain fuzzy msgids, that indicates they haven't been reviewed
    let count=$(fuzzy $po)
		if (( $count > 0 )) ; then
			echo "$po contains $count fuzzy messages"
			status=1
		fi
		# no po file should contain untranslated msgids
    let count=$(untranslated $po)
		if (( $count > 0 )) ; then
			echo "$po contains $count untranslated messages"
			status=1
		fi

		# isutf8 from pkg 'moreutils'; sudo apt-get install moreutils
    if ! isutf8 $po ; then 
				echo "$po is NOT encoded utf8"
				status=1
		fi
		
  done
done

exit $status

