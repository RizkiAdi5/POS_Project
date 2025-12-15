<cfsetting showdebugoutput="no">
<html>
<head>
	<link rel="stylesheet" href="stylesheet/stylesheet.css"/>
</head>
<body>

<cfif url.type eq "top10produstsales_val_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select b.itemno, b.desp, sum(a.qty) as sumqty, sum(a.amt) as sumamt 
		from ictran a,icitem b
		where (a.type = 'INV' or a.type = 'DN' or a.type = 'CS') 
		and a.void = ''
		and a.fperiod <> '99'
		and a.wos_date between #date1# and #date2#
		and a.itemno = b.itemno
		group by b.itemno,b.desp
		order by sumamt
		desc limit 10
	</cfquery>
	<!--- <cfdump var="#getInfo#"><cfabort> --->
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Item No" yAxisTitle="Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumamt" itemColumn="itemno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>
	
<cfelseif url.type eq "top10produstsales_val_by_lastmonth">
	<cfset thismthdate = createdate(year(now()),month(now()),1)>
	<cfset date1 = dateadd("m",-1,thismthdate)>
	<cfset date2 = createdate(year(date1),month(date1),DaysInMonth(date1))>
	
	<cfquery name="getInfo" datasource="#dts#">
		select b.itemno, b.desp, sum(a.qty) as sumqty, sum(a.amt) as sumamt
		from ictran a,icitem b
		where (a.type = 'INV' or a.type = 'DN' or a.type = 'CS') 
		and a.void = ''
		and a.wos_date between #date1# and #date2#
		and a.itemno = b.itemno
		group by b.itemno,b.desp
		order by sumamt
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Item No" yAxisTitle="Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumamt" itemColumn="itemno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10sales_cat_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select b.category as category, sum(a.qty) as sumqty, sum(a.amt) as sumamt 
		from ictran a,icitem b
		where a.itemno = b.itemno 
		and (a.type = 'INV' or a.type = 'DN' or a.type = 'CS') 
		and a.void = ''
		and a.fperiod <> '99'
		and a.wos_date between #date1# and #date2#
		group by b.category
		order by sumamt
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Category" yAxisTitle="Grand Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumamt" itemColumn="category" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10sales_agent_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select agenno, sum(grand) as sumgrand 
		from artran 
		where (type = 'INV' or type = 'DN' or type = 'CS') 
		and void = ''
		and fperiod <> '99'
		and agenno <> ''
		and wos_date between #date1# and #date2#
		group by agenno
		order by sumgrand
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Agent No" yAxisTitle="Grand Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumgrand" itemColumn="agenno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10sales_cust_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select custno,name, sum(grand) as sumgrand
		from artran
		where (type = 'INV' or type = 'DN' or type = 'CS') 
		and void = ''
		and fperiod <> '99'
		and custno <> ''
		and wos_date between #date1# and #date2#
		group by custno,name
		order by sumgrand
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Cust No" yAxisTitle="Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumgrand" itemColumn="custno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10sales_returnitem_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select b.itemno, b.desp, sum(a.qty) as sumqty
		from ictran a,icitem b
		where a.type = 'CN'
		and a.void = ''
		and a.fperiod <> '99'
		and a.wos_date between #date1# and #date2#
		and a.itemno = b.itemno
		group by b.itemno, b.desp
		order by sumqty
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Item No" yAxisTitle="Quantity" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumqty" itemColumn="itemno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>
	
