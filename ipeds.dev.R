require(devtools)

document()
build()
check()
install()

library(ipeds)
data(surveys)
ls('package:ipeds')

# This is where the data files will be downloaded by default
system.file(package='ipeds')

# Depracted methods
downloadAllSurveys(2010)
