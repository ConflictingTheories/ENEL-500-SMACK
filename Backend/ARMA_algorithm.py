"""ARMA_algorithm.py"""
#ARMA algorithm model for project
#taken from NWP data set 00
#starting with a simple linear regression tutorial example from
#http://spark.apache.org/docs/latest/mllib-linear-methods.html#regression

from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel

#set up spark context
from pyspark import SparkContext
sc = SparkContext("local", "ARMA_algorithm")

# Load and parse the data

def parsePoint(line):
    values = [float(x) for x in line.replace(',',' ').split(' ')]
    return LabeledPoint(values[0], values[1:])

data = sc.textFile("data/mllib/ridge-data/lpsa.data")
parsedData = data.map(parsePoint)

# Build the model
model = LinearRegressionWithSGD.train(parsedData)

# Evaluate the model on training data
valuesAndPreds = parsedData.map(lambda p: (p.label, model.predict(p.features)))
MSE = valuesAndPreds.map(lambda (v, p): (v - p)**2).reduce(lambda x, y: x + y) / valuesAndPreds.count()
print("Mean Squared Error = " + str(MSE))

# Save and load model
model.save(sc, "myModelPath")
sameModel = LinearRegressionModel.load(sc, "myModelPath")

