<html>
<head>
<title>Last Used No</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfquery name="getcodepatern" datasource="#dts#">
	SELECT debtorfr,debtorto,creditorfr,creditorto,custSuppNo,refnoNACC,refnoACC
    FROM gsetup;
</cfquery>
<cfquery datasource="#dts#" name="gettranname">
	SELECT lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM
	FROM GSetup
</cfquery>
<cfif isDefined("form.actionButton")>
  <cfset value = "">
  <cfset tabchr = Chr(13) & Chr(10)>
  <cfquery name="getmax" datasource="#dts#">
        SELECT max(counter) as maxcount
        FROM refnoset
        WHERE type = '#form.refnotype#'
    </cfquery>
  <cfset nextcounter = getmax.maxcount + 1>
  <cfquery name="insert" datasource="#dts#">
        INSERT INTO refnoset (type,refnocode,refnocode2,lastusedno,refnoused,presuffixuse,counter)
        VALUES ('#form.refnotype#','','','','0','0','#nextcounter#')
    </cfquery>
</cfif>
<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
  <PARAM NAME="FieldDelim" VALUE="|">
  <PARAM NAME="UseHeader" VALUE="True">
</OBJECT>
<script for="feedcontact1" event="ondatasetcomplete">show_reply(this.recordset);</script>
<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact2" WIDTH="0" HEIGHT="0">
  <PARAM NAME="FieldDelim" VALUE="|">
  <PARAM NAME="UseHeader" VALUE="True">
</OBJECT>
<script for="feedcontact2" event="ondatasetcomplete">show_info(this.recordset);</script>
<script type='text/javascript' src='/ajax/core/engine.js'></script>
<script type='text/javascript' src='/ajax/core/util.js'></script>
<script type='text/javascript' src='/ajax/core/settings.js'></script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type="text/javascript" src="/scripts/prototypenew.js" ></script>
<cfoutput>
  <script language="JavaScript">

function dataupdate(input_type,type,counter,fieldname,fieldvalue){
	var custsuppno = '#getcodepatern.custSuppNo#';
	var lenofvalue = fieldvalue.length;
	var controlterm = true;
	if (type == "CUST" || type == "SUPP")
	{
	if (custsuppno == 1)
	{

	if (fieldname == "refnocode" && lenofvalue != 4)
	{
	controlterm = false;
	}

	if (fieldname == "lastUsedNo" && lenofvalue != 3)
	{
	controlterm = false;
	}

	}

	if (custsuppno != 1)
	{

	if (fieldname == "refnocode" && lenofvalue != 0)
	{
	controlterm = false;
	}

	if (fieldname == "lastUsedNo" && lenofvalue != 8)
	{
	controlterm = false;
	}

	}

	}

	if (controlterm == true)
	{

	if (confirm("Are you sure you want to Edit?")) {
		var x = document.getElementById(fieldname + '_' + type + '_' + counter);
		x.style.backgroundColor  = 'red';
 		document.all.feedcontact1.dataurl="databind/dataupdate.cfm?input_type=" + input_type + "&type=" + type + "&counter=" + counter + "&fieldname=" + fieldname + "&fieldvalue=" + fieldvalue;
		//prompt("D",document.all.feedcontact1.dataurl);
		document.all.feedcontact1.charset=document.charset;
		document.all.feedcontact1.reset();
	}
	}
	else
	{
	var msg = "The "+type+" no format is not correct";
	alert(msg);
	}
 }

 function show_reply(rset){
 	rset.MoveFirst();
 	var type = rset.fields("type").value;
 	var counter = rset.fields("counter").value;
 	var fieldname = rset.fields("fieldname").value;
 	var x = document.getElementById(fieldname + '_' + type + '_' + counter);
 	x.style.backgroundColor  = '';
 }

function submitaction(){
 	if(document.form1.refnotype.value == ''){
 		alert("Please Select A Type!");
 		return false;
 	}
 }

function show_info(rset){
 	rset.MoveFirst();
 	window.location.reload();
 }

function deleteAction(type,counter){
	if (confirm("Are you sure you want to Delete?")) {
	var ajaxurl = "/default/admin/deleteLastUsedNo.cfm?counter="+counter+"&type="+type;
	new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('deleteajaxfield').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){
		alert('Error Update'); },

		onComplete: function(transport){
			this.location="/default/admin/LastUsedNo.cfm";
        }
      })

		<!---window.open("/default/admin/deleteLastUsedNo.cfm?counter="+counter+"&type="+type)--->
	}
}

