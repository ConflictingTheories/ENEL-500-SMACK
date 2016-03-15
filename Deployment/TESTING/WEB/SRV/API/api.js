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

// Modules
var util = require('util');
var request = require('request');
var fs = require('fs');
var express = require('express');

// Frontend Controller Object
var app = express();

// URL
var swift_url = "https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b";

// GET Request API Call - Homepage
app.get('/', function (req, res) 
{
	// Send Response to Clients Browser
	res.send('<html><body><h1>SMACK Energy Forecasting</h1><br /><br />SMACK Energy Forecasting API Portal<br/><br/>Please Read below for options<br/><br/><h2>API Endpoints:</h2><br/><p><b>/nwp</b>:<br/><ul><li>/nwp/list?date=YYYYMMDD</li><li>/nwp/listall</li><li>MORE COMING SOON</li><ul><p></body></html>');
});

// GET Request API Call - /nwp – basic returns message
app.get('/nwp', function(req, res) 
{
	// Send Response to Client’s Browser
	res.send('Please Use one of the Available API Calls - For more help try /nwp/help');
});

// Historical Data Range
app.get('/hist', function(req, res) {
	if(req.query.date != null) {
		var date = req.query.date;
		// Extract Date
		var yyyy = date.substring(0,4);
		var mm = date.substring(4,6);
		var dd = date.substring(6,8);
		if (req.query.hour != null){ if (req.query.min != null){ var rt = req.query.hour+""+req.query.min; console.log("RT: "+rt); }else{ var rt = req.query.hour; }} else { res.send("Error: Please format requests like: /hist?date=YYYYMMDD?hour=HH?min=MM"); return; }
		var dt = yyyy+"/"+mm+"/"+dd;
		// Request Files
		request({'url':swift_url+'/hist?limit=1440&prefix='+dt}, function (err, resp, bdy)
		{
			// Retrieve List of Files
			var objs = bdy.split("\n").map(function (obj)
			{;
				// Return only the single minute - RT - (HHMM)
				if (obj.search(dt+"/"+rt) != -1){
					return obj;
				}
			});
			// Remove Empty Listings
			objs = objs.filter(function(e){return e});
			// Ensure not empty
			if (objs.length > 0)
			{
				var cnt = 0;
				var accumulator = [];
				// Loop through and download files from swift
				for(fl in objs)
				{	
					if ( objs[fl] != undefined )
					{
						request({'url':swift_url+'/hist/'+objs[fl]}, function (err, rsp, bdy) 
						{
							if (bdy != undefined) {
								new_bdy = JSON.parse(bdy);
								// FOR EDITING THE STRUCTURE OF THE OBJECT LISTING (FARMS)
								//for(f in new_bdy) 
								//{	
								//	Perform Changes Here
								//}
								data = { 'date': dt, 'rt': rsp.req.path.substring(rsp.req.path.length-4,rsp.req.path.length), 'sites': new_bdy};
								accumulator.push(data);
								if(cnt == objs.length-1) { res.send(accumulator); }
								cnt++;
							}
						});
					}
				}
			}
			else
			{
				res.send(JSON.stringify({'error':'bad_date'}));
			}
		});
	}
	else {
		res.send("Please Use the following format: /hist/?date=YYYYMMDD");
	}
});
// Setup API Listener on port 3000 and wait for requests
app.listen(3000, function(){
	console.log('Example app listening on port 3000!');
});


