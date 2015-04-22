#BROWSER HEATMAP
NodeJS scripts and attached views for Browser HeatMap.

##Requirements:
*Almost all required modules are added already to the folder.
*But, in case of missing node_module, one can type(without quotes):
	*"npm install missing_module_name"
to install the required modules.

*Modules Used:
**HTTP, REQUEST : for forming HTTP GET,POST requests to get data on/off the ODL DataStore
**SOCKET.IO     : for communication between server and view pages

##TO RUN the script:
*You will need NodeJS(0.12.0 or later) to run this script

*To check if you *already have NodeJS installed, type in(without quotes):
		*"node -v" 
*It will return the version of your NodeJS, in case you don't have it installed:
One can download it following the steps below:

	Linux Users  : sudo apt-get install node
	MAC Users    : yum apt-get install node
	Windows Users: Download from - https://nodejs.org/download/

*Type in this into your terminal(after the above installation completes)
cd HEATMAP
		*node heatmap.js

*The console will tell you the port it is listening to(currently 8111)
With heatmap.js running in background,
*Type in: 
	http://localhost:8111 in your Browser 

and voila! It works!

TROUBLESHOOTING:
* The ODL server is listening on IP(52.10.62.166) at karafPORT(8282).
* If you want to see just the app working, heatmap.js is running at IP:PORT(52.10.62.166:8111)
	go to : http://52.10.62.166:8111
* Check your IPs and Port twice! before running the script:
  IP        : 52.10.62.166  -- IP where ODL is running; in this case heatmap.js is running on the same IP as well(would be replaced with your IP/localhost)
  karafPORT : 8282	    -- PORT on IP where ODL is running
  PORT      : 8111	    -- PORT where server is running