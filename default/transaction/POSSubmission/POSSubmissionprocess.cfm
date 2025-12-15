	<cfquery name="getfilename" datasource="#dts#">
    select tenantno,posdirectory,mall,tranno from POSFTP
    </cfquery>

		<cfset ndatefrom = createdate(right(form.billdate,4),mid(form.billdate,4,2),left(form.billdate,2))>

<cfif getfilename.mall eq 'vivocity'>

<cfset currentDirectory = "#getfilename.posdirectory#\#getfilename.tenantno#\#dateformat(ndatefrom,'yyyymmdd')#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >

</cfif>

<cfquery name="getbillamount" datasource="#dts#">
    select sum(grand_bil) as grand,sum(net_bil) as net,sum(tax_bil) as tax,refno,sum(discount) as discount,created_on,cs_pm_cash,cs_pm_crcd,cs_pm_crc2,cs_pm_dbcd,creditcardtype1,creditcardtype2,cs_pm_vouc from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) group by refno

</cfquery>


<cfloop query="getbillamount">
<cfif cs_pm_cash neq 0>
<cfset paytype=1>
<cfelseif cs_pm_crcd neq 0 and creditcardtype1 eq 'visa'>
<cfset paytype=2>
<cfelseif cs_pm_crc2 neq 0 and creditcardtype2 eq 'visa'>
<cfset paytype=2>
<cfelseif cs_pm_crcd neq 0 and creditcardtype1 eq 'master'>
<cfset paytype=3>
<cfelseif cs_pm_crc2 neq 0 and creditcardtype2 eq 'master'>
<cfset paytype=3>
<cfelseif cs_pm_crcd neq 0 and creditcardtype1 eq 'amex'>
<cfset paytype=4>
<cfelseif cs_pm_crc2 neq 0 and creditcardtype2 eq 'amex'>
<cfset paytype=4>
<cfelseif cs_pm_dbcd neq 0>
<cfset paytype=5>
<cfelseif cs_pm_vouc neq 0>
<cfset paytype=7>
<cfelse>
<cfset paytype=8>
</cfif>

<cfset control_header_record = "#getfilename.tenantno#|#getbillamount.refno#|#numberformat(val(getbillamount.grand),',_.__')#|#paytype#|0.00|0|0.00|0|#numberformat(val(getbillamount.tax),',_.__')#|#numberformat(val(getbillamount.discount),',_.__')#|#dateformat(ndatefrom,'YYYYMMDD')#|#timeformat(created_on,'HH')#|#timeformat(created_on,'MM')#|#timeformat(created_on,'SS')#|0|0|0">

<cffile action = "write" file = "#currentDirectory#\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#timeformat(getbillamount.created_on,'HHmmss')#.txt" output = "#control_header_record#">
<!---#getbillamount.refno#--->
</cfloop>


<cfelseif getfilename.mall eq 'vivocity2'>

<cfset currentDirectory = "#getfilename.posdirectory#\#getfilename.tenantno#\#dateformat(ndatefrom,'yyyymmdd')#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >

</cfif>

<cfquery name="getbillamount" datasource="#dts#">
    select FLOOR((sum(grand_bil*(100/107)))*100)/100 as grand,FLOOR((sum(net_bil*(100/107)))*100)/100 as net,'0' as tax,refno,sum(discount) as discount,created_on,cs_pm_cash,cs_pm_crcd,cs_pm_crc2,cs_pm_dbcd,creditcardtype1,creditcardtype2,cs_pm_vouc from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) group by refno

</cfquery>


<cfloop query="getbillamount">
<cfif cs_pm_cash neq 0>
<cfset paytype=1>
<cfelseif cs_pm_crcd neq 0 and creditcardtype1 eq 'visa'>
<cfset paytype=2>
<cfelseif cs_pm_crc2 neq 0 and creditcardtype2 eq 'visa'>
<cfset paytype=2>
<cfelseif cs_pm_crcd neq 0 and creditcardtype1 eq 'master'>
<cfset paytype=3>
<cfelseif cs_pm_crc2 neq 0 and creditcardtype2 eq 'master'>
<cfset paytype=3>
<cfelseif cs_pm_crcd neq 0 and creditcardtype1 eq 'amex'>
<cfset paytype=4>
<cfelseif cs_pm_crc2 neq 0 and creditcardtype2 eq 'amex'>
<cfset paytype=4>
<cfelseif cs_pm_dbcd neq 0>
<cfset paytype=5>
<cfelseif cs_pm_vouc neq 0>
<cfset paytype=7>
<cfelse>
<cfset paytype=8>
</cfif>

<cfset control_header_record = "#getfilename.tenantno#|#getbillamount.refno#|#numberformat(val(getbillamount.grand),',_.__')#|#paytype#|0.00|0|0.00|0|#numberformat(val(getbillamount.tax),',_.__')#|#numberformat(val(getbillamount.discount),',_.__')#|#dateformat(ndatefrom,'YYYYMMDD')#|#timeformat(created_on,'HH')#|#timeformat(created_on,'MM')#|#timeformat(created_on,'SS')#|0|0|0">

<cffile action = "write" file = "#currentDirectory#\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#timeformat(getbillamount.created_on,'HHmmss')#.txt" output = "#control_header_record#">
<!---#getbillamount.refno#--->
</cfloop>


