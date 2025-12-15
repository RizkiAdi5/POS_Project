<cfsetting showdebugoutput="no">
<cfset itemno = URLDecode(url.itemno)>
<cfset name = URLDecode(url.name)>
<cfset phone = URLDecode(url.phone)>
<cfset email = URLDecode(url.email)>
<cfset note = URLDecode(url.note)>
<cfset location = URLDecode(url.location)>
<cfset itemdesp = URLDecode(url.itemdesp)>
<cfset itemdespa = URLDecode(url.itemdespa)>
<cfset amt = val(URLDecode(url.amt_bil))>
<cfset qty = val(URLDecode(url.qty_bil))>
<cfset price = val(URLDecode(url.price_bil))>
<cfset dispec1 = URLDecode(url.dispec1)>
<cfset dispec2 = URLDecode(url.dispec2)>
<cfset dispec3 = URLDecode(url.dispec3)>
<cfset dis = URLDecode(url.disamt_bil)>
<cfset reserveno = URLDecode(url.reserveno)>

<cfquery name="validitemexist" datasource="#dts#">
SELECT * from reserve where reserveno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#">
</cfquery>

<cfif validitemexist.recordcount eq 0>
<cfquery name="addreserve" datasource="#dts#">
insert into reserve (reserveno,name,phone,email,note,location) values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#phone#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#note#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#location#">
)
</cfquery>
</cfif>

	<cfquery name="getmaxtrancode" datasource="#dts#">
		select max(trancode) as maxtrancode from reservedet where reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#">
	</cfquery>
    <cfif getmaxtrancode.recordcount eq 0>
    <cfset trancode=1>
    <cfelse>
    <cfset trancode=val(getmaxtrancode.maxtrancode)+1>
    </cfif>

<cfquery name="selecticitem" datasource="#dts#">
SELECT * FROM icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#" >
</cfquery>

<cfset qtyReal = qty>

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
        '#REReplace(itemdesp,"925925925925","%","ALL")#', 
        '#REReplace(itemdespa,"925925925925","%","ALL")#',
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

