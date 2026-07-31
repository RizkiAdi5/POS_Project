<cfparam name="url.type" default="">
<cfif url.type EQ 'type1'>
	<cfquery name="getLast5Months" datasource="#dts#">
		SELECT custno,name, SUM(grand) AS sumgrand
		FROM artran
		WHERE (type = 'INV' OR type = 'DN' OR type = 'CS') 
		AND void = ''
		AND fperiod <> '99'
		AND custno <> ''
		GROUP BY fperiod
		ORDER BY fperiod DESC 
        LIMIT 5;
	</cfquery>
</cfif>
<cfif url.type EQ 'type2'>
	<cfquery name="getTop5Customers" datasource="#dts#">
		SELECT custno,name, SUM(grand) AS sumgrand
		FROM artran
		WHERE (type = 'INV' OR type = 'DN' OR type = 'CS') 
		AND void = ''
		AND fperiod <> '99'
		AND custno <> ''
		GROUP BY custno,name
		ORDER BY sumgrand DESC 
        LIMIT 5;
	</cfquery>
</cfif>
<!--- E-Menu: peak ordering hours for last 7 days (order count by hour) --->
<cfif url.type EQ 'type3'>
	<cftry>
		<cfquery name="getEMenuPeakHours" datasource="#dts#">
			SELECT HOUR(o.created_at) AS hour_num,
				CONCAT(LPAD(HOUR(o.created_at), 2, '0'), ':00') AS hour_label,
				COUNT(*) AS order_count
			FROM app_orders o
			WHERE o.status NOT IN ('cancelled')
			AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)
			AND o.created_at < CURDATE() + INTERVAL 1 DAY
			GROUP BY HOUR(o.created_at)
			ORDER BY hour_num ASC
		</cfquery>
		<cfset emenuChartOk = true>
		<cfset emenuChartEmpty = (getEMenuPeakHours.recordCount EQ 0)>
		<cfcatch type="any">
			<cfset emenuChartOk = false>
			<cfset emenuChartErr = "E-Menu peak hours chart is unavailable: #cfcatch.message#">
		</cfcatch>
	</cftry>
</cfif>
<!--- E-Menu: top lines by line revenue for current month (app_order_items + app_orders) --->
<cfif url.type EQ 'type4'>
	<cftry>
		<cfquery name="getEmenuTopItemsMonth" datasource="#dts#">
			SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
				SUM(i.subtotal) AS line_revenue
			FROM app_order_items i
			INNER JOIN app_orders o ON o.order_id = i.order_id
			WHERE o.status NOT IN ('cancelled')
			AND o.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
			AND o.created_at < DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
			GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
			ORDER BY line_revenue DESC
			LIMIT 5
		</cfquery>
		<cfset emenuTopOk = true>
		<cfset emenuTopEmpty = (getEmenuTopItemsMonth.recordCount EQ 0)>
		<cfcatch type="any">
			<cfset emenuTopOk = false>
			<cfset emenuTopErr = "E-Menu menu chart is unavailable: #cfcatch.message#">
		</cfcatch>
	</cftry>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Chart</title>
</head>
<body style="background:#FFF1EB;">

<cfif url.type EQ 'type1'>
    <cfchart
		format="png"
        backgroundColor="FFF1EB"
        <!---
        dataBackgroundColor="EBF6F0"
        foregroundColor="708782"
		--->
        chartheight="240"
        chartwidth="450"
        xAxisTitle="Month"
        yAxisTitle="Value"
        showborder="no"
        show3d="no"
        >
        <cfchartseries
            type="bar"
            seriesColor="CF5D5D" 
            paintStyle="light"
            query="getLast5Months" 
            valueColumn="sumgrand" 
            itemColumn="fperiod"
            >
            
        </cfchartseries>
    </cfchart>
</cfif>

<cfif url.type EQ 'type2'>
    <cfchart
		format="png"
        backgroundColor="FFF1EB"
        chartheight="240"
        chartwidth="450"
        xAxisTitle="Customer"
        yAxisTitle="Value"
        showborder="no"
        show3d="no"
        >
        <cfchartseries
            type="bar"
            seriesColor="CF5D5D" 
            paintStyle="light"
            query="getTop5Customers" 
            valueColumn="sumgrand" 
            itemColumn="name"
            >
            
        </cfchartseries>
    </cfchart>
</cfif>

<cfif url.type EQ 'type3'>
	<cfif isDefined("emenuChartOk") AND emenuChartOk>
		<cfif isDefined("emenuChartEmpty") AND emenuChartEmpty>
			<p style="font-family:Verdana,Geneva,sans-serif;font-size:12px;color:#666666;padding:24px 16px;line-height:1.5;">No e-menu orders recorded in the last 7 days yet.</p>
		<cfelse>
		<cfchart
			format="png"
			backgroundColor="FFF1EB"
			chartheight="240"
			chartwidth="450"
			xAxisTitle="Hour of day"
			yAxisTitle="Orders"
			showborder="no"
			show3d="no"
			>
			<cfchartseries
				type="bar"
				seriesColor="CF5D5D"
				paintStyle="light"
				query="getEMenuPeakHours"
				valueColumn="order_count"
				itemColumn="hour_label"
				>
			</cfchartseries>
		</cfchart>
		</cfif>
	<cfelse>
		<p style="font-family:Verdana,Geneva,sans-serif;font-size:12px;color:#666666;padding:24px 16px;line-height:1.5;"><cfoutput>#emenuChartErr#</cfoutput></p>
	</cfif>
</cfif>

<cfif url.type EQ 'type4'>
	<cfif isDefined("emenuTopOk") AND emenuTopOk>
		<cfif isDefined("emenuTopEmpty") AND emenuTopEmpty>
			<p style="font-family:Verdana,Geneva,sans-serif;font-size:12px;color:#666666;padding:24px 16px;line-height:1.5;">No e-menu item sales recorded this month yet.</p>
		<cfelse>
		<cfchart
			format="png"
			backgroundColor="FFF1EB"
			chartheight="240"
			chartwidth="450"
			xAxisTitle="Menu item"
			yAxisTitle="Line revenue"
			showborder="no"
			show3d="no"
			>
			<cfchartseries
				type="bar"
				seriesColor="CF5D5D"
				paintStyle="light"
				query="getEmenuTopItemsMonth"
				valueColumn="line_revenue"
				itemColumn="dish_label"
				>
			</cfchartseries>
		</cfchart>
		</cfif>
	<cfelse>
		<p style="font-family:Verdana,Geneva,sans-serif;font-size:12px;color:#666666;padding:24px 16px;line-height:1.5;"><cfoutput>#emenuTopErr#</cfoutput></p>
	</cfif>
</cfif>
</body>
</html>