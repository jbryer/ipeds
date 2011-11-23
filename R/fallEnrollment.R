fallEnrollment <- function(data, mappings=NULL, institutionId=NA, institutionName=NA, documentId='a', createdDate=format(Sys.time(), '%Y-%m-%dT%H:%M:%S'), noteMessage=NA, transmissionType='Original', documentType='IPEDS') {
	mappings$MappedColumn = as.character(mappings$MappedColumn)
	
	if(is.na(institutionId)) { stop('institutionalId is required') }
	if(is.null(data)) { stop('Data is required') }
	#if(nrow(data[which(is.na(mappings['ProgramCIPCode','MappedColumn'])),]) > 0) { stop('All record must have a valid CIP code') }
	
	doc = newXMLDoc(namespace="http://www.w3.org/2001/XMLSchema-instance")
	root = newXMLNode("FE4:FallEnrollment", doc=doc, namespace=c('schemaLocation'="urn:org:pesc:message:FallEnrollment4Year:v1.1.0 FallEnrollment4Year_v1.1.0.xsd", 'xsi'="http://www.w3.org/2001/XMLSchema-instance", 'FE4'="urn:org:pesc:message:FallEnrollment4Year:v1.1.0"))
	
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
	
  #https://surveys.nces.ed.gov/ipeds/DataSchemas_Popup.aspx?efebb8aca1e1e9b8f9aabfeaf2e9e7eadcdfeeaad3cebfcedee3e0e8dceeaac1dce7e7c0e9edeae7e7e8e0e9efafd4e0dceddaf1aca9aca9aba9f3e8e7a1efb8c1dce7e79bc0e9edeae7e7e8e0e9ef9baf9bd4e0dcedeea1eddfefb8afaaafaaadabacac9bb3b5adafb5acb29bbcc8
  #TODO: Need to add EnrollmentFullTime
  
	counts = newXMLNode('EnrollmentPartTime', parent=enrollment)
	
	if(nrow(undergraduate) > 0) {
		ug = newXMLNode('UndergraduateEnrollment', parent=counts)
    degree = newXMLNode('DegreeCertificateSeeking', parent=ug)
    transferStudent = newXMLNode('TransferStudent', parent=degree)
    #TODO: need FirstTimeStudent, StudentOtherDegreeCertificateSeeking
		for(e in ethnicityLevels) {
			eNode = newXMLNode(e, parent=transferStudent)
			tmp2 = undergraduate.tab[which(undergraduate.tab$Var1 == e),]
			newXMLNode('CountMale', text=tmp2[which(tmp2$Var2 == 'MALE'),]$Freq, parent=eNode) #TODO: Need to map gender levels
			newXMLNode('CountFemale', text=tmp2[which(tmp2$Var2 == 'FEMALE'),]$Freq, parent=eNode)
		}
    #TODO: need NonDegreeCertificateSeeking
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
  
  addChildren(root, enrollment)
	
  return(doc)
}