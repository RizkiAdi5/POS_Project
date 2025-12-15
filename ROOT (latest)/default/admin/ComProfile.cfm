<cfif Hlinkams eq "Y">
<cfquery name="update_ims_gsetup_from_ams" datasource="#dts#">
		update
		gsetup as a,
		(
			select
			ctycode,
			debtorfr,
			debtorto,
			creditorfr,
			creditorto,
			compro,
			compro2,
			compro3,
			compro4,
			compro5,
			compro6,
			compro7
			from #replacenocase(dts,"_i","_a","all")#.gsetup
		) as b
		set
		a.debtorfr=b.debtorfr,
		a.debtorto=b.debtorto,
		a.creditorfr=b.creditorfr,
		a.creditorto=b.creditorto,
		a.compro=b.compro,
		a.compro2=b.compro2,
		a.compro3=b.compro3,
		a.compro4=b.compro4,
		a.compro5=b.compro5,
		a.compro6=b.compro6,
		a.compro7=b.compro7,
		a.bcurr=b.ctycode
		where a.companyid='IMS';
		;
	</cfquery>
    </cfif>
<html>
<head>
<title>Company Profile</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
	function validate()
	{
		if(document.companyform.bcurr.value=="")
		{
			alert("The Currency Code Can Not Be Blank !");
			document.companyform.bcurr.focus();
			return false;
		}

		return true;
	}
</script>
</head>

<cfif isdefined("url.type")>
	<cfset dd = dateformat(form.lastaccyear, "DD")>

	<cfif dd greater than '12'>
		<cfset nDateCreate = dateformat(form.lastaccyear,"YYYYMMDD")>
	<cfelse>
		<cfset nDateCreate = dateformat(form.lastaccyear,"YYYYDDMM")>
	</cfif>

	<cfif form.period gt 18>
		<cfset xperiod = 18>
	<cfelse>
		<cfset xperiod = form.period>
	</cfif>

	<cfif Hlinkams eq "Y">
		<cfquery name="SaveGeneralInfo" datasource="#replace(dts,'_i','_a','all')#">
			update gsetup set
			debtorfr='#debtorfr#',
			debtorto='#debtorto#',
			creditorfr='#creditorfr#',
			creditorto='#creditorto#',
			compro='#form.compro#',
			compro2='#form.compro2#',
			compro3='#form.compro3#',
			compro4='#form.compro4#',
			compro5='#form.compro5#',
			compro6='#form.compro6#',
			compro7='#form.compro7#',
			ctycode='#form.bcurr#',
			comuen='#form.comuen#',
			gstno='#form.gstno#',
            externalthirdparty='#form.externalthirdparty#',
        	invoiceDataFile='#form.invoiceDataFile#'
			where companyid=companyid;
		</cfquery>
	</cfif>

	<cfquery name="SaveGeneralInfo" datasource="#dts#">
		update gsetup set
		LastAccYear=#nDateCreate#,
		period='#xperiod#',
		debtorfr='#debtorfr#',
		debtorto='#debtorto#',
		creditorfr='#creditorfr#',
		creditorto='#creditorto#',
		compro='#form.compro#',
		compro2='#form.compro2#',
		compro3='#form.compro3#',
		compro4='#form.compro4#',
		compro5='#form.compro5#',
		compro6='#form.compro6#',
		compro7='#form.compro7#',
		bcurr = '#form.bcurr#',
		menutype = '#form.menuchoice#',
        dflanguage = '#form.dflanguage#'
		,periodalfr='#form.xperiodalfr#',
        interface='#form.interface#',
		comuen='#form.comuen#',
		gstno='#form.gstno#',
        externalthirdparty='#form.externalthirdparty#',
        invoiceDataFile='#form.invoiceDataFile#'

		where companyid='IMS';
	</cfquery>
</cfif>

