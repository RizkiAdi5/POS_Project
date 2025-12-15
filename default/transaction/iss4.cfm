<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfquery name="gettranname" datasource="#dts#">
select lconsignin,lconsignout,lISS,lOAI,lOAR,lbatch from gsetup
</cfquery> 

<cfquery datasource="#dts#" name="getGeneralInfo">
	select a.*,(concat('.',repeat('_',decl_uprice))) as decl_uprice 
	from gsetup as a,gsetup2 as b
</cfquery>
<html>
<head>
<title>Item Assembly</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<cfif isdefined('consignment')>
<cfset consignment=consignment>
<cfelse>
<cfset consignment=''>
</cfif>



<script language="javascript" type="text/javascript">
	function trim(str) {
		str = str.replace(/^\s+/, '');
		for (var i = str.length - 1; i >= 0; i--) {
			if (/\S/.test(str.charAt(i))) {
				str = str.substring(0, i + 1);
				break;
			}
		}
		return str;
	}
	
	function data_validation()
	{
		<!--- INSERT COMPULSORY LOCATION CHECKING --->
		<cfinclude template = "transaction_setting_checking/compulsory_location_iss4.cfm">
		<!--- INSERT COMPULSORY LOCATION CHECKING --->
		
		<cfif checkcustom.customcompany eq "Y">
			<!--- INSERT COMPULSORY BATCHCODE CHECKING --->
			<cfinclude template = "transaction_setting_checking/compulsory_batchcode_transaction4.cfm">
			<!--- INSERT COMPULSORY BATCHCODE CHECKING --->
		</cfif>
	}
	
	function getbalqty(location){
		<!---var itemno = document.form1.items.value;
		DWREngine._execute(_tranflocation, null, 'getbalqty', escape(itemno), location, showbalqty);--->
		var itemno = document.form1.items.value;
		var trancode = document.form1.itemcount.value;
		var type = document.form1.tran.value;
		var refno = document.form1.nexttranno.value;
		DWREngine._execute(_tranflocation, null, 'getbalqty', escape(itemno),trancode,type,refno, location, showbalqty);
	}
	
	function showbalqty(qtyObject){
		DWRUtil.setValue("balance", qtyObject.BALONHAND);
		//document.getElementById("balance").value=qtyObject.BALONHAND;
	}
	
	function AssignGrade(tran,ttran){
		var itemno = document.form1.items.value;
		var trancode = document.form1.itemcount.value;
		if(tran == 'TR'){
			var location = document.form1.location.value;
			if(ttran != ''){ tran = ttran;}
		}
		else{
			var location = document.form1.location.value;
			
		}
		var refno = document.form1.nexttranno.value;
		var opt = 'fullscreen=yes, scrollbars=yes, status=no';
		//window.showModalDialog('dsp_gradeitem.cfm?itemno=' + escape(itemno), '',opt);
		window.open('dsp_gradeitem.cfm?itemno=' + escape(itemno) + '&location=' + location + '&type=' + tran + '&refno=' + refno + '&trancode=' + trancode, '',opt);

	}
	
	function selectBatch(tran){
		var itemno = document.form1.items.value;
		var location = document.form1.location.value;
		//var tran = document.form1.tran.value;
		var refno = document.form1.nexttranno.value;
		var trancode = document.form1.itemcount.value;
		var price_bil = document.form1.price.value;
		var qty_bil = document.form1.qty.value;
		if(tran=='TR'){
			var ttran = document.form1.ttran.value;
			var trfrom = document.getElementById("trfrom2").value;
			var trto = document.getElementById("trto2").value;
			if(ttran == ''){
				var ttran = 'TROU';
			}
			var opt = 'Width=800px, Height=620px, scrollbars=auto, status=no';
			window.open('dsp_batch.cfm?itemno='+escape(itemno)+'&location='+location+'&type='+tran+'&refno='+refno+'&trancode='+trancode+'&price='+price_bil+'&qty='+qty_bil+'&ttran='+ttran+'&trfrom='+trfrom+'&trto='+trto, '',opt);
		}
		else{
			var opt = 'Width=800px, Height=620px, scrollbars=auto, status=no';
			window.open('dsp_batch.cfm?itemno='+escape(itemno)+'&location='+location+'&type='+tran+'&refno='+refno+'&trancode='+trancode+'&price='+price_bil+'&qty='+qty_bil, '',opt);
		}
	}
	
	function changeComment(){
		var commentcode = document.form1.comment_selection.options[document.form1.comment_selection.selectedIndex].value;
		DWREngine._execute(_tranflocation, null, 'getComment', escape(commentcode), showCommentDesp);
	}
	
	function showCommentDesp(commentObject){
		if(document.getElementById("cComment").checked && document.getElementById("comment").value !=''){
		 	DWRUtil.setValue("comment", document.getElementById("comment").value+" \n"+commentObject.COMMENTDETAILS);
		}
		else DWRUtil.setValue("comment", commentObject.COMMENTDETAILS);		
	}
</script>
</head>
<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">

<cfif isdefined("form.searchbatch") and form.searchbatch eq "Search #gettranname.lbatch# Item">
	<form name="done" action="selectbatch1.cfm">
		<cfoutput>
		<input type="hidden" name="bmode" value="search">
		<input type="hidden" name="mode" value="#mode#">
		<input type="hidden" name="nDateCreate" value="#nDateCreate#">
		<input type="hidden" name="items" value="#convertquote(items)#">
		<input type="hidden" name="tran" value="#listfirst(tran)#">
        <input type="hidden" name="consignment" value="#consignment#">
		<input type="hidden" name="type1" value="#type1#">
		<input type="hidden" name="nexttranno" value="#nexttranno#">
		<input type="hidden" name="itemcount" value="#itemcount#">
		<input type="hidden" name="agenno" value="#agenno#">
		<input type="hidden" name="oldenterbatch" value="#enterbatch#">
		<cfif isdefined("enterbatch1")>
			<input type="hidden" name="enterbatch1" value="#enterbatch1#">
		</cfif>
		<cfif listfirst(tran) eq "TR" or listfirst(tran) eq "TROU" or listfirst(tran) eq "TRIN">
			<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
			<input type="hidden" name="trto" value="#listfirst(trto)#">
			<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
			<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
			<input type="hidden" name="ttran" value="#listfirst(ttran)#">
		<cfelse>
			<input type="hidden" name="location" value="#location#">
			<input type="hidden" name="oldlocation" value="#oldlocation#">
		</cfif>
		<input type="hidden" name="mc1bil" value="#mc1bil#">
		<input type="hidden" name="mc2bil" value="#mc2bil#">
		<input type="hidden" name="sodate" value="#sodate#">
		<input type="hidden" name="dodate" value="#dodate#">
        <input type="hidden" name="milcert" value="#milcert#">
		<input type="hidden" name="expdate" value="#expdate#">
        <input type="hidden" name="manudate" value="#manudate#">
		<input type="hidden" name="batchqty" value="#batchqty#">
		<input type="hidden" name="defective" value="#defective#">
		<!--- Add on 260808 --->
		<input type="hidden" name="hmode" value="#listfirst(hmode)#">
		
		<!--- ADD ON 26-03-2009 --->
		<input type="hidden" name="grdcolumnlist" value="#form.grdcolumnlist#">
        <input type="hidden" name="grdvaluelist" value="#form.grdvaluelist#">
		<input type="hidden" name="totalrecord" value="#form.totalrecord#">
		<input type="hidden" name="bgrdcolumnlist" value="#form.bgrdcolumnlist#">
		<input type="hidden" name="oldgrdvaluelist" value="#form.oldgrdvaluelist#">
		</cfoutput>
	</form>
	<script language="javascript" type="text/javascript">
		done.submit();
	</script>
</cfif>

