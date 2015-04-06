var http = require('http');
var fs = require('fs');
var express = require('express');
var request = require('request');
app = require('express')(),
http = require('http').Server(app),
io = require('socket.io')(http),
util = require('util'),
fs = require('fs');
http.listen(8111,function (req,res) {
    console.log("Server is listening on Port 8111");
    });

var url = "http://52.10.62.166:8282/InCSE1/AE/CN?from=http:52.10.62.166:10000&requestIdentifier=12345&Content-Type=application/json&Accept=application/json&Authorization=Basic YWRtaW46YWRtaW4=";
request({
    url: url,
    json: true
}, function (error, response,data) {
    //if (!error && response.statusCode === 200)
    //Pull the entire Tree and put it in under a global variable to be accessed by Views
    console.log(JSON.stringify(data)+"------------");
    onGet = JSON.stringify(data.output.ResourceOutput[0].Attributes[3]["attributeValue"]);
    //WebGLObject.xWithoutQuotes = onGet.substring(1, onGet.length - 1);
    //latt = xWithoutQuotes.split(",");
    console.log(onGet);

    //Get/Process and Store Tree HERE to enable page
    
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
        //In case appropriate JSON is recieved it is parsed and written onto a file
        if (decodedText.length) {
            //JSON Parsing
            var store = JSON.parse(decodedText);
            var str2 = JSON.stringify(store.output);
            var wstream = fs.createWriteStream('json1.json');
            //Accessing JSON Elements
            var x = JSON.stringify(store.output.ResourceOutput[0].Attributes[3]["attributeValue"]);
            var xWithoutQuotes = x.substring(1, x.length - 1);
            var lat = xWithoutQuotes.split(",");
            wstream.write(lat[0] + "---");
            wstream.write(lat[1] + "---");
            wstream.write(lat[2] + "---");
            wstream.write(lat[3] + "---");
            console.log("\nlatitude is : " + lat[0] + "\n longitude is: " + lat[1] + "\n device Name: " + lat[2] + "\n device Id: " + lat[3]);
            wstream.end();
        }
        res.end();
        
    });
});