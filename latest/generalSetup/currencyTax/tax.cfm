<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1902, 1903, 1904, 56, 57, 65, 1900, 877, 1905, 1906, 1901, 1907">
<cfinclude template="/latest/words.cfm">

<cfif IsDefined('url.entryno')>
	<cfset URLtax = trim(urldecode(url.entryno))>
</cfif>

<cfquery name="getgsetup" datasource="#dts#">
	SELECT ctycode,bcurr 
    FROM gsetup;
</cfquery>
<cfif hlinkams EQ "Y">	
    <cfquery name="getGLDATA" datasource="#replacenocase(dts,'_i','_a','all')#">
        SELECT distinct accno,desp,desp2 
        FROM gldata 
        WHERE id="3"
        AND ((substring(sa,1,2) = "ST" OR substring(sa,3,2) = "ST" OR substring(sa,5,2) = "ST" OR substring(sa,7,2) = "ST") 
        OR (substring(sa,1,2) = "PT" OR substring(sa,3,2) = "PT" OR substring(sa,5,2) = "PT" OR substring(sa,7,2) = "PT"))
        ORDER BY accno;
    </cfquery>
</cfif>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[1902]#">
		<cfset pageAction="Create">
        <cfset entryNo = "">
		<cfset taxCode = "">
        <cfset desp = "">
        <cfset rate1 = "">
        <cfset taxType = "">
        <cfset taxType2 = "">
        <cfset customerNo = "">
        
		<cfquery name="getTax" datasource="main">
			SELECT *,type as tax_type,type2 as tax_type2
			FROM taxcode
            WHERE currcode="#getgsetup.ctycode#"
			ORDER BY tax_code_id
		</cfquery>

	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[1903]#">
		<cfset pageAction="Update">
		<cfquery name="getTax" datasource="#dts#">
			SELECT *
			FROM #target_taxtable#
			WHERE entryno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLtax#">  
		</cfquery>
		<cfset entryNo = getTax.entryno>
        <cfset taxCode = getTax.code>
		<cfset desp = getTax.desp>
		<cfset rate1 = getTax.rate1>
		<cfset taxType = getTax.tax_type>
        <cfset taxType2 = getTax.tax_type2>
		<cfset customerNo = getTax.corr_accno> 
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="#words[1904]#">
		<cfset pageAction="Delete">   
        
        <cfquery name="getTax" datasource="#dts#">
			SELECT * 
			FROM #target_taxtable#
			WHERE entryNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLtax#"> 
		</cfquery>
		<cfset entryNo = getTax.entryno>
        <cfset taxCode = getTax.code>
		<cfset desp = getTax.desp>
		<cfset rate1 = getTax.rate1>
		<cfset taxType = getTax.tax_type>
        <cfset taxType2 = getTax.tax_type2>
		<cfset customerNo = getTax.corr_accno> 
	</cfif> 
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>
    <title>#pageTitle#</title>
    </cfoutput>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <!---<link rel="stylesheet" href="/latest/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />--->
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    <!---<script type="text/javascript" src="/latest/js/jqueryui/jquery-ui-1.10.3.custom.min.js"></script>--->
    <!---<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js" type="text/javascript"></script>--->
    <script src="/latest/js/priceFormat/jquery.maskMoney.js" type="text/javascript"></script>
    
    <script type="text/javascript">
	
		function updateDisplay(){
			
			document.getElementById('desp').value=document.taxForm.taxCode.options[document.taxForm.taxCode.selectedIndex].id.split('|')[0];
			document.getElementById('rate1').value=document.taxForm.taxCode.options[document.taxForm.taxCode.selectedIndex].id.split('|')[1];
			document.getElementById('taxType').value=document.taxForm.taxCode.options[document.taxForm.taxCode.selectedIndex].title.split('|')[0];
			document.getElementById('taxType2').value=document.taxForm.taxCode.options[document.taxForm.taxCode.selectedIndex].title.split('|')[1];
			
		}
		$(function () {
			$('#rate1').maskMoney({
				allowNegative:false, 	// Prevent users from inputing negative values
				defaultZero:false,  	// when the user enters the field, it sets a default mask using zero
				decimal: '.' , 			// The decimal separator
				precision: 0, 			// How many decimal places are allowed
				affixesStay : true,		// set if the symbol will stay in the field after the user exits the field. 
				suffix :' %' 			// set % symbol on the right hand side of the value
			}); 
					
		})
	</script>
