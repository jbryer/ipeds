require(ipeds)
require(ggplot2)

data(surveys)
directory = getIPEDSSurvey('HD', 2009)
admissions = getIPEDSSurvey("IC", 2009)
retention = getIPEDSSurvey("EFD", 2009)

#Subset the data frames so we only have the columns we need
directory = directory[,c('unitid', 'instnm', 'sector', 'control')]
admissions = admissions[,c('unitid', 'admcon1', 'admcon2', 'admcon7', 'applcnm', 
						   'applcnw', 'applcn', 'admssnm', 'admssnw', 'admssn', 
						   'enrlftm', 'enrlftw', 'enrlptm', 'enrlptw', 'enrlt', 
						   'satnum', 'satpct', 'actnum', 'actpct', 'satvr25', 
						   'satvr75', 'satmt25', 'satmt75', 'satwr25', 'satwr75', 
						   'actcm25', 'actcm75', 'acten25', 'acten75', 'actmt25', 
						   'actmt75', 'actwr25', 'actwr75')]
retention = retention[,c('unitid', 'ret_pcf', 'ret_pcp')]

#Recode admissions condition to a factor from an integer
admissionsLabels = c("Required", "Recommended", "Neither requiered nor recommended", 
					 "Do not know", "Not reported", "Not applicable")
admissions$admcon1 = factor(admissions$admcon1, levels=c(1,2,3,4,-1,-2), 
							labels=admissionsLabels)
admissions$admcon2 = factor(admissions$admcon2, levels=c(1,2,3,4,-1,-2), 
							labels=admissionsLabels)
admissions$admcon7 = factor(admissions$admcon7, levels=c(1,2,3,4,-1,-2), 
							labels=admissionsLabels)

#Rename the columns
names(admissions) = c("unitid", "UseHSGPA", "UseHSRank", "UseAdmissionTestScores", 
					  "ApplicantsMen", "ApplicantsWomen", "ApplicantsTotal", 
					  "AdmissionsMen", "AdmissionsWomen", "AdmissionsTotal", 
					  "EnrolledFullTimeMen", "EnrolledFullTimeWomen", 
					  "EnrolledPartTimeMen", "EnrolledPartTimeWomen", 
					  "EnrolledTotal", "NumSATScores", "PercentSATScores", 
					  "NumACTScores", "PercentACTScores", "SATReading25", 
					  "SATReading75", "SATMath25", "SATMath75", "SATWriting25", 
					  "SATWriting75", "ACTComposite25", "ACTComposite75", 
					  "ACTEnglish25", "ACTEnglish75", "ACTMath25", "ACTMath75", 
					  "ACTWriting25", "ACTWriting75")
names(retention) = c("unitid", "FullTimeRetentionRate", "PartTimeRetentionRate")

#Merge the data frames. Note that schools that do not appear in all three data 
#frames will not be included in the final analysis.
ret = merge(directory, admissions, by="unitid")
ret = merge(ret, retention, by="unitid")
#Use schools that require or recommend admission tests
ret2 = ret[ret$UseAdmissionTestScores %in% 
		   	c('Required', 'Recommended', 'Neither requiered nor recommended'),] 
#Remove schools with low retention rates. Are these errors in the data?
ret2 = ret2[-which(ret2$FullTimeRetentionRate < 20),] 

#IPEDS only provides the 25th and 75th percentile in SAT and ACT scores. We will use
#the mean of these two values as a proxy for the mean
ret2$SATMath75 = as.numeric(ret2$SATMath75)
ret2$SATMath25 = as.numeric(ret2$SATMath25)
ret2$SATMath = (ret2$SATMath75 + ret2$SATMath25) / 2
ret2$SATWriting75 = as.numeric(ret2$SATWriting75)
ret2$SATWriting25 = as.numeric(ret2$SATWriting25)
ret2$SATWriting = (ret2$SATWriting75 + ret2$SATWriting25) / 2
ret2$SATTotal = ret2$SATMath + ret2$SATWriting

ret2$AcceptanceTotal = as.numeric(ret2$AdmissionsTotal) / as.numeric(ret2$ApplicantsTotal)
ret2$UseAdmissionTestScores = as.factor(as.character(ret2$UseAdmissionTestScores))

ggplot(ret2, aes(x=SATTotal, y=FullTimeRetentionRate, size=NumSATScores, 
				 color=UseAdmissionTestScores)) + geom_point()

#Regression
fit = lm(FullTimeRetentionRate ~ SATWriting + SATMath + AcceptanceTotal + 
		 	UseAdmissionTestScores, data=ret2, weights=NumSATScores)
summary(fit)
