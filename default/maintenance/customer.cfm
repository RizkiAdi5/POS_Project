<html>
<head>
	<title>Customer Page</title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	
	<link rel="stylesheet" href="/stylesheet/style.css"/>
	<script type="text/javascript" src="/scripts/prototype.js"></script>
	<script type="text/javascript" src="/scripts/effects.js"></script>
	<script type="text/javascript" src="/scripts/controls.js"></script>
</head>
<cfif Hlinkams eq "Y">
<cfquery name="getgldata" datasource="#dts#">
	select accno,desp,desp2 
	from #replace(dts,'_i','_a','all')#.gldata 
	where accno not in (select custno from arcust order by custno) 
	and accno not in (select custno from apvend order by custno)
	order by accno;
</cfquery>
</cfif>

<cfquery name="showall" datasource="#dts#">
	select 
	* 
	from #target_currency#;
</cfquery>

<cfquery name="getterm" datasource="#dts#">
  	select 
	* 
	from #target_icterm# 
	order by term;
</cfquery>

<cfquery name="getarea" datasource="#dts#">
	select 
	* 
	from icarea 
	order by area;
</cfquery>

<cfquery name="getbusiness" datasource="#dts#">
	select 
	* 
	from business 
	order by business;
</cfquery>

<cfquery name="getcodepatern" datasource="#dts#">
	select 
	debtorfr,
	debtorto,
    countryddl,
    custSuppNo,
    custnamelength,
    ldriver,
    lagent,
    dfcustcode
	from gsetup;
</cfquery>

<cfquery name="getrefno" datasource="#dts#">
	SELECT * FROM refnoset WHERE type = "cust"
</cfquery>

<!--- <cfif getrefno.lastusedno eq "">
<cfset oldlastusedno = 0>
<cfelse>
<cfset oldlastusedno = getrefno.lastusedno>
</cfif>

<cfinvoke component="cfc.refno" method="processNum" oldNum="#oldlastusedno#" returnvariable="newnextNum" />
<cfif getcodepatern.custSuppno eq "1">
<cfset nextcustno = getrefno.refnocode&"/"&newnextNum>
<cfelse>
<cfset nextcustno = getrefno.refnocode&newnextNum>
</cfif> --->

<cfif getrefno.refnoused eq 1 and url.type eq "create">
<cfif getrefno.lastusedno eq "">
<cfset oldlastusedno = 0>
<cfelse>
<cfset oldlastusedno = getrefno.lastusedno>
</cfif>
<cftry>
<cfinvoke component="cfc.refno" method="processNum" oldNum="#oldlastusedno#" returnvariable="newnextNum" />
<cfcatch type="any">
<cfset newnextNum = oldlastusedno>
<cfoutput>
<script type="text/javascript">
alert("Autogenerate customer number fail, please check the last used no whether the entry is correct");
</script>
</cfoutput>
</cfcatch>
</cftry>
<cfif getcodepatern.custSuppno eq "1">
<cfset nextcustno = getrefno.refnocode&"/"&newnextNum>
<cfelse>
<cfset nextcustno = getrefno.refnocode&newnextNum>
</cfif>

</cfif>

<script language="JavaScript">
	function displayrate()
	{
		if(document.CustomerForm.currcode.value !=""){
			<cfoutput query ="showall">
			if(document.CustomerForm.currcode.value == "#showall.currcode#")
			{
				document.CustomerForm.currency.value = "#showall.currency#";
				document.CustomerForm.currency1.value = "#showall.currency1#";
			}		
			</cfoutput>	
		}else{
			document.CustomerForm.currency.value = "";
			document.CustomerForm.currency1.value = "";
		}
	}
	function check_float()
	{
		if(!isNaN(document.getElementById('invLimit').value))
		{
			return true;
		}
		else
		{
			alert("Invoice Limit Must Be A Numeric !");
			document.getElementById('invLimit').focus();
			return false;
		}
	}
	
	function check_compulsoryfield(){
		if(document.CustomerForm.Name.value == ''){
			alert("Company Name cannot be blank !");
			document.getElementById('Name').focus();
			return false;
		}
		else if(document.CustomerForm.Add1.value == ''){
			alert("Address cannot be blank !");
			document.getElementById('Add1').focus();
			return false;
		}
		else if(document.CustomerForm.Attn.value == ''){
			alert("Attention cannot be blank !");
			document.getElementById('Attn').focus();
			return false;
		}
		else if(document.CustomerForm.phone.value == ''){
			alert("Phone cannot be blank !");
			document.getElementById('phone').focus();
			return false;
		}
		else if(document.CustomerForm.Fax.value == ''){
			alert("Fax cannot be blank !");
			document.getElementById('Fax').focus();
			return false;
		}
		else if(document.CustomerForm.agent.value == ''){
			alert("Agent cannot be blank !");
			document.getElementById('agent').focus();
			return false;
		}
		else if(document.CustomerForm.term.value == ''){
			alert("Terms cannot be blank !");
			document.getElementById('term').focus();
			return false;
		}
		else if(document.CustomerForm.crlimit.value == ''){
			alert("Credit Limit cannot be blank !");
			document.getElementById('crlimit').focus();
			return false;
		}
		else
		{
			return true;
		}
	}
	
	function check_field(){
		if(document.CustomerForm.ngst_cust.checked == false){
			if(document.CustomerForm.gstno.value == ''){
				alert("GST No. cannot be blank !");
				document.getElementById('gstno').focus();
				return false;
			}else{
				return true;
			}
		}else{
			return true;
		}
	}
	
	function limitText(limitField, limitNum) {
		if (limitField.value.length > limitNum) {
			limitField.value = limitField.value.substring(0, limitNum);
		} 
	}
	
	function checkSimilar(){
		checkboxObj=document.getElementById("check");
		checkboxObj.checked =false;
	}
	function checkalert()
	{
	if(document.getElementById("nric").value == "1")
	{
	alert('NRIC No. Existed');
	}
	}
</script>

<script language="javascript" type="text/javascript" src="../../scripts/check_customer_code.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

<body>

<cfset mode = isdefined("url.type")>

