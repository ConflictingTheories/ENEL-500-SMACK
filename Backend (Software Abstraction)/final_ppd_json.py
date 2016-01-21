"""Final Power Prediction Demo with json (final_ppd_json.py)"""
#import all required libraries

import json

from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel

#set up spark context and sql context for structured dataframe from json
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext

conf = SparkConf().setMaster("local").setAppName("final_ppd_json.py")
sc = SparkContext(conf = conf)
sqlContext = SQLContext(sc)

#Load data and create dataframe (df)
NWP_df = sqlContext.read.json("json/00_NWP_Sample_snip.json")
print "Data information:\n"
NWP_df.printSchema()

#create RDDs and dataframes 
#Load wind speed
print "Loading wind speed at 10/40/80 m in m/s:\n"
v_10_df = NWP_df.select("WIND_TGL_10")
v_10_df.show()
v_10_RDD = v_10_df.rdd
##v_10_array = v_10_RDD.collect()
##print v_10_array

v_40_df = NWP_df.select("WIND_TGL_40")
v_40_df.show()
v_40_RDD = v_40_df.rdd


v_80_df = NWP_df.select("WIND_TGL_80")
v_80_df.show()
v_80_RDD = v_80_df.rdd


#load wind direction
print "Loading wind direction at 10/40/80 m relative to i,j comp of grid:\n"
wdir_10_df = NWP_df.select("WDIR_TGL_10")
wdir_10_df.show()

wdir_40_df = NWP_df.select("WDIR_TGL_40")
wdir_40_df.show()

wdir_80_df = NWP_df.select("WDIR_TGL_80")
wdir_80_df.show()

#Create RDDs for data to be parsed
data_10_40_v = v_10_RDD.zip(v_40_RDD) #speed at 10/40m

data = data_10_40_v.zip(v_80_RDD).cache() #speed at 10/40/80m

#Display a sample of data that will be analyzed
data_array = data.collect()
print "\nThe dataset is " + str(data_array[0]) + " at the first row for the speed at 10/40/80m"
print "The dataset is " + str(data_array[1]) + " for the second row for the speed at 10/40/80m\n"

print "The length of the entire dataset is " + str(len(data_array))

#function to parsedata
def parsePoint(line):
    print line[0][0]
    print line[0][1]
    print line[1]
    
    for row in line[0][0]:
      #print row
      speed_10 = row
      break

    for row in line[0][1]:
      #print row
      speed_40 = row
      break

    for row in line[1]:
      #print row
      speed_80 = row
      break
    
    speed_weight_10_40 = speed_10/speed_40
    speed_weight_40_80 = speed_40/speed_80
    speed_weight_10_80 = speed_10/speed_80
    
    return LabeledPoint(speed_weight_10_40, [speed_weight_40_80, speed_weight_10_80])

#Parse the filtered data
parsedData = data.map(parsePoint)

# Build the model
model = LinearRegressionWithSGD.train(parsedData)

#test MSE
valuesAndPreds = parsedData.map(lambda p: (p.label, model.predict(p.features)))
MSE = valuesAndPreds.map(lambda (v, p): (v - p)**2).reduce(lambda x, y: x + y) / valuesAndPreds.count()#data.count()
print("\nMean Squared Error = " + str(MSE))

# Evaluate model and get power output
output_power = valuesAndPreds.map(lambda (v, p): v*p/20).reduce(lambda x, y: x + y) #total dummy algorithm

print "The output power for this particular dataset is " + str(output_power) + " MW"


