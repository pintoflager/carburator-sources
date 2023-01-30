#!/usr/bin/env bash

### OPTIONAL SCRIPT, DESTROY IF NOT NEEDED ###

# This hook script runs as a root on a remote node during the project
# installation before any changes are made to project files.

# It should handle the logic of keeping revision history larger than 1 revision.
#
# Meaning: carburator saves copy of project dir on node as tar.gz archive on
# project/.revisions/latest.tar.gz
#
# If longer history, for instance 5 revisions are desired this script gets
# invoked: before changes are made AND before copy of the project is taken.

keep_revisions_count=5

# No revisions dir, first round or wiped dir -- nothing to do.
if [[ ! -d .revisions ]]; then
	exit
fi

# Latest revision seems to be in place, extract it's modified timestamp and
# save it with timestamp as it's name.
if [[ -e .revisions/latest.tar.gz ]]; then
	modtime=$(stat -c '%y' .revisions/latest.tar.gz | sed "s|[ :.]|-|g")

	mv -f .revisions/latest.tar.gz ".revisions/$modtime.tar.gz"
fi

# Only keep {x} latest revisions in history.
cd .revisions
c=$((keep_revisions_count + 1))

# List by creation time, take from oldest, run delete
ls -tp | grep -v '/$' | tail -n +"$c" | xargs -I {} rm -rf -- {}

