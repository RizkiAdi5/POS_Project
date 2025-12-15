<cfajaximport tags="cfform">
<cfajaximport tags="cfwindow,cflayout-tab"> 
<cfinclude template="/CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Vehicles Page</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type='text/javascript' src='/ajax/core/engine.js'></script>
<script type='text/javascript' src='/ajax/core/util.js'></script>
<script type='text/javascript' src='/ajax/core/settings.js'></script>
<script type="text/javascript" src="/scripts/jscripts/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript" src="/scripts/highslide/highslide.js"></script>
<link rel="stylesheet" type="text/css" href="/scripts/highslide/highslide.css" />
<link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>

<cfquery name='getgsetup' datasource='#dts#'>
  Select * from gsetup
</cfquery>

<script type="text/javascript">
//<![CDATA[
hs.registerOverlay({
	html: '<div class="closebutton" onclick="return hs.close(this)" title="Close"></div>',
	position: 'top right',
	fade: 2 // fading the semi-transparent overlay looks bad in IE
});


hs.graphicsDir = '/scripts/highslide/graphics/';
hs.wrapperClassName = 'borderless';
//]]>
</script>



<script language="javascript" type="text/javascript" src="/scripts/collapse_expand_single_item.js"></script>
<script language='JavaScript'>
function selectlist(custno,fieldtype){
			if (custno =='Mr'){
			var custno1='male'	
			}
			else{
			var custno1='female'	
			}
			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++) 
			{
        	if (custno1==document.getElementById(fieldtype).options[idx].value) 
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		} 
			
									}

function imposeMaxLength(Object, MaxLen)
{
  return (Object.value.length <= MaxLen);
}

	function getcustomerdetail()
	{
	var customerurl = 'addvehicleAjax.cfm?custno='+document.getElementById('custcode').value;
	ajaxFunction(document.getElementById('customerdetailajax'),customerurl);
	}

	function getSupp(type,option){
		var inputtext = document.CustomerForm.searchsupp.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult);	
	}
	
	function getSuppResult(suppArray){
		DWRUtil.removeAllOptions("custcode");
		DWRUtil.addOptions("custcode", suppArray,"KEY", "VALUE");
	}
	
	function getCustSupp2(custno,custname){
				myoption = document.createElement("OPTION");
				myoption.text = custno + " - " + custname;
				myoption.value = custno;
				document.CustomerForm.custcode.options.add(myoption);
				var indexvalue = document.getElementById("custcode").length-1;
				document.getElementById("custcode").selectedIndex=indexvalue;
				getcustomerdetail();
		}

	function test_prefix(form,field,value)
	{
		
		
		
		var allNum = "";
		var chkVal = allNum;
		var prsVal = parseInt(allNum);
		
		var item1 = value;
		var item2 = '<cfoutput>#getgsetup.debtorfr#</cfoutput>'; 
		var item3 = '<cfoutput>#getgsetup.debtorto#</cfoutput>'; 		
	
		var checkOK = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		var allValid = true;
		var decPoints = 0;
		var allNum = "";
		
		for (i = 0;  i < item1.length;  i++)
		{
		ch = item1.charAt(i);
		for (j = 0;  j < checkOK.length;  j++)
		if (ch == checkOK.charAt(j))
		break;
		if (j == checkOK.length)
		{
		allValid = false;
		break;
		}
		if (ch != ",")
		allNum += ch;
		
		}
		if (!allValid)
		{
		return false;
		}
				
		for (var i = 0; i<value.length; i++)
		{		
		
    	if (item1.charCodeAt(i) < item2.charCodeAt(i) || item1.charCodeAt(i) > item3.charCodeAt(i)){		

		return false;
		
		}
		} 
		
		return true;
				
	}
	function addOption(selectbox,text,value )
{
var optn = document.createElement("OPTION");
optn.text = text;
optn.value = value;
selectbox.options.add(optn);
}
	
	function test_prefix1(form,field,value)
	{
		var allNum = "";
		var chkVal = allNum;
		var prsVal = parseInt(allNum);
		
		var item1 = value;
		var item2 = '<cfoutput>#getgsetup.creditorfr#</cfoutput>'; 
		var item3 = '<cfoutput>#getgsetup.creditorto#</cfoutput>'; 		
	
		var checkOK = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		var allValid = true;
		var decPoints = 0;
		var allNum = "";
		
		for (i = 0;  i < item1.length;  i++)
		{
		ch = item1.charAt(i);
		for (j = 0;  j < checkOK.length;  j++)
		if (ch == checkOK.charAt(j))
		break;
		if (j == checkOK.length)
		{
		allValid = false;
		break;
		}
		if (ch != ",")
		allNum += ch;
		
		}
		if (!allValid)
		{
		return false;
		}
				
		for (var i = 0; i<value.length; i++)
		{		
		
    	if (item1.charCodeAt(i) < item2.charCodeAt(i) || item1.charCodeAt(i) > item3.charCodeAt(i)){		

		return false;
		
		}
		} 
		
		return true;
				
	}
	
	function test_suffix(form,field,value)
{
		
		// require that at least one character be entered
		if (value.length < 3)
		{
		return false;
		}
		
		if (value == '000')
		{
		return false;
		}
		
		return true;
}


