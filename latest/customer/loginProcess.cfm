<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../../application.cfm">
<cfsetting showdebugoutput="false">

<!--- Must come via POST --->
<cfif CGI.REQUEST_METHOD neq "POST">
    <cflocation url="/latest/customer/login.cfm" addtoken="false">
</cfif>

<!--- No table context --->
<cfif NOT len(trim(SESSION.emenu_table_id))>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>

<cfparam name="form.action"     default="">
<cfparam name="form.email"      default="">
<cfparam name="form.password"   default="">
<cfparam name="form.fullname"   default="">
<cfparam name="form.phone"      default="">
<cfparam name="form.descriptor" default="">

<cfset action   = lCase(trim(form.action))>
<cfset email    = lCase(trim(form.email))>
<cfset password = trim(form.password)>
<cfset fullname = trim(form.fullname)>
<cfset phone    = trim(form.phone)>

<!--- Helper: redirect back to login with an error message --->
<cffunction name="loginError" output="false" returntype="void">
    <cfargument name="msg" type="string" required="true">
    <cfargument name="tab" type="string" default="login">
    <cflocation url="/latest/customer/login.cfm?error=#URLEncodedFormat(arguments.msg)#&tab=#arguments.tab#" addtoken="false">
</cffunction>

<!--- ================================================================
    ACTION: EMAIL + PASSWORD LOGIN
================================================================ --->
<cfif action eq "login">

    <cfif NOT len(email) OR NOT len(password)>
        <cfset loginError("Please enter your email and password.")>
    </cfif>

    <!--- Hash password with SHA-256 --->
    <cfset pwHash = lCase(hash(password, "SHA-256"))>

    <cftry>
        <cfquery name="qUser" datasource="#dts#">
            SELECT CUSTNO, NAME, E_MAIL, PHONE,
                   POINT_BF, is_app_user, is_member, member_tier
            FROM   arcust
            WHERE  LOWER(E_MAIL)   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
            AND    app_password     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pwHash#">
            AND    is_app_user      = 1
            LIMIT  1
        </cfquery>
        <cfcatch type="any">
            <cfset loginError("Login service error. Please try again.")>
        </cfcatch>
    </cftry>

    <cfif qUser.recordCount eq 0>
        <cfset loginError("Incorrect email or password. Please try again.")>
    </cfif>

    <!--- Set session --->
    <cfset SESSION.emenu_loggedin  = "Yes">
    <cfset SESSION.emenu_custno    = trim(qUser.CUSTNO)>
    <cfset SESSION.emenu_name      = trim(qUser.NAME)>
    <cfset SESSION.emenu_email     = trim(qUser.E_MAIL)>
    <cfset SESSION.emenu_points    = val(qUser.POINT_BF)>
    <cfset SESSION.emenu_tier      = trim(qUser.member_tier)>
    <cfset SESSION.emenu_is_guest  = "No">

    <cflocation url="/latest/customer/menu.cfm" addtoken="false">

<!--- ================================================================
    ACTION: REGISTER NEW ACCOUNT
================================================================ --->
<cfelseif action eq "register">

    <!--- Validate inputs --->
    <cfif NOT len(fullname)>
        <cfset loginError("Please enter your full name.", "signup")>
    </cfif>
    <cfif NOT len(email) OR NOT find("@", email)>
        <cfset loginError("Please enter a valid email address.", "signup")>
    </cfif>
    <cfif len(password) lt 6>
        <cfset loginError("Password must be at least 6 characters.", "signup")>
    </cfif>

    <!--- Check email not already registered --->
    <cftry>
        <cfquery name="qExist" datasource="#dts#">
            SELECT COUNT(*) AS cnt
            FROM   arcust
            WHERE  LOWER(E_MAIL) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">
            AND    is_app_user   = 1
        </cfquery>
        <cfcatch type="any">
            <cfset loginError("Registration service error. Please try again.", "signup")>
        </cfcatch>
    </cftry>

    <cfif val(qExist.cnt) gt 0>
        <cfset loginError("This email is already registered. Please login instead.", "signup")>
    </cfif>

    <!--- Generate unique CUSTNO --->
    <!--- Format: APP + 6 digits from UUID --->
    <cfset newCustNo = "">
    <cfset attempts  = 0>
    <cfloop condition="NOT len(newCustNo) AND attempts lt 10">
        <cfset attempts++>
        <cfset candidate = "APP" & uCase(left(replace(createUUID(), "-", "", "all"), 6))>
        <cftry>
            <cfquery name="qCustCheck" datasource="#dts#">
                SELECT COUNT(*) AS cnt FROM arcust
                WHERE CUSTNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#candidate#">
            </cfquery>
            <cfcatch type="any">
                <cfset loginError("Registration service error. Please try again.", "signup")>
            </cfcatch>
        </cftry>
        <cfif val(qCustCheck.cnt) eq 0>
            <cfset newCustNo = candidate>
        </cfif>
    </cfloop>

    <cfif NOT len(newCustNo)>
        <cfset loginError("Could not generate account ID. Please try again.", "signup")>
    </cfif>

    <!--- Hash password --->
    <cfset pwHash = lCase(hash(password, "SHA-256"))>

    <!--- Insert new customer row --->
    <cftry>
        <cfquery datasource="#dts#">
            INSERT INTO arcust
                (CUSTNO, NAME, E_MAIL, PHONE,
                 is_app_user, is_member, app_password,
                 app_created_at,
                 CRLIMIT, LC_EX, TEMP, TARGET, OUTSTAND,
                 NGST_CUST, POINT_BF, TERM_IN_M,
                 DISPEC1, DISPEC2, DISPEC3, COMMPERC,
                 PROV_DISC, CREATED_ON, UPDATED_ON,
                 DATE, CR_AP_DATE, gst_app_datefrom, gst_app_dateto)
            VALUES
                (<cfqueryparam cfsqltype="cf_sql_varchar"  value="#newCustNo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#fullname#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#email#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#phone#">,
                 1, 0,
                 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#pwHash#">,
                 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                 0, 0, 0, 0, 0,
                 'T', 0, 0,
                 0, 0, 0, 0,
                 0,
                 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                 <cfqueryparam cfsqltype="cf_sql_date"      value="#now()#">,
                 <cfqueryparam cfsqltype="cf_sql_date"      value="#now()#">,
                 <cfqueryparam cfsqltype="cf_sql_date"      value="#now()#">,
                 <cfqueryparam cfsqltype="cf_sql_date"      value="#now()#">)
        </cfquery>
        <cfcatch type="any">
            <cfset loginError("Could not create account: " & left(cfcatch.message, 200), "signup")>
        </cfcatch>
    </cftry>

    <!--- Set session --->
    <cfset SESSION.emenu_loggedin = "Yes">
    <cfset SESSION.emenu_custno   = newCustNo>
    <cfset SESSION.emenu_name     = fullname>
    <cfset SESSION.emenu_email    = email>
    <cfset SESSION.emenu_points   = 0>
    <cfset SESSION.emenu_tier     = "">
    <cfset SESSION.emenu_is_guest = "No">

    <!--- New account — offer face registration then go to menu --->
    <cflocation url="/latest/customer/face_register.cfm" addtoken="false">

