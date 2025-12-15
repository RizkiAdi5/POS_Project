<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">


<cfquery name="getitem" datasource="#dts#">
	select * from icitem 
	where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#itemno#">
</cfquery>

<cfquery name="getartran" datasource="#dts#">
	select * from artran 
	where type='#type#'
	and refno='#refno#'
</cfquery>

<cfquery name="getsetup" datasource="#dts#">
select auom from gsetup
</cfquery>

<cfif type eq "RC" or type eq "PO" or type eq "PR">
	<cfquery name="getrecommendprice" datasource="#dts#">
		select * from icl3p 
		where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
		and custno='#getartran.custno#'
	</cfquery>

	<cfif getrecommendprice.recordcount gt 0>
		<cfset price = getrecommendprice.price>
	<cfelse>
        <cfif currrate neq 0>
			<cfset price = val(getitem.ucost)/currrate>
		<cfelse>
			<cfset price = val(getitem.ucost)>
		</cfif>
	</cfif>
<cfelse>
	<cfquery name="getrecommendprice" datasource="#dts#">
		select * from icl3p2 
		where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
		and custno='#getartran.custno#'
	</cfquery>

	<cfif getrecommendprice.recordcount gt 0>
		<cfset price = getrecommendprice.price>
	<cfelse>
        <cfif bcurr neq refno3>
			<cfif currrate neq 0>
                <cfset price = getitem.price/currrate>
            <cfelse>
                <cfset price = getitem.price>
            </cfif>
        <cfelse>
            <cfset price = getitem.price>
        </cfif>
	</cfif>
</cfif>

<html>
<head>
	<title>UNIT OF MEASUREMENT</title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		function UpdateUnit(){
			radioObj = document.itemform.unit;
			if(radioObj.value != "1"){
				var radioLength = radioObj.length;
				if(radioLength == "undefined"){
					if(radioObj.checked)
						//alert(radioObj.value);
						var secondunit = "secondunit_" + radioObj.value;
						var factora = "factora_" + radioObj.value;
						var factorb = "factorb_" + radioObj.value;
						var priceu = "priceu_" + radioObj.value;
						opener.document.form1.unit.value = document.getElementById(secondunit).value;
						opener.document.form1.factor1.value = document.getElementById(factora).value;
						opener.document.form1.factor2.value = document.getElementById(factorb).value;
						opener.document.form1.price.value = document.getElementById(priceu).value;
				}
				else{
					for(var i = 0; i < radioLength; i++) {
						if(radioObj[i].checked) {
							//alert(radioObj[i].value);
							var secondunit = "secondunit_" + radioObj[i].value;
							var factora = "factora_" + radioObj[i].value;
							var factorb = "factorb_" + radioObj[i].value;
							var priceu = "priceu_" + radioObj[i].value;
							opener.document.form1.unit.value = document.getElementById(secondunit).value;
							opener.document.form1.factor1.value = document.getElementById(factora).value;
							opener.document.form1.factor2.value = document.getElementById(factorb).value;
							opener.document.form1.price.value = document.getElementById(priceu).value;
						}
					}
				}
			}
			else{
				var secondunit = "secondunit_1";
				var factora = "factora_1";
				var factorb = "factorb_1";
				var priceu = "priceu_1";
				opener.document.form1.unit.value = document.getElementById(secondunit).value;
				opener.document.form1.factor1.value = document.getElementById(factora).value;
				opener.document.form1.factor2.value = document.getElementById(factorb).value;
				opener.document.form1.price.value = document.getElementById(priceu).value;
			}
			opener.checkqty();
			window.close();
		}
		
		function calculatePrice(){
			var price1 = document.itemform.priceu_1.value;
			var factor1 = document.itemform.factora_7.value;
			var factor2 = document.itemform.factorb_7.value;
			if(isNaN(factor1) || isNaN(factor2)){
				document.itemform.priceu_7.value = price1.toFixed(4);
			}
			else{
				if(parseFloat(factor2) != 0){
					document.itemform.priceu_7.value = (parseFloat(price1) * parseFloat(factor1) / parseFloat(factor2)).toFixed(4);
				}
				else{
					document.itemform.priceu_7.value = price1.toFixed(4);
				}
			}
		}
		
		function calculatePrice2(){
			var price1 = document.itemform.priceu_1.value;
			var factor1 = document.itemform.factora_8.value;
			var factor2 = document.itemform.factorb_8.value;
			if(isNaN(factor1) || isNaN(factor2)){
				document.itemform.priceu_8.value = price1.toFixed(4);
			}
			else{
				if(parseFloat(factor2) != 0){
					document.itemform.priceu_8.value = (parseFloat(price1) * parseFloat(factor1) / parseFloat(factor2)).toFixed(4);
				}
				else{
					document.itemform.priceu_8.value = price1.toFixed(4);
				}
			}
		}
	</script>
</head>

<body> 
<h1 align="center">Change Unit</h1>
<cfoutput>
<form name="itemform" action="" method="post">
<input type="hidden" name="itemno" value="#convertquote(itemno)#">

