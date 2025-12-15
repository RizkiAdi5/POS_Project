<html>
<head>
<title>Calculate Cost</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<body>
<h2 align="center"><font face="Times New Roman, Times, serif">
	<cfswitch expression="#url.type#">
		<cfcase value="fixed">Calculated by Fixed Cost Method</cfcase>
		<cfcase value="month">Calculated by Month Average Method</cfcase>
		<cfcase value="moving">Calculated by Moving Average Method</cfcase>
		<cfcase value="fifo">Calculated by First In First Out Method</cfcase>
		<cfcase value="lifo">Calculated by Last In First Out Method</cfcase>
	</cfswitch>
</font></h2>

<cfswitch expression="#url.type#">
	<cfcase value="fixed">
		<cfinvoke component="calculatecost1" method="calculate_fixed_cost">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
		</cfinvoke>
	</cfcase>
	<cfcase value="month">
		<cfinvoke component="calculatecost2" method="calculate_month_average_cost">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
		</cfinvoke>
	</cfcase>
	<cfcase value="moving">
		<cfinvoke component="calculatecost3" method="calculate_moving_average_cost">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
		</cfinvoke>
	</cfcase>
	<cfcase value="fifo">
		<cfinvoke component="calculatecost4" method="calculate_first_in_fist_out_cost">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
		</cfinvoke>
	</cfcase>
	<cfcase value="lifo">
		<cfinvoke component="calculatecost5" method="calculate_last_in_first_out_cost">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="itemfrom" value="#trim(form.itemfrom)#">
			<cfinvokeargument name="itemto" value="#trim(form.itemto)#">
		</cfinvoke>
	</cfcase>
</cfswitch>

<h2 align="center"><font face="Times New Roman, Times, serif" color="red">Finish !!!</font></h2>
<div align="center"><input type="button" name="Close This Window" value="Close This Window" onClick="javascript:window.close();"></div>
</body>
</html>