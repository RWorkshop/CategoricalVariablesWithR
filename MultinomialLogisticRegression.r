
install.packages(c("nnet","sandwich","msm","reshape2"))

library(foreign)
library(ggplot2)
library(MASS)
library(Hmisc)
library(reshape2)
library(sandwich)
library(msm)




library(nnet)
library(ggplot2)
library(reshape2)

ml <- read.csv("https://raw.githubusercontent.com/RWorkshop/workshopdatasets/master/multilog.csv")

with(ml, table(ses, prog))
 


with(ml, do.call(rbind, tapply(write, prog, function(x) c(M = mean(x), SD = sd(x)))))


ml$prog2 <- relevel(ml$prog, ref = "academic")
test <- multinom(prog2 ~ ses + write, data = ml)


summary(test)

### Test Statistics and P-values
z <- summary(test)$coefficients/summary(test)$standard.errors
z

p <- (1 - pnorm(abs(z), 0, 1)) * 2
p


## extract the coefficients from the model and exponentiate
exp(coef(test))

head(pp <- fitted(test))

dses <- data.frame(ses = c("low", "middle", "high"), write = mean(ml$write))

predict(test, newdata = dses, "probs")


dwrite <- data.frame(ses = rep(c("low", "middle", "high"), each = 41), write = rep(c(30:70),
    3))

## store the predicted probabilities for each value of ses and write
pp.write <- cbind(dwrite, predict(test, newdata = dwrite, type = "probs", se = TRUE))

## calculate the mean probabilities within each level of ses
by(pp.write[, 3:5], pp.write$ses, colMeans)


## melt data set to long for ggplot2
lpp <- melt(pp.write, id.vars = c("ses", "write"), value.name = "probability")
head(lpp)  # view first few rows

## plot predicted probabilities across write values for each level of ses
## facetted by program type
ggplot(lpp, aes(x = write, y = probability, colour = ses)) + geom_line() + facet_grid(variable ~
    ., scales = "free")

## melt data set to long for ggplot2
lpp <- melt(pp.write, id.vars = c("ses", "write"), value.name = "probability")
head(lpp)  # view first few rows
 
##   ses write variable probability
## 1 low    30 academic     0.09844
## 2 low    31 academic     0.10717
## 3 low    32 academic     0.11650
## 4 low    33 academic     0.12646
## 5 low    34 academic     0.13705
## 6 low    35 academic     0.14828
 



## plot predicted probabilities across write values for each level of ses
## facetted by program type
ggplot(lpp, aes(x = write, y = probability, colour = ses)) + geom_line() + facet_grid(variable ~
    ., scales = "free")
