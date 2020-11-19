#########################################################
# filename : start.sh
# author   : moonwhite
# version  : v1.0.0
# function : 1. start local jekyll service.
#            2. start chrome to access local test page. 
#            3. start vscode.
#########################################################

nohup bundle exec jekyll serve --trace 1 > /dev/null 2>&1 &
sleep 2
open -a "/Applications/Google Chrome.app" 'http://127.0.0.1:4000/'
code -r .