function updateRefNoCode(type,counter,fieldValue){
	if (confirm("Are you sure you want to Edit?")) {

		var ajaxurl = "/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=refnocode";
		new Ajax.Request(ajaxurl,
		  {
			method:'get',
			onSuccess: function(getdetailback){
			document.getElementById('updateajaxfield').innerHTML = trim(getdetailback.responseText);
			},
			onFailure: function(){
			alert('Error Update'); },

			onComplete: function(transport){
				this.location="/default/admin/LastUsedNo.cfm";
			}
		  })

		<!---window.open("/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=refnocode");--->
	}
}

function updateLastUsedNo(type,counter,fieldValue){
	if (confirm("Are you sure you want to Edit?")) {

		var ajaxurl = "/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=lastUsedNo";
		new Ajax.Request(ajaxurl,
		  {
			method:'get',
			onSuccess: function(getdetailback){
			document.getElementById('updateajaxfield').innerHTML = trim(getdetailback.responseText);
			},
			onFailure: function(){
			alert('Error Update'); },

			onComplete: function(transport){
				this.location="/default/admin/LastUsedNo.cfm";
			}
		  })

		<!---window.open("/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=lastUsedNo");--->
	}
}

function updateRefNoCode2(type,counter,fieldValue){
	if (confirm("Are you sure you want to Edit?")) {
		var ajaxurl = "/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=refnocode2";
		new Ajax.Request(ajaxurl,
		  {
			method:'get',
			onSuccess: function(getdetailback){
			document.getElementById('updateajaxfield').innerHTML = trim(getdetailback.responseText);
			},
			onFailure: function(){
			alert('Error Update'); },

			onComplete: function(transport){
				this.location="/default/admin/LastUsedNo.cfm";
			}
		  })

		<!---window.open("/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=refnocode2");--->
	}
}

function updatePresuffixuse(type,counter){
	if (confirm("Are you sure you want to Edit?")) {
		if(document.getElementById('presuffixuse_'+type+'_'+counter).checked){
			fieldValue = 1;
		}
		else{
			fieldValue = 0;
		}
		var ajaxurl = "/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=presuffixuse";
		new Ajax.Request(ajaxurl,
		  {
			method:'get',
			onSuccess: function(getdetailback){
			document.getElementById('updateajaxfield').innerHTML = trim(getdetailback.responseText);
			},
			onFailure: function(){
			alert('Error Update'); },

			onComplete: function(transport){
				this.location="/default/admin/LastUsedNo.cfm";
			}
		  })

		<!---window.open("/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=presuffixuse");--->
	}
}

function updateRefNoUsed(type,counter){
	if (confirm("Are you sure you want to Edit?")) {
		if(document.getElementById('refnoused_'+type+'_'+counter).checked){
			fieldValue = 1;
		}
		else{
			fieldValue = 0;
		}

		var ajaxurl = "/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=refnoused";
		new Ajax.Request(ajaxurl,
		  {
			method:'get',
			onSuccess: function(getdetailback){
			document.getElementById('updateajaxfield').innerHTML = trim(getdetailback.responseText);
			},
			onFailure: function(){
			alert('Error Update'); },

			onComplete: function(transport){
				this.location="/default/admin/LastUsedNo.cfm";
			}
		  })
		<!---window.open("/default/admin/updateInfo.cfm?counter="+counter+"&type="+type+"&fieldValue="+fieldValue+"&fieldname=refnoused");--->
	}
}

function updateField(input_type,fieldname,fieldvalue){

	document.getElementById(fieldname).style.backgroundColor  = 'red';
	DWREngine._execute(_maintenanceflocation, null, 'updateField', input_type, fieldname,escape(fieldvalue), showResult2);
}

function showResult2(FieldObject){
	document.getElementById(FieldObject.FIELDNAME).style.backgroundColor  = '';
}
</script>
</cfoutput>
</head>
<cfquery name="getInfo" datasource="#dts#">
	SELECT * from refnoset
	ORDER BY type, counter
</cfquery>
<cfquery name="getrefnotype" datasource="#dts#">
	select type as refnotype
	from refnoset
	group by type
