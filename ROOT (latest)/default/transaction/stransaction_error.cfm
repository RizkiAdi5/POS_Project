<cfparam name="alcreate" default="0">
<cfparam name="aledit" default="0">
<cfparam name="aldelete" default="0">
<cfparam name="alown" default="0">

<cfquery datasource="#dts#" name="getGeneralInfo1">
	Select lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM

	from GSetup
</cfquery>

<cfif tran eq "RC">
	<cfset tran = "RC">
	<cfset tranname = getGeneralInfo1.lRC>
	<cfset trancode = "rcno">
	
	<cfif getpin2.h2102 eq 'T'>
  		<cfset alcreate = 1>
	</cfif>

	<cfif getpin2.h2103 eq 'T'>
  		<cfset aledit = 1>
	</cfif>

	<cfif getpin2.h2104 eq 'T'>
  		<cfset aldelete = 1>
	</cfif>

	<cfif getpin2.h2105 eq 'T'>
  		<cfset alown = 1>
	</cfif>
</cfif>

<cfif tran eq "PR">
	<cfset tran = "PR">
	<cfset tranname = getGeneralInfo1.lPR>
	<cfset trancode = "prno">
	
	<cfif getpin2.h2201 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2202 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2203 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2204 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "DO">
	<cfset tran = "DO">
	<cfset tranname = getGeneralInfo1.lDO>
	<cfset trancode = "dono">
	
	<cfif getpin2.h2301 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2302 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2303 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2304 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "INV">
	<cfset tran = "INV">
	<cfset tranname = getGeneralInfo1.lINV>
	<cfset trancode = "invno">
	
	<cfif getpin2.h2401 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2402 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2403 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2404 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "CS">
	<cfset tran = "CS">
	<cfset tranname = getGeneralInfo1.lCS>
	<cfset trancode = "csno">
	
	<cfif getpin2.h2501 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2502 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2503 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2504 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "CN">
	<cfset tran = "CN">
	<cfset tranname = getGeneralInfo1.lCN>
	<cfset trancode = "cnno">
	
	<cfif getpin2.h2601 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2602 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2603 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2604 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "DN">
	<cfset tran = "DN">
	<cfset tranname = getGeneralInfo1.lDN>
	<cfset trancode = "dnno">
	
	<cfif getpin2.h2701 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2702 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2703 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2704 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "PO">
	<cfset tran = "PO">
	<cfset tranname = getGeneralInfo1.lPO>
	<cfset trancode = "pono">
	
	<cfif getpin2.h2861 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2862 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2863 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2864 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "QUO">
	<cfset tran = "QUO">
	<cfset tranname = getGeneralInfo1.lQUO>
	<cfset trancode = "quono">
	
	<cfif getpin2.h2871 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	<cfif getpin2.h2872 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	<cfif getpin2.h2873 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	<cfif getpin2.h2874 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "SO">
	<cfset tran = "SO">
	<cfset tranname = getGeneralInfo1.lSO>
	<cfset trancode = "sono">
	
	<cfif getpin2.h2881 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2882 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2883 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2884 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif tran eq "SAM">
	<cfset tran = "SAM">
	<cfset tranname = getGeneralInfo1.lSAM>
	<cfset trancode = "samno">
	<cfset tranarun = "samarun">
	
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
	<title><cfoutput>Search #tranname#</cfoutput></title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<cfquery datasource="#dts#" name="getGeneralInfo">
	select delinvoice,invsecure,printoption,invoneset ,agentlistuserid
	from GSetup;
</cfquery>

<cfquery datasource='#dts#' name="getjob">
	select artran.*,(select 1<!--- phone from customer where customerno=artran.custno --->) as phone 
	from artran 
	where type = '#tran#' 
	<cfif alown eq 1>
		<cfif getGeneralInfo.agentlistuserid eq "Y">and ucase(artran.agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(artran.userid)='#ucase(huserid)#' or ucase(artran.agenno)='#ucase(huserid)#')  
			</cfif>
	</cfif>
	<!--- and fperiod <> '99' ---> 
	order by refno desc;
</cfquery>

<body>
<cfoutput>
  <h1>Search #tranname#</h1>

<h4>
	<cfif alcreate eq 1>
		<cfif getgeneralinfo.invoneset neq '1' and tran eq 'INV'>
			<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
		<cfelse>
			<a href="transaction1.cfm?ttype=create&tran=#tran#&nexttranno=<!--- &bcode=&dcode= --->&first=0">Create New #tranname#</a>
		</cfif> ||
	</cfif>
	<a href="transaction.cfm?tran=#tran#">List all #tranname#</a> ||
	<a href="stransaction.cfm?tran=#tran#">Search For #tranname#</a>
</h4>
</cfoutput>

