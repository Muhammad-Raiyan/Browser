var zmq = require('zeromq');
var publisher = zmq.socket('pub');
var subscriber = zmq.socket('sub');
var synchronizeSubscription = zmq.socket('req');
var synchronizePublisher = zmq.socket("rep");
var page_req = require('request')

const publisherEnvelope = "gui_backend"
const subscriberEnvelope = "network_backend"
const SUBSCRIBERS_EXPECTED = 1;

// Subscription Synchronization
synchronizeSubscription.connect('tcp://localhost:5100')
synchronizeSubscription.send('')

// Publisher synchronization
var subscriberCount = 0;
synchronizePublisher.on('message', function (request) {
    subscriberCount++;
    synchronizePublisher.send('')
    if (subscriberCount >= SUBSCRIBERS_EXPECTED){
        console.log("Publisher Synched")
    }
})


synchronizePublisher.bind('tcp://*:6100', function(err){
    if(err)
        console.log(err)
    else
        console.log('Listening on 6100…')
})


// Bind publisher to port
publisher.bind('tcp://*:6101', function (err) {
    if (err)
        console.log(err)
    else
        console.log("Publishing on 6101...")
})


// Function to handle requests
function handle_request(request) {
    var url = request.url
    var req_token =  request.token
    console.log("Token: " + req_token)
    console.log("url: " + url)  

    if (url.startsWith("www"))
        url = "https://" + url;

    page_req(url, function (error, response, body) {
        if (error) {
            console.log('error:', error);
            publisher.send([publisherEnvelope, error]);
        } else if (response && response.statusCode == 200) {
            console.log('response status', response.statusCode);
            publisher.send([publisherEnvelope, body]);
        } else if (response) {
            console.log('Reponse status not OK:', response.statusCode);
            publisher.send([publisherEnvelope, response.statusMessage]);
        }
    });
}

// Initializing and listening to port
subscriber.on("message", function(request){
    var msg = [];
    Array.prototype.slice.call(arguments).forEach(function (arg) {
        msg.push(arg.toString());
    });

    var request = JSON.parse(msg[1])

    if (request.token === "KILL"){
        close_sockets();
        process.exit();
    } else {
        handle_request(request);
    }
})

subscriber.connect("tcp://localhost:5101");
subscriber.subscribe(subscriberEnvelope);

// Function to close all sockets
function close_sockets(){
    synchronizeSubscription.close()
    console.log('closed sync Subscription ')
    synchronizePublisher.close()
    console.log('closed sync Publisher')
    subscriber.close()
    console.log('Closed subscriber')
    publisher.close()
    console.log('Closed publisher')
}

// On terminate cleanup
process.on('SIGINT', function () {
    close_sockets();
})