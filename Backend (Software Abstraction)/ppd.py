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


    
# Build the model

# model =

# Evaluate model
