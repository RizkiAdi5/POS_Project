	<cfquery name="getfilename" datasource="#dts#">
    select tenantno,posdirectory,mall from POSFTP
    </cfquery>
	
	<cfset ndatefrom = createdate(right(form.billdate,4),mid(form.billdate,4,2),left(form.billdate,2))>

    <cfquery name="getbillamount" datasource="#dts#">
    select sum(grand_bil) as grand,sum(net_bil) as net,sum(tax_bil) as tax,count(refno) as refno,YEAR(created_on) as created_year,MONTH(created_on) as created_month,DAY(created_on) as created_day,HOUR(created_on) as created_hour from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
    group by HOUR(created_on)
    
    </cfquery>
    <cfloop query="getbillamount">
<cfset control_header_record = 'EID,TxnYear,TxnMonth,TxnDate,TxnHour,TxnAmount,TxnVoid'&#Chr(13)#&#Chr(10)#&"#getfilename.tenantno#,#getbillamount.created_year#,#getbillamount.created_month#,#getbillamount.created_day#,#getbillamount.created_hour#,#numberformat(val(getbillamount.grand),',_.__')#,0"&#Chr(13)#&#Chr(10)#&'END,,,,,,'>

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>

<cffile action = "write" file = "#currentDirectory#\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_H_#created_hour#.txt"
output = "#control_header_record#">

<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_H_#created_hour#.txt"
output = "#control_header_record#">
   </cfloop>
   
   <cfoutput>
   <form name="form1" id="form1" method="post" action="/default/transaction/POSSubmission/POSPost.cfm">
   <input type="hidden" name="billdate" id="billdate" value="#dateformat(ndatefrom,'YYYYMMDD')#" />
   <input type="hidden" name="errorvalid" id="errorvalid" value="" />
   </form>
   </cfoutput>
   
 <script>
	form1.submit();
	</script>



