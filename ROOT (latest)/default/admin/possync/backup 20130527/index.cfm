<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<script language="javascript" type="text/javascript">
function validateform()
{
	var r=confirm('Are You Sure You Want To Sync With Cloud?')
	if (r==true){
	ColdFusion.Window.show('processing');
	return true;
	}
	else
	{
	return false;
	}
}

</script>

<cfoutput>
<h1>
Sync Into Cloud
</h1>
<form action="process.cfm" method="post" onSubmit="return validateform();">
<table>
<tr>
<th>Date From:</th>
<td><input type="text" name="datefrom" id="datefrom" value="#dateformat(now(),'DD/MM/YYYY')#" readonly /><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('datefrom'));">&nbsp;(DD/MM/YYYY)</td>
</tr>
<tr>
<th>Date To:</th>
<td><input type="text" name="dateto" id="dateto" value="#dateformat(now(),'DD/MM/YYYY')#" readonly /><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('dateto'));">&nbsp;(DD/MM/YYYY)</td>
</tr>
<tr>
<th>Export Bill Type:</th>
<td>
<input type="checkbox" name="billtype" id="billtype" value="CS" checked>&nbsp;Cash Sales<br/>
<input type="checkbox" name="billtype" id="billtype" value="INV" checked>&nbsp;Invoice<br/>
<input type="checkbox" name="loginrecord" id="loginrecord" value="loginrecord" checked onclick="return false;">Log in Record<br/>
<cfif getgsetup.voidtransfer eq 'Y'>
<input type="checkbox" name="updatetr" id="updatetr" value="updatetr" checked>&nbsp;Update DO<br/>
</cfif>

<!---
<input type="checkbox" name="billtype" id="billtype" value="DO" checked>&nbsp;Delivery Order--->
</td>
</tr>
<tr>
<th>Import data From Cloud</th>
<td>
<input type="checkbox" name="productim" id="productim" value="product" checked>&nbsp;Product<br/>
<input type="checkbox" name="promotionim" id="promotionim" value="promotion" checked>&nbsp;Promotion<br/>
<input type="checkbox" name="custim" id="custim" value="customer" checked>&nbsp;Customer<br/>
<input type="checkbox" name="memberim" id="memberim" value="member" checked>&nbsp;Member<br />
<input type="checkbox" name="receiveim" id="receiveim" value="receive" checked>&nbsp;Receive & DO<br />
<input type="checkbox" name="adjustmentim" id="adjustmentim" value="adjustment" checked>&nbsp;Adjustment<br />
<input type="checkbox" name="voidbillsim" id="voidbillsim" value="voidbills" checked>&nbsp;Adjustment
</td>
</tr>
<tr><th>Batch Update</th>
<td>Date <input type="text" name="batchdate" id="batchdate" value="#dateformat(getgsetup.batchdate,'DD/MM/YYYY')#" readonly /><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('batchdate'));">
<br />
<input type="checkbox" name="batchupdate" id="batchupdate" value="batchupdate" checked> (untick to update all item)
</td>
</tr>
<tr>
<td colspan="2" align="center">
<input type="submit" name="sub_btn" id="sub_btn" value="Sync" >
</td>
</tr>
</table>
</form>
</cfoutput>

<cfwindow name="processing" width="300" height="300" initshow="false" draggable="false" title="Processing....Please Wait" modal="true" resizable="false" >
<h1>Processing....Please Wait</h1>
<img src="/images/loading.gif" align="middle" />
</cfwindow>