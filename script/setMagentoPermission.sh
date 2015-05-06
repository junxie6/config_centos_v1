#!/bin/sh

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

magDir="/www/magento1.9.1_us"
srcCtl=".svn .git autorun"

### check if it's running by root

### make sure apache is in dev group
### Usage: isUserInGroup user group
function isUserInGroup {
  # \b is word boundary.
  if id -Gn ${1} | grep &>/dev/null "\b${2}\b"; then
    return 0 # true. exit status code
  fi

  return 1 # false exit status code
}

if ! isUserInGroup apache dev; then
  usermod -a -G dev apache
  systemctl restart httpd.service
  systemctl restart php-fpm.service
fi

### protecting the Magento directories and files
find ${magDir}/ -not -path "*/\.svn*" -and -not -path "*/\.git*" -print0 | xargs -0 -I {} chown dev:dev {}
find ${magDir}/ -not -path "*/\.svn*" -and -not -path "*/\.git*" -type d -print0 | xargs -0 -I {} chmod 750 {}
find ${magDir}/ -not -path "*/\.svn*" -and -not -path "*/\.git*" -type f -print0 | xargs -0 -I {} chmod 640 {}

find ${magDir}/var/ -type d -print0 | xargs -0 -I {} chmod 770 {}
find ${magDir}/var/ -type f -print0 | xargs -0 -I {} chmod 660 {}

find ${magDir}/media/ -type d -print0 | xargs -0 -I {} chmod 770 {}
find ${magDir}/media/ -type f -print0 | xargs -0 -I {} chmod 660 {}

chcon -R -t httpd_sys_content_t ${magDir}/
chcon -R -t httpd_sys_rw_content_t ${magDir}/var/
chcon -R -t httpd_sys_rw_content_t ${magDir}/media/

### sitemap
if [[ -f ${magDir}/media/sitemap.xml ]]; then
  chmod 660 ${magDir}/media/sitemap.xml
  chcon -t httpd_sys_rw_content_t ${magDir}/media/sitemap.xml
fi

### protecting .htaccess files
find ${magDir}/ -name '.htaccess' -type f -print0 | xargs -0 -I {} chmod 640 {}
find ${magDir}/ -name '.htaccess' -type f -print0 | xargs -0 -I {} chcon -t httpd_sys_content_t {}

### protecting the .svn or .git directories
for d in ${srcCtl}; do
  dd=${magDir}/${d}/

  if [[ -d ${dd} ]]; then
    find ${dd} -print0 | xargs -0 -I {} chown dev:wheel {}
    find ${dd} -type f -print0 | xargs -0 -I {} chmod 600 {}
    find ${dd} -type d -print0 | xargs -0 -I {} chmod 700 {}
    
    ### we should add the chon command here
    chcon -R -t user_home_t ${dd}
  fi
done

