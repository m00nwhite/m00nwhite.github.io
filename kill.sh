kill -9 `ps -ef|grep jekyll|grep serve|grep trace|grep -v grep|awk '{print $2}'`

