#! /usr/bin/env Rscript

library(table1)
library(arsenal)
library(survival)
library(survMisc)
library(KMsurv)
library(MASS)

# load dataset
load("Dataset/clean_data.rda")

fit = survfit(Surv(OREM, censor) ~ PTSD + BMI_grp, data = dat3, type="kaplan-meier")

png("Figures/figure1.png",width = 800, height = 600, res=100)
plot(fit,col=1:4,lwd=2, 
     xlab="Minutes to the Occurrence of REM Sleep", ylab="REM Sleep Achieving Probability")
legend("topright", col=1:4,lwd=2,bty = "n",cex=0.8,
       legend=c("Non-PTSD, Non-Obesity","Non-PTSD, Obesity",
                "PTSD, Non-Obesity","PTSD, Obesity"))
dev.off()
