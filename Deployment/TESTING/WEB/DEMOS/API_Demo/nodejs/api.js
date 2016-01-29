// # SMACK API - Demonstration
//
//      # Designed for Task #5
//
//      # Basic API Call Demonstration using node.js
//
//      # Available Commands:
//      # List statistics about nwp database (*not implemented)
//      #       GET /nwp?list
//      #
//      # List top 100 entries from database (*not implemented)
//      #       GET /nwp?head=100
//      #
//
//
// Use for HTTP requests (Outgoing)
var request = require('request');
// Use for API calls (Incoming)
var express = require('express');
// Frontend Controller Object
var app = express();

// Filtering Function for Null Values
function filt(objl){
	// Filtered Array
    var new_objs = [];
    // Loop Through
    for(var i = 0; i < objl.length; i++){
    	if (objl[i] == null)
    		continue;
    	else
    		new_objs.push({grib2:objl[i]});
    }
    if(new_objs.isEmpty())
    	return {nwp_grib2:"empty"};
    else
    	return {nwp_grib2:new_objs};
};

// GET Request API Call - Homepage - example - load google's homepage
app.get('/', function (req, res) {
// Send Response to Client’s Browser
	res.send('<html><body>\
		<h1>SMACK Energy Forecasting</h1>\
		<br /><br />SMACK Energy Forecasting API Portal<br/><br/>\
		Please Read below for options<br/><br/>\
		<h2>API Endpoints:</h2><br/>\
		<p>\
		<b>/nwp</b>:<br/><ul>\
		<li>/nwp/list?date=YYYYMMDD</li>\
		<li>/nwp/listall</li>\
		<li>MORE COMING SOON</li>\
		<ul><p>\
		</body></html>');
});

// GET Request API Call - /nwp – basic returns message
app.get('/nwp', function(req, res) {
	// Send Response to Client’s Browser
	res.send('Please Use one of the Available API Calls - Thank you');
});

app.get('/nwp/list', function(req, res) {
	if(req.query.date != "") {
		// Query
		var date = req.query.date;
		// Retrieve Data
		request('https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b/nwp', function (err, resp, bdy){
			var objs = bdy.split("\n").map(function (obj){
				if (obj.indexOf(date) != -1){
					return obj;
				}
			});
			objs.slice(0, objs.length);
			// Remove Nulls
			var filt_objs = filt(objs);
            // Return JSON Format
            res.send(JSON.stringify(filt_objs));
        });
    }
    else {
    	res.send("Please Use the following format: /nwp/list?date=YYYYMMDD");
    }
});

// Setup API Listener on port 3000 and wait for requests
app.listen(3000, function(){
	console.log('Example app listening on port 3000!');
});
