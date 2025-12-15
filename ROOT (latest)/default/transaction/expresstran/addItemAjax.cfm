

<cfsetting showdebugoutput="no">
<cfquery name="checkenable" datasource="#dts#">
select enabledetectrem1,itempriceprior from gsetup
</cfquery>
<cfset url.itemno = URLDECODE(URLDECODE(url.itemno))>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,price3,price4,ucost,costformula,"0" as isservi from icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno,desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,price3,price4,ucost,costformula,"0" as isservi from icitem where aitemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>

<cfif checkenable.enabledetectrem1 eq 'Y'>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno,desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,price3,price4,ucost,costformula,"0" as isservi from icitem where remark2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>
</cfif>
</cfif>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno,desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,price3,price4,ucost,costformula,"0" as isservi from icitem where barcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>
</cfif>

<cfif getItemDetails.recordcount neq 0>
<cfset url.itemno = getItemDetails.itemno>
<cfoutput>
<input type="hidden" name="replaceitemno" id="replaceitemno" value="#URLENCODEDFORMAT(trim(url.itemno))#" />
</cfoutput>
</cfif>
</cfif>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT servi,desp,despa,"1" as isservi, 0 as price, 0 as ucost,"" as unit,"" as unit2, "" as unit3, "" as unit4, "" as unit5, "" as unit6,"" as costformula from icservi where servi = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>
</cfif>
<cfset desp = getItemDetails.desp>
<cfset despa = getItemDetails.despa>
<cfif getItemDetails.recordcount neq 1 and url.itemno neq "">
<cfset desp = "itemisnoexisted" >
<cfset despa = "">
</cfif> 
<cfif getItemDetails.isservi neq "1">
<cfset allunit = getItemDetails.unit >
<cfloop from="2" to="6" index="i">
<cfset unitgo = "unit"&i>
<cfset unitadd = evaluate('getItemDetails.#unitgo#')>
<cfif trim(unitadd) neq "">
<cfset allunit = allunit &","&unitadd>
</cfif>
</cfloop>
<cfelse>
<cfset allunit = "">
</cfif>


<cfoutput>
<cfif checkenable.itempriceprior eq "2">
<cfquery name="getcustomerprice" datasource="#dts#">
select * from icl3p<cfif url.reftype eq 'PO' or url.reftype eq 'RC' or url.reftype eq 'PR'><cfelse>2</cfif> where itemno='#url.itemno#' and custno='#url.custno#'
</cfquery>
<cfif getcustomerprice.recordcount neq 0>
<cfset getItemDetails.price=getcustomerprice.price>
<cfset getItemDetails.ucost=getcustomerprice.price>
</cfif>
</cfif>

<cfquery name="getbustype" datasource="#dts#">
SELECT business FROM #target_arcust#
    where custno='#url.custno#'
</cfquery>
<cfif getbustype.business neq "">
<cfquery name="getpricelvl" datasource="#dts#">
SELECT pricelvl FROM business where business = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getbustype.business#">
</cfquery>

<cfif getpricelvl.pricelvl eq 2>
<cfset price = getItemDetails.price2>
<cfelseif getpricelvl.pricelvl eq 3>
<cfset price = getItemDetails.price3>
<cfelseif getpricelvl.pricelvl eq 4>
<cfset price = getItemDetails.price4>
<cfelse>
<cfset price = getItemDetails.price>
</cfif>
<cfelse>
<cfset price = getItemDetails.price>
</cfif>

<cfset getItemDetails.price = price >

<cfif checkenable.itempriceprior eq "1">
<cfquery name="getcustomerprice" datasource="#dts#">
select * from icl3p<cfif url.reftype eq 'PO' or url.reftype eq 'RC' or url.reftype eq 'PR'><cfelse>2</cfif> where itemno='#url.itemno#' and custno='#url.custno#'
</cfquery>
<cfif getcustomerprice.recordcount neq 0>
<cfset getItemDetails.price=getcustomerprice.price>
<cfset getItemDetails.ucost=getcustomerprice.price>
</cfif>
</cfif>



    


                        
<input type="hidden" name="desphid" id="desphid" value="#URLENCODEDFORMAT(desp)#" />
<input type="hidden" name="despahid" id="despahid" value="#URLENCODEDFORMAT(despa)#" />
<input type="hidden" name="unithid" id="unithid" value="#allunit#" />
<cfif url.reftype eq 'PO' or url.reftype eq 'RC' or url.reftype eq 'PR' or url.reftype eq 'ISS'>
<input type="hidden" name="pricehid" id="pricehid" value="#numberformat(val(getItemDetails.ucost),'.__')#" />
<cfelse>
<input type="hidden" name="pricehid" id="pricehid" value="#numberformat(val(getItemDetails.price),'.__')#" />
</cfif>
<input type="hidden" name="costformulaid" id="costformulaid" value="#getItemDetails.costformula#" />
<input type="hidden" name="iservi" id="isservi" value="#getItemDetails.isservi#" />
</cfoutput>
<cfquery name="getpricehis" datasource="#dts#">
		select 
		wos_date,price,dispec1,dispec2,dispec3,qty
		from ictran 
		where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.itemno#">
		and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.custno#"> 
		order by wos_date desc limit 2;
	</cfquery>
<cfoutput>
<b>Last Price</b>
<table>
<cfloop query="getpricehis">
<tr><td>#dateformat(getpricehis.wos_date,'YYYY-MM-DD')#</td><td>&nbsp;</td><td>#numberformat(getpricehis.price,'.__')#</td></tr>
</cfloop>
</table>
</cfoutput>