<cfif listfirst(tran) eq "ISS">
	<cfset tran = "ISS">
	<cfset tranname = gettranname.lISS>
	<cfset trancode = "issno">
<cfelseif listfirst(tran) eq "TROU" or listfirst(tran) eq "TR">
	<cfset tran = "TR">
	<cfset ttran = "TROU">
    <cfif isdefined('consignment')>
    <cfif consignment eq "out">
    <cfset tranname = "#gettranname.lconsignout#">
    <cfelse>
    <cfset tranname = "#gettranname.lconsignin#">
    </cfif>
    <Cfelse>
	<cfset tranname = "Transfer">
    </cfif>
	<cfset trancode = "trno">
<cfelseif listfirst(tran) eq "TRIN" or listfirst(tran) eq "TR">
	<cfset tran = "TR">
	<cfset ttran = "TRIN">
    <cfif isdefined('consignment')>
    <cfif consignment eq "out">
    <cfset tranname = "#gettranname.lconsignout#">
    <cfelse>
    <cfset tranname = "#gettranname.lconsignin#">
    </cfif>
    <Cfelse>
	<cfset tranname = "Transfer">
    </cfif>
	<cfset trancode = "trno">
<cfelseif listfirst(tran) eq "OAI">
	<cfset tran = "OAI">
	<cfset tranname = gettranname.lOAI>
	<cfset trancode = "oaino">
<cfelseif listfirst(tran) eq "OAR">
	<cfset tran = "OAR">
	<cfset tranname = gettranname.lOAR>
	<cfset trancode = "oarno">
</cfif>

<cfparam name="pricehis1" default="">
<cfparam name="pricehis2" default="">
<cfparam name="pricehis3" default="">
<cfparam name="disc1" default="">
<cfparam name="disc2" default="">
<cfparam name="disc3" default="">
<cfparam name="date1" default="">
<cfparam name="date2" default="">
<cfparam name="date3" default="">
<cfparam name="itembal" default="0">
<cfparam name="RCqty" default="0">
<cfparam name="RCSqty" default="0">
<cfparam name="PRqty" default="0">
<cfparam name="DOqty" default="0">
<cfparam name="invqty" default="0">
<cfparam name="CNqty" default="0">
<cfparam name="DNqty" default="0"> 
<cfparam name="CSqty" default="0"> 
<cfparam name="ISSqty" default="0"> 
<cfparam name="trinqty" default="0"> 
<cfparam name="troutqty" default="0">
<cfparam name="oaiqty" default="0">
<cfparam name="oarqty" default="0">
<cfparam name="balonhand" default="0">
<cfparam name="balonhand2" default="0">

<cfquery datasource="#dts#" name="getlocation">
	select location,desp from iclocation
</cfquery>
			
<!--- ADD ON 10-12-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
	Select * from GSetup
</cfquery>

<cfif url.type1 eq "Delete">
	<cfif tran eq 'TR'>
		<!--- <cfquery datasource='#dts#' name="getitem">
			select * from ictran where itemno= '#url.itemno#' and refno = '#nexttranno#' and (type = 'TRIN' or type = 'TROU') and itemcount = '#itemcount#'
		</cfquery> --->
		<cfif checkcustom.customcompany eq "Y">
			<cfquery datasource='#dts#' name="getitem">
				select * from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and refno = '#nexttranno#' 
				and type = 'TROU' and itemcount = '#itemcount#'
			</cfquery>
		
			<cfquery datasource='#dts#' name="getbatchcode2">
				select batchcode,brem5,brem7 from ictran where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and refno = '#nexttranno#' 
				and type = 'TRIN' and itemcount = '#itemcount#'
			</cfquery>
		<cfelse>
			<cfquery datasource='#dts#' name="getitem">
				select * from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and refno = '#nexttranno#' and (type = 'TRIN' or type = 'TROU') and itemcount = '#itemcount#'
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery datasource='#dts#' name="getitem">
			select * from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and refno = '#nexttranno#' and type = '#tran#' and itemcount = '#itemcount#'
		</cfquery>
	</cfif>
		
	<cfquery datasource='#dts#' name="getpricehis">
		select price,wos_date,dispec1 from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> order by wos_date desc limit 3
	</cfquery>	
	
	<cfquery name="getitembal" datasource="#dts#">
		select qtybf,graded from icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
	</cfquery>
	
	<!--- Add on 030908 for Graded Item --->
	<cfset graded = getitembal.graded>	
	<cfset itemno = url.itemno>
	<cfset desp=getitem.desp>
	<cfset despa=getitem.despa>
	<cfset xlocation=getitem.location>
	<cfset qty=getitem.qty>
	<cfset price=getitem.price>
	<cfset amt=getitem.amt1_bil>
	<cfset dono=getitem.dono>
	<cfset gst_item=getitem.gst_item>
	<cfset dispec1=getitem.dispec1>
	<cfset dispec2=getitem.dispec2>
	<cfset dispec3=getitem.dispec3>
	<cfset taxpec1=getitem.taxpec1>
	<cfset oldbill=getitem.oldbill>
	<cfset wos_grouop=getitem.wos_group>
	<cfset category=getitem.category>
	<cfset area=getitem.area>
	<cfset shelf=getitem.shelf>
	<!--- ADD ON 12-10-2009 --->
	<cfset xcomment=tostring(getitem.comment)>
	<cfset brem1=getitem.brem1>
	<cfset brem2=getitem.brem2>
	<cfset brem3=getitem.brem3>
	<cfset brem4=getitem.brem4>
	<!--- ADD ON 10-12-2009 --->
	<cfset xsource=getitem.source>
	<cfset xjob=getitem.job>
	<cfset mode="Delete">
	<cfset button="Delete">
</cfif>

<cfif url.type1 eq "Edit">
	<cfif tran eq 'TR'>		
		<!--- <cfquery datasource='#dts#' name="getitem">
			select * from ictran where itemno= '#url.itemno#' and refno = '#nexttranno#' 
			and type = <cfif ttran eq 'TROU'>'TROU'<cfelse>'TRIN'</cfif> and itemcount = '#itemcount#'
		</cfquery> --->
		
		<cfif checkcustom.customcompany eq "Y">
			<cfquery datasource='#dts#' name="getitem">
				select * from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and refno = '#nexttranno#' 
				and type = 'TROU' and itemcount = '#itemcount#'
			</cfquery>
		
			<cfquery datasource='#dts#' name="getbatchcode2">
				select batchcode,brem5,brem7 from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and refno = '#nexttranno#' 
				and type = 'TRIN' and itemcount = '#itemcount#'
			</cfquery>
		<cfelse>
			<cfquery datasource='#dts#' name="getitem">
				select * from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and refno = '#nexttranno#' 
				and type = <cfif ttran eq 'TROU'>'TROU'<cfelse>'TRIN'</cfif> and itemcount = '#itemcount#'
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery datasource='#dts#' name="getitem">
			select * from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> and refno = '#nexttranno#' and type = '#tran#'and itemcount = '#itemcount#'
		</cfquery>		
	</cfif>
		
	<cfquery datasource='#dts#' name="getpricehis">
		select price,wos_date,dispec1 from ictran where itemno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#"> order by wos_date desc limit 3
	</cfquery>
		
	<cfquery name="getitembal" datasource="#dts#">
		select qtybf,graded from icitem where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.itemno)#">
	</cfquery>
		
	<cfset itemno = '#url.itemno#'>
	<cfset desp=getitem.desp>
	<cfset despa=getitem.despa>
	<!--- Add on 030908 for Graded Item --->
	<cfset graded = getitembal.graded>
	
	<cfif isdefined("form.location")>
		<cfset xlocation=form.location>
	<cfelse>
		<cfset xlocation=getitem.location>
	</cfif>
		
	<cfset qty=getitem.qty>
	<cfset price=getitem.price>
	<cfset amt=getitem.amt1_bil>
	<cfset dono=getitem.dono>
	<cfset gst_item=getitem.gst_item>
	<cfset dispec1=getitem.dispec1>
	<cfset dispec2=getitem.dispec2>
	<cfset dispec3=getitem.dispec3>
	<cfset taxpec1=getitem.taxpec1>
	<cfset wos_grouop=getitem.wos_group>
	<cfset category=getitem.category>
	<!--- ADD ON 12-10-2009 --->
	<cfset xcomment=tostring(getitem.comment)>
	<cfset brem1=getitem.brem1>
	<cfset brem2=getitem.brem2>
	<cfset brem3=getitem.brem3>
	<cfset brem4=getitem.brem4>
	<!--- ADD ON 10-12-2009 --->
	<cfset xsource=getitem.source>
	<cfset xjob=getitem.job>
	<cfset mode="Edit">
	<cfset button="Edit">
