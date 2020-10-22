#! /usr/bin/env Rscript

library(table1)
library(arsenal)
library(survival)
library(survMisc)
library(KMsurv)
library(MASS)


### infile the dataset
dat0 <- read.csv("Dataset/Dataset_PTSD.csv",stringsAsFactors = F)
# summary(dat)

### remove twins with missing data
dat <- dat0[-which(dat0$Date %in% dat0[c(16,121),"Date"]),]

# identifying the obesity status based on patients BMI
BMI_grp <- rep(0, length(dat$BMI))
BMI_grp[which(dat$BMI>=30)] <- 1

dat <- data.frame(dat[,1:3],BMI_grp,dat[,4:ncol(dat)])
rm(BMI_grp)

# Factor the basic variables that we're interested in (label used in descriptive table)
label(dat$Age) <- "Age"
units(dat$Age)   <- "Years"

labels(dat$BMI) <- "BMI"
units(dat$BMI)   <- "kg/m2"

dat$BMI_grp <- factor(dat$BMI_grp,levels = c(0,1), labels = c("No", "Yes"))
labels(dat$BMI_grp) <- "Obesity Status"

dat$HTN <- factor(dat$HTN,levels = c(0,1), labels = c("No", "Yes"))
label(dat$HTN) <- "Hypertension History"

dat$HC <- factor(dat$HC,levels = c(0,1), labels = c("No", "Yes"))
label(dat$HC) <- "High Blood Cholesterol History"

dat$DM <- factor(dat$DM,levels = c(0,1), labels = c("No", "Yes"))
label(dat$DM) <- "Diabetes History"

dat$Marital <- factor(dat$Marital,levels = c(1,2,3,4,5), 
                      labels = c("Married","Widowed","Divorced","Separated","Never Married"))
label(dat$Marital) <- "Marital Status"

dat$Employ <- factor(dat$Employ,levels = c(1,2,3,4,5), 
                     labels = c("Employed(Full-time)","Employed(Part-time)",
                                "Unemployed","Unable to Work due to Disability",
                                "Retired"))
label(dat$Employ) <- "Employment Status"

dat$Education <- factor(dat$Education,levels = c(0,1,2,3,4), 
                        labels = c("Less than High School","High School",
                                   "Some College or Associate","College Degree",
                                   "Graduate Education/Degree"))
label(dat$Education) <- "Education"


dat$PTSD <- factor(dat$PTSD,levels = c(0,1),labels = c("No", "Yes"))
label(dat$PTSD) <- "PTSD"



### dataset for research question 
OREM <- dat$REML
censor <- rep(1, length(dat$REML))
OREM[which(is.na(dat$REML))] <- (dat$TST+dat$SL)[which(is.na(dat$REML))]
censor[which(is.na(dat$REML))] <- 0

dat3 <- data.frame(dat,OREM,censor)
rm(OREM,censor)
label(dat3$OREM) <- "Occurrence of REM Sleep"

dat3 <- dat3[!duplicated(dat3$Date),]
# summary(dat3)

# save data
save(dat3,file = "Dataset/clean_data.rda")

