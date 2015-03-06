#!/usr/bin/sh

magDir="/www/magento1.9.1_us"
srcCtl=".svn .git"

### make sure apache is in dev group

### protecting the Magento directories and files
find ${magDir}/ -not -path "*/\.svn*" -and -not -path "*/\.git*" | xargs -I {} chown dev:dev {}
find ${magDir}/ -not -path "*/\.svn*" -and -not -path "*/\.git*" -type d | xargs -I {} chmod 750 {}
find ${magDir}/ -not -path "*/\.svn*" -and -not -path "*/\.git*" -type f | xargs -I {} chmod 640 {}

### protecting the .htaccess file

### protecting the .svn or .git directories
for d in ${srcCtl}; do
  dd=${magDir}/${d}/

  if [[ -d ${dd} ]]; then
    find ${dd} | xargs -I {} chown dev:dev {}
    find ${dd} -type f | xargs -I {} chmod 600 {}
    find ${dd} -type d | xargs -I {} chmod 700 {}
  fi
done

###
chmod g+s ${magDir}/