<cfelseif getfilename.mall eq 'Jurong'>
    <cfquery name="getbillamount" datasource="#dts#">
    select sum(grand_bil) as grand,sum(net_bil) as net,sum(tax_bil) as tax,count(refno) as refno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)

    </cfquery>

    <cfset control_header_record = "#numberformat(val(getbillamount.grand),',_.__')#"&"|"&"#numberformat(val(getbillamount.net),',_.__')#"&"|"&"#numberformat(val(getbillamount.tax),',_.__')#"&"|"&"#getbillamount.refno#"&"|"&"#dateformat(ndatefrom,'DD-MM-YYYY')#">

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >

</cfif>

    <cffile action = "write" file = "#currentDirectory#\#getfilename.tenantno##dateformat(ndatefrom,'YYYYMMDD')#.txt" <!---#getbillamount.recordcount#---> output = "#control_header_record#">
	<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno##dateformat(ndatefrom,'YYYYMMDD')#.txt"
output = "#control_header_record#">



<cfelseif getfilename.mall eq 'Central'>

<cfquery name="getbillamount" datasource="#dts#">
	select * from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfquery name="getbillamount2" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfset control_header_record = "#getfilename.tenantno#|#dateformat(ndatefrom,'YYYYMMDD')#|0|#timeformat(now(),'HHMMSS')#|#getbillamount.recordcount#|#getbillamount2.gross#|#getbillamount2.tax#|#getbillamount2.disc#|0">

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" file = "#currentDirectory#\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#timeformat(now(),'HHMMSS')#.txt" <!---#getbillamount.recordcount#---> output = "#control_header_record#">
<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#timeformat(now(),'HHMMSS')#.txt"
output = "#control_header_record#">



<cfelseif getfilename.mall eq 'jem'>
<cfset tranautorunno=val(getfilename.tranno)+1>
<!---
<cfquery name="getbillamount" datasource="#dts#">
	select * from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>--->

<cfquery name="getbillamount2" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 00:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 01:00:00'
</cfquery>

<cfquery name="getbillamount12" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 01:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 02:00:00'
</cfquery>

<cfquery name="getbillamount22" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 02:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 03:00:00'
</cfquery>

<cfquery name="getbillamount32" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 03:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 04:00:00'
</cfquery>

<cfquery name="getbillamount42" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 04:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 05:00:00'
</cfquery>

<cfquery name="getbillamount52" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 05:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 06:00:00'
</cfquery>

<cfquery name="getbillamount62" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 06:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 07:00:00'
</cfquery>

<cfquery name="getbillamount72" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 07:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 08:00:00'
</cfquery>

<cfquery name="getbillamount82" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 08:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 09:00:00'
</cfquery>

<cfquery name="getbillamount92" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 09:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 10:00:00'
</cfquery>

<cfquery name="getbillamount102" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 10:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 11:00:00'
</cfquery>

<cfquery name="getbillamount112" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 11:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 12:00:00'
</cfquery>

<cfquery name="getbillamount122" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 12:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 13:00:00'
</cfquery>

<cfquery name="getbillamount132" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 13:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 14:00:00'
</cfquery>

<cfquery name="getbillamount142" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 14:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 15:00:00'
</cfquery>

<cfquery name="getbillamount152" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 15:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 16:00:00'
</cfquery>

<cfquery name="getbillamount162" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 16:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 17:00:00'
</cfquery>

<cfquery name="getbillamount172" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 17:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 18:00:00'
</cfquery>

<cfquery name="getbillamount182" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 18:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 19:00:00'
</cfquery>

<cfquery name="getbillamount192" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 19:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 20:00:00'
</cfquery>

<cfquery name="getbillamount202" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 20:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 21:00:00'
</cfquery>

<cfquery name="getbillamount212" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 21:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 22:00:00'
</cfquery>

<cfquery name="getbillamount222" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 22:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 23:00:00'
</cfquery>

<cfquery name="getbillamount232" datasource="#dts#">
	select FLOOR((sum(net_bil*(100/107)))*100)/100 as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 23:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 24:00:00'
</cfquery>