<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getPersonnel">
		select 
		* 
		from #target_arcust# 
		where custno='#url.custno#';
	</cfquery>
	
	<cfif getPersonnel.recordcount gt 0>
		<cfset edi_id = getPersonnel.edi_id>
		<cfset custno = getPersonnel.custno>
		<cfset name = getPersonnel.name>
		<cfset name2 = getPersonnel.name2>
		<cfset add1 = getPersonnel.add1>
		<cfset add2 = getPersonnel.add2>
		<cfset add3 = getPersonnel.add3>
		<cfset add4 = getPersonnel.add4>
		<cfset attn = getPersonnel.attn>
		<cfset daddr1 = getPersonnel.daddr1>
		<cfset daddr2 = getPersonnel.daddr2>
		<cfset daddr3 = getPersonnel.daddr3>
		<cfset daddr4 = getPersonnel.daddr4>
		<cfset dattn = getPersonnel.dattn>
		<cfset contact = getPersonnel.contact>
		<cfset phone = getPersonnel.phone>
		<cfset phonea = getPersonnel.phonea>
		<cfset fax = getPersonnel.fax>
		<cfset dphone = getPersonnel.dphone>
		<cfset dfax = getPersonnel.dfax>
		<cfset email = getPersonnel.e_mail>
		<cfset website = getPersonnel.web_site>
		<cfset comuen = getPersonnel.comuen>
		<cfset gstno = getPersonnel.gstno>
		<cfset ngst_cust = getPersonnel.ngst_cust>
        <cfset taxincl_cust = getPersonnel.taxincl_cust>
		<cfset country = getPersonnel.country>
		<cfset postalcode = getPersonnel.postalcode>
		<cfset d_country = getPersonnel.d_country>
		<cfset d_postalcode = getPersonnel.d_postalcode>
		<cfset xagent = getPersonnel.agent>
		<cfset xterm = getPersonnel.term>
		<cfset xbusiness = getPersonnel.business>
		<cfset xarea = getPersonnel.area>
		<cfset crlimit = getPersonnel.crlimit>
		<cfset currcode1 = getPersonnel.currcode>
		<cfset currency = getPersonnel.currency>
		<cfset currency1 = getPersonnel.currency1>
		<cfset currency2 = getPersonnel.currency2>
		<cfset status = getPersonnel.status>
		<cfset date = dateformat(getPersonnel.date,'DD-MM-YYYY')>
		<cfset invLimit = getPersonnel.invLimit>
		<cfset dispec_cat = getPersonnel.dispec_cat>
		<cfset dispec1 = getPersonnel.dispec1>
		<cfset dispec2 = getPersonnel.dispec2>
		<cfset dispec3 = getPersonnel.dispec3>
        <cfset SALEC = getPersonnel.SALEC>
        <cfset SALECNC = getPersonnel.SALECNC>
        <cfset normal_rate = getPersonnel.normal_rate>
        <cfset offer_rate = getPersonnel.offer_rate>
        <cfset others_rate = getPersonnel.others_rate>
        <cfset enduserdata = getPersonnel.END_USER>
		<cfset autopay=getPersonnel.autopay>	<!--- ADD ON 26-11-2009 --->
		<cfset groupto=getPersonnel.groupto>	<!--- ADD ON 26-11-2009 --->		
		<cfset arrem1=getPersonnel.arrem1>
		<cfset arrem2=getPersonnel.arrem2>
		<cfset arrem3=getPersonnel.arrem3>
		<cfset arrem4=getPersonnel.arrem4>	  
        <cfif lcase(HcomID) eq "accord_i">
        <cfset arrem5=getPersonnel.arrem5>
		<cfset arrem6=getPersonnel.arrem6>
        </cfif>     
		<cfif lcase(HcomID) eq "taftc_i">
        <cfset arrem5=getPersonnel.arrem5>
		<cfset arrem6=getPersonnel.arrem6>
		<cfset arrem7=getPersonnel.arrem7>
		<cfset arrem8=getPersonnel.arrem8>
        <cfset arrem9=getPersonnel.arrem9>
		<cfset arrem10=getPersonnel.arrem10>
		<cfset arrem11=getPersonnel.arrem11>
		<cfset arrem12=getPersonnel.arrem12>	
        <cfset arrem13=getPersonnel.arrem13>
		<cfset arrem14=getPersonnel.arrem14>
		<cfset arrem15=getPersonnel.arrem15>
		<cfset arrem16=getPersonnel.arrem16>
        		<cfset arrem17=getPersonnel.arrem17>
                        		<cfset arrem18=getPersonnel.arrem18>
        </cfif>
		<cfset mode = "Edit">
		<cfset title = "Edit Customer">
		<cfset button = "Edit">
	<cfelse>
		<cfset status = "Sorry, the Customer, #url.custno# was ALREADY removed from the system. Process unsuccessful.">
		
		<form name="done" action="vpersonnel.cfm?type=Customer&process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		
		<script>
			done.submit();
		</script>
	</cfif>
<cfelseif url.type eq "Create">
	<cfquery datasource="#dts#" name="getcurrcode">
		select 
		a.bcurr,
		b.currency,
		b.currency1 
		from gsetup as a,#target_currency# as b 
		where b.currcode = a.bcurr;
	</cfquery>
	
	<cfif getcurrcode.recordcount neq 0>
		<cfset sgcurrency = getcurrcode.currency>
		<cfset sgcurrency1 = getcurrcode.currency1>
	<cfelse>
		<h3>Please maintain your currency table first. (Default Currency Code is "<cfoutput>#getcurrcode.bcurr#</cfoutput>")</h3>					
		<cfabort>
	</cfif>
	
	<cfset edi_id = "">
	<cfset custno = getcodepatern.dfcustcode>
	<cfset name = "">
	<cfset name2 = "">
	<cfset add1 = "">
	<cfset add2 = "">
	<cfset add3 = "">
	<cfset add4 = "">
	<cfset attn = "">
	<cfset daddr1 = "">
	<cfset daddr2 = "">
	<cfset daddr3 = "">
	<cfset daddr4 = "">
	<cfset dattn = "">
	<cfset contact = "">
	<cfset phone = "">
	<cfset phonea = "">
	<cfset fax = "">
	<cfset dphone = "">
	<cfset dfax = "">
	<cfset email = "">
	<cfset website = "">
	<cfset comuen = "">
	<cfset gstno ="">
	<cfset ngst_cust = "T">
    <cfset taxincl_cust = "">
	<cfset country ="">
	<cfset postalcode ="">
	<cfset d_country = "">
	<cfset d_postalcode = "">
	<cfset xagent = "">
	<cfset xterm = "">
	<cfset xbusiness = "">
	<cfset xarea = "">
	<cfset crlimit="">
	<cfset currcode1 = getcurrcode.bcurr>
	<cfset currency = sgcurrency>
	<cfset currency1 = sgcurrency1>
	<cfset currency2 = "">
	<cfset status = "">
	<cfset date = dateformat(now(),'DD-MM-YYYY')>
	<cfset invLimit = "0.00">
	<cfset dispec_cat = "">
	<cfset dispec1 = "0.00">
	<cfset dispec2 = "0.00">
	<cfset dispec3 = "0.00">
    <cfset SALEC = "">
    <cfset SALECNC = "">
    <cfset normal_rate = "0">
    <cfset offer_rate = "0">
    <cfset others_rate = "0">
    <cfset enduserdata = "">
	<cfset autopay="O">								<!--- ADD ON 26-11-2009 --->
	<cfset groupto=getcodepatern.debtorfr&"/000">	<!--- ADD ON 26-11-2009 --->	
	<cfset arrem1="">
	<cfset arrem2="">
	<cfset arrem3="">
	<cfset arrem4="">
        <cfif lcase(HcomID) eq "accord_i">
            <cfset arrem5="">
	<cfset arrem6="">
        </cfif>
    <cfif lcase(HcomID) eq "taftc_i">
    <cfset arrem5="">
	<cfset arrem6="">
	<cfset arrem7="">
	<cfset arrem8="">
    <cfset arrem9="">
	<cfset arrem10="">
	<cfset arrem11="">
	<cfset arrem12="">
    <cfset arrem13="">
	<cfset arrem14="">
	<cfset arrem15="">
	<cfset arrem16="">
    	<cfset arrem17="">
            	<cfset arrem18="">
    </cfif>
	<cfset mode = "Create">
	<cfset title = "Create Customer">
	<cfset button = "Create">
