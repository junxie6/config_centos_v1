#!/bin/sh

### check if it's running by root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

magDir="/www/drupal8_public"
srcCtl=".svn .git autorun"

### make sure apache is in web group
### Usage: isUserInGroup user group
function isUserInGroup {
  # \b is word boundary.
  if id -Gn ${1} | grep &>/dev/null "\b${2}\b"; then
    return 0 # true. exit status code
  fi

  return 1 # false exit status code
}

if ! isUserInGroup apache web; then
  echo "groupadd web"
  echo "usermod -a -G web apache"
  exit 1
fi

if ! isUserInGroup dev web; then
  echo "groupadd web"
  echo "usermod -a -G web dev"
  exit 1
fi

if ! isUserInGroup php-fpm web; then
  echo "groupadd web"
  echo "usermod -a -G web php-fpm"
  exit 1
fi



