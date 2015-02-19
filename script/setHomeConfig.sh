#!/usr/bin/sh

symbolicFileArr=".bashrc .inputrc .vim .vimrc .tmux.conf"

for file in ${symbolicFileArr}; do
  /usr/bin/rm -rf ~/${file}
  /usr/bin/ln -s ~/linux_config_script/${file} ~/${file}
done

/usr/bin/rm -rf ~/.vimbak
/usr/bin/mkdir ~/.vimbak
/usr/bin/chmod 700 ~/.vimbak

