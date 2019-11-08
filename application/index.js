// Import express and bodyParser (used for implementing the web server)
let express = require('express');
let bodyParser = require("body-parser");

// Import Redis (to communicate messages)
let redis = require('redis');

// Initialize the web-server and the Redis client connection.
let app = express();
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

let client = redis.createClient({
    host: "localhost",
    port: 6379
});

// Post requests push messages into the queue.
app.post('/', (req, res) => {
    console.log('pushing ' + req.body.msg);
    client.lpush('message_queue', req.body.msg, function(err, push_resp) {
        if(err) {
            console.log('push error');
            return;
        }

        console.log('push returned ' + push_resp);
        res.sendStatus(200);
    });
});

// Get requests pop messages from the queue.
app.get('/', (req, res) => {
    console.log('popping from queue');
    client.rpop('message_queue', function(err, message) {
        if(err) {
            console.log('pop error');
            return;
        }
        console.log('pop returned ' + message);

        res.send(message != null ? message : "No messages in queue");
    });
});

// Launch the application to listen on port 8080
app.listen(8081, function () {
    console.log("Listening on port 8081");
});
