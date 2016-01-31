"""Broad cast testing (broadcast_test_2.py)"""
from __future__ import print_function

import os
import sys
import json
import csv
import StringIO

from pyspark import SparkContext
from pyspark.streaming import StreamingContext

#set up spark context and sql context for structured dataframe from json
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext

conf = SparkConf().setMaster("local[2]").setAppName("broadcast_test_2.pyy") #use 2 cores
sc = SparkContext(conf = conf)
sqlContext = SQLContext(sc)

### Get or register a Broadcast variable
##def getWordBlacklist(sparkContext):
##    if ('wordBlacklist' not in globals()):
##        globals()['wordBlacklist'] = sparkContext.broadcast(["a", "b", "c"])
##    return globals()['wordBlacklist']

#blacklist = getWordBlacklist(

hoods = ((1, "Mission"), (2, "SOMA"), (3, "Sunset"), (4, "Haight Ashbury"))
checkins = ((234, 1),(567, 2), (234, 3), (532, 2), (234, 4))
hoodsRdd = sc.parallelize(hoods)
checkRdd = sc.parallelize(checkins)

broadcastedHoods = sc.broadcast(hoodsRdd.collectAsMap())

rowFunc = lambda x: (x[0], x[1], broadcastedHoods.value.get(x[1], -1))
def mapFunc(partition):
    for row in partition:
        yield rowFunc(row)

checkinsWithHoods = checkRdd.mapPartitions(mapFunc, preservesPartitioning=True)

display_Data = checkinsWithHoods.take(5)

print("data information:")
print(display_Data)
