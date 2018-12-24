//ZMQ stuff
var zmq = require('zeromq');
var publisher = zmq.socket('pub');
var subscriber = zmq.socket('sub');
var synchronizeSubscription = zmq.socket('req');
var synchronizePublisher = zmq.socket("rep");
const publisherEnvelope = "gui_backend"
const subscriberEnvelope = "render_backend"
const progressEnvelope = "req_progress"
const SUBSCRIBERS_EXPECTED = 2;

// Parser stuff
var parser = require('parse5');
const cheerio = require('cheerio');

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
synchronizeSubscription.connect('tcp://localhost:6100')
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


synchronizePublisher.bind('tcp://*:7100', function(err){
    if(err)
        console.log(err)
    else
        console.log('Listening on 6100…')
})


// Bind publisher to port
publisher.bind('tcp://*:7101', function (err) {
    if (err)
        console.log(err)
    else
        console.log("Publishing on 6101...")
})

subscriber.connect("tcp://localhost:6101");
subscriber.subscribe(subscriberEnvelope);

// Function to handle requests
function render_request(body) {
    var url = request.url
    var req_token =  request.token
    console.log("Token: " + req_token) 

    var document = parser.parse(body);
    var $ = cheerio.load(document)
    $(body).each((i, element)=>{
        default_text_box.item = "text"
        default_text_box.param.text = $(element).text()
        var msg = {
            token: req_token,
            data: default_text_box
        }
        
        publisher.send([publisherEnvelope, JSON.stringify(msg)]);
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
        render_request(request);
    }
})

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