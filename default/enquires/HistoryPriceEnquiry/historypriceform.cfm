<cfinclude template = "../../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>History Price Enquiry</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type='text/javascript' src='../../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../../ajax/core/settings.js'></script>
<cfparam name="alown" default="0">

	<cfif getpin2.h4700 eq 'T'>
  		<cfset alown = 1>
  	</cfif>
<script type="text/javascript">

// begin: product search
function selectlist(custno,fieldtype){

			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++) 
			{
        	if (custno==document.getElementById(fieldtype).options[idx].value) 
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		} 
			
									}
function getProduct(type){
	if(type == 'itemto'){
		var inputtext = document.historyprice.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
		
	}else{
		var inputtext = document.historyprice.searchitemfr.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult2);
	}
}

function getProductResult(itemArray){
	DWRUtil.removeAllOptions("itemto");
	DWRUtil.addOptions("itemto", itemArray,"KEY", "VALUE");
}

function getProductResult2(itemArray){
	DWRUtil.removeAllOptions("itemfrom");
	DWRUtil.addOptions("itemfrom", itemArray,"KEY", "VALUE");
}
// end: product search

// begin: supplier search
function getSupp(type,option){
	if(type == 'suppfrom'){
		var inputtext = document.historyprice.searchsuppfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult);
		
	}
	else{
		var inputtext = document.historyprice.searchsuppto.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult2);
	}
}

function getSuppResult(suppArray){
	DWRUtil.removeAllOptions("suppfrom");
	DWRUtil.addOptions("suppfrom", suppArray,"KEY", "VALUE");
}

function getSuppResult2(suppArray){
	DWRUtil.removeAllOptions("suppto");
	DWRUtil.addOptions("suppto", suppArray,"KEY", "VALUE");
}
// end: supplier search

// begin: customer search
function getCust(type,option){
	if(type == 'custfrom'){
		var inputtext = document.historyprice.searchcustfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult);
		
	}
	else{
		var inputtext = document.historyprice.searchcustto.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult2);
	}
}

function getCustResult(custArray){
	DWRUtil.removeAllOptions("custfrom");
	DWRUtil.addOptions("custfrom", custArray,"KEY", "VALUE");
}

function getCustResult2(custArray){
	DWRUtil.removeAllOptions("custto");
	DWRUtil.addOptions("custto", custArray,"KEY", "VALUE");
}
// end: customer search
</script>

</head>

<!--- <cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear from gsetup
</cfquery> --->
<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall,lCATEGORY,lAGENT,AGENTLISTUSERID from gsetup
</cfquery>
<!--- Add On 12-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<cfquery name="getcate" datasource="#dts#">
    select * from iccate order by cate
</cfquery>

<cfquery name="getbrand" datasource="#dts#">
    select * from brand order by brand
</cfquery>

<cfset clsyear = year(getgeneral.lastaccyear)>	
<cfset clsmonth = month(getgeneral.lastaccyear)>

<!--- period default --->
<cfset newmonth = clsmonth + 1>	
<cfif newmonth gt 12>
	<cfset newmonth = newmonth - 12>
	<cfset newyear = clsyear + 1>
<cfelse>
	<cfset newyear = clsyear>
</cfif>
<cfset newdate = CreateDate(newyear, newmonth, newmonth)>
<cfset vmonth = dateformat(newdate,"mmm yy")>

<cfset xnewmonth = newmonth + 11>	
<cfif xnewmonth gt 12>
	<cfset xnewmonth = xnewmonth - 12>
	<cfset xnewyear = newyear + 1>
<cfelse>
	<cfset xnewyear = newyear>
</cfif>
<cfset xnewdate = CreateDate(xnewyear, xnewmonth, xnewmonth)>

<cfset vmonthto = dateformat(xnewdate,"mmm yy")>

<!--- period 1 --->

<cfset newmonth1 = clsmonth + 1>	
<cfif newmonth1 gt 12>
	<cfset newmonth1 = newmonth1 - 12>
	<cfset newyear1 = clsyear + 1>
<cfelse>
	<cfset newyear1 = clsyear>
</cfif>
<cfset newdate1 = CreateDate(newyear1, newmonth1, newmonth1)>
<cfset vmonthto1 = dateformat(newdate1,"mmm yy")>

<!--- period 2 --->
<cfset newmonth2 = clsmonth + 2>	
<cfif newmonth2 gt 12>
	<cfset newmonth2 = newmonth2 - 12>
	<cfset newyear2 = clsyear + 1>
<cfelse>
	<cfset newyear2 = clsyear>
</cfif>
<cfset newdate2 = CreateDate(newyear2, newmonth2, newmonth2)>
<cfset vmonthto2 = dateformat(newdate2,"mmm yy")>
<!--- period 3 --->
<cfset newmonth3 = clsmonth + 3>	
<cfif newmonth3 gt 12>
	<cfset newmonth3 = newmonth3 - 12>
	<cfset newyear3= clsyear + 1>
