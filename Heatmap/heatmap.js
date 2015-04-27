/*

***BEFORE YOU START:

**List of REQUIRED modules: 
bodyparser,
socket,
request
Please type in "npm install module_name" without quotes in your terminal to install required modules to run this script.

**RUN this using:
node heatmap.js

**NodeJS script

*/
var request =   require('request');
var app     =   require('express')();
var http    =   require('http').Server(app);
var io      =   require('socket.io')(http);

var PORT = 8119;         //nodejs listens @ PORT#

//devices array of objects has each object as : {device_UUID,acc_flag,x,y,creationTime,IN/OUT}
//each object is an array in itself
//e.g. devices[0] may return [UUID , 100, 42.1111111, -67.2222222]
//x : latitude  (in case of CMX,GPS) and co-ordinate(in case of iBeacons)
//y : longitude (in case of CMX,GPS) and co-ordinate(in case of iBeacons)


var devices = [];           //All devices
var iBeacons    = [];       //iBeacons location and other info
var devicesiB   = [];       //Devices under iBeacons Monitoring
var devicesCMX  = [];       //Devices under CMX Monitoring
var devicesGPS  = [];       //Devices under GPS Monitoring
var devicePaths = [];       //Devices paths for initial GET
var isUpdate;
updated = [];              //keeps track of updates/notifications on location change or device addition

var IP = "52.10.62.166"; //karaf is running @ ip#
var karafPORT = "8282";  //karaf listens @ karafPORT#  
var urlParameters = "?from=http:52.10.62.166:10000&requestIdentifier=12345&Content-Type=application/json&Accept=application/json";

var i;
//  Start the server on PORT#
http.listen(PORT, function (req, res) {
    console.log("Server is listening on Port " + PORT);
});

/*  
    Handling HTTP GET from a source onto NodeJS server 
    Starts with our Outdoor Map 
    See code: outdoorMap.html
*/

app.get("/", function (req, res) {
    res.sendFile(__dirname + "/outdoorMap.html");
});

/*

Issue a HTTP GET request on ODL datastore with resultContent=5 to get the list of all devices currently under location Monitoring

Data in ODL Tree is structured as:

LocationAE->Things->MAC1,MAC2...

The request below will get the list of MAC/s

*/

var GetAllUrl = "http://" + IP + ":" + karafPORT + "/InCSE1/LocationAE/Things" + urlParameters + "&resultContent=5";

request({
    url: GetAllUrl,
    json: true,
    Authorization: "Basic YWRtaW46YWRtaW4="
}, function (error, response, data) {

    console.log("GEETING DATA FROM:-" + GetAllUrl);
   
    if (data) {

        //debug: remove HERE
        console.log(JSON.stringify(data));

  
        //atttribute 10 contains all the device paths
        devicePaths = JSON.stringify(data.output.ResourceOutput[0].Attributes[8]["attributeValue"]);
        console.log(devicePaths);

        //removing quotes from attributeValue
        var withoutQuotes = devicePaths.substring(1, devicePaths.length - 2);

        //splitting each path by comma
        devicePaths = withoutQuotes.split(",");


        for (i = 0; i < devicePaths.length; i++) {

            //removing the array brackets & spaces(first characters)
            devicePaths[i] = devicePaths[i].substring(1);

            console.log("\n URL GRABBED for Device " + i + " : " + devicePaths[i]);

            var relPath = devicePaths[i];
            console.log(relPath);
            var eachPath = "http://" + IP + ":" + karafPORT + "/" + relPath + "/AccuracyFlag" + urlParameters;
            requestAccFlag(relPath, eachPath,0);
            for (var key in devices) {
                console.log("HERE" + devices[key]);
            }
           
            /*
                Now for each path/device grabbed, we loop through each path and issue HTTP GET requests to grab and check Accuracy
                flag and then gather required data by another GET request at appropriate URL {UUId,Name,X,Y}
            */
            //}
        }
    }
    else {
        console.log("Error connecting to server : " + JSON.stringify(response));
    }
    //raw for each device check accuracy flag and put it in deviceib device cmx etc
});

