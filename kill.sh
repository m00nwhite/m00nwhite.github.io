#########################################################
# filename : kill.sh
# author   : moonwhite
# version  : v1.0.0
# function : stop local jekyll service
#########################################################

kill -9 `ps -ef|grep jekyll|grep serve|grep trace|grep -v grep|awk '{print $2}'`

