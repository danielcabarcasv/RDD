

library(rddensity)
library(foreign)

setwd("~/Documents/GitHub/RDD")
hansen_dwi <- read_dta("Documents/GitHub/RDD/Data/hansen_dwi.dta")

bac1 <- hansen_dwi$bac1
summary(rddensity(hansen_dwi$bac1, c=0.08, p=2))
rddens <- rddensity(hansen_dwi$bac1, c=0.08, p=2)
rdplotdensity(rddens, bac1, title = "Density test", xlabel = "BAC")

hist(bac1, breaks=1000, main="BAC Histogram", xlab="BAC")
abline(v=0.08,col="red")