<cfset control_header_record = "#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0059|#val(getbillamount2.totalbill)#|#numberformat(val(getbillamount2.gross),'.00')#|#numberformat(val(getbillamount2.tax),'.00')#|#numberformat(val(getbillamount2.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0159|#val(getbillamount12.totalbill)#|#numberformat(val(getbillamount12.gross),'.00')#|#numberformat(val(getbillamount12.tax),'.00')#|#numberformat(val(getbillamount12.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0259|#val(getbillamount22.totalbill)#|#numberformat(val(getbillamount22.gross),'.00')#|#numberformat(val(getbillamount22.tax),'.00')#|#numberformat(val(getbillamount22.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0359|#val(getbillamount32.totalbill)#|#numberformat(val(getbillamount32.gross),'.00')#|#numberformat(val(getbillamount32.tax),'.00')#|#numberformat(val(getbillamount32.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0459|#val(getbillamount42.totalbill)#|#numberformat(val(getbillamount42.gross),'.00')#|#numberformat(val(getbillamount42.tax),'.00')#|#numberformat(val(getbillamount42.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0559|#val(getbillamount52.totalbill)#|#numberformat(val(getbillamount52.gross),'.00')#|#numberformat(val(getbillamount52.tax),'.00')#|#numberformat(val(getbillamount52.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0659|#val(getbillamount62.totalbill)#|#numberformat(val(getbillamount62.gross),'.00')#|#numberformat(val(getbillamount62.tax),'.00')#|#numberformat(val(getbillamount62.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0759|#val(getbillamount72.totalbill)#|#numberformat(val(getbillamount72.gross),'.00')#|#numberformat(val(getbillamount72.tax),'.00')#|#numberformat(val(getbillamount72.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0859|#val(getbillamount82.totalbill)#|#numberformat(val(getbillamount82.gross),'.00')#|#numberformat(val(getbillamount82.tax),'.00')#|#numberformat(val(getbillamount82.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|0959|#val(getbillamount92.totalbill)#|#numberformat(val(getbillamount92.gross),'.00')#|#numberformat(val(getbillamount92.tax),'.00')#|#numberformat(val(getbillamount92.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1059|#val(getbillamount102.totalbill)#|#numberformat(val(getbillamount102.gross),'.00')#|#numberformat(val(getbillamount102.tax),'.00')#|#numberformat(val(getbillamount102.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1159|#val(getbillamount112.totalbill)#|#numberformat(val(getbillamount112.gross),'.00')#|#numberformat(val(getbillamount112.tax),'.00')#|#numberformat(val(getbillamount112.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1259|#val(getbillamount122.totalbill)#|#numberformat(val(getbillamount122.gross),'.00')#|#numberformat(val(getbillamount122.tax),'.00')#|#numberformat(val(getbillamount122.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1359|#val(getbillamount132.totalbill)#|#numberformat(val(getbillamount132.gross),'.00')#|#numberformat(val(getbillamount132.tax),'.00')#|#numberformat(val(getbillamount132.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1459|#val(getbillamount142.totalbill)#|#numberformat(val(getbillamount142.gross),'.00')#|#numberformat(val(getbillamount142.tax),'.00')#|#numberformat(val(getbillamount142.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1559|#val(getbillamount152.totalbill)#|#numberformat(val(getbillamount152.gross),'.00')#|#numberformat(val(getbillamount152.tax),'.00')#|#numberformat(val(getbillamount152.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1659|#val(getbillamount162.totalbill)#|#numberformat(val(getbillamount162.gross),'.00')#|#numberformat(val(getbillamount162.tax),'.00')#|#numberformat(val(getbillamount162.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1759|#val(getbillamount172.totalbill)#|#numberformat(val(getbillamount172.gross),'.00')#|#numberformat(val(getbillamount172.tax),'.00')#|#numberformat(val(getbillamount172.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1859|#val(getbillamount182.totalbill)#|#numberformat(val(getbillamount182.gross),'.00')#|#numberformat(val(getbillamount182.tax),'.00')#|#numberformat(val(getbillamount182.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|1959|#val(getbillamount192.totalbill)#|#numberformat(val(getbillamount192.gross),'.00')#|#numberformat(val(getbillamount192.tax),'.00')#|#numberformat(val(getbillamount192.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|2059|#val(getbillamount202.totalbill)#|#numberformat(val(getbillamount202.gross),'.00')#|#numberformat(val(getbillamount202.tax),'.00')#|#numberformat(val(getbillamount202.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|2159|#val(getbillamount212.totalbill)#|#numberformat(val(getbillamount212.gross),'.00')#|#numberformat(val(getbillamount212.tax),'.00')#|#numberformat(val(getbillamount212.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|2259|#val(getbillamount222.totalbill)#|#numberformat(val(getbillamount222.gross),'.00')#|#numberformat(val(getbillamount222.tax),'.00')#|#numberformat(val(getbillamount222.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#dateformat(ndatefrom,'YYYYMMDD')#|2359|#val(getbillamount232.totalbill)#|#numberformat(val(getbillamount232.gross),'.00')#|#numberformat(val(getbillamount232.tax),'.00')#|#numberformat(val(getbillamount232.disc),'.00')#|0#Chr(13)#"
>

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" file = "#currentDirectory#\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#timeformat(now(),'HHMMSS')#.txt" <!---#getbillamount.recordcount#---> output = "#control_header_record#">
<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#timeformat(now(),'HHMMSS')#.txt"
output = "#control_header_record#">

<cfquery name="update" datasource="#dts#">
	update POSFTP set tranno='#tranautorunno#'
</cfquery>

<cfelseif getfilename.mall eq 'drf'>
<cfset tranautorunno=numberformat(val(getfilename.tranno)+1,000)>

<cfquery name="getbillamount" datasource="#dts#">
	select * from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfquery name="getbillamount2" datasource="#dts#">
	select sum(net_bil) as net,sum(tax_bil) as tax,sum(disc_bil) as disc from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfset control_header_record = "D#getfilename.tenantno##dateformat(ndatefrom,'YYYYMMDD')##numberformat(getbillamount2.net,'_________.__')#">

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" file = "#currentDirectory#\D#getfilename.tenantno#.#tranautorunno#" <!---#getbillamount.recordcount#---> output = "#control_header_record#">
<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\D#getfilename.tenantno#.#tranautorunno#"
output = "#control_header_record#">

<cfquery name="update" datasource="#dts#">
	update POSFTP set tranno='#tranautorunno#'
</cfquery>

<cfelseif getfilename.mall eq 'mrf'>
<cfset tranautorunno=numberformat(val(getfilename.tranno)+1,000)>

<cfquery name="getbillamount" datasource="#dts#">
	select * from artran where type='CS' and month(wos_date)=month('#dateformat(ndatefrom,'YYYY-MM-DD')#') and (void ='' or void is null)
</cfquery>

<cfquery name="getbillamount2" datasource="#dts#">
	select sum(net_bil) as net,sum(tax_bil) as tax,sum(disc_bil) as disc from artran where type='CS' and month(wos_date)=month('#dateformat(ndatefrom,'YYYY-MM-DD')#') and (void ='' or void is null)
</cfquery>

<cfset control_header_record = "T#getfilename.tenantno##dateformat(ndatefrom,'YYYYMM')##numberformat(getbillamount2.net,'_________.__')#">

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" file = "#currentDirectory#\T#getfilename.tenantno#.#tranautorunno#" <!---#getbillamount.recordcount#---> output = "#control_header_record#">
<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\T#getfilename.tenantno#.#tranautorunno#"
output = "#control_header_record#">

