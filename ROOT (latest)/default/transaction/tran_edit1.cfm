<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<cfset session.hcredit_limit_exceed = "N">
<cfset session.dcredit_limit_exceed = "Y">
<cfset session.customercode = custno>
<cfset session.tran_refno = refno>

<cfparam name="xrelated" default="0">
<cfparam name="alcreate" default="0">
<cfparam name="Submit" default="">
<cfparam name="ChgBillToAddr" default="">
<cfparam name="ChgDeliveryAddr" default="">
<cfparam name="ChgCollectFromAddr" default="">
<cfparam name="Scust" default="">

<cfquery datasource="#dts#" name="gettranname">
	Select lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM

	from GSetup
</cfquery>

<cfif tran eq "RC">
  	<cfset tran = "RC">
  	<cfset tranname = gettranname.lRC>
  	<cfset trancode = "rcno">
  	<cfset tranarun = "rcarun">

  	<cfif getpin2.h2102 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "PR">
  	<cfset tran = "PR">
  	<cfset tranname = gettranname.lPR>
  	<cfset trancode = "prno">
  	<cfset tranarun = "prarun">

  	<cfif getpin2.h2201 eq 'T'>
 		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "DO">
	<cfset tran = "DO">
	<cfset tranname = gettranname.lDO>
	<cfset trancode = "dono">
    <cfset tranarun = "doarun">

	<cfif getpin2.h2301 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "INV">
  	<cfset tran = "INV">
  	<cfset tranname = gettranname.lINV>
  	<cfset trancode = "invno">
  	<cfset tranarun = "invarun">

	<cfif getpin2.h2401 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "CS">
  	<cfset tran = "CS">
  	<cfset tranname = gettranname.lCS>
  	<cfset trancode = "csno">
  	<cfset tranarun = "csarun">

	<cfif getpin2.h2501 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "CN">
  	<cfset tran = "CN">
  	<cfset tranname = gettranname.lCN>
  	<cfset trancode = "cnno">
  	<cfset tranarun = "cnarun">

	<cfif getpin2.h2601 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "DN">
  	<cfset tran = "DN">
  	<cfset tranname = gettranname.lDN>
  	<cfset trancode = "dnno">
  	<cfset tranarun = "dnarun">

	<cfif getpin2.h2701 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "PO">
  	<cfset tran = "PO">
  	<cfset tranname = gettranname.lPO>
  	<cfset trancode = "pono">
  	<cfset tranarun = "poarun">

	<cfif getpin2.h2861 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "QUO">
  	<cfset tran = "QUO">
  	<cfset tranname = gettranname.lQUO>
  	<cfset trancode = "quono">
  	<cfset tranarun = "quoarun">

	<cfif getpin2.h2871 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "SO">
  	<cfset tran = "SO">
  	<cfset tranname = gettranname.lSO>
  	<cfset trancode = "sono">
  	<cfset tranarun = "soarun">

	<cfif getpin2.h2881 eq 'T'>
 		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif tran eq "SAM">
	<cfset tran = "SAM">
	<cfset tranname = gettranname.lSAM>
	<cfset trancode = "samno">
	<cfset tranarun = "samarun">

	<cfif getpin2.h2851 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
<cfelseif tran eq "SAMM" and lcase(hcomid) eq "hunting_i">
	<cfset tran = "SAMM">
	<cfset tranname = "Sales Order">
	<cfset trancode = "sammno">
	<cfset tranarun = "sammarun">

	<cfif getpin2.h2851 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>
<cfif isdefined("form.invset") or isdefined("invset") and invset neq 0>
	<cfif invset eq "invno">
		<cfset tranarun = "invarun">
	<cfelseif invset eq "invno_2">
		<cfset tranarun = "invarun_2">
	<cfelseif invset eq "invno_3">
		<cfset tranarun = "invarun_3">
	<cfelseif invset eq "invno_4">
		<cfset tranarun = "invarun_4">
	<cfelseif invset eq "invno_5">
		<cfset tranarun = "invarun_5">
	<cfelseif invset eq "invno_6">
		<cfset tranarun = "invarun_6">
	</cfif>

	<cfquery datasource="#dts#" name="getGeneralInfo">
		Select #invset# as tranno, #tranarun# as arun,invoneset,filterall,suppcustdropdown,attnddl,transactiondate from GSetup
	</cfquery>
<cfelse>
	<cfquery datasource="#dts#" name="getGeneralInfo">
		Select #trancode# as tranno, #tranarun# as arun,invoneset,filterall,suppcustdropdown,attnddl,transactiondate from GSetup
	</cfquery>
	<cfset invset=0>
</cfif>
<!--- Add On 11-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
</cfquery>
<html>
<head>
	<title><cfoutput>#tranname#</cfoutput></title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<link href="../../scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
	<script type='text/javascript' src='../../ajax/core/engine.js'></script>
	<script type='text/javascript' src='../../ajax/core/util.js'></script>
	<script type='text/javascript' src='../../ajax/core/settings.js'></script>
</head>