/*

Function requestAccFlag
Input Parameters : path to get the flag from
This function checks the Accuracy Flag on device and invokes requestLocationData function on it to get the location Data

*/
function requestAccFlag(relPath,eachPath, isUpdated) {
    request({
        url: eachPath,
        json: true,
        async: false,
        Authorization: "Basic YWRtaW46YWRtaW4="

    }, function (error, response, data) {
        //first check the accuracy flag for the current device
        var accFlag = JSON.stringify(data.output.ResourceOutput[0].Attributes[3]["attributeValue"]);
        console.log(accFlag);

        /* Accuracy Flag is set : 
            xx1 iBeacon
            x1x CMX
            1xx GPS
        */
        //if iBeacon is set, requestLocation is called with param 0 for LocBeacon
        if (accFlag[1] == '1') {

            //look for Location under ../../UUID/LocBeacon container : 1
            console.log("1");
            requestLocation(1, relPath, isUpdated);
        }

            //if iBeacon is not set/recieving look under LocCMX
        else if (accFlag[1] != '1') {

            if (accFlag[2] == '1') {

                //look for Location under ../../UUID/LocCMX container : 2
                console.log("2");
                requestLocation(2, relPath, isUpdated);
            }

                //if neither iBeacon nor CMX is recieving location
            else if (accFlag[2] != '1') {

                //look for Location under ../../UUID/LocGPS container : 3
                if (accFlag[3] == '1') {

                    console.log("3");
                    requestLocation(3, relPath, isUpdated);

                }

                    //if none is recieving updates on location
                else if (accFlag[3] != '1') {

                    //change x,y to 0,0 : Error Code
                    
                    console.log("4");
                    dev_x = 0;
                    dev_y = 0;

                }
            }
        }
        
        //debug : uncomment this to examine path
        //console.log("---URL FOR DEVICE---" devicePaths[i]);
     })
}

