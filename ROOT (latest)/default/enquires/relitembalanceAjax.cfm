<cfquery name="getRelItem2" datasource="#dts#">
	select a.itemno, a.relitemno,b.desp,b.despa,b.price,
	ifnull(ifnull(b.qtybf,0)+ifnull(c.sumtotalin,0)-ifnull(d.sumtotalout,0),0) as balance
	from (relitem a,icitem b)
	
	left join 
	(
		select itemno,sum(qty) as sumtotalin 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno in (select relitemno from relitem where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#">)
		and fperiod<>'99'
		and (void = '' or void is null)
		group by itemno
	) as c on a.relitemno=c.itemno
	
	left join 
	(
		select itemno,sum(qty) as sumtotalout 
		from ictran 
		where type in ('INV','DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) 
		and itemno in (select relitemno from relitem where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#">)
		and fperiod<>'99'
		and (void = '' or void is null)
		and (toinv='' or toinv is null) 
		group by itemno
	) as d on a.relitemno=d.itemno
	
	where a.relitemno=b.itemno 
	and a.itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#"> 
</cfquery>
<table width="600" align="center" class="data">
	<tr>
		<th width="150">Related Item No.</th>
		<th width="250">Description</th>
		<th width="100">Stock Balance</th>
		<th width="100">Unit Price</th>
	</tr>
	<cfoutput query="getRelItem2">
		<tr>
			<td>#getRelItem2.relitemno#</td>
			<td>#getRelItem2.desp#</td>
			<td><div align="center"><font color="FF0000">#getRelItem2.balance#</font></div></td>
			<td align="right">#numberformat(getRelItem2.price,",.____")#</td>
		</tr>
	</cfoutput>
</table>