#!/bin/sh


### check if it's running by root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

druDir="/www/drupal8_public"
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

### basic setting for the directories and files.
find ${druDir}/ -not -path "*/\.svn" -and -not -path "*/\.git" -print0 | xargs -0 -I {} chown dev:web {}
find ${druDir}/ -not -path "*/\.svn" -and -not -path "*/\.git" -print0 | xargs -0 -I {} chcon -t httpd_sys_content_t {}

find ${druDir}/ -not -path "*/\.svn" -and -not -path "*/\.git" -type d -print0 | xargs -0 -I {} chmod 2750 {}
find ${druDir}/ -not -path "*/\.svn" -and -not -path "*/\.git" -type f -print0 | xargs -0 -I {} chmod 640 {}

### sites/*/files and settings.php
find ${druDir}/sites/ -mindepth 1 -maxdepth 1 -type d -not -path ${druDir}/sites/default | while read line; do
  if [[ -d ${line} ]]; then
    ### files
    find ${line}/files/ -print0 | xargs -0 -I {} chown php-fpm:web {}
    find ${line}/files/ -print0 | xargs -0 -I {} chcon -t httpd_sys_rw_content_t {}

    find ${line}/files/ -type d -print0 | xargs -0 -I {} chmod 2770 {}
    find ${line}/files/ -type f -print0 | xargs -0 -I {} chmod 660 {}

    ### settings.php
    /bin/chown dev:web ${line}/settings.php
    /bin/chcon -t httpd_sys_content_t ${line}/settings.php
    /bin/chmod 440 ${line}/settings.php
  fi
done

### for the .htaccess files within maxdepth 2
find ${druDir}/ -maxdepth 2 -type f -name '.htaccess' -print0 | xargs -0 -I {} chown dev:web {}
find ${druDir}/ -maxdepth 2 -type f -name '.htaccess' -print0 | xargs -0 -I {} chcon -t httpd_sys_content_t {}
                                                     
find ${druDir}/ -maxdepth 2 -type f -name '.htaccess' -print0 | xargs -0 -I {} chmod 644 {}

### for the .svn and .git directories.
for d in ${srcCtl}; do
  dd=${druDir}/${d}

  if [[ -d ${dd} ]]; then
    find ${dd}/ -print0 | xargs -0 -I {} chown dev:web {}
    find ${dd}/ -print0 | xargs -0 -I {} chcon -t httpd_sys_content_t {}

    find ${dd}/ -type d -print0 | xargs -0 -I {} chmod 2700 {}
    find ${dd}/ -type f -print0 | xargs -0 -I {} chmod 600 {}
  fi
done

