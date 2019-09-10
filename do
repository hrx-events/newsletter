#!/bin/bash

set -eu

task_deploy() {
  lftp \
    -c " \
      open $DEPLOY_USER:$DEPLOY_PASS@www151.your-server.de; \
      mirror --reverse --verbose --delete newsletter cdn/newsletter; \
      "
}

usage() {
  echo "$0 deploy"
  exit 1
}

cmd="${1:-}"
shift || true
case "$cmd" in
  deploy) task_deploy "$@" ;;
  *) usage ;;
esac
