var zmq = require('zeromq')
var publisher = zmq.socket('pub');
var synchronizePublisher = zmq.socket("rep");

const publisherEnvelope = "gui_backend"

// Publisher synchronization
var subscriberCount = 0;
synchronizePublisher.on('message', function (request) {
    subscriberCount++;
    synchronizePublisher.send('')
    if (subscriberCount >= SUBSCRIBERS_EXPECTED){
        console.log("Publisher Synched")
        console.log("Sent")
        publisher.send([publisherEnvelope, "Hello"])
    }
})

synchronizePublisher.bind('tcp://*:7100', function(err){
    if(err)
        console.log(err)
    else
        console.log('Listening on 7100…')
})

// Bind publisher to port
publisher.bind('tcp://*:7101', function (err) {
    if (err)
        console.log(err)
    else
        console.log("Publishing on 7101...")
})

