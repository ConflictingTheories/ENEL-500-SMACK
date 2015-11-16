"""csv_test.py"""
#testing loading, manipulating and saving csvs 

import csv
import StringIO

#set up spark context
from pyspark import SparkConf, SparkContext

conf = SparkConf().setMaster("local").setAppName("csv_test")
sc = SparkContext(conf = conf)

def loadRecord(line): #row by row 
    """parse a CSV line"""
    input = StringIO.StringIO(line)
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                               "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    return reader.next() #next row

#load the CSV file 
input = sc.textFile("csv/00_NWP_Sample.csv").map(loadRecord)

first_element = input.first()

print first_element
print "This is the first row of the table"

csv_array_type1 = input.collect();

print csv_array_type1[1]
print "this is the second row of the table"

def loadRecords(fileNameContents): #load all records in a given file
    """Load all the records in a given file"""
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                               "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    return reader

fullFileData = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(loadRecords)

csv_array_type2 = fullFileData.collect()

def load_X_coord(fileNameContents):
    """load all x coordinates"""
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])

    X = [0]*8384 
    i = 0
    for row in reader:
        X[i] = row['X coordinate']
        #print row['X coordinate']
        i = i + 1
    return X

X = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_X_coord)

x_coords = X.collect()

#print x_coords
#print "column of x coordinates"

print x_coords[0]
print "first x coordinate entry"

print x_coords[356] #356 + 1 since the entry starts at 0
print "357th x coordinate entry"

#saving CSVs
def writeRecords(records):
    """Write out CSV lines"""
    output = StringIO.StringIO()
    writer = csv.DictWriter(output, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    for record in records:
        writer.writerow(record)
        
    return [output.getvalue()]

#save a new csv file
input.mapPartitions(writeRecords).saveAsTextFile("csv/new_00_NWP")

#save in a readable csv format. This is a command done through cmd using hadoop
#hdfs dfs -getmerge csv/new_00_NWP new_00_NWP.csv


