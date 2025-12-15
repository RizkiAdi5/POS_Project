<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>
<cfif lcase(hcomid) eq "pengwang_i" or lcase(hcomid) eq "pingwang_i" or lcase(hcomid) eq "huanhong_i" or lcase(hcomid) eq "demo_i" or lcase(hcomid) eq "ptpw_i" or lcase(hcomid) eq "huanhongpt_i">
<cftry>
<cfset userbrowser = #CGI.HTTP_USER_AGENT#>
<cfquery name="trackinput" datasource="#dts#">
INSERT INTO trackinput (type,refno,itemno,price,qty,amt,trdatetime,disc1,disc2,disc3,discamt,userid,browsertype)
values
(
'#tran#',
'#nexttranno#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#convertquote(itemno)#">,
'#listfirst(form.price)#',
'#listfirst(form.qty)#',
'#listfirst(form.amt)#',
now(),
'#listfirst(dispec1)#',
'#listfirst(dispec2)#',
'#listfirst(dispec3)#',
'#listfirst(discamt)#',
'#huserid#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#userbrowser#">
)
</cfquery>
<cfcatch type="any">

</cfcatch>
</cftry>
</cfif>
<cfoutput>
<cfparam name = "form.selecttax" default = "">
<cfif isdefined("form.multilocation") and form.multilocation eq "Y" and listfirst(service) eq "">

	<form name='form1' method='post' action='transactionprocess2.cfm?nDateCreate=#nDateCreate#'>
		<input type='hidden' id="tr1" name='tran' value='#tran#'>
   		<input name='type' id="in1" value='Inprogress' type='hidden'>
		<input name='agenno' id="ag1" value='#listfirst(agenno)#' type='hidden'>

		<cfif isdefined("form.updunitcost")>
  			<input type='hidden' id="up1" name='updunitcost' value='#form.updunitcost#'>
		</cfif>
	
		<!--- <input type='hidden' name='location' id="lo1" value='#listfirst(location)#'> --->
		<input type='hidden' name='taxpec1' id="tax1" value='#listfirst(taxpec1)#'>
		<input type='hidden' name='dispec1' id="di11" value='#listfirst(dispec1)#'>
		<input type='hidden' name='dispec2' id="di21" value='#listfirst(dispec2)#'>
		<input type='hidden' name='dispec3' id="di31"  value='#listfirst(dispec3)#'>
		<!--- ADD ON 230908, the disc amount passed from form  --->
   		<input type='hidden' name='discamt' id="discamt"  value='#listfirst(discamt)#'>
		<input type='hidden' name='brem4' id="br41" value='#convertquote(brem4)#'>
		<input type='hidden' name='brem3' id="br31" value='#convertquote(brem3)#'>
		<input type='hidden' name='packing' id="packing" value='#convertquote(listfirst(packing))#'>
		<input type='hidden' name='shelf' id="shelf" value='#convertquote(listfirst(shelf))#'>
		<cfif lcase(hcomid) eq "avent_i" >	<!--- ADD ON 18-03-2009, FOR AVENT PACKING LIST --->
			<input type='hidden' name='brem5' value='#convertquote(listfirst(brem5))#'>
			<input type='hidden' name='brem6' value='#convertquote(listfirst(brem6))#'>
       	<cfelseif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
			<input type='hidden' name='brem5' value='#convertquote(listfirst(brem5))#'>
			<input type='hidden' name='brem6' value='#convertquote(listfirst(brem6))#'>
            <input type='hidden' name='brem7' value='#convertquote(listfirst(brem7))#'>
            <input type='hidden' name='brem8' value='#convertquote(listfirst(brem8))#'>
            <input type='hidden' name='brem9' value='#convertquote(listfirst(brem9))#'>
		</cfif>
	
		<cfif isdefined("form.requestdate")>
			<input type='hidden' name='requestdate' id="req1" value='#requestdate#'>
		</cfif>
	
		<cfif isdefined("form.crequestdate")>
			<input type='hidden' name='crequestdate' id="cre1" value='#crequestdate#'>
		</cfif>
	
		<input type='hidden' name='gltradac' id="gl1" value='#listfirst(gltradac)#'>
		<input type='hidden' name='price' id="pr1" value='#listfirst(form.price)#'>
		<input type='hidden' name='qty' id="qt1" value='#listfirst(form.qty)#'>
		<!--- ADD ON 090608, PASS THE AMOUNT FROM THE FORM --->
		<!--- <input type='hidden' name='amt' id="amt" value='#listfirst(form.amt)#'> --->
		<input type='hidden' name='unit' id="uni1" value='#listfirst(unit)#'>
		<input type='hidden' name='service' id="ser1" value='#convertquote(listfirst(service))#'>
		<input type='hidden' name='sv_part' id="sv1" value='#convertquote(listfirst(sv_part))#'>
		<input type='hidden' name='sercost' id="sc1" value='#listfirst(sercost)#'>
		<input type='hidden' name='desp' id="des1" value='#convertquote(desp)#'>
		<input type='hidden' name='despa' id="depa1" value='#convertquote(despa)#'>
		<input type='hidden' name='currrate' id="cur1" value='#listfirst(currrate)#'>
		<input type='hidden' name='refno3' id="ref1" value='#listfirst(refno3)#'>
		<input type='hidden' name='mode' id="mo1" value='#listfirst(mode)#'>
		<input type='hidden' name='hmode' id="hmo1" value='#listfirst(hmode)#'>
		<input type='hidden' name='nexttranno' id="net1" value='#listfirst(nexttranno)#'>
		<input type='hidden' name='custno' id="cus1" value='#listfirst(custno)#'>
		<input type='hidden' name='readperiod' id="pr1" value='#listfirst(readperiod)#'>
		<input type='hidden' name='invoicedate' id="dt1" value='#listfirst(form.invoicedate)#'>
		<input type='hidden' name='itemno' id="itm1" value='#convertquote(itemno)#'>
		
		<input type="hidden" name="newtrancode" value="#newtrancode#">
		<!--- Add On 260908, For 2nd Unit --->
		<input type="hidden" name="factor1" value="#val(listfirst(factor1))#">
		<input type="hidden" name="factor2" value="#val(listfirst(factor2))#">
		
		<!--- Add On 01-12-2008 --->
		<cfif isdefined("form.nodisplay")>
  			<input type='hidden' id="nodisplay" name='nodisplay' value='Y'>
		<cfelse>
			<input type='hidden' id="nodisplay" name='nodisplay' value='N'>
		</cfif>
        
        <cfif isdefined("form.asvoucher")>
        	<input type="hidden" id="asvoucher" name="asvoucher" value="Y" />
            <input type="hidden" id="voucherno" name="voucherno" value="#form.voucherno#" />
        </cfif>
        <cfif isdefined("form.it_cos")>
        	<input type="hidden" id="it_cos" name="it_cos" value="#form.it_cos#" />
 		</cfif>
		<!--- ADD ON 25-02-2009 --->
		<input type='hidden' id="title_id" name='title_id' value='#listfirst(title_id)#'>
		<!--- ADD ON 26-02-2009 --->
		<input type='hidden' id="title_desp" name='title_desp' value='#URLENCODEDFORMAT(title_desp)#'>
		<!--- ADD ON 21-04-2009 --->
        <cfif isdefined('form.ictranfilename')>
        <cfif form.ictranfile neq "">
        <cfset filepath = expandpath('/download/#dts#/')>
         <cffile action="upload" filefield="ictranfile" destination="#filepath#" nameconflict="makeunique">
         <cfset form.ictranfilename = file.ServerFile>
        </cfif>  
        <input type='hidden' id="ictranfilename" name='ictranfilename' value='#form.ictranfilename#'>
        </cfif>
		<cfif lcase(hcomid) eq "topsteel_i" or lcase(hcomid) eq "topsteelhol_i">
			<input type='hidden' id="title_despa" name='title_despa' value='#convertquote(title_despa)#'>
		</cfif>
		
		<!--- Add On 25-11-2008 --->
		<input type="hidden" name="qtylist" value="#qtylist#">
		<input type="hidden" name="oldqtylist" value="#oldqtylist#">
		<input type="hidden" name="locationlist" value="#locationlist#">
		<input type="hidden" name="batchlist" value="#batchlist#">
		
		<!--- ADD ON 05-12-2008 --->
		<input type="hidden" name="oldbatchlist" value="#oldbatchlist#">
		<input type="hidden" name="mc1billist" value="#mc1billist#">
		<input type="hidden" name="mc2billist" value="#mc2billist#">
		<input type="hidden" name="sodatelist" value="#sodatelist#">
		<input type="hidden" name="dodatelist" value="#dodatelist#">
		<input type="hidden" name="expdatelist" value="#expdatelist#">
        <input type="hidden" name="milcertlist" value="#milcertlist#">
        <input type="hidden" name="importpermitlist" value="#importpermitlist#">
        
		<input type="hidden" name="defectivelist" value="#defectivelist#">
		
		<cfif checkcustom.customcompany eq "Y">
			<input type="hidden" name="hremark5" value="#listfirst(hremark5)#">	<!--- PERMIT NUMBER, ADD ON 24-03-2009 --->
			<input type="hidden" name="hremark6" value="#listfirst(hremark6)#">
			<input type="hidden" name="bremark8" value="#listfirst(bremark8)#">
			<input type="hidden" name="bremark9" value="#listfirst(bremark9)#">
			<input type="hidden" name="bremark10" value="#listfirst(bremark10)#">
		</cfif>
        
        <!--- ADD ON 24052009--->
        <input type="hidden" name="supp" value="#listfirst(supp)#">
		
		<!--- ADD ON 10-12-2009 --->
		<input type="hidden" name="source" value="#form.source#">
		<input type="hidden" name="job" value="#form.job#">
		
		<!--- ADD ON 05-06-2009 --->
		<input type="hidden" name="qty1" value="#listfirst(qty1)#">
		<input type="hidden" name="qty2" value="#listfirst(qty2)#">
		<input type="hidden" name="qty3" value="#listfirst(qty3)#">
		<input type="hidden" name="qty4" value="#listfirst(qty4)#">
		<input type="hidden" name="qty5" value="#listfirst(qty5)#">
		<input type="hidden" name="qty6" value="#listfirst(qty6)#">
		<input type="hidden" name="qty7" value="#listfirst(qty7)#">
        <input type="hidden" name="selecttax" value="#listfirst(selecttax)#">
        <input type="hidden" name="taxamt_bil" value="#val(taxamt_bil)#" />
        <cfif isdefined('form.taxincl')>
        <input type="hidden" name="taxinclude" value="#form.taxincl#"  />
		</cfif>
		
		<cfset CommentLen = len(tostring(form.comment))>
		<cfset xComment = tostring(form.comment)>
		<cfset SingleQ = "">
		<cfset DoubleQ = "">
	
		<cfloop index = "Count" from = "1" to = "#CommentLen#">
			<cfif mid(xComment,Count,1) eq "'">
				<cfset SingleQ = "Y">
			<cfelseif mid(xComment,Count,1) eq '"'>
				<cfset DoubleQ = "Y">
			</cfif>
		</cfloop>
		
		<cfif SingleQ eq "Y" and DoubleQ eq "">
			<!--- Found ' in the comment --->
			<input type='hidden' name='comment' id="comm1" value="#convertquote(form.comment)#">
		<cfelseif SingleQ eq "" and DoubleQ eq "Y">
			<!--- Found " in the comment --->
			<input type='hidden' name='comment' id="comm2" value='#convertquote(form.comment)#'>
		<cfelseif SingleQ eq "" and DoubleQ eq "">
			<input type='hidden' name='comment' id="comm3" value='#convertquote(form.comment)#'>
		<cfelse>
			<h3>Error. You cannot key in both ' and " in the comment.</h3>
			<cfabort>
		</cfif>
		
		<cfif type1 neq "Add">
			<input type='hidden' name='itemcount' id="itct1" value='#listfirst(itemcount)#'>
		</cfif>
	</form>
