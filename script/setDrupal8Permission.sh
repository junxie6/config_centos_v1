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

### sites
find ${druDir}/sites/ -mindepth 1 -maxdepth 1 -type d -not -path "sites/default" | while read line; do
  dd=${druDir}/${line}

  find ${dd}/files/ -type d -print0 | xargs -0 -I {} chmod 2770 {}
  find ${dd}/files/ -type f -print0 | xargs -0 -I {} chmod 660 {}
  find ${dd}/files/ -print0 | xargs -0 -I {} chcon -t httpd_sys_rw_content_t {}

  /bin/chmod 640 ${dd}/settings.php
  /bin/chcon -t httpd_sys_content_t ${dd}/settings.php
done

### for the .htaccess files
find ${druDir}/ -name '.htaccess' -type f -print0 | xargs -0 -I {} chown dev:dev {}
find ${druDir}/ -name '.htaccess' -type f -print0 | xargs -0 -I {} chmod 644 {}
find ${druDir}/ -name '.htaccess' -type f -print0 | xargs -0 -I {} chcon -t httpd_sys_content_t {}

### for the .svn and .git directories.
for d in ${srcCtl}; do
  dd=${druDir}/${d}/

  if [[ -d ${dd} ]]; then
    find ${dd} -print0 | xargs -0 -I {} chown dev:dev {}
    find ${dd} -type f -print0 | xargs -0 -I {} chmod 600 {}
    find ${dd} -type d -print0 | xargs -0 -I {} chmod 0000 {}
    find ${dd} -type d -print0 | xargs -0 -I {} chmod 700 {}
    
    ### we should add the chon command here
    ### Disabled: because when I "svn update", the SELinux security context permission would become "user_home_t" instead of "httpd_sys_content_t".
    #chcon -R -t user_home_t ${dd}
  fi
done