<cfelse>
	<cfset newyear3 = clsyear>
</cfif>
<cfset newdate3 = CreateDate(newyear3, newmonth3, newmonth3)>
<cfset vmonthto3 = dateformat(newdate3,"mmm yy")>
<!--- period 4--->
<cfset newmonth4 = clsmonth + 4>	
<cfif newmonth4 gt 12>
	<cfset newmonth4 = newmonth4 - 12>
	<cfset newyear4= clsyear + 1>
<cfelse>
	<cfset newyear4 = clsyear>
</cfif>
<cfset newdate4 = CreateDate(newyear4, newmonth4, newmonth4)>
<cfset vmonthto4 = dateformat(newdate4,"mmm yy")>

<!--- period 5--->
<cfset newmonth5 = clsmonth + 5>	
<cfif newmonth5 gt 12>
	<cfset newmonth5 = newmonth5 - 12>
	<cfset newyear5= clsyear + 1>
<cfelse>
	<cfset newyear5 = clsyear>
</cfif>
<cfset newdate5 = CreateDate(newyear5, newmonth5, newmonth5)>
<cfset vmonthto5 = dateformat(newdate5,"mmm yy")>
<!--- period 6--->
<cfset newmonth6 = clsmonth + 6>	
<cfif newmonth6 gt 12>
	<cfset newmonth6 = newmonth6 - 12>
	<cfset newyear6= clsyear + 1>
<cfelse>
	<cfset newyear6 = clsyear>
</cfif>
<cfset newdate6 = CreateDate(newyear6, newmonth6, newmonth6)>
<cfset vmonthto6 = dateformat(newdate6,"mmm yy")>

<!--- period 7--->
<cfset newmonth7 = clsmonth + 7>	
<cfif newmonth7 gt 12>
	<cfset newmonth7 = newmonth7 - 12>
	<cfset newyear7= clsyear + 1>
<cfelse>
	<cfset newyear7 = clsyear>
</cfif>
<cfset newdate7 = CreateDate(newyear7, newmonth7, newmonth7)>
<cfset vmonthto7 = dateformat(newdate7,"mmm yy")>
<!--- period 8--->
<cfset newmonth8 = clsmonth + 8>	
<cfif newmonth8 gt 12>
	<cfset newmonth8 = newmonth8 - 12>
	<cfset newyear8= clsyear + 1>
<cfelse>
	<cfset newyear8 = clsyear>
</cfif>
<cfset newdate8 = CreateDate(newyear8, newmonth8, newmonth8)>
<cfset vmonthto8 = dateformat(newdate8,"mmm yy")>
<!--- period 9--->
<cfset newmonth9 = clsmonth + 9>	
<cfif newmonth9 gt 12>
	<cfset newmonth9 = newmonth9 - 12>
	<cfset newyear9= clsyear + 1>
<cfelse>
	<cfset newyear9 = clsyear>
</cfif>
<cfset newdate9 = CreateDate(newyear9, newmonth9, newmonth9)>
<cfset vmonthto9 = dateformat(newdate9,"mmm yy")>
<!--- period 10--->
<cfset newmonth10 = clsmonth + 10>	
<cfif newmonth10 gt 12>
	<cfset newmonth10 = newmonth10 - 12>
	<cfset newyear10= clsyear + 1>
<cfelse>
	<cfset newyear10 = clsyear>
</cfif>
<cfset newdate10 = CreateDate(newyear10, newmonth10, newmonth10)>
<cfset vmonthto10 = dateformat(newdate10,"mmm yy")>
<!--- period 11--->
<cfset newmonth11 = clsmonth + 11>	
<cfif newmonth11 gt 12>
	<cfset newmonth11 = newmonth11 - 12>
	<cfset newyear11= clsyear + 1>
<cfelse>
	<cfset newyear11 = clsyear>
</cfif>
<cfset newdate11 = CreateDate(newyear11, newmonth11, newmonth11)>
<cfset vmonthto11 = dateformat(newdate11,"mmm yy")>
<!--- period 12--->
<cfset newmonth12 = clsmonth + 12>	
<cfif newmonth12 gt 12>
	<cfset newmonth12 = newmonth12 - 12>
	<cfset newyear12= clsyear + 1>
<cfelse>
	<cfset newyear12 = clsyear>
</cfif>
<cfset newdate12 = CreateDate(newyear12, newmonth12, newmonth12)>
<cfset vmonthto12 = dateformat(newdate12,"mmm yy")>
<!--- period 13--->
<cfset newmonth13 = clsmonth + 13>
<cfif newmonth13 gt 24>
	<cfset newmonth13 = newmonth13 - 24>
	<cfset newyear13= clsyear + 2>	
<cfelseif newmonth13 gt 12>
	<cfset newmonth13 = newmonth13 - 12>
	<cfset newyear13= clsyear + 1>