<cfelseif url.type eq "Delete">
	<cfquery datasource='#dts#' name="getPersonnel">
		select 
		* 
		from #target_arcust# 
		where custno='#url.custno#';
	</cfquery>
	
	<cfif getPersonnel.recordcount gt 0>
		<cfoutput query="getPersonnel">
		    <cfset edi_id = getPersonnel.edi_id>
			<cfset custno = getPersonnel.custno>
			<cfset name = getPersonnel.name>
			<cfset name2 = getPersonnel.name2>
			<cfset add1 = getPersonnel.add1>
			<cfset add2 = getPersonnel.add2>
			<cfset add3 = getPersonnel.add3>
			<cfset add4 = getPersonnel.add4>
			<cfset attn = getPersonnel.attn>
			<cfset daddr1 = getPersonnel.daddr1>
			<cfset daddr2 = getPersonnel.daddr2>
			<cfset daddr3 = getPersonnel.daddr3>
			<cfset daddr4 = getPersonnel.daddr4>
			<cfset dattn = getPersonnel.dattn>
			<cfset contact = getPersonnel.contact>
			<cfset phone = getPersonnel.phone>
			<cfset phonea = getPersonnel.phonea>
			<cfset fax = getPersonnel.fax>
			<cfset dphone = getPersonnel.dphone>
			<cfset dfax = getPersonnel.dfax>
			<cfset email = getPersonnel.e_mail>
			<cfset website = getPersonnel.web_site>
			<cfset comuen = getPersonnel.comuen>
			<cfset gstno = getPersonnel.gstno>
			<cfset ngst_cust = getPersonnel.ngst_cust>
            <cfset taxincl_cust = getPersonnel.taxincl_cust>
			<cfset country = getPersonnel.country>
			<cfset postalcode = getPersonnel.postalcode>
			<cfset d_country = getPersonnel.d_country>
			<cfset d_postalcode = getPersonnel.d_postalcode>
			<cfset xagent = getPersonnel.agent>
			<cfset xterm = getPersonnel.term>
			<cfset xbusiness = getPersonnel.business>
			<cfset xarea = getPersonnel.area>
			<cfset crlimit = getPersonnel.crlimit>
			<cfset currcode1 = getPersonnel.currcode>
			<cfset currency = getPersonnel.currency>
			<cfset currency1 = getPersonnel.currency1>
			<cfset currency2 = getPersonnel.currency2>
			<cfset status = getPersonnel.status>
			<cfset date = dateformat(getPersonnel.date,'DD-MM-YYYY')>
			<cfset invLimit = getPersonnel.invLimit>
			<cfset dispec_cat = getPersonnel.dispec_cat>
			<cfset dispec1 = getPersonnel.dispec1>
			<cfset dispec2 = getPersonnel.dispec2>
			<cfset dispec3 = getPersonnel.dispec3>
            <cfset SALEC = getPersonnel.SALEC>
            <cfset SALECNC = getPersonnel.SALECNC>
            <cfset normal_rate = getPersonnel.normal_rate>
        	<cfset offer_rate = getPersonnel.offer_rate>
        	<cfset others_rate = getPersonnel.others_rate>
			<cfset enduserdata = getPersonnel.END_USER>
			<cfset autopay=getPersonnel.autopay>	<!--- ADD ON 26-11-2009 --->
			<cfset groupto=getPersonnel.groupto>	<!--- ADD ON 26-11-2009 --->	
			<cfset arrem1=getPersonnel.arrem1>
			<cfset arrem2=getPersonnel.arrem2>
			<cfset arrem3=getPersonnel.arrem3>
			<cfset arrem4=getPersonnel.arrem4>
            			<cfif lcase(HcomID) eq "accord_i">
                                    <cfset arrem5=getPersonnel.arrem5>
            <cfset arrem6=getPersonnel.arrem6>
                        </cfif>
			<cfif lcase(HcomID) eq "taftc_i">
            <cfset arrem5=getPersonnel.arrem5>
            <cfset arrem6=getPersonnel.arrem6>
            <cfset arrem7=getPersonnel.arrem7>
            <cfset arrem8=getPersonnel.arrem8>
            <cfset arrem9=getPersonnel.arrem9>
            <cfset arrem10=getPersonnel.arrem10>
            <cfset arrem11=getPersonnel.arrem11>
            <cfset arrem12=getPersonnel.arrem12>	
            <cfset arrem13=getPersonnel.arrem13>
            <cfset arrem14=getPersonnel.arrem14>
            <cfset arrem15=getPersonnel.arrem15>
            <cfset arrem16=getPersonnel.arrem16>
                        <cfset arrem17=getPersonnel.arrem17>
                              <cfset arrem18=getPersonnel.arrem18>
            </cfif>
			<cfset mode = "Delete">
			<cfset title = "Delete Customer">
			<cfset button = "Delete">
		</cfoutput>
	<cfelse>
		<cfset status = "Sorry, the Customer, #url.custno# was ALREADY removed from the system. Process unsuccessful. Please refresh your webpage.">
		
		<form name="done" action="vpersonnel.cfm?type=Customer&process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		
		<script>
			done.submit();
		</script>
	</cfif>
</cfif>

<cfoutput>
	<cfif husergrpid eq "Muser">
		<a href="../home2.cfm"><u>Home</u></a>
	</cfif>
	
	<h1>#title#</h1>
	<h4>
	<cfif getpin2.h1210 eq 'T'>
		<a href="Customer.cfm?type=Create"> Creating a New Customer</a> 
	</cfif>
	<cfif getpin2.h1220 eq 'T'>
		|| <a href="vPersonnel.cfm?type=Customer">List all Customer</a> 
	</cfif>
	<cfif getpin2.h1230 eq 'T'>
		|| <a href="linkPage.cfm?type=Customer">Search Customer</a> 
	</cfif>
	<cfif getpin2.h1240 eq 'T'>
		|| <a href="p_suppcust.cfm?type=Customer">Customer Listing</a>
	</cfif>
	</h4>
</cfoutput>

