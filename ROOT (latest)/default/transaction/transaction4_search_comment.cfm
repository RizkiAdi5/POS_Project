<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfquery name="inserttemp" datasource="#dts#">
	insert into commentemp
	(
		type,
		refno,
		itemno,
		userid,
		comment
	)
	values
	(
		'#tran#',
		'#nexttranno#',
		'#itemno#',
		'#huserid#',
		
		<cfset CommentLen = len(tostring(comment))>
		<cfset xComment = tostring(comment)>
		<cfset SingleQ = ''>
		<cfset DoubleQ = ''>
		
		<cfloop index = "Count" from = "1" to = "#CommentLen#">
			<cfif mid(xComment,Count,1) eq "'">
				<cfset SingleQ = "Y">
		  	<cfelseif mid(xComment,Count,1) eq '"'>
				<cfset DoubleQ = "Y">
	  		</cfif>
		</cfloop>

		<cfif SingleQ eq "Y" and DoubleQ eq "">
			<!--- Found ' in the comment --->
			"#form.comment#"
		<cfelseif SingleQ eq "" and DoubleQ eq "Y">
			<!--- Found " in the comment --->
			'#form.comment#'
		<cfelseif SingleQ eq "" and DoubleQ eq "">
			'#form.comment#'
		<cfelse>
	  		<h3>Error. You cannot key in both ' and " in the comment.</h3>
	  		<cfabort>
		</cfif>
	)
</cfquery>

<cfoutput>
	<form name='form1' method='post' action='trancmentsearch.cfm?tran=#tran#&stype=#tranname#&hmode=#hmode#&type1=#type1#&nexttranno=#nexttranno#&itemno=#urlencodedformat(itemno)#&service=#service#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#&multilocation=#multilocation#<cfif type1 neq "Add">&itemcount=#itemcount#</cfif>'>
		<input type="hidden" name="adtcost1" value="#listfirst(adtcost1)#">			<input type="hidden" name="expdate" value="#listfirst(expdate)#">
		<input type="hidden" name="adtcost2" value="#listfirst(adtcost2)#">			<input type="hidden" name="gltradac" value="#listfirst(gltradac)#">
		<input type="hidden" name="agenno" value="#listfirst(agenno)#">				<input type="hidden" name="hmode" value="#listfirst(hmode)#">
		<input type="hidden" name="balance" value="#listfirst(balance)#">			<input type="hidden" name="invoicedate" value="#listfirst(invoicedate)#">
		<input type="hidden" name="itemcount" value="#listfirst(itemcount)#">		<input type="hidden" name="requestdate" value="#listfirst(requestdate)#">
		<input type="hidden" name="brem3" value="#convertquote(listfirst(brem3))#">	<input type="hidden" name="itemno" value="#convertquote(listfirst(itemno))#">
		<input type="hidden" name="brem4" value="#convertquote(listfirst(brem4))#">	<input type="hidden" name="items" value="#listfirst(items)#">
		<input type="hidden" name="comment" value="#convertquote(comment)#">		<input type="hidden" name="location" value="#listfirst(location)#">
		<input type="hidden" name="compareqty" value="#listfirst(compareqty)#">		<input type="hidden" name="mc1bil" value="#listfirst(mc1bil)#">
		<input type="hidden" name="crequestdate" value="#listfirst(crequestdate)#">	<input type="hidden" name="mc2bil" value="#listfirst(mc2bil)#">
		<input type="hidden" name="currrate" value="#listfirst(currrate)#">			<input type="hidden" name="mode" value="#listfirst(mode)#">
		<input type="hidden" name="custno" value="#listfirst(custno)#">				<input type="hidden" name="ndatecreate" value="#listfirst(ndatecreate)#">
		<input type="hidden" name="defective" value="#listfirst(defective)#">		<input type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
		<input type="hidden" name="desp" value="#convertquote(desp)#">				<input type="hidden" name="oldenterbatch" value="#listfirst(oldenterbatch)#">
		<input type="hidden" name="despa" value="#convertquote(despa)#">			<input type="hidden" name="oldlocation" value="#listfirst(oldlocation)#">
		<input type="hidden" name="dispec1" value="#listfirst(dispec1)#">			<input type="hidden" name="oldqty" value="#listfirst(oldqty)#">
		<input type="hidden" name="dispec2" value="#listfirst(dispec2)#">			<input type="hidden" name="price" value="#listfirst(form.price)#">
		<input type="hidden" name="dispec3" value="#listfirst(dispec3)#">			<input type="hidden" name="qty" value="#listfirst(form.qty)#">
		<input type="hidden" name="dodate" value="#listfirst(dodate)#">				<input type="hidden" name="readperiod" value="#listfirst(readperiod)#">
		<input type="hidden" name="enterbatch" value="#listfirst(enterbatch)#">		<input type="hidden" name="refno3" value="#listfirst(refno3)#">
		<input type="hidden" name="sercost" value="#listfirst(sercost)#">			<input type="hidden" name="service" value="#convertquote(listfirst(service))#">
		<input type="hidden" name="sodate" value="#listfirst(sodate)#">				<input type="hidden" name="sv_part" value="#listfirst(sv_part)#">
		<input type="hidden" name="taxpec1" value="#listfirst(taxpec1)#">			<input type="hidden" name="tran" value="#listfirst(tran)#">
		<input type="hidden" name="type" value="#listfirst(type)#">					<input type="hidden" name="type1" value="#listfirst(type1)#">
		<input type="hidden" name="unit" value="#convertquote(listfirst(unit))#">	<input type="hidden" name="newtrancode" value="#newtrancode#">
		<cfif isdefined("batchqty")>
			<input type="hidden" name="batchqty" value="#listfirst(batchqty)#">
			<input type="hidden" name="enterbatch1" value="#listfirst(enterbatch1)#">
		<cfelse>
			<input type="hidden" name="batchqty" value="0">
			<input type="hidden" name="enterbatch1" value="">
		</cfif>
		<input type="hidden" name="multilocation" value="#listfirst(multilocation)#">
		<cfif checkcustom.customcompany eq "Y">
			<input type="hidden" name="remark5" value="#listfirst(form.hremark5)#">	<!--- PERMIT NUMBER, ADD ON 24-03-2009 --->
			<input type="hidden" name="remark6" value="#listfirst(form.hremark6)#">
		</cfif>
	</form>
</cfoutput>

<script>
	form1.submit();
</script>
<cfabort>