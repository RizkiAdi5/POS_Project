<cfif IsDefined('form.batchp1')>
    <cfquery name="updaterec" datasource="#dts#">
    	UPDATE stockbatches 
        SET
    		<cfloop index="i" from="1" to="18">
    			p#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.batchp#i#')#">
				<cfif i neq 18>,</cfif>
    		</cfloop>
    </cfquery>
</cfif>

<cfquery name="getAccNo" datasource="#replace(LCASE(dts),'_i','_a')#">
    SELECT "" as recno, "Choose a Batch" AS desp
    UNION ALL
    SELECT recno,CONCAT(recno, ' - ', desp) AS desp 
    FROM glbatch;
</cfquery>

<cfquery name="getBatches" datasource="#dts#">
    SELECT * 
    FROM stockbatches;
</cfquery>
        
<cfset pageTitle="Present Stock Batches">



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
</head>

<body class="container">
<cfoutput>
    <form id="stockBatchesForm" name"stockBatchesForm" class="formContainer form2Button" action="" method="post">
        <div>#pageTitle#</div>
        <div>
            <table>
            	<cfloop index="i" from="1" to="18">
                    <tr>
                        <th><label for="period#i#">Period #i#</label></th>
                        <td>
                        	<select id="batchp#i#" name="batchp#i#" selected="#evaluate('getBatches.p#i#')#">
                                <cfloop query="getAccNo">
                                    <option value="#ToString(getaccno.recno)#" <cfif evaluate('getBatches.p#i#') EQ ToString(getaccno.recno)>selected</cfif>>#ToString(getAccNo.desp)#</option>
                                </cfloop>
                            </select>   
                        </td>
                    </tr>
                </cfloop>    
            </table>
        </div>
        <div>
            <input type="submit" value="Submit" />
            <input type="button" value="Cancel" onclick="window.location='/latest/body/bodymenu.cfm?id=60100'" />
        </div>
    </form>
</cfoutput>
</body>
</html>