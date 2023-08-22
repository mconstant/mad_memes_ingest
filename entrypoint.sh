#!/bin/bash

# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

GOOGLE_REFRESH_TOKEN=$(oauth2l fetch --scope https://www.googleapis.com/auth/drive --clientid $GOOGLE_CLIENT_ID --clientsecret $GOOGLE_CLIENT_SECRET)

export GOOGLE_REFRESH_TOKEN

bundle exec ruby mad_memes_ingest.rb