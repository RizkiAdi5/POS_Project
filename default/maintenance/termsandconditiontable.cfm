<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">

<html>
<head>
<title>Terms and Condition Maintenance</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfif isdefined("url.type")>
	<cfquery datasource="#dts#" name="checkgetictermandcondition">
    select * from ictermandcondition;
    </cfquery>
	<cfif checkgetictermandcondition.recordcount eq 0>
    <cfquery datasource="#dts#" name="Savegetictermandcondition">
		insert into ictermandcondition (lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM,lVOUC) values 
        (<cfqueryparam cfsqltype="cf_sql_char" value="#form.lRC#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lPR#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lDO#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lINV#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lCS#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lCN#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lDN#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lPO#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lQUO#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lSO#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lSAM#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#form.lVOUC#">)
	</cfquery>
    <cfelse>
	<cfquery datasource="#dts#" name="Savegetictermandcondition">
		update ictermandcondition set 
        lRC=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lRC#">,
        lPR=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lPR#">,
        lDO=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lDO#">,
        lINV=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lINV#">,
        lCS=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lCS#">,
        lCN=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lCN#">,
        lDN=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lDN#">,
        lPO=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lPO#">,
        lQUO=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lQUO#">,
        lSO=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lSO#">,
        lSAM=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lSAM#">,
        lVOUC=<cfqueryparam cfsqltype="cf_sql_char" value="#form.lVOUC#">
	</cfquery>
    </cfif>
</cfif>

<cfquery name="getictermandcondition" datasource="#dts#">
	select * 
	from ictermandcondition;
</cfquery>

<cfset lRC = getictermandcondition.lRC>
<cfset lPR = getictermandcondition.lPR>
<cfset lDO = getictermandcondition.lDO>
<cfset lINV = getictermandcondition.lINV>
<cfset lCS = getictermandcondition.lCS>
<cfset lCN = getictermandcondition.lCN>
<cfset lDN = getictermandcondition.lDN>
<cfset lPO = getictermandcondition.lPO>
<cfset lQUO = getictermandcondition.lQUO>
<cfset lSO = getictermandcondition.lSO>
<cfset lSAM = getictermandcondition.lSAM>
<cfset lVOUC = getictermandcondition.lVOUC>

<body>

<h1>Terms and Condition Maintenance </h1>
<cfoutput>
<cfform action="termsandconditiontable.cfm?type=save" method="post">
	<table width="500" align="center" class="data" cellspacing="0">
		<tr> 
      		<td colspan="2"><div align="center"><strong>Maintenance</strong></div></td>
    	</tr>
        <tr> 
		  	<th>Purchase Receive</th>
		  	<td><textarea name="lRC" id="lRC" cols="100" rows="5">#convertquote(lRC)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Purchase Return</th>
		  	<td><textarea name="lPR" id="lPR" cols="100" rows="5">#convertquote(lPR)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Delivery Order</th>
		  	<td><textarea name="lDO" id="lDO" cols="100" rows="5">#convertquote(lDO)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Invoice</th>
		  	<td><textarea name="lINV" id="lINV" cols="100" rows="5">#convertquote(lINV)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Cash Sales</th>
		  	<td><textarea name="lCS" id="lCS" cols="100" rows="5">#convertquote(lCS)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Credit Note</th>
		  	<td><textarea name="lCN" id="lCN" cols="100" rows="5">#convertquote(lCN)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Debit Note</th>
		  	<td><textarea name="lDN" id="lDN" cols="100" rows="5">#convertquote(lDN)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Purchase Order</th>
		  	<td><textarea name="lPO" id="lPO" cols="100" rows="5">#convertquote(lPO)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Quotation</th>
		  	<td><textarea name="lQUO" id="lQUO" cols="100" rows="5">#convertquote(lQUO)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Sales Order</th>
		  	<td><textarea name="lSO" id="lSO" cols="100" rows="5">#convertquote(lSO)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Sample</th>
		  	<td><textarea name="lSAM" id="lSAM" cols="100" rows="5">#convertquote(lSAM)#</textarea></td>
		</tr>
        <tr> 
		  	<th>Voucher</th>
		  	<td><textarea name="lVOUC" id="lVOUC" cols="100" rows="5">#convertquote(lVOUC)#</textarea></td>
		</tr>

		<tr> 
		  	<td colspan="2" align="center">
				<input name="submit" type="submit" value="Save">
			  	<input name="reset" type="reset" value="Reset">
			</td>
		</tr>
	</table>
</cfform>
</cfoutput>
</body>
</html>