</script>
</head>



<!--- Control The Decimal Point --->
<cfquery name='getgsetup2' datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_UPrice = '.'>

<cfloop index='LoopCount' from='1' to='#iDecl_UPrice#'>
  <cfset stDecl_UPrice = stDecl_UPrice & '_'>
</cfloop>

<!--- Add On 09-03-2010 --->
<cfquery name="getbrand" datasource="#dts#">
	select brand,desp from brand order by brand
</cfquery>

<body>
<cfoutput>
	<cfif url.type eq 'Edit'>
		<cfquery datasource='#dts#' name='getitem'>
			Select * from vehicles where entryno='#url.entryno#'
	  	</cfquery>
		
		<cfset entryno=getitem.entryno>
	  	<cfset xcustcode=getitem.custcode>
	  	<cfset custname=getitem.custname>
	  	<cfset Add1=getitem.Add1>
        <cfset Add2=getitem.Add2>
	  	<cfset Add3=getitem.Add3>
        <cfset Add4=getitem.Add4>
	  	<cfset postalcode=getitem.postalcode>
	  	<cfset Email=getitem.Email>
	  	<cfset phone=getitem.phone>
	  	<cfset Hp=getitem.Hp>
        <cfset memberid=getitem.memberid>
	  	<cfset gender=getitem.gender>
	  	<cfset contactperson =getitem.contactperson>
        <cfset contact =getitem.contact>
	  	<cfset xmake=getitem.make>
	  	<cfset xmodel=getitem.model>
	  	<cfset engineno=getitem.engineno>
	  	<cfset chasisno=getitem.chasisno>
	  	<cfset xcapacity=getitem.capacity>
        <cfset xcolour=getitem.colour>
	  	<cfset regyear=getitem.regyear>
        <cfset lastmileage = getitem.lastmileage>
        <cfset nextmileage = getitem.nextmileage>
        <cfset HONORIFIC = getitem.HONORIFIC>
         
        <cfif getitem.lastserdate eq '0000-00-00'>
        <cfset lastserdate=''>
        <cfelse>
	  	<cfset lastserdate=dateformat(getitem.lastserdate,'DD/MM/YYYY')>
        </cfif>
        <cfif getitem.nextserdate eq '0000-00-00'>
        <cfset nextserdate=''>
        <cfelse>
        <cfset nextserdate=dateformat(getitem.nextserdate,'DD/MM/YYYY')>
        </cfif>
        <cfif getitem.oriregdate eq '0000-00-00'>
        <cfset oriregdate=''>
        <cfelse>
        <cfset oriregdate=dateformat(getitem.oriregdate,'DD/MM/YYYY')>
        </cfif>
        <cfset remark=getitem.remark>
		
        <cfset mode='Edit'>
	  	<cfset title='Edit Item'>
	  	<cfset button='Edit'>
	</cfif>

	<cfif url.type eq 'Delete'>
		<cfquery datasource='#dts#' name='getitem'>
			Select * from vehicles where entryno='#url.entryno#'
	  	</cfquery>
		
		<cfset entryno=getitem.entryno>
	  	<cfset xcustcode=getitem.custcode>
	  	<cfset custname=getitem.custname>
	  	<cfset Add1=getitem.Add1>
        <cfset Add2=getitem.Add2>
	  	<cfset Add3=getitem.Add3>
        <cfset Add4=getitem.Add4>
	  	<cfset postalcode=getitem.postalcode>
	  	<cfset Email=getitem.Email>
	  	<cfset phone=getitem.phone>
	  	<cfset Hp=getitem.Hp>
        <cfset memberid=getitem.memberid>
	  	<cfset gender=getitem.gender>
	  	<cfset contactperson =getitem.contactperson>
        <cfset contact =getitem.contact>
	  	<cfset xmake=getitem.make>
	  	<cfset xmodel=getitem.model>
	  	<cfset engineno=getitem.engineno>
	  	<cfset chasisno=getitem.chasisno>
	  	<cfset xcapacity=getitem.capacity>
        <cfset xcolour=getitem.colour>
	  	<cfset regyear=getitem.regyear>
        <cfset lastmileage = getitem.lastmileage>
        <cfset nextmileage = getitem.nextmileage>
        <cfset HONORIFIC = getitem.HONORIFIC>
        <cfif getitem.lastserdate eq '0000-00-00'>
        <cfset lastserdate=''>
        <cfelse>
	  	<cfset lastserdate=dateformat(getitem.lastserdate,'DD/MM/YYYY')>
        </cfif>
        <cfif getitem.nextserdate eq '0000-00-00'>
        <cfset nextserdate=''>
        <cfelse>
        <cfset nextserdate=dateformat(getitem.nextserdate,'DD/MM/YYYY')>
        </cfif>
        <cfif getitem.oriregdate eq '0000-00-00'>
        <cfset oriregdate=''>
        <cfelse>
        <cfset oriregdate=dateformat(getitem.oriregdate,'DD/MM/YYYY')>
        </cfif>
        <cfset remark=getitem.remark>
        <cfset mode='Delete'>
	  	<cfset title='Delete Item'>
	  	<cfset button='Delete'>
	</cfif>
			
    <cfif url.type eq 'Create'>
    	<cfset entryno=''>
	  	<cfset xcustcode=''>
	  	<cfset custname=''>
	  	<cfset Add1=''>
        <cfset Add2=''>
	  	<cfset Add3=''>
        <cfset Add4=''>
	  	<cfset postalcode=''>
	  	<cfset Email=''>
	  	<cfset phone=''>
	  	<cfset Hp=''>
        <cfset memberid=''>
	  	<cfset gender=''>
	  	<cfset contactperson =''>
        <cfset contact =''>
	  	<cfset xmake=''>
	  	<cfset xmodel=''>
	  	<cfset engineno=''>
	  	<cfset chasisno=''>
	  	<cfset xcapacity=''>
        <cfset xcolour=''>
	  	<cfset regyear=''>
        <cfset HONORIFIC = ''>
        <cfset lastmileage = '0'>
	  	<cfset lastserdate=''>
        <cfset nextmileage = '0'>
        <cfset nextserdate=''>
        <cfset oriregdate=dateformat(now(),'DD/MM/YYYY')>
        <cfset remark=''>
	  	<cfset mode='Create'>
	  	<cfset title='Create Item'>
	  	<cfset button='Create'>

	</cfif>
    
    <cfquery name='getvehicolour' datasource='#dts#'>
    select * from vehicolour order by colour
    </cfquery>
    <cfquery name='getvehicapacity' datasource='#dts#'>
    select * from vehicapacity order by capacity
    </cfquery>
    <cfquery name='getvehimake' datasource='#dts#'>
    select * from vehimake order by make
    </cfquery>
    <cfquery name='getvehimodel' datasource='#dts#'>
    select * from vehimodel order by model
    </cfquery>

	<h1>#title#</h1>
	
    <h4>
	<cfif getpin2.h1310 eq 'T'>
		<a href="vehicles2.cfm?type=Create">Creating a Vehicle</a> 
	</cfif>
	<cfif getpin2.h1320 eq 'T'>
		|| <a href="vehicles.cfm">List all Vehicles</a> 
	</cfif>
	<cfif getpin2.h1330 eq 'T'>
		|| <a href="s_Vehicles.cfm">Search For Vehicles</a> 
	</cfif>
	<cfif getpin2.h1340 eq 'T'>
		|| <a href="p_Vehicles.cfm">Vehicles Listing</a> 
	</cfif>
