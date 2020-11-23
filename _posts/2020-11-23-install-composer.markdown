---
layout: post
title:  "Composer安装"
date:   2020-11-23 14:10:02 +0800
categories: php web
---

可以复制如下脚本保存并本地执行，用来下载composer.phar文件
```bash
#!/bin/sh

EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
exit $RESULT
```

执行
```bash
chmod a+x install.sh
./install.sh 
```

执行之后会看到本地目录下载好了`composer.phar`, 
然后执行`mv composer.phar /usr/local/bin/composer` 使得composer可以在任意目录使用，这样就安装完成了。

敲入`composer`命令，或者`composer -V`来确认composer是否安装成功。


