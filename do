#!/bin/bash

set -eu

ensure_ruby() {
  export LANG=C.UTF-8
  local bundler_version
  bundler_version="$(tail -n1 Gemfile.lock |tr -d ' ')"
  if ! gem list -q bundler |grep -q "$bundler_version" >/dev/null;
  then
    export BUNDLER_VERSION=2.0.1
    gem install "bundler:$bundler_version"
  fi
  bundle install --path vendor/bundle --binstubs vendor/bin
}

task_serve() {
  ensure_ruby

  local port="${1:-7070}"
  ./vendor/bin/middleman serve -p "$port" --bind-address=127.0.0.1
}

task_build() {
  ensure_ruby

  ./vendor/bin/middleman build
}

task_deploy() {
  lftp \
    -c " \
      open $DEPLOY_USER:$DEPLOY_PASS@www151.your-server.de; \
      mirror --reverse --verbose --delete newsletter cdn/newsletter; \
      "
}

usage() {
  echo "$0 serve | build | deploy"
  exit 1
}

cmd="${1:-}"
shift || true
case "$cmd" in
  serve) task_serve "$@" ;;
  build) task_build "$@" ;;
  deploy) task_deploy "$@" ;;
  *) usage ;;
esac