</h4>
  </cfoutput>

<cfform name='CustomerForm' action='vehiclesprocess.cfm' method='post'>
  <cfoutput>
    <input type='hidden' name='mode' value='#mode#'>
    <cfif isdefined('url.express')>
    <input type="hidden" name="express" id="express" value="#url.express#">
    </cfif>
  </cfoutput>
  <h1 align='center'>Vehicle Maintenance</h1>
  <cfoutput>
  <table align='center' class='data' width='779' cellspacing="0">
    
      <tr>
        <td width='126'>Vehicle No :</td>
        <td>
          <cfif mode eq 'Delete' or mode eq 'Edit'>
          <cfinput type='text' size='40' name='entryno' value='#convertquote(url.entryno)#' readonly>
          <cfelse>
		  <cfinput type='text' size='40' name='entryno' value='#entryno#' maxlength='10' required="yes" message="Please Key in a Vehicle No" onBlur="ajaxFunction(document.getElementById('checkvehicleajax'),'checkvehicleajax.cfm?entryno='+this.value);">
         <div id="checkvehicleajax">
         
         </div>
          </cfif>
        </td>
        <td nowrap>Engine No :</td>
        <td>
        <cfinput type='text' size='40' name='engineno' value='#engineno#' maxlength='50'></td>
      </tr>
      <tr>
        <td nowrap>Register year :</td>
        <td>
        <cfinput type='text' size='10' name='regyear' value='#regyear#' maxlength='4'></td>
        <td nowrap>Chassis no :</td>
        <td>
        <cfinput type='text' size='40' name='chasisno' value='#chasisno#' maxlength='50'></td>
      </tr>
      <tr>
        <td>Register Date :</td>
        <td>
        <cfinput type='text' size='10' name='oriregdate' value='#oriregdate#' maxlength='10' validate="eurodate" message="Please Key in Correct Date Format"><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(oriregdate);"> (DD/MM/YYYY)</td>
        <td <cfif getpin2.h1Q10 neq "T">style="visibility:hidden"</cfif>>Capacity :</td>
        <td <cfif getpin2.h1Q10 neq "T">style="visibility:hidden"</cfif>>
        <cfselect name="capacity">
        <option value="">Select a Capacity</option>
        <cfloop query="getvehicapacity">
        <option value="#capacity#" <cfif capacity eq xcapacity>selected</cfif>>#capacity# - #desp#</option>
        </cfloop>
        </cfselect>
        </td>
      </tr>
      <tr>
        <td>Vehicle Make :</td>
        <td>
        <cfselect name="make">
        <option value="">Select a Vehicle Make</option>
        <cfloop query="getvehimake">
        <option value="#make#" <cfif make eq xmake>selected</cfif>>#make# - #desp#</option>
        </cfloop>
        </cfselect>
        </td>
        <td>Vehicle Model :</td>
        <td>
        <cfselect name="model">
        <option value="">Select a Vehicle Model</option>
        <cfloop query="getvehimodel">
        <option value="#model#" <cfif model eq xmodel>selected</cfif>>#model# - #desp#</option>
        </cfloop>
        </cfselect>
        </td>
      </tr>
      <tr>
        <td <cfif getpin2.h1Q20 neq "T">style="visibility:hidden"</cfif>>Vehicle Colour :</td>
        <td <cfif getpin2.h1Q20 neq "T">style="visibility:hidden"</cfif>>
        <cfselect name="colour">
        <option value="">Select a colour</option>
        <cfloop query="getvehicolour">
        <option value="#colour#" <cfif colour eq xcolour>selected</cfif>>#colour# - #desp#</option>
        </cfloop>
        </cfselect>
        </td>
      </tr>
      <tr>
        <td nowrap>Last Service Mileage:</td>
        <td>
        <cfinput type='text' size='10' name='lastmileage' value='#lastmileage#' maxlength='20' validate="float" message="Please Key in number only"></td>
        <td nowrap>Last Service Date:</td>
        <td>
        <cfinput type='text' size='10' name='lastserdate' value='#lastserdate#' mask="99/99/9999" maxlength='100' validate="eurodate" message="Please Key in Correct Date Format"><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(lastserdate);"> (DD/MM/YYYY)</td>
      </tr>
      <tr>
        <td nowrap>Next Service Mileage:</td>
        <td nowrap>
        <cfinput type='text' size='10' name='nextmileage' value='#nextmileage#' maxlength='20' validate="float" message="Please Key in number only"></td>
        <td nowrap>next Service Date:</td>
        <td nowrap>
        <cfinput type='text' size='10' name='nextserdate' value='#nextserdate#' mask="99/99/9999" maxlength='100' validate="eurodate" message="Please Key in Correct Date Format"><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(nextserdate);"> (DD/MM/YYYY)</td>
      </tr>
    <tr>
      <td colspan='8'><hr></td>
    </tr>
    <tr>
      <th height='20' colspan='8'>
        <div align='center'><strong>Customer Information</strong></div></th>
    </tr>
    <!--- Customer --->
    <cfquery name='getcust' datasource='#dts#'>
    select custno,name,currcode from #target_arcust# where (status='' or status is null) order by custno
    </cfquery>
    <tr>
      <td>Customer</td>
      <td colspan='4'>
      <cfselect name='custcode' id="custcode" onChange="getcustomerdetail();" required="yes" message="Please Select a Customer">
          <option value=''>-</option>
          <cfloop query='getcust'>
            <option value='#custno#'<cfif custno eq xcustcode>selected</cfif>>#custno# - #getcust.name#</option>
          </cfloop>
        </cfselect>
		<input type="text" name="searchsupp" onKeyUp="getSupp('custcode', 'Customer');getcustomerdetail();" onBlur="getcustomerdetail();">
        <a onClick="javascript:ColdFusion.Window.show('createCustomer');" onMouseOver="this.style.cursor='hand';">Create New Customer</a>
      </td>
    </tr>
    <tr>
    <td colspan="100%" rowspan="2">
    <div id="customerdetailajax">
    <table>
    <tr>
    <td>Name</td>
    <td><cfinput type='text' size='40' name='custname' value='#custname#' maxlength='100'></td>
    </tr>
    <tr>
    <td>Address </td>
    <td><cfinput type='text' size='40' name='add1' value='#add1#' maxlength='100'></td>
    </tr>
    <tr>
    <td></td>
    <td><cfinput type='text' size='40' name='add2' value='#add2#' maxlength='100'></td>
    </tr>
    <tr>
    <td></td>
    <td><cfinput type='text' size='40' name='add3' value='#add3#' maxlength='100'></td>
    </tr>
    <tr>
    <td></td>
    <td><cfinput type='text' size='40' name='add4' value='#add4#' maxlength='100'></td>
    </tr>
    <tr>
    <td>Contact Person</td>
    <td><select name="honorific" id="honorific">
    <option value="Mr" <cfif honorific eq 'Mr'>selected</cfif>>Mr</option>
    <option value="Mrs" <cfif honorific eq 'Mrs'>selected</cfif>>Mrs</option>
    <option value="Ms" <cfif honorific eq 'Ms'>selected</cfif>>Ms</option>
    </select>
    <cfinput type='text' size='40' name='contactperson' value='#contactperson#' maxlength='100'>		</td>
    </tr>
    <tr>
    <td>Postalcode</td>
    <td><cfinput type='text' size='40' name='postalcode' value='#postalcode#' maxlength='100'></td>
    </tr>
    <tr>
    <td>E-mail</td>
    <td><cfinput type='text' size='40' name='email' value='#email#' maxlength='100'></td>
    </tr>
    <tr>
    <td>Tel</td>
    <td><cfinput type='text' size='40' name='phone' value='#phone#' maxlength='100'></td>
    </tr>
    <tr>
    <td>HP</td>
    <td><cfinput type='text' size='40' name='HP' value='#HP#' maxlength='100'></td>
    </tr>
    <tr>
    <td>Contact No</td>
    <td><cfinput type='text' size='40' name='contact' value='#contact#' maxlength='100'></td>
    </tr>
    
    
    <tr>
    <td>Member ID</td>
    <td><cfinput type='text' size='40' name='memberid' value='#memberid#' maxlength='15'></td>
    </tr>
    <tr>
    <td>Gender</td>
    <td><select name="gender" id="gender">
    <option value="">Please Select a gender</option>
    <option value="male" <cfif gender eq 'Male'>selected</cfif>>Male</option>
    <option value="female" <cfif gender eq 'Female'>selected</cfif>>Female</option>
    <option value="corporate" <cfif gender eq 'corporate'>selected</cfif>>Corporate</option>
    </select></td>
    </tr>
    </table>
    </div>
    </td>
    </tr>
       <tr>
      <td colspan='8'><hr></td>
    </tr>
    <tr>
      <th height='20' colspan='8'>
        <div align='center'><strong>Other Information</strong></div></th>
    </tr>
    <tr>
    <td>Remark :</td>
    <td><textarea name="remark" id="remark" rows="3" cols="60">#remark#</textarea></td>
    </tr>
      <tr>
        <td align="center" colspan="100%"><input name='submit' type='submit' value='#button#'></td>
      </tr>
		<!--- ADD ON 260908, 2ND UOM --->
		<tr>
			<td colspan='100%'><hr></td>
      	</tr>
      	 
  </table>
  </cfoutput>
</cfform>

<cfwindow x="20" y="100" width="250" height="250" name="findSymbol1" refreshOnShow="true"
        title="ADD SYMBOL" initshow="false"
        source="/default/maintenance/symbol/maintenanceSymbolAjax.cfm?id=1" />
<cfwindow x="20" y="100" width="250" height="250" name="findSymbol2" refreshOnShow="true"
        title="ADD SYMBOL" initshow="false"
        source="/default/maintenance/symbol/maintenanceSymbolAjax.cfm?id=2" />
<cfwindow x="10" y="10" modal="true"  width="1100" height="600" name="createCustomer" refreshOnShow="true"
        title="Add New Customer" initshow="false"
        source="/default/maintenance/shellvehicles/createCustomerAjax.cfm" />
</body>
</html>