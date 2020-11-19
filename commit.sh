#########################################################
# filename : commit.sh
# author   : moonwhite
# version  : v1.0.0
# function : 1. Get current date and time.
#            2. commit and push to github. 
#########################################################

dt=`date +'%Y%m%d-%H%M%S'`

git add .
git commit -m "dt"
git push