</cfif>

<cfif url.type1 eq "Add">
	<cfquery datasource="#dts#" name="getproductdetails">
		Select * from icitem where itemno = '#itemno#'
	</cfquery>
		
	<cfquery datasource='#dts#' name="getpricehis">
		select price,wos_date,dispec1 from ictran where itemno= '#itemno#' order by wos_date desc limit 3
	</cfquery>
		
	<cfquery name="getitembal" datasource="#dts#">
		select qtybf,price,graded,ucost,comment from icitem where itemno = '#itemno#'
	</cfquery>
	
	<cfset itemno = itemno>
	<cfset desp="">
	<cfset despa="">
	<!--- Add on 030908 for Graded Item --->
	<cfset graded = getitembal.graded>
		
	<cfif tran eq 'TR'>
		<cfquery datasource='#dts#' name="getartran">
			select rem1 from artran where refno = '#nexttranno#' and type = '#tran#'
		</cfquery>
		
		<cfif getartran.recordcount gt 0>
			<cfset xlocation=getartran.rem1>
		<cfelse>
			<cfset xlocation="">
		</cfif>
	<cfelse>
		<cfif isdefined("form.location")>
			<cfset xlocation=form.location>
		<cfelse>
			<cfif HcomID eq "pnp_i">
				<cfinclude template="../../pnp/get_userid_location.cfm">
				<cfset xlocation = get_user_id_location.location>
			<cfelse>
            <cfif getGeneralInfo.followlocation eq 'Y'>
            <cfquery name="get1stitemlocation" datasource="#dts#">
            select location from ictran where refno='#nexttranno#' and type='#tran#' and itemcount='1'
            </cfquery>
            <cfset xlocation = get1stitemlocation.location>
            <cfelse>
				<cfset xlocation = "">
            </cfif>
			</cfif>
		</cfif>
	</cfif>
	
	<cfset qty="0">
	<cfif HcomID eq "migif_i">
		<cfset price=getitembal.price>
	<cfelse>
		<cfif tran eq "OAI" or tran eq "ISS">
			<cfset price=getitembal.ucost>
        <cfelseif tran eq "OAR">
			<!---<cfset price="0">    --->
            <cfset price=getitembal.ucost>
		<cfelse>
			<cfset price=getitembal.price>
		</cfif>
        
        <cfif tran eq  "TR">
        <cfif getGeneralInfo.df_trprice eq 'price'>
        <cfset price=getitembal.price>
        <cfelse>
        <cfset price=getitembal.ucost>
        </cfif>
        </cfif>
        
	</cfif>
	
	<!--- <cfset price=getitembal.price> --->
	<cfset amt="0">
	<cfset dono="">
	<cfset gst_item="">
	<cfset totalup="">
	<cfset dispec1="0">
	<cfset dispec2="0">
	<cfset dispec3="0">
	<cfset taxpec1="0">
	<cfset wos_grouop="">
	<cfset category="">
	<cfset area="">
	<cfset shelf="">
	<!--- ADD ON 12-10-2009 --->
	<cfset xcomment=tostring(getitembal.comment)>
	<cfset brem1="">
	<cfset brem2="">
	<cfset brem3="">
	<cfset brem4="">
	<!--- ADD ON 10-12-2009 --->
	<cfset xsource="">
	<cfset xjob="">
	<cfset mode="Add">
	<cfset button="Add">	
</cfif>
	
<cfif getpricehis.recordcount gt 0>
	<cfloop query="getpricehis" startrow="1" endrow="1">
		<cfset pricehis1 = numberformat(price,"____.__")>
		<cfset date1 = dateformat(wos_date,"dd/mm/yyyy")>
		<cfset disc1 = dispec1>
	</cfloop>
		
	<cfloop query="getpricehis" startrow="2" endrow="2">
		<cfset pricehis2 = numberformat(price,"____.__")>
		<cfset date2 = dateformat(wos_date,"dd/mm/yyyy")>
		<cfset disc2 = dispec1>
	</cfloop>
		
	<cfloop query="getpricehis" startrow="3" endrow="3">
		<cfset pricehis3 = numberformat(price,"____.__")>
		<cfset date3 = dateformat(wos_date,"dd/mm/yyyy")>
		<cfset disc3 = dispec1>
	</cfloop>		
</cfif>
	
<cfif getitembal.qtybf neq "">
	<cfset itembal = getitembal.qtybf>	
</cfif> 
	
<cfquery name="getrc" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type ="RC" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null) 
</cfquery>
	
<cfif getrc.recordcount gt 0>
	<cfif getrc.sumqty neq "">
		<cfset RCqty = #getrc.sumqty#>
	</cfif>
</cfif>
	
<cfquery name="getrcs" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type ="RCS" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>
	
<cfif getrcs.recordcount gt 0>
	<cfif getrcs.sumqty neq "">
		<cfset RCSqty = getrcs.sumqty>
	</cfif>
</cfif>
	
<cfquery name="getpr" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "PR" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>
	
<cfif getpr.recordcount gt 0>
	<cfif getpr.sumqty neq "">
		<cfset PRqty = #getpr.sumqty#>
	</cfif>
</cfif>
	
<cfquery name="getdo" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "DO" and toinv = "" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>
	
<cfif getdo.recordcount gt 0>
	<cfif getdo.sumqty neq "">
		<cfset DOqty = getdo.sumqty>
	</cfif>
</cfif>

<cfquery name="getinv" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "INV" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>

<cfif getinv.recordcount gt 0>
	<cfif getinv.sumqty neq "">
		<cfset INVqty = getinv.sumqty>
	</cfif>		
</cfif>
	
<cfquery name="getcn" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "CN" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>
	
<cfif getcn.recordcount gt 0>
	<cfif getcn.sumqty neq "">
		<cfset CNqty = getcn.sumqty>
	</cfif>
</cfif>
	
<cfquery name="getdn" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "DN" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>

<cfif getdn.recordcount gt 0>
	<cfif getdn.sumqty neq "">
		<cfset DNqty = getdn.sumqty>
	</cfif>		
</cfif>
	
<cfquery name="getcs" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "CS" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>
	
<cfif getcs.recordcount gt 0>
	<cfif getcs.sumqty neq "">
		<cfset CSqty = getcs.sumqty>
	</cfif>		
</cfif>
	
<cfquery name="getiss" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "ISS" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>
	
<cfif getiss.recordcount gt 0>
	<cfif getiss.sumqty neq "">
		<cfset ISSqty = getiss.sumqty>
	</cfif>		
</cfif>
	
<cfquery name="gettrin" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "TRIN" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>

<cfif gettrin.recordcount gt 0>
	<cfif gettrin.sumqty neq "">
		<cfset trinqty = gettrin.sumqty>
	</cfif>		
</cfif>
	
<cfquery name="gettrout" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "TROU" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>

