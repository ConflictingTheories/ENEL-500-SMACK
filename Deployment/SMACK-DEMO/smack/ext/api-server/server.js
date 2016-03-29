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
res.send('<html><body><h1>SMACK Energy Forecasting</h1><br/><br/>SMACK Energy Forecasting API Portal<br/>\
	<br/>Please Read below for options<br/><br/><h2>API Endpoints:</h2><br/><p><b>Weather Prediction Data (NWP):</b>\
	<br/><ul><li>/nwp?date=YYYYMMDD&rt=XX&fh=XX&var=VARNAME</li><br/><li>Variables:<br/><ul><li>DEN_TGL_80, WIND_TGL_10, WIND_TGL_40, WIND_TGL_80</li></ul>\
	</li></ul><br/><b>Historical Power Data:</b>\
	<br/><ul><li>/hist?date=YYYYMMDD&hour=XX&min=XX</li></ul>\
	<br/><b>Predicted Power Data:</b><br/>\
	<ul><li>/pred?date=YYYYMMDD&rt=XX&site=XXXX</li><li>Available Wind Farms(sites):<br/>\
	<ul><li>ARD1, AKE1, BUL1, BUL2, BSR1, BTR1, CR1, CRR1, CRW1, SCR2, SCR3, SCR4, TAB1, KHW1, NEP1, OWF1, IEW1, IEW2, HAL1, GWW1</li></ul>\
	</li></ul><ul><li>MORE COMING SOON</li></ul><p></body></html>');
});

// GET Request API Call - /nwp – basic returns message
app.get('/nwp', function(req, res) 
{
	var rq = req.query;
	if ( rq.date != null && rq.rt != null && rq.fh != null && rq.var != null )
	{
            // Perform Query Analysis and Data Fetch
            if (rq.date == "" || rq.rt == "")
            {
            	res.send('Data transfer is limited. Please make appropriate calls.');
            }
            else
            {
            	// Extract Date
            	var date = rq.date;
            	var yyyy = date.substring(0,4);
            	var mm = date.substring(4,6);
            	var dd = date.substring(6,8);
            	var dt = yyyy+'/'+mm+'/'+dd+'/'+rq.rt

            	request({'url':swift_url+'/nwptxt?prefix='+dt}, function (err, resp, bdy)
            	{
            		var rt_objs = bdy.split("\n").map(function(obj)
            		{
						// Single Variable Single Forecast
						if (rq.var != "" && rq.fh != "")
						{
							if( obj.search(dt+'/'+rq.fh+'/'+rq.var) != -1)
								return obj;
						}
						// Single Variable All Forecasts
						else if (rq.var != "" && rq.fh == "")
						{
							if( obj.search(rq.var) != -1)
								return obj;
						}
						// All Variables Single Forecast
						else if (rq.var == "" && rq.fh != "")
						{
							if (obj.search(dt+'/'+rq.fh) != -1)
								return obj;
						} 
					});

            		rt_objs = rt_objs.filter(function(e){return e;});

            		if( rt_objs.length > 0)
            		{
            			var cnt = 0;
            			var accumulator = [];
						// Loop through and download files from swift
						for(fl in rt_objs)
						{	
							if ( rt_objs[fl] != undefined )
							{
								request({'url':swift_url+'/nwptxt/'+rt_objs[fl]}, function (err, rsp, bdy) 
								{
									if (bdy != undefined) {
										n_bdy = bdy.split("\n");
										dim = n_bdy[0].split(" ");
										new_bdy = n_bdy.slice(1);
										// FOR EDITING THE STRUCTURE OF THE OBJECT LISTING (FARMS)
										//for(f in new_bdy) 
										//{	
										//	Perform Changes Here
										//}
										data = { 'date': dt, 'var': rt_objs[fl].substring(14), 'size_i': dim[0], 'size_j': dim[1], 'data': new_bdy };
										accumulator.push(data);
										if(cnt == rt_objs.length-1) { res.send(accumulator); }
										cnt++;
									}
								});
							}
						}
					}
					else
					{
						res.send('{"error":"bad date"}');
					}
				});
}
}
else
{
            // Send Response to Client’s Browser
            res.send('Please Use one of the Available API Calls - For more help try /nwp/help');
        }
    });