<cfelse>
	<cfset newyear13 = clsyear>
</cfif>
<cfset newdate13 = CreateDate(newyear13, newmonth13, newmonth13)>
<cfset vmonthto13 = dateformat(newdate13,"mmm yy")>
<!--- period 14--->
<cfset newmonth14 = clsmonth + 14>
<cfif newmonth14 gt 24>
	<cfset newmonth14 = newmonth14 - 24>
	<cfset newyear14= clsyear + 2>	
<cfelseif newmonth14 gt 12>
	<cfset newmonth14 = newmonth14 - 12>
	<cfset newyear14= clsyear + 1>
<cfelse>
	<cfset newyear14 = clsyear>
</cfif>
<cfset newdate14 = CreateDate(newyear14, newmonth14, newmonth14)>
<cfset vmonthto14 = dateformat(newdate14,"mmm yy")>
<!--- period 15--->
<cfset newmonth15 = clsmonth + 15>
<cfif newmonth15 gt 24>
	<cfset newmonth15 = newmonth15 - 24>
	<cfset newyear15= clsyear + 2>	
<cfelseif newmonth15 gt 12>
	<cfset newmonth15 = newmonth15 - 12>
	<cfset newyear15= clsyear + 1>
<cfelse>
	<cfset newyear15 = clsyear>
</cfif>
<cfset newdate15 = CreateDate(newyear15, newmonth15, newmonth15)>
<cfset vmonthto15 = dateformat(newdate15,"mmm yy")>
<!--- period 16--->
<cfset newmonth16 = clsmonth + 16>
<cfif newmonth16 gt 24>
	<cfset newmonth16 = newmonth16 - 24>
	<cfset newyear16= clsyear + 2>	
<cfelseif newmonth16 gt 12>
	<cfset newmonth16 = newmonth16 - 12>
	<cfset newyear16= clsyear + 1>
<cfelse>
	<cfset newyear16 = clsyear>
</cfif>
<cfset newdate16 = CreateDate(newyear16, newmonth16, newmonth16)>
<cfset vmonthto16 = dateformat(newdate16,"mmm yy")>
<!--- period 17--->
<cfset newmonth17 = clsmonth + 17>
<cfif newmonth17 gt 24>
	<cfset newmonth17 = newmonth17 - 24>
	<cfset newyear17= clsyear + 2>	
<cfelseif newmonth17 gt 12>
	<cfset newmonth17 = newmonth17 - 12>
	<cfset newyear17= clsyear + 1>
<cfelse>
	<cfset newyear17 = clsyear>
</cfif>
<cfset newdate17 = CreateDate(newyear17, newmonth17, newmonth17)>
<cfset vmonthto17 = dateformat(newdate17,"mmm yy")>
<!--- period 18--->
<cfset newmonth18 = clsmonth + 18>
<cfif newmonth18 gt 24>
	<cfset newmonth18 = newmonth18 - 24>
	<cfset newyear18= clsyear + 2>	
<cfelseif newmonth18 gt 12>
	<cfset newmonth18 = newmonth18 - 12>
	<cfset newyear18= clsyear + 1>
<cfelse>
	<cfset newyear18 = clsyear>
</cfif>
<cfset newdate18 = CreateDate(newyear18, newmonth18, newmonth18)>
<cfset vmonthto18 = dateformat(newdate18,"mmm yy")>

<body>
<cfif history eq "customeritemlastprice">
	<cfset trantype="Print Customer - Item Last Price Enquiry">
<cfelseif history eq "itemcustomertransactedprice">
	<cfset trantype="Print Item - Customer Transacted Price Enquiry">
<cfelseif history eq "customeritemtransactedprice">
	<cfset trantype="Print Customer Item Transacted Price Enquiry">
<cfelseif history eq "itemsupplierlastprice">
	<cfset trantype="Print Item - Supplier Last Price Enquiry">
<cfelseif history eq "itemsuppliertransactedprice">
	<cfset trantype="Print Item - Supplier Transacted Price Enquiry">
<cfelseif history eq "supplieritemtransactedprice">
	<cfset trantype="Print Supplier - Item Transacted Price Enquiry">
    <cfelseif history eq "adjustedtransactioncost">
	<cfset trantype="Print Adjusted Transaction Cost">

</cfif>
<h3>
	<a href="historypricemenu.cfm">History Price Enquiry Menu</a> >> 
	<a><font size="2"><cfoutput>#trantype#</cfoutput></font></a>
</h3>
<cfoutput>

