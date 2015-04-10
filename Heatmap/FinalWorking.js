var http = require('http');
var fs = require('fs');
var express = require('express');
var request = require('request');
app = require('express')(),
http = require('http').Server(app),
io = require('socket.io')(http),
util = require('util'),
fs = require('fs');
var dev,dev2,dev3,url3,dev4;
var changed = 0;
var port = 8119;
http.listen(port,function (req,res) {
    console.log("Server is listening on Port "+port);
});
var url = "http://52.10.62.166:8282/InCSE1/HAE/HCN?from=http:52.10.62.166:10000&requestIdentifier=12345&Content-Type=application/json&Accept=application/json&Authorization=Basic YWRtaW46YWRtaW4=";
request({
    url: url,
    json: true
}, function (error, response,data) {
    //if (!error && response.statusCode === 200)
    //Pull the entire Tree and put it in under a global variable to be accessed by Views
    console.log(url);
    console.log(JSON.stringify(data)+"------------"); 
    dev2 = JSON.stringify(data.output.ResourceOutput[0].Attributes[1]["attributeValue"]);
    //xWithoutQuotes = onGet.substring(1, onGet.length - 1);
    //latt = xWithoutQuotes.split(",");
    //console.log(onGet);
})

app.use(express.static(__dirname));
app.get("/", function (req, res) {
    res.sendFile(__dirname + "/default.html");
});
app.post('/', function(req, res){

    console.log(req.body);
    var body = "";
    req.on('data', function (dt) {
        body += dt;
    });
    req.on('end', function () {
        res.writeHead(200);
        //from URL encoding to text
        var decodedText = decodeURIComponent(body);
        //If a page is loaded onto a browser Parsing is skipped as Page Load is treated as Post
        console.log('POST made:' + decodedText + 'x');
        //sendTime();
        //In case appropriate JSON is recieved it is parsed and written onto a file
        if (decodedText.length) {
            //JSON Parsing
            var store = JSON.parse(decodedText);
            var str2 = JSON.stringify(store.output);
            
            console.log("----------------------STATUS UPDATE : DEVICE MOVED------------------- \n" + str2);
            var wstream = fs.createWriteStream('json1.json');
            changed = 1;
            var path = "http://52.10.62.166:8282/InCSE1/";
            var path2 = "?from=http:52.10.62.166:10000&requestIdentifier=12345&Content-Type=application/json&Accept=application/json&Authorization=Basic YWRtaW46YWRtaW4=";
            var url = "http://52.10.62.166:8282/InCSE1/HAE/HCN/latest?resultContent=10&from=http:52.10.62.166:10000&requestIdentifier=12345&Content-Type=application/json&Accept=application/json&Authorization=Basic YWRtaW46YWRtaW4=";
            //
            var url2;
            request({
                url: url,
                json: true
            }, function (error, response, data) {
                console.log("------INSIDE GET****------" + JSON.stringify(data) );

                dev = JSON.stringify(data.output.ResourceOutput[0].Attributes[1]["attributeValue"]);
                //sendTime();
                console.log("CHECK THIS--------------------------" + dev);
                xWQ = dev.substring(1, dev.length - 1);
                
                url2 = path + 'HAE/HCN/Lat/' + xWQ + path2;
                url3 = path + 'HAE/HCN/Long/' + xWQ + path2;
                //
                request({
                    url: url2,
                    json: true
                }, function (error, response, data) {
                    console.log("------HERE****------" + JSON.stringify(data));
                    console.log(url2);
                    dev3 = JSON.stringify(data.output.ResourceOutput[0].Attributes[5]["attributeValue"]);
                    console.log("LATTTT--------------------------" + dev3);
                    //xWithoutQuotes = onGet.substring(1, onGet.length - 1);
                    //latt = xWithoutQuotes.split(",");
                    //console.log(onGet);
                })
                
                request({
                    url: url3,
                    json: true
                }, function (error, response, data) {
                    console.log("------HERE****------" + JSON.stringify(data));
                    console.log(url3);
                    dev4 = JSON.stringify(data.output.ResourceOutput[0].Attributes[5]["attributeValue"]);
                    sendTime();
                    console.log("LONG--------------------------" + dev4);
                    //xWithoutQuotes = onGet.substring(1, onGet.length - 1);
                    //latt = xWithoutQuotes.split(",");
                    //console.log(onGet);
                })
                //
                //xWithoutQuotes = onGet.substring(1, onGet.length - 1);
                //latt = xWithoutQuotes.split(",");
                //console.log(onGet);
            })
           
            
            //Accessing JSON Elements
            /*var x = JSON.stringify(store.output.ResourceOutput[0].Attributes[3]["attributeValue"]);
            var xWithoutQuotes = x.substring(1, x.length - 1);
            var lat = xWithoutQuotes.split(",");
            wstream.write(lat[0] + "---");
            console.log("\nlatitude is : " + lat[0] + "\n longitude is: " + lat[1] + "\n device Name: " + lat[2] + "\n device Id: " + lat[3]);
            */
                wstream.end();
        }
        res.end();
        //sendTime();
    });
    function sendTime() {
        io.sockets.emit('time', { time: new Date().toJSON() + '\n -------Device Added with Name : ' + dev + '\n With Latitude' + dev3+ '\n and Longitudee' + dev4  });
    }
    setInterval(sendTime, 10000000);
    io.sockets.on('connection', function (socket) {
        socket.emit('welcome', { message: '\n Device Moved Inside container!' + dev2});
        socket.on('client', console.log);
    });
    
});