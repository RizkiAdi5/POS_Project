<cfset xcustno='3000/CS1'>
<cfsetting showdebugoutput="no">


<cfset serialnoitem=0>

<cfquery name="checkenable" datasource="#dts#">
select enabledetectrem1,itempriceprior,branchpricelvl from gsetup
</cfquery>
<cfset url.itemno = URLDECODE(url.itemno)>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,price3,price4,price5,price6,ucost,costformula,"0" as isservi from icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#"> 
<cfif Hitemgroup neq ''>
    	and wos_group='#Hitemgroup#'
   		</cfif>
</cfquery>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno,desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,price3,price4,price5,price6,ucost,costformula,"0" as isservi from icitem where aitemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
<cfif Hitemgroup neq ''>
    	and wos_group='#Hitemgroup#'
   		</cfif>
</cfquery>

<cfif checkenable.enabledetectrem1 eq 'Y'>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno,desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,price3,price4,price5,price6,ucost,costformula,"0" as isservi from icitem where remark2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
<cfif Hitemgroup neq ''>
    	and wos_group='#Hitemgroup#'
   		</cfif>
</cfquery>
</cfif>
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
SELECT itemno,desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,price3,price4,price5,price6,ucost,costformula,"0" as isservi from icitem where barcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
<cfif Hitemgroup neq ''>
    	and wos_group='#Hitemgroup#'
   		</cfif>
</cfquery>

<cfif getItemDetails.recordcount neq 0>
<cfset url.itemno = getItemDetails.itemno>
<cfoutput>
<input type="hidden" name="replaceitemno" id="replaceitemno" value="#URLENCODEDFORMAT(trim(url.itemno))#" />
</cfoutput>
</cfif>
</cfif>

<!---price from barcode---> 
<cfif getItemDetails.recordcount eq 0 and lcase(hcomid) eq "safetymeat_i">
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno,desp,despa,unit,unit2,unit3,unit4,unit5,unit6,if(price=0,1,price) as price,price2,price3,price4,price5,price6,ucost,costformula,"0" as isservi from icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(trim(url.itemno),7)#">
<cfif Hitemgroup neq ''>
    	and wos_group='#Hitemgroup#'
</cfif>
</cfquery>

<cfoutput>
<cfset fixedamount=mid(url.itemno,8,3)&"."&mid(url.itemno,11,2)>
<cfset url.itemno = getItemDetails.itemno>

<cfset qtyfixed=val(fixedamount)/getItemDetails.price>
<input type="hidden" name="replaceitemno" id="replaceitemno" value="#URLENCODEDFORMAT(trim(url.itemno))#" />
<input type="hidden" name="qtyhid" id="qtyhid" value="#qtyfixed#" />
<input type="hidden" name="amthid" id="amthid" value="#fixedamount#" />
</cfoutput>
</cfif>

<!---end price from barcode---> 

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT servi,desp,despa,"1" as isservi, 0 as price, 0 as ucost,"" as unit,"" as unit2, "" as unit3, "" as unit4, "" as unit5, "" as unit6,"" as costformula from icservi where servi = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>
</cfif>


<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
select * from(
SELECT ifnull(sum(a.sign),0) as serialqty,a.serialno, b.itemno,b.desp,b.despa,b.unit,b.unit2,b.unit3,b.unit4,b.unit5,b.unit6,b.price,b.price2,b.price3,b.price4,b.price5,b.price6,b.ucost,b.costformula,"0" as isservi from iserial as a

 left join (
 SELECT
 itemno,desp,despa,unit,unit2,unit3,unit4,unit5,unit6,price,price2,
 price3,price4,price5,price6,ucost,costformula,"0" as isservi from icitem
 )as b on a.itemno=b.itemno

where a.serialno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
and serialno not in (select serialno from iserialtemp where uuid="#uuid#")) as aa
where serialqty <>0

</cfquery>

