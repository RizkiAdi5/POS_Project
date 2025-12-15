<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
<cfoutput>
<h1>
Sync Into Cloud
</h1>
<form action="process.cfm" method="post" onSubmit="return confirm('Are You Sure You Want To Sync With Cloud?')">
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
<input type="checkbox" name="billtype" id="billtype" value="DO" checked>&nbsp;Delivery Order
</td>
</tr>
<tr>
<th>Import data From Cloud</th>
<td>
<input type="checkbox" name="productim" id="productim" value="product" checked>&nbsp;Product<br/>
<input type="checkbox" name="promotionim" id="promotionim" value="promotion" checked>&nbsp;Promotion<br/>
<input type="checkbox" name="custim" id="custim" value="customer" checked>&nbsp;Customer<br/>
<input type="checkbox" name="memberim" id="memberim" value="member" checked>&nbsp;Member<br />
<input type="checkbox" name="receiveim" id="receiveim" value="receive" checked>&nbsp;Receive & DO
</td>
</tr>
<tr>
<td colspan="2" align="center">
<input type="submit" name="sub_btn" id="sub_btn" value="Sync">
</td>
</tr>
</table>
</form>
</cfoutput>