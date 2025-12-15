<cfparam name="alcreate" default="0">
<cfparam name="aledit" default="0">
<cfparam name="aldelete" default="0">
<cfparam name="alown" default="0">

<cfquery name="gettranname" datasource="#dts#">
select lconsignin,lconsignout,lISS,lOAI,lOAR from gsetup
</cfquery> 
<cfquery name="getmodule" datasource="#dts#">
    select * from modulecontrol
</cfquery>

<cfif tran eq "ISS">
	<cfset tran = "ISS">
	<cfset tranname = gettranname.lISS>
	<cfset trancode = "issno">
	
	<cfif getpin2.h2821 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2822 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2823 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2824 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
<cfelseif tran eq "TR">
	<cfset tran = "TR">
    
    <cfif isdefined('consignment')>
    <cfif consignment eq "out">
    <cfset tranname = "#gettranname.lconsignout#">
	<cfset trancode = "trno">
    <cfelseif consignment eq "return">
    <cfset tranname = "#gettranname.lconsignin#">
	<cfset trancode = "trno">
    <cfelse>
    <cfset tranname = "Transfer">
	<cfset trancode = "trno">
    </cfif>
    <cfelse>
	<cfset tranname = "Transfer">
	<cfset trancode = "trno">
    </cfif>
	
	<cfif getpin2.h28A1 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h28A2 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h28A3 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h28A4 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
<cfelseif tran eq "OAI">
	<cfset tran = "OAI">
	<cfset tranname = gettranname.lOAI>
	<cfset trancode = "oaino">
	
	<cfif getpin2.h2831 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2832 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2833 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2834 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
<cfelseif tran eq "OAR">
	<cfset tran = "OAR">
	<cfset tranname =  gettranname.lOAR>
	<cfset trancode = "oarno">
	
	<cfif getpin2.h2841 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2842 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2843 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2844 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif isdefined('consignment')>
<cfset consignment = consignment>
<cfelse>
<cfset consignment = ''>
</cfif>

<cfif consignment eq 'out'>
<cfquery datasource="#dts#" name="Checkconsignmentoutno">
select lastUsedNo as result, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = 2
</cfquery>
</cfif>

<cfif consignment eq 'return'>
<cfquery datasource="#dts#" name="Checkconsignmentoutno">
select lastUsedNo as result, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = 3
</cfquery>
</cfif>

<html>
<head>
<title><cfoutput>#tranname# </cfoutput>Main Page</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<!--- REMARK ON 240608 AND REPLACE WITH BELOW ONE --->
<!---cfquery datasource="#dts#" name="getGeneralInfo">
	Select #trancode# as result from GSetup
</cfquery--->

<cfquery datasource="#dts#" name="getGeneralInfo">
	Select #trancode# as result, iss_oneset, tr_oneset, oai_oneset, oar_oneset
	from GSetup
</cfquery>

<cfquery datasource="#dts#" name="getRefnoset">
	select lastUsedNo as result, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = <cfif consignment eq 'out' and Checkconsignmentoutno.recordcount neq 0>2<cfelseif consignment eq 'return' and Checkconsignmentoutno.recordcount neq 0>3<cfelse>1</cfif>
</cfquery>

<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
</cfquery>

<cfquery datasource='#dts#' name="gettransaction">
	Select * from artran 
	where type="#tran#" 
	<cfif alown eq 1>and (userid = '#huserid#' or agenno = '#huserid#')</cfif> 
    and consignment='#consignment#'
	<!--- and fperiod<>'99'  --->
	order by <cfif getdealer_menu.transactionSortBy neq "">#getdealer_menu.transactionSortBy#<cfelse> wos_date desc,refno desc</cfif> 
	limit 20
</cfquery>

<body>
<!---1. Match output at line 38 --->
<cfoutput>
<cfif husergrpid eq "Muser">
	<a href="../home2.cfm"><u>Home</u></a>
</cfif>

<h1>#tranname# Main Menu</h1>
<h4>
	<cfif alcreate eq 1>
		<cfif getgeneralinfo.iss_oneset neq '1' and tran eq 'ISS'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelseif getgeneralinfo.tr_oneset neq '1' and tran eq 'TR'>
			<a href="iss0.cfm?ttype=create&tran=#tran#&consignment=#consignment#">Create New #tranname#</a> ||
		<cfelseif getgeneralinfo.oai_oneset neq '1' and tran eq 'OAI'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelseif getgeneralinfo.oar_oneset neq '1' and tran eq 'OAR'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelse>
			<a href="iss2.cfm?ttype=create&tran=#tran#&consignment=#consignment#">Create New #tranname#</a> ||
		</cfif>
	</cfif> 
	<a href="iss.cfm?tran=#tran#&consignment=#consignment#">List all #tranname#</a> || 
	<a href="siss.cfm?tran=#tran#&consignment=#consignment#">Search For #tranname#</a>
    <cfif getmodule.matrixtran eq 1>
         <cfif alcreate eq 1>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/matrixexpressbill/index.cfm?first=true&tran=#tran#','','fullscreen=yes')">
				Matrix New
			</a>
         </cfif>
         </cfif>
