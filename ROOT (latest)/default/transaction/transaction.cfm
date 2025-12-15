<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "58,2148,2149,48,67,2150,793,782,664,188,665,666,185,689,667,690,668,673,674,961,835,2151,721,718,719,720,722,723,724,980,692,726,725,727,728,698,960,745,694,748,1782,1849,813,696,814,815,816,817,818,819,820,821,822,697,698,749,106,704,16,702,29,703,40,795,752,441,300,753,506,475,754,759,1692,1358,695,757,65,887,668,781,784,783,892,785,786,787,788,1694,1695,1696,1697,1698,1699,1700,1701,1702,1703,1716,1717,1288,705,706,10,3,808,848,806,805,804">
<cfinclude template="/latest/words.cfm">

<cfparam name="alcreate" default="0">	<!--- Authority to Create New --->
<cfparam name="aledit" default="0">		<!--- Authority to Edit --->
<cfparam name="aldelete" default="0">	<!--- Authority to Delete --->
<cfparam name="alown" default="0">		<!--- Authority to View Own Document --->
<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfquery datasource="#dts#" name="getGeneralInfo1">
	Select lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM

	from GSetup
</cfquery>

<cfif tran eq "RC">
  	<cfset tran = "RC">
  	<cfset tranname = words[664]>
  	<cfset trancode = "rcno">
  	<cfset tranarun = "rcarun">

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
	<cfset tranname = words[188]>
	<cfset trancode = "prno">
	<cfset tranarun = "prarun">

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
	<cfset tranname = words[665]>
	<cfset trancode = "dono">
	<cfset tranarun = "doarun">

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
	<cfset tranname = words[666]>
	<cfset trancode = "invno">
	<cfset tranarun = "invarun">

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
	<cfset tranname = words[185]>
	<cfset trancode = "csno">
	<cfset tranarun = "csarun">

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
	<cfset tranname = words[689]>
	<cfset trancode = "cnno">
	<cfset tranarun = "cnarun">

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
	<cfset tranname = words[667]>
	<cfset trancode = "dnno">
	<cfset tranarun = "dnarun">

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
	<cfset tranname = words[690]>
	<cfset trancode = "pono">
	<cfset tranarun = "poarun">

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
	<cfset tranname = words[668]>
	<cfset trancode = "quono">
	<cfset tranarun = "quoarun">

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
	<cfset tranname = words[673]>
	<cfset trancode = "sono">
	<cfset tranarun = "soarun">

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
	<cfset tranname = words[674]>
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
	function refreshpage(){
		setTimeout('window.location.reload();',500)
	}
	</script>
</head>

<cfquery datasource="#dts#" name="getGeneralInfo">
	Select #trancode# as tranno,delinvoice, #tranarun#, invsecure,printoption,
	invoneset,rc_oneset,pr_oneset,do_oneset,cs_oneset,cn_oneset,dn_oneset,iss_oneset,
	po_oneset,so_oneset, quo_oneset, assm_oneset, tr_oneset, oai_oneset, oar_oneset, sam_oneset,ldriver,agentlistuserid,poapproval,rem5

		,generateQuoRevision,revStyle,generateQuoRevision1,ddltran,editbillpassword,editbillpassword1

	from GSetup
</cfquery>

<!--- Add On 11-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
</cfquery>

<!--- <cfquery datasource="main" name="getRefnoset">
	select lastUsedNo as tranno, refnoused as arun from refnoset
	where userDept = '#dts#'
	and type = '#tran#'
	and counter = 1
</cfquery> --->

<cfquery datasource="#dts#" name="getRefnoset">
	select lastUsedNo as tranno, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = 1
</cfquery>

<!--- ADD ON 29-04-2009 --->
<cfif lcase(HcomID) eq "mhca_i" and tran eq "INV">
	<cfquery datasource="#dts#" name="getRefnoset2">
		select lastUsedNo as tranno, refnoused as arun from refnoset
		where type = '#tran#'
		and counter = 2
	</cfquery>
