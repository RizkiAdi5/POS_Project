<cfset session.hcredit_limit_exceed = "N">
<cfset session.bcredit_limit_exceed = "Y">
<cfset session.customercode = custno>
<cfset session.tran_refno = refno>
<!--- <cfajaximport tags="cfform">
<cfajaximport tags="cfwindow,cflayout-tab">  --->
<cfparam name="alcreate" default="0">
<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<cfquery datasource="#dts#" name="gettranname">
	Select lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM

	from GSetup
</cfquery>

<cfif tran eq "RC">
  	<cfset tranname = gettranname.lRC>
  	<cfset trancode = "rcno">
  	<cfset tranarun = "rcarun">

	<cfif getpin2.h2102 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "PR">
  	<cfset tranname = gettranname.lPR>
  	<cfset trancode = "prno">
  	<cfset tranarun = "prarun">

	<cfif getpin2.h2201 eq 'T'>
 		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "DO">
	<cfset tranname = gettranname.lDO>
	<cfset trancode = "dono">
    <cfset tranarun = "doarun">

	<cfif getpin2.h2301 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "INV">
  	<cfset tranname = gettranname.lINV>

	<cfif isdefined("form.invset")>
  		<cfset trancode = form.invset>
  		<cfset tranarun = form.tranarun>
  	<cfelse>
  		<cfset trancode = "invno">
  		<cfset tranarun = "invarun">
  	</cfif>

	<cfif getpin2.h2401 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "CS">
  	<cfset tranname = gettranname.lCS>
  	<cfset trancode = "csno">
  	<cfset tranarun = "csarun">

	<cfif getpin2.h2501 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "CN">
  	<cfset tranname = gettranname.lCN>
  	<cfset trancode = "cnno">
  	<cfset tranarun = "cnarun">

	<cfif getpin2.h2601 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "DN">
  	<cfset tranname = gettranname.lDN>
  	<cfset trancode = "dnno">
  	<cfset tranarun = "dnarun">

	<cfif getpin2.h2701 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "PO">
  	<cfset tranname = gettranname.lPO>
  	<cfset trancode = "pono">
  	<cfset tranarun = "poarun">

	<cfif getpin2.h2861 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "QUO">
  	<cfset tranname = gettranname.lQUO>
  	<cfset trancode = "quono">
  	<cfset tranarun = "quoarun">

	<cfif getpin2.h2871 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "SO">
  	<cfset tranname = gettranname.lSO>
  	<cfset trancode = "sono">
  	<cfset tranarun = "soarun">

	<cfif getpin2.h2881 eq 'T'>
 		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "SAM">
	<cfset tranname = gettranname.lSAM>
	<cfset trancode = "samno">
	<cfset tranarun = "samarun">

	<cfif getpin2.h2851 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "SAMM" and lcase(hcomid) eq "hunting_i">
	<cfset tranname = "Sales Order">
	<cfset trancode = "sammno">
	<cfset tranarun = "sammarun">

	<cfif getpin2.h2851 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfquery name="getGsetup" datasource="#dts#">
  Select ADDONREMARK,#trancode# as tranno, #tranarun# as arun, g.* from GSetup g
</cfquery>

<cfif tran eq "RC" or tran eq "PR" or tran eq "PO">
  	<cfquery name="getcustomer" datasource="#dts#">
		select custno,name,name2,currcode from #target_apvend# where custno ='#custno#'
  	</cfquery>

	<cfset ptype = target_apvend>
<cfelse>
  	<cfquery name="getcustomer" datasource="#dts#">
		select custno,name,name2,currcode from #target_arcust# where custno ='#custno#'
  	</cfquery>

	<cfset ptype = target_arcust>
</cfif>