<cfquery name="update" datasource="#dts#">
	update POSFTP set tranno='#tranautorunno#'
</cfquery>

<!--- 313 Somerset Point--->
<cfelseif getfilename.mall eq 'smp313'>
<cfset tranautorunno=val(getfilename.tranno)+1>
<!---
<cfquery name="getbillamount" datasource="#dts#">
	select * from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>--->

<cfquery name="getbillamount2" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 00:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 01:00:00'
</cfquery>

<cfquery name="getbillamount12" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 01:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 02:00:00'
</cfquery>

<cfquery name="getbillamount22" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 02:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 03:00:00'
</cfquery>

<cfquery name="getbillamount32" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 03:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 04:00:00'
</cfquery>

<cfquery name="getbillamount42" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 04:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 05:00:00'
</cfquery>

<cfquery name="getbillamount52" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 05:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 06:00:00'
</cfquery>

<cfquery name="getbillamount62" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 06:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 07:00:00'
</cfquery>

<cfquery name="getbillamount72" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 07:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 08:00:00'
</cfquery>

<cfquery name="getbillamount82" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 08:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 09:00:00'
</cfquery>

<cfquery name="getbillamount92" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 09:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 10:00:00'
</cfquery>

<cfquery name="getbillamount102" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 10:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 11:00:00'
</cfquery>

<cfquery name="getbillamount112" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 11:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 12:00:00'
</cfquery>

<cfquery name="getbillamount122" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 12:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 13:00:00'
</cfquery>

<cfquery name="getbillamount132" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 13:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 14:00:00'
</cfquery>

<cfquery name="getbillamount142" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 14:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 15:00:00'
</cfquery>

<cfquery name="getbillamount152" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 15:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 16:00:00'
</cfquery>

<cfquery name="getbillamount162" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 16:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 17:00:00'
</cfquery>

<cfquery name="getbillamount172" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 17:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 18:00:00'
</cfquery>

<cfquery name="getbillamount182" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 18:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 19:00:00'
</cfquery>

<cfquery name="getbillamount192" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 19:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 20:00:00'
</cfquery>

<cfquery name="getbillamount202" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 20:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 21:00:00'
</cfquery>

<cfquery name="getbillamount212" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 21:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 22:00:00'
</cfquery>

<cfquery name="getbillamount222" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 22:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 23:00:00'
</cfquery>

<cfquery name="getbillamount232" datasource="#dts#">
	select sum(gross_bil) as gross,sum(tax_bil) as tax,sum(disc_bil) as disc,count(refno) as totalbill from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 23:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 24:00:00'
</cfquery>

<!---
<cfset control_header_record = "#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0059|#val(getbillamount2.totalbill)#|#numberformat(val(getbillamount2.gross),'.00')#|#numberformat(val(getbillamount2.tax),'.00')#|#numberformat(val(getbillamount2.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0159|#val(getbillamount12.totalbill)#|#numberformat(val(getbillamount12.gross),'.00')#|#numberformat(val(getbillamount12.tax),'.00')#|#numberformat(val(getbillamount12.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0259|#val(getbillamount22.totalbill)#|#numberformat(val(getbillamount22.gross),'.00')#|#numberformat(val(getbillamount22.tax),'.00')#|#numberformat(val(getbillamount22.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0359|#val(getbillamount32.totalbill)#|#numberformat(val(getbillamount32.gross),'.00')#|#numberformat(val(getbillamount32.tax),'.00')#|#numberformat(val(getbillamount32.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0459|#val(getbillamount42.totalbill)#|#numberformat(val(getbillamount42.gross),'.00')#|#numberformat(val(getbillamount42.tax),'.00')#|#numberformat(val(getbillamount42.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0559|#val(getbillamount52.totalbill)#|#numberformat(val(getbillamount52.gross),'.00')#|#numberformat(val(getbillamount52.tax),'.00')#|#numberformat(val(getbillamount52.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0659|#val(getbillamount62.totalbill)#|#numberformat(val(getbillamount62.gross),'.00')#|#numberformat(val(getbillamount62.tax),'.00')#|#numberformat(val(getbillamount62.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0759|#val(getbillamount72.totalbill)#|#numberformat(val(getbillamount72.gross),'.00')#|#numberformat(val(getbillamount72.tax),'.00')#|#numberformat(val(getbillamount72.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0859|#val(getbillamount82.totalbill)#|#numberformat(val(getbillamount82.gross),'.00')#|#numberformat(val(getbillamount82.tax),'.00')#|#numberformat(val(getbillamount82.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0959|#val(getbillamount92.totalbill)#|#numberformat(val(getbillamount92.gross),'.00')#|#numberformat(val(getbillamount92.tax),'.00')#|#numberformat(val(getbillamount92.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1059|#val(getbillamount102.totalbill)#|#numberformat(val(getbillamount102.gross),'.00')#|#numberformat(val(getbillamount102.tax),'.00')#|#numberformat(val(getbillamount102.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1159|#val(getbillamount112.totalbill)#|#numberformat(val(getbillamount112.gross),'.00')#|#numberformat(val(getbillamount112.tax),'.00')#|#numberformat(val(getbillamount112.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1259|#val(getbillamount122.totalbill)#|#numberformat(val(getbillamount122.gross),'.00')#|#numberformat(val(getbillamount122.tax),'.00')#|#numberformat(val(getbillamount122.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1359|#val(getbillamount132.totalbill)#|#numberformat(val(getbillamount132.gross),'.00')#|#numberformat(val(getbillamount132.tax),'.00')#|#numberformat(val(getbillamount132.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1459|#val(getbillamount142.totalbill)#|#numberformat(val(getbillamount142.gross),'.00')#|#numberformat(val(getbillamount142.tax),'.00')#|#numberformat(val(getbillamount142.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1559|#val(getbillamount152.totalbill)#|#numberformat(val(getbillamount152.gross),'.00')#|#numberformat(val(getbillamount152.tax),'.00')#|#numberformat(val(getbillamount152.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1659|#val(getbillamount162.totalbill)#|#numberformat(val(getbillamount162.gross),'.00')#|#numberformat(val(getbillamount162.tax),'.00')#|#numberformat(val(getbillamount162.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1759|#val(getbillamount172.totalbill)#|#numberformat(val(getbillamount172.gross),'.00')#|#numberformat(val(getbillamount172.tax),'.00')#|#numberformat(val(getbillamount172.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1859|#val(getbillamount182.totalbill)#|#numberformat(val(getbillamount182.gross),'.00')#|#numberformat(val(getbillamount182.tax),'.00')#|#numberformat(val(getbillamount182.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1959|#val(getbillamount192.totalbill)#|#numberformat(val(getbillamount192.gross),'.00')#|#numberformat(val(getbillamount192.tax),'.00')#|#numberformat(val(getbillamount192.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|2059|#val(getbillamount202.totalbill)#|#numberformat(val(getbillamount202.gross),'.00')#|#numberformat(val(getbillamount202.tax),'.00')#|#numberformat(val(getbillamount202.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|2159|#val(getbillamount212.totalbill)#|#numberformat(val(getbillamount212.gross),'.00')#|#numberformat(val(getbillamount212.tax),'.00')#|#numberformat(val(getbillamount212.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|2259|#val(getbillamount222.totalbill)#|#numberformat(val(getbillamount222.gross),'.00')#|#numberformat(val(getbillamount222.tax),'.00')#|#numberformat(val(getbillamount222.disc),'.00')#|0#Chr(13)#
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|2359|#val(getbillamount232.totalbill)#|#numberformat(val(getbillamount232.gross),'.00')#|#numberformat(val(getbillamount232.tax),'.00')#|#numberformat(val(getbillamount232.disc),'.00')#|0#Chr(13)#"
>--->

