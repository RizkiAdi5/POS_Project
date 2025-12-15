<cfparam name="alcreate" default="0">
<cfparam name="aledit" default="0">
<cfparam name="aldelete" default="0">
<cfparam name="alown" default="0">

<cfswitch expression="#tran#">
	<cfcase value="RC,PR" delimiters=",">
		<cfset target_table= target_apvend>
	</cfcase>
	<cfdefaultcase>
		<cfset target_table= target_arcust>
	</cfdefaultcase>
</cfswitch>

<cfquery datasource="#dts#" name="getGeneralInfo1">
	Select lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM

	from GSetup
</cfquery>


<cfif tran eq "RC">
	<cfset tran = "RC">
	<cfset tranname = getGeneralInfo1.lRC>
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
	<cfset tranname = getGeneralInfo1.lPR>
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
	<cfset tranname = getGeneralInfo1.lDO>
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
	<cfset tranname = getGeneralInfo1.lINV>
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
	<cfset tranname = getGeneralInfo1.lCS>
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
	<cfset tranname = getGeneralInfo1.lCN>
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
	<cfset tranname = getGeneralInfo1.lDN>
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
	<cfset tranname = getGeneralInfo1.lPO>
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
	<cfset tranname = getGeneralInfo1.lQUO>
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
	<cfset tranname = getGeneralInfo1.lSO>
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
	<cfset tranname = getGeneralInfo1.lSAM>
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
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script language="javascript" type="text/javascript">
	function PopupCenter(pageURL, title,w,h) {
		var left = (screen.width/2)-(w/2);
		var top = (screen.height/2)-(h/2);
		var targetWin = window.open (pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
	} 
	function refreshpage(){
		setTimeout('window.location.reload();',500)
	}
</script>
</head>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<cfquery datasource="#dts#" name="getGeneralInfo">
	Select *
	from GSetup
</cfquery>

<cfquery name="getrecordcount" datasource="#dts#">
	select count(refno) as totalrecord from artran 
	where type='#tran#' and <cfif searchType eq 'brem2'>refno in (select refno from ictran where brem2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> and type='#tran#')<cfelseif searchType eq 'allphone'>
		(rem4 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
        frem6 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
        phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
        rem12 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
        comm4 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">
        )<cfelse>#searchtype# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchstr#%"></cfif>
	<cfif alown eq 1>
		<cfif getGeneralInfo.agentlistuserid eq "Y">and (ucase(artran.agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%") or ucase(artran.userid)='#ucase(huserid)#')
			<cfelse>
            and (ucase(artran.userid)='#ucase(huserid)#' or ucase(artran.agenno)='#ucase(huserid)#')  
			</cfif>
	<cfelse>	<!--- Add on 141108 --->
    <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
    <cfelse>
		<cfif Huserloc neq "All_loc">
			and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
		</cfif>
    </cfif>
	</cfif>
</cfquery>

<body>

<cfif getrecordcount.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage = round(getrecordcount.totalrecord/20)>
		<cfif getrecordcount.recordcount mod 20 LT 10 and getrecordcount.totalrecord mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	
	<cfform action="stransaction_similar.cfm?tran=#urlencodedformat(tran)#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#" method="post" target="_self">
		<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
		<cfset noOfPage = round(getrecordcount.totalrecord/20)>
		
		<cfif getrecordcount.totalrecord mod 20 LT 10 and getrecordcount.totalrecord mod 20 neq 0>
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
		
		
			<cfquery datasource='#dts#' name="getjob">
				select 
				artran.type,
				artran.refno,
                artran.desp,
				artran.refno2,
				artran.agenno,
                artran.updated_by,
                artran.source,
                artran.frem7,
                artran.rem1,
                artran.pono,
                artran.grand_bil,
				artran.wos_date,
				artran.fperiod,
				artran.custno,
				artran.name,
                artran.rem49,
				artran.userid,
				artran.posted,
				artran.generated,
				artran.void,
				toinv,
				artran.van,
				concat(dr.name,' ',dr.name2) as drivername,
				(select phone from #target_table# where custno=artran.custno) as phone ,
                printstatus
				from artran 
				
				left join driver dr on artran.van=dr.driverno
				
				where type='#tran#' and <cfif searchType eq 'brem2'>artran.refno in (select refno from ictran where brem2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> and type='#tran#')<cfelseif searchType eq 'allphone'>
		(rem4 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
        frem6 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
        phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
        rem12 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
        comm4 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">
        )<cfelse>artran.#searchtype# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchstr#%"></cfif>
				<cfif alown eq 1>
					and (artran.userid='#huserid#' or ucase(artran.agenno)='#ucase(huserid)#')
				<cfelse>	<!--- Add on 141108 --->
                <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
    			<cfelse>
					<cfif Huserloc neq "All_loc">
						and (artran.userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                </cfif>
				</cfif>
				<!--- and fperiod <> '99' ---> 
				order by artran.wos_date desc ,artran.refno desc 
				limit #start-1#,20;
			</cfquery>

		<cfif start neq 1>
			|| <a target="_self" href="stransaction_similar.cfm?tran=#tran#&start=#prevTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="stransaction_similar.cfm?tran=#tran#&start=#nextTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Next</a> ||
		</cfif>

		Page #page# Of #noOfPage#
		</div>
		<hr>

		<table align="center" class="data">
  			<tr>
				<td colspan="9"><div align="center"><font color="336699" size="3" face="Arial, Helvetica, sans-serif"><strong>#tranname#</strong></font></div></td>
  			</tr>
            <tr>
   	 			<th>#tranname# No</th>
                <cfif lcase(hcomid) eq "visionlaw_i" and (tran eq "sam" or tran eq "so" or tran eq "quo")>
                <th>Description</th>
                <cfelse>
                <cfif lcase(hcomid) neq "fdipx_i">
				<th>Refno2</th>
                </cfif>
                </cfif>
				<th>Agent</th>
                <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
        		<th>Pono</th>
        		</cfif>
                <cfif (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i") and tran eq "sam">
                <th>Project</th>
                </cfif>
				<th>Date</th>
				<th>Period</th>
				<th>
				<cfif tran eq "RC" or tran eq "PR" or tran eq "PO">
					Supplier Name
				<cfelse>
					<cfif lcase(hcomid) eq "ovas_i" and (tran eq "CS" or tran eq "DO" or tran eq "SO" or tran eq "SAM" or tran eq "CN" or tran eq "DN")><cfoutput>#getGeneralInfo.ldriver#</cfoutput><cfelse>Customer Name</cfif>
				</cfif>
				</th>
                
                <th>
				<cfoutput>#getGeneralInfo.ldriver#</cfoutput>
				</th>
                
                <cfif lcase(hcomid) eq "fdipx_i">
                <th>Item No</th>
                <th>Total Item</th>
                </cfif>
                <cfif lcase(hcomid) eq "tcds_i">
                <th>Total Qty</th>
                <th>Total Amount</th>
                </cfif>
                <cfif lcase(hcomid) eq "poria_i">
                <th>Delivery Code</th>
                </cfif>
				<th>Phone</th>
				<th>User</th>
                <cfif lcase(hcomid) eq "visionlaw_i">
                <th>Edit User</th>
                </cfif>
                <cfif lcase(hcomid) eq "fdipx_i" and tran eq "QUO">
        <th>DO</th>
        <th>INV</th>
        <th>PO</th>
        <th>CS</th>
        <cfelse>
				<th>Status</th>
                </cfif>
				<th>Action</th>
 		 	</tr>
			
			<cfloop query="getjob">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      				<td>#getjob.refno#</td>
                    <cfif lcase(hcomid) eq "visionlaw_i" and (tran eq "sam" or tran eq "so" or tran eq "quo")>
                    <td>#getjob.desp#</td>
                    <cfelse>
                    <cfif lcase(hcomid) neq "fdipx_i">
	  				<td>#getjob.refno2#</td>
                    </cfif>
                    </cfif>
	  				<td nowrap>#getjob.agenno#</td>
                    <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
                    <cfset ponolist=getjob.pono>
        
        			<td><cfloop list="#ponolist#" delimiters="," index="i">#i#<br></cfloop></td>
        			</cfif>
                    <cfif (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i") and tran eq "sam">
               		 <td>#getjob.source#</td>
               		 </cfif>
        	  		<td nowrap>#dateformat(getjob.wos_date,"dd-mm-yyyy")#</td>
      				<td>#getjob.fperiod#</td>
					<cfif lcase(hcomid) eq "ovas_i" and (tran eq "CS" or tran eq "DO" or tran eq "SO" or tran eq "SAM" or tran eq "CN" or tran eq "DN")>
						<td nowrap>#getjob.van# - #getjob.drivername#</td>
					<cfelse>
      					<td nowrap>#getjob.custno# - #getjob.name#</td>
					</cfif>
                    <td nowrap>#getjob.van# - #getjob.drivername#</td>
                    <cfif lcase(hcomid) eq "fdipx_i">
                    <cfquery name="get1stitem" datasource="#dts#">
                    select desp from ictran where refno='#refno#' and type='#tran#' and itemcount = '1'
                    </cfquery>
                    <cfquery name="gettotalitem" datasource="#dts#">
                    select itemno from ictran where refno='#refno#' and type='#tran#'
                    </cfquery>
                    <td nowrap>#get1stitem.desp#</td>
                    <td nowrap>#gettotalitem.recordcount#</td>
                    </cfif> 
                    <cfif lcase(hcomid) eq "tcds_i">
                    <cfquery name="gettotalqty" datasource="#dts#">
                    select sum(qty) as qty,sum(amt) as amt from ictran where refno='#refno#' and type='#tran#'
                    </cfquery>
                    <td nowrap align="center">#gettotalqty.qty#</td>
                    <td nowrap>#numberformat(gettotalqty.amt,',_.__')#</td>
                    </cfif>
                    <cfif lcase(hcomid) eq "poria_i">
                    <td nowrap>#getjob.rem1#</td>
                    </cfif>
					<td nowrap>#getjob.phone#</td>
      				<td>#getjob.userid#</td>
                    <cfif lcase(hcomid) eq "visionlaw_i">
                    <td>#getjob.updated_by#</td>
                    </cfif>
                    <cfif lcase(hcomid) eq "fdipx_i" and tran eq "QUO">
        <cfquery name="getupdatedbills" datasource="#dts#">
        select type from iclink where frtype='#tran#' and frrefno='#refno#'
        </cfquery>
        <cfset updateddo=0>
        <cfset updatedinv=0>
        <cfset updatedpo=0>
        <cfset updatedcs=0>
        <cfloop query="getupdatedbills">
        <cfif type eq 'do'><cfset updateddo=1></cfif>
        <cfif type eq 'inv'><cfset updatedinv=1></cfif>
        <cfif type eq 'po'><cfset updatedpo=1></cfif>
        <cfif type eq 'cs'><cfset updatedcs=1></cfif>
        </cfloop>
        <td><cfif updateddo eq 1>Y</cfif></td>
        <td><cfif updatedinv eq 1>Y</cfif></td>
        <td><cfif updatedpo eq 1>Y</cfif></td>
        <td><cfif updatedcs eq 1>Y</cfif></td>

        <cfelse>
	  				<td align="center">
						<cfif (tran eq 'DO' or tran eq 'PO' or tran eq 'SO' or tran eq 'QUO'  or tran eq 'SAMM' or tran eq 'SAM') and toinv eq 'C'>
							C<cfelseif (tran eq 'DO' or tran eq 'PO' or tran eq 'SO' or tran eq 'QUO'  or tran eq 'SAMM' or tran eq 'SAM') and toinv neq ''>
							Y
						</cfif>
						<cfif (tran eq 'INV' or tran eq 'RC' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN') and getjob.posted neq ''>
							P
						</cfif>
                        <cfif lcase(hcomid) eq "hunting_i" and tran eq 'SAM' and toinv eq '' and printstatus eq 'a3'>Approved</cfif>
						<cfif getjob.void neq ''>
							<font color="red"><strong>Void</strong></font>
						</cfif>
					</td>
                    </cfif>
                    <cfif lcase(hcomid) eq "glenndemo_i" or lcase(hcomid) eq "glenn_i">
                        <td align="right" nowrap>
							<cfif getgeneralinfo.printoption eq 1>
                                <a target="_blank" href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#"><img height="18px" width="18px" src="../../images/PNG-48/Print.png" alt="Print" border="0"></a>
                            <cfelse>
                                <a target="_blank" href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#"><img height="18px" width="18px" src="../../images/PNG-48/Print.png" alt="Print" border="0"></a>
                            </cfif>
                            <cfif aledit eq 1 and getjob.void eq "">
                                <a target="_parent" href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(getjob.custno)#&first=0">
                                    <img height="18px" width="18px" src="../../images/PNG-48/Modify.png" alt="Edit" border="0">
                                </a>
							<cfelse>
								<img height="18px" width="18px" src="../../images/PNG-48/iModify.png" alt="Not Allowed to Edit" border="0">
                            </cfif>
                            <cfif aldelete eq 1 and getjob.void eq "">
                                <a target="_parent" href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(getjob.custno)#&first=0">
                                    <img height="18px" width="18px" src="../../images/PNG-48/Delete.png" alt="Delete" border="0">
                                </a>
							<cfelse>
								<img height="18px" width="18px" src="../../images/PNG-48/iDelete.png" alt="Not Allowed to Delete" border="0">
                            </cfif>
							<cfif (tran eq "SO" and getpin2.h2886 eq 'T') or (tran eq "QUO" and (getpin2.h2875 eq 'T' or getpin2.h2876 eq 'T'))>
                                <cfif getjob.toinv neq "">
                                    <img height="18px" width="18px" src="../../images/PNG-48/Next_disabled.png" alt="Update" border="0">
                                <cfelse>
                                    <a href="update2/update.cfm?tran=#tran#&nexttranno=#refno#" target="_parent"><img height="18px" width="18px" src="../../images/PNG-48/Next.png" alt="Update" border="0"></a>
                                </cfif>
                            </cfif>
                        </td>
					<cfelse>
                        <td align="right" nowrap>
							<cfif getgeneralinfo.printoption eq 1>
                                <a target="_blank" href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#">Print</a>&nbsp;
                            <cfelse>
                                <a target="_blank" href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#">Print</a>&nbsp;
                            </cfif>
                            
                            <cfif getGeneralInfo.poapproval eq 'Y' and getjob.printstatus neq "a3" and tran eq "PO" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>		<input type="hidden" name="samid" id="samid" value="">
                <a style="cursor:pointer" onClick="document.getElementById('samid').value='#refno#';ColdFusion.Window.show('approvesample');"><img height="18px" width="18px" src="/images/tick.gif" alt="Edit" border="0">Approve</a>
                
				</cfif>
                            
                            <!---
                            <cfif hcomid eq 'msd' and tran eq "RC" and getpin2.h2101 eq 'T'>
                                |&nbsp;<a target="_blank" href="../reports/grn_note.cfm?tran=#tran#&nexttranno=#refno#">GRN Note</a>&nbsp;
                            </cfif>--->
                            <cfif aledit eq 1 and getjob.void eq "" and getjob.printstatus eq "">
							
                            <cfif getgeneralinfo.editbillpassword eq "1" and (getgeneralinfo.editbillpassword1 eq "" or ListFindNoCase(getgeneralinfo.editbillpassword1,tran))>
                    		<a href="javascript:void(0)" onClick="PopupCenter('editbillcontrol.cfm?tran=#tran#&refno=#refno#&parentpage=no&type=edit','linkname','500','500');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
                			<cfelse>
                            
									<cfif getgeneralinfo.generateQuoRevision eq "1" and (getgeneralinfo.generateQuoRevision1 eq "" or ListFindNoCase(getgeneralinfo.generateQuoRevision1,tran))>
										<a href="javascript:void(0)" onClick="PopupCenter('tran_edit2a.cfm?tran=#tran#&refno=#refno#&parentpage=yes','linkname','200','100');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
									<cfelse>
		                                <a target="_parent" href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(getjob.custno)#&first=0">
		                                    <img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit
		                                </a>
									</cfif>
							</cfif>
							<cfelse>
								<img height="18px" width="18px" src="../../images/edit.ICO" alt="Not Allowed to Edit" border="0">Edit
                            </cfif>
                            <cfif getpin2.H2890 eq 'T'>
                <img height="18px" width="18px" src="../../images/Copy Icon.jpg" alt="Copy" border="0"><a onMouseOver="this.style.cursor='hand'" onClick="window.open('copyfunction.cfm?refno=#refno#&type=#tran#');">Copy</a>
                </cfif>
                            <cfif aldelete eq 1 and getjob.void eq "" and getjob.printstatus eq "">
                            <cfif getgeneralinfo.editbillpassword eq "1" and (getgeneralinfo.editbillpassword1 eq "" or ListFindNoCase(getgeneralinfo.editbillpassword1,tran))>
                    		<a href="javascript:void(0)" onClick="PopupCenter('editbillcontrol.cfm?tran=#tran#&refno=#refno#&parentpage=no&type=delete','linkname','500','500');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Delete</a>
                			<cfelse>
                                <a target="_parent" href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(getjob.custno)#&first=0">
                                    <img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete
                                </a>
							</cfif>
                            <cfelse>
								<img height="18px" width="18px" src="../../images/delete.ICO" alt="Not Allowed to Delete" border="0">Delete
                            </cfif>
                           <cfif lcase(hcomid) eq "tcds_i" and tran eq 'RC' and rem49 neq 'checked'>
                	<a href="clearorder.cfm?tran=#tran#&refno=#refno#"><img height="18px" width="18px" src="../../images/foldoutmenu2_arrow.gif" border="0">Clear Order</a>
                </cfif>
                        </td>
					</cfif>
    			</tr>
  			</cfloop>
		</table>
		<hr>
		<div align="right">
		<cfif start neq 1>
			<a target="_self" href="stransaction_similar.cfm?tran=#tran#&start=#prevTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="stransaction_similar.cfm?tran=#tran#&start=#nextTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Next</a> ||
		</cfif>
		
		Page #page# Of #noOfPage#
		</div>
	</cfform>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>
</cfoutput>

</body>
</html>

<cfif getGeneralInfo.poapproval eq 'Y' and getjob.printstatus neq "a3" and tran eq "PO" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>
  <cfajaximport tags="cfform">
 <cfwindow name="approvesample" width="400" height="400" source="approvesample.cfm?tran=#tran#&refno={samid}" modal="true" title="Approval" closable="true" draggable="true"  refreshonshow="true" />
  </cfif>