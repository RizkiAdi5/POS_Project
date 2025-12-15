<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Tax Maintenance - Create NEW</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" href="../../../stylesheet/stylesheet.css">
</head>
<script language="javascript" type="text/javascript" src="../../../scripts/ajax.js"></script>

<script language="javascript">
function percentage()
{
	var taxrate = document.taxnew.rate1.value;
	var taxperc = taxrate * 100;
	document.taxnew.percent.value = taxperc;
}

function validation(){
	document.taxnew.submit();
}
</script>

<cfif isdefined("url.type")>
    <cfquery name="checkcode" datasource="#dts#">
		select * from #target_taxtable# where code='#form.code#'
	</cfquery>
	<cfif checkcode.recordcount eq 0>
		<cfif hlinkams eq "Y">
			<cfquery name="inserttax" datasource="#replace(dts,'_i','_a','all')#">
				INSERT INTO taxtable
				SET code='#form.code#',desp='#form.desp#', rate1='#val(form.rate1)#', tax_type='#form.taxtype#', corr_accno='#form.corr_accno#',tax_type2='#form.taxtype2#'
			</cfquery>
		<cfelse>
			<cfquery name="inserttax" datasource="#dts#">
				INSERT INTO taxtable
				SET code='#form.code#',desp='#form.desp#', rate1='#val(form.rate1)#', tax_type='#form.taxtype#', corr_accno='#form.corr_accno#',tax_type2='#form.taxtype2#'
			</cfquery>
		</cfif>
    </cfif>
</cfif>


<body>
<h1 align="center">EDIT TAX</h1>

<cfif isdefined("url.type")>
	<cfif checkcode.recordcount eq 0>
		** Tax code added. Click on Close Window to return to tax maintenance page **
	<cfelse>
		<div align="center"><font color="ff0000">** Tax code exist.Tax code fail to create</font></div>
	</cfif>
</cfif>

<cfoutput>
<cfquery name="gettax" datasource="main">
	select * from taxcode
</cfquery>
<cfform name="taxnew" action="taxnew.cfm?type=create" method="post" >
<table width="50%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<td width="50%">TAX CODE</td>
      	<td>
			<select name="code" onchange="desp.value=this.options[document.taxnew.code.selectedIndex].title;taxtype.value=this.options[document.taxnew.code.selectedIndex].id.split('|')[0];rate1.value=this.options[document.taxnew.code.selectedIndex].id.split('|')[1];ajaxFunction(window.document.getElementById('ajaxTaxField'),'taxajax.cfm?c='+this.options[document.taxnew.code.selectedIndex].value);percentage();">
				<option title="" value=""></option>
				<cfloop query="gettax">
					<option id="#gettax.type#|#gettax.rate1#" title="#gettax.desp#" value="#gettax.code#">#gettax.code#</option>
				</cfloop>
			</select>
		</td>  
	</tr>
	<tr>
		<td>DESCRIPTION</td>
		<td><input name="desp" type="text" size="48"></td>
	</tr>
    <tr>
		<td>TAX RATE</td>
		<td><cfinput name="rate1" validate="float" onchange="percentage();"> 
          <input type="text" name="percent" id="percent" style="background-color:##FFFFFF; text-align:right;" size="3" disabled>%
		</td>
    </tr>
    <tr>
		<td>TAX TYPE</td>
		<td><input type="text" name="taxtype" readonly="true"></td>
    </tr>
    <tr>
    <td>TAX TYPE2</td>
    <td><div  id="ajaxTaxField" name="ajaxTaxField">
    <input name="taxtype2" type="text" value="" maxlength="12" readonly>
    </div></td>
    </tr>
    <tr>
		<td>CORRESPONDENT ACCNO</td>
		<cfif Hlinkams eq "Y">
			<cfquery name="getdata" datasource="#replacenocase(dts,'_i','_a','all')#">
				select distinct accno from gldata order by accno
			</cfquery>
			<td>
				<select name="corr_accno">
					<option value="">Choose an A/C No.</option>
	          		<cfloop query="getdata">
	            		<option value="#accno#">#accno#</option>
	          		</cfloop>
	      		</select>
			</td>
		<cfelse>
			<td>
				<input type="text" name="corr_accno" value="">
			</td>
		</cfif>
    </tr>
    <tr>
		<td colspan="2">&nbsp;</td>
    </tr>
    <tr>
		<td colspan="2" align="center">
			<input type="button" name="close" value="Close Window" onClick="opener.location.reload(true);window.close();">
			<input type="reset">
			<input type="button" name="button" value="Add" onclick="validation();opener.location.reload(true);">
		</td>
	</tr>
</table>
</cfform>
</cfoutput>
</body>
</html>