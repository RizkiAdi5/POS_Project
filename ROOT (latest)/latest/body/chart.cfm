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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Chart</title>
</head>
<body style="background:#FFF1EB;">

<cfif url.type EQ 'type1'>
    <cfchart
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
</body>
</html>