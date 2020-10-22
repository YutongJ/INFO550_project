#! /usr/bin/env Rscript

library(table1)
library(arsenal)
library(survival)
library(survMisc)
library(KMsurv)
library(MASS)

# load dataset
load("Dataset/clean_data.rda")

# final model with Obesity status
fit = coxph(Surv(OREM, censor) ~ PTSD + BMI_grp + PTSD:BMI_grp + HTN + DM, data=dat3)
sum.fit <- summary(fit)
tab <- sum.fit$coefficients[,-2]
colnames(tab) <- c("Estimate","Std.Err","Z-value","p-value")
rownames(tab) <- c("PTSD", "Obesity","HTN","DM","PTSD*Obesity")


write.csv(tab,file = "Tables/table2.csv",na = "")

