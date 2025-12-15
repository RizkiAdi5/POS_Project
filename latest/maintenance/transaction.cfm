<cfajaximport tags="cfform">

<cfparam name="alcreate" default="0">	<!--- Authority to Create New --->
<cfparam name="alcopy" default="0">	<!--- Authority to Create New --->
<cfparam name="aledit" default="0">		<!--- Authority to Edit --->
<cfparam name="aldelete" default="0">	<!--- Authority to Delete --->
<cfparam name="alown" default="0">		<!--- Authority to View Own Document --->
<cfparam name="alsimple" default="0">
<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfquery datasource="#dts#" name="getGeneralInfo1">
	Select * from GSetup
</cfquery>

<cfquery name="getremarkdetail" datasource="#dts#">
	select * 
	from extraremark;
</cfquery>

<cfquery name="getmodule" datasource="#dts#">
    select * from modulecontrol
</cfquery>

<cfquery name="getdisplaysetup" datasource="#dts#">
    select * from displaysetup
</cfquery>

<cfif tran eq "RC">
  	<cfset tran = "RC">
  	<cfset tranname = getGeneralInfo1.lRC>
  	<cfset trancode = "rcno">
  	<cfset tranarun = "rcarun">

	<cfif getpin2.h2102 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h2892 eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h2108 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
    
</cfif>

<cfif tran eq "PR">
	<cfset tran = "PR">
	<cfset tranname = getGeneralInfo1.lPR>
	<cfset trancode = "prno">
	<cfset tranarun = "prarun">

	<cfif getpin2.h2201 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
	
    <cfif getpin2.h2893 eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h2207 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "DO">
	<cfset tran = "DO">
	<cfset tranname = getGeneralInfo1.lDO>
	<cfset trancode = "dono">
	<cfset tranarun = "doarun">

	<cfif getpin2.h2301 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h2894 eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h2308 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "INV">
	<cfset tran = "INV">
	<cfset tranname = getGeneralInfo1.lINV>
	<cfset trancode = "invno">
	<cfset tranarun = "invarun">

	<cfif getpin2.h2401 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h2891 eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h2407 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "CS">
	<cfset tran = "CS">
	<cfset tranname = getGeneralInfo1.lCS>
	<cfset trancode = "csno">
	<cfset tranarun = "csarun">

	<cfif getpin2.h2501 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h2895 eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h2507 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "CN">
	<cfset tran = "CN">
	<cfset tranname = getGeneralInfo1.lCN>
	<cfset trancode = "cnno">
	<cfset tranarun = "cnarun">

	<cfif getpin2.h2601 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h2896 eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h2607 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "DN">
	<cfset tran = "DN">
	<cfset tranname = getGeneralInfo1.lDN>
	<cfset trancode = "dnno">
	<cfset tranarun = "dnarun">

	<cfif getpin2.h2701 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h2897 eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h2707 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "PO">
	<cfset tran = "PO">
	<cfset tranname = getGeneralInfo1.lPO>
	<cfset trancode = "pono">
	<cfset tranarun = "poarun">

	<cfif getpin2.h2861 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>

	<cfif getpin2.h2862 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
    
    <cfif getpin2.h2899 eq 'T'>
  		<cfset alcopy = 1>
  	</cfif>

	<cfif getpin2.h2863 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>

	<cfif getpin2.h2864 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
    
    <cfif getpin2.h2869 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "QUO">
	<cfset tran = "QUO">
	<cfset tranname = getGeneralInfo1.lQUO>
	<cfset trancode = "quono">
	<cfset tranarun = "quoarun">

	<cfif getpin2.h2871 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h289B eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h287C eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "SO">
	<cfset tran = "SO">
	<cfset tranname = getGeneralInfo1.lSO>
	<cfset trancode = "sono">
	<cfset tranarun = "soarun">

	<cfif getpin2.h2881 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h289A eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h288A eq 'T'>
  		<cfset alsimple = 1>
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
    
    <cfif getpin2.h289D eq 'T'>
  		<cfset alcopy = 1>
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
    
    <cfif getpin2.h2858 eq 'T'>
  		<cfset alsimple = 1>
  	</cfif>
</cfif>

<cfif tran eq "RQ">
	<cfset tran = "RQ">
	<cfset tranname = getGeneralInfo1.lRQ>
	<cfset trancode = "rqno">
	<cfset tranarun = "rqarun">

	<cfif getpin2.h28G1 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
    
    <cfif getpin2.h2899 eq 'T'>
  		<cfset alcopy = 1>
  	</cfif>

	<cfif getpin2.h28G2 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>

	<cfif getpin2.h28G3 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>

	<cfif getpin2.h28G4 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
    
    <cfif getpin2.h28G1 eq 'T'>
  		<cfset alsimple = 1>
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

<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>


