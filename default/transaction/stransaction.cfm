<cfparam name="alcreate" default="0">
<cfparam name="aledit" default="0">
<cfparam name="aldelete" default="0">
<cfparam name="alown" default="0">

<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfquery datasource="#dts#" name="getGeneralInfo">
	select 
	delinvoice,
	invsecure,
	printoption,
	invoneset,agentlistuserid,ddltran,lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM,rem5
	from gsetup;
</cfquery>

<cfif tran eq "RC">
	<cfset tran = "RC">
	<cfset tranname = getGeneralInfo.lRC>
	<cfset trancode = "rcno">
	
	<cfif getpin2.h2102 eq "T">
  		<cfset alcreate = 1>
	</cfif>

	<cfif getpin2.h2103 eq "T">
  		<cfset aledit = 1>
	</cfif>

	<cfif getpin2.h2104 eq "T">
  		<cfset aldelete = 1>
	</cfif>

	<cfif getpin2.h2105 eq "T">
  		<cfset alown = 1>
	</cfif>
</cfif>

<cfif tran eq "PR">
	<cfset tran = "PR">
	<cfset tranname = getGeneralInfo.lRC>
	<cfset trancode = "prno">
	
	<cfif getpin2.h2201 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2202 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2203 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2204 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "DO">
	<cfset tran = "DO">
	<cfset tranname = getGeneralInfo.lDO>
	<cfset trancode = "dono">
	
	<cfif getpin2.h2301 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2302 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2303 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2304 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "INV">
	<cfset tran = "INV">
	<cfset tranname = getGeneralInfo.lINV>
	<cfset trancode = "invno">
	
	<cfif getpin2.h2401 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2402 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2403 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2404 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "CS">
	<cfset tran = "CS">
	<cfset tranname = getGeneralInfo.lCS>
	<cfset trancode = "csno">
	
	<cfif getpin2.h2501 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2502 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2503 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2504 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "CN">
	<cfset tran = "CN">
	<cfset tranname = getGeneralInfo.lCN>
	<cfset trancode = "cnno">
	
	<cfif getpin2.h2601 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2602 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2603 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2604 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "DN">
	<cfset tran = "DN">
	<cfset tranname = getGeneralInfo.lDN>
	<cfset trancode = "dnno">
	
	<cfif getpin2.h2701 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2702 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2703 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2704 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "PO">
	<cfset tran = "PO">
	<cfset tranname = getGeneralInfo.lPO>
	<cfset trancode = "pono">
	
	<cfif getpin2.h2861 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2862 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2863 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2864 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "QUO">
	<cfset tran = "QUO">
	<cfset tranname = getGeneralInfo.lQUO>
	<cfset trancode = "quono">
	
	<cfif getpin2.h2871 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	<cfif getpin2.h2872 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	<cfif getpin2.h2873 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	<cfif getpin2.h2874 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "SO">
	<cfset tran = "SO">
	<cfset tranname = getGeneralInfo.lSO>
	<cfset trancode = "sono">
	
	<cfif getpin2.h2881 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2882 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2883 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2884 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "SAM">
	<cfset tran = "SAM">
	<cfset tranname = getGeneralInfo.lSAM>
	<cfset trancode = "samno">
	<cfset tranarun = "samarun">
	
	<cfif getpin2.h2851 eq "T">
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2852 eq "T">
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2853 eq "T">
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2854 eq "T">
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "SAMM" and lcase(hcomid) eq "hunting_i">
	<cfset tran = "SAMM">
	<cfset tranname = "Sales Order">
	<cfset trancode = "sammno">
	<cfset tranarun = "sammarun">

	<cfif getpin2.h2851 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>

	<cfif getpin2.h2852 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>

	<cfif getpin2.h2853 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>

	<cfif getpin2.h2854 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<html>
<head>
<cfoutput>
<title>Search #tranname#</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">



<body>
	<h1>Search #tranname#</h1>
	<h4>
	<cfif alcreate eq 1>
		<cfif HcomID eq "pnp_i">
			<cfinclude template="../../pnp/get_authorised_multi_invoive.cfm">
		<cfelse>
			<cfif getgeneralinfo.invoneset neq '1' and tran eq 'INV'>
				<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
			<cfelse>
				<a href="transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&first=0">Create New #tranname#</a>
			</cfif> || 
		</cfif>
	</cfif>
	
	<a href="transaction.cfm?tran=#tran#">List all #tranname#</a> ||
	<a href="stransaction.cfm?tran=#tran#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Search For #tranname#</a>
    
    <cfif tran eq "QUO">
        ||<a href="closequo.cfm">Close #tranname#</a>
        </cfif>
    <cfif lcase(hcomid) eq "polypet_i" and tran eq "CS">
         <cfif getpin2.H2890 eq 'T'>
         || <a href="/default/transaction/polypettransaction.cfm?tran=#tran#">Delivery</a>
         </cfif>
         </cfif>
	</h4>
