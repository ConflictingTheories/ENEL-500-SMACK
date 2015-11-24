"""Power Prediction Demo (ppd.py)"""
#import all required libraries

import csv
import StringIO

from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel

#set up spark context
from pyspark import SparkConf, SparkContext

conf = SparkConf().setMaster("local").setAppName("ppd.py")
sc = SparkContext(conf = conf)

# Load and parse the data

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

wind_speed_array_10 = v_10_RDD.collect()

print "\nwind speed at row 1 " + str(wind_speed_array_10[1]) + " m/s"

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

wind_direction_array_10 = wdir_10_RDD.collect()

print "\nwind direction at row 1 " + str(wind_direction_array_10[1]) + " degrees relative to x and y components \nof the wind gradient"

data = v_10_RDD.zip(wdir_10_RDD) #zip combines 2 rdds together elemement by element

data_array = data.collect()
print "Title for wind speed and wind direction is " + str(data_array[0])
print "The dataset is " + str(data_array[1]) + " for the first row for speed and direction"
print "The dataset is " + str(data_array[2]) + " for the 2nd row for speed and direction\n"

print "The length of the entire dataset is " + str(len(data_array))

##def parsePoint(fileNameContents):
##    """load wind speed and direction at 10m then parse points"""
##    input = StringIO.StringIO(fileNameContents[1])
##    reader = csv.DictReader(input, fieldnames=["At Date", "At Time", "For Date", "For Time","Runtime",
##                                                "X coordinate", "Y coordinate", "Latitude", "Longitude",
##                                               "WIND_TGL_10", "WIND_TGL_40", "WIND_TGL_80", "WIND_TGL_120",
##                                               "WDIR_TGL_10", "WDIR_TGL_40", "WDIR_TGL_80", "WDIR_TGL_120",
##                                               "UGRD_TGL_10","UGRD_TGL_40", "UGRD_TGL_80", "UGRD_TGL_120",
##                                               "VGRD_TGL_10", "VGRD_TGL_40", "VGRD_TGL_80","VGRD_TGL_120",
##                                              "TMP_TGL_2", "SPFH_TGL_2", "PRES_SFC_0", "TCDC_SFC_0", "NSWRS_SFC_0"])
##    v_10 = [0]*8384 
##    wdir_10 = [0]*8384
##    Label = []*8384
##    i = 0
##    for row in reader:
##        if i == 0: 
##            i = i + 1
##        else:
##           v_10[i] = row['WIND_TGL_10']
##           wdir_10[i] = row['WDIR_TGL_10']
##           #print wdir_10[i]
##           #Label = float(x) for x in
##           i = i + 1  
##
##    v_10.pop(0)
##    wdir_10.pop(0)
##    print type(v_10[0])
##    print v_10[0]
##    print wdir_10[0]
##    print type(fileNameContents[1])
##    Label_v = [float(x) for x in v_10]
##    Label_w = [float(x) for x in wdir_10]
##    print type(Label_v[0])
##    print type(Label_v)
##    print Label_v[0]
##    print type(Label_w[0])
##    print type(Label_w)
##    return LabeledPoint(Label_v[0], Label_w[1])#Label_v 

#data_RDD = sc.wholeTextFiles("csv/00_NWP_Sample.csv")

#parsedData = data_RDD.flatMap(parsePoint)
#parsedData_array = parsedData.collect()
#print str(parsedData_array[0]) + " first row of parsed data array\n"

def parsePoint(line):
##    print type(line)
##    print line[0]
##    print line[1]
    speed = float(line[0])
    direction = float(line[1])
##    print type(speed) 
##    print type(direction)
    return LabeledPoint(1.0, [speed, direction])

#remove the header of the file
header = data.first()
filtered_data = data.filter(lambda x: x != header)

parsedData = filtered_data.map(parsePoint)
parsedData_array = parsedData.collect()
print str(parsedData_array[0]) + " first row of parsed data array\n"
#print str(parsedData_array)

#print str(parsedData_array)
#try putting into labeledpoint outside of function
#print str(parsedData_array[1]) + " 2nd row of parsed data array\n"
    
# Build the model
# http://www.cakesolutions.net/teamblogs/spark-mllib-linear-regression-example-and-vocabulary for help

model = LinearRegressionWithSGD.train(parsedData)

print model

# Evaluate model
# valuesAndPreds = parsedData.map(lambda p: (p.label, model.predict(p.features)))
# output_power = valiesAndPreds.map(lambda (v, p): v*p).reduce(lambda x, y: x + y)/valuesAndPreds.count()
# print("The output power for this particular dataset is " + str(output_power) + "MW"
