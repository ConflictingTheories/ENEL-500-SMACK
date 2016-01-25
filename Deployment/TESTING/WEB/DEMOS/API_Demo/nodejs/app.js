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

// GET Request API Call - Homepage - example - load google's homepage
app.get('/', function (req, res) {
	// Request Google and Store in Body
	request('http://www.google.com', function(error, response, body) {
    	// If no errors post to terminal and client’s browser
		if (!error && response.statusCode == 200) {
			// To Terminal
			console.log(body);
			// To Client
			res.send(body);
		}
 	});

});

// GET Request API Call - /yo - example - replies
app.get('/yo', function (req, res) {
	// Send Response  
	res.send('YO DAWG!');
});

// GET Request API Call - /nwp – basic returns message
app.get('/nwp', function(req, res) {
	// Send Response to Client’s Browser
	res.send('<html><body><h1>SMACK Energy Forecasting</h1><br /><br />NWP Data API Request Framework<br/><br/>Please Read below for options<br/><br/>COMING SOON</body></html>');
});

// Setup API Listener on port 3000 and wait for requests
app.listen(3000, function(){
	console.log('Example app listening on port 3000!');
});