<cfset control_header_record = "#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0059|#val(getbillamount2.totalbill)#|#numberformat(val(getbillamount2.gross),'.00')#|#numberformat(val(getbillamount2.tax),'.00')#|#numberformat(val(getbillamount2.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0159|#val(getbillamount12.totalbill)#|#numberformat(val(getbillamount12.gross),'.00')#|#numberformat(val(getbillamount12.tax),'.00')#|#numberformat(val(getbillamount12.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0259|#val(getbillamount22.totalbill)#|#numberformat(val(getbillamount22.gross),'.00')#|#numberformat(val(getbillamount22.tax),'.00')#|#numberformat(val(getbillamount22.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0359|#val(getbillamount32.totalbill)#|#numberformat(val(getbillamount32.gross),'.00')#|#numberformat(val(getbillamount32.tax),'.00')#|#numberformat(val(getbillamount32.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0459|#val(getbillamount42.totalbill)#|#numberformat(val(getbillamount42.gross),'.00')#|#numberformat(val(getbillamount42.tax),'.00')#|#numberformat(val(getbillamount42.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0559|#val(getbillamount52.totalbill)#|#numberformat(val(getbillamount52.gross),'.00')#|#numberformat(val(getbillamount52.tax),'.00')#|#numberformat(val(getbillamount52.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0659|#val(getbillamount62.totalbill)#|#numberformat(val(getbillamount62.gross),'.00')#|#numberformat(val(getbillamount62.tax),'.00')#|#numberformat(val(getbillamount62.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0759|#val(getbillamount72.totalbill)#|#numberformat(val(getbillamount72.gross),'.00')#|#numberformat(val(getbillamount72.tax),'.00')#|#numberformat(val(getbillamount72.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0859|#val(getbillamount82.totalbill)#|#numberformat(val(getbillamount82.gross),'.00')#|#numberformat(val(getbillamount82.tax),'.00')#|#numberformat(val(getbillamount82.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0959|#val(getbillamount92.totalbill)#|#numberformat(val(getbillamount92.gross),'.00')#|#numberformat(val(getbillamount92.tax),'.00')#|#numberformat(val(getbillamount92.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1059|#val(getbillamount102.totalbill)#|#numberformat(val(getbillamount102.gross),'.00')#|#numberformat(val(getbillamount102.tax),'.00')#|#numberformat(val(getbillamount102.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1159|#val(getbillamount112.totalbill)#|#numberformat(val(getbillamount112.gross),'.00')#|#numberformat(val(getbillamount112.tax),'.00')#|#numberformat(val(getbillamount112.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1259|#val(getbillamount122.totalbill)#|#numberformat(val(getbillamount122.gross),'.00')#|#numberformat(val(getbillamount122.tax),'.00')#|#numberformat(val(getbillamount122.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1359|#val(getbillamount132.totalbill)#|#numberformat(val(getbillamount132.gross),'.00')#|#numberformat(val(getbillamount132.tax),'.00')#|#numberformat(val(getbillamount132.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1459|#val(getbillamount142.totalbill)#|#numberformat(val(getbillamount142.gross),'.00')#|#numberformat(val(getbillamount142.tax),'.00')#|#numberformat(val(getbillamount142.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1559|#val(getbillamount152.totalbill)#|#numberformat(val(getbillamount152.gross),'.00')#|#numberformat(val(getbillamount152.tax),'.00')#|#numberformat(val(getbillamount152.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1659|#val(getbillamount162.totalbill)#|#numberformat(val(getbillamount162.gross),'.00')#|#numberformat(val(getbillamount162.tax),'.00')#|#numberformat(val(getbillamount162.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1759|#val(getbillamount172.totalbill)#|#numberformat(val(getbillamount172.gross),'.00')#|#numberformat(val(getbillamount172.tax),'.00')#|#numberformat(val(getbillamount172.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1859|#val(getbillamount182.totalbill)#|#numberformat(val(getbillamount182.gross),'.00')#|#numberformat(val(getbillamount182.tax),'.00')#|#numberformat(val(getbillamount182.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|1959|#val(getbillamount192.totalbill)#|#numberformat(val(getbillamount192.gross),'.00')#|#numberformat(val(getbillamount192.tax),'.00')#|#numberformat(val(getbillamount192.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|2059|#val(getbillamount202.totalbill)#|#numberformat(val(getbillamount202.gross),'.00')#|#numberformat(val(getbillamount202.tax),'.00')#|#numberformat(val(getbillamount202.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|2159|#val(getbillamount212.totalbill)#|#numberformat(val(getbillamount212.gross),'.00')#|#numberformat(val(getbillamount212.tax),'.00')#|#numberformat(val(getbillamount212.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|2259|#val(getbillamount222.totalbill)#|#numberformat(val(getbillamount222.gross),'.00')#|#numberformat(val(getbillamount222.tax),'.00')#|#numberformat(val(getbillamount222.disc),'.00')#|0
#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|2359|#val(getbillamount232.totalbill)#|#numberformat(val(getbillamount232.gross),'.00')#|#numberformat(val(getbillamount232.tax),'.00')#|#numberformat(val(getbillamount232.disc),'.00')#|0"
>

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" file = "#currentDirectory#\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#timeformat(now(),'HHMMSS')#.txt" <!---#getbillamount.recordcount#---> output = "#control_header_record#">
<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#timeformat(now(),'HHMMSS')#.txt"
output = "#control_header_record#">

