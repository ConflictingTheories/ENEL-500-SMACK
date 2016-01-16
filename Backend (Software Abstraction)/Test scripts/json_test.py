"""json_test.py"""
#testing loading, manipulating and saving json files 

import json

#set up spark context and sql context for structured dataframe from json
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext

conf = SparkConf().setMaster("local").setAppName("json_test")
sc = SparkContext(conf = conf)
sqlContext = SQLContext(sc)

#load the json file into dataframe

dataframe_example = sqlContext.read.json("examples/src/main/resources/people.json")
dataframe_colors = sqlContext.read.json("json/colors.json")
dataframe_NWP = sqlContext.read.json("json/00_NWP_Sample_snip.json")

#display spark example dataframe and colors dataframe
dataframe_example.show()
dataframe_example.printSchema()
dataframe_colors.show()
dataframe_colors.printSchema()
#select by column because its too much to show on one screen
dataframe_NWP.select("X").show()
X_array = dataframe_NWP.select("X").collect()
dataframe_NWP.printSchema()

print str(X_array) + " Are the x coordinates\n"
print str(X_array[0]) + " is the first x coordinate\n"

#extract single value
print "x coord types:\n"
print str(dataframe_NWP.select("X").dtypes)

for row in X_array:
    print row[0]
    print str(type(row[0])) + " is the type"

#saving json files
#in this case save x coordinates
dataframe_NWP.select("X").toJSON().saveAsTextFile("json/NWP_X_coords")


