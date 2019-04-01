#' This function generates a XML file for the twelve month enrollment survey.
#'
#' This function is no longer supported.
#' 
#' @title twelveMonthEnrollment
#' @param data A data frame containing the required fields for IPEDS reporting.
#' @param mappings The mapping between the fields in data and IPEDS (see \code{\link{mapIPEDSFields}} function)
#' @param institutionId The IPEDS institution ID the data is being generated for.
#' @param institutionName The name of the institution.
#' @param documentId Use specified.
#' @param createdDate The date the document is created.
#' @param noteMessage Optional note message to include in the generated file.
#' @param transmissionType Either original for first upload or replace.
#' @param documentType Defaults to application
#' @param reportingPeriod 
#' @param undergraduateContactHours The total number of undergraduate contact hours for the given reporting period.
#' @param undergraduateCreditHours The total number of undergraduate credit hours for the given reporting period.
#' @param graduateCreditHours The total number of graduate credit hours for the given reporting period.
twelveMonthEnrollment <- function(data, mappings=NULL, institutionId=NA, 
			institutionName=NA, documentId='a', createdDate=format(Sys.time(), '%Y-%m-%dT%H:%M:%S'), 
			noteMessage=NA, transmissionType='Original', documentType='Application',
			reportingPeriod='July-June', undergraduateContactHours=NULL,
			undergraduateCreditHours=NULL, graduateCreditHours=NULL) {
	warning('This function is no longer supported. Use at your own risk.')
	
	mappings$MappedColumn = as.character(mappings$MappedColumn)

	if(is.na(institutionId)) { stop('institutionalId is required') }
	if(is.null(data)) { stop('Data is required') }
	#if(nrow(data[which(is.na(mappings['ProgramCIPCode','MappedColumn'])),]) > 0) { stop('All record must have a valid CIP code') }

	doc = newXMLDoc(namespace="http://www.w3.org/2001/XMLSchema-instance")
	root = newXMLNode("EN12_4:TwelveMonthEnrollment4Year", doc=doc, namespace=c('schemaLocation'="urn:org:pesc:message:12MonthEnrollment4Year:v1.0.0 12MonthEnrollment4Year_v1.0.0.xsd", 'xsi'="http://www.w3.org/2001/XMLSchema-instance", 'EN12_4'="urn:org:pesc:message:12MonthEnrollment4Year:v1.0.0"))

	td = newXMLNode('TransmissionData', namespace='')
	newXMLNode('DocumentID', text=documentId, parent=td)
	newXMLNode('CreatedDateTime', text=createdDate, parent=td)
	newXMLNode('TransmissionType', text=transmissionType, parent=td)
	newXMLNode('DocumentType', text=documentType, parent=td)
	if(!is.na(noteMessage)) { newXMLNode('NoteMessage', text=noteMessage, parent=td) }
	addChildren(root, td)

	undergraduate = data[which(data[,mappings['EducationalAwardLevel','MappedColumn']] < 6),]
	graduate = data[which(data[,mappings['EducationalAwardLevel','MappedColumn']] > 5),]

	undergraduate.tab = as.data.frame(table(undergraduate[,mappings['Ethnicity','MappedColumn']],undergraduate[,mappings['Gender','MappedColumn']],exclude=NULL))
	graduate.tab = as.data.frame(table(graduate[,mappings['Ethnicity','MappedColumn']],graduate[,mappings['Gender','MappedColumn']],exclude=NULL))

	enrollment = newXMLNode('EnrollmentByInstitution', namespace='')
	inst = newXMLNode('Institution', parent=enrollment)
	newXMLNode('IPEDSUnitID', text=institutionId, parent=inst)
	if(!is.na(institutionName)) { newXMLNode('OrganizationName', text=institutionName, parent=inst) }

	counts = newXMLNode('UnduplicatedCounts', parent=enrollment)

	if(nrow(undergraduate) > 0) {
		enroll = newXMLNode('UndergraduateEnrollment', parent=counts)
		for(e in ethnicityLevels) {
			eNode = newXMLNode(e, parent=enroll)
			tmp2 = undergraduate.tab[which(undergraduate.tab$Var1 == e),]
			newXMLNode('CountMale', text=tmp2[which(tmp2$Var2 == 'MALE'),]$Freq, parent=eNode) #TODO: Need to map gender levels
			newXMLNode('CountFemale', text=tmp2[which(tmp2$Var2 == 'FEMALE'),]$Freq, parent=eNode)
		}
	}

	if(nrow(graduate) > 0) {
		enroll = newXMLNode('GraduateEnrollment', parent=counts)
		for(e in ethnicityLevels) {
			eNode = newXMLNode(e, parent=enroll)
			tmp2 = graduate.tab[which(graduate.tab$Var1 == e),]
			newXMLNode('CountMale', text=tmp2[which(tmp2$Var2 == 'MALE'),]$Freq, parent=eNode) #TODO: Need to map gender levels
			newXMLNode('CountFemale', text=tmp2[which(tmp2$Var2 == 'FEMALE'),]$Freq, parent=eNode)
		}
	}

	if(!is.null(undergraduateContactHours) | !is.null(undergraduateCreditHours) | !is.null(graduateCreditHours)) {
		activity = newXMLNode('InstructionalActivity', parent=enrollment)
		newXMLNode('ReportingPeriod', text=reportingPeriod, parent=activity)
		if(!is.null(undergraduateContactHours)) {
			newXMLNode('CndergraduateContactHours', text=undergraduateContactHours, parent=activity)
		}
		if(!is.null(undergraduateCreditHours)) {
			newXMLNode('UndergraduateCreditHours', text=undergraduateCreditHours, parent=activity)
		}
		if(!is.null(graduateCreditHours)) {
			newXMLNode('GraduateCreditHours', text=graduateCreditHours, parent=activity)
		}
	}

	addChildren(root, enrollment)
	doc
}

