#!/usr/local/bin/python3.5
#
#
#       SMACK Parser - Historical Data
#
#

import json
import urllib.request
from html.parser import HTMLParser

# Table to Parse from Webpage
Table_Title = "WIND"
#       WIND
#       HYDRO
#       COAL
#       BIOMASS AND OTHER
# ------NO GAS-----------

class MyHTMLParser(HTMLParser):
        # Header Flag - for WIND
        tf_th = False
        # Necessary Evil
        tf_tr = False
        # Real Flag for Header (P as in Post)
        tf_thp = False
        # Title Group in HTML
        tf_titgrp = False
        # Individual Titles
        tf_title = False
        # Hack
        tf_wd = False
        # Data Flag
        tf_drdy = False
        tf_data = ""
        # Title Counter
        col_cnt = 0
        # Title List
        col_tit = []
        # Data counter for Table Data
        td_cnt = 0
        # Well Counter
        w_cnt = 0
        # Temp Hist Row
        hist = []
        # Well List
        well = []
        # Necessary
        tf_w = False
        
        # When it finds a tag <example> calls functio
        def handle_starttag(self, tag, attrs):
        # TH - WIND
                if ((tag == "th")):
                        self.tf_th = True
                # For Data Header Title
                if ((tag == "tr") and self.tf_thp and not self.tf_titgrp):
                        self.tf_titgrp = True
                # Also For Data Header Titles
                if (self.tf_titgrp and (tag == "font")):
                        self.tf_title = True
                if (self.tf_drdy and tag == "td"):
                        self.tf_data = True

        # When it finds an endtag </example> calls function
        def handle_endtag(self, tag):
                # For Ending TH - WIND
                if (tag == "th"):
                        self.tf_th = False
                # Setting flag to alert section
                if (self.tf_wd):
                        self.tf_thp = True
                # If Ending Title Headers
                if (self.tf_titgrp and (tag == "tr")):
                        self.tf_titgrp = False
                        self.tf_drdy = True
                # If Ending Individual Titles - in Header
                if (self.tf_thp and (tag == "font")):
                        self.tf_title = False
                if (self.tf_data and (tag == "td")):
                        self.tf_data = False
                # Finished
                if (self.tf_drdy and (tag == "table")):
                        self.tf_th = False
                        self.tf_thp = False
                        self.tf_drdy = False
                        self.tf_titgrp = False
                        self.tf_wd = False
                        self.tf_tr = False
                        self.tf_title = False
                        self.td_cnt = 0
                        self.w_cnt = 0
                        self.col_cnt = 0
                        self.hist = []
                        self.tf_w = True


        # When it finds data between start and end tags it calls function
        def handle_data(self, data):
                # If WIND section found begin scraping
                if (self.tf_th and (data == Table_Title) and not self.tf_thp):
                        self.tf_wd = True
                # If Header is done, and individual Title
                if (self.tf_wd and self.tf_titgrp and self.tf_title):
                        self.col_tit.append(data)
                        self.col_cnt = self.col_cnt + 1
                # if data add to list
                if (self.tf_wd and self.tf_data):
                        self.hist.append(data)
                        self.td_cnt = self.td_cnt + 1
                        if (self.td_cnt == len(self.col_tit)):
                                well_d = {}
                                n = 0
                                for i in self.col_tit:
                                        well_d[i] = self.hist[n]
                                        n = n + 1
                                self.well.append({"farm" : well_d})
                                self.w_cnt = self.w_cnt + 1
                                self.td_cnt = 0
                                self.hist = []

# Generate Parser
parser = MyHTMLParser()
# New File
newData = open("historical.json", "w")
# Retrieve Data
htmlfile = urllib.request.urlopen("http://ets.aeso.ca/ets_web/ip/Market/Reports/CSDReportServlet").read()
# Parse and Extract
parser.feed(str(htmlfile))
# Dump to File
json.dump(parser.well, newData)