<form action="stransaction.cfm" method="post">
	<cfoutput>
		<h1>Search By :
		<select name="searchType">
			<option value="refno">#tranname# No</option>
			<option value="refno2">Refno2</option>
			<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
				<option value="custno">Supplier No</option>
				<option value="name">Supplier Name</option>
			<cfelse>
				<option value="custno">Customer No</option>
				<option value="name">Customer Name</option>
			</cfif>
			<option value="agenno">Agent</option>
			<option value="fperiod">Period</option>
			<option value="phone">Phone</option>
		</select>
		<input type="hidden" name="tran" value="#tran#">
		Search for <input type="text" name="searchStr" value="">
		<cfif husergrpid eq "Muser">
			<input type="submit" name="submit" value="Search"> 
		</cfif>
		</h1>
	</cfoutput>
</form>

<cfif isdefined("form.searchStr")>
	<cfquery dbtype="query" name="exactResult">
		select * 
		from getjob 
		where #form.searchType# = '#form.searchStr#' 
		order by wos_date desc;
	</cfquery>

	<cfquery dbtype="query" name="similarResult">
		select * 
		from getjob 
		where #form.searchType# LIKE '#form.searchStr#' 
		order by wos_date desc;
	</cfquery>

	<h2>Exact Result</h2>
	<cfif exactResult.recordCount neq 0>
		<table align="center" class="data">
			<tr>
				<th><cfoutput>#tranname# No</cfoutput></th>
			   	<th>Refno2</th>
			   	<th>Agent</th>
 			   	<th>Date</th>
  			  	<th>Period</th>
  			  	<th>
			  	<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
			  		Supplier Name
			  	<cfelse>
			  		Customer Name
			  	</cfif>
			  	</th>
				<th>Phone</th>
  			  	<th>User</th>
			  	<th>Status</th>
  			  	<th>Action</th>
			</tr>
  			
			<cfoutput query="exactresult">
				<tr>
   			   		<td>#exactresult.refno#</td>
			   		<td>#exactresult.refno2#</td>
			   		<td>#exactresult.agenno#</td>
					<td nowrap>#dateformat(exactresult.wos_date,"dd-mm-yyyy")#</td>
   			   		<td>#exactresult.fperiod#</td>
    			  	<td nowrap>#exactresult.custno# - #exactresult.name#</td>
					<td>#exactresult.phone#</td>
    			  	<td>#exactresult.userid#</td>
   			   		<td align="center">
						<cfif tran eq 'DO' and toinv neq ''>
							Y
						</cfif>
						<cfif (tran eq 'INV' or tran eq 'RC' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN') and exactresult.posted neq ''>
							P
						</cfif>
					</td>
          			<td align="right" nowrap>
		 			<cfif getgeneralinfo.printoption eq 1>
						<a href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
					<cfelse>
						<a href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
					</cfif>
					<!----
   	  	    		<cfif hcomid eq 'msd' and tran eq "RC" and getpin2.h2101 eq 'T'>
	  	  	  			|&nbsp;<a href="../reports/grn_note.cfm?tran=#tran#&nexttranno=#refno#">GRN Note</a>&nbsp;
 		    		</cfif>
					--->
					<cfif aledit eq 1>
						<a href="transaction1.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(exactresult.custno)#&first=0">
							<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit
						</a>
					</cfif>
            		
					<cfif aldelete eq 1>
						<a href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(exactresult.custno)#&first=0">
							<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete
						</a>
					</cfif>
				</td>
			</tr>
		</cfoutput>
		</table>
	<cfelse>
		<h3>No Exact Records were found.</h3>
	</cfif>

	<h2>Similar Result</h2>
	<cfif similarResult.recordCount neq 0>
		<table align="center" class="data">
			<tr>
				<th><cfoutput>#tranname# No</cfoutput></th>
				<th>Refno2</th>
				<th>Agent</th>
				<th>Date</th>
				<th>Period</th>
				<th>
				<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
					Supplier Name
				<cfelse>
					Customer Name
				</cfif>
				</th>
				<th>Phone</th>
				<th>User</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
			
			<cfoutput query="similarResult">
				<tr>
					<td>#similarResult.refno#</td>
					<td>#similarResult.refno2#</td>
					<td>#similarResult.agenno#</td>
					<td nowrap>#dateformat(similarResult.wos_date,"dd-mm-yyyy")#</td>
					<td>#similarResult.fperiod#</td>
					<td nowrap>#similarResult.custno# - #similarResult.name#</td>
					<td>#similarResult.phone#</td>
					<td>#similarResult.userid#</td>
					<td align="center">
					<cfif tran eq 'DO' and toinv neq ''>
						Y
					</cfif>
					<cfif (tran eq 'INV' or tran eq 'RC' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN') and similarresult.posted neq ''>
						P
					</cfif>
					</td>
					<td align="right" nowrap>
					<cfif getgeneralinfo.printoption eq 1>
						<a href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
					<cfelse>
						<a href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
					</cfif>
					<!---
					<cfif hcomid eq 'msd' and tran eq "RC" and getpin2.h2101 eq 'T'>
						|&nbsp;<a href="../reports/grn_note.cfm?tran=#tran#&nexttranno=#refno#">GRN Note</a>&nbsp;
					</cfif>
					--->
					<cfif aledit eq 1>
						<a href="transaction1.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(similarResult.custno)#&first=0">
							<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit
						</a>
					</cfif>
					<cfif aldelete eq 1>
						<a href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(similarResult.custno)#&first=0">
							<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete
						</a>
					</cfif>
				</td>
			</tr>
			</cfoutput>
		</table>
	<cfelse>
		<h3>No Similar Records were found.</h3>
	</cfif>
</cfif>

<cfif getjob.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage = round(getJob.recordcount/20)>
		<cfif getJob.recordcount mod 20 LT 10 and getJob.recordcount mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	
	<cfform action="stransaction.cfm?tran=#tran#&tranname=#tranname#" method="post">
		<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
		<cfset noOfPage = round(getJob.recordcount/20)>
		
		<cfif getJob.recordcount mod 20 LT 10 and getJob.recordcount mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif isdefined("url.start")>
			<cfset start = url.start>
		</cfif>
		
		<cfif isdefined("form.skeypage")>
			<cfset start = form.skeypage * 20 + 1 - 20>
			<cfif form.skeypage eq "1">
				<cfset start = "1">
			</cfif>
		</cfif>

		<cfset prevTwenty = start -20>
		<cfset nextTwenty = start +20>
		<cfset page = round(nextTwenty/20)>

		<cfif start neq 1>
			<cfoutput>|| <a href="stransaction.cfm?tran=#tran#&start=#prevTwenty#">Previous</a> ||</cfoutput>
		</cfif>
		
		<cfif page neq noOfPage>
			<cfoutput> <a href="stransaction.cfm?tran=#tran#&start=#evaluate(nextTwenty)#">Next</a> ||</cfoutput>
		</cfif>

		<cfoutput>Page #page# Of #noOfPage#</cfoutput>
		</div>
		<hr>
		
		<table align="center" class="data">
  			<tr>
				<td colspan="9"><div align="center"><font color="#336699" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>#tranname#</cfoutput></strong></font></div></td>
  			</tr>
            <tr>
   	 			<th><cfoutput>#tranname# No</cfoutput></th>
				<th>Refno2</th>
				<th>Agent</th>
				<th>Date</th>
				<th>Period</th>
				<th>
				<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
					Supplier Name
				<cfelse>
					Customer Name
				</cfif>
				</th>
				<th>Phone</th>
				<th>User</th>
				<th>Status</th>
				<th>Action</th>
 		 	</tr>
			
			<cfoutput query="getjob" startrow="#start#" maxrows="20">
				<tr>
      				<td>#getjob.refno#</td>
	  				<td>#getjob.refno2#</td>
	  				<td>#getjob.agenno#</td>
        	  		<td nowrap>#dateformat(getjob.wos_date,"dd-mm-yyyy")#</td>
      				<td>#getjob.fperiod#</td>
      				<td nowrap>#getjob.custno# - #getjob.name#</td>
					<td>#getjob.phone#</td>
      				<td>#getjob.userid#</td>
	  				<td align="center">
						<cfif tran eq 'DO' and toinv neq ''>
							Y
						</cfif>
						<cfif (tran eq 'INV' or tran eq 'RC' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN') and getjob.posted neq ''>
							P
						</cfif>
					</td>
          			<td align="right" nowrap>
		  			<cfif getgeneralinfo.printoption eq 1>
						<a href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
					<cfelse>
						<a href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
					</cfif>
					<!---
 	  	  			<cfif hcomid eq 'msd' and tran eq "RC" and getpin2.h2101 eq 'T'>
	  	    			|&nbsp;<a href="../reports/grn_note.cfm?tran=#tran#&nexttranno=#refno#">GRN Note</a>&nbsp;
 		  			</cfif>
					--->
		  			<cfif aledit eq 1>
		  				<a href="transaction1.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(getjob.custno)#&first=0">
							<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit
						</a>
					</cfif>
            		<cfif aldelete eq 1>
						<a href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(getjob.custno)#&first=0">
							<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete
						</a>
					</cfif>
				</td>
    		</tr>
  		</cfoutput>
		</table>
		<hr>
		<div align="right">
		<cfif start neq 1>
			<cfoutput><a href="stransaction.cfm?tran=#tran#&start=#prevTwenty#">Previous</a> ||</cfoutput>
		</cfif>
		
		<cfif page neq noOfPage>
			<cfoutput> <a href="stransaction.cfm?tran=#tran#&start=#evaluate(nextTwenty)#">Next</a> ||</cfoutput>
		</cfif>
		
		<cfoutput>Page #page# Of #noOfPage#</cfoutput>
		</div>
	</cfform>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>

</body>
</html>