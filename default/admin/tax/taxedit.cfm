<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Tax Maintenance - Edit</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../../stylesheet/stylesheet.css">
</head>

<script language="javascript">
function percentage()
{
	var taxrate = document.taxedit.rate1.value;
	var taxperc = taxrate * 100;
	document.taxedit.percent.value = taxperc;
}
</script>

<cfset checksametaxcorr.recordcount = 0>

<cfif isdefined("form.submit")>
	<cfquery name="checksametaxcorr" datasource="#dts#">
		SELECT tax_type,corr_accno FROM #target_taxtable#
		WHERE corr_accno = '#form.corr_accno#' and tax_type ='#form.taxtype#'       
	</cfquery>
     
	<!--- <cfquery name="updatetax" datasource="#dts#">
		UPDATE #target_taxtable#
		SET desp='#form.desp#', rate1='#form.rate1#', tax_type='#form.taxtype#', corr_accno='#form.corr_accno#'
		WHERE entryno='#form.taxentry#'
	</cfquery> --->
	<cfif hlinkams eq "Y">
		<cfquery name="updatetax" datasource="#replace(dts,'_i','_a','all')#">
			UPDATE taxtable
			SET desp='#form.desp#', rate1='#form.rate1#', tax_type='#form.taxtype#', corr_accno='#form.corr_accno#'
			WHERE entryno='#form.taxentry#'
		</cfquery>
	<cfelse>
		<cfquery name="updatetax" datasource="#dts#">
			UPDATE taxtable
			SET desp='#form.desp#', rate1='#form.rate1#', tax_type='#form.taxtype#', corr_accno='#form.corr_accno#'
			WHERE entryno='#form.taxentry#'
		</cfquery>
	</cfif>
</cfif>
  
<cfquery name="getedittax" datasource="#dts#">
	SELECT entryno,code,desp,rate1,tax_type,corr_accno FROM #target_taxtable#
	WHERE entryno = <cfif isdefined("form.submit")>'#form.taxentry#'<cfelse>'#url.taxentry#'</cfif>
</cfquery>

<cfset taxentry = getedittax.entryno>
<cfset code = getedittax.code>
<cfset desp = getedittax.desp>
<cfset rate1 = getedittax.rate1>
<cfset tax_type = getedittax.tax_type>
<cfset corr_accno = getedittax.corr_accno>

<body>

<h1 align="center">EDIT TAX</h1>
<cfoutput>

<cfif isdefined("form.submit")>
** Tax code edited. Click on Close Window to return to tax maintenance page **
</cfif>
<cfquery name="gettax" datasource="main">
	select * from taxcode
</cfquery>

<cfform name="taxedit" action="taxedit.cfm" method="post">
  <input type="hidden" name="taxentry" value="#taxentry#">
  <table width="50%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
    <tr>
		<td width="50%">TAX CODE</td>
		<td>#code#</td><input type="hidden" name="code" value="#code#">
    </tr>
	<tr>
		<td>DESCRIPTION</td>
		<td><input name="desp" type="text" value="#desp#" size="50"></td>
	</tr>
	<tr>
		<td>TAX RATE</td> <cfset percentvalue = getedittax.rate1 * 100>
		<td><cfinput name="rate1" value="#rate1#" validate="float" onChange="percentage();"> 
		<input type="text" name="percent" id="percent" style="background-color:##FFFFCC; text-align:right;" size="3" value="#percentvalue#" disabled>%</td>
	</tr>
	<tr>
		<td>TAX TYPE</td>
		<td><input type="text" name="taxtype" value="#tax_type#" readonly="true"> <!--- <select name="taxtype">
                                <option value=""></option> 
	  						<cfif isdefined("url.taxentry") or isdefined("form.taxentry")>						
							<option value="ST" <cfif '#tax_type#' eq 'ST'>selected</cfif>>ST - Sales Tax</option>
						    <option value="PT" <cfif '#tax_type#' eq 'PT'>selected</cfif>>PT - Purchase Tax</option>		
       						<option value="T" <cfif '#tax_type#' eq 'T'>selected</cfif>>T - Other Types</option>	 
       					    <option value="TP" <cfif '#tax_type#' eq 'TP'>selected</cfif>>TP - Purchase Tax (Reversed - Purchase Return)</option>	
							<cfelse>					 
        					<option value="ST">ST - Sales Tax</option>
							<option value="PT">PT - Purchase Tax</option>		
        					<option value="T">T - Other Types</option>						      	 
        					<option value="TP">TP - Purchase Tax (Reversed - Purchase Return)</option>	
				      	 </cfif>
							    </select> --->
        
	</tr>
	<tr>
		<td>CORRESPONDING ACCNO</td>
		<cfif Hlinkams eq "Y">
			<cfquery name="getdata" datasource="#replacenocase(dts,'_i','_a','all')#">
				select distinct accno from gldata order by accno
			</cfquery>
			<td>
				<select name="corr_accno">
					<option value="">Choose an A/C No.</option>
	          		<cfloop query="getdata">
	            		<option value="#getdata.accno#" <cfif corr_accno eq getdata.accno>selected</cfif>>#getdata.accno#</option>
	          		</cfloop>
	      		</select>
			</td>
		<cfelse>
			<td>
				<input type="text" name="corr_accno" value="#corr_accno#">
			</td>
		</cfif>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
			<input type="button" name="close" value="Close Window" onClick="opener.location.reload(true);window.close();"> 
			<input type="submit" name="submit" value="Edit & Save">
		</td>
	</tr>
  </table>
</cfform>
</cfoutput>
</body>
</html>
