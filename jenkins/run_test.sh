#!/bin/bash
# This scripts sends message to the redis-application server hearing in $SERVER:$PORT and validates that it's behaving correctly.
SERVER="$1"
PORT="$2"

if [ -z "$SERVER" ]; then
    SERVER="localhost"
fi

if [ -z "$PORT" ]; then
    PORT="80"
fi

CONNECTION="$SERVER:$PORT"

echo "Running tests to server $SERVER on port $PORT"

WAITING=0
WORKING=0
for i in {1..10}; do
    sleep 2
    echo -n "Atempting to connect to NodeJS ($i/10)..."
    RESPONSE=`curl -i "$CONNECTION" 2> /dev/null`
    RESULT="$?"
    STATUS=`echo $RESPONSE | grep HTTP | cut -d " " -f 2`
    #echo "RESPONSE: $RESPONSE"
    #echo "STATUS: $STATUS - RESULT: $RESULT"
    if [[ "$RESULT" == "0"  && "$STATUS" == "200" ]]; then
        WORKING=1
        echo "OK"
        break
    else
        echo "Failed (Status: $STATUS, Result: $RESULT)"
    fi 
done

if [ "$WORKING" -eq "0" ]; then
    echo "Timeout to connect to Redis application"
    exit 1
fi

echo "Connection established to NodeJS server"
send_to_queue() {
    MESSAGE="$1"
    echo "Sending $MESSAGE to queue..."
    curl "$CONNECTION" -XPOST -d"msg=$MESSAGE" &> /dev/null
}

assert_get_from_queue() {
    EXPECT="$1"
    echo -n "Testing if queue returns $EXPECT..."
    RESPONSE=`curl "$CONNECTION" 2> /dev/null`
    if [[ "$RESPONSE" != "$EXPECT" ]]; then
        echo "ERROR!: got $RESPONSE"
        exit 1
    fi
    echo "OK"
}

assert_get_from_queue "No messages in queue"
send_to_queue "Nacho"
assert_get_from_queue "Nacho"
assert_get_from_queue "No messages in queue"
send_to_queue "Marce"
send_to_queue "Roy"
send_to_queue "Dami"
send_to_queue "Facu"
send_to_queue "Jona"
assert_get_from_queue "Marce"
assert_get_from_queue "Roy"
assert_get_from_queue "Dami"
assert_get_from_queue "Facu"
assert_get_from_queue "Jona"
assert_get_from_queue "No messages in queue"
echo "All tests finished sucessfully"
exit 0