<br>
<cfif tran eq "DO">
			<cfif getpin2.h2305 eq 'T'>
				<h2><a href="update/update.cfm?t1=DO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo.lINV#</a></h2>
			</cfif>
		</cfif>
		<cfif tran eq "PO">
		<h2>
			<cfif getpin2.h2865 eq 'T'>
				<a href="update/update.cfm?t1=PO&t2=RC"><img src="../../images/arrow.png" alt="Update to Purchase Receive" name="updateBtn2" border="0"> Update To #getGeneralInfo.lRC#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
			<!--- ADD ON 130608, THE LINK FOR EXPORT THE PO TO DO --->
			<!--- <cfif getpin2.h2866 eq 'T'>
				<a href="update/updateA.cfm?t1=PO&t2=DO"><img src="../../images/arrow.png" alt="Update to Delivery Order" name="updateBtn3" border="0"> Update To Delivery Order</a>			
			</cfif> --->
			<cfif getpin2.h2866 eq 'T'>
				<a href="update/update.cfm?t1=PO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn3" border="0"> Update To #getGeneralInfo.lINV#</a>			
			</cfif>
		</h2>
		</cfif>
		<cfif tran eq "SO">
		<h2>
			<cfif getpin2.h2885 eq 'T'>
				<a href="update/update.cfm?t1=SO&t2=DO"><img src="../../images/arrow.png" alt="Update to Delivery Order" name="updateBtn4" border="0"> Update To #getGeneralInfo.lDO#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>

			<cfif getpin2.h2886 eq 'T'>
				<cfif lcase(hcomid) eq "solidlogic_i">
					<a href="update/s_update.cfm?t1=SO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> Update To #getGeneralInfo.lINV#</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<cfelse>
					<a href="update/update.cfm?t1=SO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> Update To #getGeneralInfo.lINV#</a>&nbsp;&nbsp;&nbsp;&nbsp;
				</cfif>
			</cfif>

			<cfif getpin2.h2887 eq 'T'>
				<a href="update/update.cfm?t1=SO&t2=PO"><img src="../../images/arrow.png" alt="Update to Purchase Order" name="updateBtn6" border="0"> Update To #getGeneralInfo.lPO#</a>
			</cfif>
            <cfif getpin2.h2887 eq 'T' and (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i") >
            <a href="update/s_update.cfm?t1=SO&t2=SAM"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> Update To Work Order (Sample)</a>&nbsp;&nbsp;&nbsp;&nbsp;
            </cfif>
		</h2>
		</cfif>
		<cfif tran eq "QUO">
		<h2>
			<cfif getpin2.h2875 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=SO"><img src="../../images/arrow.png" alt="Update to Sales Order" name="updateBtn7" border="0"> Update To #getGeneralInfo.lSO#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
			
			<cfif getpin2.H2877 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=DO"><img src="../../images/arrow.png" alt="Update to Delivery Order" name="updateBtn8" border="0"> Update To #getGeneralInfo.lDO#</a>
			</cfif>

			<cfif getpin2.h2876 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn8" border="0"> Update To #getGeneralInfo.lINV#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
			
			<cfif getpin2.H2878 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=PO"><img src="../../images/arrow.png" alt="Update to Purchase Order" name="updateBtn8" border="0"> Update To #getGeneralInfo.lPO#</a>
			</cfif>
			
			<cfif getpin2.H2879 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=CS"><img src="../../images/arrow.png" alt="Update to Cash Sales" name="updateBtn8" border="0"> Update To #getGeneralInfo.lCS#</a>
			</cfif>
		</h2>
		</cfif>
        <cfif tran eq "SAM">
			<cfif getpin2.H2855 eq 'T'>
				<h2><a href="update/update.cfm?t1=SAM&t2=SO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo.lSO#</a>&nbsp;&nbsp;<a href="update/update.cfm?t1=SAM&t2=DO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo.lDO#</a></h2>
			</cfif>
		</cfif>
        <cfif tran eq "SAMM">
			<cfif getpin2.H2855 eq 'T'>
				<h2><a href="update/update.cfm?t1=SAMM&t2=QUO"><img src="/images/arrow.png" alt="Update to Quotation" name="updateBtn" border="0"> Update To #getGeneralInfo.lQUO#</a><!--- &nbsp;&nbsp;<a href="update/update.cfm?t1=SAM&t2=DO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo.lDO#</a> ---></h2>
			</cfif>
		</cfif>

<form action="stransaction.cfm" method="post">
	<h1>Search By :
	<select name="searchType">
		<option value="refno" <cfif getGeneralInfo.ddltran eq "Refno">selected</cfif>>#tranname# No</option>
		<option value="refno2" <cfif getGeneralInfo.ddltran eq "Refno2">selected</cfif>>Refno2</option>
		<cfif tran eq "RC" or tran eq "PR" or tran eq "PO">
			<option value="custno" <cfif getGeneralInfo.ddltran eq "Supplier/Customer ID">selected</cfif>>Supplier No</option>
			<option value="name" <cfif getGeneralInfo.ddltran eq "Supplier/Customer Name">selected</cfif>>Supplier Name</option>
		<cfelse>
			<option value="custno" <cfif getGeneralInfo.ddltran eq "Supplier/Customer ID">selected</cfif>>Customer No</option>
			<option value="name" <cfif getGeneralInfo.ddltran eq "Supplier/Customer Name">selected</cfif>>Customer Name</option>
		</cfif>
		<option value="agenno" <cfif getGeneralInfo.ddltran eq "Agent">selected</cfif>>Agent</option>
		<option value="fperiod" <cfif getGeneralInfo.ddltran eq "Period">selected</cfif>>Period</option>
		<option value="rem4" <cfif getGeneralInfo.ddltran eq "Phone">selected</cfif>>Phone</option>
		<cfif checkcustom.customcompany eq "Y">
			<option value="rem5">Permit Number</option>
		</cfif>
        <option value="wos_date" <cfif getGeneralInfo.ddltran eq "Date">selected</cfif>>Date (DDMMYYYY)</option>
         <option value="pono" >PO/SO</option>
         <option value="phonea" >Phone 2</option>
         <option value="frem6" >Fax</option>
         <option value="allphone" >Phone All</option>
         
         <cfif lcase(hcomid) eq "powernas_i" or lcase(hcomid) eq "acerich_i">
        <option value="brem2">CERTIFICATE NUMBER</option>
        </cfif>
        <cfif (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i")>
        <option value="source">Project</option>
        </cfif>
        <cfif lcase(hcomid) eq "visionlaw_i">
        <option value="rem5">#getGeneralInfo.rem5#</option>
        <option value="desp">Description</option>
        </cfif>
	</select>
		
	<input type="hidden" name="tran" value="#tran#"> 
	Search for 
	<input type="text" name="searchStr" value="">

		<input type="submit" name="submit" value="Search"> 

	</h1>
</form>

<cfif isdefined("form.searchStr")>	
<cfif form.searchType eq 'wos_date'>
<cfset form.searchStr =right(form.searchStr,4)&'-'&mid(form.searchStr,3,2)&'-'&left(form.searchStr,2)>
</cfif>
	<cfquery name="getrecordcount" datasource="#dts#">
		select count(refno) as totalsimilarrecord
		from artran 
		where type='#tran#' and <cfif form.searchType eq 'brem2'>refno in (select refno from ictran where brem2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> and type='#tran#')<cfelseif form.searchType eq 'allphone'>
		(rem4 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> or
        frem6 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> or
        phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> or
        rem12 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> or
        comm4 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%">
        )
		<cfelse>#searchtype# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"></cfif>
		<cfif alown eq 1>
		<cfif getGeneralInfo.agentlistuserid eq "Y">and (ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%") or ucase(userid)='#ucase(huserid)#')
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
			</cfif>
		</cfif>
		<!--- select 
		(
			select count(refno)
			from artran 
			where type='#tran#' and #searchtype#=binary('#searchstr#') 
			<cfif alown eq 1>
			and (artran.userid='#huserid#' or ucase(agenno)='#ucase(huserid)#')
			</cfif>
		) as totalexactrecord,
		(
			select count(refno) 
			from artran 
			where type='#tran#' and #searchtype# like binary('#searchstr#') 
			<cfif alown eq 1>
			and (artran.userid='#huserid#' or ucase(agenno)='#ucase(huserid)#')
			</cfif>
		)as totalsimilarrecord --->
	</cfquery>
	
	<!--- <cfif getrecordcount.totalexactrecord neq 0>
		<h2>Exact Results</h2>
		<iframe align="middle" scrolling="auto" frameborder="0" width="100%" height="250" src="stransaction_exact.cfm?tran=#urlencodedformat(tran)#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#"></iframe>
	<cfelse>
		<h3>No Exact Results Found !</h3>
	</cfif> --->
	
	<cfif getrecordcount.totalsimilarrecord neq 0>
		<h2>Similar Results</h2>
		<iframe align="middle" scrolling="auto" frameborder="0" width="100%" height="700" src="stransaction_similar.cfm?tran=#urlencodedformat(tran)#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#"></iframe>
	<cfelse>
		<h3>No Similar Results Found !</h3>
	</cfif>
	
	<h2>Newest 20 Results</h2>
	<iframe align="middle" scrolling="auto" frameborder="0" width="100%" height="700" src="stransaction_newest.cfm?tran=#urlencodedformat(tran)#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#"></iframe>
<cfelse>
	<h2>Newest 20 Results</h2>
	<iframe align="middle" scrolling="auto" frameborder="0" width="100%" height="700" src="stransaction_newest.cfm?tran=#urlencodedformat(tran)#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#"></iframe>
</cfif>

</cfoutput>

</body>
</html>