<cfif gettrout.recordcount gt 0>
	<cfif gettrout.sumqty neq "">
		<cfset troutqty = gettrout.sumqty>
	</cfif>		
</cfif>
	
<cfquery name="getoai" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "OAI" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>

<cfif getoai.recordcount gt 0>
	<cfif getoai.sumqty neq "">
		<cfset oaiqty = getoai.sumqty>
	</cfif>		
</cfif>

<cfquery name="getoar" datasource="#dts#">
	select sum(qty)as sumqty from ictran where type = "OAR" and itemno = '#itemno#' and fperiod <> '99' and (void='' or void is null)
</cfquery>
	
<cfif getoar.recordcount gt 0>
	<cfif getoar.sumqty neq "">
		<cfset oarqty = getoar.sumqty>
	</cfif>		
</cfif>
	
<cfset balonhand = itembal + rcqty + rcsqty - prqty - doqty - invqty + cnqty - dnqty - csqty - issqty + trinqty - troutqty + oaiqty - oarqty>  

<cfif listfirst(tran) eq "TR" or listfirst(tran) eq "TROU" or listfirst(tran) eq "TRIN">
                <cfquery name="getItemBal" datasource="#dts#">
                select 
			a.itemno,
			aa.desp,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
			from locqdbf as a 
			
			right join 
			(
				select 
				itemno,
				desp 
				from icitem 
				where itemno<>'' 
				and itemno = '#itemno#'
				order by itemno
			) as aa on a.itemno=aa.itemno 
			
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as getlastin 
				from ictran
				where type in ('RC','CN','OAI','TRIN') 
				and fperiod < '' 
				and fperiod<>'99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				group by location,itemno
				order by location,itemno
			) as b on a.itemno=b.itemno and a.location=b.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as getlastout 
				from ictran
				where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO')
				and fperiod < '' 
				and fperiod<>'99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				and location='#listfirst(trfrom)#'
				 
				
				group by location,itemno
				order by location,itemno
			) as c on a.itemno=c.itemno and a.location=c.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as qin 
				from ictran 
				where type in ('RC','CN','OAI','TRIN')
				and fperiod<>'99' 
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				
				group by location,itemno
				order by location,itemno
			) as d on a.itemno=d.itemno and a.location=d.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as qout 
				from ictran 
				where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (toinv='' or toinv is null) 
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				
				group by location,itemno
				order by location,itemno
			) as e on a.itemno=e.itemno and a.location=e.location
			
			where a.location<>''
			and a.location='#listfirst(trfrom)#'
			order by a.location



                </cfquery>
                <cfset balonhand = val(getItemBal.balance) >
</cfif>

<cfif balonhand lte 0 and url.type1 eq "Add" and getGeneralInfo.negstk eq "0" and listfirst(tran) neq "OAI">
<cfif lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
<cfelse>
		<h3>
		<font color="FF0000">Negative or Zero Stock, The quantity on hand is <cfoutput>#balonhand#</cfoutput>.</font>
		<br><br>
		<font color="FF0000">Please click Back to continue.</font>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="back" id="back1" value="Back" onClick="javascript:history.back()">
		</h3>
		<cfabort>
</cfif>
	</cfif>

