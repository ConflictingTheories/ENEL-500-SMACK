"""csv_test.py"""
#testing loading, manipulating and saving csvs 

import csv
import StringIO

#set up spark context
from pyspark import SparkConf, SparkContext

conf = SparkConf().setMaster("local").setAppName("csv_test")
sc = SparkContext(conf = conf)

def loadRecord(line):
    """parse a CSV line"""
    input = StringIO.StringIO(line)
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                               "TMP_TGL_2SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    return reader.next() #next row

#load the CSV file 
input = sc.textFile("csv/00_NWP_Sample.csv").map(loadRecord)
num_commas = input.filter(lambda x: "name" in x).count()

print num_commas
print "Is the number of commas in this csv file"

first_element = input.first()

print first_element
print "This is the first row of the table"