</cfif>


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
		rem49,void,wos_date desc,refno desc
        </cfif>
		limit 20
	</cfquery>


<body>
 <cfif lcase(hcomid) eq "hunting_i" and tran eq "Sam" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>
 <cfajaximport tags="cfform">
 <cfwindow name="approvesample" width="400" height="400" source="approvesample.cfm?tran=#tran#&refno={samid}" modal="true" title="Approval" closable="true" draggable="true"  refreshonshow="true" />
 </cfif>
  <cfif getGeneralInfo.poapproval eq 'Y' and gettransaction.printstatus neq "a3" and tran eq "PO" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>
  <cfajaximport tags="cfform">
 <cfwindow name="approvesample" width="400" height="400" source="approvesample.cfm?tran=#tran#&refno={samid}" modal="true" title="Approval" closable="true" draggable="true"  refreshonshow="true" />
  </cfif>
<cfoutput><!---1. Match output at line 38 --->
<cfif husergrpid eq "Muser"><a href="../home2.cfm"><u>#words[835]#</u></a></cfif>
	<h1>#tranname# #words[2149]#</h1>
	<h4>
		<cfif alcreate eq 1>
			<cfif HcomID eq "pnp_i">
				<cfinclude template="../../pnp/get_authorised_multi_invoive.cfm">
			<cfelse>
				<cfif getgeneralinfo.invoneset neq '1' and tran eq 'INV'>
					<a href="transaction0.cfm?tran=#tran#">#words[721]#</a>
				<cfelseif getgeneralinfo.rc_oneset neq '1' and tran eq 'RC'>
					<a href="transaction0.cfm?tran=#tran#">#words[718]#</a>
				<cfelseif getgeneralinfo.pr_oneset neq '1' and tran eq 'PR'>
					<a href="transaction0.cfm?tran=#tran#">#words[719]#</a>
				<cfelseif getgeneralinfo.do_oneset neq '1' and tran eq 'DO'>
					<a href="transaction0.cfm?tran=#tran#">#words[720]#</a>
				<cfelseif getgeneralinfo.cs_oneset neq '1' and tran eq 'CS'>
					<a href="transaction0.cfm?tran=#tran#">#words[722]#</a>
				<cfelseif getgeneralinfo.cn_oneset neq '1' and tran eq 'CN'>
					<a href="transaction0.cfm?tran=#tran#">#words[723]#</a>
				<cfelseif getgeneralinfo.dn_oneset neq '1' and tran eq 'DN'>
					<a href="transaction0.cfm?tran=#tran#">#words[724]#</a>
				<cfelseif getgeneralinfo.iss_oneset neq '1' and tran eq 'ISS'>
					<a href="transaction0.cfm?tran=#tran#">#words[980]#</a>
				<cfelseif getgeneralinfo.po_oneset neq '1' and tran eq 'PO'>
					<a href="transaction0.cfm?tran=#tran#">#words[692]#</a>
				<cfelseif getgeneralinfo.so_oneset neq '1' and tran eq 'SO'>
					<a href="transaction0.cfm?tran=#tran#">#words[726]#</a>
				<cfelseif getgeneralinfo.quo_oneset neq '1' and tran eq 'QUO'>
					<a href="transaction0.cfm?tran=#tran#">#words[725]#</a>
				<cfelseif getgeneralinfo.assm_oneset neq '1' and tran eq 'ASSM'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.tr_oneset neq '1' and tran eq 'TR'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.oai_oneset neq '1' and tran eq 'OAI'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.oar_oneset neq '1' and tran eq 'OAR'>
					<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
				<cfelseif getgeneralinfo.sam_oneset neq '1' and tran eq 'SAM'>
					<a href="transaction0.cfm?tran=#tran#">#words[727]#</a>
				<cfelse>
					<a href="transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&first=0">#words[2150]# #tranname#</a>
				</cfif> ||
			</cfif>
		</cfif>
		<!--- <a href="transaction.cfm?tran=#tran#">List All #tranname#</a> || --->
		<a href="stransaction.cfm?tran=#tran#&searchtype=&searchstr=">#words[698]# #tranname#</a>
		<!---<cfif tran eq "SO" and hcomid eq "MSD">
		|| <a href="transaction_report.cfm?type=10">#tranname# Reports</a>
		</cfif>--->
        <cfif tran eq "QUO">
        ||<a href="closequo.cfm">#words[960]# #tranname#</a>
        </cfif>
         <cfif lcase(HcomID) eq "solidlogic_i"> || <a href="/default/transaction/printUnprint/printUnprint.cfm?tran=#tran#">Print Unprint #tranname#</a></cfif>
         <cfif lcase(hcomid) eq "polypet_i" and tran eq "CS">
         <cfif getpin2.H2890 eq 'T'>
         || <a href="/default/transaction/polypettransaction.cfm?tran=#tran#">#words[744]#</a>
         </cfif>
         </cfif>
         <cfif lcase(HcomID) eq "sosbat_i" or  lcase(HcomID) eq "gamemartz_i">
         || <a href="/newbody.cfm" target="mainFrame" onClick="Popupfull('/default/transaction/vehicletran/index.cfm?first=true&tran=#tran#','linkname');">
			#words[694]# #tranname#
			</a>
         </cfif>
         <cfif alcreate eq 1>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/expresstran/index.cfm?first=true&type=#tran#','','fullscreen=yes,scrollbars=yes')">
				#words[694]#
			</a>
        </cfif>

	</h4>
	<!--- BEGIN: ADD ON 180608, REPLACE THE BOTTOM ONE --->
	<p>
		<strong><br>#words[1849]#(#tranname#) :</strong><font color="##FF0000"><strong>#getRefnoset.tranno#</strong></font>
		<cfif lcase(HcomID) eq "mhca_i" and tran eq "INV">
			<strong>&nbsp;&nbsp;&nbsp;&nbsp;Last Used #tran# No (Foreign):</strong><font color="##FF0000"><strong>#getRefnoset2.tranno#</strong></font>
		</cfif>
		<cfif tran eq "DO">
			<cfif getpin2.h2305 eq 'T'>
				<h2><a href="update/update.cfm?t1=DO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> #words[813]#</a></h2>
			</cfif>
		</cfif>
		<cfif tran eq "PO">
		<h2>
			<cfif getpin2.h2865 eq 'T'>
				<a href="update/update.cfm?t1=PO&t2=RC"><img src="../../images/arrow.png" alt="Update to Purchase Receive" name="updateBtn2" border="0">#words[696]#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
			<!--- ADD ON 130608, THE LINK FOR EXPORT THE PO TO DO --->
			<!--- <cfif getpin2.h2866 eq 'T'>
				<a href="update/updateA.cfm?t1=PO&t2=DO"><img src="../../images/arrow.png" alt="Update to Delivery Order" name="updateBtn3" border="0"> #words[815]#</a>
			</cfif> --->
			<cfif getpin2.h2866 eq 'T'>
				<a href="update/update.cfm?t1=PO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn3" border="0"> #words[813]#</a>
			</cfif>
		</h2>
		</cfif>
		<cfif tran eq "SO">
		<h2>
			<cfif getpin2.h2885 eq 'T'>
				<a href="update/update.cfm?t1=SO&t2=DO"><img src="../../images/arrow.png" alt="Update to Delivery Order" name="updateBtn4" border="0"> #words[815]#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>

			<cfif getpin2.h2886 eq 'T'>
				<cfif lcase(hcomid) eq "solidlogic_i">
					<a href="update/s_update.cfm?t1=SO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> #words[813]#</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<cfelse>
					<a href="update/update.cfm?t1=SO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> #words[813]#</a>&nbsp;&nbsp;&nbsp;&nbsp;
				</cfif>
			</cfif>

			<cfif getpin2.h2887 eq 'T'>
				<a href="update/update.cfm?t1=SO&t2=PO"><img src="../../images/arrow.png" alt="Update to Purchase Order" name="updateBtn6" border="0"> #words[814]#</a>
			</cfif>
            <cfif getpin2.h2887 eq 'T' and (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i") >
            <a href="update/s_update.cfm?t1=SO&t2=SAM"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn5" border="0"> Update To Work Order (Sample)</a>&nbsp;&nbsp;&nbsp;&nbsp;
            </cfif>
		</h2>
		</cfif>
		<cfif tran eq "QUO">
		<h2>
			<cfif getpin2.h2875 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=SO"><img src="../../images/arrow.png" alt="Update to Sales Order" name="updateBtn7" border="0"> #words[820]#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>

			<cfif getpin2.H2877 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=DO"><img src="../../images/arrow.png" alt="Update to Delivery Order" name="updateBtn8" border="0"> #words[815]#</a>
			</cfif>

			<cfif getpin2.h2876 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=INV"><img src="../../images/arrow.png" alt="Update to Invoice" name="updateBtn8" border="0"> #words[813]#</a>&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>

			<cfif getpin2.H2878 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=PO"><img src="../../images/arrow.png" alt="Update to Purchase Order" name="updateBtn8" border="0"> #words[814]#</a>
			</cfif>

			<cfif getpin2.H2879 eq 'T'>
				<a href="update/update.cfm?t1=QUO&t2=CS"><img src="../../images/arrow.png" alt="Update to Cash Sales" name="updateBtn8" border="0"> #words[819]#</a>
			</cfif>
		</h2>
		</cfif>
        <cfif tran eq "SAM">
			<cfif getpin2.H2855 eq 'T'>
				<h2><a href="update/update.cfm?t1=SAM&t2=SO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> #words[820]#</a>&nbsp;&nbsp;<a href="update/update.cfm?t1=SAM&t2=DO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> #words[815]#</a></h2>
			</cfif>
		</cfif>
        <cfif tran eq "SAMM">
			<cfif getpin2.H2855 eq 'T'>
				<h2><a href="update/update.cfm?t1=SAMM&t2=QUO"><img src="/images/arrow.png" alt="Update to Quotation" name="updateBtn" border="0"> #words[821]#</a><!--- &nbsp;&nbsp;<a href="update/update.cfm?t1=SAM&t2=DO"><img src="/images/arrow.png" alt="Update to Invoice" name="updateBtn" border="0"> Update To #getGeneralInfo1.lDO#</a> ---></h2>
			</cfif>
		</cfif>
	</p>
	<!--- END: ADD ON 180608, REPLACE THE BOTTOM ONE --->
    <form action="stransaction.cfm" method="post">
	<h1>#words[697]# :
	<select name="searchType">
		<option value="refno" <cfif getGeneralInfo.ddltran eq "Refno">selected</cfif>>#tranname# No</option>
		<option value="refno2" <cfif getGeneralInfo.ddltran eq "Refno2">selected</cfif>>Refno2</option>
		<cfif tran eq "RC" or tran eq "PR" or tran eq "PO">
			<option value="custno" <cfif getGeneralInfo.ddltran eq "Supplier/Customer ID">selected</cfif>>#words[106]#</option>
			<option value="name" <cfif getGeneralInfo.ddltran eq "Supplier/Customer Name">selected</cfif>>#words[704]#</option>
		<cfelse>
			<option value="custno" <cfif getGeneralInfo.ddltran eq "Supplier/Customer ID">selected</cfif>>#words[16]#</option>
			<option value="name" <cfif getGeneralInfo.ddltran eq "Supplier/Customer Name">selected</cfif>>#words[782]#</option>
		</cfif>
		<option value="agenno" <cfif getGeneralInfo.ddltran eq "Agent">selected</cfif>>#words[29]#</option>
		<option value="fperiod" <cfif getGeneralInfo.ddltran eq "Period">selected</cfif>>#words[703]#</option>
		<option value="rem4" <cfif getGeneralInfo.ddltran eq "Phone">selected</cfif>>#words[40]#</option>
		<cfif checkcustom.customcompany eq "Y">
			<option value="rem5">#words[2036]#</option>
		</cfif>
        <option value="wos_date" <cfif getGeneralInfo.ddltran eq "Date">selected</cfif>>#words[702]# (DDMMYYYY)</option>
        <option value="pono">#words[795]#</option>
        <option value="phonea" >#words[441]#</option>
        <option value="frem6" >#words[300]#</option>
        <option value="allphone" >#words[753]#</option>
        <cfif lcase(hcomid) eq "powernas_i" or lcase(hcomid) eq "acerich_i">
        <option value="brem2">#words[758]#</option>
        </cfif>
        <cfif (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i")>
        <option value="source">#words[506]#</option>
        </cfif>
        <cfif lcase(hcomid) eq "visionlaw_i">
        <option value="rem5">#getGeneralInfo.rem5#</option>
        <option value="desp">#words[65]#</option>
        </cfif>
	</select>

	<input type="hidden" name="tran" value="#tran#">
	#words[698]#
	<input type="text" name="searchStr" value="">

		<input type="submit" name="submit" value="Search">

	</h1>
</form>
	<hr>
</cfoutput><!---1. Match output at line 28 --->

<table align="center" class="data">
	<tr>
    	<td colspan="8">
		<div align="center">
		<font color="#336699" size="3" face="Arial, Helvetica, sans-serif"><strong>Newest 20 <cfoutput>#tranname#</cfoutput></strong></font></div></td>
  	</tr>
  	<tr><cfoutput>
    	<th>#tranname# #words[58]#</th>
        <cfif lcase(hcomid) eq "visionlaw_i" and (tran eq "sam" or tran eq "so" or tran eq "quo")>
        <th>#words[65]#</th>
        <cfelse>
        <cfif lcase(hcomid) neq "fdipx_i">
		<th>Refno2</th>
        </cfif>
        </cfif>
        <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
        <th>#words[795]#</th>
        </cfif>
		<th>#words[29]#</th>
        <cfif (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i") and tran eq "sam">
        <th>#words[506]#</th>
        </cfif>
    	<th>#words[702]#</th>
    	<th>#words[703]#</th>
    	<th>
			<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
				#words[704]#
			<cfelse>
				<cfif lcase(hcomid) eq "ovas_i" and (tran eq "CS" or tran eq "DO" or tran eq "SO" or tran eq "SAM" or tran eq "CN" or tran eq "DN")><cfoutput>#getGeneralInfo.ldriver#</cfoutput><cfelse>#words[782]#</cfif>
			</cfif>
		</th>
        <th>
				<cfoutput>#getGeneralInfo.ldriver#</cfoutput>
		</th>

        <cfif lcase(hcomid) eq "tcds_i">
        <th>#words[786]#</th>
        <th>#words[787]#</th>
        </cfif>

        <cfif lcase(hcomid) eq "fdipx_i">
        <th>#words[120]#</th>
        <th>#words[789]#</th>
        </cfif>
        <cfif lcase(hcomid) eq "poria_i">
        <th>#words[790]#</th>
        </cfif>
    	<th>#words[705]#</th>
        <cfif lcase(hcomid) eq "visionlaw_i">
        <th>#words[792]#</th>
        </cfif>
        <cfif lcase(hcomid) eq "fdipx_i" and tran eq "QUO">
        <th>#words[793]#</th>
        <th>#words[794]#</th>
        <th>#words[795]#</th>
        <th>#words[796]#</th>
        <cfelse>
		<th>#words[706]#</th>
        </cfif>
    	<th>#words[10]#</th>
	</cfoutput>
  	</tr>

	<cfoutput query="gettransaction" startrow="1" maxrows="20">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      	<td nowrap>#gettransaction.refno#</td>
        <cfif lcase(hcomid) eq "visionlaw_i" and (tran eq "sam" or tran eq "so" or tran eq "quo")>
        <td nowrap>#gettransaction.desp#</td>
        <cfelse>
        <cfif lcase(hcomid) neq "fdipx_i">
		<td nowrap>#gettransaction.refno2#</td>
        </cfif>
        </cfif>
        <cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
        <cfset ponolist=gettransaction.pono>

        <td><cfloop list="#ponolist#" delimiters="," index="i">#i#<br></cfloop></td>
        </cfif>
	  	<td nowrap>#gettransaction.agenno#</td>
        <cfif (lcase(hcomid) eq "mastercare_i" or lcase(hcomid) eq "gorgeous_i") and tran eq "sam">
        <td nowrap>#gettransaction.source#</td>
        </cfif>
      	<td nowrap>#dateformat(gettransaction.wos_date,"dd-mm-yyyy")#</td>
      	<td>#gettransaction.fperiod#</td>
		<cfif lcase(hcomid) eq "ovas_i" and (tran eq "CS" or tran eq "DO" or tran eq "SO" or tran eq "SAM" or tran eq "CN" or tran eq "DN")>
			<td nowrap>#gettransaction.van# - #gettransaction.drivername#</td>
		<cfelse>
      		<td nowrap>#gettransaction.custno# - #gettransaction.name#</td>
		</cfif>

				<td nowrap>#gettransaction.van# - #gettransaction.drivername#</td>
        <cfif lcase(hcomid) eq "tcds_i">
        <cfquery name="gettotalqty" datasource="#dts#">
        select sum(qty) as qty,sum(amt) as amt from ictran where refno='#refno#' and type='#tran#'
        </cfquery>
        <td nowrap align="center">#gettotalqty.qty#</td>
        <td nowrap>#numberformat(gettotalqty.amt,',_.__')#</td>
        </cfif>

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
        <cfif lcase(hcomid) eq "poria_i">
        <td nowrap>#gettransaction.rem1#</td>
        </cfif>
      	<td nowrap>#gettransaction.userid#</td>
        <cfif lcase(hcomid) eq "visionlaw_i">
        <td nowrap>#gettransaction.updated_by#</td>
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
			<cfif (tran eq 'DO' or tran eq 'PO' or tran eq 'SO' or tran eq 'QUO' or tran eq 'SAM' or tran eq 'SAMM') and toinv eq 'C'>C<cfelseif (tran eq 'DO' or tran eq 'PO' or tran eq 'SO' or tran eq 'QUO' or tran eq 'SAM' or tran eq 'SAMM') and toinv neq ''>Y</cfif>
			<cfif (tran eq 'INV' or tran eq 'RC' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN' or tran eq 'PR') and gettransaction.posted neq ''>P</cfif>
			<cfif gettransaction.void neq ''><font color="red"><strong>#words[695]#</strong></font></cfif>
            <cfif tran eq 'PO' and toinv eq ''><cfif printstatus eq 'a3'>#words[799]#</cfif></cfif>
            <cfif lcase(hcomid) eq "hunting_i" and tran eq 'SAM' and toinv eq '' and printstatus eq 'a3'>#words[799]#</cfif>
		</td>
        </cfif>
		<cfif lcase(hcomid) eq "glenndemo_i" or lcase(hcomid) eq "glenn_i">
			<td align="right" nowrap>
		  		<cfif getgeneralinfo.printoption eq 1>
					<a href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#" target="_blank"><img height="18px" width="18px" src="../../images/PNG-48/Print.png" alt="Print" border="0"></a>
				<cfelse>
					<a href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#" target="_blank"><img height="18px" width="18px" src="../../images/PNG-48/Print.png" alt="Print" border="0"></a>
				</cfif>

				<cfif aledit eq 1 and gettransaction.void eq "">
					<a href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0"><img height="18px" width="18px" src="../../images/PNG-48/Modify.png" alt="Edit" border="0"></a>
				<cfelse>
					<img height="18px" width="18px" src="../../images/PNG-48/iModify.png" alt="Not Allowed to Edit" border="0">
				</cfif>

				<cfif aldelete eq 1 and gettransaction.void eq "">
					<a href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0"><img height="18px" width="18px" src="../../images/PNG-48/Delete.png" alt="Delete" border="0"></a>
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
	      	<td align="right" nowrap>
		  		<cfif getgeneralinfo.printoption eq 1>
					<a href="transaction3c.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">Print</a>&nbsp;
				<cfelse>
					<a href="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#refno#" target="_blank">#words[3]#</a>&nbsp;
				</cfif>
                <cfif lcase(hcomid) eq "hunting_i" and gettransaction.printstatus neq "a3" and tran eq "Sam" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>		<input type="hidden" name="samid" id="samid" value="">
                <a style="cursor:pointer" onClick="document.getElementById('samid').value='#refno#';ColdFusion.Window.show('approvesample');"><img height="18px" width="18px" src="/images/tick.gif" alt="Edit" border="0">#words[848]#</a>

				</cfif>

                <cfif getGeneralInfo.poapproval eq 'Y' and gettransaction.printstatus neq "a3" and tran eq "PO" and (HUserGrpID eq "Admin" or HUserGrpID eq "Super")>		<input type="hidden" name="samid" id="samid" value="">
                <a style="cursor:pointer" onClick="document.getElementById('samid').value='#refno#';ColdFusion.Window.show('approvesample');"><img height="18px" width="18px" src="/images/tick.gif" alt="Edit" border="0">#words[848]#</a>

				</cfif>

				<cfif aledit eq 1 and gettransaction.void eq "" and gettransaction.printstatus eq "">
				<cfif getgeneralinfo.editbillpassword eq "1" and (getgeneralinfo.editbillpassword1 eq "" or ListFindNoCase(getgeneralinfo.editbillpassword1,tran))>
                    		<a href="javascript:void(0)" onClick="PopupCenter('editbillcontrol.cfm?tran=#tran#&refno=#refno#&parentpage=no&type=edit','linkname','500','500');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">#words[2148]#</a>
                <cfelse>
						<cfif getgeneralinfo.generateQuoRevision eq "1" and (getgeneralinfo.generateQuoRevision1 eq "" or ListFindNoCase(getgeneralinfo.generateQuoRevision1,tran))>
							<a href="javascript:void(0)" onClick="PopupCenter('tran_edit2a.cfm?tran=#tran#&refno=#refno#&parentpage=no','linkname','200','100');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">#words[2148]#</a>
						<cfelse>
							<a href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(gettransaction.custno)#&first=0"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">#words[2148]#</a>
						</cfif>
				</cfif>
				<cfelse>
					<img height="18px" width="18px" src="../../images/edit.ICO" alt="Not Allowed to Edit" border="0">#words[2148]#
				</cfif>

				<cfif getpin2.H2890 eq 'T'>
                <img height="18px" width="18px" src="../../images/Copy Icon.jpg" alt="Copy" border="0"><a onMouseOver="this.style.cursor='hand'" onClick="window.open('copyfunction.cfm?refno=#refno#&type=#tran#');">#words[806]#</a>
                </cfif>
				<cfif aldelete eq 1 and gettransaction.void eq "" and gettransaction.printstatus eq "">
                <cfif getgeneralinfo.editbillpassword eq "1" and (getgeneralinfo.editbillpassword1 eq "" or ListFindNoCase(getgeneralinfo.editbillpassword1,tran))>
                    		<a href="javascript:void(0)" onClick="PopupCenter('editbillcontrol.cfm?tran=#tran#&refno=#refno#&parentpage=no&type=delete','linkname','500','500');"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">#words[805]#</a>
                <cfelse>
					<a href="transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(gettransaction.custno)#<!--- &bcode=&dcode= --->&first=0"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">#words[805]#</a>
                </cfif>
				<cfelse>
					<img height="18px" width="18px" src="../../images/delete.ICO" alt="Not Allowed to Delete" border="0">#words[805]#
				</cfif>
                <cfif lcase(hcomid) eq "tcds_i" and tran eq 'RC' and rem49 neq 'checked'>
                	<a href="clearorder.cfm?tran=#tran#&refno=#refno#"><img height="18px" width="18px" src="../../images/foldoutmenu2_arrow.gif" border="0">Clear Order</a>
                </cfif>

			</td>

		</cfif>
    </tr>
  	</cfoutput>
</table>
<!--- REMARK ON 180608, MOVE THE LINK TO THE TOP --->
<!--- <p><strong><br>Last Used <cfoutput>#tran#</cfoutput> No :</strong><font color="#FF0000"><strong><cfoutput>#getGeneralInfo.tranno#</cfoutput></strong></font></p> --->

<!---cfif tran eq "DO">
	<cfif getpin2.h2305 eq 'T'>
		<p><br><strong>Update From Delivery Order: </strong><h2><a href="update/update.cfm?t1=DO&t2=INV" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('updateBtn','','../../images/userdefinedmenu/arrow1.png',1)"><img src="../../images/userdefinedmenu/arrow.png" alt="Update to Invoice!" name="updateBtn" border="0"> To Invoice</a></h2><br></p>
	</cfif>
</cfif--->

<!---cfif tran eq "PO">
	<p><br><strong>Update From Purchase Order: </strong>
	<cfif getpin2.h2865 eq 'T'>
		<h2><a href="update/update.cfm?t1=PO&t2=RC" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('updateBtn2','','../../images/userdefinedmenu/tfp_twp26.gif',1)"><img src="../../images/userdefinedmenu/tfp_twp2.gif" alt="Update to Purchase Receive!" name="updateBtn2" border="0"> To Purchase Receive</a>&nbsp;&nbsp;&nbsp;&nbsp;
	</cfif>
	<!--- ADD ON 130608, THE LINK FOR EXPORT THE PO TO DO --->
	<a href="update/updateA.cfm?t1=PO&t2=DO" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('updateBtn3','','../../images/userdefinedmenu/tfp_twp26.gif',1)"><img src="../../images/userdefinedmenu/tfp_twp2.gif" alt="Update to Delivery Order!" name="updateBtn3" border="0"> To Delivery Order</a></h2></p>
</cfif--->

<!---cfif tran eq "SO">
	<cfif getpin2.h2885 eq 'T'>
		<p><br><strong>To Delivery Order from Sales Order: </strong><h2><a href="update/update.cfm?t1=SO&t2=DO">Click Here!</a></h2><br></p>
	</cfif>

	<cfif getpin2.h2886 eq 'T'>
		<p><br><strong>To Invoice from Sales Order: </strong><h2><a href="update/update.cfm?t1=SO&t2=INV">Click Here!</a></h2><br></p>
	</cfif>

	<cfif getpin2.h2887 eq 'T'>
		<p><br><strong>To Purchase Order from Sales Order: </strong><h2><a href="update/update.cfm?t1=SO&t2=PO">Click Here!</a></h2><br></p>
	</cfif>
</cfif--->

<!---cfif tran eq "QUO">
	<cfif getpin2.h2875 eq 'T'>
		<p><br><strong>To Sales Order from Quotation: </strong><h2><a href="update/update.cfm?t1=QUO&t2=SO">Click Here!</a></h2><br></p>
	</cfif>

	<cfif getpin2.h2876 eq 'T'>
		<p><br><strong>To Invoice from Quotation: </strong><h2><a href="update/update.cfm?t1=QUO&t2=INV">Click Here!</a></h2></p>
	</cfif>
</cfif--->

</body>
</html>


