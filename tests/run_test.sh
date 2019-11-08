#!/bin/bash
# This scripts sends message to the redis-application server hearing in $SERVER:$PORT and validates that it's behaving correctly.
SERVER="$1"
PORT="$2"

if [ -z "$SERVER" ]; then
    SERVER="localhost"
fi

if [ -z "$PORT" ]; then
    PORT="5000"
fi

CONNECTION="$SERVER:$PORT"

echo "Running tests to server $SERVER on port $PORT"

WAITING=0
WORKING=0
for i in {1..10}; do
    sleep 1
    echo "Atempting to connect to NodeJS ($i/10)..."
    curl "$CONNECTION" &> /dev/null
    if [ "$?" -eq "0" ]; then
        WORKING=1
        break
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
    RES=`curl "$CONNECTION" 2> /dev/null`
    if [[ "$RES" != "$EXPECT" ]]; then
        echo "ERROR!: got $RES"
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
