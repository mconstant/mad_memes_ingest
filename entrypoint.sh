#!/bin/bash

# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

env

echo $GOOGLE_SHEETS_JSON | base64 -d > google_sheets.json

cat google_sheets.json

bundle exec ruby mad_memes_ingest.rb