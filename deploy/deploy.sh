#!/bin/bash
# shellcheck disable=SC2086

cd $(dirname "$0")/..

rsync -av --delete \
  --exclude={'.idea','*.iml'} \
  dist/* \
  ${HOST}:~/halo/web/admin/
