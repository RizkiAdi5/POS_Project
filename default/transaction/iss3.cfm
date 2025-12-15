<!---<cfajaximport tags="cfform">
<cfajaximport tags="cfform">
<cfajaximport tags="CFINPUT-AUTOSUGGEST"> --->
<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">

<cfquery name="getdisplaysetup" datasource="#dts#">
    select * from displaysetup
</cfquery>

<cfquery name="getmodule" datasource="#dts#">
    select * from modulecontrol
</cfquery>

<cfquery name="gettranname" datasource="#dts#">
select lconsignin,lconsignout,lISS,lOAI,lOAR,ddlitem,addonremark from gsetup
</cfquery> 

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<cfif listfirst(tran) eq "ISS">
	<cfset tran = "ISS">
	<cfset tranname = gettranname.lISS>
	<cfset trancode = "issno">
	<cfset tranarun = "issarun">
<cfelseif listfirst(tran) eq "TR">
	<cfset tran = "TR">
    
    <cfif isdefined('consignment')>
    <cfif consignment eq "out">

    <cfset tranname = "#gettranname.lconsignout#">

	<cfset trancode = "trno">
    <cfset tranarun = "trarun">
    <cfelseif consignment eq "return">
    <cfset tranname = "#gettranname.lconsignin#">
	<cfset trancode = "trno">
    <cfset tranarun = "trarun">
    <cfelse>
    <cfset tranname = "Transfer">
	<cfset trancode = "trno">
	<cfset tranarun = "trarun">
    </cfif>
    <cfelse>
    
	<cfset tranname = "Transfer">
	<cfset trancode = "trno">
	<cfset tranarun = "trarun">
    </cfif>
<cfelseif listfirst(tran) eq "OAI">
	<cfset tran = "OAI">
	<cfset tranname = gettranname.lOAI>
	<cfset trancode = "oaino">
	<cfset tranarun = "oaiarun">
<cfelseif listfirst(tran) eq "OAR">
	<cfset tran = "OAR">
	<cfset tranname = gettranname.lOAR>
	<cfset trancode = "oarno">
	<cfset tranarun = "oararun">	
</cfif>

<cfif isdefined('consignment')>
<cfset consignment = consignment>
<cfelse>
<cfset consignment = ''>
</cfif>

<cfquery datasource="#dts#" name="getGeneralInfo">
	select a.*,(concat(',.',repeat('_',decl_uprice))) as decl_uprice 
	from gsetup as a,gsetup2 as b
</cfquery>
<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>
	
    <cfset multilocation = "">
<cfif getGeneralInfo.multilocation neq "">
	<cfif ListFindNoCase(getgeneralinfo.multilocation, tran, ",") neq 0>
		<cfset multilocation = "Y">
	</cfif>
</cfif>
    
<html>
<head>
<title><cfoutput>#tranname#</cfoutput></title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<script for="feedcontact1" event="ondatasetcomplete">show_info(this.recordset);</script>

<script type='text/javascript' src='../../ajax/core/util.js'></script>


<script language="javascript" type="text/javascript">
	
	<cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
	function trim1 (str) {
				var	str = str.replace(/^\s\s*/, ''),
					ws = /\s/,
					i = str.length;
				while (ws.test(str.charAt(--i)));
				return str.slice(0, i + 1);
			}
			
	function getselectadd(event)
	{
	var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
			if(keyCode==13){
			
			var getitemnostring = document.getElementById('itemselect').value;
			
			var itemnofield = document.getElementById('itemno');
				var mySplitResult = getitemnostring.split("    ");
				var spliresult = trim1(mySplitResult[3]);
				splitresult = spliresult.toLowerCase();
				for (var idx=0;idx<itemnofield.options.length;idx++) 
				{
					if (spliresult==trim(itemnofield.options[idx].value).toLowerCase()) 
					{
						itemnofield.options[idx].selected=true;
						form.submit();
						return true;
						
					}
				}
			
			return false;}
			return true;
	}
</cfif>



	function validate()
	{
		if(document.form.itemno.value=='')
		{
			alert("Your Item's No. cannot be blank.");
			document.form.itemno.focus();
			return false;
		}
		return true;
	}
	
	function getItem(){
		var text = document.form.letter.value;
		var w = document.form.searchtype.selectedIndex;
		var searchtype = document.form.searchtype.options[w].value;
		if(text != ''){
			document.all.feedcontact1.dataurl="databind/act_getitem.cfm?searchtype=" + searchtype + "&text=" + text;
			//prompt("D",document.all.feedcontact1.dataurl);
			document.all.feedcontact1.charset=document.charset;
			document.all.feedcontact1.reset();
		}
	}
	
	function show_info(rset){
		rset.MoveFirst();
		DWRUtil.removeAllOptions("itemno");
		newArray = unescape(rset.fields("itemnolist").value);
		var itemnoArray = newArray.split(";;");
		newArray2 = unescape(rset.fields("itemdesclist").value);
		var itemdescArray = newArray2.split(";;");
		
		for(i=0;i<itemnoArray.length;i++){
			
			myoption = document.createElement("OPTION");
			if(itemnoArray[i] == '-1'){
				myoption.text = itemdescArray[i];
			}else{
				myoption.text = itemnoArray[i] + " - " + itemdescArray[i];
			}
			
			myoption.value = itemnoArray[i];
			document.form.itemno.options.add(myoption);
		}
	}
	
	function getProduct(){
		var inputtext = document.form.searchitemto.value;
		DWREngine._execute(_tranflocation, null, 'productlookup', inputtext, getProductResult);
	}

	function getProductResult(itemArray){
		DWRUtil.removeAllOptions("itemno");
		DWRUtil.addOptions("itemno", itemArray,"KEY", "VALUE");
	}
	
</script>

</head>

<cfif isdefined("form.invoicedate")>
	<cfset dd=dateformat('#form.invoicedate#', "DD")>
	
	<cfif dd greater than '12'>
		<cfset nDateCreate=dateformat('#form.invoicedate#',"YYYYMMDD")>
	<cfelse>
		<cfset nDateCreate=dateformat('#form.invoicedate#',"YYYYDDMM")>
	</cfif>