<script src="../../scripts/CalendarControl.js" language="javascript"></script>
<script language="JavaScript">
	function selectlist(custno){
			
			for (var idx=0;idx<document.getElementById('custno').options.length;idx++) {
        if (custno==document.getElementById('custno').options[idx].value) {
            document.getElementById('custno').options[idx].selected=true;
			updateDetails(custno);
        }
    } 
		}

	function getCustSupp(option){
			var inputtext = document.invoicesheet.searchcustsupp.value;
			DWREngine._execute(_tranflocation, null, 'supplierlookup', inputtext, option, getCustSuppResult);
		}

	function getCustSuppResult(custsuppArray){
		DWRUtil.removeAllOptions("custno");
		DWRUtil.addOptions("custno", custsuppArray,"KEY", "VALUE");
		updateDetails(document.invoicesheet.custno[0].value);
	}
		
	function updateDetails(columnvalue){
		var tran = document.invoicesheet.tran.value;
		<cfif url.tran eq "DN" or url.tran eq "CN" or url.tran eq "PR" or url.tran eq "RC" or url.tran eq "CS" or url.tran eq "QUO">
			var tran = "INV";
			</cfif>
		<cfif url.tran eq "SAM">
		var tran = "SAM";
		</cfif>
		var tablename = document.invoicesheet.ptype.value;
		DWREngine._execute(_tranflocation, null, 'getCustSuppDetails', tablename, columnvalue, tran, showCustSuppDetails);
	}
		
	function showCustSuppDetails(CustSuppObject){
		DWRUtil.setValue("name", CustSuppObject.B_NAME);
		DWRUtil.setValue("name2", CustSuppObject.B_NAME2);
		DWRUtil.setValue("b_name", CustSuppObject.B_NAME);
		DWRUtil.setValue("b_name2", CustSuppObject.B_NAME2);
		DWRUtil.setValue("b_add1", CustSuppObject.B_ADD1);
		DWRUtil.setValue("b_add2", CustSuppObject.B_ADD2);
		DWRUtil.setValue("b_add3", CustSuppObject.B_ADD3);
		DWRUtil.setValue("b_add4", CustSuppObject.B_ADD4);
		DWRUtil.setValue("b_add5", CustSuppObject.B_ADD5);
		DWRUtil.setValue("b_attn", CustSuppObject.B_ATTN);
		DWRUtil.setValue("b_phone", CustSuppObject.B_PHONE);
		DWRUtil.setValue("b_fax", CustSuppObject.B_FAX);
		DWRUtil.setValue("term", CustSuppObject.TERM);
		DWRUtil.setValue("agent", CustSuppObject.AGENT);
		DWRUtil.setValue("currcode", CustSuppObject.CURRCODE);
		DWRUtil.setValue("b_phone2", CustSuppObject.B_PHONE2);
		DWRUtil.setValue("b_email", CustSuppObject.B_EMAIL);
		if(CustSuppObject.TRAN == 'PO' || CustSuppObject.TRAN == 'SO' || CustSuppObject.TRAN == 'INV' || CustSuppObject.TRAN == 'DO' || CustSuppObject.TRAN == 'SAM' || CustSuppObject.TRAN == 'DN' || CustSuppObject.TRAN == 'CN' || CustSuppObject.TRAN == 'PR' || CustSuppObject.TRAN == 'RC' || CustSuppObject.TRAN == 'CS' || CustSuppObject.TRAN == 'QUO'){
			DWRUtil.setValue("DCode", CustSuppObject.DCODE);
			DWRUtil.setValue("d_name", CustSuppObject.D_NAME);
			DWRUtil.setValue("d_name2", CustSuppObject.D_NAME2);
			DWRUtil.setValue("d_add1", CustSuppObject.D_ADD1);
			DWRUtil.setValue("d_add2", CustSuppObject.D_ADD2);
			DWRUtil.setValue("d_add3", CustSuppObject.D_ADD3);
			DWRUtil.setValue("d_add4", CustSuppObject.D_ADD4);
			DWRUtil.setValue("d_add5", CustSuppObject.D_ADD5);
			DWRUtil.setValue("d_attn", CustSuppObject.D_ATTN);
			DWRUtil.setValue("d_phone", CustSuppObject.D_PHONE);
			DWRUtil.setValue("d_fax", CustSuppObject.D_FAX);
		}
	}
	
	function getCustSupp2(custno,custname){
		var custname=unescape(custname);
		<cfif getGeneralInfo.suppcustdropdown eq "1">	
			myoption = document.createElement("OPTION");
			myoption.text = custno + " - " + custname;
			myoption.value = custno;
			document.invoicesheet.custno.options.add(myoption);
			var indexvalue = document.getElementById("custno").length-1;
			document.getElementById("custno").selectedIndex=indexvalue;
			updateDetails(document.invoicesheet.custno[indexvalue].value);
		<cfelse>
			document.getElementById("custno").value=custno;
			updateDetails(custno);
		</cfif>
	}
	
	function test()
	{
  		if(document.invoicesheet.nexttranno.value=='')
		{
    		alert("Your Transaction's No. cannot be blank.");
			document.invoicesheet.nexttranno.focus();
    		return false;
  		}
		if(document.invoicesheet.custno.value=='')
		{
			alert("Your Customer's No. cannot be blank.");
			document.invoicesheet.custno.focus();
			return false;
  		}
  		return true;
	}

	function CopyProfileAddr()
	{
  		<cfoutput>
    	<cfif #tran# eq "rc" or #tran# eq "pr" or #tran# eq "po">
      		<cfquery name="getcust" datasource="#dts#">
        		Select * from #target_apvend# where custno = "#custno#"
      		</cfquery>
    	<cfelse>
      		<cfquery name="getcust" datasource="#dts#">
        		Select * from #target_arcust# where custno = "#custno#"
      		</cfquery>
    	</cfif>

		document.invoicesheet.BCode.value = "Profile";
		document.invoicesheet.b_name.value = "#convertquote(getcust.name)#";
		document.invoicesheet.b_name2.value = "#convertquote(getcust.name2)#";
		document.invoicesheet.b_add1.value = "#getcust.add1#";
    	document.invoicesheet.b_add2.value = "#getcust.add2#";
    	document.invoicesheet.b_add3.value = "#getcust.add3#";
    	document.invoicesheet.b_add4.value = "#getcust.add4#";
    	document.invoicesheet.b_attn.value = "#getcust.attn#";
    	document.invoicesheet.b_phone.value = "#getcust.phone#";
    	document.invoicesheet.b_fax.value = "#getcust.fax#";
		<cfif getcust.country neq "" or getcust.postalcode neq "">
			<cfset add5=getcust.country&" "&getcust.postalcode>
			if(document.invoicesheet.b_add1.value==''){
				document.invoicesheet.b_add1.value = "#add5#";
			}
			else if(document.invoicesheet.b_add2.value==''){
				document.invoicesheet.b_add2.value = "#add5#";
			}
			else if(document.invoicesheet.b_add3.value==''){
				document.invoicesheet.b_add3.value = "#add5#";
			}
			else if(document.invoicesheet.b_add4.value==''){
				document.invoicesheet.b_add4.value = "#add5#";
			}
			else{
				document.invoicesheet.b_add5.value = "#add5#";
			}
		</cfif>
  		</cfoutput>
  		return true;
	}

	function CopyBillAddr()
	{
    	<cfoutput>
		<cfif #tran# eq "rc" or #tran# eq "pr" or #tran# eq "po">
      		<cfquery name="getcust" datasource="#dts#">
        		Select * from #target_apvend# where custno = "#custno#"
      		</cfquery>
    	<cfelse>
      		<cfquery name="getcust" datasource="#dts#">
        		Select * from #target_arcust# where custno = "#custno#"
      		</cfquery>
    	</cfif>

		document.invoicesheet.DCode.value = "Profile";
		document.invoicesheet.d_name.value = "#convertquote(getcust.name)#";
		document.invoicesheet.d_name2.value = "#convertquote(getcust.name2)#";
		document.invoicesheet.d_add1.value = "#getcust.daddr1#";
    	document.invoicesheet.d_add2.value = "#getcust.daddr2#";
    	document.invoicesheet.d_add3.value = "#getcust.daddr3#";
    	document.invoicesheet.d_add4.value = "#getcust.daddr4#";
    	document.invoicesheet.d_attn.value = "#getcust.dattn#";
    	document.invoicesheet.d_phone.value = "#getcust.dphone#";
    	document.invoicesheet.d_fax.value = "#getcust.dfax#";
		<cfif getcust.d_country neq "" or getcust.d_postalcode neq "">
			<cfset dadd5=getcust.d_country&" "&getcust.d_postalcode>
			if(document.invoicesheet.d_add1.value==''){
				document.invoicesheet.d_add1.value = "#dadd5#";
			}
			else if(document.invoicesheet.d_add2.value==''){
				document.invoicesheet.d_add2.value = "#dadd5#";
			}
			else if(document.invoicesheet.d_add3.value==''){
				document.invoicesheet.d_add3.value = "#dadd5#";
			}
			else if(document.invoicesheet.d_add4.value==''){
				document.invoicesheet.d_add4.value = "#dadd5#";
			}
			else{
				document.invoicesheet.d_add5.value = "#dadd5#";
			}
		</cfif>
  		</cfoutput>
  		return true;
	}
	
	function CopyProfileAddr2()
	{
		document.invoicesheet.DCode.value = "";
		document.invoicesheet.d_name.value = document.invoicesheet.b_name.value;
		document.invoicesheet.d_name2.value = document.invoicesheet.b_name2.value;
		document.invoicesheet.d_add1.value = document.invoicesheet.b_add1.value;
    	document.invoicesheet.d_add2.value = document.invoicesheet.b_add2.value;
    	document.invoicesheet.d_add3.value = document.invoicesheet.b_add3.value;
    	document.invoicesheet.d_add4.value = document.invoicesheet.b_add4.value;
    	document.invoicesheet.d_attn.value = document.invoicesheet.b_attn.value;
    	document.invoicesheet.d_phone.value = document.invoicesheet.b_phone.value;
    	document.invoicesheet.d_fax.value = document.invoicesheet.b_fax.value;
  		return true;
	}
	
	function CopyCollectAddr()
	{
  		<cfoutput>
    	<cfif #tran# eq "rc" or #tran# eq "pr" or #tran# eq "po">
      		<cfquery name="getcust" datasource="#dts#">
        		Select * from #target_apvend# where custno = "#custno#"
      		</cfquery>
    	<cfelse>
      		<cfquery name="getcust" datasource="#dts#">
        		Select * from #target_arcust# where custno = "#custno#"
      		</cfquery>
    	</cfif>

		document.invoicesheet.CCode.value = "Profile";
		document.invoicesheet.c_name.value = "#convertquote(getcust.name)#";
		document.invoicesheet.c_name2.value = "#convertquote(getcust.name2)#";
		document.invoicesheet.c_add1.value = "#getcust.add1#";
    	document.invoicesheet.c_add2.value = "#getcust.add2#";
    	document.invoicesheet.c_add3.value = "#getcust.add3#";
    	document.invoicesheet.c_add4.value = "#getcust.add4#";
    	document.invoicesheet.c_attn.value = "#getcust.attn#";
    	document.invoicesheet.c_phone.value = "#getcust.phone#";
    	document.invoicesheet.c_fax.value = "#getcust.fax#";
		<cfif getcust.country neq "" or getcust.postalcode neq "">
			<cfset cadd5=getcust.country&" "&getcust.postalcode>
			if(document.invoicesheet.c_add1.value==''){
				document.invoicesheet.c_add1.value = "#cadd5#";
			}
			else if(document.invoicesheet.c_add2.value==''){
				document.invoicesheet.c_add2.value = "#cadd5#";
			}
			else if(document.invoicesheet.c_add3.value==''){
				document.invoicesheet.c_add3.value = "#cadd5#";
			}
			else if(document.invoicesheet.c_add4.value==''){
				document.invoicesheet.c_add4.value = "#cadd5#";
			}
			else{
				document.invoicesheet.c_add5.value = "#cadd5#";
			}
		</cfif>
  		</cfoutput>
  		return true;
	}
	
	function redirect(TYPE){
		if(TYPE == 'chgbilltoaddr'){
			invoicesheet.action='tranaddrsearch.cfm';
		}
		else if(TYPE == 'P1'){
			<cfoutput>
			location.href='tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(custno)#&first=0';
			</cfoutput>
		}
	}
	
	function assignCust(type){
			checkboxObj=document.getElementById("internalrc");
			//document.getElementById("custno").value='ASSM/999';
			
			if(document.getElementById("custno").value != 'ASSM/999'){
				if(type=='dropdown'){
					DWRUtil.removeAllOptions("custno");
					myoption = document.createElement("OPTION");
					myoption.text = 'ASSM/999';
					myoption.value = 'ASSM/999';
					document.getElementById("custno").options.add(myoption);
				}else{
					document.getElementById("custno").value='ASSM/999';
				}
				updateDetails('ASSM/999');
			}
			else{
				if(type=='dropdown'){
					var inputtext = '';
					DWREngine._execute(_tranflocation, null, 'supplierlookup', inputtext, 'Supplier', getCustSuppResult);
				}else{
					document.getElementById("custno").value='';
					updateDetails('');
				}
			}
			checkboxObj.checked =false;
		}