<cfquery name="update" datasource="#dts#">
	update POSFTP set tranno='#tranautorunno#'
</cfquery>

<cfelseif getfilename.mall eq 'drf'>
<cfset tranautorunno=numberformat(val(getfilename.tranno)+1,000)>

<cfquery name="getbillamount" datasource="#dts#">
	select * from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfquery name="getbillamount2" datasource="#dts#">
	select sum(net_bil) as net,sum(tax_bil) as tax,sum(disc_bil) as disc from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfset control_header_record = "D#getfilename.tenantno##dateformat(ndatefrom,'YYYYMMDD')##numberformat(getbillamount2.net,'_________.__')#">

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" file = "#currentDirectory#\D#getfilename.tenantno#.#tranautorunno#" <!---#getbillamount.recordcount#---> output = "#control_header_record#">
<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\D#getfilename.tenantno#.#tranautorunno#"
output = "#control_header_record#">

<cfquery name="update" datasource="#dts#">
	update POSFTP set tranno='#tranautorunno#'
</cfquery>

<!--- 112 Katong--->
<cfelseif getfilename.mall eq 'katong112'>

<cfset tranautorunno=val(getfilename.tranno)+1>

<cfquery name="getgsetuprefno" datasource="#dts#">
select lastusedno from refnoset where type='CS'
</cfquery>

<cfquery name="getlastnumber" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date<'#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) order by refno desc limit 1

</cfquery>

<cfif getlastnumber.recordcount eq 0>
<cfset getlastnumber.lastrefno ="00000">
</cfif>

<cfset getbillamount3field="00000">
<cfset getbillamount32field="00000">
<cfset getbillamount33field="00000">
<cfset getbillamount34field="00000">
<cfset getbillamount35field="00000">
<cfset getbillamount36field="00000">
<cfset getbillamount37field="00000">
<cfset getbillamount38field="00000">
<cfset getbillamount39field="00000">
<cfset getbillamount310field="00000">
<cfset getbillamount311field="00000">
<cfset getbillamount312field="00000">


<cfquery name="getbillamount2" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 11:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 11:59:59'

</cfquery>

<cfquery name="getbillamount3" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 11:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 11:59:59' order by refno desc

</cfquery>
<cfif getbillamount2.totalbill eq 0>
<cfset getbillamount2.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount3field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount3.lastrefno>
<cfset getbillamount3field=getbillamount3.lastrefno>
</cfif>

<cfquery name="getbillamount22" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 12:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 12:59:59'
</cfquery>

<cfquery name="getbillamount32" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 12:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 12:59:59' order by refno desc
</cfquery>
<cfif getbillamount22.totalbill eq 0>
<cfset getbillamount22.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount32field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount32.lastrefno>
<cfset getbillamount32field=getbillamount32.lastrefno>
</cfif>

<cfquery name="getbillamount23" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 13:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 13:59:59'
</cfquery>

<cfquery name="getbillamount33" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 13:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 13:59:59' order by refno desc
</cfquery>
<cfif getbillamount23.totalbill eq 0>
<cfset getbillamount23.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount33field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount33.lastrefno>
<cfset getbillamount33field=getbillamount33.lastrefno>
</cfif>


<cfquery name="getbillamount24" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 14:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 14:59:59'
</cfquery>

