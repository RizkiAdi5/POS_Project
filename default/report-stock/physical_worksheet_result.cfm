<html>
<head>
<title>Physical Worksheet Report</title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>
<cfif form.date neq "">
<cfset ndate = createdate(right(form.date,4),mid(form.date,4,2),left(form.date,2))>
<cfset form.date = ndate >
</cfif>
<cfset intrantype="'RC','CN','OAI','TRIN'">
<cfif lcase(HcomID) eq "eocean_i">
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU','CT'">
<cfelse>
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU'">
</cfif>

<cfquery name="getdoupdated" datasource="#dts#">
SELECT frrefno FROM iclink WHERE frtype = "DO" 
<cfif form.itemfrom neq "" and form.itemto neq "">
	and itemno between '#form.itemfrom#' and '#form.itemto#'
</cfif> group by frrefno
</cfquery>
<cfset billupdated=valuelist(getdoupdated.frrefno)>

<cfset totalqty=0>
<cfset totalact=0>

<cfquery name="getgeneral" datasource="#dts#">
	select compro from gsetup;
</cfquery>

<cfquery name="getgroup" datasource="#dts#">
	select distinct ifnull(a.wos_group,'') as wos_group,(select desp from icgroup where wos_group=a.wos_group) as groupdesp
	from icitem as a 
	
	left join
	(
		select a.itemno,(ifnull(a.qtybf,0)+ifnull(b.sum_in,0)-ifnull(c.sum_out,0)) as balance
		from icitem as a
		
		left join
		(
			select itemno,sum(qty) as sum_in 
			from ictran
			where type in (#PreserveSingleQuotes(intrantype)#) 
            and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.period neq "">
				and fperiod <='#form.period#' and fperiod<>'99'
			<cfelse>
				and fperiod<>'99'
			</cfif>
			<cfif form.date neq "">
				and wos_date <= '#lsdateformat(form.date,"yyyy-mm-dd")#'  
			</cfif>
			group by itemno
			order by itemno
		) as b on a.itemno=b.itemno
		
		left join
		(
			select itemno,sum(qty) as sum_out 
			from ictran
			where (type in (#PreserveSingleQuotes(outtrantype)#) or 
            (type='INV' and (dono = "" or dono is null or dono not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">))))
            and (void = '' or void is null)
			and (linecode <> 'SV' or linecode is null)
			<cfif form.period neq "">
				and fperiod <='#form.period#' and fperiod<>'99'
			<cfelse>
				and fperiod<>'99'
			</cfif>
			<cfif form.date neq "">
				and wos_date <= '#lsdateformat(form.date,"yyyy-mm-dd")#' 
			</cfif>
			group by itemno
			order by itemno
		) as c on a.itemno=c.itemno
		
		where a.itemno=a.itemno 
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			and a.category between '#form.catefrom#' and '#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
			and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and a.itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
		<cfif form.shelffrom neq "" and form.shelfto neq "">
			and a.shelf between '#form.shelffrom#' and '#form.shelfto#'
		</cfif>
		order by a.itemno
	) as b on a.itemno=b.itemno 

	where a.itemno=a.itemno 
	<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and a.category between '#form.catefrom#' and '#form.cateto#'
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
	</cfif>
	<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and a.itemno between '#form.itemfrom#' and '#form.itemto#'
	</cfif>
	<cfif form.shelffrom neq "" and form.shelfto neq "">
		and a.shelf between '#form.shelffrom#' and '#form.shelfto#'
	</cfif>
    and (a.itemtype <> 'SV' or a.itemtype is null)
	<cfif not isdefined("form.include_stock")>
		and b.balance<>0
	</cfif>
	group by a.wos_group
	order by a.wos_group;
</cfquery>

<body>

<table align="center" width="100%" border="0" cellspacing="0">
	<cfoutput>
	<tr>
		<td colspan="8"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Inventory Physical Worksheet</strong></font></div></td>
	</tr>
	<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		<tr>
			<td colspan="8"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATE: #form.catefrom# - #form.cateto#</font></div></td>
		</tr>
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		<tr>
			<td colspan="8"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
		</tr>
	</cfif>
	<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		<tr>
			<td colspan="8"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM.NO. #form.itemfrom# - #form.itemto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.period neq "">
		<tr>
			<td colspan="8"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.period#</font></div></td>
		</tr>
	</cfif>
	<cfif form.date neq "">
		<tr>
			<td colspan="8"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #form.date#</font></div></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
		<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd-mm-yyyy")#</font></div></td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="8"><hr/></td>
	</tr>
	<tr>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">NO.</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">ITEM NO.</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">ITEM DESCRIPTION</font></div></td>
		<td><div align="center"><font size="2" face="Times New Roman,Times,serif">UNIT MEASURED</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">BOOK QTY</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">ACTUAL QTY</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">ADJ.QTY</font></div></td>
		<td><div align="center"><font size="2" face="Times New Roman,Times,serif">SHELF</font></div></td>
	</tr>
	<tr>
		<td colspan="8"><hr/></td>
	</tr>
	<cfoutput query="getgroup">
		<cfset wos_group = getgroup.wos_group>
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong><u>GROUP: #getgroup.wos_group#</u></strong></font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman,Times,serif"><strong><u>#getgroup.groupdesp#</u></strong></font></div></td>
		</tr>
		<cfquery name="getiteminfo" datasource="#dts#">
			select a.itemno,a.desp,a.unit,b.balance,a.qtyactual,a.shelf 
			from icitem as a 
			
			left join
			(
				select a.itemno,(ifnull(a.qtybf,0)+ifnull(b.sum_in,0)-ifnull(c.sum_out,0)) as balance
				from icitem as a
				
				left join
				(
					select itemno,sum(qty) as sum_in 
					from ictran
					where type in (#PreserveSingleQuotes(intrantype)#) 
                    and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null)
					<cfif form.period neq "">
						and fperiod <='#form.period#' and fperiod<>'99'
					<cfelse>
						and fperiod<>'99'
					</cfif>
					<cfif form.date neq "">
						and wos_date <= '#lsdateformat(form.date,"yyyy-mm-dd")#' 
					</cfif>
					group by itemno
					order by itemno
				) as b on a.itemno=b.itemno
				
				left join
				(
					select itemno,sum(qty) as sum_out 
					from ictran
					where (type in (#PreserveSingleQuotes(outtrantype)#) or 
            (type='INV' and (dono = "" or dono is null or dono not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#billupdated#">))))
                    and (void = '' or void is null)
					and (linecode <> 'SV' or linecode is null)
					<cfif form.period neq "">
					and fperiod <='#form.period#' and fperiod<>'99'
					<cfelse>
					and fperiod<>'99'
					</cfif>
					<cfif form.date neq "">
					and wos_date <= '#lsdateformat(form.date,"yyyy-mm-dd")#' 
					</cfif>
					group by itemno
					order by itemno
				) as c on a.itemno=c.itemno
				
				where a.itemno=a.itemno 
				and <cfif wos_group eq "">(a.wos_group = '#wos_group#' or a.wos_group is null)<cfelse>a.wos_group = '#wos_group#'</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and a.itemno between '#form.itemfrom#' and '#form.itemto#'
				</cfif>
				<cfif form.shelffrom neq "" and form.shelfto neq "">
				and a.shelf between '#form.shelffrom#' and '#form.shelfto#'
				</cfif>
				order by a.itemno
			) as b on a.itemno=b.itemno 
		
			where a.itemno=a.itemno 
			and <cfif wos_group eq "">(a.wos_group = '#wos_group#' or a.wos_group is null)<cfelse>a.wos_group = '#wos_group#'</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and a.itemno between '#form.itemfrom#' and '#form.itemto#'
			</cfif>
			<cfif form.shelffrom neq "" and form.shelfto neq "">
			and a.shelf between '#form.shelffrom#' and '#form.shelfto#'
			</cfif>
			<cfif not isdefined("form.include_stock")>
			and b.balance<>0
			</cfif>
            <cfif lcase(HcomID) eq "simplysiti_i">
            order by a.itemno
            <cfelse>
			order by a.itemno,a.shelf;
            </cfif>
		</cfquery>
		
		<cfloop query="getiteminfo">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.currentrow#.</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.itemno#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.desp#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.unit#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.balance#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.qtyactual#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman,Times,serif">#val(getiteminfo.balance)-val(getiteminfo.qtyactual)#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.shelf#</font></div></td>
			</tr>
            <cfset totalqty=totalqty+val(getiteminfo.balance)>
            <cfset totalact=totalact+val(getiteminfo.qtyactual)>
            
		</cfloop>
		<tr>
			<td><br/></td>
		</tr>
	</cfoutput>
    <cfoutput>
    <tr><td colspan="100%"><hr></td></tr>
    <tr>
    <td colspan="3"></td>
    <td>Total :</td>
    <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#totalqty#</font></div></td>
    <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#totalact#</font></div></td>
    </tr>
    </cfoutput>
</table>

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>