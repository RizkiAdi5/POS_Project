<cfquery name="getgeneral" datasource="#dts#">
	select invno,invno_2,invno_3,invno_4,invno_5,invno_6,refno2#tran# as refno2valid from gsetup
</cfquery>

<html>
<head>
	<title>Transaction 0</title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<!--- ADD ON 200608 --->
<!--- <cfquery name="getRefnoset" datasource="main">
	select * from refnoset
	where userDept = '#dts#'
	and type = '#tran#'
	order by counter
</cfquery> --->

<cfquery name="getRefnoset" datasource="#dts#">
	select * from refnoset
	where type = '#tran#'
	order by counter
</cfquery>

<cfif lcase(hcomid) eq "solidlogic_i" and tran eq "INV">
	<cfset defaultset="2">
<cfelse>
	<cfset defaultset="1">
</cfif>

<cfif tran eq "INV">
	<cfset refnoname = "Invoice">
<cfelseif tran eq "RC">
	<cfset refnoname = "Purchase Receive">
<cfelseif tran eq "PR">
	<cfset refnoname = "Purchase Return">
<cfelseif tran eq "DO">
	<cfset refnoname = "Delivery Order">
<cfelseif tran eq "CS">
	<cfset refnoname = "Cash Sales">
<cfelseif tran eq "CN">
	<cfset refnoname = "Credit Note">
<cfelseif tran eq "DN">
	<cfset refnoname = "Debit Note">
<cfelseif tran eq "ISS">
	<cfset refnoname = "Issue">
<cfelseif tran eq "PO">
	<cfset refnoname = "Purchase Order">
<cfelseif tran eq "SO">
	<cfset refnoname = "Sales Order">
<cfelseif tran eq "QUO">
	<cfset refnoname = "Quotation">
<cfelseif tran eq "ASSM">
	<cfset refnoname = "Assembly">
<cfelseif tran eq "TR">
	<cfset refnoname = "Transfer">
<cfelseif tran eq "OAI">
	<cfset refnoname = "Adjustment Increase">
<cfelseif tran eq "OAR">
	<cfset refnoname = "Adjustment Reduce">
<cfelseif tran eq "SAM">
	<cfset refnoname = "Sample">
</cfif>
<body>
<cfform name="form1" action="transaction1.cfm?ttype=create&nexttranno=&tran=#tran#&first=0" method="post">
	<h2>Please choose 1 set of <cfoutput>#refnoname#</cfoutput> number to continue:</h2>

	<table width="40%" class="data" cellpadding="3" align="center">
	<tr>
		<th><cfoutput>#refnoname#</cfoutput> No</th>
		<th>Selection</th>
	</tr>
  	<cfoutput>
	<cfloop query="getRefnoset">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      		<td>
			<cfif lcase(hcomid) eq "kjcpl_i">
			<cfif tran eq 'INV'>
            <cfif getRefnoset.counter eq '1'>
            Invoice-B
            <cfelseif getRefnoset.counter eq '2'>
            Invoice-G
            <cfelseif getRefnoset.counter eq '3'>
            Invoice-S
            <cfelseif getRefnoset.counter eq '4'>
            Invoice-A
            <cfelseif getRefnoset.counter eq '5'>
            Invoice-M
            <cfelse>
            Set #getRefnoset.counter#
            </cfif>
			</cfif>
            <cfif tran eq 'DO'>
            <cfif getRefnoset.counter eq '1'>
            Delivery Order-M
            <cfelse>
            Set #getRefnoset.counter#
            </cfif>
			</cfif>
            <cfelseif lcase(hcomid) eq "mlpl_i">
            <cfif tran eq 'INV'>
            <cfif getRefnoset.counter eq '1'>
            Invoice-C
            <cfelseif getRefnoset.counter eq '2'>
            Invoice-P
            <cfelseif getRefnoset.counter eq '3'>
            Invoice-M
            <cfelse>
            Set #getRefnoset.counter#
            </cfif>
			</cfif>
			<cfelse>Set #getRefnoset.counter#</cfif> - <cfif getRefnoset.refnocode neq '' and getRefnoset.presuffixuse eq '1'>#getRefnoset.refnocode#</cfif>#getRefnoset.lastUsedNo#<cfif getRefnoset.refnocode2 neq '' and getRefnoset.presuffixuse eq '1'>#getRefnoset.refnocode2#</cfif></td>
    		<td align="center"><input name="invset" type="radio" value="#getRefnoset.counter#" <cfif getRefnoset.counter eq defaultset>checked</cfif>></td>
		</tr>
	</cfloop>
	<!--- REMARK ON 200608 --->
  	<!---tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      	<td>Set 1 - #getgeneral.invno#</td>
    	<td align="center"><input name="invset" type="radio" value="invno" checked></td>
	</tr>
  	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    	<td>Set 2 - #getgeneral.invno_2#</td>
    	<td align="center"><input name="invset" type="radio" value="invno_2"></td>
   </tr>
  	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    	<td>Set 3 - #getgeneral.invno_3#</td>
    	<td align="center"><input name="invset" type="radio" value="invno_3"></td>
  	</tr>
  	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    	<td>Set 4 - #getgeneral.invno_4#</td>
    	<td align="center"><input name="invset" type="radio" value="invno_4"></td>
  	</tr>
  	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    	<td>Set 5 - #getgeneral.invno_5#</td>
    	<td align="center"><input name="invset" type="radio" value="invno_5"></td>
 	</tr>
  	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    	<td>Set 6 - #getgeneral.invno_6#</td>
    	<td align="center"><input name="invset" type="radio" value="invno_6"></td>
  	</tr--->
<cfif getgeneral.refno2valid eq "1">
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<th>Refno 2</th>
<td></td>
</tr>
	<cfloop query="getRefnoset">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
      		<td>Set #getRefnoset.counter# - #getRefnoset.lastUsedNo#</td>
    		<td align="center"><input name="invset2" type="radio" value="#getRefnoset.counter#" <cfif getRefnoset.counter eq defaultset>checked</cfif>></td>
		</tr>
	</cfloop>
</cfif>
  	<tr>
    	<td></td>
    	<td align="center"><input type="submit" name="submit" value="submit"></td>
  	</tr>
  	</cfoutput>
</table>

</cfform>

</body>
</html>