<!--- ================================================================
    ACTION: FACE LOGIN
================================================================ --->
<cfelseif action eq "face_login">

    <cfif NOT len(trim(form.descriptor))>
        <cfset loginError("No face data received. Please try again.")>
    </cfif>

    <!--- Parse the incoming descriptor --->
    <cftry>
        <cfset inDesc = deserializeJSON(form.descriptor)>
        <cfcatch type="any">
            <cfset loginError("Invalid face data. Please try again.")>
        </cfcatch>
    </cftry>

    <!--- Load all customers who have a face_token registered --->
    <cftry>
        <cfquery name="qFaceUsers" datasource="#dts#">
            SELECT CUSTNO, NAME, E_MAIL, PHONE,
                   POINT_BF, member_tier, face_token
            FROM   arcust
            WHERE  is_app_user = 1
            AND    face_token  IS NOT NULL
            AND    face_token  <> ''
        </cfquery>
        <cfcatch type="any">
            <cfset loginError("Face login service error. Please try again.")>
        </cfcatch>
    </cftry>

    <cfif qFaceUsers.recordCount eq 0>
        <cfset loginError("No face registered accounts found. Please login with email and password.")>
    </cfif>

    <!--- Compare descriptors — euclidean distance threshold 0.5 --->
    <cfset matchedCustNo = "">
    <cfset matchedName   = "">
    <cfset matchedEmail  = "">
    <cfset matchedPoints = 0>
    <cfset matchedTier   = "">
    <cfset bestDist      = 1>
    <cfset threshold     = 0.5>

    <cfloop query="qFaceUsers">
        <cftry>
            <cfset storedDesc = deserializeJSON(qFaceUsers.face_token)>

            <!--- Euclidean distance between two 128-float arrays --->
            <cfset sumSq = 0>
            <cfloop from="1" to="128" index="i">
                <cfset diff  = val(inDesc[i]) - val(storedDesc[i])>
                <cfset sumSq = sumSq + (diff * diff)>
            </cfloop>
            <cfset dist = sqr(sumSq)>

            <cfif dist lt bestDist>
                <cfset bestDist      = dist>
                <cfset matchedCustNo = trim(qFaceUsers.CUSTNO)>
                <cfset matchedName   = trim(qFaceUsers.NAME)>
                <cfset matchedEmail  = trim(qFaceUsers.E_MAIL)>
                <cfset matchedPoints = val(qFaceUsers.POINT_BF)>
                <cfset matchedTier   = trim(qFaceUsers.member_tier)>
            </cfif>
            <cfcatch type="any">
                <!--- Skip malformed descriptor rows --->
            </cfcatch>
        </cftry>
    </cfloop>

    <cfif bestDist gt threshold OR NOT len(matchedCustNo)>
        <cfset loginError("Face not recognised. Please try again or use email login.")>
    </cfif>

    <!--- Match found — set session --->
    <cfset SESSION.emenu_loggedin = "Yes">
    <cfset SESSION.emenu_custno   = matchedCustNo>
    <cfset SESSION.emenu_name     = matchedName>
    <cfset SESSION.emenu_email    = matchedEmail>
    <cfset SESSION.emenu_points   = matchedPoints>
    <cfset SESSION.emenu_tier     = matchedTier>
    <cfset SESSION.emenu_is_guest = "No">

    <cflocation url="/latest/customer/menu.cfm" addtoken="false">

<cfelse>
    <cflocation url="/latest/customer/login.cfm" addtoken="false">
</cfif>
