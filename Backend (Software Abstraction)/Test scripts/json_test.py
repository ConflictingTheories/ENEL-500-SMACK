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

#display spark example dataframe
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


#Unstructured method
input = sc.wholeTextFiles("json/00_NWP_Sample_snip.json")
#input = sc.textFile("json/colors.json")

data = input.map(lambda x: json.loads(x))

#data_array = data.collect()

#num_forecasted = data.filter("Forecasted_at_date").count()
#print num_forecasted 

#RED_hex = data.filter("red")
#RED_hex_data = collect.RED_hex
#print RED_hex_data

#saving json files
#in this case save x coordinates
dataframe_NWP.select("X").toJSON().saveAsTextFile("json/NWP_X_coords")