<!--- ADD ON 23-02-2009, PURPOSE: NET_I NEW PO FORMAT --->
<cfif (lcase(hcomid) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "PO">
	<cfquery name="getarcust" datasource="#dts#">
		select custno,name from #target_arcust# order by custno
  	</cfquery>
</cfif>

<cfquery name="currency" datasource="#dts#">
  	select * 
	from #target_currency# 
	where currcode='#getcustomer.currcode#'
</cfquery>

<!--- <cfquery name="getdriver" datasource="#dts#">
	select driverno,attn from driver where customerno = '#custno#' and customerno <>'' order by driverno
</cfquery> --->

<!--- EDITED ON 17-06-2009 --->
<!--- <cfif lcase(hcomid) eq "topsteel_i">
	<cfquery name="getdriver" datasource="#dts#">
		select driverno,name,attn from driver where (customerno = '#custno#' or customerno ='') order by driverno
	</cfquery>
<cfelseif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
	<cfquery name="getdriver" datasource="#dts#">
		select driverno,name,attn from driver order by driverno
	</cfquery>
<cfelse>
	<cfquery name="getdriver" datasource="#dts#">
		select driverno,name,attn from driver where customerno = '#custno#' and customerno <>'' order by driverno
	</cfquery>
</cfif> --->

<cfquery name="getdriver" datasource="#dts#">
	select driverno,name,attn from driver where (customerno = '#custno#' or customerno ='') order by driverno
</cfquery>

<cfquery name="getagent" datasource="#dts#">
  select agent from icagent where 0=0 and (discontinueagent='' or discontinueagent is null) <cfif getpin2.h1B40 eq 'T'>and agent = '#huserid#' or agentid = '#huserid#'</cfif> order by agent
</cfquery>

<cfquery name="getterm" datasource="#dts#">
  select * from #target_icterm# order by term
</cfquery>

<!--- ADD ON 10-12-2009 --->

	<cfquery name="getProject" datasource="#dts#">
	  select * from project where porj = "P" order by source
	</cfquery>
	
	<cfquery name="getProject2" datasource="#dts#">
	  select * from project where porj = "J" order by source
	</cfquery>

<!---
<cfquery name="getGsetup" datasource="#dts#">
  Select #trancode# as tranno, #tranarun# as arun, invoneset, from GSetup
</cfquery>
--->
<!--- REMARK ON 10-12-2009 --->
<!--- <cfquery name="getGsetup" datasource="#dts#">
  Select #trancode# as tranno, #tranarun# as arun, g.* from GSetup g
</cfquery> --->

<cfquery name="getlocation" datasource="#dts#">
	select location,desp from iclocation order by desp
</cfquery>

<cfquery datasource='#dts#' name="getartran">
	select * from artran where refno='#refno#' and type = "#tran#"
</cfquery>

<cfif lcase(HcomID) eq "avent_i" or lcase(HcomID) eq "chemline_i">
    <cfquery datasource='#dts#' name="getcomment">
		select * from comments order by code desc 
	</cfquery>
</cfif>

<cfif lcase(HcomID) eq "avent_i" or lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i" or lcase(HcomID) eq "winbells_i" or lcase(HcomID) eq "iel_i" or 
lcase(HcomID) eq "zeadine_i" or lcase(HcomID) eq "zeadine09_i" or lcase(HcomID) eq "chemline_i" or 
lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i" or lcase(HcomID) eq "probulk_i">

	<cfquery datasource='#dts#' name="getartran_remark">
		select * from artran_remark where refno='#refno#' and type = "#tran#"
	</cfquery>
    <cfif getartran_remark.recordcount neq 0>
		<cfset xremark1=tostring(getartran_remark.remark1)>
		<cfset xremark2=tostring(getartran_remark.remark2)>
		<cfset xremark3=tostring(getartran_remark.remark3)>
		<cfset xremark4=tostring(getartran_remark.remark4)>
		<cfset xremark5=tostring(getartran_remark.remark5)>
		<cfset xremark6=tostring(getartran_remark.remark6)>
		<cfset xremark7=tostring(getartran_remark.remark7)>
		<cfset xremark8=tostring(getartran_remark.remark8)>
		<cfset xremark9=tostring(getartran_remark.remark9)>
		<cfset xremark10=tostring(getartran_remark.remark10)>
		<cfif lcase(HcomID) eq "winbells_i">
			<cfset xremark11=tostring(getartran_remark.remark11)>
			<cfset xremark12=tostring(getartran_remark.remark12)>
			<cfset xremark13=tostring(getartran_remark.remark13)>
			<cfset xremark14=tostring(getartran_remark.remark14)>
			<cfset xremark15=tostring(getartran_remark.remark15)>
			<cfset xremark16=tostring(getartran_remark.remark16)>
			<cfset xremark17=tostring(getartran_remark.remark17)>
		</cfif>
	<cfelse>
		<cfset xremark1 = "">
		<cfset xremark2 = "">
		<cfset xremark3 = "">
		<cfset xremark4 = "">
		<cfset xremark5 = "">
		<cfset xremark6 = "">
		<cfset xremark7 = "">
		<cfset xremark8 = "">
		<cfset xremark9 = "">
		<cfset xremark10 = "">
		<cfif lcase(HcomID) eq "winbells_i">
			<cfset xremark11 = "">
			<cfset xremark12 = "">
			<cfset xremark13 = "">
			<cfset xremark14 = "">
			<cfset xremark15 = "">
			<cfset xremark16 = "">
			<cfset xremark17 = "">
		</cfif>
	</cfif>
</cfif>
<!--- Add on 290608 --->
<!--- <cfif lcase(HcomID) eq "avent_i">
	<!--- <cfquery datasource='#dts#' name="getartran_comment">
		select * from artran_remark where refno='#refno#' and type = "#tran#"
	</cfquery>
    <cfif getartran_comment.recordcount neq 0>
		<cfset comment = tostring(getartran_comment.remark1)>
		<cfset designation = tostring(getartran_comment.remark2)>
		<cfset fobcif = tostring(getartran_comment.remark3)>
	<cfelse>
		<cfset comment = "">
		<cfset designation = "">
		<cfset fobcif = "">
	</cfif> --->
	<cfquery datasource='#dts#' name="getartran_remark">
		select * from artran_remark where refno='#refno#' and type = "#tran#"
	</cfquery>
    <cfif getartran_remark.recordcount neq 0>
		<cfset xremark1 = tostring(getartran_remark.remark1)>
		<cfset xremark2 = tostring(getartran_remark.remark2)>
		<cfset xremark3 = tostring(getartran_remark.remark3)>
	<cfelse>
		<cfset xremark1 = "">
		<cfset xremark2 = "">
		<cfset xremark3 = "">
	</cfif>
<cfelseif lcase(HcomID) eq "topsteel_i">
	<cfquery datasource='#dts#' name="getartran_remark">
		select * from artran_remark where refno='#refno#' and type = "#tran#"
	</cfquery>
    <cfif getartran_remark.recordcount neq 0>
		<cfset xremark1 = tostring(getartran_remark.remark1)>
		<cfset xremark2 = tostring(getartran_remark.remark2)>
	<cfelse>
		<cfset xremark1 = "">
		<cfset xremark2 = "">
	</cfif>
<cfelseif lcase(HcomID) eq "winbells_i">
	<cfquery datasource='#dts#' name="getartran_remark">
		select * from artran_remark where refno='#refno#' and type = "#tran#"
	</cfquery>
    <cfif getartran_remark.recordcount neq 0>
		<cfset xremark1=tostring(getartran_remark.remark1)>
		<cfset xremark2=tostring(getartran_remark.remark2)>
		<cfset xremark3=tostring(getartran_remark.remark3)>
		<cfset xremark4=tostring(getartran_remark.remark4)>
		<cfset xremark5=tostring(getartran_remark.remark5)>
		<cfset xremark6=tostring(getartran_remark.remark6)>
		<cfset xremark7=tostring(getartran_remark.remark7)>
		<cfset xremark8=tostring(getartran_remark.remark8)>
		<cfset xremark9=tostring(getartran_remark.remark9)>
		<cfset xremark10=tostring(getartran_remark.remark10)>
		<cfset xremark11=tostring(getartran_remark.remark11)>
		<cfset xremark12=tostring(getartran_remark.remark12)>
		<cfset xremark13=tostring(getartran_remark.remark13)>
		<cfset xremark14=tostring(getartran_remark.remark14)>
		<cfset xremark15=tostring(getartran_remark.remark15)>
		<cfset xremark16=tostring(getartran_remark.remark16)>
		<cfset xremark17=tostring(getartran_remark.remark17)>
	<cfelse>
		<cfset xremark1 = "">
		<cfset xremark2 = "">
		<cfset xremark3 = "">
		<cfset xremark4 = "">
		<cfset xremark5 = "">
		<cfset xremark6 = "">
		<cfset xremark7 = "">
		<cfset xremark8 = "">
		<cfset xremark9 = "">
		<cfset xremark10 = "">
		<cfset xremark11 = "">
		<cfset xremark12 = "">
		<cfset xremark13 = "">
		<cfset xremark14 = "">
		<cfset xremark15 = "">
		<cfset xremark16 = "">
		<cfset xremark17 = "">
	</cfif>
<cfelseif lcase(HcomID) eq "iel_i">
	<cfquery datasource='#dts#' name="getartran_remark">
		select * from artran_remark where refno='#refno#' and type = "#tran#"
	</cfquery>
    <cfif getartran_remark.recordcount neq 0>
		<cfset xremark1 = tostring(getartran_remark.remark1)>
		<cfset xremark2 = tostring(getartran_remark.remark2)>
		<cfset xremark3=tostring(getartran_remark.remark3)>
		<cfset xremark4=tostring(getartran_remark.remark4)>
	<cfelse>
		<cfset xremark1 = "">
		<cfset xremark2 = "">
		<cfset xremark3 = "">
		<cfset xremark4 = "">
	</cfif>
<cfelseif lcase(HcomID) eq "zeadine_i" or lcase(HcomID) eq "zeadine09_i">
	<cfquery datasource='#dts#' name="getartran_remark">
		select * from artran_remark where refno='#refno#' and type = "#tran#"
	</cfquery>
    <cfif getartran_remark.recordcount neq 0>
		<cfset xremark1 = tostring(getartran_remark.remark1)>
	<cfelse>
		<cfset xremark1 = "">
	</cfif>
<cfelseif lcase(HcomID) eq "chemline_i">
	<cfquery datasource='#dts#' name="getartran_remark">
		select * from artran_remark where refno='#refno#' and type = "#tran#"
	</cfquery>
    <cfif getartran_remark.recordcount neq 0>
		<cfset xremark1 = tostring(getartran_remark.remark1)>
		<cfset xremark2=tostring(getartran_remark.remark2)>
		<cfset xremark3=tostring(getartran_remark.remark3)>
		<cfset xremark4=tostring(getartran_remark.remark4)>
		<cfset xremark5=tostring(getartran_remark.remark5)>
		<cfset xremark6=tostring(getartran_remark.remark6)>
		<cfset xremark7=tostring(getartran_remark.remark7)>
		<cfset xremark8=tostring(getartran_remark.remark8)>
	<cfelse>
		<cfset xremark1 = "">
		<cfset xremark2 = "">
		<cfset xremark3 = "">
		<cfset xremark4 = "">
		<cfset xremark5 = "">
		<cfset xremark6 = "">
		<cfset xremark7 = "">
		<cfset xremark8 = "">
	</cfif>
</cfif> --->

<!--- Add on 290608 --->
<cfif getpin2.h2E00 eq 'T'>
<cfif dateformat(getartran.wos_date,'YYYY-MM-DD') neq dateformat(now(),'YYYY-MM-DD')>
<h3>Transaction is not created Today</h3>
	<cfabort>
    </cfif>
</cfif>
<cfif getartran.posted eq "P">
	<h3>Transaction already posted.</h3>
	<cfabort>
</cfif>

<cfif getGsetup.enableedit neq 'Y'>
<cfif getartran.toinv neq ''>
	<h3>Not Allowed to Edit.</h3>
	<cfabort>
</cfif>
</cfif>
<!--- ADD ON 27-03-2009 --->
<cfif getartran.fperiod eq '99' and getgsetup.allowedityearend neq "Y" >
	<h3>Not Allowed to Edit. Transaction already year-ended.</h3>
	<cfabort>
<cfelseif getartran.fperiod eq '99' and getgsetup.allowedityearend  eq "Y" and tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
<h3>Not Allowed to Edit. Transaction already year-ended.</h3>
	<cfabort>
</cfif>

<!--- Add on 06-02-2009 --->
<!--- REMOVE ON 29-07-2009 --->
<!--- <cfif lcase(HcomID) eq "net_i"> --->
<cfif getGsetup.periodalfr neq "01">
	<cfloop from="1" to="#val(getGsetup.periodalfr)-1#" index="a">
		<cfif val(getartran.fperiod) eq val(a)>
			<h3>Period Allowed from <cfoutput>#getGsetup.periodalfr# to 18.</cfoutput></h3>
			<cfabort>
		</cfif>
	</cfloop>
</cfif>
<!--- </cfif> --->

<cfset Bil_Custno=getartran.custno>

<cfif tran eq 'SAM'>
        <cfquery datasource="#dts#" name="getcustomere">
	    		Select name, name2,currcode,agent from #target_apvend# where custno = "#custno#"
                union all
                Select name, name2,currcode,agent from #target_arcust# where custno = "#custno#"
      		</cfquery>
<cfelse>
<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
	<cfquery datasource="#dts#" name="getcustomere">
		Select name, name2,currcode,agent from #target_apvend# where custno="#custno#"
	</cfquery>
<cfelse>
	<cfquery datasource="#dts#" name="getcustomere">
		Select name, name2,currcode,agent from #target_arcust# where custno="#custno#"
	</cfquery>
</cfif>
</cfif>
<cfset name =getartran.name>
<cfset name2 ="">

<!--- Remark on 080808 and replace with the below one --->
<cfif getartran.currcode neq "">
	<cfset xcurrcode = getartran.currcode>
<cfelse>
	<cfset xcurrcode = getcustomere.currcode>
</cfif>
<!--- <cfset xcurrcode = getcustomere.currcode> --->

<cfset currrate = getartran.currrate>
<cfset wos_type = getartran.type>
<cfset readpreiod = getartran.fperiod>
<cfset refno2 = getartran.refno2>
<cfset desp = getartran.desp>
<cfset despa = getartran.despa>
<cfset xterm = getartran.term>
<cfset xsource = getartran.source>
<cfset xjob = getartran.job>
<!--- Remark on 06-02-2009 and replace with the below one --->
<cfif getGsetup.agentbycust eq 'Y'>
<cfset xagenno = getcustomere.agent>
<cfelse>
<cfset xagenno = getartran.agenno>
</cfif>
<!--- <cfset xagenno = getcustomere.agent> --->
<cfset xdriverno = getartran.van>
<cfset pono = getartran.pono>
<cfset dono = getartran.dono>
<cfset sono = getartran.sono>
<cfset nDateCreate = getartran.wos_date>
<cfset nDateCreate2 = getartran.tran_date>
<cfset remark0 = getartran.rem0>
<cfset remark2 = getartran.rem2>
<cfset remark4 = getartran.rem4>
<cfset remark5 = getartran.rem5>
<cfset remark6 = getartran.rem6>
<cfset remark7 = getartran.rem7>
<cfset remark8 = getartran.rem8>
<cfset remark9 = getartran.rem9>
<cfset remark10 = getartran.rem10>
<cfset remark11 = getartran.rem11>
<cfset permitno = getartran.permitno>
<cfset frem0 = getartran.frem0>
<cfset frem1 = getartran.frem1>
<cfset frem2 = getartran.frem2>
<cfset frem3 = getartran.frem3>
<cfset frem4 = getartran.frem4>
<cfset frem5 = getartran.frem5>
<cfset remark13 = getartran.rem13>
<cfset frem6 = getartran.frem6>
<cfset phonea = getartran.phonea>
<cfset e_mail = getartran.e_mail>

<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
	<cfset remark1 = getartran.rem1>
	<cfset remark3 = getartran.rem3>
	<cfset remark12 = getartran.rem12>
	<cfset frem7 = getartran.frem7>
	<cfset frem8 = tostring(getartran.frem8)>
	<cfset frem9 = getartran.frem9>
	<cfset comm0 = getartran.comm0>
	<cfset comm1 = getartran.comm1>
	<cfset comm2 = getartran.comm2>
	<cfset comm3 = getartran.comm3>
	<cfset remark14 = getartran.rem14>
	<cfset comm4 = getartran.comm4>
<cfelse>
	<cfset remark1 = getartran.rem1>
	<cfset remark3 = getartran.rem3>
	<cfset remark12 = getartran.rem12>
	<cfset remark14 = getartran.rem14>
	<cfset frem7 = getartran.frem7>
	<cfset frem8 = tostring(getartran.frem8)>
	<cfset frem9 = getartran.frem9>
	<cfset comm0 = getartran.comm0>
	<cfset comm1 = getartran.comm1>
	<cfset comm2 = getartran.comm2>
	<cfset comm3 = getartran.comm3>
	<cfset comm4 = getartran.comm4>
</cfif>
<cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
	<cfset remark15 = getartran.rem15>
	<cfset remark16 = getartran.rem16>
	<cfset remark17 = getartran.rem17>
	<cfset remark18 = getartran.rem18>
	<cfset remark19 = getartran.rem19>
	<cfset remark20 = getartran.rem20>
	<cfset remark21 = getartran.rem21>
	<cfset remark22 = getartran.rem22>
	<cfset remark23 = getartran.rem23>
	<cfset remark24 = getartran.rem24>
	<cfset remark25 = getartran.rem25>
</cfif>
<cfif lcase(hcomid) eq 'ugateway_i'>
	<cfset via = getartran.via>      
</cfif>
<cfif lcase(hcomid) eq "accord_i" and tran eq "INV">
	<cfset checkno = getartran.checkno> 
</cfif>

<cfset currefno = refno>
<cfset userid = getartran.userid>
<cfset title = "Mode = Edit ">
<cfset button = "Edit">
	
<html>
<head>
	<title><cfoutput>#tranname#</cfoutput></title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<link href="../../scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="/stylesheet/style.css"/>
	
	<script src="../../scripts/CalendarControl.js" language="javascript"></script>
	<script type="text/javascript" src="/scripts/prototype.js"></script>
	<script type="text/javascript" src="/scripts/effects.js"></script>
	<script type="text/javascript" src="/scripts/controls.js"></script>
	<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
	<script language="JavaScript">
		function updateDriver(drno,drname){
			myoption = document.createElement("OPTION");
			myoption.text = drno + " - " + drname;
			myoption.value = drno;
			document.invoicesheet.driver.options.add(myoption);
			var indexvalue = document.getElementById("driver").length-1;
			document.getElementById("driver").selectedIndex=indexvalue;
		}
		function updatejob(jobno){
			myoption = document.createElement("OPTION");
			myoption.text = jobno;
			myoption.value = jobno;
			document.invoicesheet.Job.options.add(myoption);
			var indexvalue = document.getElementById("job").length-1;
			document.getElementById("job").selectedIndex=indexvalue;
		}
		function updateProject(Projectno){
			myoption = document.createElement("OPTION");
			myoption.text = Projectno;
			myoption.value = Projectno;
			document.invoicesheet.Source.options.add(myoption);
			var indexvalue = document.getElementById("Source").length-1;
			document.getElementById("Source").selectedIndex=indexvalue;
		}
		function checkupdate(){
			if(document.getElementById("searchdriver").value ==''){
				document.getElementById("driver").value='';
			}
		}
		function selectlist(varval,varattb){		
		for (var idx=0;idx<document.getElementById(varattb).options.length;idx++) 
		{
			if (varval==document.getElementById(varattb).options[idx].value) 
			{
				document.getElementById(varattb).options[idx].selected=true;
				
			}
		}
		}
		function updateremark6(){
		selectlist(document.getElementById('remark61').value,'remark6');
		selectlist(document.getElementById('remark71').value,'remark7');
		selectlist(document.getElementById('remark81').value,'remark8');
		selectlist(document.getElementById('remark131').value,'remark13');
		}
		function checkcurrency()
		{
		<cfoutput>
		var oldrate = #Numberformat(val(listfirst(currrate)), "._____")#;
		</cfoutput>
		oldrate = oldrate * 1;
		var newrate = document.getElementById('currrate').value * 1;
		var changes = oldrate - newrate;
		var checkedcheck = document.getElementById('itemrate').checked;
		if(changes != 0 && checkedcheck == false)
		{
		var answer = confirm("Are you sure don't want to update item rate?");
		if(answer)
		{
		return true;
		}
		else
		{
		return false;
		}
		}
		else
		{
		return true;
		}
		}
	</script>
</head>

<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<cfif isdefined('url.jsoff') eq false> <script for="feedcontact1" event="ondatasetcomplete">show_info(this.recordset);</script></cfif>

<cfif lcase(HcomID) eq "avt_i">
<body onLoad="textCounter(document.invoicesheet.remark11,document.invoicesheet.remLen,254);">
<cfelse>
<body>
</cfif>

<cfoutput>
<h4>
	<cfif alcreate eq 1>
		<cfif getGsetup.invoneset neq '1' and tran eq 'INV'>
			<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
		<cfelse>
			<a href="transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&first=0">Create New #tranname#</a>
		</cfif> ||
	</cfif>
  	<a href="transaction.cfm?tran=#tran#">List all #tranname#</a> ||
	<a href="stransaction.cfm?tran=#tran#&searchtype=&searchstr=">Search For #tranname#</a>
</h4>
</cfoutput>
<cfif isdefined('url.jsoff')>
<cfset formname = "invoicesheetpost">
<cfset formid = "invoicesheetpost">
<cfelse>
<cfset formname = "invoicesheet">
<cfset formid = "invoicesheet">
</cfif>
<cfform name="#formname#" id="#formid#" action="transaction3.cfm" method="post" onsubmit="return checkcurrency();">

  	<cfoutput>
	<input type="hidden" name="type" value="Edit">
	<input type="hidden" name="tran" value="#tran#">
	<input type="hidden" name="currefno" value="#refno#">
	
	<cfif isdefined("form.invset")>
		<input type="hidden" name="invset" value="#listfirst(invset)#">
		<input type="hidden" name="tranarun" value="#listfirst(tranarun)#">
	</cfif>

	<table align="center" class="data" border="0" cellpadding="1" cellspacing="0">
	<tr>
		<th width="115">#tranname# No</th>
		<td width="94"><h3>#currefno#</h3></td>
		<!--- To do a marking for Update Unit Cost, because the form.type will be change after back from Transaction4.cfm --->
		<td nowrap>
			<cfif tran eq "RC">
				<!---Replace Checkbox updunitcost --->
				<cfinclude template = "transaction2_check_update_unit_cost.cfm">
				<!---Replace Checkbox updunitcost --->
			</cfif>		</td>
		<th width="94">Type</th>
		<td width="209"><h2>Edit #tranname#</h2></td>
	</tr>
	<tr>
		<th>#tranname# Date</th>
		<td colspan="2">
			<input type="text" name="invoicedate" size="10" value="#dateformat(nDateCreate,"dd/mm/yyyy")#" readonly>(DD/MM/YYYY)		</td>
		
        <th height="20">#getGsetup.refno2#</th>
		<td ><input type="text" name="refno2" value="#refno2#"></td>
	</tr>
	<tr>
		<th>#iif(tran eq 'RC' or tran eq 'PR',DE('Supplier'),DE('Customer'))# No</th>
		<td colspan="2"><input type="text" name="custno" value="#custno#" readonly></td>
		<th <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>Currency</th>
		<td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>
			<input name="refno3" type="text" size="10" value="#listfirst(xcurrcode)#" readonly>
			<input name="currrate" id="currrate" type="text" size="10" value="#Numberformat(listfirst(currrate), "._____")#">
			<input type="Button" name="UpdCurrRate" value="Update" onClick="displayrate(),displayname()">
			<input type="checkbox" name="itemrate" id="itemrate" value="1" checked>Item Rate		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="2"><input name="name" type="text" size="40" maxlength="40" value="#convertquote(name)#" readonly></td>
		<th <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getGsetup.lDRIVER#</th>
		<td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>
			<cfif getGsetup.filterall eq "1"  and lcase(hcomid) neq "iel_i" and lcase(hcomid) neq "ielm_i" and lcase(hcomid) neq "huanhong_i" and lcase(hcomid) neq "bakersoven11_i">
				<cfquery name="getdrivername" datasource="#dts#">
					select name from driver where driverno='#xdriverno#'
				</cfquery>
				<cfif getdrivername.recordcount eq 0>
					<cfset drname="">
				<cfelse>
					<cfset drname="#xdriverno# - #getdrivername.name#">
				</cfif>
				<input id="searchdriver" name="searchdriver" type="text" size="30" value="#drname#"/>
                <input id="driver" name="driver" type="hidden" value="#xdriverno#" />
				<div id="hint" class="autocomplete"></div>
                <cfif isdefined('url.jsoff') eq false>
                <script type="text/javascript">
					var url = "/ajax/functions/getRecord.cfm";
						
					new Ajax.Autocompleter("searchdriver","hint",url,{afterUpdateElement : getSelectedId});
						
					function getSelectedId(text, li) {
						$('driver').value=li.id;
					}
				</script>
                </cfif>
			<cfelse>
				<select name="driver">
					<option value="">Choose a #getGsetup.lDRIVER#</option>
					<cfloop query="getdriver">
						<option value="#driverno#"<cfif xdriverno eq driverno>selected</cfif>>#driverno# - #name#</option>
					</cfloop>
				</select>
			</cfif>
			<cfif getpin2.h1C10 eq 'T'>&nbsp;<a href="driver.cfm?type=Create" target="_blank">Create New</a></cfif>		</td>
	</tr>
	<tr>
		<td height="23"></td>
		<td colspan="2"><input name="name2" type="text" size="40" maxlength="40" value="#name2#" readonly></td>
		<th <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getGsetup.lAGENT#</th>
		<td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>><select name="agenno" id="select"  <cfif lcase(HcomID) eq "hyray_i">onChange="ajaxFunction(document.getElementById('keeptrackbug'),'/default/transaction/keeptrackbug.cfm?agenno='+this.value+'&type=update&fieldtype=agent&custno=#custno#&tran=#tran#&refno=#currefno#');"</cfif>>
			<cfif getpin2.h1B40 neq 'T' or getagent.recordcount eq 0>
				<option value="">Choose a #getGsetup.lAGENT#</option>
			</cfif>
			<cfloop query="getagent">
				<option value="#getagent.agent#"<cfif xagenno eq getagent.agent>Selected</cfif>>#getagent.agent#</option>
			</cfloop>
			</select>		</td>
	</tr>
	<tr>
		<th height="25">Description</th>
		<td colspan="2"><input name="desp" type="text" size="40" maxlength="40" value="#desp#"></td>
		<th <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>Terms</th>
		<td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>><select name="terms" id="terms" <cfif lcase(hcomid) eq "tmt_i" or lcase(HcomID) eq "taff_i">onChange="ChgDueDate()"</cfif>>
				<option value="">Choose a Terms</option>
				<cfloop query="getterm">
					<option value="#term#"<cfif xterm eq term>Selected</cfif>>#term# <cfif lcase(hcomid) eq 'fdipx_i'>- #getterm.desp#</cfif></option>
				</cfloop>
			</select>		</td>
	</tr>
	<tr>
		<td height="23">&nbsp;</td>
		<td colspan="2"><input name="despa" type="text" size="40" maxlength="40" value="#despa#"></td>
		<cfif getGsetup.projectbybill eq "1">
			<th <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>><!--- Project / Job --->#getGsetup.lPROJECT# / #getGsetup.lJOB#</th>
			<td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>><select name="Source" id="Source">
					<option value="">Choose a <!--- Project --->#getGsetup.lPROJECT#</option>
					<cfloop query="getProject">
						<option value="#getProject.source#"<cfif xSource eq getProject.source>Selected</cfif>>#getProject.source#</option>
					</cfloop>
				</select>
				<select name="Job" id="Job">
					<option value="">Choose a <!--- Job --->#getGsetup.lJOB#</option>
					<cfloop query="getProject2">
						<option value="#getProject2.source#"<cfif xJob eq getProject2.source>Selected</cfif>>#getProject2.source#</option>
					</cfloop>
				</select>			</td>
        <cfelseif getGsetup.jobbyitem eq "Y">
        <th><!--- Project / Job --->#getGsetup.lPROJECT# / #getGsetup.lJOB#</th>
			<td><select name="Source" id="Source">
					<option value="">Choose a <!--- Project --->#getGsetup.lPROJECT#</option>
					<cfloop query="getProject">
						<option value="#getProject.source#"<cfif xSource eq getProject.source>Selected</cfif>>#getProject.source#</option>
					</cfloop>
				</select><input type="hidden" name="Job" id="Job" value="#xJob#"></td>
		<cfelse>
			<input type="hidden" name="Source" id="Source" value="#xSource#">
			<input type="hidden" name="Job" id="Job" value="#xJob#">
			<td colspan="2"></td>
		</cfif>
	</tr>
    <cfif getGsetup.projectbybill eq "1" or getGsetup.jobbyitem eq "Y">
    <tr>
    <cfif getGsetup.transactiondate eq "Y">
    <th>Transaction Date</th>
		<td colspan="2">
			<input type="text" name="transactiondate" size="10" value="#dateformat(nDateCreate2,"dd/mm/yyyy")#" readonly>(DD/MM/YYYY)		</td>
	<cfelse>
        <td></td>
        <td></td>
        <td></td>
        </cfif>
        <th></th>
        <td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>><!--- <a onClick="ColdFusion.Window.show('createProjectAjax');" onMouseOver="this.style.cursor='hand';" >Create New Project</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onClick="ColdFusion.Window.show('createJobAjax');" onMouseOver="this.style.cursor='hand';" >Create New Job</a> ---></td>
        </tr>
        <cfelse>
        <tr>
        <cfif getGsetup.transactiondate eq "Y">
    <th>Transaction Date</th>
		<td colspan="2">
			<input type="text" name="transactiondate" size="10" value="#dateformat(nDateCreate2,"dd/mm/yyyy")#" readonly>(DD/MM/YYYY)		</td>
        <td></td>
        <td></td>
	<cfelse>
        <td></td>
        <td></td>
        <td></td>
        </cfif>
        <td></td>
        <td></td>
        </tr>
        </cfif>
     <cfif lcase(HcomID) eq 'taftc_i'>
     <cfquery name="getprojectwsq" datasource="#dts#">
     select wsq from project where source="#getartran.source#"
     </cfquery>
      <tr>
      <td></td><td></td><td></td>
        <th>WSQ Competency Codes :</th>
        <td colspan="4"><!--- <cftextarea name="WSQ" id="WSQ" cols="50" rows="7" bind="cfc:tran2cfc.getwsq('#dts#',{Source})">#getprojectwsq.wsq#</cftextarea> ---></td>
      </tr>
      </cfif>
	<tr><td height="20" colspan="5"><hr></td></tr>
    <tr>
    <th>SO</th>
    <td><input type="text" name="sono" value="#sono#" size="40" maxlength="35"></td>
    <td></td>
    <th><cfif lcase(hcomid) eq "fdipx_i">Invoice No.<cfelse>Permit No</cfif></th>
    <td><input type="text" name="permitno" value="#permitno#" size="40" maxlength="100"></td>
    </tr>
	<tr>
		<th height="20" <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>><cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">PO<cfelse>PO/SO</cfif></th>
		<td colspan="2" <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>
        <cfif custno eq 'ASSM/999'>
        <cfquery name="getissueno" datasource="#dts#">
   		select refno from artran where type='ISS'
		</cfquery>
        <select name="pono">
        <option value="">Choose a issue No</option>
        <cfloop query="getissueno">
        <cfset issueno='ISS '&getissueno.refno>
        <option value="#getissueno.refno#"<cfif pono eq #issueno#>selected</cfif>>#issueno#</option>
        </cfloop>
        <cfelse>
        <input type="text" name="pono" value="#pono#" size="40" maxlength="35">
        </cfif>
        </td>
		<th>#getGsetup.rem5#</th>
		<td>
		<cfif lcase(hcomid) eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "aqua_i">
			<cfquery datasource="#dts#" name="getcust">
				Select custno,name from #target_arcust# order by name
			</cfquery>
			<select name="remark5">
				<option value="">Please Select</option>
				<cfloop query="getcust">
					<option value="#getcust.custno#"<cfif remark5 eq getcust.custno>Selected</cfif>>#getcust.custno# - #getcust.name#</option>
				</cfloop>
			</select>
        <cfelseif lcase(hcomid) eq "accord_i" and tran eq "INV">
        <cfquery name="getveh" datasource="#dts#">
        SELECT * from vehicles where custcode = "#custno#"
        </cfquery>
        <select name="remark5" id="remark5" onChange="setTimeout('updateremark6()',1000);">
            <option value="">Select a vehicles</option>
            <cfloop query="getveh">
                <option value="#getveh.carno#" <cfif remark5 eq getveh.carno>Selected</cfif>>#getveh.carno#</option>
            </cfloop>
            </select>
         <cfelseif lcase(HcomID) eq "kimlee_i" and tran eq "CN" or lcase(HcomID) eq "bakersoven_i" and tran eq "CN">
         
			 <script type="text/javascript">
             function selectlist(custno){	
			for (var idx=0;idx<document.getElementById('remark5').options.length;idx++) {
					if (custno==document.getElementById('remark5').options[idx].value) {
						document.getElementById('remark5').options[idx].selected=true;
					}
				} 
				}
	</script>
         <cfquery name="getkiminv" datasource="#dts#">
        SELECT custno,refno,name from artran where type = "INV" group by refno
        </cfquery>
        <select name="remark5" id="remark5">
        <cfloop query="getkiminv">
        	<option value="#getkiminv.refno#" <cfif remark5 eq getkiminv.refno>Selected</cfif>>#getkiminv.refno# - #getkiminv.custno# #getkiminv.name#</option>
        </cfloop>
        </select>
        <!--- <img src="/images/find.jpg" width="20" height="14.5" onClick="javascript:ColdFusion.Window.show('findInvoice');" /> --->
         <cfelseif lcase(hcomid) eq "taftc_i">
         <cfinput type="text" name="remark5" id="remark5" value="#remark5#" <!--- bind="cfc:tran2cfc.getdate1('#dts#',{Job})" ---> />
         <cfelseif lcase(HcomID) eq "unichem_i" and tran eq "INV">
        <cfquery name="getservicecode" datasource="#dts#">
        SELECT "" as servicecode, "Please Select a Service Agreement" as desp
        union all
        SELECT servicecode,concat(servicecode,' - ',desp) as desp from serviceagree
        </cfquery>  
        <cfselect name="remark5" id="remark5" query="getservicecode" value="servicecode" display="desp" selected="#remark5#" />
        <cfelseif  lcase(HcomID) eq "stjohns_i">
			<input type="text" name="remark5" value="#remark5#" size="40" maxlength="120">
        <cfelseif  lcase(HcomID) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i">
            <input type="checkbox" name="remcheck" id="remcheck" value="Yes" <cfif remark5 eq "YES"> checked</cfif> onClick="if(this.checked == true){document.getElementById('remark5').value='YES';} else {document.getElementById('remark5').value='NO';}">
            <input type="hidden" name="remark5" id="remark5" value="#remark5#" size="40" maxlength="80">
        <cfelseif lcase(HcomID) eq "vtop_i">
        <input type="text" name="remark5" value="#remark5#" size="40" maxlength="200">
		<cfelse>
			<input type="text" name="remark5" value="#remark5#" size="40" maxlength="80">
		</cfif>		</td>
	</tr>
	<tr>
		<th height="20">DO<cfif lcase(hcomid) eq "widos_i">/QUO</cfif></th>
		<td colspan="2"><input type="text" name="dono" value="#dono#" size="40" maxlength="35"></td>
		<th>#getGsetup.rem6#</th>
        <td><cfif lcase(hcomid) eq "accord_i" and tran eq "INV">
		

  <select name="remark6" id="remark6" >
  <cfloop list="0%,10%,15%,20%,30%,40%,50%" index="i">
  <option value="#i#" <cfif remark6 eq #i#>selected</cfif>>#i#</option>
</cfloop></select><cfinput type="hidden" id="remark61" name="remark61" <!--- bind="cfc:accordtran2.getremark6('#dts#',{remark5})" ---> >        </td>
  <cfelseif lcase(hcomid) eq "taftc_i">
         <cfinput type="text" name="remark6" id="remark6" value="#remark6#" <!--- bind="cfc:tran2cfc.getdate2('#dts#',{Job})" ---> />
         <cfelseif lcase(hcomid) eq "visionlaw_i">
         <textarea name="remark6" id="remark6" cols='40' rows='3' onKeyDown="limitText(this.form.remark6,300);" onKeyUp="limitText(this.form.remark6,300);">#remark6#</textarea>	
        <cfelse>
 
        <input type="text" name="remark6" value="#remark6#" size="40" maxlength="80"></cfif></td>
	</tr>
	<tr>
		<th>#getGsetup.rem0#</th>
		<td colspan="2"><input type="text" name="remark0" value="#remark0#" size="40" readonly></td>
		<th>#getGsetup.rem7#</th>
		<td>
			<!--- MODIFIED ON 23-02-2009,PURPOSE: NET_I NEW PO FORMAT --->
			<cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "PO">
				<select name="remark7">
					<option value="">Please Select the Client</option>
					<cfloop query="getarcust">
						<option value="#custno#" <cfif custno eq remark7>selected</cfif>>#custno# - #name#</option>
					</cfloop>
				</select>
                <cfelseif lcase(hcomid) eq "kingston_i" and tran eq "PO">
				<select name="remark7" id="remark7">
                <option value="Kindly send to our office" <cfif remark7 eq "Kindly send to our office">selected</cfif>>Kindly send to our office</option>
                <option value="Kindly send to our site" <cfif remark7 eq "Kindly send to our site">selected</cfif>>Kindly send to our site</option>
                <option value="Self-Collection" <cfif remark7 eq "Self-Collection">selected</cfif>>Self-Collection</option>
                </select>
                        <cfelseif lcase(hcomid) eq "accord_i" and tran eq "INV">
                        
                 <select name="remark7" id="remark7">
  <cfloop list="OPC,normal" index="i">
  <option value="#i#" <cfif remark7 eq #i#>selected</cfif>>#i#</option>
</cfloop></select><cfinput type="hidden" id="remark71" name="remark71"<!---  bind="cfc:accordtran2.getremark7('#dts#',{remark5})" --->>
			<cfelseif lcase(hcomid) eq "mcjim_i">
            <input type="text" name="remark7" value="#remark7#" size="40" maxlength="50">
            <cfelseif lcase(hcomid) eq "powernas_i">
            <input type="text" name="remark7" value="#remark7#" size="40" maxlength="200">
            <cfelseif lcase(hcomid) eq "visionlaw_i">
         <textarea name="remark7" id="remark7" cols='40' rows='3' onKeyDown="limitText(this.form.remark7,300);" onKeyUp="limitText(this.form.remark7,300);">#remark7#</textarea>	
			<cfelse>
				<input type="text" name="remark7" value="#remark7#" size="40" maxlength="80">
			</cfif>		</td>
	</tr>
	<tr>
    	<th>#getGsetup.rem1#</th>
		<td colspan="2"><input type="text" name="remark1" value="#remark1#" size="40" readonly></td>
		<th>#getGsetup.rem8#</th>
		<td>
		<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i" >
			<select name="remark8">
			<option value="">Please Select</option>
			<cfloop query="getlocation">
			<option value="#location#" <cfif remark8 eq location>selected</cfif>>#desp#</option>
			</cfloop>
			</select>
		<cfelseif lcase(hcomid) eq "tmt_i" or lcase(HcomID) eq "taff_i">
			<select name="remark8">
			<option value="">Please Select</option>
			<option value="directReferral" <cfif remark8 eq "directReferral">selected</cfif>>Direct Referral</option>
			<option value="onspot" <cfif remark8 eq "onspot">selected</cfif>>On Spot</option>
			<option value="telesales" <cfif remark8 eq "telesales">selected</cfif>>Tele-Sales</option>
			</select>
            <cfelseif lcase(hcomid) eq "net_i">
            <input type="text" name="remark8" value="<cfif remark8 neq "" and remark8 neq "0000-00-00"> #dateformat(remark8,"dd/mm/yyyy")#</cfif>" size="10" maxlength="10">
			<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(remark8);">(DD/MM/YYYY)
           <cfelseif lcase(hcomid) eq "accord_i" and tran eq "INV">
<select name="remark8" id="remark8">
<option value="" <cfif remark8 eq "">Selected</cfif>>Please select a coverage type</option>
<option value="Comprehensive" <cfif remark8 eq "Comprehensive">Selected</cfif>>Comprehensive</option>
<option value="Third party, fire and theft" <cfif remark8 eq "Third party, fire and theft">Selected</cfif>>Third party, fire and theft</option>
<option value="Third party only" <cfif remark8 eq "Third party only">Selected</cfif>>Third party only</option>
</select><cfinput type="hidden" id="remark81" name="remark81" <!--- bind="cfc:accordtran2.getremark8('#dts#',{remark5})" --->>

<cfelseif lcase(hcomid) eq "redhorn_i" and tran eq "PO">
                        
                <select name="remark8" id="remark8">
<option value="" <cfif remark8 eq "">Selected</cfif>>Please select a Delivery type</option>
<option value="Self Collect" <cfif remark8 eq "Self Collect">Selected</cfif>>Self Collect</option>
<option value="Deliver By Supplier" <cfif remark8 eq "Deliver By Supplier">Selected</cfif>>Deliver By Supplier</option>
</select>

            <cfelseif lcase(hcomid) eq "taftc_i">
         <cfinput type="text" name="remark8" id="remark8" value="#remark8#"  <!--- bind="cfc:tran2cfc.getdate3('#dts#',{Job})" ---> />
   
		<cfelse>
			<input type="text" name="remark8" value="#remark8#" size="40" maxlength="80">
		</cfif>		</td>
	</tr>
	<tr>
    	<th>#getGsetup.rem2#</th>
		<td colspan="2"><input type="text" name="remark2" value="#remark2#" size="40" maxlength="35" readonly></td>
		<th><cfif (lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and tran eq "PO">Arrival Date<cfelse>#getGsetup.rem9#</cfif></th>
		<td>
		<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i" or lcase(hcomid) eq "net_i" or ((lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and tran eq "PO")>
			<input type="text" name="remark9" value="<cfif remark9 neq "" and remark9 neq "0000-00-00"> #dateformat(remark9,"dd/mm/yyyy")#</cfif>" size="10" maxlength="10">
			<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(remark9);">(DD/MM/YYYY)
            
                      <cfelseif lcase(hcomid) eq "accord_i" and tran eq "INV">
                        
                     <cfinput type="text" id="remark9" name="remark9" <!--- bind="cfc:accordtran2.getremark9('#dts#',{remark5})" value="#remark9#" --->>
<cfelseif lcase(hcomid) eq "taftc_i">
         <cfinput type="text" name="remark9" id="remark9" value="#remark9#" <!--- bind="cfc:tran2cfc.getdate4('#dts#',{Job})" ---> />
         <cfelseif (lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "hcss_i" or lcase(hcomid) eq "mfss_i") and tran eq "SO">
			<cfinput type="text" name="remark9" value="#remark9#" size="40" maxlength="35" required="yes" message="Kindly Fill in Doctor Name">
        <cfelseif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i">
         <input type="checkbox" name="rem9check" id="rem9check" value="Yes" <cfif remark9 eq "YES"> checked</cfif> onClick="if(this.checked == true){document.getElementById('remark9').value='YES';} else {document.getElementById('remark9').value='NO';}">
         <input type="hidden" name="remark9" id="remark9" value="#remark9#" size="40" maxlength="35">
		<cfelse>
			<input type="text" name="remark9" value="#remark9#" size="40" maxlength="35">
		</cfif>		</td>
	</tr>
	<tr>
    	<th>#getGsetup.rem3#</th>
		<td colspan="2"><input type="text" name="remark3" size="40" maxlength="35" <cfif lcase(HcomID) eq "hl_i" and tran eq "PO"> value="#remark3#"<cfelse>value="#remark3#" readonly</cfif>></td>
		<th <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>><cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">Start On<cfelse>#getGsetup.rem10#</cfif></th>
		<td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>
		<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
			<select name="remark10">
			<option value="">Please Select</option>
			<option value="-" <cfif remark10 eq "-">selected</cfif>>To</option>
			<option value="&" <cfif remark10 eq "&">selected</cfif>>And</option>
			</select>
		<cfelseif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">
			<input type="text" name="remark10" value="#remark10#" size="10" maxlength="10">
			<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(remark10);">(DD/MM/YYYY)
		<cfelseif lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i" or lcase(hcomid) eq "decor_i">
			<textarea name="remark10" id="remark10" cols='40' rows='1' onKeyDown="limitText(this.form.remark10,200);" onKeyUp="limitText(this.form.remark10,200);">#remark10#</textarea>	
            <cfelseif lcase(hcomid) eq "bestform_i" or lcase(hcomid) eq "alsale_i">
			<textarea name="remark10" id="remark10" cols='40' rows='3' onKeyDown="limitText(this.form.remark10,500);" onKeyUp="limitText(this.form.remark10,500);">#remark10#</textarea>	
        <cfelseif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "visionlaw_i" or lcase(hcomid) eq "bspl_i">
        <input type="text" name="remark10" value="#remark10#" maxlength="100" size="40"></td>
        
                 <cfelseif lcase(hcomid) eq "accord_i" and tran eq "INV">
                <cfoutput>
<cfinput type="text" name="remark10" id="remark10" value="#remark10#" <!--- bind="cfc:accordtran2.getremark10('#dts#',{remark5})" --->></cfoutput>
        <cfelseif lcase(hcomid) eq "mingsia_i" or lcase(hcomid) eq "knm_i" or lcase(hcomid) eq "letrain_i" or lcase(hcomid) eq "btgroup_i">
        <input type="text" name="remark10" value="#remark10#" maxlength="150" size="40"></td>
         <cfelseif (lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "hcss_i" or lcase(hcomid) eq "mfss_i") and tran eq "SO">
         <cfinput type="text" name="remark10" value="#remark10#" maxlength="35" size="40" required="yes" message="Kindly Fill in Patient Name"></td>
		<cfelse>
			<input type="text" name="remark10" value="#remark10#" maxlength="35" size="40"></td>
		</cfif>
	</tr>
	<tr>
    	<th>#getGsetup.rem4#</th>
		<td colspan="2"><input type="text" name="remark4" value="#remark4#" size="40" maxlength="35" readonly></td>
	  <cfif lcase(HcomID) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
			<th <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getGsetup.rem11#</th>
		<td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>
			<input type="text" name="remark11" value="#dateformat(remark11,"dd/mm/yyyy")#" size="10" maxlength="10">
		<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(remark11);">(DD/MM/YYYY)			</td>
		<cfelseif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">
			<th>Expire On</th>
		<td>
				<input type="text" name="remark11" value="#remark11#" size="10" maxlength="10">
		<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(remark11);">(DD/MM/YYYY)			</td>
		<cfelseif lcase(hcomid) eq "eocean_i" or lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i" or lcase(hcomid) eq "probulk_i" or lcase(hcomid) eq "ielm_i" or lcase(hcomid) eq "leatat_i" or lcase(hcomid) eq "dnet_i" or lcase(hcomid) eq "avoncleaning_i" or lcase(hcomid) eq "spcivil_i" or lcase(hcomid) eq "marico_i" or lcase(hcomid) eq "knights_i" or lcase(hcomid) eq "manhattan_i" or lcase(hcomid) eq "elmanhattan_i" or lcase(hcomid) eq "alsale_i" or lcase(hcomid) eq "letrain_i" or lcase(hcomid) eq "elitez_i" or lcase(hcomid) eq "reaktion_i" or lcase(hcomid) eq "amtaire_i" or lcase(hcomid) eq "taftc_i" or lcase(hcomid) eq "bofi_i" or lcase(hcomid) eq "avonservices_i" or lcase(hcomid) eq "widos_i" or lcase(hcomid) eq "avoncars_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "cleansing_i" or lcase(hcomid) eq "manhattan09_i" or lcase(hcomid) eq "marquis_i" or lcase(hcomid) eq "bspl_i" or lcase(hcomid) eq "ccwpl_i">
			<th>#getgsetup.rem11#</th>
       	  <td rowspan="2">
          
		<textarea name="remark11" id="remark11" cols='40' rows='3' onKeyDown="limitText(this.form.remark11,200);" onKeyUp="limitText(this.form.remark11,200);">#remark11#</textarea>			</td>
		<cfelseif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "ideakonzepte_i" or lcase(hcomid) eq "bestform_i" or lcase(hcomid) eq "ovas_i">
			<th>#getgsetup.rem11#</th>
       	<td rowspan="2">
          <cfif remark11 eq "">
            <textarea name="remark11" id="remark11" cols='40' rows='3' onKeyDown="limitText(this.form.remark11,300);" onKeyUp="limitText(this.form.remark11,300);"></textarea><cfelse>
	    <textarea name="remark11" id="remark11" cols='40' rows='3' onKeyDown="limitText(this.form.remark11,300);" onKeyUp="limitText(this.form.remark11,300);">#remark11#</textarea>		</cfif>	</td>
        
        <cfelseif lcase(hcomid) eq "mingsia_i" or lcase(hcomid) eq "knm_i">
			<th>#getgsetup.rem11#</th>
       	<td rowspan="2">
          <cfif remark11 eq "">
            <textarea name="remark11" id="remark11" cols='40' rows='3' onKeyDown="limitText(this.form.remark11,800);" onKeyUp="limitText(this.form.remark11,800);"></textarea><cfelse>
	    <textarea name="remark11" id="remark11" cols='40' rows='3' onKeyDown="limitText(this.form.remark11,800);" onKeyUp="limitText(this.form.remark11,800);">#remark11#</textarea>		</cfif>	</td>
                
                             <cfelseif lcase(hcomid) eq "accord_i" and tran eq "INV">
                             <th>#getgsetup.rem11#</th>
             <td>   <cfoutput>
<cfinput type="text" name="remark11" id="remark11" value="#remark11#" <!--- bind="cfc:accordtran2.getremark11('#dts#',{remark5})" --->></cfoutput></td>
        <cfelseif lcase(HcomID) eq "fdipx_i">
            <th>#getGsetup.rem11#</th>
			<td><textarea name="remark11" id="remark11" cols="40" rows="3" >#remark11#</textarea>
            </td>
            <cfelseif lcase(hcomid) eq "powernas_i" or lcase(hcomid) eq "acerich_i">
                <cfquery name="getsupplist" datasource="#dts#">
                select custno,name from #target_apvend#
                </cfquery>
				<th>#getgsetup.rem11#</th>
        		<td>
                <select  name="remark11">
                <option value="">Please Choose a supplier</option>
                <cfloop query="getsupplist">
                <option value="#getsupplist.custno#"<cfif remark11 eq getsupplist.custno>selected</cfif>>#getsupplist.custno# - #getsupplist.name#</option>
                </cfloop>
                </select>
				</td>
        <cfelseif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i">
            <th>#getgsetup.rem11#</th>
         <td><input type="checkbox" name="rem11check" id="rem11check" value="Yes" <cfif remark11 eq "YES"> checked</cfif> onClick="if(this.checked == true){document.getElementById('remark11').value='YES';} else {document.getElementById('remark11').value='NO';}">
         <input type="hidden" name="remark11" value="#remark11#" size="40" maxlength="35">	</td>
		<cfelseif lcase(HcomID) neq "avt_i">
			<th <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getGsetup.rem11#</th>
			<td <cfif lcase(hcomid) eq "visionlaw_i">style="visibility:hidden"</cfif>><input type="text" name="remark11" value="#remark11#" size="40" maxlength="35"></td>

		<cfelse>
			<td colspan="2"></td>
	  </cfif>
	</tr>
	<tr>
		<th><cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">Heading<cfelse>#getGsetup.rem12#</cfif></th>

		<td colspan="2"><input type="text" name="remark12" size="40" maxlength="35" <cfif lcase(HcomID) eq "hl_i" and tran eq "PO"> value="#remark12#"<cfelse>value="#remark12#" readonly</cfif>></td>

		<!--- Add on 01-12-2008 --->
   	  <cfif lcase(HcomID) eq "avent_i">
			<th>FOB/CIF</th>
   		<td><input type="text" name="xremark3" value="#xremark3#" maxlength="10"></td>
        <cfelseif lcase(HcomID) eq "accord_i" and tran eq "INV">
        	<th>Cheque No:</th>
          <td><cfif isdefined('checkno')>
			  <input type="text" name="checkno" value="#checkno#" maxlength="12">
              </cfif></td>
		<cfelse>
		<td colspan="2">&nbsp;</td>
		</cfif>
	</tr>
    
    <cfif lcase(hcomid) eq "accord_i">
            <tr><td></td><td></td><td></td>
            <th>Certificate Of Merit</th>
          <td>
			  <select name="remark13" id="remark13">
<option value="" <cfif remark13 eq "">Selected</cfif>>Please select a COM</option>
<option value="true" <cfif remark13 eq "true">Selected</cfif>>True</option>
<option value="false" <cfif remark13 eq "false">Selected</cfif>>False</option>
</select><cfinput type="hidden" id="remark131" name="remark131" <!--- bind="cfc:accordtran2.getremark13('#dts#',{remark5})" --->>
</td>
            </tr>
        </cfif>
        
	<cfif lcase(HcomID) eq "avt_i">
	<tr>
		<th>#getgsetup.rem11#</th>
		<td colspan="5">
			<textarea name="remark11" wrap="physical" cols="60" rows="5" onKeyDown="textCounter(this.form.remark11,this.form.remLen,300);" onKeyUp="textCounter(this.form.remark11,this.form.remLen,300);">#remark11#</textarea><br>
			<input readonly type="text" name="remLen" size="3" maxlength="3" value="300"> characters left ( You may enter up to 300 characters. )<br></font>		</td>
	</tr>
	</cfif>
    <!--- Add on 290608 --->
    <cfif lcase(HcomID) eq "avent_i">
    <tr>
    	<th rowspan="2">Comment</th>
        <td><select name="comment_selection" onChange="changeComment();">
        		<option value="">Select a comment</option>
                <cfloop query="getcomment">
                	<option value="#getcomment.code#">#getcomment.desp#</option>
                </cfloop>
            </select>        </td>
    </tr>
    <tr><td><textarea name="comment_selected" wrap="physical" cols="70" rows="4">#xremark1#</textarea></td></tr>
	<tr>
		<th>Designation</th>
		<td><textarea name="xremark2" wrap="physical" cols="70" rows="4">#xremark2#</textarea></td>
	</tr>
	<cfelseif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">
		<tr>
    		<th>Installation & Commissioning</th>
      		<td><select name="xremark1">
					<option value="1" <cfif xremark1 eq "1">selected</cfif>>Yes</option>
        			<option value="" <cfif xremark1 eq "">selected</cfif>>No</option>
            	</select>        	</td>
		</tr>
		<tr>
			<th>Note</th>
			<td><textarea name="xremark2" wrap="physical" cols="60" rows="4">#xremark2#</textarea></td>
		</tr>
	<cfelseif lcase(HcomID) eq "winbells_i">
		<tr><td colspan="100%"><hr></td></tr>
		<tr>
    		<th>JOB REF</th>
      		<td><input type="text" name="xremark1" value="#xremark1#" size="40"></td>
			<td></td>
			<th>Port Of Discharge</th>
      		<td><input type="text" name="xremark9" value="#xremark9#" size="40"></td>
		</tr>
		<tr>
			<th>CARRIER</th>
			<td><input type="text" name="xremark2" value="#xremark2#" size="40"></td>
			<td></td>
			<th>ETD</th>
      		<td><input type="text" name="xremark10" value="#xremark10#" size="40"></td>
		</tr>
		<tr>
			<th>OB/L REF</th>
			<td><input type="text" name="xremark3" value="#xremark3#" size="40"></td>
			<td></td>
			<th>ETA</th>
      		<td><input type="text" name="xremark11" value="#xremark11#" size="40"></td>
		</tr>
		<tr>
			<th>HB/L REF</th>
			<td><input type="text" name="xremark4" value="#xremark4#" size="40"></td>
			<td></td>
			<th>FLIGHT</th>
      		<td><input type="text" name="xremark12" value="#xremark12#" size="40"></td>
		</tr>
		<tr>
			<th>M VESSEL</th>
			<td><input type="text" name="xremark5" value="#xremark5#" size="40"></td>
			<td></td>
			<th>DATE</th>
      		<td><input type="text" name="xremark13" value="#xremark13#" size="40"></td>
		</tr>
		<tr>
			<th>F VESSEL</th>
			<td><input type="text" name="xremark6" value="#xremark6#" size="40"></td>
			<td></td>
			<th>MASTER AWB NO.</th>
      		<td><input type="text" name="xremark14" value="#xremark14#" size="40"></td>
		</tr>
		<tr>
			<th>VOYAGE</th>
			<td><input type="text" name="xremark7" value="#xremark7#" size="40"></td>
			<td></td>
			<th>HAWB NO.</th>
      		<td><input type="text" name="xremark15" value="#xremark15#" size="40"></td>
		</tr>
		<tr>
			<th>Port Of Loading</th>
			<td><input type="text" name="xremark8" value="#xremark8#" size="40"></td>
			<td></td>
			<th>AIR WAY BILL</th>
      		<td><input type="text" name="xremark16" value="#xremark16#" size="40"></td>
		</tr>
		<tr>
			<th>CONTAINER NO.</th>
			<td>
				<textarea name="xremark17" wrap="physical" cols="40" rows="4">#xremark17#</textarea>			</td>
		</tr>
    <cfelseif lcase(HcomID) eq "iel_i">
		<tr><td colspan="100%"><hr></td></tr>
		<tr>
    		<th>TRANSPORTATION OF</th>
      		<td><input type="text" name="xremark1" value="#xremark1#" size="40"></td>
			<td></td>
			<th rowspan="3">DIMENSION</th>
      		<td rowspan="3"><textarea name="xremark2" wrap="physical" cols="40" rows="4">#xremark2#</textarea></td>
		</tr>
        <tr>
    		<th>FROM</th>
      		<td><input type="text" name="xremark3" value="#xremark3#" size="40"></td>
			<td></td>
		</tr>
		<tr>
			<th>TO</th>
			<td><input type="text" name="xremark4" value="#xremark4#" size="40"></td>
			<td></td>
		</tr>
    <cfelseif lcase(HcomID) eq "zeadine_i" or lcase(HcomID) eq "zeadine09_i">
		<tr>
			<th>Note</th>
			<td><textarea name="xremark1" wrap="physical" cols="60" rows="4">#xremark1#</textarea></td>
		</tr>
	<cfelseif lcase(HcomID) eq "chemline_i">
		<tr><td colspan="100%"><hr></td></tr>
		<tr>
    		<th>XRemark 1</th>
      		<td><input type="text" name="xremark1" value="#xremark1#" size="40"></td>
			<td></td>
			<th>XRemark 6</th>
      		<td><input type="text" name="xremark6" value="#xremark6#" size="40"></td>
		</tr>
		<tr>
			<th>XRemark 2</th>
			<td><input type="text" name="xremark2" value="#xremark2#" size="40"></td>
			<td></td>
			<th>XRemark 7</th>
      		<td><input type="text" name="xremark7" value="#xremark7#" size="40"></td>
		</tr>
		<tr>
			<th>XRemark 3</th>
			<td><input type="text" name="xremark3" value="#xremark3#" size="40"></td>
			<td></td>
    		<th rowspan="3">XRemark 8</th>
	        <td rowspan="3">
		        <select name="comment_selection" onChange="changeComment();">
	        		<option value="">Select a comment</option>
	                <cfloop query="getcomment">
	                	<option value="#getcomment.code#">#getcomment.desp#</option>
	                </cfloop>
	            </select><br>
		        <textarea name="comment_selected" wrap="physical" cols="40" rows="4">#xremark8#</textarea>	        </td>
	    </tr>
		<tr>
			<th>QUOT NO</th>
			<td><input type="text" name="xremark4" value="#xremark4#" size="40"></td>
			<td></td>
		</tr>
		<tr>
			<th>XRemark 5</th>
			<td><input type="text" name="xremark5" value="#xremark5#" size="40"></td>
			<td></td>
		</tr>
	<cfelseif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
		<tr>
    		<th>GST</th>
      		<td><input type="text" name="xremark1" value="#xremark1#" size="40"></td>
		</tr>
		<tr>
			<th>Validity</th>
			<td><input type="text" name="xremark2" value="#xremark2#" size="40"></td>
		</tr>
	<cfelseif lcase(HcomID) eq "probulk_i">
		<tr>
    		<th>Remark A</th>
      		<td>
				<select name="xremark1">
					<option value="Owner">Owner</option>
					<option value="Charter" <cfif xremark1 eq "Charter">selected</cfif>>Charter</option>
				</select>			</td>
			<td></td>
			<th>Remark B</th>
      		<td>
				<select name="xremark2">
					<option value="Charter Hire Payable">Charter Hire Payable</option>
					<option value="Freight Hire Payable" <cfif xremark2 eq "Freight Hire Payable">selected</cfif>>Freight Hire Payable</option>
				</select>			</td>
		</tr>
		<tr>
    		<th>Remark C</th>
      		<td><input type="text" name="xremark3" value="#xremark3#" size="40"></td>
			<td></td>
			<th rowspan="3">Remark D</th>
      		<td rowspan="3"><textarea name="xremark4" wrap="physical" cols="40" rows="4">#xremark4#</textarea></td>
		</tr>
		<tr>
    		<th>Remark E</th>
      		<td><input type="text" name="xremark5" value="#xremark5#" size="40"></td>
			<td></td>
		</tr>
		<tr>
    		<th>Remark F</th>
      		<td><input type="text" name="xremark6" value="#xremark6#" size="40"></td>
			<td></td>
		</tr>
		<tr>
    		<th>Total Bill</th>
      		<td><input type="text" name="xremark7" value="#xremark7#" size="40"></td>
			<td></td>
		</tr>
    </cfif>
    <!--- Add on 290608 --->
                <cfif lcase(hcomid) eq "mcjim_i" and tran eq "DO">
        <tr>
				<td colspan="5">
					<table align="center">
						<tr>
							<th>Material</th>
							<td colspan="4"><input type="text" name="frem0" value="#convertquote(frem0)#" maxlength="80" size="80"></td>
						</tr>
						<tr>
							<th>Colour</th>
							<td colspan="4"><input type="text" name="frem1" value="#convertquote(frem1)#" maxlength="80" size="80"></td>
						</tr>
						<tr>
							<th>Specification</th>
							<td colspan="4"><input type="text" name="frem2" value="#frem2#" maxlength="80" size="80"></td>
						</tr>
						<tr>
							<th>Requirement</th>
							<td colspan="4"><input type="text" name="frem3" value="#frem3#" maxlength="80" size="80"></td>
						</tr>
						<tr>
							<th>D.O/Invoice No. (1)</th>
							<td colspan="4"><input type="text" name="frem4" value="#frem4#" maxlength="80" size="80"></td>
						</tr>
						<tr>
							<th>D.O/Invoice No. (2)</th>
							<td colspan="4"><input type="text" name="frem5" value="#frem5#" maxlength="80" size="80"></td>
						</tr>
						<tr>
							<th>D.O/Invoice No. (3)</th>
							<td colspan="4"><input type="text" name="frem6" value="#frem6#" maxlength="80" size="80"></td>
						</tr>
						<tr>
							<th>D.O/Invoice No. (4)</th>
							<td colspan="4"><input type="text" name="frem7" value="#convertquote(frem7)#" maxlength="80" size="80"></td>
						</tr>
						<tr>
							<th>D.O/Invoice No. (5)</th>
							<td colspan="4">
							<input type="text" name="frem8" value="#convertquote(frem8)#" maxlength="80" size="80">							</td>

							<input type="hidden" name="comm0" value="#convertquote(comm0)#">
							<input type="hidden" name="remark13" value="#remark13#">
							<input type="hidden" name="remark14" value="#remark14#">
							<input type="hidden" name="comm3" value="#comm3#">
							<input type="hidden" name="comm4" value="#comm4#">
                            <input type="hidden" name="phonea" value="#phonea#">
                            <input type="hidden" name="e_mail" value="#e_mail#">
						</tr>
						<tr>
							<th>D.O/Invoice No. (6)</th>
							<td colspan="4"><input type="text" name="frem9" value="#frem9#" maxlength="80" size="80"></td>
						</tr>
                        <tr>
							<th>Footer Remark 10</th>
							<td colspan="4"><input type="text" name="comm1" value="#convertquote(comm1)#" maxlength="80" size="80"></td>
						</tr>
                        <tr>
							<th>Footer Remark 11</th>
							<td colspan="4"><input type="text" name="comm2" value="#convertquote(comm2)#" maxlength="80" size="80"></td>
						</tr>
                        <tr>
							<th>Footer Remark 12</th>
							<td colspan="4"><input type="text" name="comm3" value="#convertquote(comm3)#" maxlength="80" size="80"></td>
						</tr>
                        <tr>
							<th>Footer Remark 13</th>
							<td colspan="4"><input type="text" name="comm4" value="#convertquote(comm4)#" maxlength="80" size="80"></td>
						</tr>
                        <tr>
							<th>Footer Remark 14</th>
							<td colspan="4"><input type="text" name="remark13" value="#remark13#" maxlength="80" size="80"></td>
						</tr>
                        <tr>
							<th>Footer Remark 15</th>
							<td colspan="4"><input type="text" name="remark14" value="#remark14#" maxlength="80" size="80"></td>
						</tr>
					</table>				</td>
			</tr>
			</cfif>
            <cfif getgsetup.addonremark eq 'Y'>
            <tr><td colspan="5">
            <cfinclude template="tran2addon.cfm">
            </td>
</tr>
</cfif>
 <cfif getgsetup.multiagent eq 'Y'>
            <tr><td colspan="5">
            <cfinclude template="tranmultiagent.cfm">
            </td>
</tr>
</cfif>

	<tr>
		<td colspan="5" align="center">
        <cfif lcase(hcomid) eq 'mcjim_i' and tran eq "DO">
        <cfelseif lcase(hcomid) eq 'accord_i'>
        	<input type="hidden" name="frem0" value="#convertquote(frem0)#">
			<input type="hidden" name="frem1" value="#convertquote(frem1)#">
			<input type="hidden" name="frem2" value="#frem2#">
			<input type="hidden" name="frem3" value="#frem3#">
			<input type="hidden" name="frem4" value="#frem4#">
			<input type="hidden" name="frem5" value="#frem5#">
			<input type="hidden" name="frem6" value="#frem6#">
			<input type="hidden" name="frem7" value="#convertquote(frem7)#">
			<input type="hidden" name="frem8" value="#convertquote(frem8)#">
			<input type="hidden" name="frem9" value="#frem9#">
			<input type="hidden" name="comm0" value="#convertquote(comm0)#">
			<input type="hidden" name="comm1" value="#convertquote(comm1)#">
			<input type="hidden" name="comm2" value="#convertquote(comm2)#">
			<input type="hidden" name="comm3" value="#convertquote(comm3)#">
			<input type="hidden" name="comm4" value="#convertquote(comm4)#">
			<input type="hidden" name="remark14" value="#remark14#">
			<input type="hidden" name="phonea" value="#phonea#">
            <input type="hidden" name="e_mail" value="#e_mail#">
        <cfelse>
			<input type="hidden" name="frem0" value="#convertquote(frem0)#">
			<input type="hidden" name="frem1" value="#convertquote(frem1)#">
			<input type="hidden" name="frem2" value="#frem2#">
			<input type="hidden" name="frem3" value="#frem3#">
			<input type="hidden" name="frem4" value="#frem4#">
			<input type="hidden" name="frem5" value="#frem5#">
			<input type="hidden" name="frem6" value="#frem6#">
			<input type="hidden" name="frem7" value="#convertquote(frem7)#">
			<input type="hidden" name="frem8" value="#convertquote(frem8)#">
			<input type="hidden" name="frem9" value="#frem9#">
			<input type="hidden" name="comm0" value="#convertquote(comm0)#">
			<input type="hidden" name="comm1" value="#convertquote(comm1)#">
			<input type="hidden" name="comm2" value="#convertquote(comm2)#">
			<input type="hidden" name="comm3" value="#convertquote(comm3)#">
			<input type="hidden" name="comm4" value="#convertquote(comm4)#">
			<input type="hidden" name="remark13" value="#remark13#">
			<input type="hidden" name="remark14" value="#remark14#">
			<input type="hidden" name="phonea" value="#phonea#">
            <input type="hidden" name="e_mail" value="#e_mail#">
			</cfif>
			<cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
            	<input type="hidden" name="remark15" value="#remark15#">
                <input type="hidden" name="remark16" value="#remark16#">
                <input type="hidden" name="remark17" value="#remark17#">
                <input type="hidden" name="remark18" value="#remark18#">
                <input type="hidden" name="remark19" value="#remark19#">
                <input type="hidden" name="remark20" value="#remark20#">
                <input type="hidden" name="remark21" value="#remark21#">
                <input type="hidden" name="remark22" value="#remark22#">
                <input type="hidden" name="remark23" value="#remark23#">
                <input type="hidden" name="remark24" value="#remark24#">
                <input type="hidden" name="remark25" value="#remark25#">
            </cfif>
            <cfif lcase(hcomid) eq 'ugateway_i'>
            	<input type="hidden" name="via" value="#via#" >
			</cfif>	
			<input type="hidden" name="readpeiod" value="#getartran.fperiod#">
			<input name="main" type="button" value="Update Address" onClick="location.href='tran_edit1.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(custno)#&first=0'">
			<!--- ADD ON 10-12-2009 --->
			<input name="submit1" type="submit" value="  Save  "<cfif getGsetup.filterall eq "1"> onclick="checkupdate();"</cfif>>
			<input name="submit1" type="submit" value="  Edit  "<cfif getGsetup.filterall eq "1"> onclick="checkupdate();"</cfif>>		</td>
	</tr>
  	</table>
  </cfoutput>
</cfform>
<cfif lcase(HcomID) eq "kimlee_i" and tran eq "CN" or lcase(HcomID) eq "bakersoven_i" and tran eq "CN">
<!--- <cfwindow  width="600" height="400" name="findInvoice" refreshOnShow="true"
        title="Find Invoice" initshow="false"
        source="/default/transaction/findInvoice.cfm" /> --->
</cfif>
<!--- <cfwindow  width="600" height="400" name="createJobAjax" refreshOnShow="true"
        title="Create Job" initshow="false"
        source="/default/transaction/createJobAjax.cfm" />
<cfwindow  width="600" height="400" name="createProjectAjax" refreshOnShow="true"
        title="Create Project" initshow="false"
        source="/default/transaction/createProjectAjax.cfm" /> --->
<!---------------------------------------------------------------------- DATA VALIDATION ---------------------------------------------------->
<script language="JavaScript">
	function textCounter(field, countfield, maxlimit){
		if (field.value.length > maxlimit) // if too long...trim it!
			field.value = field.value.substring(0, maxlimit);
			// otherwise, update 'characters left' counter
		else 
			countfield.value = maxlimit - field.value.length;
	}// End -->
	function limitText(field,maxlimit){
		if (field.value.length > maxlimit) // if too long...trim it!
			field.value = field.value.substring(0, maxlimit);
			// otherwise, update 'characters left' counter
	}
	function displayname(){
		if(document.invoicesheet.custno.value==''){
			document.invoicesheet.name.value='';
			document.invoicesheet.name2.value='';
		}else{
			<cfoutput query ="getcustomer">
			if(document.invoicesheet.custno.value=='#getcustomer.custno#')
			{
				document.invoicesheet.refno3.value='#getcustomer.currcode#';
			}
			</cfoutput>
		}
	}
	function displayrate(){
  		if(document.invoicesheet.refno3.value==''){
			<cfoutput query ="getcustomer">
	  		if(document.invoicesheet.custno.value=='#getcustomer.custno#'){
				document.invoicesheet.refno3.value='#getcustomer.currcode#';
	  		}
			</cfoutput>
  		}
		if(document.invoicesheet.refno3.value!=''){
			<cfoutput query ="currency">
			if(document.invoicesheet.refno3.value=='#currency.currcode#'){	
				<cfquery datasource="#dts#" name="getGsetup">
					Select * from GSetup
				</cfquery>

				<cfset lastaccyear = dateformat(getGsetup.lastaccyear, "dd/mm/yyyy")>
				<cfset period = getGsetup.period>
				<cfset currentdate = dateformat(nDateCreate,"dd/mm/yyyy")>
				<cfset tmpYear = year(currentdate)>
				<cfset clsyear = year(lastaccyear)>
				<!--- MODIFIED ON 04-02-2009 --->
				<!--- <cfset tmpmonth = month(currentdate)> --->
				<cfset tmpmonth = month(nDateCreate)>
				<cfset clsmonth = month(lastaccyear)>
				<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>

				<cfif intperiod gt 18 or intperiod lte 0>
					<cfset readperiod = 99>
				<cfelse>
					<cfset readperiod = numberformat(intperiod,"00")>
				</cfif>

				<cfif readperiod eq '01'>
					<cfset rates2 = currency.CurrP1>
				<cfelseif readperiod eq '02'>
					<cfset rates2 = currency.CurrP2>
				<cfelseif readperiod eq '03'>
					<cfset rates2 = currency.CurrP3>
				<cfelseif readperiod eq '04'>
					<cfset rates2 = currency.CurrP4>
				<cfelseif readperiod eq '05'>
					<cfset rates2 = currency.CurrP5>
				<cfelseif readperiod eq '06'>
					<cfset rates2 = currency.CurrP6>
				<cfelseif readperiod eq '07'>
					<cfset rates2 = currency.CurrP7>
				<cfelseif readperiod eq '08'>
					<cfset rates2 = currency.CurrP8>
				<cfelseif readperiod eq '09'>
					<cfset rates2 = currency.CurrP9>
				<cfelseif readperiod eq '10'>
					<cfset rates2 = currency.CurrP10>
				<cfelseif readperiod eq '11'>
					<cfset rates2 = currency.CurrP11>
				<cfelseif readperiod eq '12'>
					<cfset rates2 = currency.CurrP12>
				<cfelseif readperiod eq '13'>
					<cfset rates2 = currency.CurrP13>
				<cfelseif readperiod eq '14'>
					<cfset rates2 = currency.CurrP14>
				<cfelseif readperiod eq '15'>
					<cfset rates2 = currency.CurrP15>
				<cfelseif readperiod eq '16'>
					<cfset rates2 = currency.CurrP16>
				<cfelseif readperiod eq '17'>
					<cfset rates2 = currency.CurrP17>
				<cfelseif readperiod eq '18'>
					<cfset rates2 = currency.CurrP18>
				<cfelse>
					<cfset rates2 = currrate>
				</cfif>
				document.invoicesheet.currrate.value='#numberformat(rates2,"._____")#';
			}
			</cfoutput>
		}
	}
	function NextTransNo(){
   		document.invoicesheet.currefno.value == '#currefno#';
   		return true;
 	}
	function ChgDueDate(){
  		if(document.invoicesheet.terms.value != ''){
			<cfoutput query ="getTerm">
 			if(document.invoicesheet.terms.value == '#term#')
			{
        		<cfif sign eq "P">
        			<cfquery datasource="#dts#" name="getDays">
						Select days from #target_icterm# where term = 'document.invoicesheet.terms.value'
  					</cfquery>

					<cfset Days = getDays.days>
					<cfset xDate = "#dateformat(nDateCreate, "dd/mm/yyyy")#">
					<cfset yDate = DateAdd("y", #Days#, #xDate#)>
  					document.invoicesheet.remark6.value = '#dateformat(yDate, 'dd/mm/yyyy')#';
  				</cfif>
  			}
 			</cfoutput>
   		}else{
       		document.invoicesheet.remark6.value = '';
   		}
 	}
	
	//Add on 300608
	function changeComment(){
		var a = document.invoicesheet.comment_selection.options[document.invoicesheet.comment_selection.selectedIndex].value;
		if(a != ''){
			document.all.feedcontact1.dataurl="databind/act_getcomment.cfm?commentcode=" + a;
			//prompt("D",document.all.feedcontact1.dataurl);
			document.all.feedcontact1.charset=document.charset;
			document.all.feedcontact1.reset();
		}
	}
	
	function show_info(rset){
		rset.MoveFirst();
		document.invoicesheet.comment_selected.value = unescape(rset.fields("commentdetails").value);
	}
</script>
<div id="keeptrackbug">
</div>
<cfif isdefined('url.posttrue')>

<script type="text/javascript">
<cfif lcase(HcomID) eq "hyray_i">
<cfoutput>
ajaxFunction(document.getElementById('keeptrackbug'),'/default/transaction/keeptrackbug.cfm?agenno='+document.getElementById("agenno").value+'&type=create&fieldtype=agent&custno=#custno#&tran=#tran#&refno=#currefno#');
</cfoutput>
</cfif>
document.invoicesheet.submit();
</script>
</cfif>

</body>
</html>