</cfif>
<!--- Serialno --->
<cfif isdefined("form.trfrom") and isdefined("form.trto") and (form.type eq "Delete" or form.type eq "Edit")>
	<cfif form.remark1 neq form.trfrom or form.remark2 neq form.trto>
		<cfquery name="getSerial" datasource="#dts#">
			select serialno from iserial where type='TR' and refno='#form.currefno#'
			and location='#form.remark2#'
		</cfquery>
		<cfif getSerial.recordcount neq 0>
			<cfquery name="delete_serialno_loc_changed" datasource="#dts#">
				delete from iserial 
				where sign='-1' and 
				serialno in ('#listChangeDelims(valuelist(getSerial.serialno),"','")#')
			</cfquery>
			<cfquery name="delete_serialno_loc_changed" datasource="#dts#">
				delete from iserial 
				where type='TR' and refno='#form.currefno#'
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<cfif isdefined("form.type")>
	<cfif form.type eq "Delete">
		<cfif isdefined("form.keepDeleted")>	<!--- ADD ON 22-12-2009 --->
			<cfset keepDeleted="1">
			<cfset deleteStatus="Voided">
		<cfelse>
			<cfset keepDeleted="">
			<cfset deleteStatus="Deleted">
		</cfif>
		<cfset status = "Invoice #deleteStatus# Successfully">

		<!--- Add On 061008, For View Audit Trail --->
		<cfquery datasource="#dts#" name="getartran">
			select * from artran
			where refno = "#form.currefno#" and type = "#tran#"
		</cfquery>

		<cfquery datasource="#dts#" name="insert">
			insert into artranat 
			(TYPE,REFNO,CUSTNO,FPERIOD,WOS_DATE,DESP,DESPA,
			<cfswitch expression="#tran#">
				<cfcase value="RC,CN,OAI" delimiters=",">
					CREDITAMT
				</cfcase>
				<cfdefaultcase>
					DEBITAMT
				</cfdefaultcase>
			</cfswitch>,
			TRDATETIME,USERID,REMARK,CREATED_BY,UPDATED_BY,CREATED_ON,UPDATED_ON)
			values
			('#tran#','#form.currefno#','#getartran.custno#','#getartran.fperiod#',#getartran.wos_date#,'#getartran.desp#','#getartran.despa#',
			<cfswitch expression="#tran#">
				<cfcase value="RC,CN,OAI" delimiters=",">
					'#getartran.grand#'
				</cfcase>
				<cfdefaultcase>
				'#getartran.grand#'
				</cfdefaultcase>
			</cfswitch>,
			<cfif getartran.trdatetime neq "">#createdatetime(year(getartran.trdatetime),month(getartran.trdatetime),day(getartran.trdatetime),hour(getartran.trdatetime),minute(getartran.trdatetime),second(getartran.trdatetime))#<cfelse>'0000-00-00'</cfif>,
			'#getartran.userid#','#deleteStatus#','#getartran.created_by#','#Huserid#',
			<cfif getartran.created_on neq "">#createdatetime(year(getartran.created_on),month(getartran.created_on),day(getartran.created_on),hour(getartran.created_on),minute(getartran.created_on),second(getartran.created_on))#<cfelse>'0000-00-00'</cfif>,
			#now()#)
		</cfquery>
		<!--- Add On 061008, For View Audit Trail --->

		<cfif tran eq "TR">
			<cfif keepDeleted eq "1">
				<cfquery datasource="#dts#" name="updateartran">
					Update artran
					set void='Y' 
					where refno = "#form.currefno#" and (type = 'TR')
				</cfquery>
                <cfquery datasource="#dts#" name="updateartran">
					Update ictran
					set void='Y' 
					where refno = "#form.currefno#" and (type = 'TRIN')
				</cfquery>
                <cfquery datasource="#dts#" name="updateartran">
					Update ictran
					set void='Y' 
					where refno = "#form.currefno#" and (type = 'TROU')
				</cfquery>
			<cfelse>
				<cfquery datasource="#dts#" name="deleteartran">
					Delete from artran where refno = "#form.currefno#" and (type = 'TR')
				</cfquery>
			</cfif>
			
			<cfquery name="getallitems" datasource="#dts#">
				select type,itemno,qty,fperiod from ictran where refno = "#form.currefno#" and (type = 'TROU' or type='TRIN')
			</cfquery>
			
			<cfquery name="getbatchitem" datasource="#dts#">
				select type,batchcode,itemno,qty,fperiod,location from ictran where refno = "#form.currefno#" and (type = 'TROU' or type='TRIN')
			</cfquery>

			<cfif getbatchitem.recordcount gt 0>
				<cfloop query="getbatchitem">
					<cfif getbatchitem.location neq "">
						<cfquery name="updateobbatch" datasource="#dts#">
							update lobthob set <cfif getbatchitem.type eq "TROU">bth_qut=(bth_qut-#getbatchitem.qty#)<cfelseif getbatchitem.type eq "TRIN">bth_qin=(bth_qin-#getbatchitem.qty#)</cfif>
							where location ='#getbatchitem.location#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
						</cfquery>
						<cfquery name="updateobbatch" datasource="#dts#">
							update obbatch set <cfif getbatchitem.type eq "TROU">bth_qut=(bth_qut-#getbatchitem.qty#)<cfelseif getbatchitem.type eq "TRIN">bth_qin=(bth_qin-#getbatchitem.qty#)</cfif>
							where itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
			
			<cfif getallitems.recordcount gt 0>
				<cfloop query="getallitems">
					<cfif getallitems.type eq "TRIN">
						<cfset qname='QIN'&(getallitems.fperiod+10)>
					<cfelse>
						<cfset qname='QOUT'&(getallitems.fperiod+10)>
					</cfif>
					
					<cfquery name="UpdateIcitem" datasource="#dts#">
						update icitem set #qname#=(#qname#-#getallitems.qty#) where itemno = '#getallitems.itemno#'
					</cfquery>
				</cfloop>
			</cfif>
			
			<cfif keepDeleted eq "1">
				<cfquery datasource="#dts#" name="updateictran">
					Update ictran 
					set void='Y' 
					where refno = "#form.currefno#" and (type = 'TROU' or type='TRIN')
				</cfquery>
			
				<cfquery datasource="#dts#" name="updateserial">
					Update iserial 
					set void='Y' 
					where refno = "#form.currefno#" and (type = 'TROU' or type='TRIN')
				</cfquery>
			<cfelse>
				<cfquery datasource="#dts#" name="deleteictran">
					Delete from ictran where refno = "#form.currefno#" and (type = 'TROU' or type='TRIN')
				</cfquery>
			
				<cfquery datasource="#dts#" name="deleteserial">
					Delete from iserial where refno = "#form.currefno#" and (type = 'TROU' or type='TRIN')
				</cfquery>
			</cfif>
			
			<!--- Begin: Add on 030908 for Graded Item --->
			<cfquery name="getigrade" datasource="#dts#">
				select * from igrade where refno = "#form.currefno#" and (type = 'TROU' or type='TRIN')
			</cfquery>
			
			<cfif getigrade.recordcount neq 0>
				<cfset firstcount = 11>
				<cfset maxcounter = 70>
				<cfset totalrecord = (maxcounter - firstcount + 1)>
				
				<cfloop query="getigrade">
					<cfloop from="#firstcount#" to="#maxcounter#" index="i">
						<cfif i eq firstcount>
							<cfset grdvaluelist = Evaluate("getigrade.GRD#i#")>
							<cfset bgrdlist = "bgrd"&i>
						<cfelse>
							<cfset grdvaluelist = grdvaluelist&","&Evaluate("getigrade.GRD#i#")>
							<cfset bgrdlist = bgrdlist&",bgrd"&i>
						</cfif>	
					</cfloop>
					
					<cfset myArray = ListToArray(bgrdlist,",")>
					<cfset myArray2 = ListToArray(grdvaluelist,",")>
					
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#totalrecord#" index="i">
							<cfif i neq totalrecord>
								#myArray[i]# = #myArray[i]#<cfif getigrade.type eq "TRIN">-<cfelse>+</cfif>#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#<cfif getigrade.type eq "TRIN">-<cfelse>+</cfif>#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.location#">
					</cfquery>
					
				</cfloop>
				<cfif keepDeleted eq "1">
					<cfquery name="updateigrade" datasource="#dts#">
						Update igrade
						set void='Y' 
						where refno = "#form.currefno#" and (type = 'TROU' or type='TRIN')
					</cfquery>
				<cfelse>
					<cfquery name="deleteigrade" datasource="#dts#">
						delete from igrade
						where refno = "#form.currefno#"
						and (type = 'TROU' or type='TRIN')
					</cfquery>
				</cfif>
			</cfif>
			<!--- End --->
		<cfelse><!--- Tran neq TR --->
			<cfif keepDeleted eq "1">
				<cfquery datasource="#dts#" name="updateartran">
					Update artran 
					set void='Y'
					where refno = "#form.currefno#" and type = "#tran#"
				</cfquery>
			<cfelse>
				<cfquery datasource="#dts#" name="deleteartran">
					Delete from artran where refno = "#form.currefno#" and type = "#tran#"
				</cfquery>
			</cfif>
			
			<cfquery name="getbatchitem" datasource="#dts#">
				select batchcode,itemno,qty,fperiod,location from ictran where refno = "#form.currefno#" and type = "#tran#"
			</cfquery>
			
			<cfquery name="getallitems" datasource="#dts#">
				select itemno,qty from ictran where refno = "#form.currefno#" and type = "#tran#"
			</cfquery>
			
			<cfif getbatchitem.recordcount gt 0>
				<cfif tran eq "OAI">
					<cfset obtype= "bth_qin">
				<cfelse>
					<cfset obtype= "bth_qut">
				</cfif>
				
				<cfloop query="getbatchitem">
					<cfif getbatchitem.location neq "">
						<cfquery name="updateobbatch" datasource="#dts#">
							update lobthob set #obtype#=(#obtype#-#getbatchitem.qty#) 
							where location ='#location#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
						</cfquery>
						<cfquery name="updateobbatch" datasource="#dts#">
							update obbatch set #obtype#=(#obtype#-#getbatchitem.qty#) 
							where itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
						</cfquery>
					<cfelse>
						<cfquery name="updateobbatch" datasource="#dts#">
							update obbatch set #obtype#=(#obtype#-#getbatchitem.qty#) 
							where itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
			
			<cfif getallitems.recordcount gt 0>
				<cfif tran eq "OAI">
					<cfset qname='QIN'&(getbatchitem.fperiod+10)>
				<cfelse>
					<cfset qname='QOUT'&(getbatchitem.fperiod+10)>
				</cfif>
				
				<cfloop query="getallitems">
					<cfquery name="UpdateIcitem" datasource="#dts#">
						update icitem set #qname#=(#qname#-#qty#) where itemno = '#getallitems.itemno#'
					</cfquery>
				</cfloop>
			</cfif>
			
			<cfif keepDeleted eq "1">
				<cfquery datasource="#dts#" name="updateictran">
					Update ictran 
					set void='Y'
					where refno = "#form.currefno#" and type = "#tran#"
				</cfquery>
			
				<cfquery datasource="#dts#" name="updateserial">
					Update iserial 
					set void='Y'
					where refno = "#form.currefno#" and type = "#tran#"
				</cfquery>
			<cfelse>
				<cfquery datasource="#dts#" name="deleteictran">
					Delete from ictran where refno = "#form.currefno#" and type = "#tran#"
				</cfquery>
			
				<cfquery datasource="#dts#" name="deleteserial">
					Delete from iserial where refno = "#form.currefno#" and type = "#tran#"
				</cfquery>
			</cfif>
			
			<!--- Begin: Add on 030908 for Graded Item --->
			<cfquery name="getigrade" datasource="#dts#">
				select * from igrade where refno = "#form.currefno#" and type = "#tran#"
			</cfquery>
			
			<cfif getigrade.recordcount neq 0>
				<cfset firstcount = 11>
				<cfset maxcounter = 70>
				<cfset totalrecord = (maxcounter - firstcount + 1)>
				
				<cfif getigrade.type neq "SO" and getigrade.type neq "PO" and getigrade.type neq "QUO" and getigrade.type neq "SAM">
					<cfloop from="#firstcount#" to="#maxcounter#" index="i">
						<cfif i eq firstcount>
							<cfset grdvaluelist = Evaluate("getigrade.GRD#i#")>
							<cfset bgrdlist = "bgrd"&i>
						<cfelse>
							<cfset grdvaluelist = grdvaluelist&","&Evaluate("getigrade.GRD#i#")>
							<cfset bgrdlist = bgrdlist&",bgrd"&i>
						</cfif>	
					</cfloop>
	
					<cfset myArray = ListToArray(bgrdlist,",")>
					<cfset myArray2 = ListToArray(grdvaluelist,",")>
	
					<cfquery name="updateitemgrd" datasource="#dts#">
						update itemgrd
						set
						<cfloop from="1" to="#totalrecord#" index="i">
							<cfif i neq totalrecord>
								#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#"> 
					</cfquery>
	
		
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#totalrecord#" index="i">
							<cfif i neq totalrecord>
								#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.location#">
					</cfquery>
				</cfif>
				
				<cfif keepDeleted eq "1">
					<cfquery name="updateigrade" datasource="#dts#">
						Update igrade
						set void='Y'
						where refno = '#getigrade.refno#' and type = '#getigrade.type#'
					</cfquery>
				<cfelse>
					<cfquery name="deleteigrade" datasource="#dts#">
						delete from igrade
						where refno = '#getigrade.refno#'
						and type = '#getigrade.type#'
					</cfquery>
				</cfif>
			</cfif>
			<!--- End --->
		</cfif>

		<cfform name="done" action="iss.cfm" method="post">
			<cfoutput>
				<input type="hidden" value="#tran#" name="tran">
                <input type="hidden" value="#consignment#" name="consignment">
				<input name="status" value="#status#" type="hidden">
			</cfoutput>
		</cfform>	

		<script>
			done.submit();
		</script>
		
		<cfabort>
	</cfif>
</cfif>
<!---Control create year end bill--->
<cfif isdefined("form.type") and form.type eq "Create">

	<cfset lastaccyear = dateformat(getGeneralInfo.lastaccyear, "dd/mm/yyyy")>
	<cfset period = '#getGeneralInfo.period#'>
	<cfset currentdate =dateformat(form.invoicedate,"dd/mm/yyyy")>
	<cfset tmpYear = year(currentdate)>
	<cfset clsyear = year(lastaccyear)>
	<cfset tmpmonth = month(currentdate)>
	<cfset clsmonth = month(lastaccyear)>
	<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>
	
    <cfif intperiod gt 18 or intperiod lte 0>
		<cfset readperiod = 99>
	<cfelse>
		<cfset readperiod = numberformat(intperiod,"00")>
	</cfif>

<cfif readperiod eq '99'>
        <h3>Error, the bill date is over period 18. Please contact system administrator.</h3>
        <cfabort>
</cfif>
<!--- --->
</cfif>

<cfif isdefined("form.type") and form.type eq "Edit">
	<!--- Add on 260808 --->
	<cfset hmode = "Edit">
	<cfset status = "Invoice Edited Successfully">		
	<cfset lastaccyear = dateformat(getGeneralInfo.lastaccyear, "dd/mm/yyyy")>
	<cfset period = '#getGeneralInfo.period#'>
	<cfset currentdate =dateformat(form.invoicedate,"dd/mm/yyyy")>
	<cfset tmpYear = year(currentdate)>
	<cfset clsyear = year(lastaccyear)>
	<cfset tmpmonth = month(currentdate)>
	<cfset clsmonth = month(lastaccyear)>
	<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>
	
	<cfif intperiod gt 18 or intperiod lte 0>
		<cfset readperiod = 99>
	<cfelse>
		<cfset readperiod = numberformat(intperiod,"00")>
	</cfif>
	
    
    
	<!--- ADD ON 090608, WHEN THE PERIOD CHANGED, THE QIN/QOUT BASED ON THE PERIOD HAVE TO CHANGE TOO --->
	<cfquery datasource='#dts#' name="getpreviousperiod">
		select * from artran where refno = '#form.currefno#' and type = '#tran#'
	</cfquery>
	<cfif readperiod neq getpreviousperiod.fperiod>
	
	<cfif listfirst(tran) neq "TR">
		<cfif listfirst(tran) eq "OAI">
			<cfset qname_old='QIN'&(getpreviousperiod.fperiod+10)>
			<cfset qname_new='QIN'&(readperiod+10)>
		<cfelse>
			<cfset qname_old='QOUT'&(getpreviousperiod.fperiod+10)>
			<cfset qname_new='QOUT'&(readperiod+10)>
		</cfif>
		<cfquery name="geticitem" datasource="#dts#">
			select * from ictran
			where refno = '#form.currefno#' and type = '#tran#'
			and (void = '' or void is null)
		</cfquery>
		<cfif geticitem.recordcount neq 0>
			<cfloop query="geticitem">
				<cfquery name="UpdateIcitem" datasource="#dts#">
					update icitem set 
					#qname_old#=(#qname_old#-#geticitem.qty#),
					#qname_new#=(#qname_new#+#geticitem.qty#)
					where itemno='#geticitem.itemno#'
				</cfquery>
			</cfloop>
		</cfif>
	<cfelse>
		<cfquery name="geticitem" datasource="#dts#">
			select * from ictran
			where refno = '#form.currefno#' and type = 'TRIN'
			and (void = '' or void is null)
		</cfquery>
		
		<cfset qin_old='QIN'&(getpreviousperiod.fperiod+10)>
		<cfset qin_new='QIN'&(readperiod+10)>
		<cfset qout_old='QOUT'&(getpreviousperiod.fperiod+10)>
		<cfset qout_new='QOUT'&(readperiod+10)>
		
		<cfif geticitem.recordcount neq 0>
			<cfloop query="geticitem">
				<cfquery name="UpdateIcitem" datasource="#dts#">
					update icitem set 
					#qin_old#=(#qin_old#-#geticitem.qty#),
					#qin_new#=(#qin_new#+#geticitem.qty#),
					#qout_old#=(#qout_old#-#geticitem.qty#),
					#qout_new#=(#qout_new#+#geticitem.qty#)
					where itemno='#geticitem.itemno#'
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>
	
	</cfif>
	<!--- ADD ON 090608, WHEN THE PERIOD CHANGED, THE QIN/QOUT BASED ON THE PERIOD HAVE TO CHANGE TOO --->
	
	<!--- To add more fields to add in!! --->
	<!--- ADD PROJECT & JOB on 25-11-2009 --->
	<cfquery datasource="#dts#" name="updateartran">
		Update artran set wos_date = #ndatecreate#, fperiod = '#numberformat(readperiod,"00")#', agenno = '#form.agenno#',
		source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Source#">,
		job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Job#">,
		custno = '#form.custno#',
		name = '#form.name#', 
		rem0 = '#form.remark0#', <cfif tran neq 'TR'>rem1 = '#form.remark1#', rem2 = '#form.remark2#',<cfelse>rem1 = '#form.trfrom#', rem2 = '#form.trto#',</cfif> rem3 = '#form.remark3#',
		rem4 = '#form.remark4#', rem5 = '#form.remark5#', rem6 = '#form.remark6#', rem7 = '#form.remark7#',
		rem8 = '#form.remark8#', rem9 = '#form.remark9#', rem10 = '#form.remark10#', 
		rem11 = '#form.remark11#'<cfif getpreviousperiod.userid eq "" and lcase(husergrpid) neq "super"><cfif getGeneralInfo.tranuserid neq "Y">,userid='#Huserid#'</cfif></cfif><cfif tran eq "TR">, term = '#form.term#'</cfif>,
		updated_by = '#Huserid#',updated_on = #now()#
		where refno = "#form.currefno#" and type = "#tran#"
	</cfquery>
	
    <cfif gettranname.addonremark eq 'Y'>
        <cfinclude template="iss2updateaddonremark.cfm">
    </cfif>
    
	<cfset nexttranno = "#form.currefno#">
	
	<!--- Readperiod will be inserted into the period in the database. --->
	<!--- End of Read period --->
	<cfif tran eq "TR">
		<!--- Modified on 040908, Update the Date,Period and etc --->
		<!--- <cfquery name="updatetrfrom" datasource="#dts#">
			update ictran set location='#trfrom#' where refno = '#form.currefno#' and type = 'TROU'
		</cfquery>
		
		<cfquery name="updatetrto" datasource="#dts#">
			update ictran set location='#trto#' where refno = '#form.currefno#' and type = 'TRIN'
		</cfquery> --->
		
		<!--- ADD PROJECT & JOB on 25-11-2009 --->
		<cfquery name="updatetrfrom" datasource="#dts#">
			update ictran 
			set location='#trfrom#',
			wos_date = #ndatecreate#,
			fperiod = '#numberformat(readperiod,"00")#',
			custno = '#form.custno#',
			name = '#form.name#', 
			agenno = '#form.agenno#'	
			<cfif getGeneralInfo.projectbybill eq "1">
				,source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Source#">,
				job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Job#">
			</cfif>
			where refno = '#form.currefno#' and type = 'TROU'
		</cfquery>
		
		<cfquery name="updatetrto" datasource="#dts#">
			update ictran 
			set location='#trto#',
			wos_date = #ndatecreate#,
			fperiod = '#numberformat(readperiod,"00")#',
			custno = '#form.custno#',
			name = '#form.name#', 
			agenno = '#form.agenno#'
			<cfif getGeneralInfo.projectbybill eq "1">
				,source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Source#">,
				job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Job#">
			</cfif>
			<cfif checkcustom.customcompany eq "Y">,BREM5='#form.remark5#',BREM7='#form.remark6#'</cfif>
			where refno = '#form.currefno#' and type = 'TRIN'
			<!--- <cfif lcase(hcomid) eq "thaipore_i" or lcase(hcomid) eq "jaynbtrading_i">and BREM6 <> 'I'</cfif> --->
		</cfquery>
		
		<!--- <cfquery name="getbatchitem" datasource="#dts#">
			select * from ictran where batchcode <> ''
		</cfquery> --->
		<cfquery name="getbatchitem" datasource="#dts#">
			select * from ictran 
			where batchcode <> ''
			and refno = '#form.currefno#'
			and type in ('TRIN','TROU')
		</cfquery>
		
		<cfif getbatchitem.recordcount gt 0>
			<cfloop query="getbatchitem">
				<cfif getbatchitem.type eq "TROU">
					<cfif trfrom neq oldtrfrom>
						<!--- <cfquery name="checklobthob" datasource="#dts#">
							select location,batchcode,itemno from lobthob where location='#trfrom#' and batchcode='#getbatchitem.batchcode#' and itemno='#getbatchitem.itemno#'
						</cfquery> --->
						<cfquery name="checklobthob" datasource="#dts#">
							select location,batchcode,itemno<cfif checkcustom.customcompany eq "Y">,permit_no</cfif> 
							from lobthob 
							where location='#trfrom#' and batchcode='#getbatchitem.batchcode#' and itemno='#getbatchitem.itemno#'
						</cfquery>
						
						<cfif checklobthob.recordcount eq 0>
							<cfquery name="insertlobthob" datasource="#dts#">
								insert into lobthob 
								(location,batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,expdate,rc_type,rc_refno,rc_expdate<cfif checkcustom.customcompany eq "Y">,permit_no</cfif>) 
								values
								('#trfrom#','#getbatchitem.batchcode#','#getbatchitem.itemno#','','','0','0','#getbatchitem.qty#','0','0','0','','','',''<cfif checkcustom.customcompany eq "Y">,'#getbatchitem.permit_no#'</cfif>)
							</cfquery>
							
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set bth_qut=(bth_qut-#getbatchitem.qty#) 
								where location='#oldtrfrom#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery>
						<cfelse>
							<!--- <cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set bth_qut=(bth_qut+#getbatchitem.qty#) 
								where location='#trfrom#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery> --->
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set bth_qut=(bth_qut+#getbatchitem.qty#) 
								where location='#trfrom#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery>
							
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set bth_qut=(bth_qut-#getbatchitem.qty#) 
								where location='#oldtrfrom#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif getbatchitem.type eq "TRIN">
					<cfif trto neq oldtrto>
						<cfquery name="checklobthob" datasource="#dts#">
							select location,batchcode,itemno<cfif checkcustom.customcompany eq "Y">,permit_no</cfif> 
							from lobthob 
							where location='#trto#' and batchcode='#getbatchitem.batchcode#' and itemno='#getbatchitem.itemno#'
						</cfquery>
						
						<cfif checklobthob.recordcount eq 0>
							<!--- <cfquery name="insertlobthob" datasource="#dts#">
								insert into lobthob (location,batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,expdate,rc_type,rc_refno,rc_expdate) 
								values('#trto#','#getbatchitem.batchcode#','#getbatchitem.itemno#','','','0','#getbatchitem.qty#','0','0','0','0','','','','')
							</cfquery> --->
							<cfquery name="insertlobthob" datasource="#dts#">
								insert into lobthob 
								(location,batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,expdate,rc_type,rc_refno,rc_expdate<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
								values
								('#trto#','#getbatchitem.batchcode#','#getbatchitem.itemno#','','','0','#getbatchitem.qty#','0','0','0','0','','','',''<cfif checkcustom.customcompany eq "Y">,'#form.remark5#','#form.remark6#'</cfif>)
							</cfquery>
							
							<!--- <cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set bth_qin=(bth_qin-#getbatchitem.qty#) 
								where location='#oldtrto#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery> --->
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob 
								set bth_qin=(bth_qin-#getbatchitem.qty#) 
								where location='#oldtrto#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery>
						<cfelse>
							<!--- <cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set bth_qin=(bth_qin+#getbatchitem.qty#) 
								where location='#trto#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery> --->
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob 
								set bth_qin=(bth_qin+#getbatchitem.qty#)
								<cfif checkcustom.customcompany eq "Y">,permit_no='#form.remark5#',permit_no2='#form.remark6#'</cfif> 
								where location='#trto#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery>
							
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set bth_qin=(bth_qin-#getbatchitem.qty#) 
								where location='#oldtrto#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery>
						</cfif>
					 <cfelse>
                    	<cfif checkcustom.customcompany eq "Y">
                        	<cfquery name="updatepermit" datasource="#dts#">
								update lobthob 
								set permit_no='#form.remark5#',permit_no2='#form.remark6#'
								where location='#getbatchitem.location#' and itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery>
                            <cfquery name="updatepermit" datasource="#dts#">
								update obbatch 
								set permit_no='#form.remark5#',permit_no2='#form.remark6#'
								where itemno='#getbatchitem.itemno#' and batchcode='#getbatchitem.batchcode#'
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<!--- Add on 040908, For Graded Item (TYPE eq "TR")--->
		<cfquery name="getigrade" datasource="#dts#">
			select * from igrade where refno = "#form.currefno#" and type='TRIN'
		</cfquery>
		
		<cfif getigrade.recordcount neq 0>
			<cfset firstcount = 11>
			<cfset maxcounter = 70>
			<cfset totalrecord = (maxcounter - firstcount + 1)>
			
			<cfloop query="getigrade">
				
				<cfloop from="#firstcount#" to="#maxcounter#" index="i">
					<cfif i eq firstcount>
						<cfset grdvaluelist = Evaluate("getigrade.GRD#i#")>
						<cfset bgrdlist = "bgrd"&i>
					<cfelse>
						<cfset grdvaluelist = grdvaluelist&","&Evaluate("getigrade.GRD#i#")>
						<cfset bgrdlist = bgrdlist&",bgrd"&i>
					</cfif>	
				</cfloop>
				
				<cfset myArray = ListToArray(bgrdlist,",")>
				<cfset myArray2 = ListToArray(grdvaluelist,",")>
				
				<cfif oldtrto neq trto>
					<cfquery name="checkexist" datasource="#dts#">
						select * from logrdob
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = '#trto#'
					</cfquery>
					
					<cfif checkexist.recordcount eq 0>
						<cfquery name="insert" datasource="#dts#">
							insert into logrdob 
							(itemno,location)
							values
							(<cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">,
							'#trto#')
						</cfquery>
					</cfif>
					
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#totalrecord#" index="i">
							<cfif i neq totalrecord>
								#myArray[i]# = #myArray[i]#+#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#+#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = '#trto#'
					</cfquery>
				
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#totalrecord#" index="i">
							<cfif i neq totalrecord>
								#myArray[i]# = #myArray[i]#-#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#-#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = '#oldtrto#'
					</cfquery>
				</cfif>
				
				<cfif oldtrfrom neq trfrom>
					<cfquery name="checkexist2" datasource="#dts#">
						select * from logrdob
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = '#trfrom#'
					</cfquery>
					
					<cfif checkexist2.recordcount eq 0>
						<cfquery name="insert" datasource="#dts#">
							insert into logrdob 
							(itemno,location)
							values
							(<cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">,
							'#trfrom#')
						</cfquery>
					</cfif>
				
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#totalrecord#" index="i">
							<cfif i neq totalrecord>
								#myArray[i]# = #myArray[i]#-#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#-#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = '#trfrom#'
					</cfquery>
				
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#totalrecord#" index="i">
							<cfif i neq totalrecord>
								#myArray[i]# = #myArray[i]#+#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#+#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = '#oldtrfrom#'
					</cfquery>
				</cfif>
				
				<cfquery name="updateigrade" datasource="#dts#">
					update igrade
					set wos_date = #ndatecreate#,
					fperiod = '#numberformat(readperiod,"00")#',
					custno = '#form.custno#',
					location = '#trto#'
					where refno = '#getigrade.refno#'
					and type = 'TRIN'
				</cfquery>
				
				<cfquery name="updateigrade2" datasource="#dts#">
					update igrade
					set wos_date = #ndatecreate#,
					fperiod = '#numberformat(readperiod,"00")#',
					custno = '#form.custno#',
					location = '#trfrom#'
					where refno = '#getigrade.refno#'
					and type = 'TROU'
				</cfquery>
			</cfloop>
		</cfif>
		<!--- End --->
		
	<cfelse>	<!--- Add on 040908, For TYPE neq "TR" --->
		<!--- ADD PROJECT & JOB on 25-11-2009 --->
		<cfquery name="updateictran" datasource="#dts#">
			update ictran 
			set wos_date = #ndatecreate#,
			fperiod = '#numberformat(readperiod,"00")#',
			custno = '#form.custno#',
			name = '#form.name#', 
			agenno = '#form.agenno#'
			<cfif getGeneralInfo.projectbybill eq "1">
				,source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Source#">,
				job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Job#">
			</cfif>
			<cfif (checkcustom.customcompany eq "Y") and tran eq "OAI">,BREM5='#form.remark5#',BREM7='#form.remark6#'</cfif>
			where refno = '#form.currefno#' and type = "#tran#"
		</cfquery>
		
		<!--- Add on 040908, For Graded Item (TYPE neq "TR")--->
		<cfquery name="updateigrade" datasource="#dts#">
			update igrade
			set wos_date = #ndatecreate#,
			fperiod = '#numberformat(readperiod,"00")#',
			custno = '#form.custno#'
			where refno = '#form.currefno#' and type = "#tran#"
		</cfquery>
		<!--- End 040908 --->
	</cfif>
</cfif>

<cfif isdefined("form.type") and form.type eq "Create">
	<!--- REMARK ON 240608 AND REPLACE WITH THE BELOW ONE --->
	<!---cfquery datasource="#dts#" name="getGeneralInfo">
		Select #trancode# as tranno, #tranarun# as arun from GSetup
	</cfquery--->
	
	<!--- <cfquery datasource="main" name="getGeneralInfo">
		select lastUsedNo as tranno, refnoused as arun 
		from refnoset
		where userDept = '#dts#'
		and type = '#tran#'
		and counter = <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
	</cfquery> --->
	<!--- Add on 260808 --->
    
    <!---check consignment refnoset --->
<cfif consignment eq 'out'>
<cfquery datasource="#dts#" name="Checkconsignmentoutno">
select lastUsedNo as result, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = 2
</cfquery>
</cfif>

<cfif consignment eq 'return'>
<cfquery datasource="#dts#" name="Checkconsignmentoutno">
select lastUsedNo as result, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = 3
</cfquery>
</cfif>
    <!--- --->
	<cfset hmode = "Create">
	<cfquery datasource="#dts#" name="getGeneralInfo">
		select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse 
		from refnoset
		where type = '#tran#'
		and counter = <cfif isdefined("form.invset")>'#form.invset#'<cfelse><cfif consignment eq 'out' and Checkconsignmentoutno.recordcount neq 0>2<cfelseif consignment eq 'return' and Checkconsignmentoutno.recordcount neq 0>3<cfelse>1</cfif></cfif>
	</cfquery>
	
	<cfif getGeneralInfo.arun eq "1">
		<cfset refnocnt = len(getGeneralInfo.tranno)>	
		<cfset cnt = 0>
		<cfset yes = 0>
		
		<cfloop condition = "cnt lte refnocnt and yes eq 0">
			<cfset cnt = cnt + 1>			
			<cfif isnumeric(mid(getGeneralInfo.tranno,cnt,1))>				
				<cfset yes = 1>			
			</cfif>								
		</cfloop>
		
		<cfset nolen = refnocnt - cnt + 1>
		<cfset nextno = right(getGeneralInfo.tranno,nolen) + 1>
		<cfset nocnt = 1>
		<cfset zero = "">
		
		<cfloop condition = "nocnt lte nolen">
			<cfset zero = zero & "0">
			<cfset nocnt = nocnt + 1>	
		</cfloop>
				
		<cfif tran eq 'SO' or tran eq 'PO' or tran eq 'QUO'> 
			<cfset limit = 24>
		<cfelse>
			<cfset limit = 10>
		</cfif>
		
		<cfif cnt gt 1>
			<cfset nexttranno = left(getGeneralInfo.tranno,cnt-1)&numberformat(nextno,zero)>
			<cfif len(nexttranno) gt limit>
				<cfset nexttranno = '99999999'>
			</cfif>
		<cfelse>
			<cfset nexttranno = numberformat(nextno,zero)> 
			<cfif len(nexttranno) gt limit>
				<cfset nexttranno = '99999999'>
			</cfif>
		</cfif>
		
		<cfif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "chemline_i">
			<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
			<cfset nexttranno = newnextNum>
        <cfelse>
        	<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
        	<cfset actual_nexttranno = newnextNum>
            <cfif (getGeneralInfo.refnocode2 neq "" or getGeneralInfo.refnocode neq "") and getGeneralInfo.presuffixuse eq "1">
				<cfset nexttranno = getGeneralInfo.refnocode&actual_nexttranno&getGeneralInfo.refnocode2>
            <cfelse>
            	<cfset nexttranno = actual_nexttranno>
			</cfif>
		</cfif>
		
		<cfquery name="checkexist" datasource="#dts#">
			select refno from artran where type = '#tran#' and refno = '#nexttranno#'
		</cfquery>
		
		<cfif checkexist.recordcount gt 0>
			<h3>Sorry, this transaction number have been used.</h3>
			<cfabort>
		</cfif>
	<cfelse>
		<cfquery name="checkexist" datasource="#dts#">
			select refno from artran where type = '#tran#' and refno = '#form.nexttranno#'
		</cfquery>
		
		<cfif checkexist.recordcount gt 0>
			<h3>Sorry, this transaction number have been used.</h3>
			<cfabort>
		</cfif>
		
		<cfset nexttranno = form.nexttranno>
	</cfif>

	<!--- REMARK ON 240608 AND REPLACE WITH THE BELOW ONE --->
	<!---cfquery datasource="#dts#" name="updategsetup">
		Update Gsetup set #trancode# =UPPER("#nexttranno#")
	</cfquery--->
	
	<!--- <cfquery name="updategsetup" datasource="main">
		update refnoset 
		set lastUsedNo=UPPER('#nexttranno#')
		where userDept = '#dts#'
		and type = '#tran#'
		and counter =  <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
	</cfquery> --->
	
	<cfquery name="updategsetup" datasource="#dts#">
		update refnoset 
		set lastUsedNo=<cfif isdefined("actual_nexttranno")>UPPER('#actual_nexttranno#')<cfelse>UPPER('#nexttranno#')</cfif>
		where type = '#tran#'
		and counter =  <cfif isdefined("form.invset")>'#form.invset#'<cfelse><cfif consignment eq 'out' and Checkconsignmentoutno.recordcount neq 0>2<cfelseif consignment eq 'return' and Checkconsignmentoutno.recordcount neq 0>3<cfelse>1</cfif></cfif>
	</cfquery>
	
	<cfset dd=dateformat('#form.invoicedate#', "DD")>
	
	<cfif dd greater than '12'>
		<cfset nDateCreate=dateformat('#form.invoicedate#',"YYYYMMDD")>
	<cfelse>
		<cfset nDateCreate=dateformat('#form.invoicedate#',"YYYYDDMM")>
	</cfif>
	
	<cfset dd=dateformat('#now()#', "DD")>
	
	<cfif dd greater than '12'>
		<cfset nDateNow=dateformat('#now()#',"YYYYMMDD")>
	<cfelse>
		<cfset nDateNow=dateformat('#now()#',"YYYYDDMM")>
	</cfif>

	<!--- Calculate the period --->
	<cfquery datasource="#dts#" name="getGeneralInfo">
		Select * from GSetup
	</cfquery>
	
	<cfset lastaccyear = dateformat(getGeneralInfo.lastaccyear, "dd/mm/yyyy")>
	<cfset period = '#getGeneralInfo.period#'>
	<cfset currentdate = dateformat(form.invoicedate,"dd/mm/yyyy")>
	<cfset tmpYear = year(currentdate)>
	<cfset clsyear = year(lastaccyear)>
	<cfset tmpmonth = month(currentdate)>
	<cfset clsmonth = month(lastaccyear)>
	<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>
	
	<cfif intperiod gt 18 or intperiod lte 0>
		<cfset readperiod = 99>
	<cfelse>
		<cfset readperiod = "#intperiod#">
	</cfif>

	<!--- ADD PROJECT & JOB on 25-11-2009 --->
	<cfquery datasource="#dts#" name="insertartran">
		Insert into artran (type,refno,custno,fperiod,wos_date,agenno,source,job,
		rem0,rem1,rem2,rem3,rem4,rem5,rem6,rem7,rem8,rem9,rem10,rem11,name,exported,
		trdatetime,userid<cfif tran eq "TR">,term</cfif>,created_by,created_on,updated_by,updated_on,consignment<cfif gettranname.addonremark eq 'Y'>,rem30,rem31,rem32,rem33,rem34,rem35,rem36,rem37,rem38,rem39,rem40,rem41,rem42,rem43,rem44,rem45,rem46,rem47,rem48,rem49</cfif>)
			
		values('#tran#','#nexttranno#','#form.custno#','#numberformat(readperiod,"00")#',#nDateCreate#,'#form.agenno#',
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Source#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Job#">,
		'#form.remark0#',<cfif tran neq 'TR'>'#form.remark1#', '#form.remark2#',
		<cfelse>'#form.trfrom#','#form.trto#',</cfif>
	    '#form.remark3#', '#form.remark4#','#form.remark5#','#form.remark6#', '#form.remark7#', 
		'#form.remark8#', '#form.remark9#', '#form.remark10#','#form.remark11#',
		'#form.name#','',#nDateNow#, '#HUserID#'<cfif tran eq "TR">,'#form.term#'</cfif>,'#HUserID#',#now()#,'#HUserID#',#now()#,'#form.consignment#'<cfif gettranname.addonremark eq 'Y'>
                ,'#form.remark30#','#form.remark31#','#form.remark32#','#form.remark33#','#form.remark34#'
                    ,'#form.remark35#','#form.remark36#','#form.remark37#','#form.remark38#','#form.remark39#'
                    ,'#form.remark40#'
                    ,'#form.remark41#','#form.remark42#','#form.remark43#','#form.remark44#','#form.remark45#'
                    ,'#form.remark46#','#form.remark47#','#form.remark48#','#form.remark49#'
                </cfif>)
	</cfquery>
</cfif>

<cfif tran eq 'TR'>
	<cfquery name="getictran" datasource="#dts#">
		select * from ictran where refno = '#nexttranno#' and (type = 'TRIN' or type = 'TROU') order by itemcount
	</cfquery>
	
	<cfquery name="getartran" datasource="#dts#">
		select * from artran where refno = '#nexttranno#' and type = "#tran#"
	</cfquery>
<cfelse>
	<cfquery name="getictran" datasource="#dts#">
		select * from ictran where refno = '#nexttranno#' and type = '#tran#' order by itemcount
	</cfquery>
	
	<cfquery name="getartran" datasource="#dts#">
		select currrate,currcode from artran where refno = '#nexttranno#' and type = "#tran#"
	</cfquery>
</cfif>

<cfquery name="getitem" datasource="#dts#">
	select itemno,<cfif lcase(hcomid) eq "vsolutionspteltd_i">concat(aitemno,' ------',desp) as desp<cfelse>desp</cfif>,nonstkitem from icitem where (nonstkitem<>'T' or nonstkitem is null) order by itemno;
</cfquery>

<cfquery datasource="#dts#" name="getbcurr">
	Select bcurr,filteritem,iss_oneset,tr_oneset,oai_oneset,oar_oneset from GSetup
</cfquery>

<body>
<cfoutput>
	<h4>
		<cfif getbcurr.iss_oneset neq '1' and tran eq 'ISS'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelseif getbcurr.tr_oneset neq '1' and tran eq 'TR'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelseif getbcurr.oai_oneset neq '1' and tran eq 'OAI'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelseif getbcurr.oar_oneset neq '1' and tran eq 'OAR'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelse>
			<a href="iss2.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> || 
		</cfif>
		
		<a href="iss.cfm?tran=#tran#">List all #tranname#</a> || 
		<a href="siss.cfm?tran=#tran#">Search For #tranname#</a>
	</h4>

	<table width="85%" align="center" class="data">
		<tr>
			<th width="34%">Next #tranname# No :</th>
			<td width="31%"><strong><font color="##FF0000" size="2" face="Arial, Helvetica, sans-serif">#nexttranno#</font></strong></td>
			<td width="35%">&nbsp;</td>
		</tr>
		
		<tr> 
			<th>#tranname# Date :</th>
			<td><font face="Arial, Helvetica, sans-serif">#invoicedate#</font></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<th>Authorised By :</th>
			<td><font face="Arial, Helvetica, sans-serif">#custno#</font></td>
			<td></td>
		</tr>
		<tr>
			<th>Reason for #tranname# :</th>
			<td colspan="2"><font face="Arial, Helvetica, sans-serif">#name#</font></td>
		</tr>
	</table>
	<br>
    <cfform name="form" action="iss4.cfm?type1=Add&ndatecreate=#ndatecreate#" method="post" onsubmit="return validate()">
		<input type="hidden" name="tran" value="#tran#">	   
        <input type="hidden" name="consignment" value="#consignment#">
		<input type="hidden" name="nexttranno" value="#nexttranno#">
		<input type="hidden" name="custno" value="#custno#">
		<input type="hidden" name="agenno" value="#agenno#">		
		<input type="hidden" name="readperiod" value="#readperiod#">
		<input type="hidden" name="nDateCreate" value="#dateformat(invoicedate,"dd/mm/yyyy")#">
		<input type="hidden" name="nDateNow" value="#dateformat(now(),"dd/mm/yyyy")#">
		<input type="hidden" name="invoicedate" value="#dateformat(invoicedate,"dd/mm/yyyy")#">
		<cfif checkcustom.customcompany eq "Y">
			<input type="hidden" name="remark5" value="#remark5#">	<!--- PERMIT NUMBER, ADD ON 31-03-2009 --->
			<input type="hidden" name="remark6" value="#listfirst(remark6)#">
		</cfif>
		<cfif tran eq 'TR'>
			<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
			<input type="hidden" name="trto" value="#listfirst(trto)#">
			<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
			<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
			<input type="hidden" name="ttran" value="#ttran#">
		</cfif>
		<!--- Add on 260808 --->
		<input type="hidden" name="hmode" value="#listfirst(hmode)#">
		<hr>
		<table width="85%"  align="center" class="data">
			<tr>
				<th width="27%">Item Code</th>
				<td width="73%" nowrap> 
					<cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "pnp_i" or lcase(hcomid) eq "ovas_i">
						<select id="itemno" name='itemno'>
							<option value='-1'>Choose an Item</option>
							<cfloop query='getitem'>
								<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
			           		</cfloop>
			       		</select>
						<cfif getgeneralinfo.filterall eq "1">
								<input type="text" name="searchitemto" onKeyUp="getProduct();" size="10">
						</cfif>
						<input type='submit' name='submit2' value='Add Item'>
                        
                       
					<cfelse>
						<cfif getgeneralinfo.filteritem eq "1">
							<select id="itemno" name='itemno'>
								<option value='-1'>Please Filter The Item</option>
							</select> Filter by:
							<input id="letter" name="letter" type="text" size="8" onKeyup="getItem()"> in:
							<select id="searchtype" name="searchtype" onChange="getItem()">
								<option value="itemno" <cfif gettranname.ddlitem eq 'Item No'>selected</cfif>>Item No</option>
                                <option value="aitemno" <cfif gettranname.ddlitem eq 'Product Code'>selected</cfif>>Product Code</option>
								<option value="desp" <cfif gettranname.ddlitem eq 'Description'>selected</cfif>>Description</option>
								<option value="category" <cfif gettranname.ddlitem eq 'category'>selected</cfif>>Category</option>
								<option value="wos_group" <cfif gettranname.ddlitem eq 'Group'>selected</cfif>>Group</option>
								<option value="brand" <cfif gettranname.ddlitem eq 'brand'>selected</cfif>>Brand</option>
							</select>
							<input type="submit" name="submit2" value="Add Item">
                          
						<cfelse>
							<select name="itemno" id="itemno">
								<option value="">Choose an Item</option>
								<cfloop query="getitem">
									<option value='#convertquote(itemno)#' <cfif isdefined("url.itemno1") and url.itemno1 eq getitem.itemno>selected</cfif>>#itemno# - #desp#</option>
								</cfloop>
							</select>
            <cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
            <input type="text" name="itemnoselect" id="itemselect" value="" onKeyPress="return getselectadd(event)">
			</cfif>
							<input type="submit" name="submit2" value="Add Item">
                          
                        <a  onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.show('searchitem');">AS</a>
							<cfif type eq "Create">
								<a href="issitemsearch.cfm?tran=#tran#&stype=#tran#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&name=#name#&agenno=#agenno#&hmode=#hmode#<cfif tran eq 'TR'>&trfrom=#trfrom#&trto=#trto#&oldtrfrom=#oldtrfrom#&oldtrto=#oldtrto#&ttran=#ttran#</cfif><cfif lcase(hcomid) eq 'thaipore_i' or lcase(hcomid) eq 'jaynbtrading_i' or lcase(hcomid) eq 'lotdemo_i' or lcase(hcomid) eq "laihock_i">&remark5=#URLEncodedFormat(remark5)#&remark6=#URLEncodedFormat(remark6)#</cfif>&consignment=#consignment#<cfif isdefined('form.TRfrom')>&trform=#form.trfrom#</cfif>">SEARCH</a>
							<cfelse>
								<a href="issitemsearch.cfm?tran=#tran#&stype=#tran#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&name=#name#&agenno=#agenno#&hmode=#hmode#<cfif tran eq 'TR'>&trfrom=#trfrom#&trto=#trto#&oldtrfrom=#oldtrfrom#&oldtrto=#oldtrto#&ttran=#ttran#</cfif><cfif lcase(hcomid) eq 'thaipore_i' or lcase(hcomid) eq 'jaynbtrading_i' or lcase(hcomid) eq 'lotdemo_i' or lcase(hcomid) eq "laihock_i">&remark5=#URLEncodedFormat(remark5)#&remark6=#URLEncodedFormat(remark6)#</cfif>&consignment=#consignment#<cfif isdefined('form.TRfrom')>&trform=#form.trfrom#</cfif>">SEARCH</a>
							</cfif>
						</cfif>
					</cfif>		
                    <cfif (lcase(hcomid) eq "aipl_i" or lcase(hcomid) eq "gramas_i") and tran eq 'TR'>
		&nbsp;&nbsp;|&nbsp;&nbsp;<a style="cursor:pointer;" onClick="window.open('aiplimportbody/import_tranexcelTR.cfm?refno=#URLENCODEDFORMAT(nexttranno)#&type=#tran#&consignment=#consignment#','UploadDocument','width=600, height=500, status=yes, menubar=no, location=no, scrollbars=yes')"><b>Import Item TR</b>
        			</a></cfif>			
				</td>
				<!---td width="53%"><input type="submit" name="submit2" value="Add Item">
					<cfif type eq "Create">
						<a href="issitemsearch.cfm?tran=#tran#&stype=#tran#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&name=#name#&agenno=#agenno#<cfif tran eq 'TR'>&trfrom=#trfrom#&trto=#trto#&oldtrfrom=#oldtrfrom#&oldtrto=#oldtrto#&ttran=#ttran#</cfif>">SEARCH</a>
					<cfelse>
						<a href="issitemsearch.cfm?tran=#tran#&stype=#tran#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&name=#name#&agenno=#agenno#<cfif tran eq 'TR'>&trfrom=#trfrom#&trto=#trto#&oldtrfrom=#oldtrfrom#&oldtrto=#oldtrto#&ttran=#ttran#</cfif>">SEARCH</a>
					</cfif>
				</td--->
			</tr>
		</table>
	</cfform>
	<br>
	
	<table width="100%"  align="center" class="data">
		<tr>
        <th align="center">No</th>
			<th align="center">Item Code</th>
            <cfif getdisplaysetup.billbody_aitemno eq 'Y'>
            <th>Product Code</th>
            </cfif>
      		<th align="center">Description</th>
            <cfif getdisplaysetup.billbody_location eq 'Y'>
   			 <th>Location</th>
  			  </cfif>
      		<th align="right">Quantity</th>
            <th>Unit</th>
            <cfif tran eq 'TR'><th align="right">Qty Balance</td> </cfif>
      		<th align="right">Price</td> 
	  		<th align="center">Curr Code</th>
      		<th align="right">Amount</th>
      		<th align="center">Action</th>
    	</tr>
    	<cfset i=1>
		<cfif getictran.recordcount gt 0>
			<cfloop query="getictran"> 
       			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
                	<td><div align="left"><font face="Arial, Helvetica, sans-serif">#i#</font></div></td>
                    <cfset i=i+1>
					<td><div align="left"><font face="Arial, Helvetica, sans-serif">#itemno#</font></div></td>
                    <cfif getdisplaysetup.billbody_aitemno eq 'Y'>
                    <cfquery name="getproductcode" datasource="#dts#">
                    select aitemno from icitem where itemno='#getictran.itemno#'
                    </cfquery>
                    <td>#getproductcode.aitemno#</td>
                    </cfif>
          			<td><div align="left"><font face="Arial, Helvetica, sans-serif">#desp#</font></div></td>
                    <cfif getdisplaysetup.billbody_location eq 'Y'>
                    <td><font face='Arial, Helvetica, sans-serif'>#location#</font></td>
                    </cfif>
          			<td><div align="right"><font face="Arial, Helvetica, sans-serif">#qty#</font></div></td>
                    <cfquery name="getunit" datasource="#dts#">
                    select unit from icitem where itemno='#getictran.itemno#'
                    </cfquery>
                    <td><font face='Arial, Helvetica, sans-serif'><cfif unit eq ''>#getunit.unit#<cfelse>#unit#</cfif></font></td>
                    <cfif tran eq 'TR'>
<cfquery datasource="#dts#" name="getqtybalance">

	select 
	c.balance 
	
	from icitem as a 
	
	left join 
	(
		select 
		location,
		itemno,
		(select desp from iclocation where location=locqdbf.location) as locationdesp 
		from locqdbf
		where itemno=itemno 
		and itemno='#itemno#' 
		and location = <cfif isdefined('form.trfrom')>'#form.trfrom#'<cfelse>'#url.trfrom#'</cfif>
	) as b on a.itemno=b.itemno 
	
	left join 
	(
		select 
		a.location,
		a.itemno,
		(ifnull(a.locqfield,0)+ifnull(b.sum_in,0)-ifnull(c.sum_out,0)) as balance 
		
		from locqdbf as a 
		
		left join
		(
			select 
			location,
			itemno,
			sum(qty) as sum_in 
			
			from ictran
			
			where type in ('RC','CN','OAI','TRIN') 
			and fperiod<>'99'
			and itemno='#itemno#' 
			and location = <cfif isdefined('form.trfrom')>'#form.trfrom#'<cfelse>'#url.trfrom#'</cfif>
			and (void = "" or void is null)
			group by location,itemno
			order by location,itemno
		) as b on a.location=b.location and a.itemno=b.itemno
		
		left join
		(
			select 
			location,
            category,
            wos_group,
			itemno,
			sum(qty) as sum_out 
			
			from ictran 
			
			where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
			and toinv='' 
			and fperiod<>'99'
			and itemno='#itemno#' 
			and location = <cfif isdefined('form.trfrom')>'#form.trfrom#'<cfelse>'#url.trfrom#'</cfif>
            and (void = "" or void is null)
			group by location,itemno
			order by location,itemno
		) as c on a.location=c.location and a.itemno=c.itemno 
		
		where a.itemno=a.itemno
		and a.itemno='#itemno#' 
       
		and a.location = <cfif isdefined('form.trfrom')>'#form.trfrom#'<cfelse>'#url.trfrom#'</cfif>
	) as c on a.itemno=c.itemno and b.location=c.location 
	
	where a.itemno=a.itemno 
	and b.location<>''


	and b.location = <cfif isdefined('form.trfrom')>'#form.trfrom#'<cfelse>'#url.trfrom#'</cfif>

    and a.itemno='#itemno#' 
	order by a.itemno;
</cfquery>
                    
                    
                    <td><div align="right"><font face="Arial, Helvetica, sans-serif">#getqtybalance.balance#</font></div></td>
                    </cfif>
          			<td><div align="right"><font face="Arial, Helvetica, sans-serif">#numberformat(iif(val(getartran.currrate) eq 1,DE(getictran.price_bil),DE(getictran.price)),getgeneralinfo.decl_uprice)#</font></div></td>
          			<td><div align="center"><font face="Arial, Helvetica, sans-serif">#iif(getartran.currcode neq "",DE(getartran.currcode),DE(getbcurr.bcurr))#</font></div></td>
		  			<td><div align="right"><font face="Arial, Helvetica, sans-serif">#numberformat(iif(val(getartran.currrate) eq 1,DE(getictran.amt_bil),DE(getictran.amt)),getgeneralinfo.decl_uprice)#</font></div></td>
          			<td><div align="center"><font face="Arial, Helvetica, sans-serif">
		  					<a href="iss4.cfm?tran=<cfif tran eq "TR">#type#<cfelse>#tran#</cfif>&hmode=#hmode#&type1=Edit&itemno=#urlencodedformat(itemno)#&itemcount=#itemcount#&ndatecreate=#ndatecreate#&nexttranno=#nexttranno#<cfif tran eq 'TR'>&trfrom=#urlencodedformat(getartran.rem1)#&trto=#urlencodedformat(getartran.rem2)#&oldtrfrom=#urlencodedformat(oldtrfrom)#&oldtrto=#urlencodedformat(oldtrto)#</cfif>&consignment=#consignment#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>&nbsp; 
          					<a href="iss4.cfm?tran=<cfif tran eq "TR">#type#<cfelse>#tran#</cfif>&hmode=#hmode#&type1=Delete&itemno=#urlencodedformat(itemno)#&itemcount=#itemcount#&ndatecreate=#ndatecreate#&nexttranno=#nexttranno#<cfif tran eq 'TR'>&trfrom=#urlencodedformat(getartran.rem1)#&trto=#urlencodedformat(getartran.rem2)#&oldtrfrom=#urlencodedformat(oldtrfrom)#&oldtrto=#urlencodedformat(oldtrto)#</cfif>&consignment=#consignment#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
						</font></div>
					</td>
       			</tr>
      		</cfloop>
		</cfif>
	</table>
	
	<hr>
	
	<cfif isdefined ("url.complete") or type eq "Edit">
		<cfform name="invoicesheet" action="iss3b.cfm" method="post">
			<input type="hidden" name="tran" value="#tran#">
            <input type="hidden" name="consignment" value="#consignment#" >	
 			<input type="hidden" name="nexttranno" value="#nexttranno#">
			<input type="hidden" name="type" value="#type#">
			<!--- Add on 260808 --->
			<input type="hidden" name="hmode" value="#listfirst(hmode)#">
			<cfquery name="getartran" datasource="#dts#">
				select * from artran where refno = '#nexttranno#' and type = "#tran#"
			</cfquery>
	
			<cfif tran eq 'TR'>
				<cfquery name="getictran" datasource="#dts#">
					select sum(amt_bil) as subtotal from ictran where refno = '#nexttranno#' and (type = 'TRIN' or type = 'TROU')
				</cfquery>
			<cfelse>
				<cfquery name="getictran" datasource="#dts#">
					select sum(amt_bil) as subtotal from ictran where refno = '#nexttranno#' and type = "#tran#"
				</cfquery>
			</cfif>
	
			<cfif getartran.recordcount gt 0>
				<cfif getartran.disp1 eq "">
					<cfset xdisp1 = 0>		
				<cfelse>
					<cfset xdisp1 = getartran.disp1>
				</cfif>
				
				<cfif getartran.disp2 eq "">
					<cfset xdisp2 = 0>		
				<cfelse>
					<cfset xdisp2 = getartran.disp2>
				</cfif>
				
				<cfif getartran.disp3 eq "">
					<cfset xdisp3 = 0>		
				<cfelse>
					<cfset xdisp3 = getartran.disp3>
				</cfif>
				
				<cfif getartran.taxp1 eq "">
					<cfset xtaxp1 = 0>		
				<cfelse>
					<cfset xtaxp1 = getartran.taxp1>
				</cfif>
				
				<cfif getartran.discount eq "">
					<cfset xamtdisp1 = 0>
				<cfelse>	
					<cfset xamtdisp1 = getartran.disc1_bil>
				</cfif>	
				
				<cfset xnote = getartran.note>
			</cfif>	
  	
			<table width="40%" align="right" border="0">
				<tr> 
					<td>Sub Total</td>
					<td>:</td>
					<td><input name="subtotal" type="text" size="10" maxlength="15" value="#numberformat(getictran.subtotal,".__")#" readonly></td>
				</tr>
				<tr > 
					<td>Discount (%)</td>
					<td>:</td>
					<td nowrap> 
					<cfinput name="totaldisc1" validate="integer" type="text" size="5" maxlength="3" value="#xdisp1#" required="yes" message="Please input a value for Discount(%)(0-100).">
					<font color="##FF0000"><strong>OR</strong></font> &nbsp;Discount ($) : 
					<cfinput name="totalamtdisc" validate="float" type="text" size="10" maxlength="15" value="#xamtdisp1#" required="yes" message="Please input a value for Discount($).">
					</td>
				</tr>
				<tr >
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td><cfinput name="totaldisc2"  validate="float" type="text" size="5" maxlength="5" value="#xdisp2#" required="yes" message="Please input a value for Discount 2(%)(0-100)."></td>
				</tr>
				<tr >
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td><cfinput name="totaldisc3"  validate="float" type="text" size="5" maxlength="5" value="#xdisp3#" required="yes" message="Please input a value for Discount 3(%)(0-100)."></td>
				</tr>
				<tr> 
					<td>Tax (%)</td>
					<td >:</td>
					<td ><cfinput name="totaltax" type="text"  validate="integer"size="5" maxlength="3" value="#xtaxp1#" required="yes" message="Please input a value for Tax."> 
						<!--- REMARK ON 09-10-2009 --->
						<!--- <select name="selecttax">
							<option value="STAX"<cfif xnote eq "STAX">selected</cfif>>STAX</option>
							<option value="ZR"<cfif xnote eq "ZR">selected</cfif>>Zero Rated</option>
							<option value="EX"<cfif xnote eq "EX">selected</cfif>>Exempted</option>
							<option value="OS"<cfif xnote eq "OS">selected</cfif>>Out of Scope</option>
						</select> --->
						<cfquery name="select_tax" datasource="#dts#">
							SELECT * FROM #target_taxtable#
						</cfquery>
						<select name="selecttax" onChange="JavaScript:document.getElementById('totaltax').value=this.options[this.selectedIndex].id;">
			                <cfloop query="select_tax">
			                	<cfset idrate = select_tax.rate1 * 100>
			                	<option value="#select_tax.code#" id="#idrate#" <cfif xnote eq select_tax.code>selected</cfif>>#select_tax.code#</option>
			                </cfloop>
		                </select>
					</td>
				</tr>
				<tr> 
					<td colspan="3" align="left"><input type="submit" name="Submit" value="Accept"><font color="##FF0000"> <--Please Click 'Accept' When You Finished</font></td>
				</tr>
			</table>
		</cfform>
	</cfif>
	
	<br><br><br><br><br><br><br><br><br><br><br><br>
	
	
    <script type="text/javascript">
function selectitem(itemChoose)
{
itemChoose = unescape(itemChoose);

for (var idx=0;idx<document.getElementById('itemno').options.length;idx++) {
        if (itemChoose==document.getElementById('itemno').options[idx].value) {
            document.getElementById('itemno').options[idx].selected=true;
        }
    } 

}
function trim(strval)
{
return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

function checkexpress(addType)
{

var expressservice=trim(document.getElementById('expressservicelist').value);
var desp = trim(document.getElementById('desp').value);

if (addType == "Products")
{
var expressamt = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
}
else
{
var expressamt = trim(document.getElementById('expressamt').value);
}
var intvalid = true;
if (addType == "Products")
{
try
{
expressamt = expressamt * 1;
expprice = expprice * 1;
}
catch(err)
{
intvalid = false;
}
}
var msg = "";

if (expressservice == "")
{
if (addType == "Products")
{
msg = msg + "-Please select a product\n";
}
else
{
msg = msg + "-Please select a service\n";
}
}
if ( desp == "")
{
msg = msg + "-Description field is required\n";
}

if (addType == "Products")
{
if ( expressamt == "" || expressamt <= 0 )
{
msg = msg + "-Quantity field is required\n";
}
if ( expprice == "" || expprice <= 0 )
{
msg = msg + "-Price field is required\n";
}
if (intvalid == false)
{
msg = msg + "-Price or quantity field is invalid\n";
}

else
{
if ( expressamt == "")
{
msg = msg + "-Amount field is required\n";
}
}
}

if (expressservice == "" || desp == "" || expressamt == "" || intvalid == false)
{
alert(msg);
return false;
}

}

function calamt()
{
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
expqty = expqty * 1;
expprice = expprice * 1;
var itemamt = expqty * expprice;
document.getElementById('expressamt').value =  itemamt.toFixed(2);
}

function calamtadvance()
{
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
var expdis = trim(document.getElementById('expdis').value);
expqty = expqty * 1;
expprice = expprice * 1;
expdis = expdis * 1;
var itemamt = (expqty * expprice) - expdis;
document.getElementById('expressamt').value =  itemamt.toFixed(2);
}

function addItem(addType)
{
if (addType == "Services")
{
var validatefield = checkexpress('Services');
}
else
{
var validatefield = checkexpress('Products');
}
if (validatefield == false)
{
}
else
{

var expressservice=trim(document.getElementById('expressservicelist').value);
var desp = encodeURI(trim(document.getElementById('desp').value));
var expressamt = trim(document.getElementById('expressamt').value);
var ajaxurl = '/default/transaction/services/addservicesAjax.cfm?servicecode='+expressservice+'&desp='+desp+'&expressamt='+expressamt+'&tran=#tran#&tranno=#nexttranno#&custno=#custno#';
if (addType == "Services")
{
ajaxFunction(document.getElementById('ajaxFieldSer'),ajaxurl);
}
if (addType == "Products")
{
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
var location = trim(document.getElementById('location').value);
<cfquery name="check_compulsory_location_setting" datasource="#dts#">
	select 
	compulsory_location
	from transaction_menu;
</cfquery>

<cfif check_compulsory_location_setting.compulsory_location eq "Y">
	if(location=="")
	{
		alert("Please Select A Location !");
		document.getElementById("location").focus();
		return false;
	}
</cfif>
var ajaxurl = '/default/transaction/issproducts/addproductsAjax.cfm?servicecode='+expressservice+'&desp='+desp+'&expressamt='+expressamt+'&expqty='+expqty+'&expprice='+expprice+'&tran=#tran#&tranno=#nexttranno#&custno=#custno#&location='+location;
ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
}


clearform(addType);
}

}

function addItemAdvance()
{
var validatefield = checkexpress('Products');

if (validatefield == false)
{
}
else
{
var expressservice=trim(document.getElementById('expressservicelist').value);
var desp = escape(trim(document.getElementById('desp').value));
var expressamt = trim(document.getElementById('expressamt').value);
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
var expcomment = escape(trim(document.getElementById('expcomment').value));
var expunit = trim(document.getElementById('expunit').value);
var expdis = trim(document.getElementById('expdis').value);
var ajaxurl = '/default/transaction/advanceProduct/addproductsAjax.cfm?servicecode='+expressservice+'&desp='+desp+'&expressamt='+expressamt+'&expqty='+expqty+'&expprice='+expprice+'&comment='+expcomment+'&unit='+expunit+'&dis='+expdis+'&tran=#tran#&tranno=#nexttranno#&custno=#custno#';
ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
clearformadvance();
}
}

function clearform(addType)
{
document.getElementById('expressservicelist').selectedIndex = 0;
document.getElementById('desp').value = '';
document.getElementById('expressamt').value = '0.00';
if (addType == "Products")
{
document.getElementById('expqty').value = '0';
document.getElementById('expprice').value = '0.00';
document.getElementById('location').selectedIndex = 0;
}
}

function clearformadvance()
{
document.getElementById('expressservicelist').value = '';
document.getElementById('desp').value = '';
document.getElementById('expressamt').value = '0.00';
document.getElementById('expqty').value = '1';
document.getElementById('expqtycount').value = '1';
document.getElementById('expprice').value = '0.00';
document.getElementById('expunit').value = '';
document.getElementById('expdis').value = '0.00';
document.getElementById('expunitdis').value = '0.00';
document.getElementById('expcomment').value = '';
document.getElementById('expressservicelist').focus();
}

function nextIndex(thisid,id)
{
var itemno = document.getElementById('expressservicelist').value;
if (thisid == 'expressservicelist' && itemno == '')
{
}
else
{
if(event.keyCode==13){
document.getElementById(''+id+'').focus();
document.getElementById(''+id+'').select();
}
}
}

function checkstring(strText)
{
var strReplaceAll = strText;
var intIndexOfMatch = strReplaceAll.indexOf( "%" );
 

// Loop over the string value replacing out each matching
// substring.
while (intIndexOfMatch != -1){
// Relace out the current instance.
strReplaceAll = strReplaceAll.replace( "%", "925925925925" )
 

// Get the index of any next matching substring.
intIndexOfMatch = strReplaceAll.indexOf( "%" );
}
return strReplaceAll;
}
</script>

<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

<script type="text/javascript">
function submitinvoice()
{
document.invoicesheetpost.submit();

}

</script>

</cfoutput>

</body>
</html>

<cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
<script type="text/javascript">
document.getElementById('itemselect').focus();
</script>
</cfif>