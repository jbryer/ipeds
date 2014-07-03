require(ipeds)
require(ggplot2)

data(surveys)

ipedsHelp('IC', 2011)
ipedsHelp('EFD', 2011)

directory = getIPEDSSurvey('HD', 2011)
admissions = getIPEDSSurvey("IC", 2011)
retention = getIPEDSSurvey("EFD", 2011)

directory = directory[,c('unitid', 'instnm', 'sector', 'control')]
admissions = admissions[,c('unitid', 'cntlaffi', 'openadmp', 
						   'applcnm', 'applcnw', 'admssnm', 'admssnw',
						   'ft_ug', 'pt_ug', 'enrlt', 'distnced')]
retention = retention[,c('unitid', 'ret_pcf', 'ret_pcp')]

names(admissions) = c('unitid', 'control', 'openadmission', 
					  'applicantsMale', 'applicantsFemale', 'admissionsMale', 'admissionsFemale',
					  'ftug', 'ptug', 'enrollment', 'distanceEd')
names(retention) = c("unitid", "FullTimeRetentionRate", "PartTimeRetentionRate")

str(admissions)
admissions$openadmission = factor(admissions$openadmission, 
								  levels=c('1','2'), labels=c('Open','FirstTime'))
admissions$distanceEd = factor(admissions$distanceEd,
							   levels=c('1','2'), labels=c('Yes','No'))
admissions[admissions$applicantsMale == 1,]$applicantsMale = NA
admissions$applicantsMale = as.integer(admissions$applicantsMale)
admissions[admissions$applicantsFemale == 1,]$applicantsFemale = NA
admissions$applicantsFemale = as.integer(admissions$applicantsFemale)
admissions[admissions$admissionsMale == 1,]$admissionsMale = NA
admissions$admissionsMale = as.integer(admissions$admissionsMale)
admissions[admissions$admissionsFemale == 1,]$admissionsFemale = NA
admissions$admissionsFemale = as.integer(admissions$admissionsFemale)
admissions$enrollment = as.integer(admissions$enrollment)

schools <- merge(directory, admissions, by='unitid', all.x=TRUE)
schools <- merge(schools, retention, by='unitid', all.x=TRUE)
schools$Selectivity <- (schools$admissionsMale + schools$admissionsFemale) /
	                   (schools$applicantsMale + schools$applicantsFemale)
summary(schools$Selectivity)
mean(schools$Selectivity, na.rm=TRUE)

