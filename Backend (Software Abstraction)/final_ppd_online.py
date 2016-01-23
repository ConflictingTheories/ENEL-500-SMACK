"""Final Power Prediction Demo with csv (final_ppd_online.py)"""
#import all required libraries

import json
import csv
import StringIO

from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel

#set up spark context and sql context for structured dataframe from json
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext

conf = SparkConf().setMaster("local[2]").setAppName("final_ppd_online.py") #use 2 cores
sc = SparkContext(conf = conf)
sqlContext = SQLContext(sc)

#Functions to Load the data

def load_wind_speed_10(fileNameContents):
    """load windspeed at 10m"""
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    v_10 = [0]*8384 
    i = 0
    for row in reader:
        v_10[i] = row['WIND_TGL_10']
        i = i + 1
    return v_10

def load_wind_dir_10(fileNameContents):
    """load wind direction at 10m"""
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    wdir_10 = [0]*8384
    i = 0
    for row in reader:
        wdir_10[i] = row['WDIR_TGL_10']
        i = i + 1
    return wdir_10

def load_wind_speed_40(fileNameContents):
    """load windspeed at 40m"""
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    v_40 = [0]*8384 
    i = 0
    for row in reader:
        v_40[i] = row['WIND_TGL_40']
        i = i + 1
    return v_40

def load_wind_dir_40(fileNameContents):
    """load wind direction at 40m"""
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    wdir_40 = [0]*8384
    i = 0
    for row in reader:
        wdir_40[i] = row['WDIR_TGL_40']
        i = i + 1
    return wdir_40

def load_wind_speed_80(fileNameContents):
    """load windspeed at 80m"""
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    v_80 = [0]*8384 
    i = 0
    for row in reader:
        v_80[i] = row['WIND_TGL_80']
        i = i + 1
    return v_80

def load_wind_dir_80(fileNameContents):
    """load wind direction at 80m"""
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
    wdir_80 = [0]*8384
    i = 0
    for row in reader:
        wdir_80[i] = row['WDIR_TGL_80']
        i = i + 1
    return wdir_80

#Load data and create dataframe (df) from sample json file
NWP_df = sqlContext.read.json("json/00_NWP_Sample_snip.json")
print "Data information:\n"
NWP_df.printSchema()

#create RDDs and dataframes
print "Loading wind speed at 10/40/80 m in m/s:\n"
v_10_df = NWP_df.select("WIND_TGL_10")
v_10_df.show()
v_10_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_speed_10)

v_40_df = NWP_df.select("WIND_TGL_40")
v_40_df.show()
v_40_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_speed_40)

v_80_df = NWP_df.select("WIND_TGL_80")
v_80_df.show()
v_80_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_speed_80)


print "Loading wind direction at 10/40/80 m relative to i,j comp of grid:\n"

wdir_10_df = NWP_df.select("WDIR_TGL_10")
wdir_10_df.show()
wdir_10_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_dir_10)

wdir_40_df = NWP_df.select("WDIR_TGL_40")
wdir_40_df.show()
wdir_40_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_dir_40)

wdir_80_df = NWP_df.select("WDIR_TGL_80")
wdir_80_df.show()
wdir_80_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_dir_80)

#Create RDDs for data to be parsed
data_10_40_v = v_10_RDD.zip(v_40_RDD) #speed at 10/40m

data = data_10_40_v.zip(v_80_RDD).cache() #speed at 10/40/80m

#Display size of entire data set
data_array = data.collect()
print "The length of the entire dataset is " + str(len(data_array))
print "Running power prediction calculations..."

#function to parsedata
def parsePoint(line):       #dir and speed 10/40
    speed_10 = float(line[0][0])
    speed_40 = float(line[0][1])
    speed_80 = float(line[1])
    speed_weight_10_40 = speed_10/speed_40
    speed_weight_40_80 = speed_40/speed_80
    speed_weight_10_80 = speed_10/speed_80
    return LabeledPoint(speed_weight_10_40, [speed_weight_40_80, speed_weight_10_80])

#remove the header of the file to deal with numbers only
header = data.first()
filtered_data = data.filter(lambda x: x != header).cache()

#Parse the filtered data
#socket exception occurs here because of removal of header
parsedData = filtered_data.map(parsePoint)

# Build the model
model = LinearRegressionWithSGD.train(parsedData)

#test MSE
valuesAndPreds = parsedData.map(lambda p: (p.label, model.predict(p.features)))
MSE = valuesAndPreds.map(lambda (v, p): (v - p)**2).reduce(lambda x, y: x + y) / valuesAndPreds.count()#data.count()
print("\nMean Squared Error = " + str(MSE))

# Evaluate model and get power output
output_power = valuesAndPreds.map(lambda (v, p): v*p/20).reduce(lambda x, y: x + y) #total dummy algorithm

print "The output power for this particular dataset is " + str(output_power) + " MW"

