<!--- 
    Step 1 verification — confirms customer route guard is working.
    Delete this file after confirming.
--->
<cfinclude template="../../application.cfm">
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Customer Route Test</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 40px; background: #f0fdf4; }
        .box { background: #fff; border: 2px solid #86efac; border-radius: 10px; padding: 30px; max-width: 500px; margin: auto; }
        h2 { color: #16a34a; margin: 0 0 16px; }
        table { border-collapse: collapse; width: 100%; margin-top: 16px; }
        td { padding: 6px 10px; border-bottom: 1px solid #e5e7eb; font-size: 14px; }
        td:first-child { color: #6b7280; width: 200px; }
        .ok { color: #16a34a; font-weight: bold; }
    </style>
</head>
<body>
<div class="box">
    <h2>&#10003; Customer route guard is working</h2>
    <p>You reached this page without staff login. The guard is correctly bypassing the staff auth block.</p>
    <table>
        <tr><td>REQUEST.isCustomerRoute</td><td class="ok"><cfoutput>#REQUEST.isCustomerRoute#</cfoutput></td></tr>
        <tr><td>dts (datasource)</td><td><cfoutput>#dts#</cfoutput></td></tr>
        <tr><td>SESSION.emenu_loggedin</td><td><cfoutput>#SESSION.emenu_loggedin#</cfoutput></td></tr>
        <tr><td>SESSION.emenu_custno</td><td><cfoutput>#SESSION.emenu_custno#</cfoutput></td></tr>
        <tr><td>SESSION.emenu_table_id</td><td><cfoutput>#SESSION.emenu_table_id#</cfoutput></td></tr>
        <tr><td>CGI.SCRIPT_NAME</td><td><cfoutput>#CGI.SCRIPT_NAME#</cfoutput></td></tr>
    </table>
</div>
</body>
</html>
