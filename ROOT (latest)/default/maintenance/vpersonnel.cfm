<html>
<head>
<title>View Users</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfset target_table = iif(url.type eq "customer",DE(target_arcust),DE(target_apvend))>

<!--- Add On 11-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
</cfquery>

<cfquery name="getgeneral" datasource="#dts#">
select agentlistuserid from gsetup
</cfquery>

<cfif isdefined("url.type")>
	<cfset typeNo="cust" & "No"> 
	<cfset link = url.type &".cfm">

	<!--- <cfquery datasource='#dts#' name="getPersonnel">
		Select * from #target_table# order by #typeNo#
	</cfquery> --->
	<cfset type = url.type>
<cfelse>
	<cfset typeNo= type & "No"> 
	<cfset link = type &".cfm">

	<!--- <cfquery datasource='#dts#' name="getPersonnel">
		Select * from #target_table# <cfif url.type eq 'Customer' and getpin2.h1250 eq 'T'>where agent = '#huserid#'</cfif>order by #typeNo#
	</cfquery> --->	
</cfif>

<cfquery datasource='#dts#' name="getPersonnel">
	Select #typeNo#,Name,Name2,Add1,Add2,Add3,Add4,Attn,phone,phonea,fax,e_mail,web_site from #target_table#  where 0=0
	<cfif url.type eq 'Customer' and getpin2.h1250 eq 'T'>and agent = '#huserid#'</cfif>
    <cfif url.type eq "Customer" and getpin2.h1t00 eq 'T'>
<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(agent)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
                     <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                     <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                    </cfif>
                    </cfif>
	order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>#typeNo#</cfif>
</cfquery>	
			
