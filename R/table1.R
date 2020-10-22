#! /usr/bin/env Rscript

library(table1)
library(arsenal)
library(survival)
library(survMisc)
library(KMsurv)
library(MASS)

# load dataset
load("Dataset/clean_data.rda")

# Cox-PH for numerical covariates
tab = NULL
fit = coxph(Surv(OREM, censor) ~ BMI_grp, data = dat3,ties = "breslow")
sums = summary(fit)
tab = rbind(tab, c(sums$conf.int[c(1,3,4)],sums$sctest[3]))
fit = coxph(Surv(OREM, censor) ~ HTN, data = dat3,ties = "breslow")
sums = summary(fit)
tab = rbind(tab, c(sums$conf.int[c(1,3,4)],sums$sctest[3]))
fit = coxph(Surv(OREM, censor) ~ HC, data = dat3,ties = "breslow")
sums = summary(fit)
tab = rbind(tab, c(sums$conf.int[c(1,3,4)],sums$sctest[3]))
fit = coxph(Surv(OREM, censor) ~ DM, data = dat3,ties = "breslow")
sums = summary(fit)
tab = rbind(tab, c(sums$conf.int[c(1,3,4)],sums$sctest[3]))
fit = coxph(Surv(OREM, censor) ~ PTSD, data = dat3,ties = "breslow")
sums = summary(fit)
tab = rbind(tab, c(sums$conf.int[c(1,3,4)],sums$sctest[3]))

fit = coxph(Surv(OREM, censor) ~ Marital, data = dat3,ties = "breslow")
sums = summary(fit)
tab = rbind(tab, cbind(sums$conf.int[,c(1,3,4)],sums$sctest[3]))
fit = coxph(Surv(OREM, censor) ~ Employ, data = dat3,ties = "breslow")
sums = summary(fit)
tab = rbind(tab, cbind(sums$conf.int[,c(1,3,4)],sums$sctest[3]))
fit = coxph(Surv(OREM, censor) ~ Education, data = dat3,ties = "breslow")
sums = summary(fit)
tab = rbind(tab, cbind(sums$conf.int[,c(1,3,4)],sums$sctest[3]))
tab <- round(tab,3)
Covariates = c("Obesity Status","Hypertension History","High Blood Cholesterol", "Diabetes","PTSD", 
               "Marital Status","(ref) Married", rep(NA,(length(table(dat3$Marital))-3)), 
               "Employment Status", "(ref) Employed-full time", rep(NA,(length(table(dat3$Employ))-3)),
               "Education", "(ref) Less than High School", rep(NA,(length(table(dat3$Education))-3)))
Comparison = c(rep("Yes vs. No",5), 
               names(table(dat3$Marital))[-1],
               names(table(dat3$Employ))[-1],
               names(table(dat3$Education))[-1])
tab <- cbind(Covariates, Comparison, tab)
rownames(tab)=NULL
colnames(tab) = c("Covariates", "Comparison", "Relative Risk", "Lower0.95", "Upper0.95", "p-value")

write.csv(tab,file = "Tables/table1.csv",row.names = F,na = "")
