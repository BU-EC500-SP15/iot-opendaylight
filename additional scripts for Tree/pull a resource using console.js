var http = require('http');

//http://52.10.62.166:8282/InCSE1/LocationAE?from=http:52.10.62.166:10000&requestIdentifier=12345&Content-Type=application/json&Accept=application/json
var xpath,store,str2;
process.argv.forEach(function (val, index, array) {
        if (index < 2) {
        }
        else {
            console.log(index + ': ' + val);
            xpath = val
        }
    });
var options = {
    
  host: '52.10.62.166',
  port: 8282,
  path: '/InCSE1/'+xpath+'?from=http:52.10.62.166:10000&requestIdentifier=12345&Content-Type=application/json&Accept=application/json'  
//path: '/InCSE1/LocationAE?from=http:52.10.62.166:10000&requestIdentifier=12345&Content-Type=application/json&Accept=application/json'
};
callback = function(response) {
  var str = '';

  response.on('data', function (dt) {
    str += dt;   
    store = JSON.parse(str);
    str2 = JSON.stringify(store.output)
  });

  response.on('end', function () {
    console.log(str);
    console.log("-----------------Here is the PARSED OUTPUT for "+xpath+" :------------");
    console.log(store);
    console.log('\n'+"-----------------Response Status :------------");
    console.log(JSON.stringify(store.output.responseStatusCode)); 
    console.log('\n'+"-----------------Resource Output :------------");   
    console.log('\n'+"1-----Resource Type :------------");
   console.log(JSON.stringify(store.output.ResourceOutput[0]["resourceType"]));
   console.log('\n'+"2-----Resource ID :------------");
   console.log(JSON.stringify(store.output.ResourceOutput[0]["resourceID"]));
   console.log('\n'+"3-----Resource Attributes :------------");
   console.log(JSON.stringify(store.output.ResourceOutput[0]["Attributes"]));
   console.log('\n' + "3-----Resource AttributesNNNNNN :------------");

   console.log(JSON.stringify(store.output.ResourceOutput[0].Attributes[0]));

  });
}
http.request(options, callback).end();