<html>
<head>
	<title><cfoutput>#tranname#</cfoutput> Main Page</title>
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	
	<script language="javascript" type="text/javascript">
	function PopupCenter(pageURL, title,w,h) {
		var left = (screen.width/2)-(w/2);
		var top = (screen.height/2)-(h/2);
		var targetWin = window.open (pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
	} 
	
	function Popupfull(pageURL, title) {
		var left = (screen.width/2);
		var pageheight = (screen.height)-100;
		var targetWin = window.open (pageURL,title, 'scrollbars=yes,'+'width='+screen.width+', height='+pageheight+', top=0, left=0');
	} 
	
	</script>
</head>

<cfquery datasource="#dts#" name="getGeneralInfo">
	Select #trancode# as tranno,delinvoice, #tranarun#, invsecure,printoption,
	invoneset,rc_oneset,pr_oneset,do_oneset,cs_oneset,cn_oneset,dn_oneset,iss_oneset,
	po_oneset,so_oneset, quo_oneset, assm_oneset, tr_oneset, oai_oneset, oar_oneset, sam_oneset,ldriver,agentlistuserid,poapproval,rem5,rem6,rem11,refno2
,generateQuoRevision,revStyle,generateQuoRevision1,ddltran,editbillpassword,editbillpassword1
	from GSetup
</cfquery>

<cfquery name="getRemarkDetails" datasource="#dts#">
	SELECT rem30,rem32 
	FROM extraremark;
</cfquery>

<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
</cfquery>


<cfquery datasource="#dts#" name="getRefnoset">
	select lastUsedNo as tranno, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = 1
</cfquery>

<cfif lcase(HcomID) eq "mhca_i" and tran eq "INV">
	<cfquery datasource="#dts#" name="getRefnoset2">
		select lastUsedNo as tranno, refnoused as arun from refnoset
		where type = '#tran#'
		and counter = 2
	</cfquery>
</cfif>

<cfif lcase(hcomid) eq "ovas_i" and (tran eq "CS" or tran eq "DO" or tran eq "SO" or tran eq "SAM" or tran eq "CN" or tran eq "DN")>
	<cfquery datasource='#dts#' name="gettransaction">
		Select a.*,concat(dr.name,' ',dr.name2) as drivername 
		from artran a
		left join driver dr on a.van=dr.driverno
		where type='#tran#' 
		<cfif alown eq 1>
			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#') 
		<cfelse>
			<cfif Huserloc neq "All_loc">
				and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
		</cfif> <!--- and fperiod <> '99' ---> 
		order by 
        <cfif lcase(hcomid) eq "kingston_i">
        wos_date desc,right(refno,'4') desc
        <cfelseif lcase(hcomid) eq "sinlian_i">
        length(refno) desc,refno desc
        <cfelse>
		<cfif getdealer_menu.transactionSortBy neq "">#getdealer_menu.transactionSortBy#<cfelse>wos_date desc,refno desc</cfif>
        </cfif>
		limit 20
	</cfquery>
<cfelse>
	<cfquery datasource='#dts#' name="gettransaction">
		Select * 
		from artran 
		where type='#tran#' 
		<cfif alown eq 1>
			<cfif getGeneralInfo.agentlistuserid eq "Y">and (ucase(agenno) in (SELECT agent FROM #target_icagent# WHERE agentlist like "%#ucase(huserid)#%") or ucase(userid)='#ucase(huserid)#')
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#' or (ucase(agenno) in (SELECT agent FROM #target_icagent# WHERE ucase(agentid) like "%#ucase(huserid)#%")))  
			</cfif>
		<cfelse>
        <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Van Sales')>
    	<cfelse>
			<cfif Huserloc neq "All_loc">
				and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
        </cfif>
		</cfif> <!--- and fperiod <> '99' ---> 
        <cfif lcase(husergrpid) eq 'sales' and lcase(hcomid) eq "sosbat_i" or lcase(hcomid) eq "netivan_i">
        and refno like '%R%'
        <cfelseif lcase(husergrpid) eq 'workshop' and lcase(hcomid) eq "sosbat_i" or lcase(hcomid) eq "netivan_i">
        and refno like '%WS%'
        </cfif>
        
		order by 
		<cfif (lcase(hcomid) eq "iel_i" or lcase(hcomid) eq "ielm_i") and tran eq "INV">
			substring_index(refno,'/',-1) desc,substring_index(substring_index(refno,'/',1),'.',-1) desc,substring_index(refno,'.',1) desc
		<cfelse>
		<cfif lcase(hcomid) eq "kingston_i">
        wos_date desc,right(refno,'4') desc
        <cfelseif lcase(hcomid) eq "sinlian_i">
        length(refno) desc,refno desc
        <cfelse>
		<cfif getdealer_menu.transactionSortBy neq "">#getdealer_menu.transactionSortBy#<cfelse>wos_date desp,refno desp</cfif>
        </cfif>
		</cfif> 
		limit 20
	</cfquery>
</cfif>

<body>
 <cfif lcase(hcomid) eq "hunting_i" and tran eq "Sam" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>

 <cfwindow name="approvesample" width="400" height="400" source="approvesample.cfm?tran=#tran#&refno={samid}" modal="true" title="Approval" closable="true" draggable="true" center="true" refreshonshow="true" />
 </cfif>
  <cfif getGeneralInfo.poapproval eq 'Y' and tran eq "PO" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>

 <cfwindow name="approvesample" width="400" height="400" source="approvesample.cfm?tran=#tran#&refno={samid}" modal="true" title="Approval" closable="true" draggable="true" center="true" refreshonshow="true" />
  </cfif>
  <cfif (hcomid eq "asiasoft_i" or  hcomid eq "asaiki_i") and tran eq "SO" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super" or HUserGrpID eq "General")>

 <cfwindow name="approveso" width="400" height="400" source="approveso.cfm?tran=#tran#&refno={soid}" modal="true" title="Approval" closable="true" draggable="true" center="true" refreshonshow="true" />
 <input type="hidden" name="soid" id="soid" value="">
  </cfif>
<cfoutput><!---1. Match output at line 38 --->
<cfif husergrpid eq "Muser"><a href="../home2.cfm"><u>Home</u></a></cfif>
	<h1>#tranname# Main Menu</h1>
	<h4>
		<cfif alcreate eq 1>
			<cfif HcomID eq "pnp_i">
				<cfinclude template="../../pnp/get_authorised_multi_invoive.cfm">
            <cfelseif (lcase(HcomID) eq "imperial1_i" or lcase(HcomID) eq "coolnlite_i") and tran eq 'SAM'>
         			<a href="servicededuction.cfm">Create New #tranname#</a> || 
			<cfelse>
				<cfif getgeneralinfo.invoneset neq '1' and tran eq 'INV'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.rc_oneset neq '1' and tran eq 'RC'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.pr_oneset neq '1' and tran eq 'PR'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.do_oneset neq '1' and tran eq 'DO'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.cs_oneset neq '1' and tran eq 'CS'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.cn_oneset neq '1' and tran eq 'CN'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.dn_oneset neq '1' and tran eq 'DN'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.iss_oneset neq '1' and tran eq 'ISS'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.po_oneset neq '1' and tran eq 'PO'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.so_oneset neq '1' and tran eq 'SO'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.quo_oneset neq '1' and tran eq 'QUO'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.assm_oneset neq '1' and tran eq 'ASSM'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.tr_oneset neq '1' and tran eq 'TR'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.oai_oneset neq '1' and tran eq 'OAI'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.oar_oneset neq '1' and tran eq 'OAR'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.sam_oneset neq '1' and tran eq 'SAM'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelse>
					<a href="transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&first=0">Create New #tranname#</a>
				</cfif> || 
			</cfif>		
		</cfif>
		<!--- <a href="transaction.cfm?tran=#tran#">List All #tranname#</a> || --->
		<a href="stransaction.cfm?tran=#tran#&searchtype=&searchstr=">Search For #tranname#</a>
		<!---<cfif tran eq "SO" and hcomid eq "MSD">
		|| <a href="transaction_report.cfm?type=10">#tranname# Reports</a>
		</cfif>--->
        <cfif tran eq "QUO">
        ||<a href="closequo.cfm">Close #tranname#</a>
        ||<a href="unclosequo.cfm">Unclose #tranname#</a>
        </cfif>
         <cfif lcase(HcomID) eq "solidlogic_i"> || <a href="/default/transaction/printUnprint/printUnprint.cfm?tran=#tran#">Print Unprint #tranname#</a></cfif>
         <cfif lcase(hcomid) eq "polypet_i" and tran eq "CS">
         <cfif getpin2.H2890 eq 'T'>
         || <a href="/default/transaction/polypettransaction.cfm?tran=#tran#">Delivery</a>
         </cfif>
         </cfif>
         
         <cfif getmodule.simpletran eq 1>
         <cfif alsimple eq 1>
         <cfif tran eq 'INV'>
         <cfif getGeneralInfo1.simpleinvtype eq '2'>
         <cfif getmodule.auto eq "1">
         <cfelse>
         <cfif lcase(HcomID) eq "tranz_i">
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/expresstranzplus/index.cfm?first=true&type=#tran#','','fullscreen=yes,scrollbars=yes')">
				Simple New Multilocation
			</a>
         <cfelse>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/expresstran/index.cfm?first=true&type=#tran#','','fullscreen=yes,scrollbars=yes')">
				Simple New
			</a>
         </cfif>
          </cfif>
          <cfelse>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/POS2/index.cfm?first=true')">
				Simple New
			</a>
         
         </cfif>
         <cfelseif lcase(HcomID) eq "ugateway_i" and tran eq "SO">
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/expressSO/index.cfm?first=true','','fullscreen=yes,scrollbars=yes')">
				Simple New SO
			</a>
         <cfelseif getmodule.auto eq "1" and (tran eq 'SO' or tran eq 'CN')>
         
        
         <cfelse>
         <cfif lcase(HcomID) eq "tranz_i">
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/expresstranzplus/index.cfm?first=true&type=#tran#','','fullscreen=yes,scrollbars=yes')">
				Simple New Multilocation
			</a>
         <cfelse>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/expresstran/index.cfm?first=true&type=#tran#','','fullscreen=yes,scrollbars=yes')">
				Simple New
			</a>
         </cfif>
         </cfif>
         </cfif>
         </cfif>
         
          <cfif (lcase(HcomID) eq "atc2000_i" or lcase(HcomID) eq "atc2005_i") and (tran eq 'SO')>
         || <a href="/default/transaction/expressatc/searchmember.cfm" target="mainFrame">
         Cake Order
         </a></cfif>
         <cfif getmodule.matrixtran eq 1>
         <cfif alcreate eq 1>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/matrixexpressbill/index.cfm?first=true&tran=#tran#','','fullscreen=yes,scrollbars=yes')">
				Matrix New
			</a>
         </cfif>
         </cfif>
         
         
         <cfif getmodule.auto eq "1" and (tran eq 'SO' or tran eq 'INV' or tran eq 'CN')>
         <cfif alsimple eq 1>
         <cfif lcase(HcomID) eq "ltm_i" or lcase(HcomID) eq "netilung_i" or lcase(HcomID) eq "imperial1_i" or lcase(HcomID) eq "coolnlite_i" or lcase(HcomID) eq "sosbat_i" or lcase(hcomid) eq "netivan_i">
         <cfif lcase(HcomID) eq "sosbat_i" or lcase(hcomid) eq "netivan_i">
         || <a href="/newbody.cfm" target="mainFrame" onClick="Popupfull('/default/transaction/vehicletran/index.cfm?first=true&tran=#tran#','linkname');">
			New #tranname#
			</a>
         <cfelse>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/vehicletran/index.cfm?first=true&tran=#tran#','','fullscreen=yes,scrollbars=yes')">
			New #tranname#
			</a>
         </cfif>
         <cfelse>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/shelltran/index.cfm?first=true&tran=#tran#','','fullscreen=yes,scrollbars=yes')">
			New #tranname#
			</a>
         </cfif>
         </cfif>
         </cfif>
         
	</h4>
	<!--- BEGIN: ADD ON 180608, REPLACE THE BOTTOM ONE --->
	<p>
		<strong><br>Last Used #tran# No :</strong><font color="##FF0000"><strong>#getRefnoset.tranno#</strong></font>
		<cfif lcase(HcomID) eq "mhca_i" and tran eq "INV">
			<strong>&nbsp;&nbsp;&nbsp;&nbsp;Last Used #tran# No (Foreign):</strong><font color="##FF0000"><strong>#getRefnoset2.tranno#</strong></font>
		</cfif>
  <cfif tran eq "DO">
			<cfif getpin2.h2305 eq 'T'>
				<h2><a href="update/update.cfm?t1=DO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo1.lINV#</a></h2>
			</cfif>
  </cfif>
		<cfif tran eq "PO">
		<h2>
			<cfif getpin2.h2865 eq 'T'>
				<a href="update/update.cfm?t1=PO&t2=RC"><img src="../../images/arrow.png" alt="Update to Purchase Receive" name="updateBtn2" border="0"> Update To #getGeneralInfo1.lRC#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>

			<cfif getpin2.h2866 eq 'T'>
				<a href="update/update.cfm?t1=PO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn3" border="0"> Update To #getGeneralInfo1.lINV#</a>			
			</cfif>
		</h2>
		</cfif>
        <cfif tran eq "RQ">
		<h2>
			<cfif getpin2.h28G5 eq 'T'>
				<a href="update/updateA.cfm?t1=RQ&t2=PO"><img src="../../images/arrow.png" alt="Update to Purchase Order" name="updateBtn4" border="0"> Update To #getGeneralInfo1.lPO#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
        </h2>
        </cfif>
        
		<cfif tran eq "SO">
		<h2>
			<cfif getpin2.h2885 eq 'T'>
				<a href="update/update.cfm?t1=SO&t2=DO"><img src="../../images/arrow.png" alt="Update to Delivery Order" name="updateBtn4" border="0"> Update To #getGeneralInfo1.lDO#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>

			<cfif getpin2.h2886 eq 'T'>
				<cfif lcase(hcomid) eq "solidlogic_i">
					<a href="update/s_update.cfm?t1=SO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> Update To #getGeneralInfo1.lINV#</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<cfelse>
					<a href="update/update.cfm?t1=SO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> Update To #getGeneralInfo1.lINV#</a>&nbsp;&nbsp;&nbsp;&nbsp;
				</cfif>
			</cfif>

			<cfif getpin2.h2887 eq 'T'>
			<a href="update/update.cfm?t1=SO&t2=PO"><img src="../../images/arrow.png" alt="Update to Purchase Order" name="updateBtn6" border="0"> Update To #getGeneralInfo1.lPO#</a>
            <a href="update/update.cfm?t1=SO&t2=RC"><img src="../../images/arrow.png" alt="Update to Purchase Receive" name="updateBtn6" border="0"> Update To #getGeneralInfo1.lRC#</a>
            <a href="update/update.cfm?t1=SO&t2=RQ"><img src="../../images/arrow.png" alt="Update to Purchase requisition " name="updateBtn6" border="0"> Update To #getGeneralInfo1.lRQ#</a>
            
               
			</cfif>
            <cfif getpin2.h2887 eq 'T' and (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i" or lcase(hcomid) eq "atc2005_i") >
            <a href="update/s_update.cfm?t1=SO&t2=SAM"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> Update To Work Order (Sample)</a>&nbsp;&nbsp;&nbsp;&nbsp;
            </cfif>
            <cfif getpin2.h2887 eq 'T' and (lcase(hcomid) eq "asaiki_i") >
            <a href="update/s_update.cfm?t1=SO&t2=SAM"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> Update To Packinglist (Sample)</a>&nbsp;&nbsp;&nbsp;&nbsp;
            </cfif>
            
            <cfif getpin2.H2879 eq 'T'>
				<a href="update/update.cfm?t1=SO&t2=CS"><img src="../../images/arrow.png" alt="Update to Cash Sales" name="updateBtn8" border="0"> Update To #getGeneralInfo1.lCS#</a>
			</cfif>
		</h2>
		</cfif>
		<cfif tran eq "QUO">
		<h2>
			<cfif getpin2.h2875 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=SO"><img src="../../images/arrow.png" alt="Update to Sales Order" name="updateBtn7" border="0"> Update To #getGeneralInfo1.lSO#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
			
			<cfif getpin2.H2877 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=DO"><img src="../../images/arrow.png" alt="Update to Delivery Order" name="updateBtn8" border="0"> Update To #getGeneralInfo1.lDO#</a>
			</cfif>

			<cfif getpin2.h2876 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn8" border="0"> Update To #getGeneralInfo1.lINV#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
			
			<cfif getpin2.H2878 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=PO"><img src="../../images/arrow.png" alt="Update to Purchase Order" name="updateBtn8" border="0"> Update To #getGeneralInfo1.lPO#</a>
			</cfif>
			
			<cfif getpin2.H2879 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=CS"><img src="../../images/arrow.png" alt="Update to Cash Sales" name="updateBtn8" border="0"> Update To #getGeneralInfo1.lCS#</a>
			</cfif>
		</h2>
		</cfif>
        <cfif tran eq "SAM">
			<cfif getpin2.H2855 eq 'T'>
				<h2><a href="update/update.cfm?t1=SAM&t2=SO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo1.lSO#</a>&nbsp;&nbsp;<a href="update/update.cfm?t1=SAM&t2=DO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo1.lDO#</a></h2>
			</cfif>
		</cfif>
        <cfif tran eq "SAMM">
			<cfif getpin2.H2855 eq 'T'>
				<h2><a href="update/update.cfm?t1=SAMM&t2=QUO"><img src="/images/arrow.png" alt="Update to Quotation" name="updateBtn" border="0"> Update To #getGeneralInfo1.lQUO#</a><!--- &nbsp;&nbsp;<a href="update/update.cfm?t1=SAM&t2=DO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo1.lDO#</a> ---></h2>
			</cfif>
		</cfif>
        <cfif tran eq "RC" and hcomid eq "asiasoft_i">
        <h2><a href="/default/transaction/rctoinv/list.cfm" target="_blank"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo1.lINV#</a><!--- &nbsp;&nbsp;<a href="update/update.cfm?t1=SAM&t2=DO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo1.lDO#</a> ---></h2>
        </cfif>
        <cfif lcase(hcomid) eq "fixics_i">
        <cfif tran eq "INV" or tran eq "DO" or tran eq "QUO">
        	<h2><a href="update/Fixicsupdate.cfm?t1=#tran#"><img src="/images/arrow.png" alt="Update to Ticket" name="updateBtn" border="0"> Update To Ticket</a></h2>
        </cfif>
        </cfif>
	</p>
	<!--- END: ADD ON 180608, REPLACE THE BOTTOM ONE --->
  <form action="stransaction.cfm" method="post">
	<h1>Search By :
	<select name="searchType" id="searchType" onChange="if(document.getElementById('searchType').options[document.getElementById('searchType').selectedIndex].value=='status'){document.getElementById('searchStr').value='updated'}else{document.getElementById('searchStr').value=''}">
    	<cfif getmodule.auto eq "1">
        <option value="rem5" selected>Vehicle Number</option>
        <cfif getGeneralInfo.rem11 neq ''>
        <option value="rem11">#getGeneralInfo.rem11#</option>
        </cfif>
        <option value="refno">#tranname# No</option>
        
		<option value="refno2">#getGeneralInfo.refno2#</option>
		<cfif tran eq "RC" or tran eq "PR" or tran eq "PO" or tran eq "RQ">
			<option value="custno">Supplier No</option>
			<option value="name">Supplier Name</option>
		<cfelse>
			<option value="custno">Customer No</option>
			<option value="name" >Customer Name</option>
		</cfif>
        
		<option value="agenno"><cfoutput>
#getGeneralInfo1.lagent#</cfoutput></option>
		<option value="fperiod" >Period</option>
		<option value="rem4" >Phone</option>
        <option value="wos_date" >Date (DDMMYYYY)</option>
        <option value="pono">PO/SO</option>
        <option value="sono" >SO</option>
        <option value="phonea" >Phone 2</option>
        <option value="frem6" >Fax</option>
        <option value="allphone" >Phone All</option>
        <option value="source" >Project</option>
        <option value="job" >Job</option>
        <option value="status">Status(updated/approved)</option>
        <option value="created_by" <cfif getGeneralInfo.ddltran eq "created_by">selected</cfif>>Created By</option>
        <cfif lcase(hcomid) eq "ltm_i">
        <option value="rem45">Status</option>
        </cfif>
        
        <cfelse>
        
		<option value="refno" <cfif getGeneralInfo.ddltran eq "Refno">selected</cfif>>#tranname# No</option>
		<option value="refno2" <cfif getGeneralInfo.ddltran eq "Refno2">selected</cfif>>#getGeneralInfo.refno2#</option>
		<cfif tran eq "RC" or tran eq "PR" or tran eq "PO" or tran eq "RQ">
			<option value="custno" <cfif getGeneralInfo.ddltran eq "Supplier/Customer ID">selected</cfif>>Supplier No</option>
			<option value="name" <cfif getGeneralInfo.ddltran eq "Supplier/Customer Name">selected</cfif>>Supplier Name</option>
		<cfelse>
			<option value="custno" <cfif getGeneralInfo.ddltran eq "Supplier/Customer ID">selected</cfif>>Customer No</option>
			<option value="name" <cfif getGeneralInfo.ddltran eq "Supplier/Customer Name">selected</cfif>>Customer Name</option>
		</cfif>
        <cfif lcase(hcomid) eq 'thats_i'>
        <option value="no">PRC no</option>
        <option value="work">Work Order</option>
        </cfif>
		<option value="agenno" <cfif getGeneralInfo.ddltran eq "Agent">selected</cfif>><cfoutput>
#getGeneralInfo1.lagent#</cfoutput></option>
		<option value="fperiod" <cfif getGeneralInfo.ddltran eq "Period">selected</cfif>>Period</option>
		<option value="rem4" <cfif getGeneralInfo.ddltran eq "Phone">selected</cfif>>Phone</option>
		<cfif checkcustom.customcompany eq "Y">
			<option value="rem5">Permit Number</option>
		</cfif>
        <option value="wos_date" <cfif getGeneralInfo.ddltran eq "Date">selected</cfif>>Date (DDMMYYYY)</option>
        <option value="pono">PO/SO</option>
        <option value="sono" >SO</option>
        <option value="dono" >DO</option>
        <option value="phonea" >Phone 2</option>
        <option value="frem6" >Fax</option>
        <option value="allphone" >Phone All</option>
        <option value="source" >Project</option>
        <option value="job" >Job</option>
        <option value="void" >Void</option>
        <option value="van" >#getGeneralInfo.ldriver#</option>
        <option value="status">Status(updated/approved)</option>
        <option value="LeftName" <cfif getGeneralInfo.ddltran eq "Left Name">selected</cfif>>Left Name</option>
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
        
        <cfif lcase(hcomid) eq "ascend_i" or lcase(hcomid) eq "hodaka_i">
        <option value="rem6">#getGeneralInfo.rem6#</option>
        </cfif>

        	<option value="rem30">#getremarkdetail.rem30#</option>
 
        	<option value="rem31">#getremarkdetail.rem31#</option>

        	<option value="rem32">#getremarkdetail.rem32#</option>

        
        <option value="created_by" <cfif getGeneralInfo.ddltran eq "created_by">selected</cfif>>Created By</option>
        </cfif>
	</select>
		
	<input type="hidden" name="tran" id="tran" value="#tran#"> 
	Search for 
	<input type="text" name="searchStr" id="searchStr" value="" onKeyUp="ajaxFunction(document.getElementById('searchtranajax'),'/default/transaction/transactionajax.cfm?tran='+document.getElementById('tran').value+'&searchType='+escape(document.getElementById('searchType').value)+'&searchStr='+escape(document.getElementById('searchStr').value));">
	</h1>
</form>
	<hr>
</cfoutput><!---1. Match output at line 28 --->
<div id="searchtranajax">
<table align="center" class="data">
	<tr>
    	<td colspan="8">
		<div align="center">
		<font color="#336699" size="3" face="Arial, Helvetica, sans-serif"><strong>Newest 20 <cfoutput>#tranname#</cfoutput></strong></font></div>
        <input type="hidden" name="samid" id="samid" value="">
        </td>
  	</tr>
  	<tr>
    	<cfif getdisplaysetup.bill_refno eq 'Y'>
    	<th><cfoutput>#tranname#</cfoutput> No</th>
        </cfif>
        <cfif getdisplaysetup.bill_name eq 'Y'>
        <th>Description</th>
        </cfif>
        <cfif getdisplaysetup.bill_toinv eq 'Y'>
        <th>To Inv</th>
        </cfif>
        <cfif getdisplaysetup.bill_refno2 eq 'Y'>
        <cfoutput>
		<th>#getGeneralInfo1.refno2#</th>
        </cfoutput>
        </cfif>
        <cfif getdisplaysetup.bill_SO eq 'Y'>
        <th>SO No</th>
        </cfif>
        <cfif getdisplaysetup.bill_PO eq 'Y'>
        <cfif lcase(hcomid) eq "gorgeous_i" or lcase(hcomid) eq "mastercare_i">
        <th> P/O</th>
        <cfelse>
        <th>Pono</th>
        </cfif>
        </cfif>
        <cfif getdisplaysetup.bill_agent eq 'Y'>
        <cfoutput>
		<th>#getGeneralInfo1.lagent#</th>
		</cfoutput>
        </cfif>
        <cfif getdisplaysetup.bill_driver eq 'Y'>
        <cfoutput>
		<th>#getGeneralInfo.ldriver#</th>
        </cfoutput>
        </cfif>
        <cfif getdisplaysetup.bill_project eq 'Y'>
        <th>Project</th>
        </cfif>
        <cfif getdisplaysetup.bill_projectdesp eq 'Y'>
        <th>Project Description</th>
        </cfif>
        <cfif getdisplaysetup.bill_job eq 'Y'>
        <th>Job</th>
        </cfif>
        <cfif getdisplaysetup.bill_date eq 'Y'>
    	<th>Date</th>
        </cfif>
        <cfif getdisplaysetup.bill_period eq 'Y'>
    	<th>Period</th>
        </cfif>
        <cfif getdisplaysetup.bill_custno eq 'Y'>
    	<th>
			<cfif tran eq "rc" or tran eq "pr" or tran eq "po" or tran eq "rq">
				Supplier Name
			<cfelse>
				Customer Name
			</cfif>
		</th>
        </cfif>
        <cfif getdisplaysetup.billbody_dadd eq 'Y'>
        <th>Delivery Name</th>
        </cfif>
        <cfif getdisplaysetup.bill_b_attn eq 'Y'>
        <th>B_Attn</th>
        </cfif>
        <cfif getdisplaysetup.bill_created eq 'Y'>
        <th>Created By</th>
        </cfif>
        <cfif getdisplaysetup.bill_currcode eq 'Y'>
        <th>Currency Code</th>
        </cfif>
        <cfif getdisplaysetup.bill_term eq 'Y'>
        <th>Terms</th>
        </cfif>
        <cfif getdisplaysetup.bill_totalqty eq 'Y'>
        <th>Total Qty</th>
        </cfif>
        <cfif getdisplaysetup.bill_grand eq 'Y'>
        <th>Total Amount</th>
        </cfif>
        <cfoutput>
        <cfif getdisplaysetup.bill_permitno eq 'Y'>
        <th>Permit No</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem5 eq 'Y'>
        <th>#getGeneralInfo1.rem5#</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem6 eq 'Y'>
        <th>#getGeneralInfo1.rem6#</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem7 eq 'Y'>
        <th>#getGeneralInfo1.rem7#</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem8 eq 'Y'>
        <th>#getGeneralInfo1.rem8#</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem9 eq 'Y'>
        <th>#getGeneralInfo1.rem9#</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem10 eq 'Y'>
        <th>#getGeneralInfo1.rem10#</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem11 eq 'Y'>
        <th>#getGeneralInfo1.rem11#</th>
        </cfif>
        
        <cfif getdisplaysetup.bill_rem30 eq 'Y'>
        	<th>#getremarkdetail.rem30#</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem31 eq 'Y'>
        	<th>#getremarkdetail.rem31#</th>
        </cfif>
        <cfif getdisplaysetup.bill_rem32 eq 'Y'>
        	<th>#getremarkdetail.rem32#</th>
        </cfif>
        
        
        </cfoutput>
        <cfif lcase(hcomid) eq "fdipx_i">
        <th>Item </th>
        <th>Total Item</th>
        </cfif>
        <cfif lcase(hcomid) eq "poria_i">
        <th>Delivery Code</th>
        </cfif>
        <cfif getdisplaysetup.bill_b_phone eq 'Y'>
        <th>Phone</th>
        </cfif>
        <cfif getdisplaysetup.bill_d_attn eq 'Y'>
    	<th>D_Attn</th>
        </cfif>
        <cfif getdisplaysetup.bill_user eq 'Y'>
    	<th>User</th>
        </cfif>
        <cfif lcase(hcomid) eq "visionlaw_i">
        <th>Edit User</th>
        </cfif>
         <cfif getdisplaysetup.bill_bodystatus eq 'Y'>
        <cfif lcase(hcomid) eq "fdipx_i" and tran eq "QUO">
        <th>DO</th>
        <th>INV</th>
        <th>PO</th>
        <th>CS</th>
        <th>Status</th>
        <cfelse>
		<th>Status</th>
        </cfif>
        </cfif>
        <cfif lcase(hcomid) eq "fixics_i">
        <th>Ticket</th>
        </cfif>
    	<th>Action</th>
  	</tr>

	<cfoutput query="gettransaction" startrow="1" maxrows="20">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    	<cfif getdisplaysetup.bill_refno eq 'Y'>
        <cfif lcase (hcomid) eq "fdipx_i">
      	<td nowrap align="center">#gettransaction.refno#</td>
        <cfelse>
        <td nowrap>#gettransaction.refno#</td>
        </cfif>
        </cfif>
        <cfif getdisplaysetup.bill_name eq 'Y'>
        <td nowrap>#gettransaction.desp#</td>
        </cfif>
        <cfif getdisplaysetup.bill_toinv eq 'Y'>
        <td nowrap>#gettransaction.toinv#</td>
        </cfif>
        <cfif getdisplaysetup.bill_refno2 eq 'Y'>
		<td nowrap>#gettransaction.refno2#</td>
        </cfif>
        <cfif getdisplaysetup.bill_SO eq 'Y'>
        <cfset sonolist=gettransaction.sono>
        
        <td><cfloop list="#sonolist#" delimiters="," index="i">#i#<br></cfloop></td>
        
        </cfif>
        <cfif getdisplaysetup.bill_PO eq 'Y'>
        <cfset ponolist=gettransaction.pono>
        
        <td><cfloop list="#ponolist#" delimiters="," index="i">#i#<br></cfloop></td>
        </cfif>
        <cfif getdisplaysetup.bill_agent eq 'Y'>
	  	<td nowrap>#gettransaction.agenno#</td>
        </cfif>
        <cfif getdisplaysetup.bill_driver eq 'Y'>
         <cfquery name="getvandesp" datasource="#dts#">
       				select name from driver where driverno='#gettransaction.van#'
        			</cfquery>
        <td nowrap>#gettransaction.van#- #getvandesp.name#</td>
        </cfif>
        <cfif getdisplaysetup.bill_project eq 'Y'>
        <td nowrap>#gettransaction.source#</td>
        </cfif>
        <cfif getdisplaysetup.bill_projectdesp eq 'Y'>
        <cfquery name="getprojectdesp" datasource="#dts#">
                    select project from #target_project# where source='#gettransaction.source#' and porj='P'
        </cfquery>
        <td nowrap>#getprojectdesp.project#</td>
        </cfif>
        <cfif getdisplaysetup.bill_job eq 'Y'>
        <td nowrap>#gettransaction.job#</td>
        </cfif>
        <cfif getdisplaysetup.bill_date eq 'Y'>
      	<td nowrap>#dateformat(gettransaction.wos_date,"dd-mm-yyyy")#</td>
        </cfif>
        <cfif getdisplaysetup.bill_period eq 'Y'>
        <cfif lcase (hcomid) eq "fdipx_i">
      	<td align="center">#gettransaction.fperiod#</td>
        <cfelse>
        <td>#gettransaction.fperiod#</td>
        </cfif>
        </cfif>
        <cfif getdisplaysetup.bill_custno eq 'Y'>
		
      		<td nowrap>#gettransaction.custno# - #gettransaction.name# #gettransaction.frem1#</td>

        </cfif>
         <cfif getdisplaysetup.billbody_dadd eq 'Y'>
        <td nowrap>#gettransaction.frem7# #gettransaction.frem8#</td>
        </cfif>
        <cfif getdisplaysetup.bill_b_attn eq 'Y'>
        <td nowrap>#gettransaction.rem2#</td>
        </cfif>
        <cfif getdisplaysetup.bill_created eq 'Y'>
        <td nowrap>
        
        #gettransaction.created_by#
                </td>
        </cfif>
        <cfif getdisplaysetup.bill_currcode eq 'Y'>
        <td nowrap>#gettransaction.currcode#</td>
        </cfif>
        <cfif getdisplaysetup.bill_term eq 'Y'>
        <td nowrap>#gettransaction.term#</td>
        </cfif>
        <cfif getdisplaysetup.bill_totalqty eq 'Y'>
        <cfquery name="gettotalqty" datasource="#dts#">
        select sum(qty) as qty from ictran where refno='#refno#' and type='#tran#'
        </cfquery>
        <td nowrap align="center">#gettotalqty.qty#</td>
        </cfif>
        <cfif getdisplaysetup.bill_grand eq 'Y'>
        <td nowrap>#numberformat(gettransaction.grand_bil,',_.__')#</td>
        </cfif>
        <cfif getdisplaysetup.bill_permitno eq 'Y'>
        <td>#gettransaction.permitno#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem5 eq 'Y'>
        <td>#gettransaction.rem5#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem6 eq 'Y'>
        <td>#gettransaction.rem6#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem7 eq 'Y'>
        <td>#gettransaction.rem7#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem8 eq 'Y'>
        <td>#gettransaction.rem8#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem9 eq 'Y'>
        <td>#gettransaction.rem9#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem10 eq 'Y'>
        <td>#gettransaction.rem10#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem11 eq 'Y'>
        <td>#gettransaction.rem11#</td>
        </cfif>
       
        <cfif getdisplaysetup.bill_rem30 eq 'Y'>
        <td>#gettransaction.rem30#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem31 eq 'Y'>
        <td>#gettransaction.rem31#</td>
        </cfif>
        <cfif getdisplaysetup.bill_rem32 eq 'Y'>
        <td>#gettransaction.rem32#</td>
        </cfif>
        
        <cfif lcase(hcomid) eq "fdipx_i">
        <cfquery name="get1stitem" datasource="#dts#">
        select desp from ictran where refno='#refno#' and type='#tran#' and itemcount = '1'
        </cfquery>
        <cfquery name="gettotalitem" datasource="#dts#">
        select itemno from ictran where refno='#refno#' and type='#tran#'
        </cfquery>
        <td nowrap>#get1stitem.desp#</td>
        <td nowrap align="center">#gettotalitem.recordcount#</td>
        </cfif>        
        <cfif lcase(hcomid) eq "poria_i">
        <td nowrap>#gettransaction.rem1#</td>
        </cfif>
        <cfif getdisplaysetup.bill_b_phone eq 'Y'>
        <td nowrap>#gettransaction.rem4#</td>
</cfif>
        <cfif getdisplaysetup.bill_d_attn eq 'Y'>
      	<td nowrap>#gettransaction.rem3#</td>
        </cfif>
        <cfif getdisplaysetup.bill_user eq 'Y'>
      	<td nowrap>
        <cfif hcomid eq 'thats_i'>
        #gettransaction.updated_by#
        <cfelse>
        #gettransaction.userid#
        </cfif>
        </td>
        </cfif>
        <cfif lcase(hcomid) eq "visionlaw_i">
        <td nowrap>#gettransaction.updated_by#</td>
        </cfif>
 <cfif getdisplaysetup.bill_bodystatus eq 'Y'>
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
        <cfif lcase(hcomid) eq "fdipx_i">
        <td align="center"><cfif updateddo eq 1>Y</cfif></td>
        <cfelse>
		<td><cfif updateddo eq 1>Y</cfif></td>

        </cfif>
        <td><cfif updatedinv eq 1>Y</cfif></td>
        <td><cfif updatedpo eq 1>Y</cfif></td>
        <td><cfif updatedcs eq 1>Y</cfif></td>
        <td><cfif toinv eq 'C'>Close</cfif></td>

        <cfelse>
	  	<td align="center">
        	<cfif tran eq 'SO' and lcase(hcomid) eq "litelab_i" and order_cl neq ''>
                        PO 
            </cfif>
			<cfif (tran eq 'DO' or tran eq 'PO' or tran eq 'SO' or tran eq 'QUO' or tran eq 'SAM' or tran eq 'SAMM' or tran eq 'RQ') and toinv eq 'C'>C<cfelseif (tran eq 'DO' or tran eq 'PO' or tran eq 'SO' or tran eq 'QUO' or tran eq 'SAM' or tran eq 'SAMM' or tran eq 'RQ') and toinv neq ''><cfif lcase(hcomid) eq 'maranroad_i' or lcase(hcomid) eq 'asramaraya_i'>Updated<cfelse>Y</cfif></cfif>
			<cfif (tran eq 'INV' or tran eq 'RC' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN' or tran eq 'PR') and gettransaction.posted neq ''>P</cfif>
			<cfif gettransaction.void neq ''><font color="red"><strong>Void</strong></font></cfif>
            <cfif tran eq 'PO' and toinv eq ''><cfif printstatus eq 'a3'>Approved</cfif></cfif>
            <cfif lcase(hcomid) eq "hunting_i" and tran eq 'SAM' and toinv eq '' and printstatus eq 'a3'>Approved</cfif>
<cfif lcase(hcomid) eq "asiasoft_i" and tran eq 'SO' and toinv eq '' and printstatus eq '' and (HUserGrpID eq "admin" or HUserGrpID eq "super" or HUserGrpID eq "general")>Req 1st App</cfif><cfif lcase(hcomid) eq "asiasoft_i" and tran eq 'SO' and toinv eq '' and printstatus eq 'a2' and (HUserGrpID eq "admin" or HUserGrpID eq "super")>Req Final App</cfif>
<cfif (lcase(hcomid) eq "asiasoft_i" or lcase(hcomid) eq "asaiki_i") and tran eq 'SO' and toinv eq '' and printstatus eq 'a3'>Approved</cfif>
<cfif lcase(hcomid) eq "asiasoft_i" and tran eq 'SO' and toinv eq '' and printstatus eq 'reject'>REJECTED</cfif>
<cfif lcase(hcomid) eq "net_i" and tran eq 'QUO' and toinv eq '' and printstatus eq 'a3'>Approved</cfif>
<cfif lcase(hcomid) eq "net_i" and tran eq 'QUO' and toinv eq '' and printstatus eq ''>Pending</cfif>
<cfif lcase(hcomid) eq "asiasoft_i" and tran eq 'SO'>
<cfdirectory action="list" directory="#HRootPath#\download\#dts#\bill\SO\#gettransaction.refno#" name="file_list">
<cfif file_list.recordcount neq 0>
<font style="color:red">Attached</font>
</cfif>
</cfif>
            
            <cfif lcase(hcomid) eq "polypet_i" and tran eq 'SAM'>
                        <cfif printstatus eq '1'>
                        Approved
						<cfelse>
                        Not Approved
						</cfif>
						</cfif>
        <cfif lcase(hcomid) eq "ltm_i" and toinv eq ''>
                        #gettransaction.rem45#
        </cfif>
		</td>
        </cfif>
        </cfif>
        <cfif lcase(hcomid) eq "fixics_i">
                <td align="center"><cfif ticket neq ''>#ticket#</cfif><cfif left(toinv,2) eq 'DO'>DO<cfelseif toinv neq ''>INV</cfif></td>
        </cfif>
		<cfif lcase(hcomid) eq "glenndemo_i" or lcase(hcomid) eq "glenn_i">
			<td align="right" nowrap>
		  		<cfif getgeneralinfo.printoption eq 1>
					<a href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#" target="_blank"><img height="18px" width="18px" src="../../images/PNG-48/Print.png" alt="Print" border="0"></a>
				<cfelse>
					<a href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#" target="_blank"><img height="18px" width="18px" src="../../images/PNG-48/Print.png" alt="Print" border="0"></a>
				</cfif>
	
				<cfif aledit eq 1 and gettransaction.void eq "">
					<a href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0"><img height="18px" width="18px" src="../../images/PNG-48/Modify.png" alt="Edit" border="0"></a>
				<cfelse>
					<img height="18px" width="18px" src="../../images/PNG-48/iModify.png" alt="Not Allowed to Edit" border="0">
				</cfif>
	
				<cfif aldelete eq 1 and gettransaction.void eq "">
					<a href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0"><img height="18px" width="18px" src="../../images/PNG-48/Delete.png" alt="Delete" border="0"></a>
				<cfelse>
					<img height="18px" width="18px" src="../../images/PNG-48/iDelete.png" alt="Not Allowed to Delete" border="0">
				</cfif>
				<cfif (tran eq "SO" and getpin2.h2886 eq 'T') or (tran eq "QUO" and (getpin2.h2875 eq 'T' or getpin2.h2876 eq 'T'))>
                	<cfif gettransaction.toinv neq "">
                    	<img height="18px" width="18px" src="../../images/PNG-48/Next_disabled.png" alt="Update" border="0">
					<cfelse>
						<a href="update2/update.cfm?tran=#tran#&nexttranno=#refno#"><img height="18px" width="18px" src="../../images/PNG-48/Next.png" alt="Update" border="0"></a>
					</cfif>
				</cfif>
			</td>
		<cfelse>
        <div id="getdepositajax"></div>
	      	<td align="left" nowrap>
            
            	<cfif lcase(hcomid) eq "lkabb_i" or lcase(hcomid) eq "lkabp_i" or lcase(hcomid) eq "lkab_i" <!---or lcase(hcomid) eq "lkatlb_i"--->
				or lcase(hcomid) eq "lkatbh_i" or lcase(hcomid) eq "svcmm_i" or lcase(hcomid) eq "svcnvn_i" or lcase(hcomid) eq "svctm_i"
				or lcase(hcomid) eq "svcyr_i" or lcase(hcomid) eq "svcdm_i" or lcase(hcomid) eq "svcbd_i" or lcase(hcomid) eq "21bl_i"
				or lcase(hcomid) eq "21cmw_i" or lcase(hcomid) eq "jvtpy_i" or lcase(hcomid) eq "jvsbw_i" or lcase(hcomid) eq "stbrd_i"
				or lcase(hcomid) eq "stpylb_i" or lcase(hcomid) eq "stfsrg_i" or lcase(hcomid) eq "stfsk_i" or lcase(hcomid) eq "ftmps_i"
				or lcase(hcomid) eq "lkabt_i" or lcase(hcomid) eq "lkatb_i" or lcase(hcomid) eq "lkatl_i" or lcase(hcomid) eq "shell_i"
				or lcase(hcomid) eq "fttk_i" or lcase(hcomid) eq "svcnc_i" or lcase(hcomid) eq "autoserv_i">
                             <a target="_blank" href="/billformat/#dts#/preprintedformat.cfm?tran=#tran#&nexttranno=#refno#&BillName=shell_iCBIL_#tran#&doption=0">Print</a>&nbsp;
                        	
                <cfelse>
		  		<cfif getgeneralinfo.printoption eq 1>
					<a href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
				<cfelse>
					<a href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
				</cfif>
                </cfif>
                <cfif lcase(hcomid) eq "hunting_i" and gettransaction.printstatus neq "a3" and tran eq "Sam" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>		
                <a style="cursor:pointer" onClick="document.getElementById('samid').value='#refno#';ColdFusion.Window.show('approvesample');"><img height="18px" width="18px" src="/images/tick.gif" alt="Edit" border="0">Approve</a>
                
				</cfif>
                
                <cfif getGeneralInfo.poapproval eq 'Y' and gettransaction.printstatus neq "a3" and tran eq "PO" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>		<input type="hidden" name="samid" id="samid" value="">
                <a style="cursor:pointer" onClick="document.getElementById('samid').value='#refno#';ColdFusion.Window.show('approvesample');"><img height="18px" width="18px" src="/images/tick.gif" alt="Edit" border="0">Approve</a>
                
				</cfif>
                <cfif (lcase(hcomid) eq "asiasoft_i" or lcase(hcomid) eq "asaiki_i") and gettransaction.printstatus neq "a3"  and gettransaction.printstatus neq "REJECT" and tran eq "SO" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super" or HUserGrpID eq "General")><a style="cursor:pointer" onClick="document.getElementById('soid').value='#refno#';ColdFusion.Window.show('approveso');"><img height="18px" width="18px" src="/images/tick.gif" alt="Edit" border="0">Approve</a>
                
                </cfif>
				
                
				<cfif aledit eq 1 and gettransaction.void eq "">
					
                    <cfif (lcase(hcomid) eq "weikeninv_i" or lcase(hcomid) eq "weikenint_i" or lcase(hcomid) eq "weikenid_i" or lcase(hcomid) eq "futurehome_i" or lcase(hcomid) eq "weikenbuilder_i" or lcase(hcomid) eq "weikendecor_i") and tran eq "SO">
                    <cfif (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>
                    <a href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0">Edit</a>
                    <cfelseif permitno neq "locked">
                    <a href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0">Edit</a>
                    <cfelse>
                    <img height="18px" width="18px" src="../../images/edit.ICO" alt="Not Allowed to Edit" border="0">Edit
                    </cfif>
                    <cfelse>
                    
                    <cfif lcase(hcomid) eq "fixics_i" and ticket neq ''>
                            <img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit
                    <cfelse>
                    
                    <cfif getgeneralinfo.editbillpassword eq "1" and (getgeneralinfo.editbillpassword1 eq "" or ListFindNoCase(getgeneralinfo.editbillpassword1,tran))>
                    		<a href="javascript:void(0)" onClick="PopupCenter('editbillcontrol.cfm?tran=#tran#&refno=#URLEncodedFormat(refno)#&parentpage=no','linkname','300','150');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
                    <cfelse>
                    	
						<cfif getgeneralinfo.generateQuoRevision eq "1" and tran neq 'INV' and (getgeneralinfo.generateQuoRevision1 eq "" or ListFindNoCase(getgeneralinfo.generateQuoRevision1,tran))>
                        
                            <cfquery name="checkiclink" datasource="#dts#">
                                select refno from iclink where (refno='#refno#' and type='#tran#') or (frrefno='#refno#' and frtype='#tran#')
                            </cfquery>
                        	<cfif checkiclink.recordcount eq 0>
							<a href="javascript:void(0)" onClick="PopupCenter('tran_edit2a.cfm?tran=#tran#&refno=#URLEncodedFormat(refno)#&parentpage=no','linkname','200','100');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
                            
                            <cfelse>
                            <a href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
                            
                            </cfif>
						<cfelse>
							<a href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
                            
						</cfif>
                    </cfif>
					</cfif>
                    </cfif>
                <cfelse>
                <img height="18px" width="18px" src="../../images/edit.ICO" alt="Not Allowed to Edit" border="0">Edit
                </cfif>
                    
                    <cfif HUserGrpID eq "super">
                    <a onMouseOver="JavaScript:this.style.cursor='hand';" target="mainFrame" onClick="window.open('expresstranedit/index.cfm?tran=#tran#&ttype=Edit&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0','','fullscreen=yes,scrollbars=yes')">
                	<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">New Edit</a>
                    </cfif>
                    
                    <cfif <!---HUserGrpID eq "super" and---> (tran eq 'SO' or tran eq 'INV' or tran eq 'CN') and lcase(hcomid) eq "ltm_i">
                    <cfif aledit eq 1 and gettransaction.void eq "">
					<cfif toinv eq ''>
                    <a onMouseOver="JavaScript:this.style.cursor='hand';" target="mainFrame" onClick="window.open('vehicletranedit/index.cfm?tran=#tran#&ttype=Edit&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0','','fullscreen=yes,scrollbars=yes')">
                	<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">New Edit</a>
                    <cfelse>
                    <img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">New Edit
                    </cfif>
                    <cfelse>
                    <img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">New Edit
                	</cfif>
					</cfif>
                
				<cfif getpin2.H2890 eq 'T' and alcopy eq 1>
                <img height="18px" width="18px" src="../../images/Copy Icon.jpg" alt="Copy" border="0"><a onMouseOver="this.style.cursor='hand'" onClick="window.open('copyfunction.cfm?refno=#refno#&type=#tran#');">Copy</a>
                </cfif>
                
                <cfif lcase(hcomid) eq "fixics_i" and ticket neq ''>
                <img height="18px" width="18px" src="../../images/delete.ICO" alt="Not Allowed to Delete" border="0">Delete
                <cfelseif lcase(hcomid) eq "tcds_i">
                <a href="javascript:void(0)" onClick="PopupCenter('editbillcontrol.cfm?tran=#tran#&refno=#refno#&parentpage=no&type=delete','linkname','500','500');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Delete</a>
                <cfelse>
				<cfif aldelete eq 1 and gettransaction.void eq "">
					<a href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#URLEncodedFormat(refno)#&custno=#URLEncodedFormat(gettransaction.custno)#<!--- &bcode=&dcode= --->&first=0"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
				<cfelse>
					<img height="18px" width="18px" src="../../images/delete.ICO" alt="Not Allowed to Delete" border="0">Delete
				</cfif>
                </cfif>
            &nbsp;&nbsp;&nbsp;
            <cfif getmodule.auto eq "1" and tran eq 'INV' and posted eq ''>
            <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="window.open('paybill.cfm?type=#type#&refno=#URLEncodedFormat(refno)#','_blank','height=630,width=700,scrollbar=yes,')">Pay</a>
            </cfif>
            
            <cfif getpin2.H2408 eq "T" and tran eq 'INV' and posted eq ''>
            <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="window.open('paybill.cfm?type=#type#&refno=#URLEncodedFormat(refno)#','_blank','height=630,width=700,scrollbar=yes,')">Pay</a>
            </cfif>
            
            <cfif getpin2.H288B eq "T" and tran eq 'SO' and posted eq ''>
            <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="window.open('paybill.cfm?type=#type#&refno=#URLEncodedFormat(refno)#','_blank','height=630,width=700,scrollbar=yes,')">Pay</a>
							</cfif>
            <cfif (hcomid eq "bnbm_i" or hcomid eq "bnbp_i") and tran eq 'QUO'>
                    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="window.open('/salesstatus/orderstatus.cfm?refno=#refno#')">Status</a>
                    </cfif>
                
			</td>

		</cfif>
    </tr>
  	</cfoutput>
</table>
</div>
</body>
</html>
