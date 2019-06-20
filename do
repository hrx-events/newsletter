#!/bin/bash

set -eu

task_deploy() {
  local user="${1:-deploy-think-about-cdn}"

  rsync \
    -ruvc \
    --delete \
    newsletter \
    "${user}@turing.holderbaum.me:www/"
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