</script>

<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
	<cfset ptype = target_apvend>
	<cfset ptype1 = "Supplier">
<cfelse>
	<cfset ptype = target_arcust>
	<cfset ptype1 = "Customer">
</cfif>

<!--- REMARK ON 16-06-2009 and REPLACE WITH THE BELOW ONE --->
<!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
	<cfquery name="getcustsupp" datasource="#dts#">
   		select custno as xcustno,name from #ptype# order by custno
	</cfquery>
</cfif> --->

<!--- REMARK ON 09-12-2009, MOVE TO UPPER --->
<!--- EDITED ON 16-06-2009 --->
<!--- <cfif isdefined("form.invset") or isdefined("invset") and invset neq 0>
	<cfif invset eq "invno">
		<cfset tranarun = "invarun">
	<cfelseif invset eq "invno_2">
		<cfset tranarun = "invarun_2">
	<cfelseif invset eq "invno_3">
		<cfset tranarun = "invarun_3">
	<cfelseif invset eq "invno_4">
		<cfset tranarun = "invarun_4">
	<cfelseif invset eq "invno_5">
		<cfset tranarun = "invarun_5">
	<cfelseif invset eq "invno_6">
		<cfset tranarun = "invarun_6">
	</cfif>

	<cfquery datasource="#dts#" name="getGeneralInfo">
		Select #invset# as tranno, #tranarun# as arun,invoneset,filterall,suppcustdropdown from GSetup
	</cfquery>
<cfelse>
	<cfquery datasource="#dts#" name="getGeneralInfo">
		Select #trancode# as tranno, #tranarun# as arun,invoneset,filterall,suppcustdropdown from GSetup
	</cfquery>
	<cfset invset=0>
</cfif> --->

<cfif getGeneralInfo.suppcustdropdown eq "1">
	<!--- <cfquery name="getcustsupp" datasource="#dts#">
   		select custno as xcustno,name from #ptype# order by <cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">custno,name<cfelse>name,custno</cfif>
	</cfquery> --->
    
	<cfquery name="getcustsupp" datasource="#dts#">
   		select custno as xcustno,name from #ptype# order by #getdealer_menu.custSuppSortBy#
	</cfquery>
</cfif>

