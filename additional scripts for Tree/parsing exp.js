var http = require('http');
var postResponse =
  '<html><head><title>ODl For Post</title></head>' +
  '<body>' +
  '<form method="post">' +
  'POST Recieved: <input name="postmsg"><br>'+
  '</form>' +
  '</body></html>';
var fs = require('fs');

http.createServer(function (req, res) {
    var body = "";
    req.on('data', function (dt) {
        body += dt;
    });
    req.on('end', function () {
       res.writeHead(200);  
      //var decodedText = decodeURIComponent(body);
        console.log('POST made: ' + body);
        var store = JSON.parse(body);
        var str2 = JSON.stringify(store.output);
        var str3 = JSON.stringify(store.output.ResourceOutput[0]["attributeValue"]);
        var wstream = fs.createWriteStream('json1.json');
        wstream.write(str2 + '\nJSONObject');
        wstream.write('---------\n'+str3);
        wstream.end();
        res.end(postResponse);
    });


}).listen(8111);
/* NodeJS Server
var http = require('http');
var API = "http://admin:admin@52.10.62.166:8282/InCSE1/LocationAE/Things?requestIdentifier=12345&Content-Type=application/json&Accept=application/json&from=http:localhost:10000/callback=foo";
const PORT=8080; 

//We need a function which handles requests and send response
function handleRequest(request, response)
{
    response.end('It Works!! Path Hit: ' + request.url);
}

//Create a server
var server = http.createServer(handleRequest);

//Lets start our server
server.listen(PORT, function(){
    //Callback triggered when server is successfully listening. Hurray!
    console.log("Server listening on: http://localhost:%s", PORT);
 
});
     
 
var http = require('http');
var postHTML = 
  '<html><head><title>Post Example</title></head>' +
  '<body>' +
  '<form method="post">' +
  'Input 1: <input name="input1"><br>' +
  'Input 2: <input name="input2"><br>' +
  '<input type="submit">' +
  '</form>' +
  '</body></html>';

http.createServer(function (req, res) {
    var body = "";
    req.on('data', function (chunk) {
        body += chunk;
    });
    req.on('end', function () {
        console.log('POSTed: ' + body);
        res.writeHead(200);
        res.end(postHTML);
    });
}).listen(8080);
<!--
<!DOCTYPE html>
<html>
<body>

<div id="id01"></div>

<script>
    var xmlhttp = new XMLHttpRequest();
var url = "http://admin:admin@52.10.62.166:8282/InCSE1/LocationAE?requestIdentifier=12345&Content-Type=application/json&Accept=application/json&from=http:localhost:10000/callback=foo";

xmlhttp.onreadystatechange = function () {
    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        var myArr = JSON.parse(xmlhttp.responseText);
        myFunction(myArr);
    }
}
xmlhttp.open("GET", url, true);
xmlhttp.send();

function myFunction(arr) {
    var out = "";
    var i;
    for (i = 0; i < arr.length; i++) {
        out += '<a href="' + arr[i].url + '">' +
        arr[i].display + '</a><br>';
    }
    document.getElementById("id01").innerHTML = out;
}
</script>

</body>
</html>-->
*/