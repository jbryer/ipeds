devtools::install_github('jbryer/ipeds')

require(ipeds)
require(ggplot2)
require(reshape2)
require(scales)
data(surveys)

View(surveys)

# Directory
ipedsHelp('HD', 2012)
schools <- getIPEDSSurvey('HD', 2012)
head(schools)

# Graduates
ipedsHelp('C_A', 2012)

grads <- data.frame()
for(i in seq(2000, 2012)) {
	tmp <- getIPEDSSurvey('C_A', i)
	if(!'ctotalw' %in% names(tmp)) {
		# Somewhere around 2007/2008
		tmp$ctotalm <- tmp$crace15
		tmp$ctotalw <- tmp$crace16
	}
	tmp <- tmp[,c('unitid','cipcode','awlevel','ctotalw','ctotalm')]
	tmp$Year <- i
	grads <- rbind(grads, tmp)
}

# CIP Codes 
# Mathematics: http://nces.ed.gov/ipeds/cipcode/cipdetail.aspx?y=55&cipid=88406
# CIS: http://nces.ed.gov/ipeds/cipcode/cipdetail.aspx?y=55&cipid=88073
# NOTE 27.99xx is Mathematics and Statistics Other, leaving in math
cipcode <- ifelse(grads$cipcode < 10,
				  paste0('0', formatC(grads$cipcode, digits=5, format='fg', flag='#')),
				  formatC(grads$cipcode, digits=6, format='fg', flag='#'))

grads.math <- grads[substr(grads$cipcode, 1, 5) %in% c('27.01','27.03','27.99'),
					c('Year','unitid','cipcode','awlevel','ctotalw','ctotalm')]

grads.stat <- grads[substr(grads$cipcode, 1, 5) %in% c('27.05'),
					c('Year','unitid','cipcode','awlevel','ctotalw','ctotalm')]

grads.cis <- grads[substr(grads$cipcode, 1, 2) %in% c('11'),
					c('Year','unitid','cipcode','awlevel','ctotalw','ctotalm')]

names(grads.math) <- names(grads.stat) <- names(grads.cis) <- 
	c('Year','school','cipcode','level','nfemales','nmales')

grads.math$subject <- 'Math'
grads.stat$subject <- 'Stats'
grads.cis$subject <- 'CIS'

grads2 <- rbind(grads.math, grads.stat, grads.cis)

grads.sum <- cbind(aggregate(grads2$nfemales, by=list(grads2$subject, grads2$Year), FUN=sum),
                   aggregate(grads2$nmales, by=list(grads2$subject, grads2$Year), FUN=sum)[,3] )
names(grads.sum) <- c('Subject', 'Year', 'nFemales', 'nMales')
grads.sum$Total <- apply(grads.sum[,c('nFemales','nMales')], 1, sum)
grads.sum$Female <- grads.sum$nFemales / grads.sum$Total
grads.sum$Male <- grads.sum$nMales / grads.sum$Total
head(grads.sum)
grads.sum.melt <- melt(grads.sum[,c('Subject','Year','Female','Male')], id=c('Subject','Year'))
grads.tot.melt <- melt(grads.sum[,c('Subject','Year','Total')], id=c('Subject','Year'))

ggplot(grads.tot.melt, aes(x=factor(Year), y=value, color=Subject, group=Subject)) + 
	geom_path(stat='identity') +
	xlab('Year') + ylab('Number of Graduates')

ggplot(grads.tot.melt, aes(x=factor(Year), y=value, fill=Subject)) + 
	geom_bar(stat='identity', position='dodge') +
	xlab('Year') + ylab('Number of Graduates') +
	ggtitle('Number of Graduates by Year')

ggplot(grads.sum.melt[grads.sum.melt$variable == 'Female',], 
	   aes(x=factor(Year), y=value, group=Subject, color=Subject)) +
	geom_path(stat='identity', alpha=.5) +
	geom_text(aes(label=paste0(prettyNum(value*100, digits=3), '%')), size=4, vjust=-1) +
	scale_y_continuous(labels=percent, limits=c(0,1)) +
	xlab('Year') + ylab('Percent Female Graduates') +
	ggtitle('Percent of Female Graduates by Year for CIS, Math, and Statistics Majors') +
	annotate('text', x='2000', y=0, size=3, hjust=0,
			 label='Data Source: Integrated Postsecondary Education Data System')


