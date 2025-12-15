<script type="text/javascript" src="/scripts/prototypenew.js" ></script>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script language="Javascript">
		var speed = 60000;
	
		function reload() 
		{
			window.location.reload();
		}
	
		setTimeout("reload()", speed);
	</script>

<cfif husergrpid eq 'Store User'>
<cfoutput>
<div id="updatealertmessage">
<cfquery name="getalert" datasource="#dts#">
SELECT refno FROM artran where type='SO' and fperiod!='99' and (void='' or void is null) and (toinv='' or toinv is null)
</cfquery>
<cfif getalert.recordcount neq 0>
<a onClick="window.open('outstandingSO.cfm');"><h3>Outstanding SO Alert!</h3></a>
</cfif>
</div>
</cfoutput>
<cfelseif husergrpid eq 'Coordinator'>

<cfoutput>
<div id="updatealertmessage">
<cfquery name="getalert" datasource="#dts#">
SELECT refno FROM artran where type='DO' and fperiod!='99' and (void='' or void is null) and (toinv='' or toinv is null)
</cfquery>
<cfif getalert.recordcount neq 0>
<a onClick="window.open('outstandingDO.cfm');"><h3>Outstanding DO Alert!</h3></a>
</cfif>
</div>
</cfoutput>

</cfif>