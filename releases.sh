#!/bin/bash
red=$'\e[0;101m'
white=$'\e[0m'


tag_release () {

  type=''

  if [ -z "$1" ] || [ "$1" = 'patch' ]; then
    type='patch'
  fi

  if [ "$1" = 'minor' ]; then
    type='minor'
  fi

  if [ "$1" = 'major' ]; then
    type='major'
  fi

  if [ "$1" = 'feature' ]; then
    type='prerelease --preid=rc'
  fi

  # Get all of the tags from upstream and set the package.json file version
  # to match the latest release tag. This is an important first step to help
  # normalise the process from this point on. It also ensures that users
  # always use the latest tag.
  git fetch --tags upstream
  latestVersion="$(git tag | tail -1)"
  npm version $latestVersion --allow-same-version -m "Updating pagckage.json to %s";

  # Create a new tag based on the type users select and update the package.json
  # file. This tag is not automatically pushed.
  newVersion="$(npm version $type)";
  git tag -a "${newVersion}";
  printf "\n";
  echo "New tag created: $red ${newVersion} $white";
  echo "Remember to push it";
  printf "\n";
}
