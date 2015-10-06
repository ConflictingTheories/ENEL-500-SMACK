#ARMA algorithm model for project
#taken from NWP data set 00
#starting with a simple linear regression tutorial example from
#http://spark.apache.org/docs/latest/mllib-linear-methods.html#regression

from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel

#set up spark context
from pyspark import SparkContext

logFile = "C:/Users/Andrew/Dropbox/Homework/Spark/spark-1.5.0-bin-hadoop2.6/README.md"  # Should be some file on your system
sc = SparkContext("local", "Simple App")
logData = sc.textFile(logFile).cache()

numAs = logData.filter(lambda s: 'a' in s).count()
numBs = logData.filter(lambda s: 'b' in s).count()

print("Lines with a: %i, lines with b: %i" % (numAs, numBs))

# Load and parse the data
"""
def parsePoint(line):
    values = [float(x) for x in lin.replace(',',' ').split(' ')]
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
