//ZMQ stuff
var zmq = require('zeromq');
var publisher = zmq.socket('pub');
var subscriber = zmq.socket('sub');
var synchronizeSubscription = zmq.socket('req');
var synchronizePublisher = zmq.socket("rep");
const publisherEnvelope = "render_backend"
const subscriberEnvelope = "network_backend"
const progressEnvelope = "req_progress"
const SUBSCRIBERS_EXPECTED = 1;

// Network stuff
var page_req = require('request')
var progress = require('request-progress')

const default_text_box = {
    type: "render",
    item: "text-box",
    param: {
      anchor_left: 0.0,
      anchor_right: 1.0,
      anchor_top: 0.0,
      anchor_bottom: 1.0,
      text: ""
  }
}     

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


synchronizePublisher.bind('tcp://*7100', function(err){
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

    // https://www.york.ac.uk/teaching/cws/wws/webpage1.html
    // Making the request for the page.
    progress( page_req(url, function (error, response, body) {
        if (error) {
            console.log('error:', error);
            publisher.send([publisherEnvelope, error]);
        } else if (response && response.statusCode == 200) {
            console.log('response status', response.statusCode);
            publisher.send([publisherEnvelope, JSON.stringify(body)]);
        } else if (response) {
            console.log('Reponse status not OK:', response.statusCode);
            publisher.send([publisherEnvelope, response.statusMessage]);
        }
    })).on('progress', function (state) {
        // Object to store necessary information.
        var stats = {
            percent: 0,
            bytes: 0
        };

        if (state.percent)
            stats.percent = state.percent;

        if (state.size.transferred)
            stats.bytes = state.size.transferred;

        console.log(JSON.stringify(stats))
        //publisher.send([progressEnvelope, JSON.stringify(stats)])

    })
    
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