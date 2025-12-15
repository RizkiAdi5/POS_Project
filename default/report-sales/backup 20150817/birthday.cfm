<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

<cfparam name="alown" default="0">
<cfif getpin2.h4700 eq 'T'>
  <cfset alown = 1>
</cfif>
<cfoutput>
 <cfloop from="1" to="18" index="i">
    <cfinvoke component="CFC.Date" method="getAppDateByPeriod" dts="#dts#" inputPeriod="#i#" returnvariable="newdate"/>
    <cfset "vmonthto#i#" = dateformat(newdate,"mmm yy")>
  </cfloop>
</cfoutput>
<html>
<head>
<title>D.O.B</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<link href="../../scripts/CalendarControl.css" rel="stylesheet" type="text/css">
<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>
<link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
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
<body>
<cfoutput>
  <cfform name="birthday" action="birthday1.cfm" method="post" target="_blank">
    <h2>Date of Birthday</h2>
    <table width="65%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
      <input type="hidden" name="tran" id="tran" value="#target_arcust#" />
      <input type="hidden" name="fromto" id="fromto" value="" />
      <tr>
        <th>Date From</th>
        <td colspan="2"><cfinput type="text" id="datefrom" name="datefrom" maxlength="10" validate="eurodate" size="10">
          <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('datefrom'));"> (DD/MM/YYYY)</td>
      </tr>
      
        <th>Date To</th>
        <td colspan="2"><cfinput type="text" id="dateto" name="dateto" maxlength="10" validate="eurodate" size="10">
          <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('dateto'));"> (DD/MM/YYYY)</td>
      <tr>
        <td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
      </tr>
    </table>
  </cfform>
</cfoutput>
</body>
</html>