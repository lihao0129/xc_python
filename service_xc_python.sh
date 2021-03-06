#!/usr/bin/env bash

# pre-defined Action OPTS and regex to match one of the OPTS
OPTS=(build build-run up down start stop)
regex=$(IFS=\|;echo "${OPTS[*]}")

# usage
USAGE="Usage:

    $0 [-h|-d folder] <$regex> [SERVICE..]
"

# shared folder to save working codes
SHARED=~/my_code

# process the command options
while getopts "hd:" opt; do
  case $opt in
    h)
      echo "$USAGE"; exit 0
      ;;
    d)
      SHARED=$2
      ;;
  esac
done
shift $((OPTIND-1))

# action must be one of the pre-defined OPTS
# export environments when build and run the applications
[[ $1 =~ ^$regex$ ]] || { echo "$USAGE"; exit; }

if [[ $1 =~ ^(up|build) ]]; then
    # SHARED folder supplied by -d argument or default to '$HOME/my_code'
    [[ -d "$SHARED" ]] || { echo "the folder '$SHARED' does not exist"; exit 1; }
    export SHARED

    # set username, user_uid and user_gid the same as the owner of the SHARED folder
    export USER=$(stat -c "%U" "$SHARED")
    export USER_UID=$(stat -c "%u" "$SHARED")
    export USER_GID=$(stat -c "%g" "$SHARED")

    # setup container xauth cookie and DISPLAY based on login
    ./xauth.init.sh

fi

# wrapper for docker-compose command with required environments for the services
case $1 in
  up)
    docker-compose up -d "${@:2}"
    ;;
  start)
    docker-compose start "${@:2}"
    ;;
  build-run)
    docker-compose up -d --build "${@:2}"
    ;;
  build)
    docker-compose build --force-rm "${@:2}"
    ;;
  down)
    docker-compose down --remove-orphans 
    ;;
  stop)
    docker-compose stop "${@:2}"
    ;;
  *)
    echo "$USAGE"
    exit 1
    ;;
esac