<cfelseif url.type eq "top10productsales_qty_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select b.itemno, b.desp, sum(a.qty) as sumqty, sum(a.amt) as sumamt 
		from ictran a,icitem b
		where (a.type = 'INV' or a.type = 'DN' or a.type = 'CS') 
		and a.void = ''
		and a.fperiod <> '99'
		and a.wos_date between #date1# and #date2#
		and a.itemno = b.itemno
		group by b.itemno, b.desp
		order by sumqty
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Item No" yAxisTitle="Quantity" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumqty" itemColumn="itemno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10productsales_qty_by_lastmonth">
	<cfset thismthdate = createdate(year(now()),month(now()),1)>
	<cfset date1 = dateadd("m",-1,thismthdate)>
	<cfset date2 = createdate(year(date1),month(date1),DaysInMonth(date1))>
	
	<cfquery name="getInfo" datasource="#dts#">
		select b.itemno, b.desp, sum(a.qty) as sumqty, sum(a.amt) as sumamt 
		from ictran a,icitem b
		where (a.type = 'INV' or a.type = 'DN' or a.type = 'CS') 
		and a.void = ''
		and a.fperiod <> '99'
		and a.wos_date between #date1# and #date2#
		and a.itemno = b.itemno
		group by b.itemno, b.desp
		order by sumqty
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Item No" yAxisTitle="Quantity" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumqty" itemColumn="itemno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10itempurchase_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select b.itemno, b.desp, sum(a.qty) as sumqty, sum(a.amt) as sumamt 
		from ictran a,icitem b
		where a.type = 'RC'
		and a.void = ''
		and a.fperiod <> '99'
		and a.wos_date between #date1# and #date2#
		and a.itemno = b.itemno
		group by b.itemno, b.desp
		order by sumamt
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Item No" yAxisTitle="Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumamt" itemColumn="itemno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10purchase_cat_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select b.category as category, sum(a.qty) as sumqty, sum(a.amt) as sumamt 
		from ictran a,icitem b
		where a.itemno = b.itemno 
		and a.type = 'RC'
		and a.void = ''
		and a.fperiod <> '99'
		and a.wos_date between #date1# and #date2#
		group by b.category
		order by sumqty
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Category" yAxisTitle="Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumamt" itemColumn="category" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10purchase_vendor_by_currmonth">
	<cfset date1 = createdate(year(now()),month(now()),1)>
	<cfset date2 = createdate(year(now()),month(now()),DaysInMonth(date1))>
	<cfquery name="getInfo" datasource="#dts#">
		select custno,name, sum(grand) as sumgrand
		from artran
		where type = 'RC'
		and void = ''
		and fperiod <> '99'
		and custno <> ''
		and wos_date between #date1# and #date2#
		group by custno,name
		order by sumgrand
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Vendor No" yAxisTitle="Grand Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumgrand" itemColumn="custno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>

<cfelseif url.type eq "top10outstanding_so_by_agent">
	<cfquery name="getInfo" datasource="#dts#">
		select a.agenno as agenno, sum((b.qty-b.writeoff-b.shipped)*b.price) as sumgrand 
		from artran a, ictran b
		where b.type = 'SO'
		and b.void = ''
		and b.fperiod <> '99'
		and a.agenno <> ''
		group by agenno
		order by sumgrand
		desc limit 10
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Agent No" yAxisTitle="Grand Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumgrand" itemColumn="agenno" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33"/></cfchart>
	
<cfelseif url.type eq "outstanding_so_by_pd">
	<cfquery name="getInfo" datasource="#dts#">
		select fperiod, sum((qty-writeoff-shipped)*price) as sumgrand 
		from ictran 
		where type = 'SO'
		and void = ''
		and fperiod <> '99'
		group by fperiod
		order by fperiod
	</cfquery>
	
	<cfchart backgroundcolor="eff8ff" fontsize="10" xAxisTitle="Period" yAxisTitle="Grand Value" title="" showborder="no" show3d="no" chartheight="300" chartwidth="400">
	<cfchartseries type="bar" query="getInfo" valueColumn="sumgrand" itemColumn="fperiod" colorlist="1E90FF,48D1CC,F08080,DDA0DD,008000,996699,CCCC99,FFCCCC,333366,FFFF33,99CC00,00CC99,FF0066,6699FF,FFCC99,CCCCCC,FF99FF,6600FF"/></cfchart>
<cfelse>

</cfif>

</body>
</html>