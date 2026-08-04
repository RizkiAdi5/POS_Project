
<cfquery name="getInfo" datasource="main">
	SELECT info_remark,info_date,info_desp
	FROM info
	ORDER BY info_date desc
	LIMIT 5;
</cfquery>
<!--- E-menu analytics (KPI cards, e-menu charts, AI chat bubble) are admin/super only --->
<cfset emenuAnalyticsAllowed = (isDefined("husergrpid") AND listFindNoCase("super,admin", husergrpid))>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Overview</title>
<link rel="stylesheet" href="/latest/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="/latest/css/dataTables/dataTables_fullPagination.css" />
<link rel="stylesheet" href="/latest/css/body/overview.css?v=20260714d" />
<link rel="stylesheet" href="/latest/css/waiter/emenu-admin.css" />
<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/latest/js/dataTables/jquery.dataTables.min.js"></script>
<cfoutput>
<script type="text/javascript">
	var dts='#dts#';
</script>
</cfoutput>
<script type="text/javascript" src="/latest/js/body/overview.js"></script>
</head>
<body>
<cfoutput>
<div class="containerDiv">
	<div class="titleDiv">Overview</div>
	<div class="chartGroupDiv">
		<div class="chartDiv">
			<div class="chartTitleDiv">Last 5 Month Sales</div>
			<div class="chartContentDiv">
				<iframe marginwidth="5%" frameborder="0" align="middle" name="list" height="250px" width="500px" src="/latest/body/chart.cfm?type=type1" noresize scrolling="no"></iframe>
			</div>
		</div>
		<div class="chartDiv">
			<div class="chartTitleDiv">Top 5 Customers Last Month</div>
			<div class="chartContentDiv">
				<iframe marginwidth="5%" frameborder="0" align="middle" name="list" height="250px" width="500px" src="/latest/body/chart.cfm?type=type2" noresize scrolling="no"></iframe>
			</div>
		</div>
		<cfif emenuAnalyticsAllowed>
		<div class="chartDiv">
			<div class="chartTitleDiv">E-Menu Peak Hours (last 7 days)</div>
			<div class="chartContentDiv">
				<iframe marginwidth="5%" frameborder="0" align="middle" name="emenuMonthSales" height="250px" width="500px" src="/latest/body/chart.cfm?type=type3" noresize scrolling="no"></iframe>
			</div>
		</div>
		<div class="chartDiv">
			<div class="chartTitleDiv">Top 5 E-Menu Items This Month (by revenue)</div>
			<div class="chartContentDiv">
				<iframe marginwidth="5%" frameborder="0" align="middle" name="emenuTopItems" height="250px" width="500px" src="/latest/body/chart.cfm?type=type4" noresize scrolling="no"></iframe>
			</div>
		</div>
		</cfif>
	</div>
</cfoutput>
	<cfif emenuAnalyticsAllowed>
	<div class="emenuOverviewDiv">
		<cftry>
			<cfset emenuDashCompact = true>
			<cfinclude template="../Waiter/inc_emenu_sales_dashboard.cfm">
			<cfcatch type="any">
				<div class="emenu-sales-alert" style="margin:12px 0;padding:12px 14px;border:1px solid #fecaca;background:#fff;color:#991b1b;border-radius:8px;font-family:Verdana,Geneva,sans-serif;font-size:13px;">
					E-Menu dashboard error: <cfoutput>#HTMLEditFormat(left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 400))#</cfoutput>
				</div>
			</cfcatch>
		</cftry>
	</div>
	</cfif>
<cfoutput>
	<div class="infoBoardDiv">
		<div class="infoBoardTitleDiv">Information Board</div>
		<div class="infoBoardContentDiv">
			<cfloop query="getInfo">
			<div class="infoDiv">
				<div class="infoTitleDiv">#info_remark#
					<div class="infoDateDiv">#DateFormat(info_date,"DD/MM/YYYY")#</div>
				</div>
				<div class="infoContentDiv">#info_desp#</div>	
			</div>
			</cfloop>	
		</div>
	</div>
	<div class="loggingHistoryDiv">
		<table id="loggingTable" style="width:100%;">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>
</cfoutput>
<cfinclude template="/latest/ai/launcher.cfm">
</body>
</html>