<cfquery name="getGSetup" datasource="#dts#">
  	select compro,compro2,compro3,compro4,compro5,compro6,compro7,gstno from gsetup 
</cfquery>
<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall from gsetup
</cfquery>


<cfset lastyear = year(getgeneral.lastaccyear)>
	<cfset lastmonth = month(getgeneral.lastaccyear)>
	<cfset lastday = 1>
	<cfset selectedmonth = val(form.periodfrom)>
	<cfset count = 1>
	<cfset nodays = arraynew(1)>
	<cfset lastmonth = lastmonth + selectedmonth>
	<cfif lastmonth gt 24>
		<cfset lastyear = lastyear + 2>
		<cfset lastmonth = lastmonth -24>
        <cfelseif lastmonth gt 12>
        <cfset lastyear = lastyear + 1>
		<cfset lastmonth = lastmonth -12>
	</cfif>

	<cfset firstdate = dateformat(createdate(lastyear,lastmonth,1),'DD/MM/YYYY')>
    
    <cfset totalday = daysinmonth(createdate(lastyear,lastmonth,1))>
	<cfset lastdate = dateformat(createdate(lastyear,lastmonth,totalday),'DD/MM/YYYY')>



<cfoutput>

<cfquery name="MyQuery" datasource="#dts#">
select * from (
select wos_date,sum(invgross) as amt,sum(tax) as tax,sum(grand) as grand,van from artran
		where wos_date > #getgeneral.lastaccyear# and fperiod = '#form.periodfrom#' and (void = '' or void is null)
		and (type = 'INV' or type = 'CS')
		group by van,wos_date
		order by van,wos_date) as aa
        
        left join (select sum(grand) as grandtotal,sum(tax) as grandtax,sum(invgross) as grandamt,van from artran
		where wos_date > #getgeneral.lastaccyear# and fperiod = '#form.periodfrom#' and (void = '' or void is null)
		and (type = 'INV' or type = 'CS')
		group by van
		order by van
        ) as bb on aa.van=bb.van
</cfquery>

</cfoutput>
<cfset reportname = "dailysalesreport.cfr">


<cfreport template="#reportname#" format="PDF" query="MyQuery" report="dailysalesreport.cfr"><!--- or "FlashPaper" or "Excel" or "RTF" --->
	<cfreportparam name="compro" value="#getGSetup.compro#">
	<cfreportparam name="compro2" value="#getGSetup.compro2#">
	<cfreportparam name="compro3" value="#getGSetup.compro3#">
	<cfreportparam name="compro4" value="#getGSetup.compro4#">
	<cfreportparam name="compro5" value="#getGSetup.compro5#">
	<cfreportparam name="compro6" value="#getGSetup.compro6#">
	<cfreportparam name="compro7" value="#getGSetup.compro7#">
    <cfreportparam name="datefrom" value="#firstdate#">
	<cfreportparam name="dateto" value="#lastdate#">
    <cfreportparam name="dts" value="#form.periodfrom#">
    <cfreportparam name="gstno" value="#getGSetup.gstno#">
    
</cfreport>
