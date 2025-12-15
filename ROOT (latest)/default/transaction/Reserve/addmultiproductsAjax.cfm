<cfset reserveno = URLDecode(url.reserveno)>


<cfquery name="checkenable" datasource="#dts#">
select enabledetectrem1,itempriceprior,branchpricelvl from gsetup
</cfquery>

<cfquery name="gettempitem" datasource="#dts#">
SELECT itemno FROM expresspickitem WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemlisting)#"> ORDER BY CREATED_ON DESC
</cfquery>

<cfloop query="gettempitem">

<cfset itemno = gettempitem.itemno>

<cfquery name="getproductdetail" datasource="#dts#">
select * from icitem where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>


<cfset price = getproductdetail.price>

<cfset desp = getproductdetail.desp>
<cfset amt = price>
<cfset qty = 1>
<cfset unit = getproductdetail.unit>
<cfset dispec1 = 0>
<cfset dispec2 = 0>
<cfset dispec3 = 0>
<cfset dis = 0>
<cfset driver = ''> 
<cfset rem9 = ''> 



<cfquery name="validitemexist" datasource="#dts#">
SELECT *
FROM reservedet WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
and reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#">
</cfquery>

<cfif validitemexist.recordcount neq 0>
<cfelse>

<cfquery name="getmaxtrancode" datasource="#dts#">
		select max(trancode) as maxtrancode from reservedet where reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#">
	</cfquery>
    <cfif getmaxtrancode.recordcount eq 0>
    <cfset trancode=1>
    <cfelse>
    <cfset trancode=val(getmaxtrancode.maxtrancode)+1>
    </cfif>

<cfquery name="getitemdetail" datasource="#dts#">
    select 
    wos_group,category,desp,despa
    from icitem
    where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
</cfquery>


<cfquery name="selecticitem" datasource="#dts#">
SELECT unit,unit2,unit3,unit4,unit5,unit6,factor1,factor2,factorU3_a,factorU3_b,factorU4_a,factorU4_b,factorU5_a,factorU5_b,factorU6_a,factorU6_b FROM icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#" >
</cfquery>

<cfset qtyReal = qty>

<!--- <cfset trancode = val(selectictran.trancode) + 1> --->

<cfquery name="insertictran" datasource="#dts#">
	insert into reservedet
	(
		reserveno,
        trancode,
        itemno,
        desp,
        despa,
        qty_bil,
        price_bil,
        dispec1,
        dispec2,
        dispec3,
        disamt_bil,
        amt_bil,
        taxpec1,
        taxpec2,
        taxpec3,
        taxamt_bil,
        note_a,
        status
        )
        values
        (
        '#reserveno#',
        #trancode#,
        '#itemno#', 
        '#getitemdetail.desp#', 
        '#getitemdetail.despa#',
        #numberformat(val(qty),'._____')#,
        #numberformat(val(price),'.__')#, 
        #val(dispec1)#,
        #val(dispec2)#,
        #val(dispec3)#,
        #numberformat(val(dis),'._____')#,
        #numberformat(val(amt),'.__')#, 
        '0',
        '0',
        '0',
        0.00000,
        '',''
        )
</cfquery>
</cfif>



</cfloop>

<cfquery name="getsum" datasource="#dts#">
SELECT SUM(amt_bil) as totalamt,count(itemno) as countitemno FROM reservedet where reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#" />
</cfquery>

<cfquery name="addpackage" datasource="#dts#">
update reserve set grossamt="#numberformat(val(getsum.totalamt),'.__')#" where reserveno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#" />
</cfquery>

<cfoutput>

<input type="hidden" name="hidsubtotal" id="hidsubtotal" value="#numberformat(getsum.totalamt,'.__')#" />
<input type="hidden" name="hiditemcount" id="hiditemcount" value="#getsum.countitemno#" />
</cfoutput>