</cfquery>
<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<body>
<h4>
  <cfif getpin2.h5110 eq "T">
    <a href="comprofile.cfm">Company Profile</a>
  </cfif>
  <cfif getpin2.h5120 eq "T">
    || Last Used No
  </cfif>
  <cfif getpin2.h5130 eq "T">
    || <a href="transaction.cfm">Transaction Setup</a>
  </cfif>
  <cfif husergrpid eq "super">
    ||<a href="modulecontrol.cfm">Module Control</a>
  </cfif>
  <cfif getpin2.h5150 eq "T">
    || <a href="userdefine.cfm">User Defined</a>
  </cfif>
  <cfif getpin2.h5160 eq "T">
    ||<a href="dealer_menu/dealer_menu.cfm">Dealer Menu</a>
  </cfif>
  <!---<cfif getpin2.h5170 eq "T">
    ||<a href="transaction_menu/transaction_menu.cfm">Transaction Menu</a>
  </cfif>
  <cfif getpin2.h5180 eq "T">
    ||<a href="userdefineformula.cfm">User Define - Formula</a>
  </cfif>
 <cfif getpin2.h5140 eq "T">
    || <a href="Accountno.cfm">AMS Accounting Default Setup</a>
  </cfif>
  <cfif getpin2.h5130 eq "T">
    ||<a href="displaysetup.cfm">Listing Setup</a>
  </cfif>
  <cfif getpin2.h5130 eq "T">
    ||<a href="displaysetup2.cfm">Display Detail</a>
  </cfif>--->