<cfif Hlinkams eq "Y">
	<cfquery name="general_info" datasource="#replace(dts,'_i','_a','all')#">
		select
		companyid,
		lastaccyear,
		ctycode,
		period,
		debtorfr,
		debtorto,
		creditorfr,
		creditorto,
		compro,
		compro2,
		compro3,
		compro4,
		compro5,
		compro6,
		compro7,
		comuen,gstno,
        externalthirdparty,
        invoiceDataFile
		from gsetup;
	</cfquery>

	<cfset lastaccyear = dateformat(general_info.lastaccyear, "dd/mm/yyyy")>
	<cfset period = general_info.period>
	<cfset debtorfr = general_info.debtorfr>
	<cfset debtorto = general_info.debtorto>
	<cfset creditorfr = general_info.creditorfr>
	<cfset creditorto = general_info.creditorto>
	<cfset compro = general_info.compro>
	<cfset compro2 = general_info.compro2>
	<cfset compro3 = general_info.compro3>
	<cfset compro4 = general_info.compro4>
	<cfset compro5 = general_info.compro5>
	<cfset compro6 = general_info.compro6>
	<cfset compro7 = general_info.compro7>
	<cfset bcurr = general_info.ctycode>
	<cfset comuen = general_info.comuen>
	<cfset gstno = general_info.gstno>
    <cfset externalthirdparty = General_Info.externalthirdparty>
    <cfset invoiceDataFile = General_Info.invoiceDataFile>
<cfelse>
	<cfquery name="getGeneralInfo" datasource="#dts#">
		select
		companyid,
		lastaccyear,
		ctycode,
		period,
		debtorfr,
		debtorto,
		creditorfr,
		creditorto,
		compro,
		compro2,
		compro3,
		compro4,
		compro5,
		compro6,
		compro7,
		bcurr,
		comuen,
        gstno,
        externalthirdparty,
        invoiceDataFile
		from gsetup;
	</cfquery>

	<cfset lastaccyear = dateformat(getGeneralInfo.lastaccyear, "dd/mm/yyyy")>
	<cfset period = getGeneralInfo.period>
	<cfset debtorfr = getGeneralInfo.debtorfr>
	<cfset debtorto = getGeneralInfo.debtorto>
	<cfset creditorfr = getGeneralInfo.creditorfr>
	<cfset creditorto = getGeneralInfo.creditorto>
	<cfset compro = getGeneralInfo.compro>
	<cfset compro2 = getGeneralInfo.compro2>
	<cfset compro3 = getGeneralInfo.compro3>
	<cfset compro4 = getGeneralInfo.compro4>
	<cfset compro5 = getGeneralInfo.compro5>
	<cfset compro6 = getGeneralInfo.compro6>
	<cfset compro7 = getGeneralInfo.compro7>
	<cfset bcurr = getGeneralInfo.bcurr>
	<cfset comuen = getGeneralInfo.comuen>
	<cfset gstno = getGeneralInfo.gstno>
	<cfset externalthirdparty = getGeneralInfo.externalthirdparty>
    <cfset invoiceDataFile = getGeneralInfo.invoiceDataFile>
</cfif>

<cfquery name="getCurrency" datasource="#dts#">		<!--- ADDED ON 300508 --->
	select * from #target_currency#
	order by CurrCode
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">		<!--- ADDED ON 160608 --->
	select * from gsetup
</cfquery>
<body>

<h4>
	<cfif getpin2.h5110 eq "T">Company Profile </cfif>
    <cfif getpin2.h5120 eq "T">|| <a href="lastusedno.cfm">Last Used No</a> </cfif>
    <cfif getpin2.h5130 eq "T">|| <a href="transaction.cfm">Transaction Setup</a> </cfif>
    <cfif getpin2.h5150 eq "T">|| <a href="userdefine.cfm">User Defined</a> </cfif>
    <cfif getpin2.h5160 eq "T">||<a href="dealer_menu/dealer_menu.cfm">Dealer Menu</a> </cfif>
</h4>

<h1>General Setup - Company Profile</h1>

