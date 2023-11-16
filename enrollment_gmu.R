#------------------------------------------------------
#    Enrollment Scrapping
#------------------------------------------------------

library(rvest)
library(dplyr)

url <- "https://oiep.gmu.edu/data-analytics-research/enrollment/enrollment-by-demographic/"

# Read the HTML content from the webpage
page <- read_html(url)


# Read the HTML content (replace 'html_text' with your HTML content)
html_content <- '<select name="MAJRABBR" id="MAJRABBR" style="width:260px; font-size:10px" onchange="javascript:callself()">

		 		<option value="ALL" selected="">All</option>
	  			
		 		<option value="ADVA">ADVANCE NOVA Partnership - ADVA</option>
	  			
		 		<option value="AE">Academic English - AE</option>
	  			
		 		<option value="ACCT">Accounting - ACCT</option>
	  			
		 		<option value="ACAN">Accounting Analytics - ACAN</option>
	  			
		 		<option value="ACGC">Accounting for Gov Contracts - ACGC</option>
	  			
		 		<option value="ACTS">Actuarial Sciences - ACTS</option>
	  			
		 		<option value="EDGC">Add-on Endrs Spec Ed Gen Curr - EDGC</option>
	  			
		 		<option value="ANPT">Adv Networking Protocols-TCOM - ANPT</option>
	  			
		 		<option value="ABS">Advanced Biomedical Sciences - ABS</option>
	  			
		 		<option value="CARA">Advanced Skills - CARA</option>
	  			
		 		<option value="ANTH">Anthropology - ANTH</option>
	  			
		 		<option value="ABAC">Applied Behavior Analysis - ABAC</option>
	  			
		 		<option value="ACS">Applied Computer Science - ACS</option>
	  			
		 		<option value="ACBS">Applied Cyber Security - ACBS</option>
	  			
		 		<option value="AIOP">Applied Industrial and Organizational Psychology - AIOP</option>
	  			
		 		<option value="AIT">Applied Information Technology - AIT</option>
	  			
		 		<option value="APSY">Applied Psychology - APSY</option>
	  			
		 		<option value="APLS">Applied Science - APLS</option>
	  			
		 		<option value="ASTA">Applied Statistics - ASTA</option>
	  			
		 		<option value="PHAE">Applied and Engineering Physics - PHAE</option>
	  			
		 		<option value="ARTE">Art Education - ARTE</option>
	  			
		 		<option value="ARTL">Art Education Licensure - ARTL</option>
	  			
		 		<option value="AH">Art History - AH</option>
	  			
		 		<option value="AVT">Art and Visual Technology - AVT</option>
	  			
		 		<option value="ARTC">Artist Certificate - ARTC</option>
	  			
		 		<option value="AMGT">Arts Management - AMGT</option>
	  			
		 		<option value="AT">Assistive Technology - AT</option>
	  			
		 		<option value="ASTR">Astronomy - ASTR</option>
	  			
		 		<option value="ATT">Athletic Training - ATT</option>
	  			
		 		<option value="AOES">Atmospheric Sciences - AOES</option>
	  			
		 		<option value="ASD">Autism Spectrum Disorders - ASD</option>
	  			
		 		<option value="BIOD">Biodefense - BIOD</option>
	  			
		 		<option value="BIOE">Bioengineering - BIOE</option>
	  			
		 		<option value="BNFM">Bioinformatics Management - BNFM</option>
	  			
		 		<option value="BCB">Bioinformatics and Computational Biology - BCB</option>
	  			
		 		<option value="BIOL">Biology - BIOL</option>
	  			
		 		<option value="BIOS">Biosciences - BIOS</option>
	  			
		 		<option value="BSTA">Biostatistics - BSTA</option>
	  			
		 		<option value="BVI">Blind/Visual Impair PK12 Licen - BVI</option>
	  			
		 		<option value="BUS">Business - BUS</option>
	  			
		 		<option value="BUAD">Business Administration - BUAD</option>
	  			
		 		<option value="BUSA">Business Analytics - BUSA</option>
	  			
		 		<option value="BUSF">Business Fundamentals - BUSF</option>
	  			
		 		<option value="CMB">Cell and Molecular Biology - CMB</option>
	  			
		 		<option value="CBCM">Chemistry &amp; Biochemistry - CBCM</option>
	  			
		 		<option value="CHEM">Chemistry - CHEM</option>
	  			
		 		<option value="CEIE">Civil and Infrastructure Engr - CEIE</option>
	  			
		 		<option value="CLIM">Climate Dynamics - CLIM</option>
	  			
		 		<option value="CLIS">Climate Science - CLIS</option>
	  			
		 		<option value="CNEU">Cognitive Neuroscience - CNEU</option>
	  			
		 		<option value="CTCH">College Teaching - CTCH</option>
	  			
		 		<option value="COM">Communication - COM</option>
	  			
		 		<option value="COMH">Community Health - COMH</option>
	  			
		 		<option value="CDS">Computational &amp; Data Sciences - CDS</option>
	  			
		 		<option value="COMP">Computational Science - COMP</option>
	  			
		 		<option value="CSIM">Computational Science - CSIM</option>
	  			
		 		<option value="CSI">Computational Sciences and Informatics - CSI</option>
	  			
		 		<option value="CSS">Computational Social Science - CSS</option>
	  			
		 		<option value="CPE">Computer Engineering - CPE</option>
	  			
		 		<option value="CFRS">Computer Forensics - CFRS</option>
	  			
		 		<option value="GAME">Computer Game Design - GAME</option>
	  			
		 		<option value="CS">Computer Science - CS</option>
	  			
		 		<option value="CMFD">Computing Foundations - CMFD</option>
	  			
		 		<option value="CONF">Conflict Analysis and Resolution - CONF</option>
	  			
		 		<option value="CDRE">Contemporary Dispute Rsltn - CDRE</option>
	  			
		 		<option value="CNSL">Counseling - CNSL</option>
	  			
		 		<option value="CNDV">Counseling and Development - CNDV</option>
	  			
		 		<option value="CW">Creative Writing - CW</option>
	  			
		 		<option value="CJUS">Criminal Justice - CJUS</option>
	  			
		 		<option value="CLS">Criminology, Law and Society - CLS</option>
	  			
		 		<option value="CULT">Cultural Studies - CULT</option>
	  			
		 		<option value="CRIN">Curriculum and Instruction - CRIN</option>
	  			
		 		<option value="CYSE">Cyber Security Engineering - CYSE</option>
	  			
		 		<option value="CINS">Cyber, Intelligence &amp; Ntnl Sec - CINS</option>
	  			
		 		<option value="DANC">Dance - DANC</option>
	  			
		 		<option value="DNIC">Data Analytics - DNIC</option>
	  			
		 		<option value="DAEN">Data Analytics Engineering - DAEN</option>
	  			
		 		<option value="DSCI">Data Science - DSCI</option>
	  			
		 		<option value="DFOR">Digital Forensics - DFOR</option>
	  			
		 		<option value="DPH">Digital Public Humanities - DPH</option>
	  			
		 		<option value="ESLP">ESOL for PK-12 Practitioners - ESLP</option>
	  			
		 		<option value="EPK3">Early Childhood Ed-PK3 - EPK3</option>
	  			
		 		<option value="ECDL">Early Childhood Education Div Learners - ECDL</option>
	  			
		 		<option value="SPEC">Early Childhood Special Education - SPEC</option>
	  			
		 		<option value="ESCI">Earth Science - ESCI</option>
	  			
		 		<option value="ESSC">Earth Systems Science - ESSC</option>
	  			
		 		<option value="ESGS">Earth Systems and Geoinformation Sciences - ESGS</option>
	  			
		 		<option value="ECON">Economics - ECON</option>
	  			
		 		<option value="EAED">Ed Assesmnt Eval &amp; Data Litrcy - EAED</option>
	  			
		 		<option value="EDUC">Education - EDUC</option>
	  			
		 		<option value="EDLE">Education Leadership - EDLE</option>
	  			
		 		<option value="EPOL">Education Policy - EPOL</option>
	  			
		 		<option value="EDP">Educational Psychology - EDP</option>
	  			
		 		<option value="ELEN">Electrical Engineering - ELEN</option>
	  			
		 		<option value="ECE">Electrical and Computer Engineering - ECE</option>
	  			
		 		<option value="ELED">Elementary Education - ELED</option>
	  			
		 		<option value="ENGL">English - ENGL</option>
	  			
		 		<option value="EGBC">Environmental GIS and Biodiversity Conservation - EGBC</option>
	  			
		 		<option value="EVSC">Environmental Science - EVSC</option>
	  			
		 		<option value="EVSP">Environmental Science and Policy - EVSP</option>
	  			
		 		<option value="EVPP">Environmental Science and Public Policy - EVPP</option>
	  			
		 		<option value="EVSS">Environmental and Sustainability Studies - EVSS</option>
	  			
		 		<option value="EXPL">Exploratory - EXPL</option>
	  			
		 		<option value="FAVS">Film and Video Studies - FAVS</option>
	  			
		 		<option value="FNAN">Finance - FNAN</option>
	  			
		 		<option value="FLNC">Foreign Language Licensure - FLNC</option>
	  			
		 		<option value="FRLN">Foreign Languages - FRLN</option>
	  			
		 		<option value="FACC">Forensic Accounting - FACC</option>
	  			
		 		<option value="FRSC">Forensic Science - FRSC</option>
	  			
		 		<option value="FORS">Forensics - FORS</option>
	  			
		 		<option value="GECA">Geographic &amp; Cartographic Sciences - GECA</option>
	  			
		 		<option value="GISC">Geographic Information Science - GISC</option>
	  			
		 		<option value="GEOG">Geography - GEOG</option>
	  			
		 		<option value="GEOI">Geoinformatics and Geospatial Intelligence - GEOI</option>
	  			
		 		<option value="GEOL">Geology - GEOL</option>
	  			
		 		<option value="GI">Geospatial Intelligence - GI</option>
	  			
		 		<option value="EDGE">Gifted Education - EDGE</option>
	  			
		 		<option value="GLOA">Global Affairs - GLOA</option>
	  			
		 		<option value="LAWG">Global Antitrust Law &amp; Econmcs - LAWG</option>
	  			
		 		<option value="GCPO">Global Commerce and Policy - GCPO</option>
	  			
		 		<option value="GLOH">Global Health - GLOH</option>
	  			
		 		<option value="GACT">Government Accounting - GACT</option>
	  			
		 		<option value="GVIP">Government and International Politics - GVIP</option>
	  			
		 		<option value="GD">Graphic Design - GD</option>
	  			
		 		<option value="GM">Guest Matriculant - GM</option>
	  			
		 		<option value="HADM">Health Administration - HADM</option>
	  			
		 		<option value="HINF">Health Informatics - HINF</option>
	  			
		 		<option value="HSR">Health Services Research - HSR</option>
	  			
		 		<option value="HSMG">Health Systems Management - HSMG</option>
	  			
		 		<option value="HMP">Health and Medical Policy - HMP</option>
	  			
		 		<option value="HFRR">Health, Fitness &amp; Recreation Resources - HFRR</option>
	  			
		 		<option value="HSGR">High School Guest Registration - HSGR</option>
	  			
		 		<option value="HESD">Higher Ed and Student Dvlopmnt - HESD</option>
	  			
		 		<option value="HIST">History - HIST</option>
	  			
		 		<option value="HIDA">Hlth Infmatics and Data Analyt - HIDA</option>
	  			
		 		<option value="HDFS">Human Devl and Family Science - HDFS</option>
	  			
		 		<option value="ILTA">Illicit Trade Analysis - ILTA</option>
	  			
		 		<option value="INDV">Individualized Study - INDV</option>
	  			
		 		<option value="ISCI">Information Sciences - ISCI</option>
	  			
		 		<option value="ISA">Information Security and Assurance - ISA</option>
	  			
		 		<option value="ISOM">Information Systems &amp; Ops Mgmt - ISOM</option>
	  			
		 		<option value="ISYS">Information Systems - ISYS</option>
	  			
		 		<option value="INFT">Information Technology - INFT</option>
	  			
		 		<option value="INTS">Integrative Studies - INTS</option>
	  			
		 		<option value="LAWN">Intellectual Property - LAWN</option>
	  			
		 		<option value="ISIN">Interdisciplinary Studies, (Individualized) - ISIN</option>
	  			
		 		<option value="ICP">International Commerce and Policy - ICP</option>
	  			
		 		<option value="ISLW">International Security &amp; Law - ISLW</option>
	  			
		 		<option value="INLS">International Security - INLS</option>
	  			
		 		<option value="ISE">International Student Exchange - ISE</option>
	  			
		 		<option value="KNES">Kinesiology - KNES</option>
	  			
		 		<option value="LAS">Latin American Studies - LAS</option>
	  			
		 		<option value="LAW">Law - LAW</option>
	  			
		 		<option value="LAWM">Law - LAWM</option>
	  			
		 		<option value="NDLU">Law School - Non-Degree - NDLU</option>
	  			
		 		<option value="LDTC">Learning Design &amp; Technology - LDTC</option>
	  			
		 		<option value="LTCH">Learning Technologies - LTCH</option>
	  			
		 		<option value="LING">Linguistics - LING</option>
	  			
		 		<option value="LITE">Linguistics: Teaching English to Speakers of Other Languages  - LITE</option>
	  			
		 		<option value="LRIN">Literacy/Reading Instruction - LRIN</option>
	  			
		 		<option value="LTCO">Literature and Composition - LTCO</option>
	  			
		 		<option value="MGMT">Management - MGMT</option>
	  			
		 		<option value="MKTG">Marketing - MKTG</option>
	  			
		 		<option value="MAGP">Mass Atrocity &amp; Genocide Prev - MAGP</option>
	  			
		 		<option value="MATH">Mathematics - MATH</option>
	  			
		 		<option value="ME">Mechanical Engineering - ME</option>
	  			
		 		<option value="MLAB">Medical Laboratory Science - MLAB</option>
	  			
		 		<option value="MEIS">Middle East &amp; Islamic Studies - MEIS</option>
	  			
		 		<option value="MUSI">Music - MUSI</option>
	  			
		 		<option value="MUE">Music Education - MUE</option>
	  			
		 		<option value="MELP">Music Education Licensure PK12 - MELP</option>
	  			
		 		<option value="MUAR">Musical Arts - MUAR</option>
	  			
		 		<option value="NSP">National Security and Public Policy - NSP</option>
	  			
		 		<option value="NSDN">Naval Ship Design - NSDN</option>
	  			
		 		<option value="NEUR">Neuroscience - NEUR</option>
	  			
		 		<option value="NDCC">Non-Degree Contract Course - NDCC</option>
	  			
		 		<option value="NPMG">Nonprofit Management - NPMG</option>
	  			
		 		<option value="NURS">Nursing - NURS</option>
	  			
		 		<option value="NUTR">Nutrition - NUTR</option>
	  			
		 		<option value="OPRS">Operations Research - OPRS</option>
	  			
		 		<option value="ODKM">Organization Development and Knowledge Management - ODKM</option>
	  			
		 		<option value="PPKR">Patriot Pathway Korea - PPKR</option>
	  			
		 		<option value="PRSM">Personalized Medicine - PRSM</option>
	  			
		 		<option value="PHIL">Philosophy - PHIL</option>
	  			
		 		<option value="PHED">Physical Education - PHED</option>
	  			
		 		<option value="PHYS">Physics - PHYS</option>
	  			
		 		<option value="POS">Political Science - POS</option>
	  			
		 		<option value="PMCL">Pre-Medical - PMCL</option>
	  			
		 		<option value="PTW">Professional and Techncl Wrtng - PTW</option>
	  			
		 		<option value="PMHN">Psychiatric Mntl Hlth Nurs PC - PMHN</option>
	  			
		 		<option value="PSYC">Psychology - PSYC</option>
	  			
		 		<option value="PUAD">Public Administration - PUAD</option>
	  			
		 		<option value="PUBH">Public Health - PUBH</option>
	  			
		 		<option value="PMG">Public Management - PMG</option>
	  			
		 		<option value="PUBP">Public Policy - PUBP</option>
	  			
		 		<option value="REAL">Real Estate Development - REAL</option>
	  			
		 		<option value="RMGT">Recreation Management - RMGT</option>
	  			
		 		<option value="RELI">Religious Studies - RELI</option>
	  			
		 		<option value="RESM">Research Methods - RESM</option>
	  			
		 		<option value="REST">Russian &amp; Eurasian Studies - REST</option>
	  			
		 		<option value="ZSNY">SUNY - Korea - ZSNY</option>
	  			
		 		<option value="SCH">School Psychology - SCH</option>
	  			
		 		<option value="STS">Science, Tchnlgy, &amp; Security - STS</option>
	  			
		 		<option value="SELC">Secondary Education Licensure - SELC</option>
	  			
		 		<option value="SSEN">Small Satellite Engineering - SSEN</option>
	  			
		 		<option value="SOCW">Social Work - SOCW</option>
	  			
		 		<option value="SOCI">Sociology - SOCI</option>
	  			
		 		<option value="SWE">Software Engineering - SWE</option>
	  			
		 		<option value="SHLE">Spanish Language Heritage Education - SHLE</option>
	  			
		 		<option value="EDSE">Special Education - EDSE</option>
	  			
		 		<option value="COMM">Speech Communication - COMM</option>
	  			
		 		<option value="SPMG">Sport Management - SPMG</option>
	  			
		 		<option value="SRST">Sport and Recreation Studies - SRST</option>
	  			
		 		<option value="STAT">Statistical Science - STAT</option>
	  			
		 		<option value="STIC">Statistics - STIC</option>
	  			
		 		<option value="STTR">Strategic Trade - STTR</option>
	  			
		 		<option value="SSIE">Systems &amp; Industrial Enginrng - SSIE</option>
	  			
		 		<option value="SYST">Systems Engineering - SYST</option>
	  			
		 		<option value="SEOR">Systems Engineering and Operations Research - SEOR</option>
	  			
		 		<option value="TESL">Teaching English as Second Language - TESL</option>
	  			
		 		<option value="THRP">Teaching Theatre PK-12 - THRP</option>
	  			
		 		<option value="TECM">Technology Management - TECM</option>
	  			
		 		<option value="TCOM">Telecommunications - TCOM</option>
	  			
		 		<option value="TRHS">Terrorism &amp; Homeland Security - TRHS</option>
	  			
		 		<option value="THR">Theater - THR</option>
	  			
		 		<option value="TEM">Tourism and Events Management - TEM</option>
	  			
		 		<option value="LAWU">U.S. Law - LAWU</option>
	  			
		 		<option value="UNDC">Undecided - UNDC</option>
	  			
		 		<option value="UNDE">Undeclared - UNDE</option>
	  			
		 		<option value="ZUMW">University of Mary Washington - ZUMW</option>
	  			
		 		<option value="VCON">Virginia Consortium - VCON</option>
	  			
		 		<option value="VPA">Visual and Performing Arts - VPA</option>
	  			
		 		<option value="WCON">Washington Consortium - WCON</option>
	  			
		 		<option value="WGST">Women and Gender Studies - WGST</option>
	  			
		 		<option value="WRTR">Writing and Rhetoric - WRTR</option>
	  			</select>'

page <- read_html(html_content)

dropdown_menu <- page %>% html_node("#MAJRABBR")

options <- dropdown_menu %>% html_nodes("option") # all options?

option_values <- options %>% html_attr("value")
option_texts <- options %>% html_text()

specific_option <- dropdown_menu %>% 
  html_nodes("option[value='GLOA']") ##### choose the program
specific_option_text <- specific_option %>% 
  html_text()

# print(specific_option_text) ### sanity check

table_data <- page %>%
  html_nodes(".table-class") %>%
  html_table()

if (length(table_data) > 0) {
  table_df <- table_data[[1]] %>%
    # Perform dplyr operations here
    # For instance, select specific columns using select()
    select(column_name_1, column_name_2)
  
  # Print or further process the resulting data frame
  print(table_df)
} else {
  print("No table found")
}

