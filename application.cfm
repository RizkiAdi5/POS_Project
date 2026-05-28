<cfsilent><!---
************************************************************************
Program Name : application.cfm
Program : To SET Application informations to all pages
************************************************************************
--->
<cfif NOT structKeyExists(REQUEST, "_pos_app_bootstrapped")>
<cfset REQUEST._pos_app_bootstrapped = true>
<!---
	Deployment (edit per installation — all settings here, no separate config file):
	- appScopeName: cfapplication name; use a unique value if several apps share one engine.
	- defaultDts: tenant Lucee/Railo datasource. Staff login overwrites `dts` from users;
	  customer e-menu needs this set before go-live. Leave "" for staff-only installs.
--->
<cfset appScopeName = "webordersystem">
<cfset defaultDts = "">
<!--- Xendit: prefer PaymentGateway/pgConfig.cfm (copy from pgConfig.example.cfm). Restart app pool after key change. --->
<cfapplication name="#appScopeName#" sessionmanagement="yes" clientmanagement="no" sessiontimeout="#createTimespan(0,12,0,0)#">
<cfset dts = trim(defaultDts)>
<!--- ================================================================
  CUSTOMER E-MENU ROUTE GUARD
  If the request path is under /latest/customer/ we skip the staff
  login block entirely and set up a lightweight customer session.
  All staff routes below are completely unchanged.
================================================================ --->
<cfset REQUEST.isCustomerRoute = (
    findNoCase("/latest/customer/", CGI.SCRIPT_NAME) gt 0
    OR findNoCase("/latest/customer/", CGI.PATH_INFO) gt 0
    OR findNoCase("/PaymentGateway/payment", CGI.SCRIPT_NAME) gt 0
    OR findNoCase("/PaymentGateway/payment", CGI.PATH_INFO) gt 0
)>

<cfif REQUEST.isCustomerRoute>
    <cfset resolvedDts = "">
    <cfset dtsCandidate = "">
    <cfset qDtsCheck = "">
    <cfset qTenantList = "">
    <cfset qTokenHit = "">
    <cfset qrToken = "">

    <!--- Session tenant (preferred) --->
    <cfif structKeyExists(SESSION, "emenu_dts") AND len(trim(toString(SESSION.emenu_dts)))>
        <cfset resolvedDts = trim(toString(SESSION.emenu_dts))>
    </cfif>

    <!--- Explicit db from URL/form link --->
    <cfif NOT len(resolvedDts) AND structKeyExists(URL, "db")>
        <cfset dtsCandidate = trim(toString(URL.db))>
        <cfif reFind("^[A-Za-z0-9_]+$", dtsCandidate)><cfset resolvedDts = dtsCandidate></cfif>
    </cfif>
    <cfif NOT len(resolvedDts) AND structKeyExists(FORM, "db")>
        <cfset dtsCandidate = trim(toString(FORM.db))>
        <cfif reFind("^[A-Za-z0-9_]+$", dtsCandidate)><cfset resolvedDts = dtsCandidate></cfif>
    </cfif>

    <!--- Useful fallback when customer flow starts from staff session --->
    <cfif NOT len(resolvedDts) AND structKeyExists(SESSION, "usercty") AND len(trim(toString(SESSION.usercty)))>
        <cfset dtsCandidate = trim(toString(SESSION.usercty))>
        <cfif reFind("^[A-Za-z0-9_]+$", dtsCandidate)><cfset resolvedDts = dtsCandidate></cfif>
    </cfif>

    <!--- Resolve by QR token across known tenant datasources --->
    <cfif NOT len(resolvedDts) AND structKeyExists(URL, "t") AND len(trim(toString(URL.t)))>
        <cfset qrToken = trim(toString(URL.t))>
        <cftry>
            <cfquery name="qTenantList" datasource="main">
                SELECT DISTINCT userdept
                FROM users
                WHERE userdept IS NOT NULL
                  AND TRIM(userdept) <> ''
                ORDER BY userdept
            </cfquery>
            <cfloop query="qTenantList">
                <cfset dtsCandidate = trim(toString(qTenantList.userdept))>
                <cfif reFind("^[A-Za-z0-9_]+$", dtsCandidate)>
                    <cftry>
                        <cfquery name="qTokenHit" datasource="#dtsCandidate#">
                            SELECT COUNT(*) AS row_count
                            FROM app_tables
                            WHERE qr_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qrToken#">
                            LIMIT 1
                        </cfquery>
                        <cfif val(qTokenHit.row_count) gt 0>
                            <cfset resolvedDts = dtsCandidate>
                            <cfbreak>
                        </cfif>
                        <cfcatch type="any"></cfcatch>
                    </cftry>
                </cfif>
            </cfloop>
            <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>

    <!--- Final deployment fallback --->
    <cfif NOT len(resolvedDts)>
        <cfset dtsCandidate = trim(defaultDts)>
        <cfif reFind("^[A-Za-z0-9_]+$", dtsCandidate)><cfset resolvedDts = dtsCandidate></cfif>
    </cfif>
    <cfset dts = resolvedDts>

    <!--- Customer session defaults --->
    <cfparam name="SESSION.emenu_custno"      default="">
    <cfparam name="SESSION.emenu_name"        default="">
    <cfparam name="SESSION.emenu_email"       default="">
    <cfparam name="SESSION.emenu_loggedin"    default="No">
    <cfparam name="SESSION.emenu_table_id"    default="">
    <cfparam name="SESSION.emenu_table_number" default="">
    <cfparam name="SESSION.emenu_qr_token"    default="">
    <cfparam name="SESSION.emenu_order_id"    default="">
    <cfparam name="SESSION.emenu_order_number" default="">
    <cfparam name="SESSION.emenu_cart_locked" default="false">
    <cfparam name="SESSION.emenu_is_guest"    default="No">
    <cfparam name="SESSION.emenu_dts"         default="">
    <cfif len(dts)><cfset SESSION.emenu_dts = dts></cfif>
    <cfif NOT len(dts)>
        <h2>Customer datasource not resolved. Please regenerate QR from waiter dashboard.</h2>
        <cfabort>
    </cfif>
    <cftry>
        <cfinclude template="/latest/customer/inc_emenu_currency.cfm">
        <cfcatch type="any"></cfcatch>
    </cftry>
    <cfparam name="REQUEST.emenu_currency_code" default="MYR">
    <cfparam name="REQUEST.emenu_currency_symbol" default="RM">
    <cfparam name="REQUEST.emenu_currency_decimals" default="2">
    <cfset SESSION.emenu_currency_code = REQUEST.emenu_currency_code>
    <cfset SESSION.emenu_currency_symbol = REQUEST.emenu_currency_symbol>
    <cfset SESSION.emenu_currency_decimals = REQUEST.emenu_currency_decimals>

<cfelse>

    <!--- ============================================================
      STAFF LOGIN BLOCK — unchanged from original
    ============================================================ --->
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
<cfset HRootPath = "C:\inetpub\wwwroot\POS\POS_Project">
<cfset Hlinkams = getHQstatus.linktoams>
<!--- ADD ON 300908, THE USER LOCATION --->
<cfset Huserloc = getHQstatus.location>
<cfset hlang = ""><!--- optional: getHQstatus.lang --->
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

</cfif><!--- end staff-only block --->
</cfif><!--- end request bootstrap guard --->
</cfsilent>