// Historical Data Range
app.get('/hist', function(req, res) {
	if(req.query.date != null) {
		var date = req.query.date;
	// Extract Date
	var yyyy = date.substring(0,4);
	var mm = date.substring(4,6);
	var dd = date.substring(6,8);
	if (req.query.hour != null && req.query.hour != ""){ if (req.query.min != null){ var rt = req.query.hour+""+req.query.min; }else{ var rt = req.query.hour; }} else { if(req.query.hour == "" && req.query.min != null) {res.send("Error: Please format requests like: /hist?date=YYYYMMDD?hour=HH?min=MM"); return;} else {var rt = req.query.hour;} }
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
							try{
								new_bdy = JSON.parse(bdy);
								// FOR EDITING THE STRUCTURE OF THE OBJECT LISTING (FARMS)
								//for(f in new_bdy) 
								//{	
								//	Perform Changes Here
								//}
							}
							catch(e)
							{
								new_bdy = JSON.parse('{"error":"bad json"}');
							}
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
	res.send("Please Use the following format: /hist?date=YYYYMMDD&hour=HH&min=MM");
}
});

// GET Request API Call - Prediction Data
app.get('/pred', function(req, res) 
{
	var rq = req.query;
	if ( rq.date != null && rq.rt != null && rq.site != null )
	{
            // Perform Query Analysis and Data Fetch
            if (rq.date == "" || rq.rt == "")
            {
            	res.send('Data transfer is limited. Please make appropriate calls.');
            }
            else
            {
            	// Extract Date
            	var date = rq.date;
            	var yyyy = date.substring(0,4);
            	var mm = date.substring(4,6);
            	var dd = date.substring(6,8);
            	var dt = yyyy+'/'+mm+'/'+dd+'/'+rq.rt

            	request({'url':swift_url+'/PwrPred?prefix='+dt}, function (err, resp, bdy)
            	{
            		var rt_objs = bdy.split("\n").map(function(obj)
            		{
						// Single Site
						if (rq.site != "")
						{
							if( obj.search(rq.site) != -1)
								return obj;
						}
						// All Sites
						else if (rq.site == "")
						{
							if( obj.search(dt+'/') != -1)
								return obj;
						}
					});

            		rt_objs = rt_objs.filter(function(e){return e;});

            		if( rt_objs.length > 0)
            		{
            			var cnt = 0;
            			var accumulator = [];
						// Loop through and download files from swift
						rt_objs = rt_objs.filter(function (e){ if (e.search('_SUCCESS') == -1 && e != dt){return e} });
						rt_objs = rt_objs.filter(function (e){if(e.search('part-00000') != -1){return e}});
                        //console.log(rt_objs);
                        for(fl in rt_objs)
                        {
                        	if ( rt_objs[fl] != undefined )
                        	{
                        		request({'url':swift_url+'/PwrPred/'+rt_objs[fl]}, function (err, rsp, bdy)
                        		{
                        			if (bdy != undefined) {
                        				new_bdy = bdy;
                        					if ( bdy != "" )
                        					{
                        						try
                        						{
                        							//console.log(bdy);
                        							new_bdy = JSON.parse(bdy);
                        						}
                        						catch(e)
                        						{
                                            		// Replace with
                                            		new_bdy = JSON.parse('{"error":"bad json"}');
                                            	}
                                            }
                                            // FOR EDITING THE STRUCTURE OF THE OBJECT LISTING (FARMS)
                                            //for(f in new_bdy)
                                            //{
                                            //      Perform Changes Here
                                            //}
                                            container = 'PwrPred/';
                                            file_end = '/part-00000';
                                            pUrl = rsp.req.path;
                                            indexStart = pUrl.indexOf(container);
                                            indexEnd = pUrl.indexOf(file_end);
                                            sitename = pUrl.substring(indexStart+19, indexStart+21);
                                            runtime = pUrl.substring(indexStart+22, indexEnd);
                                            data = { 'date': yyyy+'/'+mm+'/'+dd, 'rt': runtime, 'site': sitename, 'data': new_bdy };
                                            accumulator.push(data);
                                            if(cnt == rt_objs.length-1) { res.send(accumulator); }
                                            cnt++;
                                    }
								});
							}
						}
					}
					else
					{
						res.send('{"error":"bad date"}');
					}
				});
			}
		}
	else
	{
        // Send Response to Client’s Browser
    	res.send('Please Use one of the Available API Calls - For more help try /nwp/help');
    }
});

// Setup API Listener on port 3000 and wait for requests
app.listen(3000, function(){
	console.log('SMACK API is up on port 3000!');
});