/*
function Location data:
input parameters : Identifier(0: LocBeacon, 1:LocCMX, 2:LocGPS) and Device Path
returns          : locData
function LocatinoData when called returns device UUID,X,Y,TimeStamp by issuing a GET
*/
function requestLocation(LocId, treePath, isUpdated) {
  
    console.log(LocId, treePath);
    //if location data is under LocBeacon
    if (LocId == 1) {
        request({
            async:false,
            url: "http://" + IP + ":" + karafPORT + "/" + treePath + "/LocBeacon/latest" + urlParameters + "&resultContent=6",
            json: true,
            Authorization: "Basic YWRtaW46YWRtaW4="

        }, function (error, response, data) {

            //grabbing device's UUID
            var attr1 = JSON.stringify(data.output.ResourceOutput[0].Attributes[5]["attributeValue"]);
            attr1 = attr1.split("/");

            var dev_UUID = attr1[3];
            console.log("\n GOT DEVICE DATA FOR---" + dev_UUID);

            //grabbing device's X Co-ordinate/Latitude
            var dev_x;
            var attr2 = JSON.stringify(data.output.ResourceOutput[0].Attributes[7]["attributeValue"]);
            attr2 = attr2.substring(1,attr2.length-1);
            attr2 = attr2.split(",");

            dev_x = attr2[0];

            //grabbing device's Y Co-ordinate/Longitude
            var dev_y;
            dev_y = attr2[1];

            //grabbing timestamp of updated location/content creation Time
            var last_updated = JSON.stringify(data.output.ResourceOutput[0].Attributes[4]["attributeValue"]);;
            console.log("\n RAW DATA: \n" + JSON.stringify(data));
            //devices.push([dev_UUID, dev_x, dev_y, last_updated, "INOUT"]);

            if (isUpdated != 2) {
                devices.push([dev_UUID, dev_x, dev_y, last_updated, "INOUT"]);
            }
            else if (isUpdated == 2) {
                for (var key in devices) {

                    //if UUID match is found, add to the array of locations
                    if (devices[key][0] == dev_UUID) {
                        updated[key][1].push(dev_x);
                        updated[key][2].push(dev_y);
                        updated[key][3].push(last_updated);
                        updated[key][4].push("INOUT");
                    }
                }
            }
        })
    }
    else if (LocId == 2) {
        request({

            async: false,
            url: "http://" + IP + ":" + karafPORT + "/" + treePath + '/LocCMX/latest' + urlParameters + '&resultContent=6',
            json: true,
            Authorization: "Basic YWRtaW46YWRtaW4="

        }, function (error, response, data) {

            //grabbing device's UUID
            var attr1 = JSON.stringify(data.output.ResourceOutput[0].Attributes[5]["attributeValue"]);
            attr1 = attr1.split("/");
            var dev_UUID = attr1[3];
            console.log("\n GOT DEVICE DATA FOR---" + dev_UUID);

            //grabbing device's X Co-ordinate/Latitude
            var dev_x;
            var attr2 = JSON.stringify(data.output.ResourceOutput[0].Attributes[7]["attributeValue"]);
            attr2 = attr2.substring(1, attr2.length - 1);
            attr2 = attr2.split(",");

            dev_x = attr2[0];

            //grabbing device's Y Co-ordinate/Longitude
            var dev_y;
            dev_y = attr2[1];

            //grabbing timestamp of updated location/content creation Time
            var last_updated = JSON.stringify(data.output.ResourceOutput[0].Attributes[4]["attributeValue"]);;
            console.log("\n RAW DATA: \n" + JSON.stringify(data));

            if (isUpdated != 2) {
                devices.push([dev_UUID, dev_x, dev_y, last_updated, "INOUT"]);
            }
            else if (isUpdated == 2) {
                for (var key in devices) {

                    //if UUID match is found, add to the array of locations
                    if (devices[key][0] == dev_UUID) {
                        updated[key][1].push(dev_x);
                        updated[key][2].push(dev_y);
                        updated[key][3].push(last_updated);
                        updated[key][4].push("INOUT");
                    }
                }
            }
        })
    }

    //perfrom a GET Request on LocGPS if device is under LocGPS
    else if (LocId == 3) {
        request({

            async:false,
            url: "http://" + IP + ":" + karafPORT + "/" + treePath + '/LocGPS/latest' + urlParameters + '&resultContent=6',
            json: true,
            Authorization: "Basic YWRtaW46YWRtaW4="

        }, function (error, response, data) {

            //grabbing device's UUID
            var attr1 = JSON.stringify(data.output.ResourceOutput[0].Attributes[5]["attributeValue"]);
            attr1 = attr1.split("/");
            var dev_UUID = attr1[3];

            console.log("\n GOT DEVICE DATA FOR---" + dev_UUID);

            //grabbing device's X Co-ordinate/Latitude
            var dev_x;
            var attr2 = JSON.stringify(data.output.ResourceOutput[0].Attributes[7]["attributeValue"]);
            attr2 = attr2.substring(1, attr2.length - 1);
            attr2 = attr2.split(",");

            dev_x = attr2[0];
            
            //grabbing device's Y Co-ordinate/Longitude
            var dev_y;
            dev_y = attr2[1];

            //grabbing timestamp of updated location/content creation Time
            var last_updated = JSON.stringify(data.output.ResourceOutput[0].Attributes[4]["attributeValue"]);;
            console.log("\n RAW DATA: \n" + JSON.stringify(data));

            //devices.push([dev_UUID, dev_x, dev_y, last_updated,"OUT"]);
            if (isUpdated != 2) {
                devices.push([dev_UUID, dev_x, dev_y, last_updated, "OUT"]);
            }
            else if (isUpdated == 2) {
                for (var key in devices) {

                    //if UUID match is found, add to the array of locations
                    if (devices[key][0] == dev_UUID) {
                        updated[key][1].push(dev_x);
                        updated[key][2].push(dev_y);
                        updated[key][3].push(last_updated);
                        updated[key][4].push("OUT");
                    }
                }
            }
        })
        
    }

    //If device has left/logged out already
    else if (LocId = 4) {
        request({

            async: false,
            url: "http://" + IP + ":" + karafPORT + "/" + treePath + '/LocGPS/latest' + urlParameters + '&resultContent=6',
            json: true,
            Authorization: "Basic YWRtaW46YWRtaW4="

        }, function (error, response, data) {

            //grabbing device's UUID
            var attr1 = JSON.stringify(data.output.ResourceOutput[0].Attributes[7]["attributeValue"]);
            attr1 = attr1.split("/");
            var dev_UUID = attr1[3];

            console.log("\n DEVICE LEFT!---" + dev_UUID);

            //check devices array for matching UUID
            for (var key in devices) {

                //if UUID match is found
                if (devices[key][0] == dev_UUID) {

                    //splice the array starting from the current index for/uptil 1 element
                    devices.splice(key, 1);
                    updated.splice(key, 1);
                }
            }
            console.log("\n RAW DATA: \n" + JSON.stringify(data));

        })
    }
}

function sendUpdate() {
   // io.sockets.emit('updatedDev', {updatedDev:updated});
}

results = [];

