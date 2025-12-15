<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Tax Maintenance - Generate Tax Code</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../../stylesheet/stylesheet.css">
</head>
<h1 align="center">GENERATE TAX CODE</h1>
<cfif Hlinkams eq "Y">
			<cfquery name="getdata" datasource="#replacenocase(dts,'_i','_a','all')#">
	select distinct accno from gldata order by accno
</cfquery>
</cfif>

<form action="tax.cfm" method="post">
<cfoutput>
<table width="70%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th width="8%">Select</th>
		<th width="10%">Tax Code</th>
		<th width="40%">Description</th>
		<th width="8%">Tax Rate</th>
		<th width="10%">Tax Type</th>
		<th width="10%">Tax Type2</th>
		<th width="14%">Correspondent Accno</th>
	</tr>
	
	<cfloop index="looptype" list="TX,IM,ME,BL,NR,ZP,EP,OP,TX-E33,TX-N33,TX-RE,SR,ZR,ES33,ESN33,DS,OS" delimiters=",">
		<cfquery name="gettaxcode" datasource="main">
			select * from taxcode where code='#looptype#' and length(type) >= 2
		</cfquery>
		<cfquery name="checkcode" datasource="#dts#">
			select * from taxtable where code='#looptype#' and tax_type="#gettaxcode.type#" and tax_type2="gettaxcode.type2"
		</cfquery>
		
		<cfloop query="gettaxcode">
	<tr>
		<td>
			<input type="checkbox" name="gsttax" id="gsttax" value="#gettaxcode.code#"
				<cfif checkcode.recordcount neq 0>disabled="disabled"><cfelse>checked="checked"</cfif>></td>
		<td>#gettaxcode.code#</td>
		<td>
			<input type="text" name="desp#gettaxcode.code#" id="desp#gettaxcode.code#" value="#gettaxcode.desp#" size="50" readonly>
		</td>
		<td>
			<input type="text" name="rate#gettaxcode.code#" id="rate#gettaxcode.code#" value="#gettaxcode.rate1#" size="8" readonly>
		</td>
		<td>
			<input type="text" name="type#gettaxcode.code#" id="type#gettaxcode.code#" value="#gettaxcode.type#" size="8" readonly>
		</td>
		<td>
			<input type="text" name="type2#gettaxcode.code#" id="type2#gettaxcode.code#" value="#gettaxcode.type2#" size="8" readonly>
		</td>
		<td>
        <cfif Hlinkams eq "Y">
			<select name="corr_accno#gettaxcode.code#">
				<option value="">--</option>
          		<cfoutput><cfloop query="getdata">
            	<option value="#accno#">#accno#</option>
          		</cfloop></cfoutput>
      		</select>
            <cfelse>
            <input type="text" name="corr_accno#gettaxcode.code#" value="">
            </cfif>
		</td>
	</tr>
		</cfloop>
	</cfloop>
</table>
<table width="70%" align="center">
	<tr><td>* If the tax code existed in database, the select checkbox will be disabled.</td></tr>
	<tr><td align="center">
		<input type="submit" name="submit" value="Submit">&nbsp;
		<input type="submit" name="cancel" value="Cancel">
	</td></tr>
</table>
</cfoutput>
</form>
</body>
</html>
