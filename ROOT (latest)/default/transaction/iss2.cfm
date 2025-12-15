<cfquery name="gettranname" datasource="#dts#">
select lconsignin,lconsignout,lISS,lOAI,lOAR from gsetup
</cfquery> 

<cfif tran eq "ISS">
	<cfset tran = "ISS">
	<cfset tranname = gettranname.lISS>
	<cfset trancode = "issno">
	<cfset tranarun = "issarun">
<cfelseif tran eq "TR">
	<cfset tran = "TR">
    
    <cfif isdefined('consignment')>
    <cfif consignment eq "out">

    <cfset tranname = "#gettranname.lconsignout#">

	<cfset trancode = "trno">
    <cfset tranarun = "trarun">
    <cfelseif consignment eq "return">
    <cfset tranname = "#gettranname.lconsignin#">
	<cfset trancode = "trno">
    <cfset tranarun = "trarun">
    <cfelse>
    <cfset tranname = "Transfer">
	<cfset trancode = "trno">
	<cfset tranarun = "trarun">
    </cfif>
    <cfelse>
	<cfset tranname = "Transfer">
	<cfset trancode = "trno">
	<cfset tranarun = "trarun">
    </cfif>
<cfelseif tran eq "OAI">
	<cfset tran = "OAI">
	<cfset tranname = gettranname.lOAI>
	<cfset trancode = "oaino">
	<cfset tranarun = "oaiarun">
<cfelseif tran eq "OAR">
	<cfset tran = "OAR">
	<cfset tranname = gettranname.lOAR>
	<cfset trancode = "oarno">
	<cfset tranarun = "oararun">	
</cfif>
<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfif isdefined('consignment')>
<cfset consignment = consignment>
<cfelse>
<cfset consignment = ''>
</cfif>

<!--- REMARK ON 240608 AND REPLACE WITH THE BELOW ONE --->
<!---cfquery datasource="#dts#" name="getGeneralInfo">
	select #trancode# as tranno, #tranarun# as arun from GSetup
</cfquery--->

<cfif isdefined("form.invset") or isdefined("invset") and invset neq 0>
	<!--- <cfquery datasource="main" name="getGeneralInfo">
		select lastUsedNo as tranno, refnoused as arun from refnoset
		where userDept = '#dts#'
		and type = '#tran#'
		and counter = '#invset#'
	</cfquery> --->
	<cfquery datasource="#dts#" name="getGeneralInfo">
		select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse 
        from refnoset
		where type = '#tran#'
		and counter = '#invset#'
	</cfquery>
	<cfset counter = invset>
<cfelse>
	<!--- <cfquery datasource="main" name="getGeneralInfo">
		select lastUsedNo as tranno, refnoused as arun from refnoset
		where userDept = '#dts#'
		and type = '#tran#'
		and counter = 1
	</cfquery> --->
	<cfquery datasource="#dts#" name="getGeneralInfo">
		select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse 
        from refnoset
		where type = '#tran#'
		and counter = 1
	</cfquery>
	<cfset invset = 1>
	<cfset counter = 1>
</cfif>