<body>
<cfoutput>
	<h4>
		<a href="iss2.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> || 
		<a href="iss.cfm?tran=#tran#">List all #tranname#</a> || 
		<a href="siss.cfm?tran=#tran#">Search For #tranname#</a>
	</h4>
	
	<cfform name="form1" method="post" action="issprocess.cfm?nDateCreate=#nDateCreate#" onsubmit="JavaScript:return data_validation();">
		<input type="hidden" name="tran" value="#tran#">
        <input type="hidden" name="consignment" value="#consignment#">
		<input name="type" value="Inprogress" type="hidden">
		<!--- Add on 260808 --->
		<input type="hidden" name="hmode" value="#listfirst(hmode)#">
		<cfif tran eq 'TR'>
			<input type="hidden" name="trfrom" id="trfrom2" value="#listfirst(trfrom)#">
			<input type="hidden" name="trto" id="trto2" value="#listfirst(trto)#">
		</cfif>
		<cfif mode eq "Add">
			<input type="hidden" name="mode" value="ADD">
			<input type="hidden" name="nexttranno" value="#nexttranno#">
		
			<cfquery datasource='#dts#' name="getartran">
				select * from artran where refno= '#nexttranno#' and type = '#tran#'
			</cfquery>
			
			<!--- ADD ON 10-12-2009 --->
			<cfif getGsetup.projectbybill eq "1">
				<cfset xsource=getartran.source>
				<cfset xjob=getartran.job>
            <cfelseif getGsetup.jobbyitem eq "Y">
            <cfset xsource=getartran.source>
			</cfif>
		
			<input type="hidden" name="custno" value="#getartran.custno#">
			<!--- <input type="hidden" name="agenno" value="#getartran.agenno#"> --->
			<input type="hidden" name="name" value="#getartran.name#">
			<input type="hidden" name="readperiod" value="#getartran.fperiod#">
			<input type="hidden" name="nDateCreate" value="#getartran.wos_date#">
			<input type="hidden" name="invoicedate" value="#getartran.wos_date#"> 
			<cfif checkcustom.customcompany eq "Y">
				<cfif tran eq "TR">
					<input type="hidden" name="hremark5" value="#listfirst(remark5)#">	<!--- FOR TRIN, PERMIT NUMBER, ADD ON 31-03-2009 --->
					<input type="hidden" name="hremark6" value="#listfirst(remark6)#">
					<input type="hidden" name="bremark5" value="">	<!--- FOR TROU, PERMIT NUMBER, ADD ON 31-03-2009 --->
					<input type="hidden" name="bremark6" value="">	<!--- INTERNAL / EXTERNAL TRANSFER, I: INTERNAL, E:EXTERNAL(BY DEFAULT) --->
					<input type="hidden" name="bremark7" value="">
					<input type="hidden" name="bremark8" value="">
					<input type="hidden" name="bremark9" value="">
					<input type="hidden" name="bremark10" value="">
				<cfelse>
					<cfif tran eq "OAI">
						<input type="hidden" name="hremark5" value="#listfirst(remark5)#">	<!--- PERMIT NUMBER, ADD ON 31-03-2009 --->	
						<input type="hidden" name="hremark6" value="#listfirst(remark6)#">
					<cfelse>
						<input type="hidden" name="hremark5" value="">
						<input type="hidden" name="hremark6" value="">
					</cfif>
					<input type="hidden" name="bremark6" value="">
					<input type="hidden" name="bremark8" value="">
					<input type="hidden" name="bremark9" value="">
					<input type="hidden" name="bremark10" value="">
				</cfif>
			</cfif>
    	<cfelseif mode eq "Edit">
			<input type ="hidden" name="mode" value="Edit">
			<input type="hidden" name="nexttranno" value="#nexttranno#">
			<input type="hidden" name="itemcount" value="#itemcount#">
		
			<cfquery datasource='#dts#' name="getartran">
				select * from artran where refno= '#nexttranno#' and type = '#tran#'
			</cfquery>
		
			<input type="hidden" name="agenno" value="#getartran.agenno#">
			<input type="hidden" name="custno" value="#getartran.custno#">
			<input type="hidden" name="name" value="#getartran.name#">
			<input type="hidden" name="readperiod" value="#getartran.fperiod#">
			<input type="hidden" name="nDateCreate" value="#getartran.wos_date#">
			<input type="hidden" name="invoicedate" value="#getartran.wos_date#"> 
			<cfif checkcustom.customcompany eq "Y">
				<cfif tran eq "TR">
					<input type="hidden" name="hremark5" value="#getartran.rem5#">	<!--- FOR TRIN, PERMIT NUMBER, ADD ON 31-03-2009 --->
					<input type="hidden" name="hremark6" value="#getartran.rem6#">
					<input type="hidden" name="bremark5" value="#getitem.brem5#">	<!--- FOR TROU, PERMIT NUMBER, ADD ON 31-03-2009 --->
					<input type="hidden" name="bremark6" value="#getitem.brem6#">	<!--- INTERNAL / EXTERNAL TRANSFER, I: INTERNAL, E:EXTERNAL(BY DEFAULT) --->
					<input type="hidden" name="bremark7" value="#getitem.brem7#">
					<input type="hidden" name="bremark8" value="#getitem.brem8#">
					<input type="hidden" name="bremark9" value="#getitem.brem9#">
					<input type="hidden" name="bremark10" value="#getitem.brem10#">
				<cfelse>
					<cfif tran eq "OAI">
						<input type="hidden" name="hremark5" value="#getartran.rem5#">	<!--- PERMIT NUMBER, ADD ON 31-03-2009 --->	
						<input type="hidden" name="hremark6" value="#getartran.rem6#">
						<input type="hidden" name="bremark8" value="">
						<input type="hidden" name="bremark9" value="">
						<input type="hidden" name="bremark10" value="">
					<cfelse>
						<input type="hidden" name="hremark5" value="#getitem.brem5#">
						<input type="hidden" name="hremark6" value="#getitem.brem7#">
						<input type="hidden" name="bremark8" value="#getitem.brem8#">
						<input type="hidden" name="bremark9" value="#getitem.brem9#">
						<input type="hidden" name="bremark10" value="#getitem.brem10#">
					</cfif>
					<input type="hidden" name="bremark6" value="">
				</cfif>
			</cfif>
    	<cfelse>
			<input type="hidden" name="mode" value="Delete">
			<input type="hidden" name="nexttranno" value="#nexttranno#">
			<input type="hidden" name="itemcount" value="#itemcount#">
			<cfquery datasource='#dts#' name="getartran">
				select * from artran where refno= '#nexttranno#' and type = '#tran#'
			</cfquery>
			<input type="hidden" name="agenno" value="#getartran.agenno#">
			<input type="hidden" name="custno" value="#getartran.custno#">
			<input type="hidden" name="name" value="#getartran.name#">
			<input type="hidden" name="readperiod" value="#getartran.fperiod#">
			<input type="hidden" name="nDateCreate" value="#getartran.wos_date#">
			<input type="hidden" name="invoicedate" value="#getartran.wos_date#"> 
			<cfif checkcustom.customcompany eq "Y">
				<cfif tran eq "TR">
					<input type="hidden" name="hremark5" value="#getartran.rem5#">	<!--- FOR TRIN, PERMIT NUMBER, ADD ON 31-03-2009 --->
					<input type="hidden" name="hremark6" value="#getartran.rem6#">
					<input type="hidden" name="bremark5" value="#getitem.brem5#">	<!--- FOR TROU, PERMIT NUMBER, ADD ON 31-03-2009 --->
					<input type="hidden" name="bremark6" value="#getitem.brem6#">	<!--- INTERNAL / EXTERNAL TRANSFER, I: INTERNAL, E:EXTERNAL(BY DEFAULT) --->
					<input type="hidden" name="bremark7" value="#getitem.brem7#">
				<cfelse>
					<cfif tran eq "OAI">
						<input type="hidden" name="hremark5" value="#getartran.rem5#">	<!--- PERMIT NUMBER, ADD ON 31-03-2009 --->	
						<input type="hidden" name="hremark6" value="#getartran.rem6#">
						<input type="hidden" name="bremark8" value="">
						<input type="hidden" name="bremark9" value="">
						<input type="hidden" name="bremark10" value="">
					<cfelse>
						<input type="hidden" name="hremark5" value="#getitem.brem5#">
						<input type="hidden" name="hremark6" value="#getitem.brem7#">
						<input type="hidden" name="bremark8" value="#getitem.brem8#">
						<input type="hidden" name="bremark9" value="#getitem.brem9#">
						<input type="hidden" name="bremark10" value="#getitem.brem10#">
					</cfif>
					<input type="hidden" name="bremark6" value="">
				</cfif>
			</cfif>
		</cfif>
		
		#tranname#
  <table align="center" class="data">
			<tr> 
      			<th colspan="6"> Body</th>
   		  </tr>
    		<tr> 
      			<th width="73" height="37">Item Code</th>
      			<td colspan="3">
					<cfif mode eq "Delete" or mode eq "Edit">
						#url.itemno# 
				    <cfset checkitemno = url.itemno >
          				<input type="hidden" name="itemno" value='#convertquote(url.itemno)#'>
          			<cfelse>
          				#itemno# 
                    <cfset checkitemno = itemno >
          				<input type="hidden" name="itemno" value='#convertquote(itemno)#'>
        			</cfif>
				</td>
                <cfif listfirst(tran) eq "TR" or listfirst(tran) eq "TROU" or listfirst(tran) eq "TRIN">
                <cfquery name="getItemBal" datasource="#dts#">
                select 
			a.itemno,
			aa.desp,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
			from locqdbf as a 
			
			right join 
			(
				select 
				itemno,
				desp 
				from icitem 
				where itemno<>'' 
				and itemno = '#checkitemno#'
				order by itemno
			) as aa on a.itemno=aa.itemno 
			
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as getlastin 
				from ictran
				where type in ('RC','CN','OAI','TRIN') 
				and fperiod < '' 
				and fperiod<>'99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				group by location,itemno
				order by location,itemno
			) as b on a.itemno=b.itemno and a.location=b.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as getlastout 
				from ictran
				where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO')
				and fperiod < '' 
				and fperiod<>'99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				and location='#listfirst(trfrom)#'
				 
				
				group by location,itemno
				order by location,itemno
			) as c on a.itemno=c.itemno and a.location=c.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as qin 
				from ictran 
				where type in ('RC','CN','OAI','TRIN')
				and fperiod<>'99' 
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				
				group by location,itemno
				order by location,itemno
			) as d on a.itemno=d.itemno and a.location=d.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as qout 
				from ictran 
				where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (toinv='' or toinv is null) 
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				
				group by location,itemno
				order by location,itemno
			) as e on a.itemno=e.itemno and a.location=e.location
			
			where a.location<>''
			and a.location='#listfirst(trfrom)#'
			order by a.location



                </cfquery>
                <cfset balonhand = val(getItemBal.balance) >
                <!---- ---->
                <cfquery name="getItemBal2" datasource="#dts#">
                select 
			a.itemno,
			aa.desp,
			ifnull(d.qin,0) as qin,
			ifnull(e.qout,0) as qout,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)) as qtybf,
			(ifnull(a.locqfield,0)+ifnull(b.getlastin,0)-ifnull(c.getlastout,0)+ifnull(d.qin,0)-ifnull(e.qout,0)) as balance
			from locqdbf as a 
			
			right join 
			(
				select 
				itemno,
				desp 
				from icitem 
				where itemno<>'' 
				and itemno = '#checkitemno#'
				order by itemno
			) as aa on a.itemno=aa.itemno 
			
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as getlastin 
				from ictran
				where type in ('RC','CN','OAI','TRIN') 
				and fperiod < '' 
				and fperiod<>'99'
				and (void = '' or void is null) 
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				group by location,itemno
				order by location,itemno
			) as b on a.itemno=b.itemno and a.location=b.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as getlastout 
				from ictran
				where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO')
				and fperiod < '' 
				and fperiod<>'99'
				and (toinv='' or toinv is null)
				and (void = '' or void is null)
				and (linecode <> 'SV' or linecode is null) 
				and location='#listfirst(trfrom)#'
				 
				
				group by location,itemno
				order by location,itemno
			) as c on a.itemno=c.itemno and a.location=c.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as qin 
				from ictran 
				where type in ('RC','CN','OAI','TRIN')
				and fperiod<>'99' 
				and (void = '' or void is null)  
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				
				group by location,itemno
				order by location,itemno
			) as d on a.itemno=d.itemno and a.location=d.location
		
			left join
			(
				select 
				location,
				itemno,
				sum(qty) as qout 
				from ictran 
				where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
				and fperiod<>'99' 
				and (void = '' or void is null)
				and (toinv='' or toinv is null) 
				and (linecode <> 'SV' or linecode is null)
				and location='#listfirst(trfrom)#'
				
				 
				
				group by location,itemno
				order by location,itemno
			) as e on a.itemno=e.itemno and a.location=e.location
			
			where a.location<>''
			and a.location='#listfirst(trto)#'
			order by a.location



                </cfquery>
                <cfset balonhand2 = val(getItemBal2.balance) >
                
                <!---- ---->
                </cfif>
                <cfif lcase(hcomid) neq "meisei_i">
      			<th width="129">Balance on Hand</th>
      			<td width="60"><input name="balance" id="balance" type="text" size="6" maxlength="10" value="#balonhand#" readonly></td>
                </cfif>
    		</tr>
    		<tr> 
      			<th rowspan="2">Description</th>
      			<td colspan="3"nowrap>
					<cfif mode eq "Delete" or mode eq "Edit">
						<input name="desp" type="text" value='#convertquote(desp)#' size="40" maxlength="40">
					<cfelse>
						<input name="desp" type="text" value='#convertquote(getproductdetails.desp)#' size="40" maxlength="40">
					</cfif>
				</td>
			</tr>
   			<tr>
    			<td colspan="3" nowrap>
					<cfif mode eq "Delete" or mode eq "Edit">
         				<input name="despa" type="text" value="#despa#" size="40" maxlength="40">
         			<cfelse>
         				<input type="text" name="despa" value="#getproductdetails.despa#" size="40" maxlength="40">
       				</cfif>
				</td>
    		</tr>
    		<cfquery datasource='#dts#' name="getcomment">
				select * from comments order by code desc 
			</cfquery>
   			<tr>
    			<th rowspan="4">Comment</th>
      			<td colspan="3"><select name="comment_selection" onChange="changeComment();">
        				<option value="">Select a comment</option>
               			<cfloop query="getcomment">
	                		<option value="#getcomment.code#">#getcomment.desp#</option>
						</cfloop>
            		</select>
					<input type="checkbox" name="cComment">&nbsp;<font color="##FF0000">**</font>Add<br>
        		</td>
    		</tr>
   			<tr>
      			<td rowspan="3" colspan="3" nowrap>
					<textarea name="comment" cols="50" rows="4">#convertquote(xcomment)#</textarea>
				</td>
      			<th>Qty </th>
   				<td>
				<cfif isdefined("form.enterbatch")>
					<cfif tran neq "OAI" and tran neq "TR">
						<cfif form.enterbatch neq "">
							<cfquery name="checkbatchqty" datasource="#dts#">
								<cfif location neq "">
									select location,batchcode,rc_type,rc_refno,((bth_qob+bth_qin)-bth_qut) as batch_balance,expdate as exp_date from lobthob 
									where location='#location#' and batchcode='#form.enterbatch#' and ((bth_qob+bth_qin)-bth_qut) >0 order by itemno
								<cfelse>
									select batchcode,rc_type,rc_refno,((bth_qob+bth_qin)-bth_qut) as batch_balance,exp_date from obbatch 
									where batchcode='#form.enterbatch#' and ((bth_qob+bth_qin)-bth_qut) >0 order by itemno
								</cfif>
							</cfquery>

							<cfif form.batchqty gt checkbatchqty.batch_balance>
								<script>
									alert("Batch QTY Invalid");
									javascript:history.back();
								</script>
							</cfif>
						</cfif>
					</cfif>
					<!--- Batch Option --->
					<cfinput name="qty" type="text" id="qty" size="6" maxlength="10" value="#form.batchqty#" required="no" message="Please key in the quantity." validate="float">
				
					<cfif isdefined("url.type1") and type1 eq 'Add'>
						<input name='oldqty' id="oldqty" type='hidden' size='10' maxlength='10' value='0'>
						<input name='oldenterbatch' id='oldenterbatch' type='hidden' value=''>
					<cfelse>
						<input name='oldqty' id="oldqty" type='hidden' size='10' maxlength='10' value='#form.oldbatchqty#'>
						<cfif oldenterbatch eq "">
							<input name='oldenterbatch' id='oldenterbatch' type='hidden' value=''>
						<cfelse>
							<input name='oldenterbatch' id='oldenterbatch' type='hidden' value='#oldenterbatch#'>
						</cfif>
					</cfif>
			
					<input name='dodate' id='dodate' type='hidden' value='#form.dodate#'>
                    <input type="hidden" name="milcert" value="#form.milcert#">
					<input name='sodate' id='sodate' type='hidden' value='#form.sodate#'>
					<input name='adtcost1' id='adtcost1' type='hidden' value='#form.mc1bil#'>
					<input name='adtcost2' id='adtcost2' type='hidden' value='#form.mc2bil#'>
					<input name='enterbatch' id='enterbatch' type="hidden" value='#form.enterbatch#'>
					<input name='expdate' id='expdate' type='hidden' value='#form.expdate#'>
                    <input name='manudate' id='manudate' type='hidden' value='#form.manudate#'>
					<input name='mc1bil' id='mc1bil' type='hidden' value='#form.mc1bil#'>
					<input name='mc2bil' id='mc2bil' type='hidden' value='#form.mc2bil#'>
					<input name='defective' id='defective' type='hidden' value='#form.defective#'>
					<!---End Batch Option --->
					<input type="hidden" name="grdcolumnlist" value="#grdcolumnlist#">
			        <input type="hidden" name="grdvaluelist" value="#grdvaluelist#">
					<input type="hidden" name="totalrecord" value="#totalrecord#">
					<input type="hidden" name="bgrdcolumnlist" value="#bgrdcolumnlist#">
					<input type="hidden" name="oldgrdvaluelist" value="#oldgrdvaluelist#">
				<cfelseif isdefined("url.type1") and type1 eq 'Add'>
					<!--- Modified on 030908 for Graded Item --->
					<input type="hidden" name="grdcolumnlist" value="">
            		<input type="hidden" name="grdvaluelist" value="">
					<input type="hidden" name="totalrecord" value="0">
					<input type="hidden" name="bgrdcolumnlist" value="">
					<input type="hidden" name="oldgrdvaluelist" value="">
					<cfif graded neq "" and graded eq "Y">
						<cfinput name="qty" type="text" id="qty" size="6" maxlength="10" value="#qty#" required="yes" message="Please key in the quantity." validate="float" readonly>
						<cfif tran eq "TR">
							<input type="button" value="Grade" onClick="AssignGrade('#tran#','TROU');">
						<cfelse>
							<input type="button" value="Grade" onClick="AssignGrade('#tran#','');">
						</cfif>
						
					<cfelse>
						<cfinput name="qty" type="text" id="qty" size="6" maxlength="10" value="#qty#" required="yes" message="Please key in the quantity." validate="float" onchange="document.getElementById('amt').value=document.getElementById('price').value*document.getElementById('qty').value">
					</cfif>
					<!--- <cfinput name="qty" type="text" id="qty" size="6" maxlength="10" value="#qty#" required="yes" message="Please key in the quantity." validate="integer"> --->
					<input name='oldqty' id="oldqty" type='hidden' size='10' maxlength='10' value='0'>
					<input name='oldenterbatch' id='oldenterbatch' type='hidden' value=''>
					<input name='dodate' id='dodate' type='hidden' value=''>
                    <input type="hidden" name="milcert" id='milcert' value="">
					<input name='sodate' id='sodate' type='hidden' value=''>
					<input name='adtcost1' id='adtcost1' type='hidden' value=''>
					<input name='adtcost2' id='adtcost2' type='hidden' value=''>
					<input name='enterbatch' id='enterbatch' type="hidden" value=''>
					<input name='expdate' id='expdate' type='hidden' value=''>
                    <input name='manudate' id='manudate' type='hidden' value=''>
					<input name='mc1bil' id='mc1bil' type='hidden' value=''>
					<input name='mc2bil' id='mc2bil' type='hidden' value=''>
					<input name='defective' id='defective' type='hidden' value=''>
				<cfelse>
					<!--- Modified on 030908 for Graded Item --->
					<input type="hidden" name="grdcolumnlist" value="">
            		<input type="hidden" name="grdvaluelist" value="">
					<input type="hidden" name="totalrecord" value="0">
					<input type="hidden" name="bgrdcolumnlist" value="">
					<input type="hidden" name="oldgrdvaluelist" value="">
					<cfif graded neq "" and graded eq "Y">
						<cfinput name="qty" type="text" id="qty" size="6" maxlength="10" value="#qty#" required="yes" message="Please key in the quantity." validate="float" onchange="document.getElementById('amt').value=document.getElementById('price').value*document.getElementById('qty').value">
						<cfif tran eq "TR">
							<input type="button" value="Grade" onClick="AssignGrade('#tran#','#ttran#');">
						<cfelse>
							<input type="button" value="Grade" onClick="AssignGrade('#tran#','');">
						</cfif>
					<cfelse>
						<cfinput name="qty" type="text" id="qty" size="6" maxlength="10" value="#qty#" required="yes" message="Please key in the quantity." validate="float" onchange="document.getElementById('amt').value=document.getElementById('price').value*document.getElementById('qty').value">
					</cfif>
					<!--- <cfinput name="qty" type="text" id="qty" size="6" maxlength="10" value="#qty#" required="yes" message="Please key in the quantity." validate="integer"> --->
					<input name='oldqty' id="oldqty" type='hidden' size='10' maxlength='10' value='#qty#'>
					<input name='oldenterbatch' id='oldenterbatch' type='hidden' value='#getitem.batchcode#'>
                    <input type="hidden" name="milcert" id='milcert' value="'#getitem.milcert#">
					<input name='dodate' id='dodate' type='hidden' value='#getitem.dodate#'>
					<input name='sodate' id='sodate' type='hidden' value='#getitem.sodate#'>
					<input name='adtcost1' id='adtcost1' type='hidden' value='#getitem.mc1_bil#'>
					<input name='adtcost2' id='adtcost2' type='hidden' value='#getitem.mc2_bil#'>
					<input name='enterbatch' id='enterbatch' type="hidden" value='#getitem.batchcode#'>
					<input name='expdate' id='expdate' type='hidden' value='#dateformat(getitem.expdate,"yyyy-mm-dd")#'>
                    <input name='manudate' id='manudate' type='hidden' value='#dateformat(getitem.manudate,"yyyy-mm-dd")#'>
					<input name='mc1bil' id='mc1bil' type='hidden' value='#getitem.mc1_bil#'>
					<input name='mc2bil' id='mc2bil' type='hidden' value='#getitem.mc2_bil#'>
					<input name='defective' id='defective' type='hidden' value='#getitem.defective#'>
				</cfif>
			
				<cfif mode eq "Add">
					<cfif tran eq "TR">
						<input type="hidden" name="items" value="#convertquote(itemno)#">
						<input type="hidden" name="type1" value="#type1#">
						<input type="hidden" name="itemcount" value="0">
						<input type="hidden" name="agenno" value="#agenno#">
						<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
						<input type="hidden" name="trto" value="#listfirst(trto)#">
						<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
						<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
						<input type="hidden" name="ttran" value="">
						<!--- <input type="hidden" name="nDateCreate" value="#nDateCreate#"> --->
						<!--- MODIFIED ON 26-03-2009 --->
						<!--- <input type="submit" name="submit" value="Select Batch Code"> --->
						<cfif checkcustom.customcompany eq "Y">
							<input type="hidden" name="batchcode2" value="">
							<input type="button" name="submit" value="Lot Number" onClick="selectBatch('#tran#');">
						<cfelse>
							<input type="submit" name="submit" value="Select Batch Code">
						</cfif>
					<cfelse>
						<input type="hidden" name="items" value="#convertquote(itemno)#">
						<input type="hidden" name="type1" value="#type1#">
						<input type="hidden" name="itemcount" value="0">
						<input type="hidden" name="agenno" value="#getartran.agenno#">
						<!--- MODIFIED ON 26-03-2009 --->
						<cfif checkcustom.customcompany eq "Y">
							<input type="button" name="submit" value="Lot Number" onClick="selectBatch('#tran#');">
						<cfelse>
							<input type="submit" name="submit" value="Select Batch Code">
						</cfif>
						<!--- <input type="submit" name="submit" value="Select Batch Code"> --->
					</cfif>
				<cfelse>
					<cfif tran eq "TROU" or tran eq "TRIN" or tran eq "TR">
						<input type="hidden" name="items" value="#convertquote(itemno)#">
						<input type="hidden" name="tran" value="#tran#">
                        <input type="hidden" name="consignment" value="#consignment#">
						<input type="hidden" name="type1" value="#type1#">
						<input type="hidden" name="agenno" value="#getartran.agenno#">
						<input type="hidden" name="enterbatch1" value="#getitem.batchcode#">
						<input type="hidden" name="batchqty" value="#qty#">
						<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
						<input type="hidden" name="trto" value="#listfirst(trto)#">
						<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
						<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
						<!--- <input type="submit" name="submit" value="Select Batch Code"> --->
						<cfif checkcustom.customcompany eq "Y">
							<input type="hidden" name="batchcode2" value="#getbatchcode2.batchcode#">
							<input type="hidden" name="obatchcode2" value="#getbatchcode2.batchcode#">
							<input type="button" name="submit" value="Lot Number" onClick="selectBatch('#tran#');">
						<cfelse>
							<input type="submit" name="submit" value="Select Batch Code">
						</cfif>
					<cfelse>
						<input type="hidden" name="items" value="#convertquote(itemno)#">
						<input type="hidden" name="type1" value="#type1#">
						<input type="hidden" name="agenno" value="#getartran.agenno#">
						<input type="hidden" name="enterbatch1" value="#getitem.batchcode#">
						<input type="hidden" name="batchqty" value="#qty#">
                    	<!--- <input type="submit" name="submit" value="Select Batch Code"> --->
					
						<cfif checkcustom.customcompany eq "Y">
							<input type="button" name="submit" value="Lot Number" onClick="selectBatch('#tran#');">
						<cfelse>
							<input type="submit" name="submit" value="Select Batch Code">
						</cfif>
					</cfif>
				</cfif>
				</td>
    		</tr>
    		<tr> 
      			<th>Price</th>
				<td><input name="price" type="text" size="15" maxlength="10" 
				<cfif lcase(Hcomid) eq "meisei_i">value="#numberformat(price,'.____')#"
				<cfelse>value="#numberformat(price,getgeneralinfo.decl_uprice)#"
				</cfif> onchange='document.getElementById("amt").value=document.getElementById("price").value*document.getElementById("qty").value'>
                </td>
    		<tr> 
      			<th>Amount</th>
     			<td><input name="amt" type="text" size="15" maxlength="10" value="#numberformat(amt,".__")#"></td>
    		</tr>
    		</tr>
			<tr>
				<cfif tran neq "TR">
					<th>Location</th><input type="hidden" name="oldlocation" value="#xlocation#">
					<td colspan="3">
						<select name="location" id="location" onChange="getbalqty(this.value);">
			  				<option value="">Choose a Location</option>
			  				<cfloop query="getlocation">
								<option value="#getlocation.location#"<cfif xlocation eq getlocation.location>Selected </cfif>>#location# - #desp#</option>
			  				</cfloop>
						</select>
					</td>
				<cfelse>
                <cfif tran eq "TR" and lcase(hcomid) eq "meisei_i">
                <th>Location From</th>
							<td colspan="3">
								<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
								<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
								<input type="hidden" name="ttran" value="#listfirst(ttran)#">
								<input name="location" value="#listfirst(trfrom)#" readonly>
							</td>
                            <th>On Hand
                            </th>
                            <td><input name="balance" id="balance" type="text" size="6" maxlength="10" value="#balonhand#" readonly>
                            </td>
                            <tr>
							<th>Location To</th>
							<td colspan="3">
								<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
								<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#)">
								<input type="hidden" name="ttran" value="#listfirst(ttran)#">
								<input name="location" value="#listfirst(trto)#" readonly>
							</td>
                            <th>On Hand
                            </th>
                            <td><input name="balance" id="balance" type="text" size="6" maxlength="10" value="#balonhand2#" readonly>
                            </td>
                            </tr>
                            <tr>
                            <th></th><td></td><td></td><td></td>
                </cfif>
                <cfif lcase(hcomid) neq "meisei_i">
					<cfif type1 eq "Edit" or type1 eq "Delete">
						<cfif ttran eq "TROU">
							<th>Location From</th>
							<td colspan="3">
								<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
								<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
								<input type="hidden" name="ttran" value="#listfirst(ttran)#">
								<input name="location" value="#listfirst(trfrom)#" readonly>
							</td>
						<cfelse>
							<th>Location To</th>
							<td colspan="3">
								<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
								<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#)">
								<input type="hidden" name="ttran" value="#listfirst(ttran)#">
								<input name="location" value="#listfirst(trto)#" readonly>
							</td>
						</cfif>
						<input type="hidden" name="ttran1" value="#listfirst(ttran)#">
					<cfelse>
						<!--- Add on 030908 for Graded Item --->
						<input name="location" value="#listfirst(trfrom)#" type="hidden">
						<td colspan="4"></td>
					</cfif>
				</cfif>
                </cfif>
				<th>Discount (%)</th>
				<td><input name="dispec1" type="text" value="#dispec1#" size="6" maxlength="3"></td>
			</tr>
    		<tr> 
      			<th><cfif lcase(hcomid) eq "meisei_i">Model 1<cfelse>Body Remark 1</cfif></th>
      			<td colspan="3"><input name="brem1" type="text" value="#brem1#" size="40" maxlength="40"></td>
	        	<th>&nbsp;</th>
	        	<td><input name="dispec2" type="text" value="#dispec2#" size="6" maxlength="5"></td>
    		</tr>
    		<tr> 
      			<th><cfif lcase(hcomid) eq "meisei_i">Model 2<cfelse>Body Remark 2</cfif></th>
      			<td colspan="3"><input name="brem2" type="text" value="#brem2#" size="40" maxlength="40"></td>
	        	<th>&nbsp;</th>
	        	<td><input name="dispec3" type="text" value="#dispec3#" size="6" maxlength="5"></td>
    		</tr>
    		<tr> 
      			<th>Body Remark 3</th>
      			<td colspan="3"><input name="brem3" type="text" value="#brem3#" size="40" maxlength="40"></td>
	        	<th>Tax (%)</th>
	        	<td><input name="taxpec1" type="text" value="#taxpec1#" size="6" maxlength="3"></td>
    		</tr>
    		<tr> 
      			<th>Body Remark 4</th>
      			<td colspan="3"><input name="brem4" type="text" value="#brem4#" size="40" maxlength="40"></td>
    		</tr>
			<tr> 
      			<th><!--- Project / Job --->#getGsetup.lPROJECT# / #getGsetup.lJOB#</th>
      			<td colspan="3">
					<cfif getGsetup.projectbybill eq "1">
						<input type="text" name="xsource" id="xsource" value="#xsource#" size="20" disabled>
						<input type="text" name="xjob" id="xjob" value="#xjob#" size="20" disabled>
						<input type="hidden" name="source" id="source" value="#xsource#">
						<input type="hidden" name="job" id="job" value="#xjob#">
                        <cfelseif getGsetup.jobbyitem eq "Y">
                        <input type="text" name="xsource" id="xsource" value="#xsource#" size="20" disabled>
                        <input type="hidden" name="source" id="source" value="#xsource#">
                        <cfquery name="getProject2" datasource="#dts#">
						  select * from project where porj = "J" order by source
						</cfquery>
                        <select name="job" id="job">
							<option value="">Choose a #getGsetup.lJOB#</option>
							<cfloop query="getProject2">
								<option value="#getProject2.source#"<cfif xjob eq getProject2.source>Selected</cfif>>#getProject2.source#</option>
							</cfloop>
						</select>
					<cfelse>
						<cfquery name="getProject" datasource="#dts#">
						  select * from project where porj = "P" order by source
						</cfquery>
						
						<cfquery name="getProject2" datasource="#dts#">
						  select * from project where porj = "J" order by source
						</cfquery>
						<select name="source" id="source">
							<option value="">Choose a #getGsetup.lPROJECT#</option>
							<cfloop query="getProject">
								<option value="#getProject.source#"<cfif xsource eq getProject.source>Selected</cfif>>#getProject.source#</option>
							</cfloop>
						</select>
						<select name="job" id="job">
							<option value="">Choose a #getGsetup.lJOB#</option>
							<cfloop query="getProject2">
								<option value="#getProject2.source#"<cfif xjob eq getProject2.source>Selected</cfif>>#getProject2.source#</option>
							</cfloop>
						</select>
					</cfif>
				</td>
    		</tr>
    		<tr> 
      			<td></td>
      			<td colspan="5"></td>
    		</tr>
	    	<tr> 
	      		<th colspan="4">Last 3 Price / Discount History</th>
	    	</tr>
	    	<tr> 
	      		<td><strong>Date</strong></td>
	      		<td width="72"><strong>Price</strong></td>
	      		<td width="95">&nbsp;</td>
	      		<td width="95"><strong>Discount %</strong></td>
	      		<td>&nbsp;</td>
	      		<td>&nbsp;</td>
	    	</tr>
	    	<tr> 
	      		<td>#date1#</td>
	      		<td>#pricehis1#</td>
	      		<td>&nbsp;</td>
	      		<td>#disc1#</td>
	      		<td>&nbsp;</td>
	      		<td>&nbsp;</td>
	    	</tr>
	    	<tr> 
	      		<td>#date2#</td>
	      		<td>#pricehis2#</td>
	      		<td>&nbsp;</td>
	      		<td>#disc2#</td>
	      		<td></td>
	      		<td>&nbsp;</td>
	    	</tr>
	    	<tr> 
	      		<td>#date3#</td>
	      		<td>#pricehis3#</td>
	      		<td>&nbsp;</td>
	      		<td>#disc3#</td>
	      		<td></td>
	      		<td>&nbsp;</td>
	    	</tr>
	    	<tr> 
	      		<td>&nbsp;</td>
	      		<td>&nbsp;</td>
	      		<td>&nbsp;</td>
	     		<td>&nbsp;</td>
	      		<td>&nbsp;</td>
	      		<td> 
		  		<!--- <input type="button" name="back" value="back" onClick="javascript:history.back()"> ---> 
		  		<input type="submit" name="Submit" value="#mode#"> 
	      		</td>
			</tr>
		</table>
	</cfform>
</cfoutput>
<script type="text/javascript">
getbalqty(document.getElementById('location').value);
</script>
</body>
</html>