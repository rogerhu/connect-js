#!/bin/bash  -ex
cd `dirname $0`
TODAY=`date --rfc-3339=date`
JS_OUTPUT="js/all_${TODAY}.js"
if [ ! -d "js"]
then
  mkdir "js"
fi
/usr/bin/wget https://connect.facebook.net/en_US/all.js -O ${JS_OUTPUT}
/usr/bin/python jsbeautifier.py -o all_deminified.js ${JS_OUTPUT}
# Avoid sending out unnecessary updates if only the timestamp has changed.
ALL_JS_DIFF=`git diff --shortstat all_deminified.js | grep -v "1 insertions"`
#ALL_JS_DIFF=`git diff .`
if [ ! -z "$ALL_JS_DIFF" ]                            
then                                                  
  echo "Commit has changed..."                        
  git --no-pager diff . # Just to see what changed...turn off the pager.
  /usr/bin/git add all_deminified.js
  /usr/bin/git commit -m "Facebook Connect changes for $TODAY"
  /usr/bin/git push -f origin
fi                                                    
                                                      
