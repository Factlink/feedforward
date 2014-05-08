#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
. bin/kill-descendants-on-exit.sh

(bundle exec thin start || kill $$)  2>&1| perl -pe "s/^/\x1b[0;32m[webserver] \x1b[0m/" &
wait
