"""Power Prediction Demo (ppd.py)"""
#import all required libraries

import csv
import StringIO

from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel

#set up spark context
from pyspark import SparkConf, SparkContext

conf = SparkConf().setMaster("local").setAppName("ppd.py")
sc = SparkContext(conf = conf)

# Load the data

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

v_10_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_speed_10)

##wind_speed_array_10 = v_10_RDD.collect()
##
##print "\nwind speed at row 1 " + str(wind_speed_array_10[1]) + " m/s at a height of 10m"

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

wdir_10_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_dir_10)

##wind_direction_array_10 = wdir_10_RDD.collect()
##
##print "\nwind direction at row 1 " + str(wind_direction_array_10[1]) + " degrees relative to x and y components \nof the wind gradient 10m"

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

v_40_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_speed_40)

##wind_speed_array_40 = v_40_RDD.collect()
##
##print "\nwind speed at row 1 " + str(wind_speed_array_40[1]) + " m/s at a height of 40m"

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

wdir_40_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_dir_40)

##wind_direction_array_40 = wdir_40_RDD.collect()
##
##print "\nwind direction at row 1 " + str(wind_direction_array_40[1]) + " degrees relative to x and y components \nof the wind gradient 40m"

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

v_80_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_speed_80)

##wind_speed_array_80 = v_80_RDD.collect()
##
##print "\nwind speed at row 1 " + str(wind_speed_array_80[1]) + " m/s at a height of 80m"

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

wdir_80_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv").flatMap(load_wind_dir_80)

##wind_direction_array_80 = wdir_80_RDD.collect()
##
##print "\nwind direction at row 1 " + str(wind_direction_array_80[1]) + " degrees relative to x and y components \nof the wind gradient 80m"

#Begin combining RDDs and parsing data
#zip combines 2 rdds together element by element

#combine speed and direction at:
v_wdir_10_RDD = v_10_RDD.zip(wdir_10_RDD) #10m
v_wdir_40_RDD = v_40_RDD.zip(wdir_40_RDD) #40m
v_wdir_80_RDD = v_80_RDD.zip(wdir_80_RDD) #80m

#combine speed only: 

#Data to be parsed
#data_10_40_v_wdir = v_wdir_10_RDD.zip(v_wdir_40_RDD) #data for 10/40m speed & direction
data_10_40_v = v_10_RDD.zip(v_40_RDD) #speed at 10/40m

data = data_10_40_v.zip(v_80_RDD) #speed at 10/40/80m

data_array = data.collect()
print "\nTitle for wind speed and wind direction is " + str(data_array[0])
print "The dataset is " + str(data_array[1]) + " for the first row for speed and direction"
print "The dataset is " + str(data_array[2]) + " for the 2nd row for speed and direction\n"

print "The length of the entire dataset is " + str(len(data_array))

# def parsePoint(line):     #dir and speed 10/40/80
#     #print type(line)
#     # print line[0][0][0]
#     # print line[0][0][1]
#     # print line[0][1][0]
#     # print line[0][1][1]
#     speed_10 = float(line[0][0][0])
#     direction_10 = float(line[0][0][1])
#     speed_40 = float(line[0][1][0])
#     direction_40 = float(line[0][1][1])
#     speed_80 = float(line[1][0])
#     direction_80 = float(line[1][1])
# ##    print type(speed)
# ##    print type(direction)
#     return LabeledPoint(direction_10, [speed_10, speed_40, speed_80])

##def parsePoint(line):       #dir and speed 10/40
##    #print type(line)
##    # print line[0][0]
##    # print line[0][0]
##    speed_10 = float(line[0][0])
##    direction_10 = float(line[0][1])
##    speed_40 = float(line[1][0])
##    direction_40 = float(line[1][1])
####    print type(speed)
####    print type(direction)
##    return LabeledPoint(direction_10, [speed_10, speed_40])

def parsePoint(line):       #dir and speed 10/40
    #print type(line)
##    print line[0][0]
##    print line[0][1]
##    print line[1]
    speed_10 = float(line[0][0])
    speed_40 = float(line[0][1])
    speed_80 = float(line[1])
    speed_weight_10_40 = speed_10/speed_40
    speed_weight_40_80 = speed_40/speed_80
    speed_weight_10_80 = speed_10/speed_80
##    print type(speed)
##    print type(direction)
    return LabeledPoint(speed_weight_10_40, [speed_weight_40_80, speed_weight_10_80]) #LabeledPoint(speed_10, [speed_40, speed_80])



#remove the header of the file
header = data.first()
filtered_data = data.filter(lambda x: x != header)

parsedData = filtered_data.map(parsePoint)
parsedData_array = parsedData.collect()

print str(parsedData_array[0]) + " first row of parsed data array\n"

#print str(parsedData_array)
#print str(parsedData_array[1]) + " 2nd row of parsed data array\n"
    
# Build the model
# http://www.cakesolutions.net/teamblogs/spark-mllib-linear-regression-example-and-vocabulary for help

model = LinearRegressionWithSGD.train(parsedData)

print model

#test MSE
valuesAndPreds = parsedData.map(lambda p: (p.label, model.predict(p.features)))
MSE = valuesAndPreds.map(lambda (v, p): (v - p)**2).reduce(lambda x, y: x + y) / valuesAndPreds.count()#data.count()
print("Mean Squared Error = " + str(MSE))

# Evaluate model and get power output
# valuesAndPreds = parsedData.map(lambda p: (p.label, model.predict(p.features)))
output_power = valuesAndPreds.map(lambda (v, p): v*p/20).reduce(lambda x, y: x + y) #total dummy algorithm

print "The output power for this particular dataset is " + str(output_power) + " MW"