<cfoutput>
	<cfif isdefined("form.submit") and submit eq "Save & continue">	
		<cfinvoke component="cfc.Date" method="getDbDate" inputDate="#form.invoicedate#" returnvariable="ndatecreate"/>
        <cfif getGeneralInfo.transactiondate eq 'Y'>
        <cfinvoke component="cfc.Date" method="getDbDate" inputDate="#form.transactiondate#" returnvariable="ndatecreatetran"/>
        </cfif>
        <cfset nndate = createdate(right(form.invoicedate,4),mid(form.invoicedate,4,2),left(form.invoicedate,2))>
		<cfinvoke component="cfc.Period" method="getCurrentPeriod" dts="#dts#" inputDate="#dateformat(nndate,'yyyy-mm-dd')#" returnvariable="cperiod"/>
		
		<cfquery name="update_ictran" datasource="#dts#">
			update ictran set wos_date = #ndatecreate#, 
			custno='#form.custno#', <cfif lcase(husergrpid) neq "super">userid='#Huserid#',</cfif> fperiod='#cperiod#' 
			where refno = '#form.refno#' and type = '#tran#'
		</cfquery>
		
		<!--- REMARK ON 090608 AND REPLACE WITH THE BELOW QUERY (REMOVE THE FPERIOD TO BE UPDATE TO "99" IN THE ARTRAN, BECAUSE THE FPERIOD WILL BE USED IN ANOTHER FORM) --->
		<!---cfquery name="update_artran" datasource="#dts#">
			Update artran set wos_date=#ndatecreate#, custno='#form.custno#', fperiod='#cperiod#', 
			rem0 = '#form.bcode#', rem2 = '#form.b_attn#',
			rem4 = '#form.b_phone#', frem2 = '#form.b_add1#', frem3 = '#form.b_add2#',
			frem4 = '#form.b_add3#', frem5 = '#form.b_add4#', rem13 = '#form.b_add5#', 
			frem0 = '#form.b_name#', frem1 = '#form.b_name2#', frem6 = '#form.b_fax#',
			frem9 = '#form.frem9#', userid='#Huserid#', name='#form.name#'
			<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
			, rem1 = '#form.dcode#', rem3 = '#form.d_attn#' , rem12='#form.d_phone#'
			, rem14 = '#form.d_add5#'
			, frem7 = '#form.d_name#'
			, frem8 = '#form.d_name2#'
			, comm0='#form.d_add1#', comm1='#form.d_add2#', comm2='#form.d_add3#'
			, comm3='#form.d_add4#', comm4='#form.d_fax#'
			</cfif>
			where refno = '#form.refno#' and type = '#tran#'
		</cfquery--->
		
		<!--- REMARK ON 30-03-2009, ADD AGENT,TERM,CURRCODE --->
		<!--- <cfquery name="update_artran" datasource="#dts#">
			Update artran set wos_date=#ndatecreate#, custno='#form.custno#',
			rem0 = '#form.bcode#', rem2 = '#form.b_attn#',
			rem4 = '#form.b_phone#', frem2 = '#form.b_add1#', frem3 = '#form.b_add2#',
			frem4 = '#form.b_add3#', frem5 = '#form.b_add4#', rem13 = '#form.b_add5#', 
			frem0 = '#form.b_name#', frem1 = '#form.b_name2#', frem6 = '#form.b_fax#',
			frem9 = '#form.frem9#', <cfif lcase(husergrpid) neq "super">userid='#Huserid#',</cfif> name='#form.name#'
			<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
			, rem1 = '#form.dcode#', rem3 = '#form.d_attn#' , rem12='#form.d_phone#'
			, rem14 = '#form.d_add5#'
			, frem7 = '#form.d_name#'
			, frem8 = '#form.d_name2#'
			, comm0='#form.d_add1#', comm1='#form.d_add2#', comm2='#form.d_add3#'
			, comm3='#form.d_add4#', comm4='#form.d_fax#'
			</cfif>
			where refno = '#form.refno#' and type = '#tran#'
		</cfquery> --->
		<cfquery name="update_artran" datasource="#dts#">
			Update artran set wos_date="#ndatecreate#", fperiod = "#cperiod#" ,custno='#form.custno#',
			rem0 = '#form.bcode#', rem2 = '#form.b_attn#',
			rem4 = '#form.b_phone#', frem2 = '#form.b_add1#', frem3 = '#form.b_add2#',
			frem4 = '#form.b_add3#', frem5 = '#form.b_add4#', rem13 = '#form.b_add5#', 
			frem0 = '#form.b_name#', frem1 = '#form.b_name2#', frem6 = '#form.b_fax#',
			frem9 = '#form.frem9#', <cfif lcase(husergrpid) neq "super">userid='#Huserid#',</cfif> name='#form.name#',phonea='#form.b_phone2#',e_mail='#form.b_email#',
			currcode='#form.currcode#'
			<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV' or tran eq 'SAM' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN' or tran eq 'PR' or tran eq 'RC' or tran eq 'QUO'>
			, rem1 = '#form.dcode#', rem3 = '#form.d_attn#' , rem12='#form.d_phone#'
			, rem14 = '#form.d_add5#'
			, frem7 = '#form.d_name#'
			, frem8 = '#form.d_name2#'
			, comm0='#form.d_add1#', comm1='#form.d_add2#', comm2='#form.d_add3#'
			, comm3='#form.d_add4#', comm4='#form.d_fax#'
			<cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
				,rem15='#form.ccode#',rem16='#form.c_name#',rem17='#form.c_name2#',rem18='#form.c_add1#',rem19='#form.c_add2#'
                ,rem20='#form.c_add3#',rem21='#form.c_add4#',rem22='#form.c_add5#',rem23='#form.c_attn#',rem24='#form.c_phone#'
                ,rem25='#form.c_fax#'
			</cfif>
            <cfif getGeneralInfo.transactiondate eq 'Y'>
			,tran_date="#ndatecreatetran#"
			</cfif>
            <cfif lcase(hcomid) eq 'ugateway_i'>
            <cfif isdefined('form.via')>
            ,via = '#form.via#'
			</cfif>
            </cfif>
			</cfif>
			where refno = '#form.refno#' and type = '#tran#'
		</cfquery>
		<cflocation url="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(form.custno)#&first=0" addtoken="no">
	<cfelseif ChgBillToAddr neq "">
		<form name="invoicesheet" action="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&stype=#tranname#&ttype=#ttype#&refno=#refno#&nexttranno=#form.nexttranno#&custno=#URLEncodedFormat(form.custno)#&bcode=#form.bcode#&dcode=#form.dcode#&addrtype=Bill&invoicedate=#form.invoicedate#&ccode=#form.ccode#" method="post">
		<script>invoicesheet.submit()</script>
		</form>
	<cfelseif ChgDeliveryAddr neq "">
		<form name="invoicesheet" action="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&stype=#tranname#&ttype=#ttype#&refno=#refno#&nexttranno=#form.nexttranno#&custno=#URLEncodedFormat(form.custno)#&bcode=#form.bcode#&dcode=#form.dcode#&addrtype=Delivery&invoicedate=#form.invoicedate#&ccode=#form.ccode#" method="post">
		<script>invoicesheet.submit()</script>
		</form>
	<cfelseif scust neq "">
		<cfif (tran eq 'PO' or tran eq 'PR' or tran eq 'RC') and ttype neq "Create">
			<form name="invoicesheet" action="transuppsearch.cfm?tran=#tran#&stype=#tranname#&ttype=#ttype#&refno=#refno#&nexttranno=#form.nexttranno#&custno=#URLEncodedFormat(form.custno)#&bcode=#form.bcode#&dcode=#form.dcode#&invoicedate=#form.invoicedate#&ccode=#form.ccode#" method="post">
			<script>invoicesheet.submit()</script>
			</form>
		<cfelse>
			<form name="invoicesheet" action="trancustsearch.cfm?tran=#tran#&stype=#tranname#&ttype=#ttype#&refno=#refno#&nexttranno=#form.nexttranno#&custno=#URLEncodedFormat(form.custno)#&bcode=#form.bcode#&dcode=#form.dcode#&invoicedate=#form.invoicedate#&ccode=#form.ccode#" method="post">
			<script>invoicesheet.submit()</script>
			</form>
		</cfif>
	<cfelseif ChgCollectFromAddr neq "">
		<form name="invoicesheet" action="trancollectaddrsearch.cfm?invset=#invset#&tran=#tran#&stype=#tranname#&ttype=#ttype#&refno=#refno#&nexttranno=#form.nexttranno#&custno=#URLEncodedFormat(form.custno)#&bcode=#form.bcode#&dcode=#form.dcode#&addrtype=Collect&invoicedate=#form.invoicedate#&ccode=#form.ccode#" method="post">
		<script>invoicesheet.submit()</script>
		</form>
	</cfif>

  	<cfquery datasource='#dts#' name="getitem">
		select * from artran where refno='#refno#' and type = '#tran#'
  	</cfquery>

	<cfif getitem.posted eq 'P'>
  		<h3>Transaction already posted.</h3>
		<cfabort>
  	</cfif>
	
	<cfquery name="getcust" datasource="#dts#">
		Select * from #ptype# where custno='#url.custno#'
	</cfquery>
		
  	<cfif url.custno neq getitem.custno and url.first eq 1>
		<cfset name=getcust.name>
		<cfset name2=getcust.name2>
		<!--- ADD ON 30-03-2009 --->
		<cfset term = getcust.term>
		<cfset agent = getcust.agent>
		<cfset currcode = getcust.currcode>
  	<cfelse>
		<cfset name = getitem.name>
		<cfset name2= ''>
		<!--- ADD ON 30-03-2009 --->
		<cfset term = getitem.term>
		<cfset agent = getitem.agenno>
		<cfset currcode = getitem.currcode>
  	</cfif>
	
	<cfif first eq 0>
      	<cfset T_BCode = getitem.rem0>
      	<cfset T_DCode = getitem.rem1>
		<cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
			<cfset T_CCode = getitem.rem15>
		<cfelse>
			<cfset T_CCode="">
		</cfif>
  	<cfelse>
    	<cfset T_BCode = bcode>
		<!--- <cfif getcust.daddr1 neq "">
    		<cfset T_DCode = "Profile">
		<cfelse>
			<cfset T_DCode = dcode>
		</cfif> --->
		<cfif isdefined("url.dcode")>
    		<cfif url.dcode neq "">
				<cfset T_DCode = dcode>
			<cfelse>
				<cfset T_DCode = "Profile">
			</cfif>
		<cfelse>
			<cfset T_DCode = "Profile">
		</cfif>
		<cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
			<cfif isdefined("url.ccode")>
	    		<cfif url.ccode neq "">
					<cfset T_CCode = ccode>
				<cfelse>
					<cfset T_CCode = "Profile">
				</cfif>
			<cfelse>
				<cfset T_CCode = "Profile">
			</cfif>
		<cfelse>
			<cfset T_CCode="">
		</cfif>
  	</cfif>
	
  	<cfset nexttranno=refno>
  	<cfset nDateCreate = getitem.wos_date>
    <cfset nDateCreate2 = getitem.tran_date>

	<cfset b_name = "">
  	<cfset b_name2 = "">
  	<cfset b_add1 = "">
  	<cfset b_add2 = "">
  	<cfset b_add3 = "">
 	<cfset b_add4 = "">
  	<cfset b_add5 = "">
  	<cfset b_attn = "">
  	<cfset b_phone = "">
  	<cfset b_fax = "">
  	<cfset b_phone2 = "">
    <cfset b_email = "">
  	<cfset d_name = "">
  	<cfset d_name2 = "">
  	<cfset d_add1 = "">
  	<cfset d_add2 = "">
  	<cfset d_add3 = "">
  	<cfset d_add4 = "">
  	<cfset d_add5 = "">
  	<cfset d_attn = "">
  	<cfset d_phone = "">
  	<cfset d_fax = "">
  	<cfset frem9 = "">

	<!--- <cfif lcase(hcomid) eq 'iel_i'> --->
		<cfset c_name="">
        <cfset c_name2="">
        <cfset c_add1 = "">
		<cfset c_add2 = "">
        <cfset c_add3 = "">
        <cfset c_add4 = "">
        <cfset c_add5 = "">
        <cfset c_attn = "">
        <cfset c_phone = "">
        <cfset c_fax = "">
	<!--- </cfif> --->
		<cfset via = "">
  	<!--- First from the menu or first click from Create --->

	<cfif T_BCode neq "">
    	<cfif T_BCode eq "Profile">
      		<cfset BCode = "Profile">
      		<cfset b_name = getcust.name>
      		<cfset b_name2 = getcust.name2>
      		<cfset b_add1 = getcust.add1>
      		<cfset b_add2 = getcust.add2>
      		<cfset b_add3 = getcust.add3>
      		<cfset b_add4 = getcust.add4>
	 	 	<cfset b_add5 = ''>
      		<cfset b_attn = getcust.attn>
      		<cfset b_phone = getcust.phone>
      		<cfset b_fax = getcust.fax>
  			<cfset b_phone2 = getcust.phonea>
            <cfset b_email = getcust.e_mail>
			<!--- ADD ON 14-10-2009 --->
			<cfif getcust.country neq "" and getcust.postalcode neq "">
				<cfset add5=getcust.country&" "&getcust.postalcode>
				<cfif getcust.add1 eq "">
					<cfset b_add1 = add5>
				<cfelseif getcust.add2 eq "">
					<cfset b_add2 = add5>
				<cfelseif getcust.add3 eq "">
					<cfset b_add3 = add5>
				<cfelseif getcust.add4 eq "">
					<cfset b_add4 = add5>
				<cfelse>
					<cfset b_add5 = add5>
				</cfif>
			</cfif>
    	<cfelse>
      		<cfquery name="getBillAddr" datasource="#dts#">
      			Select * from address where code = "#T_BCode#"
      		</cfquery>

			<cfset BCode = getBillAddr.code>
      		<cfset b_name = getBillAddr.name>
			<!--- <cfset b_name2 = ""> --->
		  	<cfset b_name2 = getitem.frem1>
		  	<cfset b_add1 = getBillAddr.add1>
		  	<cfset b_add2 = getBillAddr.add2>
		  	<cfset b_add3 = getBillAddr.add3>
		  	<cfset b_add4 = getBillAddr.add4>
		  	<cfset b_add5 = "">
		  	<cfset b_attn = getBillAddr.attn>
		  	<cfset b_phone = getBillAddr.phone>
		  	<cfset b_fax = getBillAddr.fax>
            <cfset b_email = getBillAddr.e_mail>
		  	<cfset b_phone2 =getBillAddr.phonea>
			<!--- ADD ON 14-10-2009 --->
			<cfif getBillAddr.country neq "" and getBillAddr.postalcode neq "">
				<cfset add5=getBillAddr.country&" "&getBillAddr.postalcode>
				<cfif getBillAddr.add1 eq "">
					<cfset b_add1 = add5>
				<cfelseif getBillAddr.add2 eq "">
					<cfset b_add2 = add5>
				<cfelseif getBillAddr.add3 eq "">
					<cfset b_add3 = add5>
				<cfelseif getBillAddr.add4 eq "">
					<cfset b_add4 = add5>
				<cfelse>
					<cfset b_add5 = add5>
				</cfif>
			</cfif>
    	</cfif>
    <cfelse>
			<cfset BCode = "">
			<cfset b_name = getitem.frem0>
		  	<cfset b_name2 = getitem.frem1>
		  	<cfset b_add1 = getitem.frem2>
		  	<cfset b_add2 = getitem.frem3>
		  	<cfset b_add3 = getitem.frem4>
		  	<cfset b_add4 = getitem.frem5>
		  	<cfset b_add5 = getitem.rem13>
		  	<cfset b_attn = getitem.rem2>
		  	<cfset b_phone = getitem.rem4>
		  	<cfset b_fax = getitem.frem6>
		  	<cfset b_phone2 =getitem.phonea>
            <cfset b_email =getitem.e_mail>
  	</cfif>

	<cfif T_DCode neq "">
    	<cfif T_DCode eq "Profile">
      		<cfset DCode = "Profile">
      		<cfset d_name = getcust.name>
      		<cfset d_name2 = getcust.name2>
      		<cfset d_add1 = getcust.daddr1>
      		<cfset d_add2 = getcust.daddr2>
      		<cfset d_add3 = getcust.daddr3>
      		<cfset d_add4 = getcust.daddr4>
	  		<cfset d_add5 = ''>
      		<cfset d_attn = getcust.dattn>
      		<cfset d_phone = getcust.dphone>
      		<cfset d_fax = getcust.dfax>
			<!--- ADD ON 14-10-2009 --->
			<cfif getcust.d_country neq "" and getcust.d_postalcode neq "">
				<cfset dadd5=getcust.d_country&" "&getcust.d_postalcode>
				<cfif getcust.daddr1 eq "">
					<cfset d_add1 = dadd5>
				<cfelseif getcust.daddr2 eq "">
					<cfset d_add2 = dadd5>
				<cfelseif getcust.daddr3 eq "">
					<cfset d_add3 = dadd5>
				<cfelseif getcust.daddr4 eq "">
					<cfset d_add4 = dadd5>
				<cfelse>
					<cfset d_add5 = dadd5>
				</cfif>
			</cfif>
     	<cfelse>
      		<cfquery name="getDeliveryAddr" datasource="#dts#">
      			select * from address where code = "#T_DCode#"
      		</cfquery>

			<cfset DCode = getDeliveryAddr.code>
		  	<cfset d_name = getDeliveryAddr.name>
		  	<!--- <cfset d_name2 = ""> --->
		  	<cfset d_name2 = getitem.frem8>
		  	<cfset d_add1 = getDeliveryAddr.add1>
		  	<cfset d_add2 = getDeliveryAddr.add2>
		  	<cfset d_add3 = getDeliveryAddr.add3>
		  	<cfset d_add4 = getDeliveryAddr.add4>
		  	<cfset d_add5 = "">
		  	<cfset d_attn = getDeliveryAddr.attn>
		  	<cfset d_phone = getDeliveryAddr.phone>
		  	<cfset d_fax = getDeliveryAddr.fax>
			<!--- ADD ON 14-10-2009 --->
			<cfif getDeliveryAddr.country neq "" and getDeliveryAddr.postalcode neq "">
				<cfset dadd5=getDeliveryAddr.country&" "&getDeliveryAddr.postalcode>
				<cfif getDeliveryAddr.add1 eq "">
					<cfset d_add1 = dadd5>
				<cfelseif getDeliveryAddr.add2 eq "">
					<cfset d_add2 = dadd5>
				<cfelseif getDeliveryAddr.add3 eq "">
					<cfset d_add3 = dadd5>
				<cfelseif getDeliveryAddr.add4 eq "">
					<cfset d_add4 = dadd5>
				<cfelse>
					<cfset d_add5 = dadd5>
				</cfif>
			</cfif>
    	</cfif>
    <cfelse>
		  	<cfset DCode = "">
		  	<cfset d_name = getitem.frem7>
		  	<cfset d_name2 = getitem.frem8>
			<cfset frem9 = getitem.frem9>
		  	<cfset d_add1 = getitem.comm0>
		  	<cfset d_add2 = getitem.comm1>

		  	<cfset d_add3 = getitem.comm2>
		  	<cfset d_add4 = getitem.comm3>
		  	<cfset d_add5 = getitem.rem14>
		  	<cfset d_attn = getitem.rem3>
		  	<cfset d_phone = getitem.rem12>
		  	<cfset d_fax = getitem.comm4>
  	</cfif>
	
	<cfif lcase(hcomid) eq 'ugateway_i'>
    	<cfset via = getitem.via>
	</cfif>
    
	<cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
		<cfif T_CCode neq "">
            <cfif T_CCode eq "Profile">
                <cfset CCode = "Profile">
                <cfset c_name = getcust.name>
                <cfset c_name2 = getcust.name2>
                <cfset c_add1 = getcust.add1>
                <cfset c_add2 = getcust.add2>
                <cfset c_add3 = getcust.add3>
                <cfset c_add4 = getcust.add4>
                <cfset c_add5 = ''>
                <cfset c_attn = getcust.attn>
                <cfset c_phone = getcust.phone>
                <cfset c_fax = getcust.fax>
				<!--- ADD ON 14-10-2009 --->
				<cfif getcust.country neq "" and getcust.postalcode neq "">
					<cfset cadd5=getcust.country&" "&getcust.postalcode>
					<cfif getcust.add1 eq "">
						<cfset c_add1 = cadd5>
					<cfelseif getcust.add2 eq "">
						<cfset c_add2 = cadd5>
					<cfelseif getcust.add3 eq "">
						<cfset c_add3 = cadd5>
					<cfelseif getcust.add4 eq "">
						<cfset c_add4 = cadd5>
					<cfelse>
						<cfset c_add5 = cadd5>
					</cfif>
				</cfif>
            <cfelse>
                <cfquery name="getCollectAddr" datasource="#dts#">
                    select * from collect_address where code = '#T_CCode#'
                </cfquery>
    
                <cfset CCode = getCollectAddr.code>
                <cfset c_name = getCollectAddr.name>
                <cfset c_name2 = "">
                <cfset c_add1 = getCollectAddr.add1>
                <cfset c_add2 = getCollectAddr.add2>
                <cfset c_add3 = getCollectAddr.add3>
                <cfset c_add4 = getCollectAddr.add4>
                <cfset c_add5 = "">
                <cfset c_attn = getCollectAddr.attn>
                <cfset c_phone = getCollectAddr.phone>
                <cfset c_fax = getCollectAddr.fax>
				<!--- ADD ON 14-10-2009 --->
				<cfif getCollectAddr.country neq "" and getCollectAddr.postalcode neq "">
					<cfset cadd5=getCollectAddr.country&" "&getCollectAddr.postalcode>
					<cfif getCollectAddr.add1 eq "">
						<cfset c_add1 = cadd5>
					<cfelseif getCollectAddr.add2 eq "">
						<cfset c_add2 = cadd5>
					<cfelseif getCollectAddr.add3 eq "">
						<cfset c_add3 = cadd5>
					<cfelseif getCollectAddr.add4 eq "">
						<cfset c_add4 = cadd5>
					<cfelse>
						<cfset c_add5 = cadd5>
					</cfif>
				</cfif>
            </cfif>
        <cfelse>
            <cfif ttype eq 'Create'>
                <cfset CCode = "">
                <cfset c_name = "">
                <cfset c_name2 = "">
                <cfset c_add1 = "">
                <cfset c_add2 = "">
                <cfset c_add3 = "">
                <cfset c_add4 = "">
                <cfset c_add5 = "">
                <cfset c_attn = "">
                <cfset c_phone = "">
                <cfset c_fax = "">
            <cfelse>
                <cfset CCode = "">
                <cfset c_name = getitem.rem16>
                <cfset c_name2 = getitem.rem17>
                <cfset c_add1 = getitem.rem18>
                <cfset c_add2 = getitem.rem19>
                <cfset c_add3 = getitem.rem20>
                <cfset c_add4 = getitem.rem21>
                <cfset c_add5 = getitem.rem22>
                <cfset c_attn = getitem.rem23>
                <cfset c_phone = getitem.rem24>
                <cfset c_fax = getitem.rem25>
            </cfif>
        </cfif>
	</cfif>

