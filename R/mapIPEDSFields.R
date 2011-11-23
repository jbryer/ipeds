#' This function creates a mapping between the field (column) names from source data frame and the names used by the ipeds package.
#'
#' @title mapIPEDSFields
#' @param programCIPCode The name of the column containing the CIP codes.
#' @param educationalProgramType The name of the column containing the program types.
#' @param educationalProgramName The name of the column containing the program names.
#' @param educationalAwardLevel The name of the column containing the award levels.
#' @param ethnicityColumn The name of the column containing student ethnicities.
#' @param genderColumn The name of the column containing student genders.
#' @export
mapIPEDSFields <- function(programCIPCode, educationalProgramType, 
		educationalProgramName, educationalAwardLevel, ethnicityColumn, 
		genderColumn) {
	fields = c('ProgramCIPCode', 
			'EducationalProgramType', 
			'EducationalProgramName', 
			'EducationalAwardLevel', 
			'Ethnicity', 
			'Gender')
	mapping = data.frame(MappedColumn=rep(NA, length(fields)), row.names=fields)
	mapping['ProgramCIPCode', 'MappedColumn'] = programCIPCode
	mapping['EducationalProgramType', 'MappedColumn'] = educationalProgramType
	mapping['EducationalProgramName', 'MappedColumn'] = educationalProgramName
	mapping['EducationalAwardLevel', 'MappedColumn'] = educationalAwardLevel
	mapping['Ethnicity', 'MappedColumn'] = ethnicityColumn
	mapping['Gender', 'MappedColumn'] = genderColumn
	mapping
}