io.sockets.on('connection', function (socket) {
    socket.on('client', console.log);
    //debug uncomment HERE
    query = '';
    socket.emit('welcome', { message: '\n Connection Established with the Server!' });
    //uncomment HERE SUNDAY
    socket.emit('allDevices', { devices: devices });

 //   sendUpdate();
    socket.on('search', function (data) {

        query = data.query;
        console.log("searching");
        var queryUrl = "http://" + IP + ":" + karafPORT + "/InCSE1/UserAE/" + data.query + urlParameters + "&resultContent=6";

        request({
            url: queryUrl,
            json: true,
            async:false,
            Authorization: "Basic YWRtaW46YWRtaW4="
        }, function (error, response, data) {

            console.log("GEETING DATA FROM:-" + queryUrl);
            
            if (JSON.stringify(data.output)) {

                //debug: remove HERE
                console.log(JSON.stringify(data));

                //atttribute 0 contains all child container in this case device UUID which we need
                queryPath = JSON.stringify(data.output.ResourceOutput[0].Attributes[0]["attributeValue"]);
                console.log(queryPath);

                //removing quotes from attributeValue
                var withoutQuotes = queryPath.substring(1, queryPath.length - 2);

                //splitting each path by comma then splitting by '/'
                queryPath = withoutQuotes.split(",");
                queryPath = withoutQuotes.split("/");
                
                console.log("\n URL UUID for : " + queryPath[3]);
                io.sockets.emit('results', { results: queryPath[3], query: query });
                
            }
            else {

                console.log("Error connecting to server : " + JSON.stringify(data));

                io.sockets.emit('results', { results: 0, query: query });
                //pass zero to indicate search returned no results
            }
            //raw for each device check accuracy flag and put it in deviceib device cmx etc
        });

    });

});

updated = [];
app.post('/', function (req, res) {

    var body = "";
    req.on('data', function (dt) {
        body += dt;
    });
    req.on('end', function () {

        //give a response back from where the POST request came
        res.writeHead(200);

        //from URL encoding to text
        var decodedText = decodeURIComponent(body);

        //If a page is loaded onto a browser Parsing is skipped as Page Load is treated as Post
        console.log('POST made:' + decodedText);

        //In case appropriate JSON is recieved it is parsed and acted upon
        if (decodedText.length) {

            //JSON Parsing
            var parsedJSON = JSON.parse(decodedText);
            var output = JSON.stringify(parsedJSON.output);

            console.log("----------------------STATUS UPDATE : DEVICE MOVED------------------- \n" + output);

            var updateUrl = "http://" + IP + ":" + karafPORT + "/InCSE1/LocationAE/Things" + urlParameters + "&resultContent=6";

            //grab source container
            //SUNDAY : change to source attribute
            var source = JSON.stringify(data.output.ResourceOutput[0].Attributes[5]["attributeValue"]);
            var path = "http://" + IP + ":" + karafPORT + "/" + relPath + "/AccuracyFlag" + urlParameters;
            
            //if source is things, i.e. device container is created and new device is added
            if (source == "InCSE1/LocationAE/Things")
            {
                requestAccFlag(source, path,1);
                
            }
            //else location changed from source conatainer
            else
            {
                requestAccFlag(source,path,2)
            }

           // sendUpdate();
            //check TWO: for device being added
        }
        res.end();
    });
});


 /*
    function sendTimestamp() {
        io.sockets.emit('time', { time: new Date().toJSON() + '\n -------Device Added with Name : ' + dev + '\n With Latitude' + dev3 + '\n and Longitudee' + dev4 });
    }
    setInterval(sendTimestamp, 10000000);

*/

/*
//source from where update arrived
var updateUrl = "http://" + IP + ":" + karafPORT + "/InCSE1/LocationAE/Things" + urlParameters + "&resultContent=5";

request({
    url: updateUrl,
    json: true,
    Authorization: "Basic YWRtaW46YWRtaW4="
}, function (error, response, data) {

    //if(data.length){
    console.log("GEETING DATA FROM:-" + GetAllUrl);
    console.log(JSON.stringify(data));

    //find the parent container of update notificaition/source
    devicePaths = JSON.stringify(data.output.ResourceOutput[0].Attributes[8]["attributeValue"]);
    console.log(devicePaths);

    //removing quotes from attributeValue
    var withoutQuotes = devicePaths.substring(1, devicePaths.length - 2);

    //splitting each path by comma
    devicePaths = withoutQuotes.split(",");


    for (i = 0; i < devicePaths.length; i++) {

        //removing the array brackets & spaces(first characters)
        devicePaths[i] = devicePaths[i].substring(1);

        console.log("\n URL GRABBED for Device " + i + " : " + devicePaths[i]);

        var relPath = devicePaths[i];
        console.log(relPath);
        var eachPath = "http://" + IP + ":" + karafPORT + "/" + relPath + "/AccuracyFlag" + urlParameters;
        requestAccFlag(relPath, eachPath);
       


        }
    }
    
});
*/