<cfif getItemDetails.recordcount neq 0>
<cfset serialno=url.itemno>
<cfset url.itemno = getItemDetails.itemno>
<cfset serialnoitem=1>
<cfoutput>
<input type="hidden" name="replaceitemno" id="replaceitemno" value="#URLENCODEDFORMAT(trim(url.itemno))#" />
</cfoutput>
<cfelse>
</cfif>
</cfif>


<cfset desp = getItemDetails.desp>
<cfset despa = getItemDetails.despa>
<cfif getItemDetails.recordcount eq 0 and url.itemno neq "">
<cfset desp = "itemisnoexisted" >
<cfset despa = "">
</cfif> 
<cfif getItemDetails.isservi neq "1">
<cfset allunit = getItemDetails.unit>
<cfelse>
<cfset allunit = "">
</cfif>


<cfoutput>
<cfif checkenable.itempriceprior eq "2">
<cfquery name="getcustomerprice" datasource="#dts#">
select * from icl3p<cfif url.reftype eq 'PO' or url.reftype eq 'RC' or url.reftype eq 'PR'><cfelse>2</cfif> where itemno='#url.itemno#' and custno='#xcustno#'
</cfquery>
<cfif getcustomerprice.recordcount neq 0>
<cfset getItemDetails.price=getcustomerprice.price>
<cfset getItemDetails.ucost=getcustomerprice.price>
</cfif>
</cfif>

<cfquery name="getbustype" datasource="#dts#">
SELECT business FROM #target_arcust#
    where custno='#xcustno#'
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

<cfif getItemDetails.recordcount neq 0>
<cfset getItemDetails.price = price >
</cfif>


<!---gsetup price--->

<cfif checkenable.branchpricelvl eq 2>
<cfset price = getItemDetails.price2>
<cfelseif checkenable.branchpricelvl eq 3>
<cfset price = getItemDetails.price3>
<cfelseif checkenable.branchpricelvl eq 4>
<cfset price = getItemDetails.price4>
<cfelseif checkenable.branchpricelvl eq 5>
<cfset price = getItemDetails.price5>
<cfelseif checkenable.branchpricelvl eq 6>
<cfset price = getItemDetails.price6>
<cfelse>
<cfset price = getItemDetails.price>
</cfif>

<cfif getItemDetails.recordcount neq 0>
<cfset getItemDetails.price = price >
</cfif>

<cfif checkenable.itempriceprior eq "1">
<cfquery name="getcustomerprice" datasource="#dts#">
select * from icl3p<cfif url.reftype eq 'PO' or url.reftype eq 'RC' or url.reftype eq 'PR'><cfelse>2</cfif> where itemno='#url.itemno#' and custno='#xcustno#'
</cfquery>
<cfif getcustomerprice.recordcount neq 0>
<cfset getItemDetails.price=getcustomerprice.price>
<cfset getItemDetails.ucost=getcustomerprice.price>
</cfif>
</cfif>

<cfif serialnoitem eq 1>
<input type="hidden" name="itemserialnohid" id="itemserialnohid" value="#URLENCODEDFORMAT(serialno)#" />
<cfelse>
<input type="hidden" name="itemserialnohid" id="itemserialnohid" value="" />
</cfif>
                        
<input type="hidden" name="desphid" id="desphid" value="#URLENCODEDFORMAT(desp)#" />
<input type="hidden" name="despahid" id="despahid" value="#URLENCODEDFORMAT(despa)#" />
<input type="hidden" name="unithid" id="unithid" value="#allunit#" />
<cfif url.reftype eq 'PO' or url.reftype eq 'RC' or url.reftype eq 'PR'>
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
		and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#xcustno#"> 
		order by wos_date desc limit 2;
	</cfquery>
<cfoutput>
<b>Last Price #url.itemno#</b>
<table>
<cfloop query="getpricehis">
<tr><td>#dateformat(getpricehis.wos_date,'YYYY-MM-DD')#</td><td>&nbsp;</td><td>#numberformat(getpricehis.price,'.__')#</td></tr>
</cfloop>
</table>
</cfoutput>