library(table1)
library(arsenal)
library(survival)
library(survMisc)
library(KMsurv)
library(MASS)

# The path used for reading and writing in this exam
dir <- "/Users/firmiana/Firmiana/Coursework/INFO550/HW/HW2/"

### infile the dataset
dat <- read.csv(paste0(dir,"Dataset_PTSD.csv"),stringsAsFactors = F)
summary(dat)

### identify the locations of missing values
which(is.na(dat),arr.ind = T)
# row col
#  16   4   --
#  16   5     |-- These pairs should be removed 
# 121   8   --

#   1  14   --
#  69  14     |
# 117  14     |
# 128  14     |-- These missing are allowed due to study design
# 141  14     |
# 142  14     |
# 162  14   --

### remove twins with missing data
dat <- dat[-which(dat$Date %in% dat[c(16,121),"Date"]),]

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
save(dat3,file = paste0(dir,"dat3.rda"))

summary(dat3)
###########################
######   analysis   #######
###########################
# table 1


# univariate analysis for categorical variables
pdf(file = paste0(dir,"Uni_Categorical_SurvCurve.pdf"))
# PTSD + BMI_grp
fit = survfit(Surv(OREM, censor) ~ PTSD + BMI_grp, data = dat3, type="kaplan-meier")
plot(fit,col=1:4,lty=1:4,xlab="Minutes to theOccurrence of REM Sleep", lwd=2,ylab="REM Sleep Achieving Probability",main="Kaplan-Meier Plot")
legend("bottomleft", lty=1:4, col=1:4,lwd=2,bty = "n",cex=0.8,
       legend=c("Non-PTSD, Non-Obesity","Non-PTSD, Obesity",
                "PTSD, Non-Obesity","PTSD, Obesity"))
dev.off()

# log-rank test for categorical covariates
survdiff(Surv(OREM, censor) ~ BMI_grp, data = dat3)
survdiff(Surv(OREM, censor) ~ HTN, data = dat3)
survdiff(Surv(OREM, censor) ~ HC data = dat3)
survdiff(Surv(OREM, censor) ~ DM, data = dat3)
survdiff(Surv(OREM, censor) ~ PTSD, data = dat3)
survdiff(Surv(OREM, censor) ~ Marital, data = dat3)
survdiff(Surv(OREM, censor) ~ Employ, data = dat3)
survdiff(Surv(OREM, censor) ~ Education, data = dat3)

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
               "Marital Status","(ref) Married", rep(NA,(length(table(dat$Marital))-3)), 
               "Employment Status", "(ref) Employed-full time", rep(NA,(length(table(dat$Employ))-3)),
               "Education", "(ref) Less than High School", rep(NA,(length(table(dat$Education))-3)))
Comparison = c(rep("Yes vs. No",5), 
               names(table(dat$Marital))[-1],
               names(table(dat$Employ))[-1],
               names(table(dat$Education))[-1])
               # paste0(names(table(dat$Marital))[-1]," vs. ",names(table(dat$Marital))[1]),
               # paste0(names(table(dat$Employ))[-1]," vs. ",names(table(dat$Employ))[1]),
               # paste0(names(table(dat$Education))[-1]," vs. ",names(table(dat$Education))[1]))
tab <- cbind(Covariates, Comparison, tab)
rownames(tab)=NULL
colnames(tab) = c("Covariates", "Comparison", "Relative Risk", "Lower .95", "Upper .95", "p-value")

knitr::kable(tab,booktabs = T,format = "latex", caption = "Summary Statistics by Cox-PH Model with Respect to Categorical Covariate")

# options(knitr.kable.NA = '')
# knitr::kable(test,booktabs = F)
# knitr::kable(test,booktabs = T,format = "latex", caption = "Title of the table")

# wald test
# est=fit$coefficients;var=fit$var;C=c(0,1,0,0,0)
walds <-  function(est,var,C){
  df = nrow(C)
  Ccov = C%*%var%*%t(C)
  X.w = t(C%*%est)%*%ginv(Ccov)%*%(C%*%est) #test.stat
  pval = 1-pchisq(X.w,df)
  es = (C%*%est)
  low = (C%*%est)+sqrt(Ccov)%*%qnorm(0.025)
  up  = (C%*%est)+sqrt(Ccov)%*%qnorm(0.975)
  res = c(exp(es),exp(low),exp(up),pval)
  names(res) = c("HR","HRlower","HRuppper","P-value")
  return(res)
}


# final model with Obesity status
fit = coxph(Surv(OREM, censor) ~ PTSD + BMI_grp + PTSD:BMI_grp + HTN + DM, data=dat3)
summary(fit)

# hypothesis test for Obesity status stratification
# Non-Obesity: PTSD v.s. non-PTSD
Cs <- rbind(c(1,0,0,0,0))
walds(est=fit$coefficients,var=fit$var,C=Cs)
# Obesity:  PTSD v.s. non-PTSD
Cs <- rbind(c(1,0,0,0,1))
walds(est=fit$coefficients,var=fit$var,C=Cs)
# Difference between associations
Cs <- rbind(c(0,0,0,0,1))
walds(est=fit$coefficients,var=fit$var,C=Cs)