</h4>
<h1>General Setup - Transaction Last Used Number</h1>
<form name="form1" action="LastUsedNo.cfm" method="post">
  <table width="570" align="center" class="data">
    <cfif HcomID neq "pnp_i">
      <tr>
        <td colspan="2"><div align="center"><strong>Add New Set of Reference No :</strong></div></td>
      </tr>
      <tr>
        <th>Type of Reference No Set :</th>
        <td><select name="refnotype">
            <option value="">Choose a Type</option>
            <cfloop query="getrefnotype">
              <cfif getrefnotype.refnotype eq "INV">
                <cfset refnoname = "Invoice">
                <cfelseif getrefnotype.refnotype eq "RC">
                <cfset refnoname = "Purchase Receive">
                <cfelseif getrefnotype.refnotype eq "PR">
                <cfset refnoname = "Purchase Return">
                <cfelseif getrefnotype.refnotype eq "DO">
                <cfset refnoname = "Delivery Order">
                <cfelseif getrefnotype.refnotype eq "CS">
                <cfset refnoname = "Cash Sales">
                <cfelseif getrefnotype.refnotype eq "CN">
                <cfset refnoname = "Credit Note">
                <cfelseif getrefnotype.refnotype eq "DN">
                <cfset refnoname = "Debit Note">
                <cfelseif getrefnotype.refnotype eq "ISS">
                <cfset refnoname = "Issue">
                <cfelseif getrefnotype.refnotype eq "PO">
                <cfset refnoname = "Purchase Order">
                <cfelseif getrefnotype.refnotype eq "SO">
                <cfset refnoname = "Sales Order">
                <cfelseif getrefnotype.refnotype eq "QUO">
                <cfset refnoname = "Quotation">
                <cfelseif getrefnotype.refnotype eq "ASSM">
                <cfset refnoname = "Assembly">
                <cfelseif getrefnotype.refnotype eq "TR">
                <cfset refnoname = "Transfer">
                <cfelseif getrefnotype.refnotype eq "OAI">
                <cfset refnoname = "Adjustment Increase">
                <cfelseif getrefnotype.refnotype eq "OAR">
                <cfset refnoname = "Adjustment Reduce">
                <cfelseif getrefnotype.refnotype eq "SAM">
                <cfset refnoname = "Sample">
                <cfelseif getrefnotype.refnotype eq "CUST">
                <cfset refnoname = "Customer No.">
                <cfelseif getrefnotype.refnotype eq "SUPP">
                <cfset refnoname = "Supplier No.">
                <cfelseif getrefnotype.refnotype eq "CT">
                <cfset refnoname = "Consignment Note">
                <cfelseif getrefnotype.refnotype eq "RQ">
                <cfset refnoname = "Purchase Requisition">
                <cfelseif getrefnotype.refnotype eq "PACK">
                <cfset refnoname = "Packing List">
              </cfif>
              <cfoutput>
                <option value="#getrefnotype.refnotype#">#refnoname#</option>
              </cfoutput>
            </cfloop>
          </select>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <input type="Submit" value="Add" onClick="submitaction();">
          <input type="hidden" name="actionButton" id="actionButton" value=""></td>
      </tr>
      <tr>
        <td height="5"></td>
      </tr>
    </cfif>
    <tr>
      <td colspan="2"><div align="center"><strong>Transaction Last Used Number</strong></div></td>
    </tr>
    <cfoutput>
      <cfloop query="getInfo">
        <cfif getInfo.type eq "INV">
          <cfset refnoname = gettranname.lINV>
          <cfelseif getInfo.type eq "RC">
          <cfset refnoname = gettranname.lRC>
          <cfelseif getInfo.type eq "PR">
          <cfset refnoname = gettranname.lPR>
          <cfelseif getInfo.type eq "DO">
          <cfset refnoname = gettranname.lDO>
          <cfelseif getInfo.type eq "CS">
          <cfset refnoname = gettranname.lCS>
          <cfelseif getInfo.type eq "CN">
          <cfset refnoname = gettranname.lCN>
          <cfelseif getInfo.type eq "DN">
          <cfset refnoname = gettranname.lDN>
          <cfelseif getInfo.type eq "ISS">
          <cfset refnoname = "Issue">
          <cfelseif getInfo.type eq "PO">
          <cfset refnoname = gettranname.lPO>
          <cfelseif getInfo.type eq "SO">
          <cfset refnoname = gettranname.lSO>
          <cfelseif getInfo.type eq "QUO">
          <cfset refnoname = gettranname.lQUO>
          <cfelseif getInfo.type eq "ASSM">
          <cfset refnoname = "Assembly">
          <cfelseif getInfo.type eq "TR">
          <cfset refnoname = "Transfer">
          <cfelseif getInfo.type eq "OAI">
          <cfset refnoname = "Adjustment Increase">
          <cfelseif getInfo.type eq "OAR">
          <cfset refnoname = "Adjustment Reduce">
          <cfelseif getInfo.type eq "SAM">
          <cfset refnoname = gettranname.lSAM>
          <cfelseif getInfo.type eq "CUST">
          <cfset refnoname = "Customer No.">
          <cfelseif getInfo.type eq "SUPP">
          <cfset refnoname = "Supplier No.">
          <cfelseif getInfo.type eq "BARC">
          <cfset refnoname = "Bar Code.">
          <cfelseif getInfo.type eq "CT">
          <cfset refnoname = "Consignment Note">
          <cfelseif getInfo.type eq "RQ">
          <cfset refnoname = "Purchase Requisition">
          <cfelseif getInfo.type eq "PACK">
          <cfset refnoname = "Packing List">
        </cfif>
        <tr>
          <th>#refnoname#
            <cfif lcase(hcomid) eq "kjcpl_i">
              <cfif getInfo.type eq 'INV'>
                <cfif getInfo.counter eq "1">
                  - B
                  <cfelseif getInfo.counter eq "2">
                  - G
                  <cfelseif getInfo.counter eq "3">
                  - S
                  <cfelseif getInfo.counter eq "4">
                  - A
                  <cfelseif getInfo.counter eq "5">
                  - M
                  <cfelse>
                  #getInfo.counter#
                </cfif>
              </cfif>
              <cfif getInfo.type eq 'DO'>
                <cfif getInfo.counter eq "1">
                  - M
                  <cfelse>
                  #getInfo.counter#
                </cfif>
              </cfif>
              <cfelseif lcase(hcomid) eq "mlpl_i">
              <cfif getInfo.type eq 'INV'>
                <cfif getInfo.counter eq "1">
                  - C
                  <cfelseif getInfo.counter eq "2">
                  - P
                  <cfelseif getInfo.counter eq "3">
                  - M
                  <cfelse>
                  #getInfo.counter#
                </cfif>
              </cfif>
              <cfelse>
              <cfif getInfo.counter neq "1">
                #getInfo.counter#
              </cfif>
            </cfif></th>
          <td><input name="refnocode_#getInfo.type#_#getInfo.counter#" type="text"
                    maxlength="
					<cfif (getInfo.type eq "CUST" or getInfo.type eq "SUPP" or getInfo.type eq "BARC") and getcodepatern.custsuppno eq "1">4<cfelseif (getInfo.type eq "CUST" or getInfo.type eq "SUPP" or getInfo.type eq "BARC") and getcodepatern.custsuppno eq "2">0<cfelse>15</cfif>" size="5" onKeyUp="javascript:this.value=this.value.toUpperCase();" onBlur="updateRefNoCode('#getInfo.type#','#getInfo.counter#',this.value);" value="#getInfo.refnocode#">
            /
            <cfif getInfo.type eq 'SO' or getInfo.type eq 'PO' or getInfo.type eq 'QUO' or getInfo.type eq 'SAM'>
              <input name="lastUsedNo_#getInfo.type#_#getInfo.counter#" type="text" maxlength="#getcodepatern.refnoNACC#" size="15" onKeyUp="javascript:this.value=this.value.toUpperCase();" onBlur="updateLastUsedNo('#getInfo.type#','#getInfo.counter#',this.value);" value="#getInfo.lastUsedNo#">
              <cfelse>
              <input name="lastUsedNo_#getInfo.type#_#getInfo.counter#" type="text" maxlength="<cfif (getInfo.type eq "CUST" or getInfo.type eq "SUPP") and getcodepatern.custsuppno eq "1">3<cfelseif (getInfo.type eq "CUST" or getInfo.type eq "SUPP") and getcodepatern.custsuppno eq "2">8<cfelse>#getcodepatern.refnoACC#</cfif>" size="15" onKeyUp="javascript:this.value=this.value.toUpperCase();" onBlur="updateLastUsedNo('#getInfo.type#','#getInfo.counter#',this.value);" value="#getInfo.lastUsedNo#">
            </cfif>
            /
            <input name="refnocode2_#getInfo.type#_#getInfo.counter#" type="text" maxlength="<cfif getInfo.type eq "CUST" or getInfo.type eq "SUPP">0<cfelse>#getcodepatern.refnoNACC#</cfif>" size="5" onKeyUp="javascript:this.value=this.value.toUpperCase();" onBlur="updateRefNoCode2('#getInfo.type#','#getInfo.counter#',this.value);" value="#getInfo.refnocode2#">

            <input name="presuffixuse_#getInfo.type#_#getInfo.counter#" id="presuffixuse_#getInfo.type#_#getInfo.counter#" type="checkbox" value="#getInfo.presuffixuse#" onChange="updatePresuffixuse('#getInfo.type#','#getInfo.counter#');" <cfif getInfo.presuffixuse eq '1'>checked</cfif>>
            /
            <input name="refnoused_#getInfo.type#_#getInfo.counter#" id="refnoused_#getInfo.type#_#getInfo.counter#" type="checkbox" value="#getInfo.refnoused#" onChange="updateRefNoUsed('#getInfo.type#','#getInfo.counter#');" <cfif getInfo.refnoused eq '1'>checked</cfif>>
            <cfif getInfo.type neq "INV" and getInfo.counter neq 1>
              <img src="/images/userdefinedmenu/idelete.gif" alt="Delete" style="cursor: hand;" onClick="deleteAction('#getInfo.type#','#getInfo.counter#');">
              <cfelseif getInfo.type eq "INV" and getInfo.counter gt 6>
              <img src="/images/userdefinedmenu/idelete.gif" alt="Delete" style="cursor: hand;" onClick="deleteAction('#getInfo.type#','#getInfo.counter#');">
            </cfif></td>
        </tr>
      </cfloop>

      <cfif checkcustom.customcompany eq "Y">
        <cfquery name="getlotno" datasource="#dts#">
				select lotno,lotnorun from gsetup
			</cfquery>
        <tr>
          <td colspan="2"><div align="center"><strong>Last Used Lot Number</strong></div></td>
        </tr>
        <tr>
          <th>Lot Number</th>
          <td><input type="text" name="lotno" id="lotno" value="#getlotno.lotno#" onBlur="updateField('txtbox',this.id,this.value);">
            <input type="checkbox" name="lotnorun" id="lotnorun" value="#getlotno.lotnorun#" onChange="updateField('chkbox',this.id,this.value);" <cfif getlotno.lotnorun eq '1'>checked</cfif>></td>
        </tr>
      </cfif>
      <cfif lcase(hcomid) eq "fdipx_i" or lcase(hcomid) eq "ulp_i">
        <cfquery name="getjoborderno" datasource="#dts#">
				select joborderno,jobordernorun from gsetup
			</cfquery>
        <tr>
          <td colspan="2"><div align="center"><strong>Last Used Job Order No</strong></div></td>
        </tr>
        <tr>
          <th>Job Order No</th>
          <td><input type="text" name="joborderno" id="joborderno" value="#getjoborderno.joborderno#" onBlur="updateField('txtbox',this.id,this.value);">
            <input type="checkbox" name="jobordernorun" id="jobordernorun" value="#getjoborderno.jobordernorun#" onChange="updateField('chkbox',this.id,this.value);" <cfif getjoborderno.jobordernorun eq '1'>checked</cfif>></td>
        </tr>
      </cfif>


    </cfoutput>
  </table>
  <div id="updateajaxfield"></div>
  <div id="deleteajaxfield"></div>
</form>
</body>
</html>