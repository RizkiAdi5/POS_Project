<html>
<head>
<title><cfif hcomid eq "pnp_i">Stock Card Details<cfelse>Stock Card Report</cfif></title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>


<!---TRY: To check if got perform year end before--->
<cftry>
    <cfquery name="checkYearEndRecord" datasource="#dts#">
        SELECT lastaccdate 
        FROM icitem_last_year 
        LIMIT 1;
    </cfquery>
    
    <cfquery name="getgeneral" datasource="#dts#">
        SELECT lastaccyear 
        FROM gsetup
    </cfquery>
    
    <cfquery name="getprevlastaccyear" datasource="#dts#">
        SELECT LastAccDate,ThisAccDate 
        FROM icitem_last_year 
        GROUP BY LastAccDate,ThisAccDate 
        ORDER BY LastAccDate desc
    </cfquery>
    
    
    <body>
    <h1 align="center">
    <cfif hcomid eq "pnp_i">View Stock Card Details<cfelse>View Stock Card Report</cfif>
    </h1>
    <form name="itemform" action="stockcard.cfm" method="post">
    <table border="0" align="center" width="65%" class="data">
        <tr>
            <th width="20%">Transaction Range</th>
            <td width="*">&nbsp;
                <cfoutput>
                <select name="lastaccdaterange">
                    <option value="">#dateformat(getgeneral.lastaccyear,"dd/mm/yyy")# - #dateformat(now(),"dd/mm/yyy")#</option>
                    <cfloop query="getprevlastaccyear">
                    <option value="#getprevlastaccyear.LastAccDate#">#dateformat(getprevlastaccyear.LastAccDate,"dd/mm/yyy")# - #dateformat(getprevlastaccyear.ThisAccDate,"dd/mm/yyy")#</option>
                    </cfloop>
                </select>
                </cfoutput>
                &nbsp;&nbsp;<input type="submit" value="Submit">
            </td>
        </tr>
    </table>
    </form>
    </body>
    </html>
    <cfcatch type="any">
        <cfoutput>
            <script language="javascript">
                window.location = "stockcard.cfm"
            </script>
        </cfoutput>
    </cfcatch>    
</cftry>    