<cfelse>

	<form name='form1' method='post' action='transactionprocess.cfm?nDateCreate=#nDateCreate#' <cfif mode neq 'delete'>onsubmit='return validate()'</cfif>>
		<input type='hidden' id="tr1" name='tran' value='#tran#'>
   		<input name='type' id="in1" value='Inprogress' type='hidden'>
		<input name='agenno' id="ag1" value='#listfirst(agenno)#' type='hidden'>

		<cfif isdefined("form.updunitcost")>
  			<input type='hidden' id="up1" name='updunitcost' value='#form.updunitcost#'>
		</cfif>
	
		<input type='hidden' name='location' id="lo1" value='#listfirst(location)#'>
		<input type='hidden' name='taxpec1' id="tax1" value='#listfirst(taxpec1)#'>
		<input type='hidden' name='dispec1' id="di11" value='#listfirst(dispec1)#'>
		<input type='hidden' name='dispec2' id="di21" value='#listfirst(dispec2)#'>
		<input type='hidden' name='dispec3' id="di31"  value='#listfirst(dispec3)#'>
		<!--- ADD ON 230908, the disc amount passed from form  --->
   		<input type='hidden' name='discamt' id="discamt"  value='#listfirst(discamt)#'>
		<input type='hidden' name='brem4' id="br41" value='#convertquote(brem4)#'>
		<input type='hidden' name='brem3' id="br31" value='#convertquote(brem3)#'>
		<input type='hidden' name='packing' id="packing" value='#convertquote(listfirst(packing))#'>
		<input type='hidden' name='shelf' id="shelf" value='#convertquote(listfirst(shelf))#'>
		<cfif lcase(hcomid) eq "avent_i" >	<!--- ADD ON 18-03-2009, FOR AVENT PACKING LIST --->
			<input type='hidden' name='brem5' value='#convertquote(listfirst(brem5))#'>
			<input type='hidden' name='brem6' value='#convertquote(listfirst(brem6))#'>
        <cfelseif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
			<input type='hidden' name='brem5' value='#convertquote(listfirst(brem5))#'>
			<input type='hidden' name='brem6' value='#convertquote(listfirst(brem6))#'>
            <input type='hidden' name='brem7' value='#convertquote(listfirst(brem7))#'>
			<input type='hidden' name='brem8' value='#convertquote(listfirst(brem8))#'>
            <input type='hidden' name='brem9' value='#convertquote(listfirst(brem9))#'>
		</cfif>
	
		<cfif isdefined("form.requestdate")>
			<input type='hidden' name='requestdate' id="req1" value='#requestdate#'>
		</cfif>
	
		<cfif isdefined("form.crequestdate")>
			<input type='hidden' name='crequestdate' id="cre1" value='#crequestdate#'>
		</cfif>
	
		<input type='hidden' name='gltradac' id="gl1" value='#listfirst(gltradac)#'>
		<input type='hidden' name='price' id="pr1" value='#listfirst(form.price)#'>
		<input type='hidden' name='qty' id="qt1" value='#listfirst(form.qty)#'>
		<!--- ADD ON 090608, PASS THE AMOUNT FROM THE FORM --->
		<input type='hidden' name='amt' id="amt" value='#listfirst(form.amt)#'>
		<input type='hidden' name='unit' id="uni1" value='#listfirst(unit)#'>
		<input type='hidden' name='service' id="ser1" value='#convertquote(listfirst(service))#'>
		<input type='hidden' name='sv_part' id="sv1" value='#convertquote(listfirst(sv_part))#'>
		<input type='hidden' name='sercost' id="sc1" value='#listfirst(sercost)#'>
		<input type='hidden' name='desp' id="des1" value='#convertquote(desp)#'>
		<input type='hidden' name='despa' id="depa1" value='#convertquote(despa)#'>
		<input type='hidden' name='currrate' id="cur1" value='#listfirst(currrate)#'>
		<input type='hidden' name='refno3' id="ref1" value='#listfirst(refno3)#'>
		<input type='hidden' name='mode' id="mo1" value='#listfirst(mode)#'>
		<input type='hidden' name='hmode' id="hmo1" value='#listfirst(hmode)#'>
		<input type='hidden' name='nexttranno' id="net1" value='#listfirst(nexttranno)#'>
		<input type='hidden' name='custno' id="cus1" value='#listfirst(custno)#'>
		<input type='hidden' name='readperiod' id="pr1" value='#listfirst(readperiod)#'>
		<input type='hidden' name='invoicedate' id="dt1" value='#listfirst(form.invoicedate)#'>
		<input type='hidden' name='itemno' id="itm1" value='#convertquote(itemno)#'>
		<input name='oldlocation' id='oldlocation' type='hidden' value='#listfirst(oldlocation)#'>
		<input name='oldenterbatch' id='oldenterbatch' type='hidden' value='#listfirst(oldenterbatch)#'>
		<input name='oldqty' id="oldqty" type='hidden' size='10' maxlength='10' value='#listfirst(oldqty)#'>
		<input name='dodate' id='dodate' type='hidden' value='#listfirst(dodate)#'>
		<input name='sodate' id='sodate' type='hidden' value='#listfirst(sodate)#'>
		<input name='adtcost1' id='adtcost1' type='hidden' value='#listfirst(mc1bil)#'>
		<input name='adtcost2' id='adtcost2' type='hidden' value='#listfirst(mc2bil)#'>
		<input name='enterbatch' id='enterbatch' type="hidden" value='#listfirst(form.enterbatch)#'>
		<input name='expdate' id='expdate' type='hidden' value="#listfirst(expdate)#">
        <input name='manudate' id='manudate' type='hidden' value="#listfirst(manudate)#">
        <input name='milcert' id='milcert' type='hidden' value="#listfirst(milcert)#">
        <input name='importpermit' id='importpermit' type='hidden' value="#listfirst(importpermit)#">
		<input name='mc1bil' id='mc1bil' type='hidden' value='#listfirst(mc1bil)#'>
		<input name='mc2bil' id='mc2bil' type='hidden' value='#listfirst(mc2bil)#'>
		<input name='defective' id='defective' type='hidden' value='#listfirst(defective)#'>
		<input type="hidden" name="newtrancode" value="#newtrancode#">
		<!--- Add on 010908 for Graded Item --->
		<input type="hidden" name="grdcolumnlist" value="#grdcolumnlist#">
		<input type="hidden" name="bgrdcolumnlist" value="#bgrdcolumnlist#">
	    <input type="hidden" name="grdvaluelist" value="#grdvaluelist#">
		<input type="hidden" name="totalrecord" value="#totalrecord#">
		<input type="hidden" name="oldgrdvaluelist" value="#oldgrdvaluelist#">
		<!--- Add On 260908, For 2nd Unit --->
		<input type="hidden" name="factor1" value="#val(listfirst(factor1))#">
		<input type="hidden" name="factor2" value="#val(listfirst(factor2))#">
		
		<!--- Add On 01-12-2008 --->
		<cfif isdefined("form.nodisplay")>
  			<input type='hidden' id="nodisplay" name='nodisplay' value='Y'>
		<cfelse>
			<input type='hidden' id="nodisplay" name='nodisplay' value='N'>
		</cfif>
        <cfif isdefined("form.asvoucher")>
        	<input type="hidden" id="asvoucher" name="asvoucher" value="Y" />
            <input type="hidden" id="voucherno" name="voucherno" value="#form.voucherno#" />
        </cfif>
        
        <cfif isdefined("form.foc")>
        	<input type="hidden" id="foc" name="foc" value="#form.foc#" />
		</cfif>
        <cfif isdefined("form.promotiontype")>
        	<input type="hidden" id="promotiontype" name="promotiontype" value="#form.promotiontype#" />
		</cfif>
        <cfif isdefined("form.it_cos")>
        	<input type="hidden" id="it_cos" name="it_cos" value="#form.it_cos#" />
 		</cfif>
		<!--- ADD ON 25-02-2009 --->
		<input type='hidden' id="title_id" name='title_id' value='#listfirst(title_id)#'>
		<!--- ADD ON 26-02-2009 --->
		<input type='hidden' id="title_desp" name='title_desp' value='#URLENCODEDFORMAT(title_desp)#'>
		<!--- ADD ON 21-04-2009 --->
        <cfif isdefined('form.ictranfilename')>
        <cfif form.ictranfile neq "">
        <cfset filepath = expandpath('/download/#dts#/')>
         <cffile action="upload" filefield="ictranfile" destination="#filepath#" nameconflict="makeunique">
         <cfset form.ictranfilename = file.ServerFile>
        </cfif>  
        <input type='hidden' id="ictranfilename" name='ictranfilename' value='#form.ictranfilename#'>
        </cfif>
		<cfif lcase(hcomid) eq "topsteel_i" or lcase(hcomid) eq "topsteelhol_i">
			<input type='hidden' id="title_despa" name='title_despa' value='#convertquote(title_despa)#'>
		</cfif>
		
		<cfif checkcustom.customcompany eq "Y">
			<input type="hidden" name="hremark5" value="#listfirst(hremark5)#">	<!--- PERMIT NUMBER, ADD ON 24-03-2009 --->
			<input type="hidden" name="hremark6" value="#listfirst(hremark6)#">
			<input type="hidden" name="bremark8" value="#listfirst(bremark8)#">
			<input type="hidden" name="bremark9" value="#listfirst(bremark9)#">
			<input type="hidden" name="bremark10" value="#listfirst(bremark10)#">
		</cfif>
        
        <!--- ADD ON 24052009--->
        <input type="hidden" name="supp" value="#listfirst(supp)#">
		
		<!--- ADD ON 10-12-2009 --->
		<input type="hidden" name="source" value="#form.source#">
		<input type="hidden" name="job" value="#form.job#">
		
		<!--- ADD ON 05-06-2009 --->
		<input type="hidden" name="qty1" value="#listfirst(qty1)#">
		<input type="hidden" name="qty2" value="#listfirst(qty2)#">
		<input type="hidden" name="qty3" value="#listfirst(qty3)#">
		<input type="hidden" name="qty4" value="#listfirst(qty4)#">
		<input type="hidden" name="qty5" value="#listfirst(qty5)#">
		<input type="hidden" name="qty6" value="#listfirst(qty6)#">
		<input type="hidden" name="qty7" value="#listfirst(qty7)#">
        <input type="hidden" name="selecttax" value="#listfirst(selecttax)#">
        <input type="hidden" name="taxamt_bil" value="#val(taxamt_bil)#" />
	    <cfif isdefined('form.taxincl')>
        <input type="hidden" name="taxinclude" value="#form.taxincl#"  />
        
		</cfif>
		<!---
		<input type="hidden" name="grd11" value="#grd11#"><input type="hidden" name="grd41" value="#grd41#">
		<input type="hidden" name="grd12" value="#grd12#"><input type="hidden" name="grd42" value="#grd42#">
		<input type="hidden" name="grd13" value="#grd13#"><input type="hidden" name="grd43" value="#grd43#">
		<input type="hidden" name="grd14" value="#grd14#"><input type="hidden" name="grd44" value="#grd44#">
		<input type="hidden" name="grd15" value="#grd15#"><input type="hidden" name="grd45" value="#grd45#">
		<input type="hidden" name="grd16" value="#grd16#"><input type="hidden" name="grd46" value="#grd46#">
		<input type="hidden" name="grd17" value="#grd17#"><input type="hidden" name="grd47" value="#grd47#">
		<input type="hidden" name="grd18" value="#grd18#"><input type="hidden" name="grd48" value="#grd48#">
		<input type="hidden" name="grd19" value="#grd19#"><input type="hidden" name="grd49" value="#grd49#">
		<input type="hidden" name="grd20" value="#grd20#"><input type="hidden" name="grd50" value="#grd50#">
		<input type="hidden" name="grd21" value="#grd21#"><input type="hidden" name="grd51" value="#grd51#">
		<input type="hidden" name="grd22" value="#grd22#"><input type="hidden" name="grd52" value="#grd52#">
		<input type="hidden" name="grd23" value="#grd23#"><input type="hidden" name="grd53" value="#grd53#">
		<input type="hidden" name="grd24" value="#grd24#"><input type="hidden" name="grd54" value="#grd54#">
		<input type="hidden" name="grd25" value="#grd25#"><input type="hidden" name="grd55" value="#grd55#">
		<input type="hidden" name="grd26" value="#grd26#"><input type="hidden" name="grd56" value="#grd56#">
		<input type="hidden" name="grd27" value="#grd27#"><input type="hidden" name="grd57" value="#grd57#">
		<input type="hidden" name="grd28" value="#grd28#"><input type="hidden" name="grd58" value="#grd58#">
		<input type="hidden" name="grd29" value="#grd29#"><input type="hidden" name="grd59" value="#grd59#">
		<input type="hidden" name="grd30" value="#grd30#"><input type="hidden" name="grd60" value="#grd60#">
		<input type="hidden" name="grd31" value="#grd31#"><input type="hidden" name="grd61" value="#grd61#">
		<input type="hidden" name="grd32" value="#grd32#"><input type="hidden" name="grd62" value="#grd62#">
		<input type="hidden" name="grd33" value="#grd33#"><input type="hidden" name="grd63" value="#grd63#">
		<input type="hidden" name="grd34" value="#grd34#"><input type="hidden" name="grd64" value="#grd64#">
		<input type="hidden" name="grd35" value="#grd35#"><input type="hidden" name="grd65" value="#grd65#">
		<input type="hidden" name="grd36" value="#grd36#"><input type="hidden" name="grd66" value="#grd66#">
		<input type="hidden" name="grd37" value="#grd37#"><input type="hidden" name="grd67" value="#grd67#">
		<input type="hidden" name="grd38" value="#grd38#"><input type="hidden" name="grd68" value="#grd68#">
		<input type="hidden" name="grd39" value="#grd39#"><input type="hidden" name="grd69" value="#grd69#">
		<input type="hidden" name="grd40" value="#grd40#"><input type="hidden" name="grd70" value="#grd70#"> 
		--->
		
		<cfset CommentLen = len(tostring(form.comment))>
		<cfset xComment = tostring(form.comment)>
		<cfset SingleQ = "">
		<cfset DoubleQ = "">
	
		<cfloop index = "Count" from = "1" to = "#CommentLen#">
			<cfif mid(xComment,Count,1) eq "'">
				<cfset SingleQ = "Y">
			<cfelseif mid(xComment,Count,1) eq '"'>
				<cfset DoubleQ = "Y">
			</cfif>
		</cfloop>
		
		<cfif SingleQ eq "Y" and DoubleQ eq "">
			<!--- Found ' in the comment --->
			<input type='hidden' name='comment' id="comm1" value="#convertquote(form.comment)#">
		<cfelseif SingleQ eq "" and DoubleQ eq "Y">
			<!--- Found " in the comment --->
			<input type='hidden' name='comment' id="comm2" value='#convertquote(form.comment)#'>
		<cfelseif SingleQ eq "" and DoubleQ eq "">
			<input type='hidden' name='comment' id="comm3" value='#convertquote(form.comment)#'>
		<cfelse>
			<h3>Error. You cannot key in both ' and " in the comment.</h3>
			<cfabort>
		</cfif>
		
		<cfif type1 neq "Add">
			<input type='hidden' name='itemcount' id="itct1" value='#listfirst(itemcount)#'>
		</cfif>
	</form>
</cfif>

</cfoutput>

<script>
	form1.submit();
</script>


<cfabort>