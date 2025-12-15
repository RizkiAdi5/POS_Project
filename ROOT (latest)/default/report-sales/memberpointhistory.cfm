<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<cfparam name="alown" default="0">

	<cfif getpin2.h4700 eq 'T'>
  		<cfset alown = 1>
  	</cfif>


<cfoutput>
<cfquery name="getmember" datasource="#dts#">
		SELECT * FROM driver order by driverno
</cfquery>
</cfoutput>

<cfoutput>
<cfloop from="1" to="18" index="i">
<cfinvoke component="CFC.Date" method="getAppDateByPeriod" dts="#dts#" inputPeriod="#i#" returnvariable="newdate"/>
<cfset "vmonthto#i#" = dateformat(newdate,"mmm yy")>
</cfloop>
</cfoutput>

<html>
<head>
	<title>Member Point History</title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<link href="../../scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	
<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<script type="text/javascript">

function selectlist(nextserdate,fieldtype){

			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++) 
			{
        	if (nextserdate==document.getElementById(fieldtype).options[idx].value) 
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		} 
			
									}


</script>
	
</head>

<script src="../../scripts/CalendarControl.js" language="javascript"></script>


<body>
<cfoutput>

<form name="memberhistory" action="memberpointhistory1.cfm" method="post" target="_blank">

<!--- <h2>Print #trantype# Report By Type</h2> --->
<h2>
	Member Point History
</h2>

<table width="65%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">

<input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
	<tr>
    <td colspan="100%">
    <input type="checkbox" name="Negpoint" id="Negpoint" value="1"> Negative Points<br>
    <input type="checkbox" name="point30" id="point30" value="1">More than 30 Points<br>
    </td>
    </tr>
	<tr> 
        <th>Member</th>
        <td><select name="memberfrom">
				<option value="">Choose a Member</option>
				<cfloop query="getmember"><option value="#driverno#">#driverno#</option>
				</cfloop>
			</select>
            <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('findmember');" />
		</td>
	</tr>
    <!---<tr> 
        <th>Member to</th>
        <td><select name="memberto">
				<option value="">Choose a Member</option>
				<cfloop query="getmember"><option value="#driverno#">#driverno#</option>
				</cfloop>
			</select>
            <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('findmember');" />
		</td>
	</tr>--->

    <tr> 
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
    </tr>      
</table>
</form>
</cfoutput>
</body>
</html>

<cfwindow width="550" height="400" name="findmember" refreshOnShow="true"
        title="Find Member" initshow="false"
        source="findmember.cfm?type=member&fromto={fromto}" />
<!---
<cfset clsyear=year(getgeneral.lastaccyear)>	
<cfset clsmonth=month(getgeneral.lastaccyear)>
<!--- period default --->
<cfset newmonth=clsmonth+1>	

<cfif newmonth gt 12>
	<cfset newmonth = newmonth - 12>
	<cfset newyear = clsyear + 1>
<cfelse>
	<cfset newyear = clsyear>
</cfif>

<cfset newdate = CreateDate(newyear, newmonth, newmonth)>
<cfset vmonth = dateformat(newdate,"mmm yy")>
<cfset xnewmonth = newmonth + 11>	

<cfif xnewmonth gt 12>
	<cfset xnewmonth = xnewmonth - 12>
	<cfset xnewyear = newyear + 1>
<cfelse>
	<cfset xnewyear = newyear>
</cfif>

<cfset xnewdate = CreateDate(xnewyear, xnewmonth, xnewmonth)>
<cfset vmonthto = dateformat(xnewdate,"mmm yy")>
<!--- period 1 --->
<cfset newmonth1 = clsmonth + 1>	

<cfif newmonth1 gt 12>
	<cfset newmonth1 = newmonth1 - 12>
	<cfset newyear1 = clsyear + 1>
<cfelse>
	<cfset newyear1 = clsyear>
</cfif>

<cfset newdate1 = CreateDate(newyear1, newmonth1, newmonth1)>
<cfset vmonthto1 = dateformat(newdate1,"mmm yy")>
<!--- period 2 --->
<cfset newmonth2 = clsmonth + 2>	

<cfif newmonth2 gt 12>
	<cfset newmonth2 = newmonth2 - 12>
	<cfset newyear2 = clsyear + 1>
<cfelse>
	<cfset newyear2 = clsyear>
</cfif>
<cfset newdate2 = CreateDate(newyear2, newmonth2, newmonth2)>
<!--- period 12--->
<cfset newmonth12 = clsmonth + 12>	

<cfif newmonth12 gt 12>
	<cfset newmonth12 = newmonth12 - 12>
	<cfset newyear12= clsyear + 1>
<cfelse>
	<cfset newyear12 = clsyear>
</cfif>

<cfset newdate12 = CreateDate(newyear12, newmonth12, newmonth12)>
<cfset vmonthto12 = dateformat(newdate12,"mmm yy")>
<!--- period 13--->
<cfset newmonth13 = clsmonth + 13>

<cfif newmonth13 gt 24>
	<cfset newmonth13 = newmonth13 - 24>
	<cfset newyear13= clsyear + 2>	
<cfelseif newmonth13 gt 12>
	<cfset newmonth13 = newmonth13 - 12>
	<cfset newyear13= clsyear + 1>
<cfelse>
	<cfset newyear13 = clsyear>
</cfif>

<cfset newdate13 = CreateDate(newyear13, newmonth13, newmonth13)>
<cfset vmonthto13 = dateformat(newdate13,"mmm yy")>
--->