<cfoutput>
  	<form name="CustomerForm" action="CustomerProcess.cfm" method="post" 
  	<cfif url.type eq "Create" and lcase(HcomID) neq "glenn_i" and lcase(HcomID) neq "glenndemo_i">
		<cfif lcase(HcomID) eq "mhsl_i" or lcase(HcomID) eq "mpt_i" or lcase(HcomID) eq "mhca_i">
			onSubmit="javascript:releaseDirtyFlag();if(validate('#getcodepatern.debtorfr#','#getcodepatern.debtorto#','#getcodepatern.custSuppNo#')&&check_float()&&check_compulsoryfield()&&check_field()){return true;}else{return false;}"
		<cfelseif lcase(hcomid) eq "nikbra_i">
			onSubmit="javascript:releaseDirtyFlag();if(check_float()&&check_field()){return true;}else{return false;}"
            <cfelseif lcase(hcomid) eq "hl_i">
		<cfelse>
			onSubmit="javascript:releaseDirtyFlag();if(validate('#getcodepatern.debtorfr#','#getcodepatern.debtorto#','#getcodepatern.custSuppNo#')&&check_float()&&check_field()){return true;}else{return false;}"
		</cfif>
	<cfelseif (url.type eq "Edit") or (url.type eq "Create" and (lcase(HcomID) eq "glenn_i" or lcase(HcomID) eq "glenndemo_i"))>
    <cfif lcase(hcomid) neq "hl_i">
		onSubmit="javascript:releaseDirtyFlag();if(check_float()&&check_field()){return true;}else{return false;}"
    <cfelse>
    onSubmit="javascript:releaseDirtyFlag();"
	</cfif>
    <cfelse>
    onSubmit="javascript:releaseDirtyFlag();"
	</cfif>
	>
  	<input type="hidden" name="mode" value="#mode#">
  	<input type="hidden" name="target_table" value="arcust">
  	
	<table align="center" class="data" width="660px">
  		<tr>
    		<th>Customer No :</th>
    		<td>
    			<cfif mode eq "Delete" or mode eq "Edit">
        			<input type="text" size="15" name="custno" value="#custno#" readonly>
        			<input type="hidden" name="edi_id" value="#edi_id#">
        		<cfelse>
        			<input type="text" size="40" name="custno" value="<cfif getrefno.refnoused eq 1>#nextcustno#<cfelse>#custno#</cfif>" maxlength="8"><input type="hidden" name="nexcustno" id="nexcustno" value="#getcodepatern.custSuppNo#" >					<div id="hint" class="autocomplete"></div>
	                <script type="text/javascript">
						var url = "/ajax/functions/getRecord.cfm?custtype=customer";
							
						new Ajax.Autocompleter("custno","hint",url,{afterUpdateElement : getSelectedId});
							
						function getSelectedId(text, li) {
							$('custno').value=li.id;
						}
					</script>
      			</cfif>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT type=checkbox value='O' name="autopay" <cfif autopay eq "O">checked</cfif>>Open Item Customer
    		</td>
  		</tr>
  		<tr>
    		<th>
				<cfif lcase(HcomID) eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">
        			Customer Name :
            	<cfelse>
            		Company Name :
      			</cfif>
      		</th>
    		<td><input type="text" size="40" name="Name" id="Name" value="#Name#" maxlength="40">
				<cfif mode eq "Create">
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="check" value="Y" onClick="checkSimilar();ajaxFunction(document.getElementById('ajaxField1'),'/default/maintenance/ajaxAction.cfm?dfunction=checkSimilarCustomer&name='+document.getElementById('Name').value);">Check Similar
					<div id="ajaxField1" name="ajaxField1">
					</div>
				</cfif>
			</td>
  		</tr>
  		<tr>
  			<td></td>
    		<td><input type="text" size="40" name="Name2" id="Name2" value="#Name2#" maxlength="40"></td>
  		</tr>
        <cfif lcase(HcomID) neq "taftc_i" and lcase(HcomID) neq "accord_i">
        <cfif getcodepatern.custnamelength eq "Y">
        <tr>
        <td></td>
        <td><input type="text" size="40" name="arrem3" id="arrem3" value="#arrem3#" maxlength="35"></td>
        </tr>
        <tr>
        <td></td>
        <td><input type="text" size="40" name="arrem4" id="arrem4" value="#arrem4#" maxlength="35"></td>
        </tr>
        
        </cfif>
        </cfif>
		<tr>
		   	<th>Company UEN :</th>
		    <td><input type="text" size="40" name="comuen" id="comuen" value="#comuen#" maxlength="50"></td>
		</tr>
		<tr>
		   	<th>Gst No. :</th>
		    <td><input type="text" size="40" name="gstno" id="gstno" value="#gstno#" maxlength="50"></td>
		</tr>
		<tr>
		   	<th>Non GST Customer :</th>
		    <td><input type="checkbox" name="ngst_cust" id="ngst_cust" value="#ngst_cust#" <cfif ngst_cust eq "T">checked</cfif>></td>
		</tr>
        <tr>
		   	<th>Tax Included :</th>
		    <td><input type="checkbox" name="taxincl_cust" id="taxincl_cust" value="#taxincl_cust#" <cfif taxincl_cust eq "T">checked</cfif>></td>
		</tr>
		<tr>
		   	<th>Group To :</th>
		    <td><input name="groupto" type="text" maxlength="12" value="#groupto#" size="15"></td>
		</tr>
		<tr><td colspan="100%"><hr></td></tr>
  		<tr>
    		<th>Address :</th>
    		<td><input type="text" size="40" name="Add1" id="Add1" value="#Add1#" maxlength="35" ></td>
  		</tr>
  		<tr>
    		<td></td>
    		<td><input type="text" size="40" name="Add2" id="Add2"  value="#Add2#" maxlength="35" ></td>
  		</tr>
  		<tr>
    		<td></td>
    		<td><input type="text" size="40" name="Add3" id="Add3"  value="#Add3#" maxlength="35" ></td>
  		</tr>
  		<tr>
    		<td></td>
    		<td><input type="text" size="40" name="Add4" id="Add4"  value="#Add4#" maxlength="35" ></td>
  		</tr>
         <cfif getcodepatern.countryddl eq 'Y'>
         		<tr>
		    <th>Country :</th>
        <td>
        <cfquery name="getcountrylist" datasource="#dts#">
        SELECT * FROM droplistcountry
        </cfquery>
               <select class="" id="country" name="country">
               <cfif isdefined('getPersonnel.country')>
			   
			   <cfif getPersonnel.country eq "">
               <cfset selectedcountry = "Singapore">
			   <cfelse>
               <cfset selectedcountry = getPersonnel.country>
               </cfif>
             	<cfelse>
                <cfset selectedcountry = "Singapore">
               </cfif>
                    <cfloop query =getcountrylist>
                    <option value="#getcountrylist.country#" <cfif selectedcountry eq getcountrylist.country>selected</cfif>>#getcountrylist.country#</option>
                    </cfloop>
               </select>