<cfif history eq "customeritemlastprice">
	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by custno
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by itemno
	</cfquery> --->
	<cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
	</cfquery>
	
	<!--- <h2>Print Customer - Item Last Price Enquiry</h2> --->
	
	<form name="historyprice" action="historyprice1.cfm?type=customeritemlastprice" method="post" target="_blank"><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
	<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
		<tr>
		  	<th>Customer From</th>
        	<td><select name="custfrom" id="custfrom">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>		
      	</tr>
      	<tr> 
        	<th>Customer To</th>
        	<td><select name="custto" id="custto">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
		  	<th>Item No From</th>
        	<td><select name="itemfrom">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
				</cfif>
			</td>
		</tr>
      	<tr> 
        	<th>Item No To</th>
        	<td><select name="itemto">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
				</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr> 
			<th>Date From</th>
			<td><input type="text" name="datefrom" maxlength="10" size="10"> (DD/MM/YYYY)</td>
		</tr>
		<tr> 
			<th>Date To</th>
			<td><input type="text" name="dateto" maxlength="10" size="10"> (DD/MM/YYYY)</td>
		</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
			<th>Format Method</th>
		</tr>
		<tr>
			<td><input type="radio" name="sort" id="1" value="itemno" checked> Sort by Item No</td>
			<td><input type="radio" name="sort" id="1" value="desp"> Sort by Item Description</td>
		</tr>
		<tr>
			<td><input type="checkbox" name="displaycurr" id="1" value="yes"> With Currency Code</td>
			<td><input type="checkbox" name="displayqty" id="1" value="yes"> With Quantity</td>
		</tr>
		<tr> 
			<td colspan="3" align="right"><input type="submit" name="Submit" value="Submit"></td>
		</tr>
	</table>
	</form>

<cfelseif history eq "itemcustomertransactedprice">
	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by custno
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by itemno
	</cfquery> --->
    
	<cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
	</cfquery>
	<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where 0=0
                        <cfif alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and  ucase(agent)='#ucase(huserid)#'
					</cfif>
					<cfelse>
					
					</cfif> order by agent
					</cfquery>
	<!--- <h2>Print Item - Customer Transacted Price Enquiry</h2> --->
	
	<form name="historyprice" action="historyprice2.cfm?type=itemcustomertransactedprice" method="post" target="_blank"><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
	<table width="75%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
    <tr>
	  	<td nowrap>
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT<br/>
            <input type="checkbox" name="service" id="service" value="1">Include Service
            </td>
            </tr>
		<tr>
		  	<th>Customer From</th>
        	<td><select name="custfrom">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>		
      	</tr>
      	<tr> 
        	<th>Customer To</th>
        	<td><select name="custto">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
        <tr> 
    	<th>#getgeneral.lAGENT# From</th>
        <td><select name="agentfrom">
				
					
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>

			</select>
		</td>
    </tr>
    <tr> 
        <th>#getgeneral.lAGENT# To</th>
        <td><select name="agentto">
				
					<option value="">Choose an #getgeneral.lAGENT#</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
			</select>
		</td>
    </tr>
    <tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
		  	<th>Item No From</th>
        	<td><select name="itemfrom">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
				</cfif>
			</td>
		</tr>
      	<tr> 
        	<th>Item No To</th>
        	<td><select name="itemto">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
				</cfif>
			</td>
      	</tr>
         <tr> 
			<td colspan="3"><hr></td>
		</tr>
        <tr>
      	<th width="16%"><cfoutput>#getgeneral.lCATEGORY#</cfoutput> From</th>
      	<td colspan="2">
			<select name="Catefrom">
          		<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
          		<cfloop query="getcate">
            	<option value="#cate#">#cate# - #desp#</option>
          		</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
			</cfif>
		</td>
    </tr>
   
    <tr>
      	<th width="16%"><cfoutput>#getgeneral.lCATEGORY#</cfoutput> To</th>
      	<td colspan="2">
			<select name="Cateto">
          		<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
          		<cfloop query="getcate">
            	<option value="#cate#">#cate# - #desp#</option>
          		</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
			</cfif>
		</td>
    </tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
        <tr>
      	<th width="16%">Brand From</th>
      	<td colspan="2">
			<select name="brandfrom">
          		<option value="">Choose a Brand</option>
          		<cfloop query="getbrand">
            	<option value="#brand#">#brand# - #desp#</option>
          		</cfloop>
			</select>

		</td>
    </tr>
   
    <tr>
      	<th width="16%">Brand To</th>
      	<td colspan="2">
			<select name="brandto">
          		<option value="">Choose a Brand</option>
          		<cfloop query="getbrand">
            	<option value="#brand#">#brand# - #desp#</option>
          		</cfloop>
			</select>
		</td>
    </tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr> 
			<th>Date From</th>
			<td><input type="text" name="datefrom" maxlength="10" size="10"> (DD/MM/YYYY)</td>
		</tr>
		<tr> 
			<th>Date To</th>
			<td><input type="text" name="dateto" maxlength="10" size="10"> (DD/MM/YYYY)</td>
		</tr>
		<tr> 
			<td colspan="3" align="right"><input type="submit" name="Submit" value="Submit"></td>
		</tr>
	</table>
	</form>

