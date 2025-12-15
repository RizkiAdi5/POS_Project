<html>
<head>
<title>Physical Worksheet Report</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
	function calculate_adjusted_qty(balance,actual)
	{
		var qty_balance=parseFloat(balance);
		var qty_actual=parseFloat(actual);
		var result=qty_balance-qty_actual;
		return result;
	}
</script>
<cfif form.date neq "">
<cfset ndate = createdate(right(form.date,4),mid(form.date,4,2),left(form.date,2))>
<cfset form.date = ndate >
</cfif>
</head>

<cfquery name="getdoupdated" datasource="#dts#">
SELECT frrefno FROM iclink WHERE frtype = "DO" 
<cfif form.itemfrom neq "" and form.itemto neq "">
	and itemno between '#form.itemfrom#' and '#form.itemto#'
</cfif> group by frrefno
</cfquery>
<cfset billupdated=valuelist(getdoupdated.frrefno)>

<cfinclude template="../../CFC/convert_single_double_quote_script.cfm">

<cfquery name="getgeneral" datasource="#dts#">
	select compro from gsetup;
</cfquery>
<cfset intrantype="'RC','CN','OAI','TRIN'">
<cfif lcase(HcomID) eq "eocean_i">
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU','CT'">
<cfelse>
	<cfset outtrantype="'DO','DN','PR','CS','ISS','OAR','TROU'">
</cfif>