</td>
		</tr>
        <cfelse> 
		<tr>
		    <th>Country :</th>
		    <td><input type="text" size="40" name="country" id="country" value="#country#" maxlength="50"></td>
		</tr>
        </cfif>
		<tr>
		    <th>Postal Code :</th>
		    <td><input type="text" size="40" name="postalcode" id="postalcode" value="#postalcode#" maxlength="50"></td>
		</tr>
		<cfif lcase(HcomID) eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">
	  		<tr>
	   			<th><cfif lcase(HcomID) eq "taftc_i">Attn. :<cfelse>I.C no. :</cfif></th>
	    		<td><input type="text" size="40" name="Attn" id="Attn"  value="#attn#" maxlength="35"></td>
	  		</tr>
	  		<tr>
		    	<th>Forum Id :</th>
		    	<td><input type="text" size="40" name="DAddr1" id="DAddr1" value="#DAddr1#" maxlength="40"></td>
		  	</tr>
		  	<tr>
		      	<th>Product key :</th>
		      	<td><input type="password" size="40" name="DAddr2" id="DAddr2"  value="#DAddr2#" maxlength="35"></td>
		  	</tr>
		  	<tr>
			  	<th>Activation Date (dd-mm-yyyy) :</th>
				<td><input type="text" size="40" name="DAddr3" id="DAddr3"  value="#DAddr3#" maxlength="35"></td>
		  	</tr>
		  	<tr>
		    	<td></td>
		    	<td><input type="text" size="40" name="DAddr4" id="DAddr4"  value="#DAddr4#" maxlength="35"></td>
		  	</tr>
		  	<tr>
		    	<th>Expiry Date (dd-mm-yyyy) :</th>
		    	<td><input type="text" size="40" name="DAttn" id="DAttn"  value="#dattn#" maxlength="35"></td>
		  	</tr>
		  	<tr>
		    	<th>Sex :</th>
		    	<td><input type="text" size="40" name="contact" id="contact"  value="#contact#"  maxlength="15"></td>
		  	</tr>
		  	<tr>
		    	<th>Phone :</th>
		    	<td><input type="text" size="40" name="phone" id="phone" value="#phone#" maxlength="25"></td>
		  	</tr>
		  	<tr>
		    	<th>Mobile :</th>
		    	<td><input type="text" size="40" name="phonea" id="phonea" value="#phonea#" maxlength="25"></td>
		  	</tr>
		  	<tr>
		    	<th>Fax :</th>
		    	<td><input type="text" size="40" name="Fax" id="Fax" value="#Fax#" maxlength="25"></td>
		  	</tr>
		  	<tr>
		    	<th>Email :</th>
		    	<td><input type="text" size="60" name="e_mail" id="e_mail" value="#email#" maxlength="90"></td>
		  	</tr>
		  	<tr>
		    	<th>Date Of Intake (dd-mm-yyyy) :</th>
		    	<td><input type="text" size="40" name="web_site" id="web_site" value="#website#" maxlength="50"></td>
		  	</tr>
		  	<input type="hidden" name="dphone" id="dphone" value="#dphone#">
		  	<input type="hidden" name="dfax" id="dfax" value="#dfax#">
		  	<input type="hidden" name="d_country" id="d_country" value="#d_country#">
		  	<input type="hidden" name="d_postalcode" id="d_postalcode" value="#d_postalcode#">
		<cfelse>
	  		<tr>
	   			<th>Attention :</th>
	    		<td><input type="text" size="40" name="Attn" id="Attn"  value="#attn#" maxlength="35" ></td>
	  		</tr>
		  	<tr>
		    	<th>Phone :</th>
		    	<td><input type="text" size="40" name="phone" id="phone" value="#phone#" maxlength="25" ></td>
		  	</tr>
		  	<tr>
		    	<th><cfif lcase(HcomID) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i">HP<cfelse>Phone 2</cfif> :</th>
		    	<td><input type="text" size="40" name="phonea" id="phonea" value="#phonea#" maxlength="25"></td>
		  	</tr>
		  	<tr>
		    	<th>Fax :</th>
		    	<td><input type="text" size="40" name="Fax" id="Fax" value="#Fax#" maxlength="25"></td>
		  	</tr>
	  		<tr>
		    	<th>Delivery Address : <input type="button" name="btn_copy" id="btn_copy" value="Copy Address" onClick=
                "document.getElementById('DAddr1').value = document.getElementById('Add1').value;
                document.getElementById('DAddr2').value = document.getElementById('Add2').value;
                document.getElementById('DAddr3').value = document.getElementById('Add3').value;
                document.getElementById('DAddr4').value = document.getElementById('Add4').value;
                <cfif getcodepatern.countryddl eq 'Y'>
                document.getElementById('d_country').options[document.getElementById('country').selectedIndex].selected = true;
				<cfelse>
                document.getElementById('d_country').value = document.getElementById('country').value;
				</cfif>
                document.getElementById('d_postalcode').value = document.getElementById('postalcode').value;
                document.getElementById('DAttn').value = document.getElementById('Attn').value;
                document.getElementById('dphone').value = document.getElementById('phone').value;
                document.getElementById('dfax').value = document.getElementById('fax').value;                
                " /></th>
		    	<td><input type="text" size="40" name="DAddr1" id="DAddr1" value="#DAddr1#" maxlength="40"></td>
		  	</tr>
		  	<tr>
			  	<td></td>
		      	<td><input type="text" size="40" name="DAddr2" id="DAddr2"  value="#DAddr2#" maxlength="35"></td>
		  	</tr>
		  	<tr>
			  	<td></td>
				<td><input type="text" size="40" name="DAddr3" id="DAddr3"  value="#DAddr3#" maxlength="35"></td>
		  	</tr>
		  	<tr>
		    	<td></td>
		    	<td><input type="text" size="40" name="DAddr4" id="DAddr4"  value="#DAddr4#" maxlength="35"></td>
		  	</tr>
            <cfif getcodepatern.countryddl eq 'Y'>
         		<tr>
		    <th>Delivery Country :</th>
        <td>
			<cfset singapore = "Singapore">
               <select class="" id="d_country" name="d_country">
               <cfif isdefined('getPersonnel.d_country')>
			   <cfif getPersonnel.d_country eq "">
               <cfset selectedcountry = "Singapore">
			   <cfelse>
               <cfset selectedcountry = getPersonnel.d_country>
               </cfif>
             	<cfelse>
                <cfset selectedcountry = "Singapore">
               </cfif>
                    <cfloop query =getcountrylist>
                    <option value="#getcountrylist.country#" <cfif selectedcountry eq getcountrylist.country>selected</cfif>>#getcountrylist.country#</option>
                    </cfloop>
               </select>
		</td>
		</tr>
        <cfelse>
			<tr>
			    <th>Delivery Country :</th>
			    <td><input type="text" size="40" name="d_country" id="d_country" value="#d_country#" maxlength="50"></td>
			</tr>
            </cfif>
			<tr>
			    <th>Delivery Postal Code :</th>
			    <td><input type="text" size="40" name="d_postalcode" id="d_postalcode" value="#d_postalcode#" maxlength="50"></td>
			</tr>
		  	<tr>
		    	<th>Delivery Attention :</th>
		    	<td><input type="text" size="40" name="DAttn" id="DAttn"  value="#dattn#" maxlength="35"></td>
		  	</tr>
		  	<tr>
		    	<th>Delivery Phone :</th>
		    	<td><input type="text" size="40" name="dphone" id="dphone" value="#dphone#" maxlength="25"></td>
		  	</tr>
		  	<tr>
		    	<th>Delivery Fax :</th>
		    	<td><input type="text" size="40" name="dfax" id="dfax" value="#dfax#" maxlength="25"></td>
		  	</tr>
		  	<tr>
		    	<th><cfif lcase(HcomID) eq "varz_i">REP<cfelse>Contact</cfif> :</th>
		    	<td><input type="text" size="40" name="contact" id="contact"  value="#contact#"  maxlength="35"></td>
		  	</tr>
		  	<tr>
		    	<th>Email :</th>
		    	<td><input type="text" size="60" name="e_mail" id="e_mail" value="#email#" maxlength="90"></td>
		  	</tr>
		  	<tr>
		    	<th>Web Site :</th>
		    	<td><input type="text" size="40" name="web_site" id="web_site" value="#website#" maxlength="50"></td>
		  	</tr>
		</cfif>
