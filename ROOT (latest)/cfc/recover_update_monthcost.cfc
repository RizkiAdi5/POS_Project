<cfcomponent>
	<cffunction name="monthcost">
		<cfargument name="dts" required="yes" type="any">
		
		<cfquery name="truncate_monthcost_table" datasource="#arguments.dts#">
			truncate monthcost_last_year;
		</cfquery>
		
		<cfquery name="get_last_year" datasource="#arguments.dts#">
			select lastaccyear 
			from gsetup;
		</cfquery>
		
		<cfquery name="calculate_item_info" datasource="#arguments.dts#">
			insert into monthcost_last_year 
			select a.itemno,
			a.avcost,aa.qtybf,(ifnull(a.qtybf,0)*ifnull(a.avcost,0)),0,
			0,ifnull(b.sumqty1,0),ifnull(b.sumamt1,0),ifnull(b.oqty1,0),
			0,ifnull(c.sumqty2,0),ifnull(c.sumamt2,0),ifnull(c.oqty2,0),
			0,ifnull(d.sumqty3,0),ifnull(d.sumamt3,0),ifnull(d.oqty3,0),
			0,ifnull(e.sumqty4,0),ifnull(e.sumamt4,0),ifnull(e.oqty4,0),
			0,ifnull(f.sumqty5,0),ifnull(f.sumamt5,0),ifnull(f.oqty5,0),
			0,ifnull(g.sumqty6,0),ifnull(g.sumamt6,0),ifnull(g.oqty6,0),
			0,ifnull(h.sumqty7,0),ifnull(h.sumamt7,0),ifnull(h.oqty7,0),
			0,ifnull(i.sumqty8,0),ifnull(i.sumamt8,0),ifnull(i.oqty8,0),
			0,ifnull(j.sumqty9,0),ifnull(j.sumamt9,0),ifnull(j.oqty9,0),
			0,ifnull(k.sumqty10,0),ifnull(k.sumamt10,0),ifnull(k.oqty10,0),
			0,ifnull(l.sumqty11,0),ifnull(l.sumamt11,0),ifnull(l.oqty11,0),
			0,ifnull(m.sumqty12,0),ifnull(m.sumamt12,0),ifnull(m.oqty12,0),
			(ifnull(a.qtybf,0)*ifnull(a.avcost,0)),a.qtybf,a.avcost 
			from icitem as a 
			left join
			(
				select itemno,qtybf 
				from icitem_last_year 
				order by itemno
			) as aa on a.itemno=aa.itemno
			<!--- Month 1 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty1,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt1,d.oqty1 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-11,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-11,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-11,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-11,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-11,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-11,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-11,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-11,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-11,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-11,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty1 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-11,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-11,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-11,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-11,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-11,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as b on a.itemno=b.itemno 
			<!--- Month 2 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty2,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt2,d.oqty2 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-10,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-10,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-10,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-10,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-10,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-10,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-10,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-10,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-10,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-10,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty2 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-10,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-10,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-10,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-10,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-10,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as c on a.itemno=c.itemno 
			<!--- Month 3 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty3,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt3,d.oqty3 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-9,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-9,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-9,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-9,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-9,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-9,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-9,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-9,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-9,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-9,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty3 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-9,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-9,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-9,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-9,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-9,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as d on a.itemno=d.itemno 
			<!--- Month 4 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty4,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt4,d.oqty4 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-8,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-8,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-8,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-8,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-8,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-8,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-8,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-8,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-8,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-8,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty4 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-8,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-8,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-8,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-8,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-8,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as e on a.itemno=e.itemno 
			<!--- Month 5 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty5,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt5,d.oqty5 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-7,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-7,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-7,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-7,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-7,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-7,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-7,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-7,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-7,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-7,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty5 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-7,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-7,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-7,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-7,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-7,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as f on a.itemno=f.itemno 
			<!--- Month 6 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty6,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt6,d.oqty6 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-6,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-6,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-6,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-6,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-6,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-6,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-6,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-6,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-6,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-6,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty6 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-6,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-6,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-6,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-6,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-6,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as g on a.itemno=g.itemno 
			<!--- Month 7 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty7,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt7,d.oqty7 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-5,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-5,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-5,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-5,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-5,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-5,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-5,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-5,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-5,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-5,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty7 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-5,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-5,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-5,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-5,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-5,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as h on a.itemno=h.itemno 
			<!--- Month 8 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty8,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt8,d.oqty8 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-4,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-4,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-4,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-4,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-4,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-4,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-4,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-4,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-4,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-4,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty8 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-4,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-4,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-4,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-4,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-4,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as i on a.itemno=i.itemno 
			<!--- Month 9 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty9,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt9,d.oqty9 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-3,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-3,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-3,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-3,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-3,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-3,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-3,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-3,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-3,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-3,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty9 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-3,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-3,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-3,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-3,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-3,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as j on a.itemno=j.itemno 
			<!--- Month 10 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty10,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt10,d.oqty10 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-2,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-2,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-2,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-2,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-2,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-2,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-2,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-2,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-2,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-2,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty10 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-2,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-2,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-2,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-2,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-2,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as k on a.itemno=k.itemno 
			<!--- Month 11 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty11,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt11,d.oqty11 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-1,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-1,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-1,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-1,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-1,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-1,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-1,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-1,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-1,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-1,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty11 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-1,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-1,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-1,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-1,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-1,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as l on a.itemno=l.itemno 
			<!--- Month 12 --->
			left join 
			(
				select a.itemno,(ifnull(b.qty1,0)-ifnull(c.qty2,0)) as sumqty12,(ifnull(b.amt1,0)-ifnull(c.amt2,0)) as sumamt12,d.oqty12 
				from icitem as a 
				left join 
				(
					select itemno,sum(qty)as qty1,sum(amt)as amt1 
					from ictran 
					where type in ('RC','OAI') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-0,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-0,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-0,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-0,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-0,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as b on a.itemno=b.itemno
				left join 
				(
					select itemno,sum(qty)as qty2,sum(amt)as amt2 
					from ictran 
					where type='PR'
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-0,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-0,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-0,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-0,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-0,get_last_year.lastaccyear))#'
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as c on a.itemno=c.itemno 
				left join 
				(
					select itemno,sum(qty)as oqty12 
					from ictran 
					where type in ('INV','CS','DN','DO','ISS') 
					and fperiod='99' 
					and wos_date between 
					'#datepart("yyyy",dateadd("m",-0,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-0,get_last_year.lastaccyear))#-01'
					and 
					'#datepart("yyyy",dateadd("m",-0,get_last_year.lastaccyear))#-#datepart("m",dateadd("m",-0,get_last_year.lastaccyear))#-#daysinmonth(dateadd("m",-0,get_last_year.lastaccyear))#'
					and toinv='' 
					and (void = '' or void is null) 
					group by itemno 
					order by itemno 
				) as d on a.itemno=d.itemno
			) as m on a.itemno=m.itemno 
			
			order by a.itemno;
		</cfquery>
		
		<cfloop index="a" from="1" to="12">
			<cfquery name="calculate_month_cost" datasource="#arguments.dts#">
				update monthcost_last_year set 
				cost#a#=((cumamt+amt#a#-(oqty#a-1#*cumcost))/(cumqty+qty#a#-oqty#a-1#)), 
				cumamt=if((cumqty+qty#a#-oqty#a-1#)=0,0,(cumamt+amt#a#-(oqty#a-1#*cumcost))), 
				cumqty=(cumqty+qty#a#-oqty#a-1#), 
				cumcost=cost#a#;
			</cfquery>
		</cfloop>
		
		<cfquery name="update_month_cost" datasource="#arguments.dts#">
			update icitem,monthcost_last_year set 
			icitem.avcost=monthcost_last_year.cumcost 
			where icitem.itemno=monthcost_last_year.itemno;
		</cfquery>		
	</cffunction>
</cfcomponent>