<cfquery name="getbillamount34" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 14:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 14:59:59' order by refno desc
</cfquery>
<cfif getbillamount24.totalbill eq 0>
<cfset getbillamount24.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount34field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount34.lastrefno>
<cfset getbillamount34field=getbillamount34.lastrefno>
</cfif>


<cfquery name="getbillamount25" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 15:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 15:59:59'
</cfquery>

<cfquery name="getbillamount35" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 15:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 15:59:59' order by refno desc
</cfquery>
<cfif getbillamount25.totalbill eq 0>
<cfset getbillamount25.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount35field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount35.lastrefno>
<cfset getbillamount35field=getbillamount35.lastrefno>
</cfif>


<cfquery name="getbillamount26" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 16:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 16:59:59'

</cfquery>

<cfquery name="getbillamount36" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 16:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 16:59:59' order by refno desc
</cfquery>
<cfif getbillamount26.totalbill eq 0>

<cfset getbillamount26.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount36field=getlastnumber.lastrefno>

<cfelse>
<cfset getlastnumber.lastrefno=getbillamount36.lastrefno>
<cfset getbillamount36field=getbillamount36.lastrefno>
</cfif>


<cfquery name="getbillamount27" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 17:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 17:59:59'
</cfquery>

<cfquery name="getbillamount37" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 17:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 17:59:59' order by refno desc
</cfquery>
<cfif getbillamount27.totalbill eq 0>
<cfset getbillamount27.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount37field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount37.lastrefno>
<cfset getbillamount37field=getbillamount37.lastrefno>
</cfif>

<cfquery name="getbillamount28" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 18:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 18:59:59'
</cfquery>

<cfquery name="getbillamount38" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 18:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 18:59:59' order by refno desc
</cfquery>
<cfif getbillamount28.totalbill eq 0>
<cfset getbillamount28.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount38field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount38.lastrefno>
<cfset getbillamount38field=getbillamount38.lastrefno>
</cfif>

<cfquery name="getbillamount29" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 19:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 19:59:59'
</cfquery>

<cfquery name="getbillamount39" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 19:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 19:59:59' order by refno desc
</cfquery>
<cfif getbillamount29.totalbill eq 0>
<cfset getbillamount29.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount39field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount39.lastrefno>
<cfset getbillamount39field=getbillamount39.lastrefno>
</cfif>

<cfquery name="getbillamount210" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 20:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 20:59:59'
</cfquery>

<cfquery name="getbillamount310" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 20:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 20:59:59' order by refno desc
</cfquery>
<cfif getbillamount210.totalbill eq 0>
<cfset getbillamount210.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount310field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount310.lastrefno>
<cfset getbillamount310field=getbillamount310.lastrefno>
</cfif>

<cfquery name="getbillamount211" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 21:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 21:59:59'
</cfquery>

<cfquery name="getbillamount311" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 21:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 21:59:59' order by refno desc
</cfquery>
<cfif getbillamount211.totalbill eq 0>
<cfset getbillamount211.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount311field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount311.lastrefno>
<cfset getbillamount311field=getbillamount311.lastrefno>
</cfif>

<cfquery name="getbillamount212" datasource="#dts#">
	select sum(grand_bil) as gross,ifnull(sum(tax_bil),0) as tax,sum(disc_bil) as disc,sum(roundadj) as roundadj,count(refno) as totalbill,ifnull(refno,0) as firstrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 22:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 22:59:59'
</cfquery>

<cfquery name="getbillamount312" datasource="#dts#">
	select ifnull(refno,0) as lastrefno from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null) and created_on between '#dateformat(ndatefrom,'YYYY-MM-DD')# 22:00:00' and '#dateformat(ndatefrom,'YYYY-MM-DD')# 22:59:59' order by refno desc
</cfquery>
<cfif getbillamount212.totalbill eq 0>
<cfset getbillamount212.firstrefno=getlastnumber.lastrefno>
<cfset getbillamount312field=getlastnumber.lastrefno>
<cfelse>
<cfset getlastnumber.lastrefno=getbillamount312.lastrefno>
<cfset getbillamount312field=getbillamount312.lastrefno>
</cfif>