</cfoutput>
	<tr><td colspan="100%"><hr></td></tr>
	<cfquery name="getEndUser" datasource="#dts#">
    select * from driver order by driverno
    </cfquery>
    <tr>
    <th><cfoutput>#getcodepatern.ldriver# :</cfoutput></th>
    <td>
    <select name="enduser" id="enduser">
    <option value="">Choose an <cfoutput>#getcodepatern.ldriver#</cfoutput></option>
    <cfoutput query="getEndUser">
    <option value="#getEndUser.DRIVERNO#" <cfif enduserdata eq getEndUser.DRIVERNO>selected </cfif> >#getEndUser.DRIVERNO# - #getEndUser.Name#</option>
	</cfoutput>
    </select><!--- &nbsp;<cfif getpin2.h1C10 eq 'T'><br /><a href="driver.cfm?type=Create" target="_blank">Create New End User</a></cfif> --->
    </td>
    </tr>
    <cfquery name="getagent" datasource="#dts#">
		select 
		agent 
		from icagent;
	</cfquery>
	<tr>
		<th><cfoutput>#getcodepatern.lagent# :</cfoutput></th>
		<td>
			<select name="agent" id="agent">
				<option value="">Choose an <cfoutput>#getcodepatern.lagent#</cfoutput></option>
				<cfoutput query="getagent">
					<option value="#getagent.agent#"<cfif xagent eq "#getagent.agent#">selected</cfif>>#getagent.agent#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<th>Terms :</th>
		<td><select name="term" id="term">
				<option value="">Choose a Terms</option>
				<cfoutput query="getterm">
					<option value="#getterm.term#"<cfif xterm eq getterm.term>Selected</cfif>>#getterm.term#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<th>Area :</th>
		<td><select name="area" id="area">
				<option value="">Choose a Area</option>
				<cfoutput query="getarea">
					<option value="#getarea.area#"<cfif xarea eq getarea.area>Selected</cfif>>#getarea.area#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<th>Business :</th>
		<td><select name="business" id="business">
				<option value="">Choose a Business</option>
				<cfoutput query="getbusiness">
					<option value="#getbusiness.business#"<cfif xbusiness eq getbusiness.business>Selected</cfif>>#getbusiness.business# - #getbusiness.desp#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	
	<cfoutput>
	<tr>
		<th>Credit Limit :</th>
		<td><input type="text" size="40" name="crlimit" id="crlimit" value="#crlimit#" maxlength="19"></td>
	</tr>
	</cfoutput>
	
	<tr>
		<th>Currency Code : <cfoutput>#currcode1#</cfoutput></th>
		<td>
			<select name="currcode" id="currcode" onChange="javascript:displayrate()">
				<!--- REMARK ON 300508, ALL THE CURRENCY WILL RETRIEVE FROM DATABASE --->
				<!---option value="SGD">SGD - S$</option--->	
				<option value="">Choose a Currency</option>							
				<cfoutput query="showall"> 
					<option value="#showall.CurrCode#" <cfif showall.currcode eq '#currcode1#'>selected</cfif>>#showall.currcode# - #showall.Currency#</option>
				</cfoutput> 
			</select>
		</td>
	</tr>
	
	<cfoutput>
		<tr>
			<th>Currency:</th>
			<td><input type="text" size="40" name="currency" id="currency" value="#currency#" maxlength="10"></td>
		</tr>
		<tr>
			<th>Currency Dollar :</th>
			<td><input type="text" size="40" name="currency1" id="currency1" value="#currency1#" maxlength="17"></td>
		</tr>
		<tr>
			<th>Currency Dollar 2 :</th>
			<td><input type="text" size="40" name="currency2" id="currency2" value="#currency2#" maxlength="17"></td>
		</tr>
		<tr>
			<th>Bad Status :</th>
			<td><input type="checkbox" name="status" id="status" value="B" <cfif status eq "B">checked</cfif>></td>
		</tr>
		<tr>
			<th>Date <cfif lcase(HcomID) eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">of Birth (dd-mm-yyyy)</cfif> :</th>
			<td>
				<cfif lcase(HcomID) eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">
					<input type="text" size="40" name="date" id="date" value="#date#">
				<cfelse>
					<input type="text" size="40" name="date" id="date" value="#date#" readonly>
				</cfif>
			</td>
		</tr>
		<tr>
			<th>Invoice Limit :</th>
			<td><input type="text" size="40" name="invLimit" id="invLimit" value="#invLimit#" maxlength="19"></td>
		</tr>
		<tr>
			<th>Discount Percentage Category :</th>
			<td><input type="text" size="40" name="dispec_cat" id="dispec_cat" value="#dispec_cat#" maxlength="1"></td>
		</tr>
		<tr>
			<th>Discount Percentage Level 1 :</th>
			<td><input type="text" size="40" name="dispec1" id="dispec1" value="#dispec1#" validate="float" maxlength="5"></td>
		</tr>
		<tr>
			<th>Discount Percentage Level 2 :</th>
			<td><input type="text" size="40" name="dispec2" id="dispec2" value="#dispec2#" maxlength="5"></td>
		</tr>
		<tr>
			<th>Discount Percentage Level 3 :</th>
			<td><input type="text" size="40" name="dispec3" id="dispec3" value="#dispec3#" maxlength="5"></td>
		</tr>
        
        <cfif Hlinkams eq "Y">
        
        <tr> 
		  			<th>Credit Sales Code:</th>
		  			<td>
						<select name="SALEC">
							<option value="" #iif((SALEC eq "" or SALEC eq ""),DE("selected"),DE(""))#>Please Select an account no</option>
							<cfloop query="getgldata">
								<option value="#getgldata.accno#" #iif((SALEC eq getgldata.accno),DE("selected"),DE(""))#>#getgldata.accno# - #getgldata.desp# - #getgldata.desp2#</option>
							</cfloop>
						</select>
					</td>
				</tr>
                
                 <tr> 
		  			<th>Sales Return Code:</th>
		  			<td>
						<select name="SALECNC">
							<option value="" #iif((SALECNC eq "" or SALECNC eq ""),DE("selected"),DE(""))#>Please Select an account no</option>
							<cfloop query="getgldata">
								<option value="#getgldata.accno#" #iif((SALECNC eq getgldata.accno),DE("selected"),DE(""))#>#getgldata.accno# - #getgldata.desp# - #getgldata.desp2#</option>
							</cfloop>
						</select>
					</td>
				</tr>
        
        <cfelse>
        <tr>
			<th>Credit Sales Code:</th>
			<td><input type="text" size="40" name="SALEC" id="SALEC" value="#SALEC#" mask="1111/111" maxlength="7"></td>
		</tr>
        
        <tr>
			<th>Sales Return Code:</th>
			<td><input type="text" size="40" name="SALECNC" id="SALECNC" value="#SALECNC#" mask="1111/111" maxlength="7"></td>
		</tr>
        </cfif>
        <tr>
			<th>Normal Rate:</th>
			<td><input type="text" size="40" name="normal_rate" id="normal_rate" value="#normal_rate#" maxlength="2"></td>
		</tr>
        
        <tr>
			<th>Offer Rate:</th>
			<td><input type="text" size="40" name="offer_rate" id="offer_rate" value="#offer_rate#" maxlength="2"></td>
		</tr>
        
        <tr>
			<th>Others Rate:</th>
			<td><input type="text" size="40" name="others_rate" id="others_rate" value="#others_rate#" maxlength="2"></td>
		</tr>
		<tr>
			<th><cfif lcase(HcomID) eq "solidlogic_i">Rebate Percent (%)<cfelseif lcase(HcomID) eq "taftc_i">Contact Person :<cfelseif lcase(HcomID) eq "accord_i">Customer IC :<cfelseif lcase(HcomID) eq "varz_i">Ship Date<cfelse>Remark 1</cfif> :</th>
			<td>
				<cfif lcase(HcomID) eq "ugateway_i">
					<select name="arrem1" id="arrem1">
						<option value="">Please select a customer type</option>
						<option value="Salon Owner" <cfif arrem1 eq "Salon Owner">selected</cfif>>Salon Owner</option>
						<option value="End User" <cfif arrem1 eq "End User">selected</cfif>>End User</option>
					</select>
				<cfelse>
					<input type="text" size="40" name="arrem1" id="arrem1" value="#arrem1#" maxlength="35">
				</cfif>
			</td>
		</tr>
		<tr>
			<th><cfif lcase(HcomID) eq "taftc_i">Tel :<cfelseif lcase(HcomID) eq "accord_i">Gender :<cfelseif lcase(HcomID) eq "bestform_i" or lcase(HcomID) eq "ulp_i">Last Quotation Ref No :<cfelseif lcase(HcomID) eq "varz_i">Ship Via<cfelse>Remark 2 :</cfif></th>
			<td><cfif lcase(HcomID) eq "accord_i">
			<cfif #arrem2# eq "female">