<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">
<cfif husergrpid eq "Muser"><a href="../home2.cfm"><u>Home</u></a></cfif>
	<cfoutput><h1>View #Type# Informations</h1></cfoutput>
	<cfoutput>
	<cfif type eq 'Customer'>
		<h4>
			<cfif getpin2.h1210 eq 'T'><a href="#link#?type=Create"> Creating a New #type#</a> </cfif>
			<cfif getpin2.h1220 eq 'T'>|| <a href="vPersonnel.cfm?type=#url.type#">List all #type#</a> </cfif>
			<cfif getpin2.h1230 eq 'T'>|| <a href="linkPage.cfm?type=#url.type#">Search #type#</a> </cfif>
			<cfif getpin2.h1240 eq 'T'>|| <a href="p_suppcust.cfm?type=#url.type#">#type# Listing</a></cfif>
			|| <a href="printlabel.cfm?type=Customer">Print Customer Labels</a>
			<!--- <cfif #url.type# eq 'Customer'>
			|| <a href="psuppcust.cfm?type=Customer" target="_blank">Customer Summary Report</a>
			</cfif> --->
		</h4>
	<cfelse>
		<h4>
			<cfif getpin2.h1110 eq 'T'><a href="#link#?type=Create"> Creating a New #type#</a> </cfif>
			<cfif getpin2.h1120 eq 'T'>|| <a href="vPersonnel.cfm?type=#url.type#">List all #type#</a> </cfif>
			<cfif getpin2.h1130 eq 'T'>|| <a href="linkPage.cfm?type=#url.type#">Search #type#</a> </cfif>
			<cfif getpin2.h1140 eq 'T'>|| <a href="p_suppcust.cfm?type=#url.type#">#type# Listing</a></cfif>
			|| <a href="printlabel.cfm?type=Supplier">Print Supplier Labels</a>
			<!--- <cfif #url.type# eq 'Customer'>
			|| <a href="psuppcust.cfm?type=Customer" target="_blank">Customer Summary Report</a>
			</cfif> --->
		</h4>
	</cfif> 
	</cfoutput>
			
	<cfif #getPersonnel.recordcount# neq 0>
		<cfif isdefined("form.skeypage")>
  			<cfset noOfPage=round(#getPersonnel.recordcount#/5)>
			<cfif #getPersonnel.recordcount# mod 5 LT 3 and #getPersonnel.recordcount# mod 5 neq 0>
				<cfset noOfPage=#noOfPage#+1>
			</cfif>
			<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
				<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
				<cfabort>
			</cfif>
 		</cfif>
		<cfform action="vpersonnel.cfm?type=#type#" method="post">
			<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
				
			<cfset noOfPage=round(#getPersonnel.recordcount#/5)>
				
			<cfif #getPersonnel.recordcount# mod 5 LT 3 and #getPersonnel.recordcount# mod 5 neq 0>
				<cfset noOfPage=#noOfPage#+1>
			</cfif>
				
			<cfif isdefined("url.start")>
				<cfset start=#url.start#>
			</cfif>
			<cfif isdefined("form.skeypage")>				
				<cfset start = #form.skeypage# * 5 + 1 - 5>				
				<cfif form.skeypage eq "1">
					<cfset start = "1">					
				</cfif>  				
			</cfif> 
				
			<cfset prevFive=#start# -5>
			<cfset nextFive=#start# +5>
			<cfset page=round(#nextFive#/5)>
				
			<cfif #start# neq 1>
				<cfoutput>|| <a href="vPersonnel.cfm?type=#url.type#&start=#prevFive#">Previous</a> ||</cfoutput>
			</cfif>
					
			<cfif #page# neq #noOfPage#>
				<cfoutput> <a href="vPersonnel.cfm?type=#url.type#&start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
			</cfif>
					
			<cfoutput>Page #page# Of #noOfPage#</cfoutput>
			</div>
			
			<hr>
			
			<cfif isdefined("url.process")>
				<cfoutput><h1>#form.status#</h1><hr></cfoutput>
			</cfif>
			
			<cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
			<cfset strNo = "getPersonnel." & #typeNo#>
				
      		<table align="center" class="data" width="500px">
        		<tr> 
          			<th width="20%">#Url.Type# No</th>
          			<td>#evaluate(strNo)#</td>
        		</tr>
		        <tr> 
		          <th>Name</th>
		          <td>#getPersonnel.Name#<br> #getPersonnel.Name2#</td>
		        </tr>
		        <tr> 
		          <th>Address</th>
		          <td>#getPersonnel.Add1#<br> #getPersonnel.Add2#<br> #getPersonnel.Add3#<br> #getPersonnel.Add4#</td>
		        </tr>
		        <tr> 
		          <th>Attention</th>
		          <td>#getPersonnel.Attn#</td>
		        </tr>
		        <tr> 
		          <th>Telephone</th>
		          <td>#getPersonnel.phone#<br> #getPersonnel.phonea#</td>
		        </tr>
		        <tr> 
		          <th>Fax</th>
		          <td>#getPersonnel.fax#</td>
		        </tr>
		        <tr> 
		          <th>Email</th>
		          <td>#getPersonnel.e_mail#</td>
		        </tr>
				<cfif lcase(HcomID) eq "ge_i" or lcase(HcomID) eq "saehan_i" or lcase(HcomID) eq "idi_i" or lcase(HcomID) eq "gwa_i">
					<tr> 
		         		<th>Website</th>
		          		<td>
							<cfif getPersonnel.web_site neq "">
								<cfif findnocase("http://",getPersonnel.web_site) eq 0>
									<cfset getPersonnel.web_site = "http://"&getPersonnel.web_site>
								</cfif>
								<a href="#getPersonnel.web_site#" target="_blank">#getPersonnel.web_site#</a>
							</cfif>
						</td>
		        	</tr>
				</cfif>
				<cfif type eq 'Customer'>
					<cfif getpin2.h1211 eq 'T'>
						<tr> 
							<td colspan="2"> <div align="right"><a href="#link#?type=Delete&#typeNo#=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0"> 
							Delete</a> <a href="#link#?type=Edit&#typeNo#=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a> 
							</div></td>
						</tr>
					</cfif>
				<cfelse>
					<cfif getpin2.h1111 eq 'T'>
						<tr> 
				          	<td colspan="2"> <div align="right"><a href="#link#?type=Delete&#typeNo#=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0"> 
				              Delete</a> <a href="#link#?type=Edit&#typeNo#=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a> 
				            </div></td>
				        </tr>
					</cfif>
				</cfif>
      		</table>	
			<br>
			<hr>
		</cfoutput>
		</cfform>
		<div align="right">
			
		<cfif #start# neq 1>
			<cfoutput>|| <a href="vPersonnel.cfm?type=#url.type#&start=#prevFive#">Previous</a> ||</cfoutput>
		</cfif>
				
		<cfif #page# neq #noOfPage#>
			<cfoutput> <a href="vPersonnel.cfm?type=#url.type#&start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
		</cfif>
				
		<cfoutput>Page #page# Of #noOfPage#</cfoutput>
		</div>
			
		<hr>
	<cfelse>
		<h3>Sorry, No records were found.</h3>
	</cfif>			
</body>
</html>
