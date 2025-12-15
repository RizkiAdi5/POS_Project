<html>
<title>Staff Attendance</title>
<head>

</head>

<body>
<cfoutput>
<cfif form.logtype eq 'login'>
<cfquery name="checkattendance" datasource="#dts#">
select * from staffattendance where wos_date='#dateformat(now(),'yyyy-mm-dd')#' and cashier='#form.cashierlist#' and logintype='login'
</cfquery>

<cfif checkattendance.recordcount eq 0>

<cfquery name="insertattendance" datasource="#dts#">
insert into staffattendance 
(wos_date,cashier,time,created_by,logintype)

values

('#dateformat(now(),'yyyy-mm-dd')#','#form.cashierlist#','#dateformat(now(),'yyyy-mm-dd')# #timeformat(now(),'HH:MM:SS')#','#huserid#','login')
</cfquery>

<script type="text/javascript">
alert("Casher Login Success!");
window.location.href="attendancetable.cfm";
</script>

<cfelse>

<script type="text/javascript">
alert("This Cashier #form.cashierlist# has already been login");
history.go(-1);
</script>

</cfif>


<cfelseif form.logtype eq 'logout'>

<cfquery name="checkattendance" datasource="#dts#">
select * from staffattendance where wos_date='#dateformat(now(),'yyyy-mm-dd')#' and cashier='#form.cashierlist#' and logintype='login'
</cfquery>

<cfquery name="checkattendance2" datasource="#dts#">
select * from staffattendance where wos_date='#dateformat(now(),'yyyy-mm-dd')#' and cashier='#form.cashierlist#' and logintype='logout'
</cfquery>

<cfif checkattendance.recordcount neq 0 and checkattendance2.recordcount eq 0>
<cfquery name="insertattendance" datasource="#dts#">
insert into staffattendance 
(wos_date,cashier,time,created_by,logintype)

values

('#dateformat(now(),'yyyy-mm-dd')#','#form.cashierlist#','#dateformat(now(),'yyyy-mm-dd')# #timeformat(now(),'HH:MM:SS')#','#huserid#','logout')
</cfquery>

<script type="text/javascript">
alert("Casher Logout Success!");
window.location.href="attendancetable.cfm";
</script>

<cfelseif checkattendance2.recordcount neq 0>
<script type="text/javascript">
alert("This Cashier #form.cashierlist# has already been Logout!");
history.go(-1);
</script>

<cfelseif checkattendance.recordcount eq 0>
<script type="text/javascript">
alert("This Cashier #form.cashierlist# has not been login!");
history.go(-1);
</script>


</cfif>

</cfif>

</cfoutput>
</body>
</html>