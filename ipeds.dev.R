require(devtools)

setwd("c:/Dropbox/My Dropbox/Projects")
setwd("~/Dropbox/Projects/")

document("ipeds")
check_doc('ipeds')
build("ipeds", path='..')
build("ipeds", path='..', binary=TRUE)
check("ipeds")
install("ipeds")

library(ipeds)
data(surveys)
ls('package:ipeds')
system.file(package='ipeds')
downloadAllSurveys(2010)