<cfform name="companyform" action="comprofile.cfm?type=save" method="post" onsubmit="releaseDirtyFlag();return validate();">
	<h1 align="center">Please enter the last financial year below.</h1>

	<table width="500" align="center" class="data">
    	<tr>
      		<td colspan="2">
				<div align="left"><strong>Company Name</strong></div>
			</td>
    	</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="compro" type="text" value="#compro#" size="80" maxlength="80">
			</td>
		</tr>
    	<tr>
      		<td colspan="2">
				<div align="left"><strong>Company Address</strong></div>
			</td>
    	</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="compro2" type="text" value="#compro2#" size="80" maxlength="80">
			</td>
		</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="compro3" type="text" value="#compro3#" size="80" maxlength="80">
			</td>
		</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="compro4" type="text" value="#compro4#" size="80" maxlength="80">
			</td>
		</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="compro5" type="text" value="#compro5#" size="80" maxlength="80">
			</td>
		</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="compro6" type="text" value="#compro6#" size="80" maxlength="80">
			</td>
		</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="compro7" type="text" value="#compro7#" size="80" maxlength="80">
			</td>
		</tr>
    	<tr>
      		<td colspan="2">
				<div align="left"><strong>Company UEN</strong></div>
			</td>
    	</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="comuen" type="text" value="#comuen#" size="80" maxlength="80">
			</td>
		</tr>
    	<tr>
      		<td colspan="2">
				<div align="left"><strong>GST Registration No.</strong></div>
			</td>
    	</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="gstno" type="text" value="#gstno#" size="80" maxlength="80">
			</td>
		</tr>
        <tr>
      		<td colspan="2">
				<div align="left"><strong>Invoice Data File</strong></div>
			</td>
    	</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="invoiceDataFile" type="text" value="#invoiceDataFile#" size="80" maxlength="2">
			</td>
		</tr>
      <tr>
      		<td colspan="2">
				<div align="left"><strong>External Third Party File</strong></div>
			</td>
    	</tr>
		<tr>
		  	<td colspan="2" align="center">
				<cfinput name="externalthirdparty" type="text" value="#externalthirdparty#" size="80" maxlength="16">
			</td>
		</tr>

		<tr>
		  	<td colspan="2">
				<br>
			</td>
		</tr>
		<tr>
		  	<td colspan="2">
				<div align="center"><strong>Menu Format</strong></div>
			</td>
		</tr>
		<tr>
        	<th>Menubar Type</th>
        	<td><select required="yes" name="menuchoice" message="Please select the menubar type.">
					<option value="H" <cfif getgsetup.menutype eq "H">selected</cfif>>Horizontal</option>
					<option value="V" <cfif getgsetup.menutype eq "V">selected</cfif>>Vertical</option>
				</select>
			</td>
      	</tr>
        <tr>
		  	<td colspan="2">
				<div align="center"><strong>Menu Language</strong></div>
			</td>
		</tr>
		<tr>
        	<th>Menubar Type</th>
        	<td><select required="yes" name="dflanguage" message="Please select the menubar anguage.">
					<option value="english" <cfif getgsetup.dflanguage eq "english">selected</cfif>>English</option>
					<option value="sim_ch" <cfif getgsetup.dflanguage eq "sim_ch">selected</cfif>>Simplify Chinese</option>
                    <option value="tra_ch" <cfif getgsetup.dflanguage eq "tra_ch">selected</cfif>>Traditional Chinese</option>
				</select>
			</td>
      	</tr>
		<tr>
		  	<td colspan="2">
				<div align="center"><strong>Financial Information</strong></div>
			</td>
		</tr>
		<tr>
		  	<th width="250">Last A/C Year Closing Date</th>
		  	<td width="250">
				<cfinput name="LastAccYear" type="text" value="#dateformat(getgsetup.lastaccyear, "dd/mm/yyyy")#" validate="eurodate" required="yes" message="Last Account Year Can Not Be Blank !">
			</td>
		</tr>
		<tr>
		  	<th>This A/C Year Closing Period</th>
		  	<td><cfinput name="Period" type="text" value="#getgsetup.period#" validate="integer" required="yes" message="The A/C Year Closing Period Be Blank !"></td>
		</tr>
		<tr>
      		<th width="250">Currency Used</th>
      		<td width="250">
				<cfoutput>
				<select name="bcurr">
					<option value="">Choose a Currency Code</option>
					<cfloop query="getCurrency">
						<option value="#getCurrency.CurrCode#" <cfif bcurr eq getCurrency.CurrCode>selected</cfif>>#getCurrency.CurrCode# - #getCurrency.Currency1#</option>
					</cfloop>
					<!--- REMARK ON 300508, DON'T WANT THE CURRENCY TO BE HARD CODED, SELECT THE CURRENCY FROM DATABASE --->
					<!---option value="LKR" <cfif bcurr eq "LKR">selected</cfif>>LKR - Sri Lanka, Rupees</option>
					<option value="MYR" <cfif bcurr eq "MYR">selected</cfif>>MYR - Malaysia, Ringits</option>
					<option value="RMB" <cfif bcurr eq "RMB">selected</cfif>>RMB - China, Yen RenMinBi</option>
					<option value="SGD" <cfif bcurr eq "SGD">selected</cfif>>SGD - Singapore, Dollars</option>
					<option value="USD" <cfif bcurr eq "USD">selected</cfif>>USD - United States of America, Dollars</option>
					<option value="VND" <cfif bcurr eq "VND">selected</cfif>>VND - Vietnam, Dong</option--->
				</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td colspan="2"><hr></td>
		</tr>
		<tr>
		  	<td colspan="2">
				<div align="center"><strong>Debtor Account Groups</strong></div>
			</td>
		</tr>
		<tr>
		  	<th width="250">Debtor From</th>
		  	<td width="250">
				<cfinput name="debtorfr" type="text" value="#debtorfr#" size="10" maxlength="4" required="yes" message="Debtor From Can Not Be Blank !">
			</td>
		</tr>
		<tr>
		  	<th width="250">Debtor To</th>
		  	<td width="250">
				<cfinput name="debtorto" type="text" value="#debtorto#" size="10" maxlength="4" required="yes" message="Debtor To Can Not Be Blank !">
			</td>
		</tr>
		<tr>
			<td colspan="2"><hr></td>
		</tr>
		<tr>
		  	<td colspan="2">
				<div align="center"><strong>Creditor Account Groups</strong></div>
			</td>
		</tr>
		<tr>
		  	<th width="250">Creditor From</th>
		  	<td width="250">
				<cfinput name="creditorfr" type="text" value="#creditorfr#" size="10" maxlength="4" required="yes" message="Creditor From Can Not Be Blank !">
			</td>
		</tr>
		<tr>
		  	<th width="250">Creditor To</th>
		  	<td width="250">
				<cfinput name="creditorto" type="text" value="#creditorto#" size="10" maxlength="4" required="yes" message="Creditor To Can Not Be Blank !">
			</td>
		</tr>
        <tr><td colspan="100%"><hr></td></tr>
        <tr>
            <th>Period Allowed From</th>
            <td>
                <select name="xperiodalfr">
                <cfloop from="1" to="18" index="a">
                    <cfoutput><option value="#numberformat(a,"00")#" <cfif val(getgsetup.periodalfr) eq a>selected</cfif>>#numberformat(a,"00")#</option></cfoutput>
                </cfloop>
                </select> To 18
            </td>
        </tr>
        <tr><td colspan="100%"><hr></td></tr>

        <tr>
		  	<td colspan="2">
				<div align="center"><strong>Interface</strong></div>
			</td>
		</tr>
		<tr>
		  	<th width="250">Interface</th>
		  	<td width="250">
				<select name="interface" id="interface">
                <option value="new" <cfif getgsetup.interface eq 'new'>selected</cfif>>New Interface</option>
                <option value="old" <cfif getgsetup.interface eq 'old'>selected</cfif>>Previous Interface</option>
                <cfif lcase(hcomid) eq "21bl_i" or lcase(hcomid) eq "21cmw_i" or lcase(hcomid) eq "autoserv_i" or lcase(hcomid) eq "ftmps_i" or lcase(hcomid) eq "lkabb_i" or lcase(hcomid) eq "lkabp_i" or lcase(hcomid) eq "lkabt_i" or lcase(hcomid) eq "lkatb_i" or lcase(hcomid) eq "lkatbh_i" or lcase(hcomid) eq "lkatl_i" or lcase(hcomid) eq "lkatlb_i" or lcase(hcomid) eq "stbrd_i" or lcase(hcomid) eq "stfsk_i" or lcase(hcomid) eq "stfsrg_i" or lcase(hcomid) eq "stpylb_i" or lcase(hcomid) eq "svcbd_i" or lcase(hcomid) eq "svcdm_i" or lcase(hcomid) eq "svcmm_i" or lcase(hcomid) eq "svcnvn_i" or lcase(hcomid) eq "svctm_i" or lcase(hcomid) eq "svcy_i" or lcase(hcomid) eq "svcyr_i" or lcase(hcomid) eq "jvsbw_i" or lcase(hcomid) eq "jvtpy_i" or lcase(hcomid) eq "shell_i" or lcase(hcomid) eq "svcnc_i" or lcase(hcomid) eq "fttk_i">
                <option value="shell" <cfif getgsetup.interface eq 'shell'>selected</cfif>>Shell Interface</option>
                </cfif>
                </select>
			</td>
		</tr>

        <tr><td colspan="100%"><hr></td></tr>
	 	<tr>
      		<td colspan="2" align="center">
          		<input name="submit" type="submit" value="Save">
          		<input name="reset" type="reset" value="Reset">
			</td>
    	</tr>
	</table>

	<h3 align="center">Warning! Make sure that the closing date is the same as the closing date found in UBS System!</h3>
</cfform>

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