<body>
  	<h4>
	<cfif alcreate eq 1>
		<cfif getgeneralinfo.invoneset neq '1' and tran eq 'INV'>
			<a href="transaction0.cfm?tran=#tran#">Create New #tranname#</a>
		<cfelse>
			<a href="transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&first=0">Create New #tranname#</a>
		</cfif> ||
	</cfif>
	<a href="transaction.cfm?tran=#tran#">List all #tranname#</a> ||
	<a href="stransaction.cfm?tran=#tran#&searchtype=&searchstr=">Search For #tranname#</a>
	<!---
	<cfif tran eq "SO" and hcomid eq "MSD">
	  || <a href="transaction_report.cfm?type=10">#tranname# Reports</a>
	</cfif>--->
  	</h4>

<form name="invoicesheet" action="" method="post">
    <input type="hidden" name="type" value="Edit">
    <input type="hidden" name="tran" value="#listfirst(tran)#">
    <input type="hidden" name="refno" value="#listfirst(refno)#">

	<cfif invset neq 0>
      	<input type="hidden" name="invset" value="#listfirst(invset)#">
      	<input type="hidden" name="tranarun" value="#listfirst(tranarun)#">
    </cfif>
	
	<input name="nexttranno" type="hidden" value="#nexttranno#">
	
	<table align="center" class="data" cellspacing="0">
	<tr>
		<th width="15%" colspan="3">#tranname# No</th>
		<td width="35%"><h3>#nexttranno#</h3></td>
		<th width="15%" colspan="3">Type</th>
		<td width="35%"><h2>Edit #tranname#</h2></td>
	</tr>
	<tr>
		<th colspan="3">#tranname# Date</th>
		<td><input type="text" name="invoicedate" value="#dateformat(nDateCreate,"dd/mm/yyyy")#" validate="eurodate" size="10" maxlength="10">
			<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(invoicedate);"> 
			(DD/MM/YYYY)
		</td>
		<th colspan="3">Last #tranname# No</th>
		<td></td>
	</tr>
    <cfif getGeneralInfo.transactiondate eq 'Y'>
    <tr>
    <th colspan="3">Transaction Date</th>
		<td><input type="text" name="transactiondate" value="#dateformat(nDateCreate2,"dd/mm/yyyy")#" validate="eurodate" size="10" maxlength="10">
			<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(transactiondate);"> 
			(DD/MM/YYYY)
		</td>
    </tr>
    </cfif>
	<tr>
		<th colspan="3">#ptype1# No</th>
		<td>
			<!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i"> --->	<!--- EDITED ON 16-06-2009 --->
			<cfif getGeneralInfo.suppcustdropdown eq "1">
            
				<select name="custno" id="custno" onChange="updateDetails(this.value);">
          			<option value="">Choose a #ptype1#</option>
          			<cfloop query="getcustsupp">
            			<option value="#trim(xcustno)#" <cfif trim(custno) eq trim(xcustno)>selected</cfif>><cfif lcase(HcomID) eq "glenn_i" or lcase(HcomID) eq "glenndemo_i">#name# - #xcustno#<cfelse>#xcustno# - #name#</cfif></option>
          			</cfloop>
				</select><!--- <a onMouseOver="JavaScript:this.style.cursor='hand';" ><img src="/images/find.jpg" width="20" height="14.5" onClick="javascript:ColdFusion.Window.show('findCustomer');" /><br> --->
				<cfif getGeneralInfo.filterall eq "1">
					<input type="text" name="searchcustsupp" onKeyUp="getCustSupp('#ptype1#');">
				</cfif>
                <cfif lcase(hcomid) neq "mastercare_i" and lcase(hcomid) neq "gorgeous_i">
				<a href="#ptype1#.cfm?type=Create" target="_blank">Create New #ptype1#</a>
                </cfif>
                <cfif tran eq 'RC'>
						&nbsp;<input type="checkbox" name="internalrc" id="internalrc" onClick="assignCust('dropdown');"> Internal Receiving
					</cfif>
				<br>
			<cfelse>
				<input name="custno" id="custno" type="text" value="#custno#"  size="20" maxlength="8" readonly>
				<input type="submit" name="Scust" value="Search"><br>
                <cfif lcase(hcomid) neq "mastercare_i" and lcase(hcomid) neq "gorgeous_i">
				<a href="#ptype1#.cfm?type=Create" target="_blank">Create New #ptype1#</a>
                </cfif>
                <cfif tran eq 'RC'>
						&nbsp;<input type="checkbox" name="internalrc" id="internalrc" onClick="assignCust('');"> Internal Receiving
					</cfif>
                <br>
			</cfif>
             <div id="issnoajax"></div>
			<input type="hidden" name="ptype" value="#ptype#">	
			<input name="name" type="text" size="45" maxlength="40" value="#convertquote(name)#"><br>
			<input name="name2" type="text" size="45" maxlength="40" value="#convertquote(name2)#" >
			<!--- ADD ON 30-03-2009 --->
			<input type="hidden" name="term" value="#term#">
			<input type="hidden" name="agent" value="#agent#">
			<input type="hidden" name="currcode" value="#currcode#">
		</td>
		<td colspan="3"></td>
		<td></td>
	</tr>
	<tr>
		<td colspan="8"><hr></td>
	</tr>
		<cfif tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV' or tran eq 'SAM' or tran eq 'CN' or tran eq 'DN' or tran eq 'PR' or tran eq 'RC' or tran eq 'CS' or tran eq 'QUO' or hcomid eq "kimlee_i" or lcase(HcomID) eq "bakersoven_i">
		<tr>
			<th colspan="3">Address Code</th>
			<td><input type="text" name="BCode" value="#T_BCode#" size="15"></td>
			<th colspan="3">Address Code</th>
			<td><input type="text" name="DCode" value="#T_DCode#"></td>
		</tr>
		<tr>
			<th colspan="3">Name</th>
			<td><input type="text" name="b_name" value="#convertquote(b_name)#" size="45" maxlength="45"></td>
			<th colspan="3">Name</th>
			<td><input type="text" name="d_name" value="#convertquote(d_name)#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
			<td><input type="text" name="b_name2" value="#convertquote(b_name2)#" size="45" maxlength="35"></td>
			<td colspan="3">&nbsp;</td>
			<td><input type="text" name="d_name2" value="#convertquote(d_name2)#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<th colspan="3">Bill To :</th>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="b_add1" value="#b_add1#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="b_add1" value="#b_add1#" size="45" maxlength="35">
            </cfif>
            </td>
			<th colspan="3">Delivery To :</th>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="d_add1" value="#d_add1#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="d_add1" value="#d_add1#" size="45" maxlength="40">
            </cfif>
            </td>
		</tr>
		<tr>
			<td rowspan="2" align="left" rowrap><input type="Button" name="ProfileAddr" value="Click" onClick="javascript:CopyProfileAddr()"></td>
			<td rowspan="2" align="left" rowrap>Same As Profile Address</td>
			<td rowspan="2" align="left" rowrap>&nbsp;&nbsp;&nbsp;</td>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="b_add2" value="#b_add2#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="b_add2" value="#b_add2#" size="45" maxlength="35">
            </cfif>
            </td>
			<td rowspan="2" align="left" rowrap>
            <input type="button" name="BillToAddr" value="Click" onClick="javascript:CopyProfileAddr2()"><br/>
            <input type="button" name="BillToAddr" value="Click" onClick="javascript:CopyBillAddr()"></td>
			<td rowspan="2" align="left" rowrap>Same As Profile Address<br/>Same As Profile Delivery Address</td>
			<td rowspan="2" align="left" rowrap>&nbsp;&nbsp;&nbsp;</td>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="d_add2" value="#d_add2#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="d_add2" value="#d_add2#" size="45" maxlength="35">
            </cfif>
            </td>
		</tr>
		<tr>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="b_add3" value="#b_add3#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="b_add3" value="#b_add3#" size="45" maxlength="35">
            </cfif>
            </td>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="d_add3" value="#d_add3#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="d_add3" value="#d_add3#" size="45" maxlength="35">
            </cfif>
            </td>
		</tr>
		<tr>
			<td align="left" rowrap rowspan="2"><input type="submit" name="ChgBillToAddr" value="Click"></td>
			<td align="left" rowrap rowspan="2">Change Bill To Address </td>
			<td align="left" rowrap rowspan="2">&nbsp;&nbsp;&nbsp;</td>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="b_add4" value="#b_add4#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="b_add4" value="#b_add4#" size="45" maxlength="35">
            </cfif>
            </td>
			<td align="left" rowrap rowspan="2"><input type="submit" name="ChgDeliveryAddr" value="Click"></td>
			<td align="left" rowrap rowspan="2">Change Delivery Address</td>
			<td align="left" rowrap rowspan="2">&nbsp;&nbsp;&nbsp;</td>
			<td>
             <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="d_add4" value="#d_add4#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="d_add4" value="#d_add4#" size="45" maxlength="35">
            </cfif>
            </td>
		</tr>
		<tr>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="b_add5" value="#b_add5#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="b_add5" value="#b_add5#" size="45" maxlength="35">
            </cfif>
            </td>
			<td>
            <cfif lcase(HcomID) eq "fdipx_i">
            <input type="text" name="d_add5" value="#d_add5#" size="45" maxlength="45">
            <cfelse>
            <input type="text" name="d_add5" value="#d_add5#" size="45" maxlength="35">
            </cfif>
            </td>
		</tr>
		<tr>
			<th colspan="3"><cfif lcase(HcomID) eq "ugateway_i" and tran eq "INV" >Order By :<cfelse>Attn :</cfif></th>
			<td>
            <cfif getGeneralInfo.attnddl eq 'Y'>
            <cfquery name="getattentionprofile" datasource="#dts#">
            select * from attention 
            </cfquery>
            <select name="b_attn" id="b_attn">
            <cfloop query="getattentionprofile">
            <option value="#getattentionprofile.attentionno#" <cfif getattentionprofile.attentionno eq b_attn>selected</cfif>>#getattentionprofile.attentionno# - #getattentionprofile.name#</option>
            </cfloop>
            </select>
            <cfelse>
            <input type="text" name="b_attn" value="#b_attn#" size="45" maxlength="35">
            </cfif>
            </td>
			<th colspan="3">Attn :</th>
			<td><input type="text" name="d_attn" value="#d_attn#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<th colspan="3"><cfif lcase(HcomID) eq "ugateway_i" and tran eq "INV" >Contact :<cfelse>Telephone :</cfif></th>
			<td><input type="text" name="b_phone" value="#b_phone#" size="45" maxlength="35"></td>
			<th colspan="3"><cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">Heading<cfelseif lcase(hcomid) eq "winbells_i">Phone Number<cfelseif lcase(hcomid) eq "chemline_i">HP<cfelse>Telephone</cfif> :</th>
			<td><input type="text" name="d_phone" value="#d_phone#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<th colspan="3"><cfif lcase(hcomid) eq "mastercare_i">HP<cfelse>Tel (2)</cfif> :</th>
			<td><input type="text" name="b_phone2" value="#b_phone2#" size="45" maxlength="35"></td>
			<th colspan="3">Fax :</th>
			<td><input type="text" name="d_fax" value="#d_fax#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<th colspan="3">Fax :</th>
			<td><input type="text" name="b_fax" value="#b_fax#" size="45" maxlength="35"></td>
            <cfif lcase(hcomid) eq 'ugateway_i'>
            <cfif  tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
            <th colspan="3">VIA :</th>
            <td>
            <select name="via" id="via" >
            <option value="">Please Select VIA</option>
            <option value="air" <cfif via eq "air">selected </cfif>>By Air</option>
            <option value="post" <cfif via eq "post">selected </cfif>>By Post</option>
            <option value="mail"<cfif via eq "mail">selected </cfif>>By Mail</option>
            <option value="agent">By Sales Agent</option>
            </select>
            </td>
            </cfif>
             </cfif>
		</tr>
        <tr>
			<th colspan="3">Email :</th>
			<td><input type="text" name="b_email" value="#b_email#" size="45" maxlength="80"></td>
		</tr>
		<cfelse>
		<tr>
			<th colspan="3">Address Code</th>
			<td><input type="text" name="BCode" value="#T_BCode#" size="15"><input type="hidden" name="DCode" value="#T_DCode#"></td>
		</tr>
		<tr>
			<th colspan="3">Name</th>
			<td><input type="text" name="b_name" value="#convertquote(b_name)#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
			<td><input type="text" name="b_name2" value="#convertquote(b_name2)#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<th colspan="3">Bill To :</th>
			<td><input type="text" name="b_add1" value="#b_add1#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<td rowspan="2" align="left" rowrap><input type="Button" name="ProfileAddr" value="Click" onClick="javascript:CopyProfileAddr()"></td>
			<td rowspan="2" align="left" rowrap>Same As Profile Address </td>
			<td rowspan="2" align="left" rowrap>&nbsp;&nbsp;&nbsp;</td>
			<td><input type="text" name="b_add2" value="#b_add2#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<td><input type="text" name="b_add3" value="#b_add3#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<td align="left" rowrap rowspan="2"><input type="submit" name="ChgBillToAddr" value="Click"></td>
			<td align="left" rowrap rowspan="2">Change Bill To Address </td>
			<td align="left" rowrap rowspan="2">&nbsp;&nbsp;&nbsp;</td>
			<td><input type="text" name="b_add4" value="#b_add4#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<td><input type="text" name="b_add5" value="#b_add5#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<th colspan="3">Attn :</th>
			<td>
            
            <input type="text" name="b_attn" value="#b_attn#" size="45" maxlength="35">
            </td>
		</tr>
		<tr>
			<th colspan="3">Telephone :</th>
			<td><input type="text" name="b_phone" value="#b_phone#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<th colspan="3">Tel (2) :</th>
			<td><input type="text" name="b_phone2" value="#b_phone2#" size="45" maxlength="35"></td>
		</tr>
		<tr>
			<th colspan="3">Fax :</th>
			<td><input type="text" name="b_fax" value="#b_fax#" size="45" maxlength="35"></td>
		</tr>
        <tr>
			<th colspan="3">Email :</th>
			<td><input type="text" name="b_email" value="#b_email#" size="45" maxlength="35"></td>
		</tr>
		</cfif>
		<!--- Modified On 29-04-2009 --->
		<cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
        	<cfif  tran eq 'PO' or tran eq 'SO' or tran eq 'DO' or tran eq 'INV'>
                <tr>
                    <td colspan="100%"><hr></td>
                </tr>
                <tr>
                    <th colspan="3">Address Code</th>
                    <td><input type="text" name="CCode" value="#T_CCode#" size="15"></td>
                </tr>
                <tr>
                    <th colspan="3">Name</th>
                    <td><input type="text" name="c_name" value="#c_name#" size="45" maxlength="45"></td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                    <td><input type="text" name="c_name2" value="#c_name2#" size="45" maxlength="35"></td>
                </tr>
                <tr>
                    <th colspan="3">Collect From :</th>
                    <td><input type="text" name="c_add1" value="#c_add1#" size="45" maxlength="35"></td>
                </tr>
                <tr>
                    <td rowspan="2" align="left" rowrap><input type="Button" name="ProfileAddr" value="Click" onClick="javascript:CopyCollectAddr();"></td>
                    <td rowspan="2" align="left" rowrap>Same As Profile Address </td>
                    <td rowspan="2" align="left" rowrap>&nbsp;&nbsp;&nbsp;</td>
                    <td><input type="text" name="c_add2" value="#c_add2#" size="45" maxlength="35"></td>
                </tr>
                <tr>
                    <td><input type="text" name="c_add3" value="#c_add3#" size="45" maxlength="35"></td>
                </tr>
                <tr>
                    <td align="left" rowrap rowspan="2"><input type="submit" name="ChgCollectFromAddr" value="Click"></td>
                    <td align="left" rowrap rowspan="2">Change Collect From Address </td>
                    <td align="left" rowrap rowspan="2">&nbsp;&nbsp;&nbsp;</td>
                    <td><input type="text" name="c_add4" value="#c_add4#" size="45" maxlength="35"></td>
                </tr>
                <tr>
                    <td><input type="text" name="c_add5" value="#c_add5#" size="45" maxlength="35"></td>
                </tr>
                <tr>
                    <th colspan="3">Attn :</th>
                    <td>
                    <input type="text" name="c_attn" value="#c_attn#" size="45" maxlength="35">
                    </td>
                </tr>
                <tr>
                    <th colspan="3">Telephone :</th>
                    <td><input type="text" name="c_phone" value="#c_phone#" size="45" maxlength="35"></td>
                </tr>
                <tr>
                    <th colspan="3">Fax :</th>
                    <td><input type="text" name="c_fax" value="#c_fax#" size="45" maxlength="35"></td>
                </tr>
            <cfelse>
            	<input type="hidden" name="CCode" value="" size="15">
			</cfif>
		<cfelse>
			<input type="hidden" name="CCode" value="" size="15">
		</cfif>
	<tr>
		<td colspan="8" align="center">
		<cfif xrelated eq 1>
			<input name="recover" type="checkbox" value="1">
			<input name="related" type="hidden" value="1">
			Recover related #xtype#<br>
		</cfif>
		<input name="submit" type="submit" value="Save & Continue">
		<input name="p2" type="button" value="Back" onClick="redirect('P1')">
		</td>
	</tr>
  	</table>
	<input type="hidden" name="frem9" value="#frem9#">
</form>
</body></cfoutput>
<!--- <cfwindow  width="580" height="400" name="findCustomer" refreshOnShow="true"
        title="Find #ptype1#" initshow="false"
        source="/default/transaction/findCustomer.cfm?type=#ptype1#&dbtype=#ptype#&custno={custno}" /> --->

</html>