</head>

<body class="container">
<cfoutput>
    <form class="formContainer form2Button" name="taxForm" id="taxForm" action="/latest/generalSetup/currencyTax/taxProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('taxCode').disabled=false;document.getElementById('taxType').disabled=false;document.getElementById('taxType2').disabled=false;">
        <div>#pageTitle#</div>
        <div>
            <table>
            	 <input type="hidden" id="entryNo" name="entryNo" value="#entryNo#" />
                 <input type="hidden" name="currcode" id="currcode" value="#getgsetup.ctycode#" readonly>
                <tr>
                    <th><label for="taxCodeLabel">#words[56]#</label></th>
                    <td>
                        <select name="taxCode" id="taxCode" onchange="updateDisplay()" required="yes" <cfif IsDefined("url.action") AND url.action NEQ "create">disabled="true"</cfif>>
                        	<option title="" value="">#words[57]#</option>
                            <cfloop query="getTax">
								<option id="#getTax.desp#|#val(getTax.rate1)*100# %" title="#getTax.tax_type#|#getTax.tax_type2#" 
                                	value="#getTax.code#" <cfif getTax.code eq taxCode> selected </cfif>>#getTax.code#</option>
                            </cfloop>
                        </select>	
                    </td>
                </tr>
                <tr>
                    <th><label for="despLabel">#words[65]#</label></th>
                    <td>
                        <textarea rows="2" cols="45" id="desp" name="desp" >#desp#</textarea>                   
                    </td>
                </tr> 
                <tr>
                    <th><label for="rate1Label">#words[1900]#</label></th>
                    <td>
                    	<cfset ratePercentage = val(rate1)*100>
                        <input type="text" id="rate1" name="rate1" value="#ratePercentage# %"/>                   
                    </td>
                </tr> 
                <tr>
                    <th><label for="typeLabel">#words[877]#</label></th>
                    <td> 
                        <cfif hlinkams eq "Y">
                            <select name="taxType" id="taxType" disabled="true">
                                <option value="">#words[1905]#</option>
                                <cfloop query="getTax">
                                    <option value="#getTax.tax_type#" <cfif getTax.tax_type EQ taxType>selected</cfif>>#getTax.tax_type#</option>
                                </cfloop>
                            </select> 
                        <cfelse>  
                         	<input type="text" id="taxType" name="taxType" value="#taxType#"/> 
                         </cfif>                 
                    </td>
                </tr> 
                <tr>
                    <th><label for="type2Label">#words[1906]#</label></th>
                    <td>
                        <input type="text" id="taxType2" name="taxType2" value="#taxType2#" disabled="true" maxlength="12"/>                   
                    </td>
                </tr> 
				<tr>
					<th><label for="customerLabel">#words[1901]#</label></th> 
                    <td>
                    	<cfif hlinkams eq "Y">			
                            <select name="customerNo" id="customerNo">
                                <option value="">#words[1907]#</option>
                                <cfloop query="getGLDATA">
                                    <option value="#getGLDATA.accno#" <cfif getGLDATA.accno EQ customerNo>selected</cfif>>#getGLDATA.accno# - #getGLDATA.desp# #getGLDATA.desp2#</option>
                                </cfloop>
                            </select>
						<cfelse>  
                         	<input type="text" id="customerNo" name="customerNo" value="#customerNo#" /> 
                         </cfif>   
                    </td>
                </tr> 
            </table>
        </div>
        <div>
            <input type="submit" value="#pageAction#" />
            <input type="button" value="Cancel" onclick="window.location='/latest/generalSetup/currencyTax/taxProfile.cfm'" />
        </div>
    </form>
</cfoutput>
</body>
</html>