<cfelseif history eq "customeritemtransactedprice">
	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by custno
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by itemno
	</cfquery> --->
	<cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
	</cfquery>
	<cfquery name="getlocation" datasource="#dts#">
		select location, desp, custno from iclocation order by location
	</cfquery>
	
	<!--- <h2>Print Customer Item Transacted Price Enquiry</h2> --->
	
	<form name="historyprice" action="historyprice3.cfm?type=customeritemtransactedprice" method="post" target="_blank"><input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
	<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
		<tr> 
        	<th>Period From</th>
        	<td><select name="periodfrom" onChange="displaymonth()">
				<option value="01"selected>1</option>
		    	<option value="02">2</option>
				<option value="03">3</option>
				<option value="04">4</option>
				<option value="05">5</option>
				<option value="06">6</option>
				<option value="07">7</option>
				<option value="08">8</option>
				<option value="09">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12">12</option>
				<option value="13">13</option>
				<option value="14">14</option>
				<option value="15">15</option>
				<option value="16">16</option>
				<option value="17">17</option>
				<option value="18">18</option>
				</select>&nbsp;<input type="text" name="monthfrom" value="#vmonth#" size="6" readonly>
			</td>
      	</tr>
      	<tr> 
        	<th>Period To</th>
			<td><select name="periodto" onChange="displaymonth()">
				<option value="01">1</option>
				<option value="02">2</option>
				<option value="03">3</option>
				<option value="04">4</option>
				<option value="05">5</option>
				<option value="06">6</option>
				<option value="07">7</option>
				<option value="08">8</option>
				<option value="09">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12"selected>12</option>
				<option value="13">13</option>
				<option value="14">14</option>
				<option value="15">15</option>
				<option value="16">16</option>
				<option value="17">17</option>
				<option value="18">18</option>
				</select>&nbsp;<input type="text" name="monthto" value="#vmonthto#" size="6" readonly>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
		  	<th>Customer From</th>
        	<td><select name="custfrom">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>		
      	</tr>
      	<tr> 
        	<th>Customer To</th>
        	<td><select name="custto">
				<option value="">Choose a Customer</option>
				<cfloop query="getcust">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
		  	<th>Item No From</th>
        	<td><select name="itemfrom">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
				</cfif>
			</td>
		</tr>
      	<tr> 
        	<th>Item No To</th>
        	<td><select name="itemto">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
				</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
			<th>Location From</th>
			<td><select name="locatefrom">
				<option value="">Choose a Location</option>
				<cfloop query="getlocation">
				<option value="#location#">#location# - #desp#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<th>Location To</th>
			<td><select name="locateto">
				<option value="">Choose a Location</option>
				<cfloop query="getlocation">
				<option value="#location#">#location# - #desp#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
			<th>Enquiry Format</th>
		</tr>
		<tr>
			<td><input type="checkbox" name="displaydesp" value="desp"> With Description</td>
			<td><input type="checkbox" name="displaycurr" value="curr"> List Foreign Curency Price</td>
		</tr>
		<tr> 
			<td colspan="3" align="right"><input type="submit" name="Submit" value="Submit"></td>
		</tr>
	</table>
	</form>

<cfelseif history eq "itemsupplierlastprice" or history eq "itemsuppliertransactedprice">
	<!--- <cfquery name="getsupp" datasource="#dts#">
		select custno, name from #target_apvend# order by custno
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by itemno
	</cfquery> --->
	<cfquery name="getsupp" datasource="#dts#">
		select custno, name from #target_apvend# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
	</cfquery>
	
	<cfif history eq "itemsupplierlastprice">
		<!--- <h2>Print Item - Supplier Last Price Enquiry</h2> --->
		<form name="historyprice" action="historyprice4.cfm?type=itemsupplierlastprice" method="post" target="_blank"><input type="hidden" name="tran" id="tran" value="#target_apvend#" /><input type="hidden" name="fromto" id="fromto" value="" />

	<cfelseif history eq "itemsuppliertransactedprice">
		<!--- <h2>Print Item - Supplier Transacted Price Enquiry</h2> --->
		<form name="historyprice" action="historyprice5.cfm?type=itemsuppliertransactedprice" method="post" target="_blank"><input type="hidden" name="tran" id="tran" value="#target_apvend#" /><input type="hidden" name="fromto" id="fromto" value="" />

	</cfif>
	
	<table width="75%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th>Supplier From</th>
        <td><select name="suppfrom">
			<option value="">Choose a Supplier</option>
			<cfloop query="getsupp">
			<option value="#custno#">#custno# - #name#</option>
			</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
		</td>
	</tr>
    <tr> 
       	<th>Supplier To</th>
    	<td><select name="suppto">
			<option value="">Choose a Supplier</option>
			<cfloop query="getsupp">
			<option value="#custno#">#custno# - #name#</option>
			</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
		</td>
	</tr>
	<tr> 
		<td colspan="3"><hr></td>
	</tr>
	<tr>
		<th>Item No From</th>
        <td><select name="itemfrom">
			<option value="">Choose a Item No</option>
			<cfloop query="getitem">
			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
			</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
			</cfif>
		</td>
	</tr>
    <tr> 
    	<th>Item No To</th>
        <td><select name="itemto">
			<option value="">Choose a Item No</option>
			<cfloop query="getitem">
			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
			</cfloop>
			</select>
			<cfif getgeneral.filterall eq "1">
			</cfif>
		</td>
    </tr>
	<tr> 
		<td colspan="3"><hr></td>
	</tr>
	<tr> 
		<th>Date From</th>
		<td><input type="text" name="datefrom" maxlength="10" size="10"> (DD/MM/YYYY)</td>
	</tr>
	<tr> 
		<th>Date To</th>
		<td><input type="text" name="dateto" maxlength="10" size="10"> (DD/MM/YYYY)</td>
	</tr>
	<cfif history eq "itemsupplierlastprice">
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
			<th>Format Method</th>
		</tr>
		<!--- <tr>
			<td><input type="radio" name="sort" id="1" value="itemno" checked> Sort by Item No</td>
			<td><input type="radio" name="sort" id="1" value="desp"> Sort by Item Description</td>
		</tr> --->
		<tr>
			<td><input type="checkbox" name="displaycurr" id="1" value="yes"> With Currency Code</td>
			<td><input type="checkbox" name="displayqty" id="1" value="yes"> With Quantity</td>
		</tr>
	</cfif>
	<tr> 
		<td colspan="3" align="right"><input type="submit" name="Submit" value="Submit"></td>
	</tr>
	</table>
	</form>