<body>
<cfset totalqty=0>
<cfset totalact=0>
<table align="center" class="data" width="100%" border="0" cellspacing="0">
	<cfoutput>
	<tr>
		<td colspan="7"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Inventory Physical Worksheet</strong></font></div></td>
	</tr>
	<cfif form.catefrom neq "" and form.cateto neq "">
		<tr>
			<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATE: #form.catefrom# - #form.cateto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.groupfrom neq "" and form.groupto neq "">
		<tr>
			<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.itemfrom neq "" and form.itemto neq "">
		<tr>
			<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM.NO. #form.itemfrom# - #form.itemto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.period neq "">
		<tr>
			<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.period#</font></div></td>
		</tr>
	</cfif>
	<cfif form.date neq "">
		<tr>
			<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.date,"dd-mm-yyyy")#</font></div></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
		<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd-mm-yyyy")#</font></div></td>
	</tr>
	<tr>
		<td colspan="7"><hr/></td>
	</tr>
	<tr>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">NO.</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">ITEM NO.</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">ITEM DESCRIPTION</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">BOOK QTY</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">ACTUAL QTY</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">ADJ.QTY</font></div></td>
		<td><div align="center"><font size="2" face="Times New Roman,Times,serif">SHELF</font></div></td>
	</tr>
	<tr>
		<td colspan="7"><hr/></td>
	</tr>

	<cfquery name="getiteminfo" datasource="#dts#">
		select a.itemno,a.desp,a.ucost,a.unit,b.balance,a.qtyactual,a.shelf 
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
			<cfif form.catefrom neq "" and form.cateto neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif form.catefrom neq "" and form.cateto neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif form.itemfrom neq "" and form.itemto neq "">
				and a.itemno between '#form.itemfrom#' and '#form.itemto#'
			</cfif>
			<cfif form.shelffrom neq "" and form.shelfto neq "">
				and a.shelf between '#form.shelffrom#' and '#form.shelfto#'
			</cfif>
			order by a.itemno
		) as b on a.itemno=b.itemno 
	
		where a.itemno=a.itemno 
		<cfif form.catefrom neq "" and form.cateto neq "">
			and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
		</cfif>
		<cfif form.catefrom neq "" and form.cateto neq "">
			and a.category between '#form.catefrom#' and '#form.cateto#'
		</cfif>
		<cfif form.itemfrom neq "" and form.itemto neq "">
			and a.itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
		<cfif form.shelffrom neq "" and form.shelfto neq "">
			and a.shelf between '#form.shelffrom#' and '#form.shelfto#'
		</cfif>
		<cfif not isdefined("form.include_stock")>
			and b.balance<>0
		</cfif>
        and (a.itemtype <> 'SV' or a.itemtype is null)
        <cfif lcase(HcomID) eq "simplysiti_i">
            order by a.itemno;
            <cfelse>
		order by a.itemno,a.shelf;
        </cfif>
	</cfquery>
	
	<cfform name="physical_worksheet_adjust" action="physical_worksheet_update_stock.cfm" method="post" target="_BLANK">
		<input type="hidden" name="generate_adjustment_transaction" value="#iif(isdefined('form.generate_adjustment_transaction'),DE('yes'),DE('no'))#">
		<input type="hidden" name="update_actual_qty" value="#iif(isdefined('form.update_actual_qty'),DE('yes'),DE('no'))#">
		<input type="hidden" name="period" value="#form.period#">
		<input type="hidden" name="date" value="#dateformat(form.date,'YYYY-MM-DD')#">
		<input type="hidden" name="totalitem" value="#getiteminfo.recordcount#">
		<cfloop query="getiteminfo">
			<tr onClick="javascript:document.physical_worksheet_adjust.actualqty#getiteminfo.currentrow#.select();" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td nowrap>
					<div align="left"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.currentrow#.</font></div>
				</td>
				<td nowrap>
					<input type="hidden" id="itemno#getiteminfo.currentrow#" name="itemno#getiteminfo.currentrow#" value="#convertquote(getiteminfo.itemno)#">
					<div align="left"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.itemno#</font></div>
				</td>
				<td nowrap>
					<input type="hidden" id="desp#getiteminfo.currentrow#" name="desp#getiteminfo.currentrow#" value="#convertquote(getiteminfo.desp)#">
					<div align="left"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.desp#</font></div>
				</td>
				<td nowrap>
					<input type="hidden" id="balance#getiteminfo.currentrow#" name="balance#getiteminfo.currentrow#" value="#convertquote(getiteminfo.balance)#">
					<div align="right"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.balance#</font></div>
				</td>
				<td nowrap>
					<input type="hidden" id="unit#getiteminfo.currentrow#" name="unit#getiteminfo.currentrow#" value="#convertquote(getiteminfo.unit)#">
					<div align="right"><cfinput type="text" id="actualqty#getiteminfo.currentrow#" name="actualqty#getiteminfo.currentrow#" value="#getiteminfo.qtyactual#" size="5" message="Please Enter A Correct Quantity !" required="no" validate="float" onKeyUp="javascript:document.physical_worksheet_adjust.adjqty#getiteminfo.currentrow#.value=calculate_adjusted_qty(document.physical_worksheet_adjust.balance#getiteminfo.currentrow#.value,document.physical_worksheet_adjust.actualqty#getiteminfo.currentrow#.value);"></div>
				</td>
				<td nowrap>
					<input type="hidden" id="ucost#getiteminfo.currentrow#" name="ucost#getiteminfo.currentrow#" value="#convertquote(getiteminfo.ucost)#">
					<div align="right"><input type="text" id="adjqty#getiteminfo.currentrow#" name="adjqty#getiteminfo.currentrow#" value="#val(getiteminfo.balance)-val(getiteminfo.qtyactual)#" size="5" readonly></div>
				</td>
				<td nowrap>
					<div align="center"><font size="2" face="Times New Roman,Times,serif">#getiteminfo.shelf#</font></div>
				</td>
			</tr>
            <cfset totalqty=totalqty+val(getiteminfo.balance)>
            <cfset totalact=totalact+val(getiteminfo.qtyactual)>
		</cfloop>
    <tr><td colspan="100%"><hr></td></tr>
    <tr>
    <td colspan="2"></td>
    <td>Total :</td>
    <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#totalqty#</font></div></td>
    <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#totalact#</font></div></td>
    </tr>
		<tr>
			<td colspan="7"><hr/></td>
		</tr>
		<tr align="center">
			<td colspan="7">
				<input type="submit" name="Submit" value="Submit">
				<input type="reset" name="Reset" value="Reset">
			</td>
		</tr>
	</cfform>
</cfoutput>

</table>
</body>
</html>