<html>
<head>
<title><cfoutput>#tranname#</cfoutput></title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<cfquery name="getlocation_customer_term" datasource="#dts#">
	select a.location,a.custno,(select term from #target_arcust# where custno=a.custno) as term
	from iclocation as a 
	order by a.custno;
</cfquery>


<script language="JavaScript">
function searchSel(fieldid,textid) {
  var input=document.getElementById(textid).value.toLowerCase();
  var output=document.getElementById(fieldid).options;
  for(var i=0;i<output.length;i++) {
    if(output[i].text.toLowerCase().indexOf(input)>=0 && i != 0){
      output[i].selected=true;
	  break;
      }
    if(document.getElementById(textid).value==''){
      output[0].selected=true;
      }
  }
}
	function changeterm()
	{
		<cfoutput query="getlocation_customer_term">
		<cfif getlocation_customer_term.custno neq ''>
			if(document.invoicesheet.trto.value=="#getlocation_customer_term.location#"){
				document.invoicesheet.term1.value="#getlocation_customer_term.term#";}
				
		<cfelse>
		document.invoicesheet.term1.value="";
		</cfif>
				
		</cfoutput>
		
	}
	function test()
	{
		try{
		if(document.invoicesheet.custno.value=='')
		{
			alert("Your Authorised By cannot be blank.");
			document.invoicesheet.custno.focus();
			return false;
		}
		}
		catch(err)
		{
		}
		try{
		if(document.invoicesheet.trfrom.value=='')
		{
			alert("Your Location From cannot be blank.");
			document.invoicesheet.trfrom.focus();
			return false;
		}
		}
		catch(err)
		{
		}
		try{
		if(document.invoicesheet.trto.value=='')
		{
			alert("Your Location To cannot be blank.");
			document.invoicesheet.trto.focus();
			return false;
		}
		}
		catch(err)
		{
		}
		try{
		if(document.invoicesheet.trfrom.value==document.invoicesheet.trto.value)
		{
			alert("Your Location From cannot same as Location To.");
			document.invoicesheet.trto.focus();
			return false;
		}
		}
		catch(err)
		{
		}
		return true;
	}	
</script>
</head>

<body>
<cfquery datasource="#dts#" name="getGsetup">
	Select #trancode# as result, iss_oneset, tr_oneset, oai_oneset, oar_oneset,jobbyitem,
	rem5,rem6,rem7,rem8,projectbybill,keepDeletedBills,lAGENT,lPROJECT,lJOB,custissue,ddllocation,addonremark
	from GSetup
</cfquery>

<cfquery name="getagent" datasource="#dts#">
	select agent,desp from icagent where 0=0 and (discontinueagent='' or discontinueagent is null) order by agent
</cfquery>

<cfquery name="getterm" datasource="#dts#">
	select term,desp from #target_icterm#;
</cfquery>

<!--- ADD ON 10-12-2009 --->
<cfif getGsetup.projectbybill eq "1" or getGsetup.jobbyitem eq "Y">
	<cfquery name="getProject" datasource="#dts#">
		select * from project where porj = "P" order by source
	</cfquery>
	
	<cfquery name="getJob" datasource="#dts#">
		select * from project where porj = "J" order by source
	</cfquery>
</cfif>

<cfif url.ttype eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		select * from artran where refno='#url.refno#' and type = "#tran#"
	</cfquery>
	
	<cfset wos_type=getitem.type>
	<cfset custno=getitem.custno>
	<cfset name=getitem.name>
	<cfset readpreiod=getitem.fperiod>
	<cfset nDateCreate=getitem.wos_date>
	<cfset desp=getitem.desp>
	<cfset despa=getitem.despa>
	<cfset xagenno=getitem.agenno>
    <cfset xsource = getitem.source>	<!--- ADD ON 25-11-2009 --->
    <cfset xjob = getitem.job>			<!--- ADD ON 25-11-2009 --->
	<cfset xterm=getitem.term>
	<cfset remark0=getitem.rem0>		
	<cfset remark1=getitem.rem1>
	<cfset remark2=getitem.rem2>
	<cfset remark3=getitem.rem3>
	<cfset remark4=getitem.rem4>
	<cfset remark5=getitem.rem5>
	<cfset remark6=getitem.rem6>
	<cfset remark7=getitem.rem7>
	<cfset remark8=getitem.rem8>
	<cfset remark9=getitem.rem9>
	<cfset remark10=getitem.rem10>
	<cfset remark11=getitem.rem11>
	<cfset remark12=getitem.rem12>
	<cfset comm1=getitem.comm1>
	<cfset userid=getitem.userid>
	<cfset nexttranno=url.refno>
	<cfset mode="Delete">
	<cfset title="Mode = Delete">
	<cfset button="Delete">
</cfif>	

<cfif url.ttype eq "Create">
	<cfset custno="">
	<cfset name="">		
	<cfset readpreiod="">
	<cfset nDateCreate="">
	<cfset desp="">
	<cfset despa="">
	<cfset xagenno="">	
    <cfset xsource="">	<!--- ADD ON 25-11-2009 --->
    <cfset xjob="">			<!--- ADD ON 25-11-2009 --->	
	<cfset xterm="">
	<cfset remark0="">		
	<cfset remark1="">
	<cfset remark2="">
	<cfset remark3="">
	<cfset remark4="">
	<cfset remark5="">
	<cfset remark6="">
	<cfset remark7="">
	<cfset remark8="">
	<cfset remark9="">
	<cfset remark10="">
	<cfset remark11="">
	<cfset remark12="">
	<cfset comm1="">
	<cfset userid="">
	<cfset mode="Create">
	<cfset title="Mode = Create">
	<cfset button="Create">

	<cfif getGeneralInfo.arun eq "1">
		<cfset refnocnt = len(getGeneralInfo.tranno)>	
		<cfset cnt = 0>
		<cfset yes = 0>
		
		<cfloop condition = "cnt lte refnocnt and yes eq 0">
			<cfset cnt = cnt + 1>			
			
			<cfif isnumeric(mid(getGeneralInfo.tranno,cnt,1))>				
				<cfset yes = 1>			
			</cfif>								
		</cfloop>
			
		<cfset nolen = refnocnt - cnt + 1>
		<cfset nextno = right(getGeneralInfo.tranno,nolen) + 1>
		<cfset nocnt = 1>
		<cfset zero = "">
		
		<cfloop condition = "nocnt lte nolen">
			<cfset zero = zero & "0">
			<cfset nocnt = nocnt + 1>	
		</cfloop>
					
		<cfif tran eq 'SO' or tran eq 'PO' or tran eq 'QUO'>
			<cfset limit = 24>
		<cfelse>
			<cfset limit = 10>
		</cfif>
		
		<cfif cnt gt 1>
			<cfset nexttranno = left(getGeneralInfo.tranno,cnt-1)&numberformat(nextno,zero)>
			
			<cfif len(nexttranno) gt limit>
				<cfset nexttranno = '99999999'>
			</cfif>
		<cfelse>
			<cfset nexttranno = numberformat(nextno,zero)> 
			
			<cfif len(nexttranno) gt limit>
				<cfset nexttranno = '99999999'>
			</cfif>
		</cfif>
		
		<cfif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "chemline_i">
			<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
			<cfset nexttranno = newnextNum>
        <cfelse>
        	<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
        	<cfset actual_nexttranno = newnextNum>
            <cfif (getGeneralInfo.refnocode2 neq "" or getGeneralInfo.refnocode neq "") and getGeneralInfo.presuffixuse eq "1">
				<cfset nexttranno = getGeneralInfo.refnocode&actual_nexttranno&getGeneralInfo.refnocode2>
            <cfelse>
            	<cfset nexttranno = actual_nexttranno>
			</cfif>
		</cfif>
	</cfif>	
</cfif>	

<cfif url.ttype eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		select * from artran where refno='#url.refno#' and type = "#tran#"
	</cfquery>
	
	<cfset custno=getitem.custno>
	<cfset name=getitem.name>
	<cfset wos_type=getitem.type>
	<cfset readpreiod=getitem.fperiod>
	<cfset nDateCreate=getitem.wos_date>
	<cfset desp=getitem.desp>
	<cfset despa=getitem.despa>
	<!--- <cfset term=#getitem.term#> --->
	<cfset xagenno=getitem.agenno>
    <cfset xsource = getitem.source>	<!--- ADD ON 25-11-2009 --->
    <cfset xjob = getitem.job>			<!--- ADD ON 25-11-2009 --->
	<cfset xterm=getitem.term>
	<!--- <cfset pono=#getitem.pono#> --->
	<cfset remark0=getitem.rem0>		
	<cfset remark1=getitem.rem1>
	<cfset remark2=getitem.rem2>
	<cfset remark3=getitem.rem3>
	<cfset remark4=getitem.rem4>
	<cfset remark5=getitem.rem5>
	<cfset remark6=getitem.rem6>
	<cfset remark7=getitem.rem7>
	<cfset remark8=getitem.rem8>
	<cfset remark9=getitem.rem9>
	<cfset remark10=getitem.rem10>
	<cfset remark11=getitem.rem11>
	<cfset remark12=getitem.rem12>
	<cfset comm1=getitem.comm1>
	<cfset userid=getitem.userid>
	<cfset nexttranno=url.refno>
	<cfset mode="Edit">
	<cfset title="Mode = Edit ">
	<cfset button="Edit">
</cfif>	

<cfoutput>
<!--- <cfquery datasource="#dts#" name="getGsetup">
	Select #trancode# as result, iss_oneset, tr_oneset, oai_oneset, oar_oneset,rem5,rem6,rem7,rem8
	from GSetup
</cfquery> --->

<h4>
	<cfif getGsetup.iss_oneset neq '1' and tran eq 'ISS'>
		<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
	<cfelseif getGsetup.tr_oneset neq '1' and tran eq 'TR'>
		<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
	<cfelseif getGsetup.oai_oneset neq '1' and tran eq 'OAI'>
		<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
	<cfelseif getGsetup.oar_oneset neq '1' and tran eq 'OAR'>
		<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
	<cfelse>
		<a href="iss2.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> || 
	</cfif>
	<a href="iss.cfm?tran=#tran#">List all #tranname#</a> || 
	<a href="siss.cfm?tran=#tran#">Search For #tranname#</a>
</h4>

<cfif isdefined('url.jsoff')>
<cfset formname = "invoicesheetpost">
<cfset formid = "invoicesheetpost">
<cfelse>
<cfset formname = "invoicesheet">
<cfset formid = "invoicesheet">
</cfif>

<cfform name="#formname#" id="#formid#" action="iss3.cfm" method="post" onSubmit="return test();">
	<input type="hidden" name="type" value="#mode#">
	<input type="hidden" name="tran" value="#tran#">
    <input type="hidden" name="consignment" value="#consignment#">
	<input type="hidden" name="ttran" value="">
	<input type="hidden" name="invset" value="#listfirst(invset)#">
	<cfif url.ttype eq "Delete" or url.ttype eq "Edit">
		<input type="hidden" name="currefno" value="#url.refno#">
		<input type="hidden" name="nexttranno" value="#url.refno#">
	</cfif>
	
  	<table align="center" class="data">
		<tr> 
        	<th width="126"><cfif url.ttype eq "Create">Next </cfif> #tranname# No</th>
            <td width="234"><cfif url.ttype eq "Create">
            					<cfif getgeneralinfo.arun eq "1">
              						<h3>#nexttranno#</h3>
              					<cfelse>
              						<input name="nexttranno" type="text" size="10" maxlength="8">
            					</cfif>
            				<cfelse>
            					<h3>#nexttranno#</h3>
          					</cfif>
			</td>
        	<th width="115">Type </th>
        	<td width="177"><h2><cfif url.ttype eq "Create">
									New
								<cfelseif url.ttype eq "Delete"> 
									Delete
								<cfelseif url.ttype eq "Edit">
									Edit
								</cfif>
						   
								<cfif url.ttype eq "Edit">
									Edit 
								</cfif>
								#tranname#
							</h2>
			</td>
      	</tr>
   	 	<tr> 
      		<th>#tranname# Date</th>
      		<td><cfif url.ttype eq "Create">
          			<input type="text" name="invoicedate" size="10" value="#dateformat(now(),"dd/mm/yyyy")#" validate="eurodate" maxlength="10">(DD/MM/YYYY)
				<cfelse>
					<input type="text" name="invoicedate" size="10" value="#dateformat(nDateCreate,"dd/mm/yyyy")#" validate="eurodate" maxlength="10">(DD/MM/YYYY)
				</cfif>
			</td>
      		<td>&nbsp;</td>
      		<td>&nbsp;</td>
    	</tr>
    	<tr> 
      		<th>Authorised By</th>
      		<td><input type="text" name="custno" value="#custno#" maxlength="8"></td> 
          	<!--- REMARK ON 25-11-2009 --->
			<!--- <td></td>
      		<td></td> --->
			<th>#getGsetup.lAGENT#</th>
      		<td><select name="agenno" id="select">
          			<option value="">Choose a #getGsetup.lAGENT#</option>
          			<cfloop query="getagent"> 
            			<option value="#getagent.agent#"<cfif xagenno eq getagent.agent>Selected</cfif>>#getagent.agent# - #getagent.desp#</option>
          			</cfloop>
				</select>
			</td>
    	</tr>
    	<tr> 
      		<th>Reason for #tranname#</th>
            <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
            <td><input name="name" type="text" size="50" maxlength="60" value="#name#"></td>
            <cfelseif lcase(hcomid) eq "vsolutionspteltd_i">
            <td><input name="name" type="text" size="50" maxlength="80" value="#name#"></td>

            <cfelse>
      		<td><input name="name" type="text" size="50" maxlength="40" value="#name#"></td>
            </cfif>
			<!--- REMARK AND ADD THE PROJECT & JOB ON 25-11-2009 --->
			<!--- <th>Agent</th>
      		<td><select name="agenno" id="select">
          			<option value="">Choose a Agent</option>
          			<cfloop query="getagent"> 
            			<option value="#getagent.agent#"<cfif xagenno eq getagent.agent>Selected</cfif>>#getagent.agent# - #getagent.desp#</option>
          			</cfloop>
				</select>
			</td> --->
			<cfif getGsetup.projectbybill eq "1">
				<th><!--- Project / Job --->#getGsetup.lPROJECT# / #getGsetup.lJOB#</th>
	      		<td><select name="Source" id="Source">
	          			<option value="">Choose a <!--- Project --->#getGsetup.lPROJECT#</option>
	          			<cfloop query="getProject">
	            			<option value="#getProject.source#"<cfif xsource eq getProject.source>Selected</cfif>>#getProject.source#</option>
	          			</cfloop>
					</select>
					<select name="Job" id="Job">
	          			<option value="">Choose a <!--- Job --->#getGsetup.lJOB#</option>
	          			<cfloop query="getJob">
	            			<option value="#getJob.source#"<cfif xjob eq getJob.source>Selected</cfif>>#getJob.source#</option>
	          			</cfloop>
					</select>
				</td>
                <cfelseif getGsetup.jobbyitem eq "Y">
                <th><!--- Project / Job --->#getGsetup.lPROJECT# / #getGsetup.lJOB#</th>
	      		<td><select name="Source" id="Source">
	          			<option value="">Choose a <!--- Project --->#getGsetup.lPROJECT#</option>
	          			<cfloop query="getProject">
	            			<option value="#getProject.source#"<cfif xsource eq getProject.source>Selected</cfif>>#getProject.source#</option>
	          			</cfloop>
					</select>
                    <input type="hidden" name="Job" id="Job" value="#xJob#">
                    </td>
			<cfelse>
				<input type="hidden" name="Source" id="Source" value="#xSource#">
				<input type="hidden" name="Job" id="Job" value="#xJob#">
				<td colspan="2"></td>
			</cfif>
    	</tr>
		
		<cfif tran eq 'TR'>
			<cfquery name="getloc" datasource="#dts#">
				select location,desp,custno,(select name from #target_arcust# where custno=iclocation.custno) as name from iclocation order by location;
			</cfquery>
    		
			<tr><input type="hidden" name="oldtrfrom" value="#remark1#">
				<input type="hidden" name="oldtrto" value="#remark2#">
        		<th nowrap>Transfer From Location</th>
	  			<td>
                <cfif hcomid neq "simplysiti_i">
                <select name="trfrom" id="trfrom">
						<option value="">Choose a Location</option>
						<cfloop query="getloc">
							<option value="#getloc.location#" <cfif url.ttype eq 'Create'><cfif isdefined('consignment')><cfif consignment eq "out"><cfif getgsetup.ddllocation eq getloc.location>selected</cfif></cfif><cfelse><cfif getgsetup.ddllocation eq getloc.location>selected</cfif></cfif><cfelse><cfif remark1 eq getloc.location>selected</cfif></cfif>>#getloc.location# - #getloc.desp# - #getloc.custno#</option>
						</cfloop>
	  				</select><!--- &nbsp;<input type="text" name="trfromfilter" id="trfromfilter" size="7" onKeyUp="searchSel('trfrom','trfromfilter')"> --->
                    <cfelse>
<cfset deflocfr = "">
<cfif url.ttype eq 'Create'>
	<cfif isdefined('consignment')>
		<cfif consignment eq "out">
			<cfif getgsetup.ddllocation neq "">
            <cfset deflocfr = getgsetup.ddllocation>
            </cfif>   
        </cfif>
    <cfelse>
        <cfif getgsetup.ddllocation neq "">
        <cfset deflocfr = getgsetup.ddllocation>
        </cfif>
    </cfif>
<cfelse>
	<cfif remark1 neq "">
        <cfset deflocfr = remark1>
    </cfif>
</cfif>

<select name="trfrom" id="trfrom" bind="cfc:iss.loclist('#dts#','#target_arcust#',{trfromfilter},'#listfirst(deflocfr)#')" bindonload="yes" display="locdesp" value="loc"/>&nbsp;<input type="text" name="trfromfilter" id="trfromfilter" size="10" >&nbsp;<input type="button" name="go_btn1" value="Go">
                    </cfif>
                   <!--- <cfselect name="trfrom" id="trfrom" bind="cfc:iss.loclist('#dts#','#target_arcust#',{trfromfilter})" bindonload="yes" display="locdesp" value="loc"/>&nbsp;<input type="text" name="trfromfilter" id="trfromfilter" size="7" >&nbsp;<input type="button" name="go_btn1" value="Go">--->
				</td> 
	  			<th>Term</th>
	  			<td><select name="term" id="term1">
						<option value="">Choose a Term</option>
						<cfloop query="getterm"> 
							<option value="#getterm.term#"<cfif xterm eq getterm.term>Selected</cfif>>#getterm.term# - #getterm.desp#</option>
						</cfloop>
					</select>
				</td>
    		</tr>
			<tr>
        		<th>Transfer To Location</th>
	  			<td>
                <cfif hcomid neq "simplysiti_i">
                <select name="trto" id="trto" onChange="changeterm();">
	  					<option value="">Choose a Location</option>
						<cfloop query="getloc">
							<option value="#getloc.location#"<cfif remark2 eq getloc.location>selected</cfif>>#getloc.location# - #getloc.desp# - #getloc.custno#</option>
						</cfloop>
	  				</select> 
<!---                     &nbsp;<input type="text" name="trtofilter" id="trtofilter" size="7" onKeyUp="searchSel('trto','trtofilter')"> --->
                    <cfelse>
                    <cfset deflocto = "">
<cfif remark2 neq "">
<cfset deflocto = remark2>
</cfif>

<select name="trto" id="trto" bind="cfc:iss.loclist('#dts#','#target_arcust#',{trtofilter},'#listfirst(deflocto)#')" bindonload="yes" display="locdesp" value="loc"/>&nbsp;<input type="text" name="trtofilter" id="trtofilter" size="10" >&nbsp;<input type="button" name="go_btn2" value="Go">
                    </cfif>
                    
                    <!--- <cfselect name="trto" id="trto" bind="cfc:iss.loclist('#dts#','#target_arcust#',{trtofilter})" bindonload="yes" display="locdesp" value="loc"/>&nbsp;<input type="text" name="trtofilter" id="trtofilter" size="7" >&nbsp;<input type="button" name="go_btn1" value="Go">--->
				</td>
	  			<td>&nbsp;</td>
	  			<td>&nbsp;</td>
    		</tr>
		</cfif>
		
		<tr>
			<td height="20" colspan="4"> <hr></td>
		</tr>
		<cfif lcase(hcomid) eq "avt_i">
			<cfquery name="getCustomer" datasource="#dts#">
				select custno,name from #target_arcust# order by custno
			</cfquery>
			<tr> 				
				<th>Customer</th>
				<td>
				<select name="remark0">
				<option value="">Choose a Customer</option>
				<cfloop query="getCustomer">
				<option value="#custno#" <cfif remark0 eq custno>selected</cfif>>#custno# - #name#</option>
				</cfloop>
				</select>
				</td>
			<th>Remark 6</th>
			<td><input type="text" name="remark6" value="#remark6#" maxlength="35"></td>
		</tr>
		<tr> 
			<th>Remark 1</th>
			<td><input type="text" name="remark1" value="#remark1#" maxlength="35" <cfif tran eq "TR">readonly</cfif>></td>
			<th>Remark 7</th>
			<td><input type="text" name="remark7" value="#remark7#" maxlength="35"></td>
		</tr>
		<tr>
			<th>Remark 2</th>
			<td><input type="text" name="remark2" value="#remark2#" maxlength="35" <cfif tran eq "TR">readonly</cfif>></td>
			<th>Remark 8</th>
			<td><input type="text" name="remark8" value="#remark8#" maxlength="35"></td>
		</tr>
		<tr> 
			<th>Return By</th>
			<td><input type="text" name="remark3" value="#remark3#" maxlength="35"></td>
			<th>Remark 9</th>
			<td><input type="text" name="remark9" value="#remark9#" maxlength="35"></td>
		</tr>
		<tr> 
			<th>Days</th>
			<td><input type="text" name="remark4" value="#remark4#" maxlength="35"></td>
			<th>Remark 10</th>
			<td><input type="text" name="remark10" value="#remark10#" maxlength="35"></td>
		</tr>
		<tr> 
			<th>New Date</th>
			<td><input type="text" name="remark5" value="#remark5#" maxlength="35"></td>
			<th>Remark 11</th>
			<td><input type="text" name="remark11" value="#remark11#" maxlength="35"></td>
		</tr>
        <cfelseif tran eq "ISS" and getGsetup.custissue eq "Y">
        <script type='text/javascript' src='/ajax/core/engine.js'></script>
<script type='text/javascript' src='/ajax/core/util.js'></script>
<script type='text/javascript' src='/ajax/core/settings.js'></script>
<script type="text/javascript">
function showCustSuppDetails(CustSuppObject){
			DWRUtil.setValue("remark1", CustSuppObject.B_ADD1);
			DWRUtil.setValue("remark2", CustSuppObject.B_ADD2);
			DWRUtil.setValue("remark3", CustSuppObject.B_ADD3);
			DWRUtil.setValue("remark4", CustSuppObject.B_ADD4);
			DWRUtil.setValue("remark5", CustSuppObject.B_ATTN);
			DWRUtil.setValue("remark6", CustSuppObject.B_PHONE);
			DWRUtil.setValue("remark7", CustSuppObject.B_FAX);		
		}
function updateDetails(columnvalue){
			DWREngine._execute(_tranflocation, null, 'getCustSuppDetails', '#target_arcust#', columnvalue, "INV", showCustSuppDetails);
		}
</script>    
        <cfquery name="getCustomer" datasource="#dts#">
		SELECT "" as custno, "Choose a Customer" as name
        union all
      	select custno,concat(custno," - ", name) as name from #target_arcust# order by custno
		</cfquery>
        <tr>
			<th>Custno</th>
			<td>
            <cfselect name="remark0" selected="#remark0#" value="custno" display="name" query="getCustomer" onChange="updateDetails(this.value);" /> 
            </td>
			<th>Phone</th>
			<td><input type="text" name="remark6" value="#remark6#" maxlength="35" size="35"></td>
		</tr>
		<tr> 
			<th>Add 1</th>
			<td><input type="text" name="remark1" value="#remark1#" maxlength="35" size="35"></td>
			<th>Fax</th>
			<td><input type="text" name="remark7" value="#remark7#" maxlength="35" size="35"></td>
		</tr>
		<tr>
			<th>Add 2</th>
			<td><input type="text" name="remark2" value="#remark2#" maxlength="35" size="35" ></td>
			<th><cfif lcase(HcomID) eq "vsolutionspteltd_i">PO No<cfelse>Remark 8</cfif></th>
			<td><input type="text" name="remark8" value="#remark8#" maxlength="35" size="35"></td>
		</tr>
		<tr> 
			<th>Add 3</th>
			<td><input type="text" name="remark3" value="#remark3#" maxlength="35" size="35"></td>
			<th><cfif lcase(HcomID) eq "vsolutionspteltd_i">Ship Via<cfelse>Remark 9</cfif></th>
			<td><input type="text" name="remark9" value="#remark9#" maxlength="35" size="35"></td>
		</tr>
		<tr> 
			<th>Add 4</th>
			<td><input type="text" name="remark4" value="#remark4#" maxlength="35" size="35"></td>
			<th>Remark 10</th>
			<td><input type="text" name="remark10" value="#remark10#" maxlength="35" size="35"></td>
		</tr>
		<tr> 
			<th>
				Attn
			</th>
			<td><input type="text" name="remark5" value="#remark5#" maxlength="35" size="35"></td>
			<th>Remark 11</th>
			<td><input type="text" name="remark11" value="#remark11#" maxlength="35" size="35"></td>
		</tr>
		<cfelse>
		<tr>
			<th><cfif lcase(HcomID) eq "chemline_i" and tran eq "ISS">Name<cfelseif lcase(HcomID) eq "vsolutionspteltd_i">Attention<cfelse>Remark 0</cfif></th>
			<td><input type="text" name="remark0" value="#remark0#" maxlength="35" size="35"></td>
			<th><cfif checkcustom.customcompany eq "Y">#getGsetup.rem6#<cfelseif lcase(HcomID) eq "vsolutionspteltd_i">Invoice No.<cfelseif lcase(HcomID) eq "supervalu_i">Address 1<cfelseif lcase(HcomID) eq "aipl_i">Ref. Doc. No.<cfelseif lcase(hcomid) eq "meisei_i">Prepared By<cfelse>Remark 6</cfif></th>
			<td><input type="text" name="remark6" value="#remark6#" maxlength="35" size="35"></td>
		</tr>
		<tr> 
			<th><cfif lcase(HcomID) eq "chemline_i" and tran eq "ISS">Add 1<cfelse>Remark 1</cfif></th>
			<td><input type="text" name="remark1" value="#remark1#" maxlength="35" size="35" <cfif tran eq "TR">readonly</cfif>></td>
			<th><cfif checkcustom.customcompany eq "Y">#getGsetup.rem7#<cfelseif lcase(HcomID) eq "vsolutionspteltd_i">PO No<cfelseif lcase(HcomID) eq "supervalu_i">Address 2<cfelseif lcase(hcomid) eq "meisei_i">Approved By<cfelse>Remark 7</cfif></th>
			<td><input type="text" name="remark7" value="#remark7#" maxlength="35" size="35"></td>
		</tr>
		<tr>
			<th><cfif lcase(HcomID) eq "chemline_i" and tran eq "ISS">Add 2<cfelse>Remark 2</cfif></th>
			<td><input type="text" name="remark2" value="#remark2#" maxlength="35" size="35" <cfif tran eq "TR">readonly</cfif>></td>
			<th><cfif checkcustom.customcompany eq "Y">#getGsetup.rem8#<cfelseif lcase(HcomID) eq "vsolutionspteltd_i">Duration<cfelseif lcase(HcomID) eq "supervalu_i">Address 3<cfelseif lcase(hcomid) eq "meisei_i">Attn<cfelse>Remark 8</cfif></th>
			<td><input type="text" name="remark8" value="#remark8#" maxlength="35" size="35"></td>
		</tr>
		<tr> 
			<th><cfif lcase(HcomID) eq "chemline_i" and tran eq "ISS">Add 3<cfelseif lcase(HcomID) eq "vsolutionspteltd_i">Tel No<cfelse>Remark 3</cfif></th>
			<td><input type="text" name="remark3" value="#remark3#" maxlength="35" size="35"></td>
			<th><cfif lcase(HcomID) eq "vsolutionspteltd_i">Ship Via<cfelseif lcase(HcomID) eq "supervalu_i">Address 4<cfelse>Remark 9</cfif></th>
			<td><input type="text" name="remark9" value="#remark9#" maxlength="35" size="35"></td>
		</tr>
		<tr> 
			<th><cfif lcase(HcomID) eq "chemline_i" and tran eq "ISS">Tel / Fax<cfelseif lcase(HcomID) eq "vsolutionspteltd_i">Email<cfelseif lcase(hcomid) eq "meisei_i">Tel<cfelse>Remark 4</cfif></th>
			<td><input type="text" name="remark4" value="#remark4#" <cfif lcase(hcomid) eq "chemline_i">maxlength="80"<cfelse>maxlength="35"</cfif> size="35"></td>
			<th><cfif lcase(HcomID) eq "vsolutionspteltd_i">Currency<cfelse>Remark 10</cfif></th>
			<td><input type="text" name="remark10" value="#remark10#" maxlength="35" size="35"></td>
		</tr>
		<tr> 
			<th>
				<cfif checkcustom.customcompany eq "Y">
					#getGsetup.rem5#
				<cfelseif lcase(HcomID) eq "chemline_i" and tran eq "ISS">
					Attn / HP
                <cfelseif lcase(HcomID) eq "vsolutionspteltd_i">
					Due Date
		<cfelseif lcase(HcomID) eq "aipl_i">
					Description
                    <cfelseif lcase(HcomID) eq "supervalu_i">
                    Bill Remarks
				<cfelseif lcase(hcomid) eq "meisei_i">
                Fax
                <cfelse>
					Remark 5
				</cfif>
			</th>
			<td><input type="text" name="remark5" value="#remark5#" <cfif lcase(hcomid) eq "chemline_i">maxlength="80"<cfelse>maxlength="35"</cfif> size="35"></td>
			<th><cfif lcase(HcomID) eq "vsolutionspteltd_i">Remark<cfelse>Remark 11</cfif></th>
			<td><cfif lcase(HcomID) eq "vsolutionspteltd_i"><input type="text" name="remark11" value="#remark11#" maxlength="200" size="35"><cfelse>
            
            <input type="text" name="remark11" value="#remark11#" maxlength="35" size="35"></cfif></td>
		</tr>
		</cfif>
		<!--- REMARK ON 22-12-2009 --->
		<!--- <tr> 
			<td></td>
			<td align="right">&nbsp;</td>
			<td align="right">&nbsp;</td>
			<td align="right"><input name="submit" type="submit" value="#mode#"></td>
		</tr> --->
        <cfif getgsetup.addonremark eq 'Y'>
            <tr><td colspan="5">
            <cfinclude template="iss2addon.cfm">
            </td>
			</tr>
		</cfif>
		<tr> 
			<td colspan="4" align="center">
				<cfif mode eq "Delete">
					<cfif getGsetup.keepDeletedBills eq "1">
						<h3>
	            		<input name="keepDeleted" id="keepDeleted" type="checkbox" value="1" checked>
	            		Keep Deleted Bills
						</h3>
					</cfif>
				</cfif>
				<input name="submit1" type="submit" value="#mode#">
			</td>
		</tr>
	</table>
    
</cfform>
</cfoutput>	

<cfif isdefined('url.posttrue')>

<script type="text/javascript">
document.invoicesheet.submit();
</script>
</cfif>

</body>
</html>