<cfset control_header_record = "#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount2.firstrefno#|#getbillamount3field#|#val(getbillamount2.totalbill)#|#numberformat(val(getbillamount2.gross),'.00')#|I|N|#numberformat(val(getbillamount2.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount2.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|11:00:00|11:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount22.firstrefno#|#getbillamount32field#|#val(getbillamount22.totalbill)#|#numberformat(val(getbillamount22.gross),'.00')#|I|N|#numberformat(val(getbillamount22.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount22.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|12:00:00|12:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount23.firstrefno#|#getbillamount33field#|#val(getbillamount23.totalbill)#|#numberformat(val(getbillamount23.gross),'.00')#|I|N|#numberformat(val(getbillamount23.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount23.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|13:00:00|13:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount24.firstrefno#|#getbillamount34field#|#val(getbillamount24.totalbill)#|#numberformat(val(getbillamount24.gross),'.00')#|I|N|#numberformat(val(getbillamount24.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount24.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|14:00:00|14:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount25.firstrefno#|#getbillamount35field#|#val(getbillamount25.totalbill)#|#numberformat(val(getbillamount25.gross),'.00')#|I|N|#numberformat(val(getbillamount25.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount25.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|15:00:00|15:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount26.firstrefno#|#getbillamount36field#|#val(getbillamount26.totalbill)#|#numberformat(val(getbillamount26.gross),'.00')#|I|N|#numberformat(val(getbillamount26.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount26.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|16:00:00|16:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount27.firstrefno#|#getbillamount37field#|#val(getbillamount27.totalbill)#|#numberformat(val(getbillamount27.gross),'.00')#|I|N|#numberformat(val(getbillamount27.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount27.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|17:00:00|17:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount28.firstrefno#|#getbillamount38field#|#val(getbillamount28.totalbill)#|#numberformat(val(getbillamount28.gross),'.00')#|I|N|#numberformat(val(getbillamount28.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount28.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|18:00:00|18:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount29.firstrefno#|#getbillamount39field#|#val(getbillamount29.totalbill)#|#numberformat(val(getbillamount29.gross),'.00')#|I|N|#numberformat(val(getbillamount29.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount29.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|19:00:00|19:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount210.firstrefno#|#getbillamount310field#|#val(getbillamount210.totalbill)#|#numberformat(val(getbillamount210.gross),'.00')#|I|N|#numberformat(val(getbillamount210.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount210.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|20:00:00|20:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount211.firstrefno#|#getbillamount311field#|#val(getbillamount211.totalbill)#|#numberformat(val(getbillamount211.gross),'.00')#|I|N|#numberformat(val(getbillamount211.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount211.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|21:00:00|21:59:59
#getfilename.tenantno#|01|#dateformat(ndatefrom,'YYYYMMDD')#|#tranautorunno#|#getbillamount212.firstrefno#|#getbillamount312field#|#val(getbillamount212.totalbill)#|#numberformat(val(getbillamount212.gross),'.00')#|I|N|#numberformat(val(getbillamount212.tax),'.00')#|0.00|0.00|0.00|#numberformat(val(getbillamount212.roundadj),'.00')#|#dateformat(ndatefrom,'YYYYMMDD')#|22:00:00|22:59:59">

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" addNewLine="no" file = "#currentDirectory#\h#getfilename.tenantno#_01_#tranautorunno#_#dateformat(ndatefrom,'YYYYMMDD')##timeformat(now(),'HHMM')#.txt"  output = "#control_header_record#">
<cffile action = "write"  addNewLine="no" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\h#getfilename.tenantno#_01_#tranautorunno#_#dateformat(ndatefrom,'YYYYMMDD')##timeformat(now(),'HHMM')#.txt"
output = "#control_header_record#">

<cfquery name="update" datasource="#dts#">
	update POSFTP set tranno='#tranautorunno#'
</cfquery>

<cfelseif getfilename.mall eq 'capitaland'>
<cfset tranautorunno=numberformat(val(getfilename.tranno)+1,000)>

<cfquery name="getbillamount" datasource="#dts#">
	select * from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfquery name="getbillamount2" datasource="#dts#">
	select count(refno) as receiptcount,sum(net_bil) as net,sum(tax_bil) as tax,sum(disc_bil) as disc from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfset control_header_record = "D#getfilename.tenantno##dateformat(ndatefrom,'YYYYMMDD')##numberformat(getbillamount2.net,'000000000.00')#">

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" file = "#currentDirectory#\D#getfilename.tenantno#.#numberformat(val(tranautorunno),'000')#" <!---#getbillamount.recordcount#---> output = "#control_header_record#">
<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\D#getfilename.tenantno#.#numberformat(val(tranautorunno),'000')#"
output = "#control_header_record#">

<cfquery name="update" datasource="#dts#">
	update POSFTP set tranno='#tranautorunno#'
</cfquery>

<cfelseif getfilename.mall eq 'serangoon'>
<cfset tranautorunno=numberformat(val(getfilename.tranno)+1,000)>

<cfquery name="getbillamount" datasource="#dts#">
	select * from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfquery name="getbillamount2" datasource="#dts#">
	select count(refno) as receiptcount,sum(net_bil) as net,sum(tax_bil) as tax,sum(disc_bil) as disc from artran where type='CS' and wos_date='#dateformat(ndatefrom,'YYYY-MM-DD')#' and (void ='' or void is null)
</cfquery>

<cfset control_header_record = "#getfilename.tenantno#|#dateformat(ndatefrom,'DDMMYYYY')#|#tranautorunno#|0000|#getbillamount2.receiptcount#|#NumberFormat( val(getbillamount2.net), ".__")#|#NumberFormat( val(getbillamount2.tax), ".__" )#|#NumberFormat( val(getbillamount2.disc), ".__" )#|0">

<cfset currentDirectory = "#getfilename.posdirectory#">
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>


<cffile action = "write" file = "#currentDirectory#\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#TimeFormat(Now(), 'HHMMss')#.txt" output = "#control_header_record#">
<cffile action = "write" file = "C:\railo\tomcat\webapps\ROOT\default\transaction\POSSubmission\#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#TimeFormat(Now(), 'HHMMss')#.txt"
output = "#control_header_record#">

<cfquery name="update" datasource="#dts#">
	update POSFTP set tranno='#tranautorunno#'
</cfquery>


</cfif>
   <cfoutput>
   <form name="form1" id="form1" method="post" action="/default/transaction/POSSubmission/POSPost.cfm">
   <input type="hidden" name="afilename" id="afilename" value="#getfilename.tenantno#_#dateformat(ndatefrom,'YYYYMMDD')#_#TimeFormat(Now(), 'HHMMss')#.txt" />
   <input type="hidden" name="billdate" id="billdate" value="#dateformat(ndatefrom,'YYYYMMDD')#" />
   <input type="hidden" name="timenow" id="timenow" value="#timeformat(now(),'HHMMSS')#" />
   <input type="hidden" name="errorvalid" id="errorvalid" value="" />
   </form>
   </cfoutput>

 <script>
	form1.submit();
	</script>