<cfelseif history eq "supplieritemtransactedprice">
	<!--- <cfquery name="getsupp" datasource="#dts#">
		select custno, name from #target_apvend# order by custno
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by itemno
	</cfquery> --->
	<cfquery name="getsupp" datasource="#dts#">
		select custno, name from #target_apvend# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
	</cfquery>
	<cfquery name="getlocation" datasource="#dts#">
		select location, desp, custno from iclocation order by location
	</cfquery>
	
	<!--- <h2>Print Supplier - Item Transacted Price Enquiry</h2> --->
	
	<form name="historyprice" action="historyprice6.cfm?type=supplieritemtransactedprice" method="post" target="_blank"><input type="hidden" name="tran" id="tran" value="#target_apvend#" /><input type="hidden" name="fromto" id="fromto" value="" />
	<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
		<tr> 
        	<th>Period From</th>
        	<td><select name="periodfrom" onChange="displaymonth()">
				<option value="01"selected>1</option>
		    	<option value="02">2</option>
				<option value="03">3</option>
				<option value="04">4</option>
				<option value="05">5</option>
				<option value="06">6</option>
				<option value="07">7</option>
				<option value="08">8</option>
				<option value="09">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12">12</option>
				<option value="13">13</option>
				<option value="14">14</option>
				<option value="15">15</option>
				<option value="16">16</option>
				<option value="17">17</option>
				<option value="18">18</option>
				</select>&nbsp;<input type="text" name="monthfrom" value="#vmonth#" size="6" readonly>
			</td>
      	</tr>
      	<tr> 
        	<th>Period To</th>
			<td><select name="periodto" onChange="displaymonth()">
				<option value="01">1</option>
				<option value="02">2</option>
				<option value="03">3</option>
				<option value="04">4</option>
				<option value="05">5</option>
				<option value="06">6</option>
				<option value="07">7</option>
				<option value="08">8</option>
				<option value="09">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12"selected>12</option>
				<option value="13">13</option>
				<option value="14">14</option>
				<option value="15">15</option>
				<option value="16">16</option>
				<option value="17">17</option>
				<option value="18">18</option>
				</select>&nbsp;<input type="text" name="monthto" value="#vmonthto#" size="6" readonly>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
		  	<th>Supplier From</th>
        	<td><select name="suppfrom">
				<option value="">Choose a Supplier</option>
				<cfloop query="getsupp">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>		
      	</tr>
      	<tr> 
        	<th>Supplier To</th>
        	<td><select name="suppto">
				<option value="">Choose a Supplier</option>
				<cfloop query="getsupp">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
		  	<th>Item No From</th>
        	<td><select name="itemfrom">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
				</cfif>
			</td>
		</tr>
      	<tr> 
        	<th>Item No To</th>
        	<td><select name="itemto">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
				</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
			<th>Location From</th>
			<td><select name="locatefrom">
				<option value="">Choose a Location</option>
				<cfloop query="getlocation">
				<option value="#location#">#location# - #desp#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<th>Location To</th>
			<td><select name="locateto">
				<option value="">Choose a Location</option>
				<cfloop query="getlocation">
				<option value="#location#">#location# - #desp#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
			<th>Enquiry Format</th>
		</tr>
		<tr>
			<td><input type="checkbox" name="displaydesp" value="desp"> With Description</td>
			<td><input type="checkbox" name="displaycurr" value="curr"> List Foreign Curency Price</td>
		</tr>
		<tr> 
			<td colspan="3" align="right"><input type="submit" name="Submit" value="Submit"></td>
		</tr>
	</table>
	</form>
    
    
    
    <cfelseif history eq "adjustedtransactioncost">
	<!--- <cfquery name="getsupp" datasource="#dts#">
		select custno, name from #target_apvend# order by custno
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by itemno
	</cfquery> --->
	<cfquery name="getsupp" datasource="#dts#">
		select custno, name from #target_apvend# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery>
	<cfquery name="getitem" datasource="#dts#">
		select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
	</cfquery>
	<cfquery name="getlocation" datasource="#dts#">
		select location, desp, custno from iclocation order by location
	</cfquery>
    
    <cfquery name="gettran" datasource="#dts#">
    select *
			from ictran
			where wos_date > #getgeneral.lastaccyear# and (type='RC' or type='PR') and (void='' or void is null) and brem4='XCOST'
    group by type,refno
    order by type,refno
    </cfquery>
	
	<!--- <h2>Print Supplier - Item Transacted Price Enquiry</h2> --->
	
	<form name="historyprice" action="historyprice7.cfm?type=adjustedtransactioncost" method="post" target="_blank"><input type="hidden" name="tran" id="tran" value="#target_apvend#" /><input type="hidden" name="fromto" id="fromto" value="" />
	<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
		<tr> 
        	<th>Period From</th>
        	<td><select name="periodfrom" onChange="displaymonth()">
				<option value="01"selected>1</option>
		    	<option value="02">2</option>
				<option value="03">3</option>
				<option value="04">4</option>
				<option value="05">5</option>
				<option value="06">6</option>
				<option value="07">7</option>
				<option value="08">8</option>
				<option value="09">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12">12</option>
				<option value="13">13</option>
				<option value="14">14</option>
				<option value="15">15</option>
				<option value="16">16</option>
				<option value="17">17</option>
				<option value="18">18</option>
				</select>&nbsp;<input type="text" name="monthfrom" value="#vmonth#" size="6" readonly>
			</td>
      	</tr>
      	<tr> 
        	<th>Period To</th>
			<td><select name="periodto" onChange="displaymonth()">
				<option value="01">1</option>
				<option value="02">2</option>
				<option value="03">3</option>
				<option value="04">4</option>
				<option value="05">5</option>
				<option value="06">6</option>
				<option value="07">7</option>
				<option value="08">8</option>
				<option value="09">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12"selected>12</option>
				<option value="13">13</option>
				<option value="14">14</option>
				<option value="15">15</option>
				<option value="16">16</option>
				<option value="17">17</option>
				<option value="18">18</option>
				</select>&nbsp;<input type="text" name="monthto" value="#vmonthto#" size="6" readonly>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
        <tr>
		  	<th>Ref No From</th>
        	<td><select name="billfrom">
				<option value="">Choose a Ref No</option>
				<cfloop query="gettran">
				<option value="#refno#">#refno#</option>
				</cfloop>
				</select>
			</td>		
      	</tr>
      	<tr> 
        	<th>Refn No To</th>
        	<td><select name="billto">
				<option value="">Choose a Ref No</option>
				<cfloop query="gettran">
				<option value="#refno#">#refno#</option>
				</cfloop>
				</select>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
        
		<tr>
		  	<th>Supplier From</th>
        	<td><select name="suppfrom">
				<option value="">Choose a Supplier</option>
				<cfloop query="getsupp">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>		
      	</tr>
      	<tr> 
        	<th>Supplier To</th>
        	<td><select name="suppto">
				<option value="">Choose a Supplier</option>
				<cfloop query="getsupp">
				<option value="#custno#">#custno# - #name#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">&nbsp;
