<cfcomponent>
	<cffunction name="calculate_month_average_cost">
		<cfargument name="dts" required="yes">
		<cfargument name="itemfrom" required="yes">
		<cfargument name="itemto" required="yes">
		
		<!---cfif arguments.itemfrom neq "" and arguments.itemto neq "">
			<cfset critirial = "where a.itemno between "&chr(39)&form.itemfrom&chr(39)& " and "&chr(39)&form.itemto&chr(39)>
			<cfset critirial1 = "and itemno between "&chr(39)&form.itemfrom&chr(39)& " and "&chr(39)&form.itemto&chr(39)>
		<cfelse>
			<cfset critirial = "">
			<cfset critirial1 = "">
		</cfif--->
		
		<!--- Truncate monthcost Table--->
		<cfquery name="truncate_monthcost_table" datasource="#arguments.dts#">
			truncate monthcost;
		</cfquery>
		
		<!--- Calculate Items Info--->
		<cfquery name="calculate_item_info" datasource="#arguments.dts#">
			
			select a.itemno,a.avcost,a.qtybf,(ifnull(a.qtybf,0)*ifnull(a.avcost,0)),0,
			0,ifnull(b.sumqty1,0),ifnull(b.sumamt1,0),ifnull(b.oqty1,0),0,ifnull(c.sumqty2,0),ifnull(c.sumamt2,0),ifnull(c.oqty2,0),0,ifnull(d.sumqty3,0),ifnull(d.sumamt3,0),ifnull(d.oqty3,0),
			0,ifnull(e.sumqty4,0),ifnull(e.sumamt4,0),ifnull(e.oqty4,0),0,ifnull(f.sumqty5,0),ifnull(f.sumamt5,0),ifnull(f.oqty5,0),0,ifnull(g.sumqty6,0),ifnull(g.sumamt6,0),ifnull(g.oqty6,0),
			0,ifnull(h.sumqty7,0),ifnull(h.sumamt7,0),ifnull(h.oqty7,0),0,ifnull(i.sumqty8,0),ifnull(i.sumamt8,0),ifnull(i.oqty8,0),0,ifnull(j.sumqty9,0),ifnull(j.sumamt9,0),ifnull(j.oqty9,0),
			0,ifnull(k.sumqty10,0),ifnull(k.sumamt10,0),ifnull(k.oqty10,0),0,ifnull(l.sumqty11,0),ifnull(l.sumamt11,0),ifnull(l.oqty11,0),0,ifnull(m.sumqty12,0),ifnull(m.sumamt12,0),ifnull(m.oqty12,0),
			0,ifnull(n.sumqty13,0),ifnull(n.sumamt13,0),ifnull(n.oqty13,0),0,ifnull(o.sumqty14,0),ifnull(o.sumamt14,0),ifnull(o.oqty14,0),0,ifnull(p.sumqty15,0),ifnull(p.sumamt15,0),ifnull(p.oqty15,0),
			0,ifnull(q.sumqty16,0),ifnull(q.sumamt16,0),ifnull(q.oqty16,0),0,ifnull(r.sumqty17,0),ifnull(r.sumamt17,0),ifnull(r.oqty17,0),0,ifnull(s.sumqty18,0),ifnull(s.sumamt18,0),
			(ifnull(a.qtybf,0)*ifnull(a.avcost,0)),a.qtybf,a.avcost 
			from icitem as a 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty1,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt1,d.oqty1 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='01' and (type='RC' or type='OAI') and (void = '' or void is null)  
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='01' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty1 from ictran where fperiod='01' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as b on a.itemno=b.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty2,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt2,d.oqty2 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='02' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='02' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty2 from ictran where fperiod='02' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as c on a.itemno=c.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty3,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt3,d.oqty3 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='03' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='03' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty3 from ictran where fperiod='03' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as d on a.itemno=d.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty4,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt4,d.oqty4 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='04' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='04' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty4 from ictran where fperiod='04' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as e on a.itemno=e.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty5,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt5,d.oqty5 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='05' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='05' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty5 from ictran where fperiod='05' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as f on a.itemno=f.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty6,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt6,d.oqty6 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='06' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='06' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty6 from ictran where fperiod='06' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as g on a.itemno=g.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty7,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt7,d.oqty7 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='07' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='07' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty7 from ictran where fperiod='07' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as h on a.itemno=h.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty8,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt8,d.oqty8 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='08' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='08' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty8 from ictran where fperiod='08' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as i on a.itemno=i.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty9,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt9,d.oqty9 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='09' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='09' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty9 from ictran where fperiod='09' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as j on a.itemno=j.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty10,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt10,d.oqty10 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='10' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='10' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty10 from ictran where fperiod='10' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as k on a.itemno=k.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty11,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt11,d.oqty11 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='11' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='11' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty11 from ictran where fperiod='11' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as l on a.itemno=l.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty12,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt12,d.oqty12 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='12' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='12' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty12 from ictran where fperiod='12' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as m on a.itemno=m.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty13,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt13,d.oqty13 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='13' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='13' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty13 from ictran where fperiod='13' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as n on a.itemno=n.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty14,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt14,d.oqty14 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='14' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='14' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty14 from ictran where fperiod='14' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as o on a.itemno=o.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty15,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt15,d.oqty15 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='15' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='15' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty15 from ictran where fperiod='15' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as p on a.itemno=p.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty16,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt16,d.oqty16 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='16' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='16' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty16 from ictran where fperiod='16' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as q on a.itemno=q.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty17,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt17,d.oqty17 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='17' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='17' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty17 from ictran where fperiod='17' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as r on a.itemno=r.itemno 
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty18,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt18,d.oqty18 from icitem as a 
				left join 
				(select itemno,sum(qty)as qty1,sum(amt)as amt1 from ictran where fperiod='18' and (type='RC' or type='OAI') and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as b on a.itemno=b.itemno
				left join 
				(select itemno,sum(qty)as qty2,sum(amt)as amt2 from ictran where fperiod='18' and type='PR' and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as c on a.itemno=c.itemno 
				left join 
				(select itemno,sum(qty)as oqty18 from ictran where fperiod='18' and (type='INV' or type='CS' or type='DN' or type='DO' or type='ISS') and (toinv='' or toinv is null) and (void = '' or void is null) 
                <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
                group by itemno) as d on a.itemno=d.itemno
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
				</cfif>
			) as s on a.itemno=s.itemno 
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				where a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
			</cfif>
            order by a.itemno
		</cfquery>
		
		<!--- Calculate Month Cost --->
		<cfloop index="a" from="1" to="18">
			<cfquery name="calculate_month_cost" datasource="#arguments.dts#">
				update monthcost set 
				cost#a#=((cumamt+amt#a#-(oqty#a-1#*cumcost))/(cumqty+qty#a#-oqty#a-1#)), 
				cumamt=if((cumqty+qty#a#-oqty#a-1#)=0,0,(cumamt+amt#a#-(oqty#a-1#*cumcost))), 
				cumqty=(cumqty+qty#a#-oqty#a-1#), 
				cumcost=cost#a#;
			</cfquery>
		</cfloop>
		
		<!--- Update Month Cost --->
		<cfquery name="update_month_cost" datasource="#arguments.dts#">
			update ictran,(select itemno,cost1,cost2,cost3,cost4,cost5,cost6,cost7,cost8,cost9,cost10,cost11,cost12,cost13,cost14,cost15,cost16,cost17,cost18 from monthcost)as cost 
			set ictran.it_cos=ictran.qty*(case ictran.fperiod when '01' then cost.cost1 when '02' then cost.cost2 when '03' then cost.cost3 when '04' then cost.cost4 when '05' then cost.cost5 when '06' then cost.cost6 when '07' then cost.cost7 when '08' then cost.cost8 when '09' then cost.cost9 when '10' then cost.cost10 when '11' then cost.cost11 when '12' then cost.cost12 when '13' then cost.cost13 when '14' then cost.cost14 when '15' then cost.cost15 when '16' then cost.cost16 when '17' then cost.cost17 else cost.cost18 end) 
			where ictran.itemno=cost.itemno and (ictran.void = '' or ictran.void is null) and (ictran.toinv='' or ictran.toinv is null) and (ictran.type='DO' or ictran.type='ISS' or ictran.type='INV' or ictran.type='CS' or ictran.type='DN' or ictran.type='CN');
		</cfquery>
		
		<cfreturn 0>
	</cffunction>
</cfcomponent>	