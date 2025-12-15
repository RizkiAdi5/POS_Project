<cfsilent><!---
************************************************************************
Program Name : application.cfm
Program : To SET Application informations to all pages
************************************************************************
--->
<cfapplication name="webordersystem" sessionmanagement="yes" clientmanagement="no" sessiontimeout="#createTimespan(0,12,0,0)#">

<cfinclude template="/latest/login/loginProcess.cfm">


<cfparam name="SESSION.loginTime" default="">  
<cfparam name="SESSION.isLogIn" default="No">
<cfparam name="SESSION.path" default="">
<cfparam name="session.hcredit_limit_exceed" default="">
<cfparam name="session.bcredit_limit_exceed" default="">
<cfparam name="session.customercode" default="">
<cfparam name="session.tran_refno" default="">

<cfquery datasource='main' name="getHQstatus">
	Select * 
    from users 
    where userId = '#GetAuthUser()#'
</cfquery>

<cfif gethqstatus.userdept neq "">
	<cfset dts = gethqstatus.userdept>
	<cfset localdb = gethqstatus.userdept>
<cfelse>
	<h2>Please assign a database for this user.</h2>
	<cfabort>
</cfif> 

<cfset HcomID = getHQstatus.userBranch>
<cfset HUserID = getHQstatus.userId>
<cfset HUserName = getHQstatus.userName>
<cfset HUserGrpID = getHQstatus.UserGrpID>
<cfset HUserCty = getHQstatus.UserCty>
<cfset Huseremail = getHQstatus.userEmail>
<cfset Hserver = "smtp.mynetiquette.com">
<cfset HVariable1 = "">
<cfset HDir = getHQstatus.userDirectory>
<cfset HRootPath = "C:\railo\tomcat\webapps\ROOT">
<cfset Hlinkams = getHQstatus.linktoams>
<!--- ADD ON 300908, THE USER LOCATION --->
<cfset Huserloc = getHQstatus.location>
<cfset hlang = ""<!--- getHQstatus.lang--->>
<!--- ADD ON 110211, THE USER GROUP --->
<cfset Hitemgroup = getHQstatus.itemgroup>

<cfset start_time1=timeformat(getHQstatus.start_time,"HH:mm:ss")>
<cfset end_time1=timeformat(getHQstatus.end_time,"HH:mm:ss")>
<cfset timenow=timeformat(now(),"HH:mm:ss")>
<cfif getHQstatus.start_time neq "" and start_time1 neq "00:00:00">
	<cfset start_hr=listgetat(start_time1,1,":")>
    <cfset start_min=listgetat(start_time1,2,":")>
    
    <cfif listgetat(timenow,1,":") lt start_hr>
		<cfinclude template="logout.cfm"><cfabort>
	</cfif>
    <cfif listgetat(timenow,1,":") eq start_hr and listgetat(timenow,2,":") lt start_min>
		<cfinclude template="logout.cfm"><cfabort>
	</cfif>
</cfif>
<cfif getHQstatus.end_time neq "" and end_time1 neq "00:00:00">
	<cfset end_hr=listgetat(end_time1,1,":")>
    <cfset end_min=listgetat(end_time1,2,":")>
    
    <cfif listgetat(timenow,1,":") gt end_hr>
		<cfinclude template="logout.cfm"><cfabort>
	</cfif>
    <cfif listgetat(timenow,1,":") eq end_hr and listgetat(timenow,2,":") gt end_min>
		<cfinclude template="logout.cfm"><cfabort>
	</cfif>
</cfif>
<cfquery name="getPRtype" datasource="#dts#">
SELECT prf from gsetup
</cfquery>

<cfif Hlinkams eq "Y">
	<cfset target_arcust = replacenocase(dts,"_i","_a","all")&".arcust">
	<cfif getPRtype.prf eq "creditor">
	<cfset target_apvend = replacenocase(dts,"_i","_a","all")&".apvend">
	<cfelse>
    <cfset target_apvend = replacenocase(dts,"_i","_a","all")&".arcust">
	</cfif>
	<cfset target_icterm = replacenocase(dts,"_i","_a","all")&".icterm">
	<cfset target_currency = replacenocase(dts,"_i","_a","all")&".currency">
	<cfset target_taxtable = replacenocase(dts,"_i","_a","all")&".taxtable">
    <cfset target_icarea = replacenocase(dts,"_i","_a","all")&".icarea">
<cfelse>
	<cfset target_arcust = dts&".arcust">
	 <cfif getPRtype.prf eq "creditor"> 
	<cfset target_apvend = dts&".apvend">
   	<cfelse>
    <cfset target_apvend = dts&".arcust">
    </cfif>
	<cfset target_icterm = dts&".icterm">
	<cfset target_currency = dts&".currency">
	<cfset target_taxtable = dts&".taxtable">
    <cfset target_project = dts&".project">
    <cfset target_icagent = dts&".icagent">
    <cfset target_icarea = dts&".icarea">
</cfif>

<cfset dtssync=replace(dts,'_i','sync','all')>

<!--- ADD ON 050608 --->
<cfif husergrpid eq "suser">
	<cfset thislevel = "standard">
<cfelseif husergrpid eq "guser">
	<cfset thislevel = "general">
<cfelseif husergrpid eq "luser">
	<cfset thislevel = "limited">
<cfelseif husergrpid eq "muser">
	<cfset thislevel = "mobile">
<cfelse>
	<cfset thislevel = husergrpid>
</cfif>
<!--- ADD ON 050608 --->
<cfquery name="getpin2" datasource="#dts#">
	select * 
	from userpin2 
	where level = '#thislevel#'
</cfquery>

<cfquery name="getuserpin2" datasource="#dts#">
	select * 
	from userpin2 
	where level = '#thislevel#'
</cfquery>
<!---
<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
--->
</cfsilent>