</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
		  	<th>Item No From</th>
        	<td><select name="itemfrom">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
				</cfif>
			</td>
		</tr>
      	<tr> 
        	<th>Item No To</th>
        	<td><select name="itemto">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
				</cfif>
			</td>
      	</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		<tr>
			<th>Location From</th>
			<td><select name="locatefrom">
				<option value="">Choose a Location</option>
				<cfloop query="getlocation">
				<option value="#location#">#location# - #desp#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<th>Location To</th>
			<td><select name="locateto">
				<option value="">Choose a Location</option>
				<cfloop query="getlocation">
				<option value="#location#">#location# - #desp#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
		
		<tr> 
			<td colspan="3" align="right"><input type="submit" name="Submit" value="Submit"></td>
		</tr>
	</table>
	</form>
</cfif>
</cfoutput>
<script language="JavaScript">
	function displaymonth(){
		
	if(document.historyprice.periodfrom.value=='01')		
	{	document.historyprice.monthfrom.value='#vmonthto1#'; }
		
	else if(document.historyprice.periodfrom.value=='02')	
	{	document.historyprice.monthfrom.value='#vmonthto2#'; }
	
	else if(document.historyprice.periodfrom.value=='03')	
	{	document.historyprice.monthfrom.value='#vmonthto3#'; }
	
	else if(document.historyprice.periodfrom.value=='04')	
	{	document.historyprice.monthfrom.value='#vmonthto4#'; }
	
	else if(document.historyprice.periodfrom.value=='05')	
	{	document.historyprice.monthfrom.value='#vmonthto5#'; }
	
	else if(document.historyprice.periodfrom.value=='06')	
	{	document.historyprice.monthfrom.value='#vmonthto6#'; }
	
	else if(document.historyprice.periodfrom.value=='07')	
	{	document.historyprice.monthfrom.value='#vmonthto7#'; }
	
	else if(document.historyprice.periodfrom.value=='08')	
	{	document.historyprice.monthfrom.value='#vmonthto8#'; }
	
	else if(document.historyprice.periodfrom.value=='09')	
	{	document.historyprice.monthfrom.value='#vmonthto9#'; }
	
	else if(document.historyprice.periodfrom.value=='10')	
	{	document.historyprice.monthfrom.value='#vmonthto10#'; }
	
	else if(document.historyprice.periodfrom.value=='11')	
	{	document.historyprice.monthfrom.value='#vmonthto11#'; }
	
	else if(document.historyprice.periodfrom.value=='12')	
	{	document.historyprice.monthfrom.value='#vmonthto12#'; }
	
	else if(document.historyprice.periodfrom.value=='13')	
	{	document.historyprice.monthfrom.value='#vmonthto13#'; }
	
	else if(document.historyprice.periodfrom.value=='14')	
	{	document.historyprice.monthfrom.value='#vmonthto14#'; }
	
	else if(document.historyprice.periodfrom.value=='15')	
	{	document.historyprice.monthfrom.value='#vmonthto15#'; }
	
	else if(document.historyprice.periodfrom.value=='16')	
	{	document.historyprice.monthfrom.value='#vmonthto16#'; }
	
	else if(document.historyprice.periodfrom.value=='17')	
	{	document.historyprice.monthfrom.value='#vmonthto17#'; }
	
	else if(document.historyprice.periodfrom.value=='18')	
	{	document.historyprice.monthfrom.value='#vmonthto18#'; }
	
	if(document.historyprice.periodto.value=='01')		
	{	document.historyprice.monthto.value='#vmonthto1#'; }
		
	else if(document.historyprice.periodto.value=='02')	
	{	document.historyprice.monthto.value='#vmonthto2#'; }
	
	else if(document.historyprice.periodto.value=='03')	
	{	document.historyprice.monthto.value='#vmonthto3#'; }
	
	else if(document.historyprice.periodto.value=='04')	
	{	document.historyprice.monthto.value='#vmonthto4#'; }
	
	else if(document.historyprice.periodto.value=='05')	
	{	document.historyprice.monthto.value='#vmonthto5#'; }
	
	else if(document.historyprice.periodto.value=='06')	
	{	document.historyprice.monthto.value='#vmonthto6#'; }
	
	else if(document.historyprice.periodto.value=='07')	
	{	document.historyprice.monthto.value='#vmonthto7#'; }
	
	else if(document.historyprice.periodto.value=='08')	
	{	document.historyprice.monthto.value='#vmonthto8#'; }
	
	else if(document.historyprice.periodto.value=='09')	
	{	document.historyprice.monthto.value='#vmonthto9#'; }
	
	else if(document.historyprice.periodto.value=='10')	
	{	document.historyprice.monthto.value='#vmonthto10#'; }
	
	else if(document.historyprice.periodto.value=='11')	
	{	document.historyprice.monthto.value='#vmonthto11#'; }
	
	else if(document.historyprice.periodto.value=='12')	
	{	document.historyprice.monthto.value='#vmonthto12#'; }
	
	else if(document.historyprice.periodto.value=='13')	
	{	document.historyprice.monthto.value='#vmonthto13#'; }
	
	else if(document.historyprice.periodto.value=='14')	
	{	document.historyprice.monthto.value='#vmonthto14#'; }
	
	else if(document.historyprice.periodto.value=='15')	
	{	document.historyprice.monthto.value='#vmonthto15#'; }
	
	else if(document.historyprice.periodto.value=='16')	
	{	document.historyprice.monthto.value='#vmonthto16#'; }
	
	else if(document.historyprice.periodto.value=='17')	
	{	document.historyprice.monthto.value='#vmonthto17#'; }
	
	else if(document.historyprice.periodto.value=='18')	
	{	document.historyprice.monthto.value='#vmonthto18#'; }
	
	}
</script>


</body>
</html>