<select name="arrem2" id="arrem2">
<option value="female">Female</option>
<option value="male">Male</option>
</select>
<cfelse>
<select name="arrem2" id="arrem2">
<option value="male">Male</option>
<option value="female">Female</option>
</select>
</cfif>
			<cfelse><input type="text" size="40" name="arrem2" id="arrem2" value="#arrem2#" maxlength="35"></cfif></td>
		</tr>
		<tr>
			<th><cfif lcase(HcomID) eq "taftc_i">Company :<cfelseif lcase(HcomID) eq "accord_i">Martial Status :<cfelseif lcase(HcomID) eq "bestform_i" or lcase(HcomID) eq "ulp_i">Last Sales Order Ref No :<cfelseif lcase(HcomID) eq "varz_i">Ship Terms<cfelse><cfif getcodepatern.custnamelength neq "Y">Remark 3 :</cfif></cfif></th>
			<td><cfif lcase(HcomID) eq "accord_i"><cfif #arrem3# eq "single">
<select name="arrem3" id="arrem3">
<option value="single">Single</option>
<option value="married">Married</option>
<option value="others">Others</option>
</select>
<cfelseif #arrem3# eq "others">
<select name="arrem3" id="arrem3">
<option value="others">Others</option>
<option value="married">Married</option>
<option value="single">Single</option>
</select>
<cfelse>
<select name="arrem3" id="arrem3">
<option value="married">Married</option>
<option value="others">Others</option>
<option value="single">Single</option>
</select>
</cfif><cfelse><cfif getcodepatern.custnamelength neq "Y"><input type="text" size="40" name="arrem3" id="arrem3" value="#arrem3#" maxlength="35"></cfif></cfif></td>
		</tr>
		<tr>
			<th><cfif lcase(HcomID) eq "taftc_i">Company Address :<cfelseif lcase(HcomID) eq "accord_i">License Date :<cfelseif lcase(HcomID) eq "bestform_i" or lcase(HcomID) eq "ulp_i">Last Invoice Ref No :<cfelseif lcase(HcomID) eq "varz_i">Expected<cfelse><cfif getcodepatern.custnamelength neq "Y">Remark 4 :</cfif></cfif></th>
			<td>
				<cfif lcase(HcomID) eq "zeadine09_i">
					<textarea name="arrem4" id="arrem4" cols='40' rows='3' onKeyDown="limitText(this.form.arrem4,1000);" onKeyUp="limitText(this.form.arrem4,1000);">#arrem4#</textarea>
                <cfelseif lcase(HcomID) eq "taftc_i">
                <textarea name="arrem4" id="arrem4" cols='40' rows='3'>#arrem4#</textarea>
                <cfelseif lcase(HcomID) eq "accord_i">
                <cfif isdate(arrem4)>
                      <cfelse>
                <cfset arrem4 = "1990-01-01">
                </cfif>
				 <select name="day2" id="day2">
                <cfloop from="1" to="31" index="i">
                <option value="#i#" <cfif dateformat(arrem4,'dd') eq i>Selected</cfif>>#i#</option>
                </cfloop>
                </select>
                <select name="month2" id="month2">
                <cfloop from="1" to="12" index="i">
                <cfset datecrete = createdate('2010',i,'1')>
                <option value="#i#" <cfif dateformat(arrem4,'mm') eq i>Selected</cfif>>#ucase(dateformat(datecrete,'mmmm'))#</option>
                </cfloop>
                </select>
                <select name="year2" id="year2">
                  <cfloop from="1930" to="2020" index="i">
                    <option value="#i#" <cfif dateformat(arrem4,'yyyy') eq i>Selected</cfif>>#i#</option>
                  </cfloop>
                </select>
                <input type="hidden" size="40" name="arrem4" id="arrem4" value="#arrem4#" maxlength="35">
            
				<cfelse>
					<cfif getcodepatern.custnamelength neq "Y"><input type="text" size="40" name="arrem4" id="arrem4" value="#arrem4#" maxlength="35"></cfif>
				</cfif>
			</td>
		</tr>
          <cfif lcase(HcomID) eq "accord_i">
          <tr>
        <th>Date Of Birth :</th>
        <cfif isdate(arrem5)>
                      <cfelse>
                <cfset arrem5 = "1990-01-01">
                </cfif>
        <td>
                <select name="day1" id="day1">
