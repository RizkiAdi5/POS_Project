<cfsetting showdebugoutput="no">
<cfif isdefined('url.itemno')>

<cfquery name="checkenable" datasource="#dts#">
select enabledetectrem1,itempriceprior from gsetup
</cfquery>

<cfset url.itemno = URLDECODE(url.itemno)>

<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno from icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno from icitem where aitemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>

<cfif checkenable.enabledetectrem1 eq 'Y'>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno from icitem where remark2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>
</cfif>
</cfif>

<cfif getItemDetails.recordcount eq 0>
<cfquery name="getItemDetails" datasource="#dts#">
SELECT itemno from icitem where barcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.itemno)#">
</cfquery>
</cfif>

<cfif getItemDetails.recordcount neq 0>
<cfset url.itemno = URLENCODEDFORMAT(getItemDetails.itemno)>
</cfif>
</cfif>

<cfquery name="getorderdetail" datasource="#dts#">
SELECT qty_gwc,qty_pp,qty_rf,qty_mbs,qty_stock,qty_warehouse FROM orderformtemp WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
</cfquery>

<cfquery name="getreservestock" datasource="#dts#">
SELECT * FROM reservestock WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
</cfquery>

<cfoutput>
<table>
<tr>
<th colspan="7" width="350px" align="center">Order List</th>
</tr>
<tr>
<td></td>
<th align="center" width="50px">GW</th>
<th align="center" width="50px">PP</th>
<th align="center" width="50px">RF</th>
<th align="center" width="50px">MBS</th>
<th align="center" width="50px">STK</th>
<th align="center" width="50px">WH</th>
<th align="center" width="50px">TOTAL</th>
</tr>
<cfif getorderdetail.recordcount neq 0>
<tr>
<td>ORDER</td>
<td align="center">#val(getorderdetail.qty_gwc)#</td>
<td align="center">#val(getorderdetail.qty_pp)#</td>
<td align="center">#val(getorderdetail.qty_rf)#</td>
<td align="center">#val(getorderdetail.qty_mbs)#</td>
<td align="center">#val(getorderdetail.qty_stock)#</td>
<td align="center">#val(getorderdetail.qty_warehouse)#</td>
<cfset totalqty = val(getorderdetail.qty_gwc) + val(getorderdetail.qty_pp)+ val(getorderdetail.qty_rf) + val(getorderdetail.qty_mbs) + val(getorderdetail.qty_stock)+ val(getorderdetail.qty_warehouse)>
<td align="center">#val(totalqty)#</td>
</tr>
<cfelse>
<tr>
<td>ORDER</td>
<td align="center">0</td>
<td align="center">0</td>
<td align="center">0</td>
<td align="center">0</td>
<td align="center">0</td>
<td align="center">0</td>
<td align="center">0</td>
</tr>
</cfif>

<cfquery name="getdoupdated" datasource="#dts#">
SELECT frrefno FROM iclink WHERE frtype = "DO" 
and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
 group by frrefno
</cfquery>

<cfset billupdated=valuelist(getdoupdated.frrefno)>

<cfquery datasource="#dts#" name="getitem">
	
	select 
	a.itemno,
    a.desp,
    a.price,
   	a.sizeid,a.colorid,a.supp,a.category,a.price2,
    b.location,
	c.balance
	
	from (SELECT itemno,desp,price,sizeid,colorid,supp,category,price2 FROM icitem WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">) as a 
	
	left join 
	(
		select 
		location,
		itemno,
		(select desp from iclocation where location=locqdbf.location) as locationdesp 
		from locqdbf
		where itemno=itemno 
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
        
	) as b on a.itemno=b.itemno 
	
	left join 
	(
		select 
		a.location,
		a.itemno,
		(ifnull(a.locqfield,0)+ifnull(b.sum_in,0)-ifnull(c.sum_out,0)) as balance
		
		from locqdbf as a 
		
		left join
		(
			select 
			location,
			itemno,
			sum(qty) as sum_in 
			
			from ictran
			
			where type in ('RC','CN','OAI','TRIN') 
			and fperiod<>'99'
			and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
			group by location,itemno
			order by location,itemno
		) as b on a.location=b.location and a.itemno=b.itemno
		
		left join
		(
			select 
			location,
            category,
            wos_group,
			itemno,
			sum(qty) as sum_out 
			
			from ictran 
			
			where 
			
                (type in ('DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) or 
				(type='INV' and (dono = "" or dono is null or dono not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">))))
			and fperiod<>'99'
			and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
            and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
			group by location,itemno
			order by location,itemno
		) as c on a.location=c.location and a.itemno=c.itemno 
		where a.itemno=a.itemno
		and a.itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
       
		
	) as c on a.itemno=c.itemno and b.location=c.location 
	
	where a.itemno=a.itemno 
	and b.location<>''

    and a.itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
	order by a.itemno;
</cfquery>
<cfset totalitembalance = 0>
<cfloop query="getitem">
<cfif getitem.location eq 'GWC'>
<cfset gwcbalance = getitem.balance>
<cfelseif  getitem.location eq 'PP'>
<cfset ppbalance = getitem.balance>
<cfelseif  getitem.location eq 'RF'>
<cfset rfbalance = getitem.balance>
<cfelseif  getitem.location eq 'mbs'>
<cfset mbsbalance = getitem.balance>
<cfelseif  getitem.location eq 'stock'>
<cfset stockbalance = getitem.balance>
<cfelseif  getitem.location eq 'warehouse'>
<cfset warehousebalance = getitem.balance>
</cfif>
<cfset totalitembalance = totalitembalance + val(getitem.balance)>
</cfloop>
<tr>
<td>BALANCE</td>
<td><div align="center"><cfif isdefined('gwcbalance')>#gwcbalance#<cfelse>0</cfif></div></td>
<td><div align="center"><cfif isdefined('ppbalance')>#ppbalance#<cfelse>0</cfif></div></td>
<td><div align="center"><cfif isdefined('rfbalance')>#rfbalance#<cfelse>0</cfif></div></td>
<td><div align="center"><cfif isdefined('mbsbalance')>#mbsbalance#<cfelse>0</cfif></div></td>
<td><div align="center"><cfif isdefined('stockbalance')>#stockbalance#<cfelse>0</cfif></div></td>
<td><div align="center"><cfif isdefined('warehousebalance')>#warehousebalance#<cfelse>0</cfif></div></td>
<td><div align="center">#totalitembalance#</div>
</td>
</tr>
<tr>
<td>RESERVE</td>
<td><div align="center">#val(getreservestock.GWC)#</div></td>
<td><div align="center">#val(getreservestock.PP)#</div></td>
<td><div align="center">#val(getreservestock.RF)#</div></td>
<td><div align="center">#val(getreservestock.MBS)#</div></td>
<td><div align="center"></div></td>
<td><div align="center"></div></td>
<td><div align="center">#val(getreservestock.GWC)+val(getreservestock.PP)+val(getreservestock.RF)+val(getreservestock.MBS)#</div>
</td>
</tr>

</table>
</cfoutput>
</cfif>