<table border="0" align="center" width="400px" cellpadding="0" cellspacing="2">
	<tr>
		<td><input type="radio" name="unit" value="1" checked></td>
		<td>#getitem.unit#</td>
		<td><input type="text" name="factora_1" id="factora_1" value='#numberformat(1,"_.__")#' size="15" readonly></td>
		<td><input type="text" name="factorb_1" id="factorb_1" value='#numberformat(1,"_.__")#' size="15" readonly></td>
		<input type="hidden" name="secondunit_1" id="secondunit_1" value="#getitem.unit#">
		<input type="hidden" name="priceu_1" id="priceu_1" value="#numberformat(price,stDecl_UPrice)#">
	</tr>
	<cfif (getitem.unit2 neq "") or (getitem.unit2 eq "" and val(getitem.factor1) neq 0)>
		<cfif type eq "RC" or type eq "PO" or type eq "PR">
			<cfif val(getitem.factor2) neq 0>
				<cfset Priceu2 = val(price) * val(getitem.factor1) / val(getitem.factor2)>
			<cfelse>
				<cfset Priceu2 = 0>
			</cfif>
		<cfelse>
            <cfif bcurr neq refno3>
				<cfif currrate neq 0>
                	<cfset Priceu2 = getitem.priceu2/currrate>
            	<cfelse>
                	<cfset Priceu2 = getitem.priceu2>
            	</cfif>
        	<cfelse>
            	<cfset Priceu2 = getitem.priceu2>
        	</cfif>
		</cfif>
		<tr>
			<td><input type="radio" name="unit" value="2"></td>
			<td>#getitem.unit2#</td>
			<td><input type="text" name="factora_2" id="factora_2" value='#numberformat(getitem.factor1,"_.__")#' size="15" readonly></td>
			<td><input type="text" name="factorb_2" id="factorb_2" value='#numberformat(getitem.factor2,"_.__")#' size="15" readonly></td>
		</tr>
		<input type="hidden" name="secondunit_2" id="secondunit_2" value="#getitem.unit2#">
		<input type="hidden" name="priceu_2" id="priceu_2" value="#numberformat(Priceu2,stDecl_UPrice)#">
	</cfif>
	<cfloop from="3" to="6" index="i">
		<cfset SecondUnit = Evaluate("getitem.UNIT#i#")>
		<cfset factora = Evaluate("getitem.FACTORU#i#_A")>
		<cfset factorb = Evaluate("getitem.FACTORU#i#_B")>
		<cfif type eq "RC" or type eq "PO" or type eq "PR">
			<cfif val(factorb) neq 0>
				<cfset Price2ndUnit = val(price) * val(factora) / val(factorb)>
			<cfelse>
				<cfset Price2ndUnit = 0>
			</cfif>
		<cfelse>
            <cfif bcurr neq refno3>
				<cfif currrate neq 0>
                	<cfset Price2ndUnit = Evaluate("getitem.PRICEU#i#")/currrate>
            	<cfelse>
                	<cfset Price2ndUnit = Evaluate("getitem.PRICEU#i#")>
            	</cfif>
        	<cfelse>
            	<cfset Price2ndUnit = Evaluate("getitem.PRICEU#i#")>
        	</cfif>
		</cfif>
		
		<cfif (SecondUnit neq "") or (SecondUnit eq "" and val(factora) neq 0)>
			<tr>
				<td><input type="radio" name="unit" value="#i#"></td>
				<td>#SecondUnit#</td>
				<td><input type="text" name="factora_#i#" id="factora_#i#" value='#numberformat(factora,"_.__")#' size="15" readonly></td>
				<td><input type="text" name="factorb_#i#" id="factorb_#i#" value='#numberformat(factorb,"_.__")#' size="15" readonly></td>
			</tr>
			<input type="hidden" name="secondunit_#i#" id="secondunit_#i#" value="#SecondUnit#">
			<input type="hidden" name="priceu_#i#" id="priceu_#i#" value="#numberformat(Price2ndUnit,stDecl_UPrice)#">
		</cfif>
	</cfloop>
	<cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i" or getsetup.auom eq 1>
		<tr>
			<td><input type="radio" name="unit" value="7" onClick="calculatePrice();"></td>
			<td><input type="text" name="secondunit_7" id="secondunit_7" size="10" onBlur="calculatePrice();"></td>
			<td><input type="text" name="factora_7" id="factora_7" value='#numberformat(1,"_.__")#' size="15" onBlur="calculatePrice();"></td>
			<td><input type="text" name="factorb_7" id="factorb_7" value='#numberformat(1,"_.__")#' size="15" onBlur="calculatePrice();"></td>
			<input type="hidden" name="priceu_7" id="priceu_7" value="#numberformat(price,stDecl_UPrice)#">
		</tr>
        
    <tr>
			<td><input type="radio" name="unit" value="8" onClick="calculatePrice2();"></td>
			<td><select name="secondunit_8" id="secondunit_8" onBlur="calculatePrice2();">
            <cfquery name="getunit" datasource="#dts#">
            select unit from unit
            </cfquery>
            <cfloop query="getunit">
            <option value="#getunit.unit#">#getunit.unit#</option>
            </cfloop>
            </select></td>
			<td><input type="text" name="factora_8" id="factora_8" value='#numberformat(1,"_.__")#' size="15" onBlur="calculatePrice2();"></td>
			<td><input type="text" name="factorb_8" id="factorb_8" value='#numberformat(1,"_.__")#' size="15" onBlur="calculatePrice2();"></td>
			<input type="hidden" name="priceu_8" id="priceu_8" value="#numberformat(price,stDecl_UPrice)#">
		</tr>
	</cfif>
    
	<tr><td colspan="100%" align="center" height="10"></td></tr>
	<tr>
		<td colspan="100%" align="center"><input type="button" value="Ok" onClick="UpdateUnit();">		  &nbsp;&nbsp;
		  <input type="button" value="Cancel" onClick="window.close();">		</td>
	</tr>
</table>
</form>
</cfoutput>
</body>
</html>