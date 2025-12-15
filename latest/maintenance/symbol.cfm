
<cfquery name="getSymbol" datasource='#dts#'>
    SELECT * 
    FROM symbol;
</cfquery>

<cfloop index="i" from="1" to="20">
    <cfset 'symbol#i#' = evaluate('getSymbol.symbol#i#')>
</cfloop>  
<cfset symbolValue ="">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Symbol Profile</title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    
    <script type="text/javascript">
		
		function getSymbol(val){
			var textField = document.getElementById('selectedField').value;
			document.getElementById(textField).value = val;	
		}
		
		function getFocus(symbol){
			document.getElementById('selectedField').value = symbol;	
		}
		
	</script>
</head>

<body class="container">
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/symbolProcess.cfm?action=update" method="post">
	<div>Symbol Profile</div>
	<div>
    	<input type="hidden" id="selectedField" name="selectedField" value="" />
		<table>
        <tr>
            <th></th>
            <td></td>
            <td rowspan="21">
            	<cfloop index="i" list="188,189,8531,8532,8533,8534,8535,8536,8537,8538">
                	<input type="button" value="#chr(i)#" onClick="getSymbol('#chr(i)#')" style="width:60px; height: 60px; font-size:20px;"/>
                </cfloop>
                
            	<cfloop index="i" list="8539,8540,8541,8542,190,216,181,176,187,8364">
                	<input type="button" value="#chr(i)#" onClick="getSymbol('#chr(i)#')" style="width:60px; height: 60px; font-size:20px;"/>
                </cfloop>
                
                <cfloop index="i" list="163,165,169,171,187,174,215,247,178,179">
                	<input type="button" value="#chr(i)#" onClick="getSymbol('#chr(i)#')" style="width:60px; height: 60px; font-size:20px;"/>
                </cfloop>
                
                <cfloop index="i" list="8451,177,9651,9671,9711,9712,9734,164">
                	<input type="button" value="#chr(i)#" onClick="getSymbol('#chr(i)#')" style="width:60px; height: 60px; font-size:20px;"/>
                </cfloop>
            </td>
        </tr>
        	<cfloop index="i" from="1" to="20">
				<cfif i%2 eq 1>
					<tr>
				</cfif>
                        <th><label for="symbol#i#">Symbol #i#</label></th>
                        <td>
                            <cfset symbolValue = evaluate('symbol#i#')>
                            <input type="text" id="symbol#i#" name="symbol#i#" value="#toString(BINARYDECODE(symbolValue,'BASE64'))#" onFocus="getFocus('symbol#i#')" maxlength="3"/>
                        </td>
                <cfif i%2 eq 0>
					</tr>
             	</cfif>
				<cfset i = i+1>
            </cfloop>
		</table>
	</div>
	<div>
		<input type="submit" value="Save" />
	</div>
</form>
</cfoutput>
</body>
</html>