<cfloop from="1" to="31" index="i">
<option value="#i#" <cfif dateformat(arrem5,'dd') eq i>Selected</cfif>>#i#</option>
</cfloop>
</select>
<select name="month1" id="month1">
<cfloop from="1" to="12" index="i">
<cfset datecrete = createdate('2010',i,'1')>
<option value="#i#" <cfif dateformat(arrem5,'mm') eq i>Selected</cfif>>#ucase(dateformat(datecrete,'mmmm'))#</option>
</cfloop>
</select>
<select name="year1" id="year1">

  <cfloop from="1930" to="2010" index="i">
    <option value="#i#" <cfif dateformat(arrem5,'yyyy') eq i>Selected</cfif>>#i#</option>
  </cfloop>
</select></td>
        </tr>
        
        <tr>
        <th>Refered By :</th>
        <td><input type="text" size="40" name="arrem6" id="arrem6" value="#arrem6#" maxlength="35" ></td>
        </tr>
</cfif>


        <cfif lcase(HcomID) eq "taftc_i">
        <tr>
        <th>Email :</th>
        <td><input type="text" size="40" name="arrem16" id="arrem16" value="#arrem16#" maxlength="35" ></td>
        </tr>
        <tr>
        <th>NRIC :</th>
        <td><input type="text" size="40" name="arrem5" id="arrem5" value="#arrem5#" maxlength="35" onBlur="ajaxFunction(document.getElementById('checkNRICajax'),'findNRICAjax.cfm?NRIC='+document.getElementById('arrem5').value+'&custno='+document.getElementById('custno').value);setTimeout('checkalert();',500);"><div id="checkNRICajax"></div></td>
        </tr>
        <tr>
         <th>SEX :</th>
        <td>
        <select name="arrem6" id="arrem6">
        <option value="">Select an option</option>
        <option value="M" <cfif arrem6 eq "M" >Selected</cfif>>Male</option>
        <option value="F" <cfif arrem6 eq "F" >Selected</cfif>>Female</option>
        </select>
        </td>
        </tr>
        <cfquery name="getdata2" datasource="#dts#">
SELECT nationality FROM droplist where nationality != "" group by nationality order by nationality
</cfquery>
        <tr>
        <th>Nationality</th>

        <td>
        <select name="arrem7" id="arrem7">
        <option value="">Select a Nationality</option>
        <cfloop query="getdata2">
        <option value="#nationality#" <cfif arrem7 eq #nationality# >Selected</cfif> >#nationality#</option>
        </cfloop>
        </select>
        </td>
        </tr>
              <tr>
<th>Date of Birth</th>
<td>
<select name="day" id="day">

<option value="#(dateformat(arrem18,'dd'))#" selected>#(dateformat(arrem18,'dd'))#</option>
<cfloop from="1" to="31" index="i">
<option value="#i#">#i#</option>
</cfloop>
</select>
<select name="month" id="month">
<option value="#ucase(dateformat(arrem18,'mm'))#" selected>#ucase(dateformat(arrem18,'mmmm'))#</option>
<cfloop from="1" to="12" index="i">
<cfset datecrete = createdate('2010',i,'1')>
<option value="#i#">#ucase(dateformat(datecrete,'mmmm'))#</option>
</cfloop>
</select>
<select name="year" id="year">
<option value="#(dateformat(arrem18,'yyyy'))#" selected>#(dateformat(arrem18,'yyyy'))#</option>
<cfloop from="1930" to="2010" index="i">
<option value="#i#">#i#</option>
</cfloop>
</select></td>
</tr>
<cfquery name="getdata1" datasource="#dts#">
SELECT Race FROM droplist where race != "" group by Race order by Race
</cfquery>
        <tr>
        <th>Race</th>
        <td>
        <select name="arrem8" id="arrem8">
        <option value="">Select a Race</option>
        <cfloop query="getdata1">
        <option value="#Race#" <cfif arrem8 eq #Race# >Selected</cfif> >#Race#</option>
        </cfloop>
        </select>
        </td>
        </tr>
                <cfquery name="getdata3" datasource="#dts#">
SELECT qualification FROM droplist where qualification != "" group by qualification order by qualification
</cfquery>
        <tr>
        <th>Qualification</th>
        
        <td>
        <select name="arrem9" id="arrem9">
        <option value="">Select a Qualification</option>
        <cfloop query="getdata3">
        <option value="#qualification#" <cfif arrem9 eq #qualification# >Selected</cfif> >#qualification#</option>
        </cfloop>
        </select>
        </td>
        </tr>
        
             <tr>
        <th>Are You Employed</th>
        <cfset emplist = "Yes,No">
        <td>
        <select name="arrem17" id="arrem17">
        <option value="">Select a option</option>
        <cfloop list="#emplist#" index="i" delimiters=",">
        <option value="#i#" <cfif arrem17 eq i >Selected</cfif> >#i#</option>
        </cfloop>
        </select>
        </td>
        </tr>
              <cfquery name="getdata4" datasource="#dts#">
SELECT salary FROM droplist where salary != "" group by salary order by salary 
</cfquery>
        <tr>
        <th>Salary Range</th>
        
        <td>
        <select name="arrem10" id="arrem10">
        <option value="">Select a Salary Range</option>
        <cfloop query="getdata4">
        <option value="#salary#" <cfif arrem10 eq #salary#>Selected</cfif> >#salary#</option>
        </cfloop>
        </select>
        </td>
        </tr>
        
        <tr>
        <th>Designation</th>
        <td><input type="text" size="40" name="arrem11" id="arrem11" value="#arrem11#" maxlength="35"></td>
        </tr>
        
         <tr>
        <th>Department</th>
        <td><input type="text" size="40" name="arrem12" id="arrem12" value="#arrem12#" maxlength="35"></td>
        </tr>
        
         <tr>
        <th>Yr in Industry</th>
        <td><input type="text" size="40" name="arrem13" id="arrem13" value="#arrem13#" maxlength="35"></td>
        </tr>
        
         <tr>
        <th>Emergency Contact Person</th>
        <td><input type="text" size="40" name="arrem14" id="arrem14" value="#arrem14#" maxlength="35"></td>
        </tr>
        
         <tr>
        <th>Emergency Contact Person Tel</th>
        <td><input type="text" size="40" name="arrem15" id="arrem15" value="#arrem15#" maxlength="35"></td>
        </tr>
        </cfif>
		<tr>
			<td></td>
			<td align="right"><input type="submit" value="  #button#  "></td>
		</tr>				
	</cfoutput>
	</table>
	</form>
			
</body>
</html>
<script type="text/javascript">
var needToConfirm = true;

function setDirtyFlag()
{
needToConfirm = true; //Call this function if some changes is made to the web page and requires an alert
// Of-course you could call this is Keypress event of a text box or so...
}

function releaseDirtyFlag()
{
needToConfirm = false; //Call this function if dosent requires an alert.
//this could be called when save button is clicked 
}


window.onbeforeunload = confirmExit;
function confirmExit()
{
if (needToConfirm)
return "You have attempted to leave this page. If you have made any changes to the fields without clicking the accept button, your changes will be lost. Are you sure you want to exit this page?";
}
</script>