</h4><hr>
<cfoutput>
<p><strong><br>Last Used #tran# No :</strong><font color="##FF0000"><strong>#getRefnoset.result#</strong></font></p>
</cfoutput>
<!---1. Match output at line 28 --->
</cfoutput>
<table align="center" class="data">
  	<tr> 
    	<td colspan="7"><div align="center"><font color="#336699" size="3" face="Arial, Helvetica, sans-serif"><strong>Newest 20 <cfoutput>#tranname#</cfoutput></strong></font></div></td>
	</tr>
  	<tr> 
    	<th><cfoutput>#tranname#</cfoutput> No</th>
		<th>Agent</th>
        <cfif lcase(hcomid) eq "xinbao_i" and (tran eq "ISS")>
        <th>Project</th>
        </cfif>
    	<th>Date</th>
    	<th>Period</th>
		<cfif lcase(hcomid) eq "avt_i" and (tran eq "OAI" or tran eq "OAR")>
    	<th>Customer</th>
		<cfelse>
		<th>Authorised By</th>
		</cfif>
    	<th>User</th>
        <cfif tran eq "TR">
        <th>Transfer From</th>
        <th>Transfer To</th>
        </cfif>
		<th>Status</th>
    	<th>Action</th>
  	</tr>
	
	<cfoutput query="gettransaction" startrow="1" maxrows="20"> 
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"> 
      	<td>#gettransaction.refno#</td>
	  	<td>#gettransaction.agenno#</td>
        <cfif lcase(hcomid) eq "xinbao_i" and (tran eq "ISS")>
        <td>#gettransaction.source#</td>
        </cfif>
      	<td>#dateformat(gettransaction.wos_date,"dd-mm-yyyy")#</td>
      	<td>#gettransaction.fperiod#</td>
		<cfif lcase(hcomid) eq "avt_i" and (tran eq "OAI" or tran eq "OAR")>
			<cfquery name="getCustomer" datasource="#dts#"><!--- special case (can improve) --->
				select concat(custno,' - ',name) as cn from #target_arcust# where custno='#gettransaction.rem0#'
			</cfquery>
      		<td nowrap>#getCustomer.cn#</td>
		<cfelse>
		<td nowrap>#gettransaction.custno#</td>
		</cfif>
         <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
        <cfquery name="getusername" datasource="main">
        select username from users where userbranch ='#dts#' and userid='#gettransaction.userid#'
        </cfquery>
        <td>#getusername.username#</td>
        <cfelse>
      	<td>#gettransaction.userid#</td>
        </cfif>
        <cfif tran eq "TR">
        <cfquery name="gettransferfrom" datasource="#dts#">
        select location from ictran where refno='#gettransaction.refno#' and type='TROU'
        </cfquery>
        <cfquery name="gettransferto" datasource="#dts#">
        select location from ictran where refno='#gettransaction.refno#' and type='TRIN'
        </cfquery>
        
         <cfquery name="gettransferfromname" datasource="#dts#">
        select desp from iclocation where location='#gettransferfrom.location#'
        </cfquery>
        <cfquery name="gettransfertoname" datasource="#dts#">
        select desp from iclocation where location='#gettransferto.location#'
        </cfquery>
        <cfif lcase(hcomid) eq "vsolutionspteltd_i">
        <td>#gettransferfromname.desp#</td>
        <td>#gettransfertoname.desp#</td>
        <cfelse>
        <td>#gettransferfrom.location#</td>
        <td>#gettransferto.location#</td>
        </cfif>
        </cfif>
		<td align="center"><cfif gettransaction.void neq ""><font color="red"><strong>Void</strong></font></cfif></td>
      	<td align="right" nowrap>
			<cfif lcase(hcomid) eq "migif_i" and tran eq "TR">
				<a href="../../billformat/#dts#/consignmentnote.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
			<cfelseif lcase(hcomid) eq "avt_i" and (tran eq "OAI" or tran eq "OAR")>
				<a href="../../billformat/#dts#/loanmenu.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
			<cfelseif lcase(hcomid) eq "valore_i" >
				<a href="../../billformat/#dts#/transaction3c.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
                <cfelseif lcase(hcomid) eq "supervalu_i" and tran eq "TR">
				<a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
			<cfelse>
				<a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
			</cfif>
			
			<cfif aledit eq 1 and gettransaction.fperiod neq "99" and gettransaction.void eq "">
				<a href="iss2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(gettransaction.custno)#">
				<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
			<cfelse>
				<img height="18px" width="18px" src="../../images/edit.ICO" alt="Not Allowed to Edit" border="0">Edit
			</cfif> 
            <cfif getpin2.H2890 eq 'T'>
                <img height="18px" width="18px" src="../../images/Copy Icon.jpg" alt="Copy" border="0"><a onMouseOver="this.style.cursor='hand'" onClick="window.open('copyfunction.cfm?refno=#refno#&type=#tran#');">Copy</a>
                </cfif>
        	<cfif aldelete eq 1 and gettransaction.fperiod neq "99" and gettransaction.void eq "">
				<a href="iss2.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(gettransaction.custno)#">
				<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
			<cfelse>
				<img height="18px" width="18px" src="../../images/delete.ICO" alt="Not Allowed to Delete" border="0">Delete
			</cfif>
		</td>
    </tr>
  	</cfoutput> 
</table>


</body>
</html>