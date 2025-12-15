<html>
<head>
<title>User Defined</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<cfquery name="getremarkInfo" datasource="#dts#">
	select * 
	from gsetup;
</cfquery>

<cfif isdefined("url.type")>
	<cfquery datasource="#dts#" name="SaveGeneralInfo">
		update gsetup set 
		Lcategory='#form.lcategory#',
		Lmodel='#form.lmodel#',
		Lrating='#form.lrating#',
		Lgroup='#form.lgroup#',
		Lsize='#form.lsize#',
		Lmaterial='#form.lmaterial#',
		lAGENT='#form.lAGENT#',
        lTEAM='#form.lTEAM#',
		lDRIVER='#form.lDRIVER#',
		lLOCATION='#form.lLOCATION#',
		lPROJECT='#form.lPROJECT#',
		lJOB='#form.lJOB#',
        lBATCH='#form.lBATCH#',
        lRC='#form.lRC#',
        lPR='#form.lPR#',
        lDO='#form.lDO#',
        lINV='#form.lINV#',
        lCS='#form.lCS#',
        lCN='#form.lCN#',
        lDN='#form.lDN#',
        lPO='#form.lPO#',
        lQUO='#form.lQUO#',
        lSO='#form.lSO#',
        lSAM='#form.lSAM#',
        lISS='#form.lISS#',
        lOAI='#form.lOAI#',
        lOAR='#form.lOAR#',
        lCONSIGNIN='#form.lCONSIGNIN#',
        lCONSIGNOUT='#form.lCONSIGNOUT#',
        
		rem0='#form.rem0#',
		rem1='#form.rem1#',
		rem2='#form.rem2#',
		rem3='#form.rem3#',
		rem4='#form.rem4#',
		rem5='#form.rem5#',
		rem6='#form.rem6#',
		rem7='#form.rem7#',
		rem8='#form.rem8#',
		rem9='#form.rem9#',
		rem10='#form.rem10#',
		rem11='#form.rem11#',
        refno2='#form.refno2#',
        misccharge1='#form.misccharge1#',
        misccharge2='#form.misccharge2#',
        misccharge3='#form.misccharge3#',
        misccharge4='#form.misccharge4#',
        misccharge5='#form.misccharge5#',
        misccharge6='#form.misccharge6#',
        misccharge7='#form.misccharge7#',
		rem12='#form.rem12#',
		brem1='#form.brem1#',
		brem2='#form.brem2#',
		brem3='#form.brem3#',
		brem4='#form.brem4#' 
		where companyid='IMS';
	</cfquery>
    <cfif getremarkInfo.addonremark eq 'Y'>
    <cfquery datasource="#dts#" name="Saveaddonremark">
    update extraremark set 
    	rem30='#form.rem30#',
		rem31='#form.rem31#',
		rem32='#form.rem32#',
		rem33='#form.rem33#',
		rem34='#form.rem34#',
		rem35='#form.rem35#',
		rem36='#form.rem36#',
		rem37='#form.rem37#',
		rem38='#form.rem38#',
        rem39='#form.rem39#',
		rem40='#form.rem40#',
		rem41='#form.rem41#',
		rem42='#form.rem42#',
		rem43='#form.rem43#',
		rem44='#form.rem44#',
		rem45='#form.rem45#',
		rem46='#form.rem46#',
		rem47='#form.rem47#',
        rem48='#form.rem48#',
		rem49='#form.rem49#'
    where companyid='IMS';
    </cfquery>
    </cfif>
    
</cfif>
<cfquery name="getremarkdetail" datasource="#dts#">
	select * 
	from extraremark;
</cfquery>
<cfquery name="getGeneralInfo" datasource="#dts#">
	select * 
	from gsetup;
</cfquery>

<cfset Lcategory = getGeneralInfo.Lcategory>
<cfset Lgroup = getGeneralInfo.Lgroup>
<cfset Lmodel = getGeneralInfo.Lmodel>
<cfset Lrating = getGeneralInfo.Lrating>
<cfset Lsize = getGeneralInfo.Lsize>
<cfset Lmaterial = getGeneralInfo.Lmaterial>
<cfset rem0 = getGeneralInfo.rem0>
<cfset rem1 = getGeneralInfo.rem1>
<cfset rem2 = getGeneralInfo.rem2>
<cfset rem3 = getGeneralInfo.rem3>
<cfset rem4 = getGeneralInfo.rem4>
<cfset rem5 = getGeneralInfo.rem5>
<cfset rem6 = getGeneralInfo.rem6>
<cfset rem7 = getGeneralInfo.rem7>
<cfset rem8 = getGeneralInfo.rem8>
<cfset rem9 = getGeneralInfo.rem9>
<cfset rem10 = getGeneralInfo.rem10>
<cfset rem11 = getGeneralInfo.rem11>

<cfset misccharge1 = getGeneralInfo.misccharge1>
<cfset misccharge2 = getGeneralInfo.misccharge2>
<cfset misccharge3 = getGeneralInfo.misccharge3>
<cfset misccharge4 = getGeneralInfo.misccharge4>
<cfset misccharge5 = getGeneralInfo.misccharge5>
<cfset misccharge6 = getGeneralInfo.misccharge6>
<cfset misccharge7 = getGeneralInfo.misccharge7>

<cfset refno2 = getGeneralInfo.refno2>
<cfset rem12 = getGeneralInfo.rem12>
<cfset brem1 = getGeneralInfo.brem1>
<cfset brem2 = getGeneralInfo.brem2>
<cfset brem3 = getGeneralInfo.brem3>
<cfset brem4 = getGeneralInfo.brem4>
<!--- ADD ON 14-07-2009 --->
<cfset lAGENT = getGeneralInfo.lAGENT>
<cfset lTEAM = getGeneralInfo.lTEAM>
<cfset lDRIVER = getGeneralInfo.lDRIVER>
<cfset lLOCATION = getGeneralInfo.lLOCATION>
<!--- ADD ON 26-03-2010 --->
<cfset lPROJECT = getGeneralInfo.lPROJECT>
<cfset lJOB = getGeneralInfo.lJOB>
<cfset lBATCH = getGeneralInfo.lBATCH>
<cfset lRC = getGeneralInfo.lRC>
<cfset lPR = getGeneralInfo.lPR>
<cfset lDO = getGeneralInfo.lDO>
<cfset lINV = getGeneralInfo.lINV>
<cfset lCS = getGeneralInfo.lCS>
<cfset lCN = getGeneralInfo.lCN>
<cfset lDN = getGeneralInfo.lDN>
<cfset lPO = getGeneralInfo.lPO>
<cfset lQUO = getGeneralInfo.lQUO>
<cfset lSO = getGeneralInfo.lSO>
<cfset lSAM = getGeneralInfo.lSAM>
<cfset LISS = getGeneralInfo.LISS>
<cfset lOAI = getGeneralInfo.lOAI>
<cfset lOAR = getGeneralInfo.lOAR>
<cfset lCONSIGNIN = getGeneralInfo.lCONSIGNIN>
<cfset lCONSIGNOUT = getGeneralInfo.lCONSIGNOUT>

<cfif getGeneralInfo.addonremark eq 'Y'>
<cfset rem30 = getremarkdetail.rem30>
<cfset rem31 = getremarkdetail.rem31>
<cfset rem32 = getremarkdetail.rem32>
<cfset rem33 = getremarkdetail.rem33>
<cfset rem34 = getremarkdetail.rem34>
<cfset rem35 = getremarkdetail.rem35>
<cfset rem36 = getremarkdetail.rem36>
<cfset rem37 = getremarkdetail.rem37>
<cfset rem38 = getremarkdetail.rem38>
<cfset rem39 = getremarkdetail.rem39>
<cfset rem40 = getremarkdetail.rem40>
<cfset rem41 = getremarkdetail.rem41>
<cfset rem42 = getremarkdetail.rem42>
<cfset rem43 = getremarkdetail.rem43>
<cfset rem44 = getremarkdetail.rem44>
<cfset rem45 = getremarkdetail.rem45>
<cfset rem46 = getremarkdetail.rem46>
<cfset rem47 = getremarkdetail.rem47>
<cfset rem48 = getremarkdetail.rem48>
<cfset rem49 = getremarkdetail.rem49>
</cfif>
<body>

<h4>
	<cfif getpin2.h5110 eq "T"><a href="comprofile.cfm">Company Profile</a> </cfif>
    <cfif getpin2.h5120 eq "T">|| <a href="lastusedno.cfm">Last Used No</a> </cfif>
    <cfif getpin2.h5130 eq "T">|| <a href="transaction.cfm">Transaction Setup</a> </cfif>
    <cfif getpin2.h5140 eq "T">|| <a href="Accountno.cfm">UBS Accounting Default Setup</a> </cfif> 
    <cfif getpin2.h5150 eq "T">||User Defined</cfif>
    <cfif getpin2.h5160 eq "T">||<a href="dealer_menu/dealer_menu.cfm">Dealer Menu</a> </cfif> 
    <cfif getpin2.h5170 eq "T">||<a href="transaction_menu/transaction_menu.cfm">Transaction Menu</a> </cfif> 
    <cfif getpin2.h5180 eq "T">||<a href="userdefineformula.cfm">User Define - Formula</a></cfif>
</h4>

<h1>General Setup - User Defined</h1>

<cfform action="userdefine.cfm?type=save" method="post">
	<table width="500" align="center" class="data" cellspacing="0">
		<tr> 
      		<td colspan="2"><div align="center"><strong>User Defined</strong></div></td>
    	</tr>
		<tr> 
		  	<th>Category Layer</th>
		  	<td><cfinput name="LCategory" type="text" maxlength="30" size="30" value="#LCategory#"></td>
		</tr>
		<tr> 
		  	<th>Group Layer</th>
		  	<td><cfinput name="Lgroup" type="text" maxlength="30" size="30" value="#Lgroup#"></td>
		</tr>
		<tr> 
		  	<th>Material Layer</th>
		  	<td><cfinput name="LMaterial" type="text" maxlength="30" size="30" value="#LMaterial#"></td>
		</tr>
		<tr> 
		  	<th>Model Layer</th>
		  	<td><cfinput name="LModel" type="text" maxlength="30" size="30" value="#LModel#"></td>
		</tr>
		<tr> 
		  	<th>Rating Layer</th>
		  	<td><cfinput name="LRating" type="text" maxlength="30" size="30" value="#LRating#"></td>
		</tr>
		<tr> 
		  	<th>Size Layer</th>
		  	<td><cfinput name="Lsize" type="text" maxlength="30" size="30" value="#Lsize#"></td>
		</tr>
		<!--- ADD ON 14-07-2009 --->	
		<tr> 
		  	<th>Agent Layer</th>
		  	<td><cfinput name="lAGENT" type="text" maxlength="30" size="30" value="#lAGENT#"></td>
		</tr>
        <tr> 
		  	<th>Team Layer</th>
		  	<td><cfinput name="lTEAM" type="text" maxlength="30" size="30" value="#lTEAM#"></td>
		</tr>
		<tr> 
		  	<th>End User Layer</th>
		  	<td><cfinput name="lDRIVER" type="text" maxlength="30" size="30" value="#lDRIVER#"></td>
		</tr>
		<tr> 
		  	<th>Location Layer</th>
		  	<td><cfinput name="lLOCATION" type="text" maxlength="30" size="30" value="#lLOCATION#"></td>
		</tr>
		<!--- ADD ON 26-03-2010 --->
		<tr> 
		  	<th>Project Layer</th>
		  	<td><cfinput name="lPROJECT" type="text" maxlength="30" size="30" value="#lPROJECT#"></td>
		</tr>
		<tr> 
		  	<th>Job Layer</th>
		  	<td><cfinput name="lJOB" type="text" maxlength="30" size="30" value="#lJOB#"></td>
		</tr>
        <tr> 
		  	<th>Batch Layer</th>
		  	<td><cfinput name="lBATCH" type="text" maxlength="30" size="30" value="#lBATCH#"></td>
		</tr>
        <tr> 
		  	<th>Purchase Receive Layer</th>
		  	<td><cfinput name="lRC" type="text" maxlength="30" size="30" value="#lRC#"></td>
		</tr>
        <tr> 
		  	<th>Purchase Return Layer</th>
		  	<td><cfinput name="lPR" type="text" maxlength="30" size="30" value="#lPR#"></td>
		</tr>
        <tr> 
		  	<th>Delivery Order Layer</th>
		  	<td><cfinput name="lDO" type="text" maxlength="30" size="30" value="#lDO#"></td>
		</tr>
        <tr> 
		  	<th>Invoice Layer</th>
		  	<td><cfinput name="lINV" type="text" maxlength="30" size="30" value="#lINV#"></td>
		</tr>
        <tr> 
		  	<th>Cash Sales Layer</th>
		  	<td><cfinput name="lCS" type="text" maxlength="30" size="30" value="#lCS#"></td>
		</tr>
        <tr> 
		  	<th>Credit Note Layer</th>
		  	<td><cfinput name="lCN" type="text" maxlength="30" size="30" value="#lCN#"></td>
		</tr>
        <tr> 
		  	<th>Debit Note Layer</th>
		  	<td><cfinput name="lDN" type="text" maxlength="30" size="30" value="#lDN#"></td>
		</tr>
        <tr> 
		  	<th>Purchase Order Layer</th>
		  	<td><cfinput name="lPO" type="text" maxlength="30" size="30" value="#lPO#"></td>
		</tr>
        <tr> 
		  	<th>Quotation Layer</th>
		  	<td><cfinput name="lQUO" type="text" maxlength="30" size="30" value="#lQUO#"></td>
		</tr>
        <tr> 
		  	<th>Sales Order Layer</th>
		  	<td><cfinput name="lSO" type="text" maxlength="30" size="30" value="#lSO#"></td>
		</tr>
        <tr> 
		  	<th>Sample Layer</th>
		  	<td><cfinput name="lSAM" type="text" maxlength="30" size="30" value="#lSAM#"></td>
		</tr>
        <tr> 
		  	<th>Issue Layer</th>
		  	<td><cfinput name="lISS" type="text" maxlength="30" size="30" value="#lISS#"></td>
		</tr>
        <tr> 
		  	<th>Adjustment Increase Layer</th>
		  	<td><cfinput name="lOAI" type="text" maxlength="30" size="30" value="#lOAI#"></td>
		</tr>
        <tr> 
		  	<th>Adjustment Reduce Layer</th>
		  	<td><cfinput name="lOAR" type="text" maxlength="30" size="30" value="#lOAR#"></td>
		</tr>
        <tr> 
		  	<th>Consignment Return Layer</th>
		  	<td><cfinput name="lCONSIGNIN" type="text" maxlength="30" size="30" value="#lCONSIGNIN#"></td>
		</tr>
        <tr> 
		  	<th>Consignment Out Layer</th>
		  	<td><cfinput name="lCONSIGNOUT" type="text" maxlength="30" size="30" value="#lCONSIGNOUT#"></td>
		</tr>
        <tr> 
		  	<th>Ref No 2</th>
		  	<td><cfinput name="refno2" type="text" maxlength="30" size="30" value="#refno2#"></td>
		</tr>
		<tr> 
		  	<th>Header Remark 0 (R)</th>
		  	<td><input name="rem0" type="text" maxlength="30" size="30" value="Bill To Address Code"readonly></td>
		</tr>
		<tr> 
		  	<th>Header Remark 1 (R)</th>
		  	<td><input name="rem1" type="text" maxlength="30" size="30" value="Del Address Code"readonly></td>
		</tr>
		<tr> 
			<th>Header Remark 2 (R)</th>
		  	<td><input name="rem2" type="text" maxlength="30" size="30" value="Bill Attn"readonly></td>
		</tr>
		<tr> 
		  	<th>Header Remark 3 (R)</th>
		  	<td><input name="rem3" type="text" maxlength="30" size="30" value="Delivery Attn"readonly></td>
		</tr>
		<tr> 
		  	<th>Header Remark 4 (R)</th>
		  	<td><input name="rem4" type="text" maxlength="30" size="30" value="Bill Tel"readonly></td>
		</tr>
		<tr> 
		  	<th>Header Remark 5</th>
		  	<td><cfinput name="rem5" type="text" maxlength="30" size="30" value="#rem5#"></td>
		</tr>
		<tr> 
		  	<th>Header Remark 6</th>
		  	<td><cfinput name="rem6" type="text" maxlength="30" size="30" value="#rem6#"></td>
		</tr>
		<tr> 
		  	<th>Header Remark 7</th>
		  	<td><cfinput name="rem7" type="text" maxlength="30" size="30" value="#rem7#"></td>
		</tr>
		<tr> 
		  	<th>Header Remark 8</th>
		  	<td><cfinput name="rem8" type="text" maxlength="30" size="30" value="#rem8#"></td>
		</tr>
		<tr> 
		  	<th>Header Remark 9</th>
		  	<td><cfinput name="rem9" type="text" maxlength="30" size="30" value="#rem9#"></td>
		</tr>
		<tr> 
		  	<th>Header Remark 10</th>
		  	<td><cfinput name="rem10" type="text" maxlength="30" size="30" value="#rem10#"></td>
		</tr>
		<tr> 
		  	<th>Header Remark 11</th>
		  	<td><cfinput name="rem11" type="text" maxlength="30" size="30" value="#rem11#"></td>
		</tr>
        
		<tr> 
		  	<th>Header Remark 12 (R)</th>
		  	<td><input name="rem12" type="text" maxlength="30" size="30" value="Delivery Tel" readonly></td>
		</tr>
        <tr> 
		  	<th>Misc. Charges (1)</th>
		  	<td><cfinput name="misccharge1" type="text" maxlength="30" size="30" value="#misccharge1#"></td>
		</tr>
        <tr> 
		  	<th>Misc. Charges (2)</th>
		  	<td><cfinput name="misccharge2" type="text" maxlength="30" size="30" value="#misccharge2#"></td>
		</tr>
        <tr> 
		  	<th>Misc. Charges (3)</th>
		  	<td><cfinput name="misccharge3" type="text" maxlength="30" size="30" value="#misccharge3#"></td>
		</tr>
        <tr> 
		  	<th>Misc. Charges (4)</th>
		  	<td><cfinput name="misccharge4" type="text" maxlength="30" size="30" value="#misccharge4#"></td>
		</tr>
        <tr> 
		  	<th>Misc. Charges (5)</th>
		  	<td><cfinput name="misccharge5" type="text" maxlength="30" size="30" value="#misccharge5#"></td>
		</tr>
        <tr> 
		  	<th>Misc. Charges (6)</th>
		  	<td><cfinput name="misccharge6" type="text" maxlength="30" size="30" value="#misccharge6#"></td>
		</tr>
        <tr> 
		  	<th>Misc. Charges (7)</th>
		  	<td><cfinput name="misccharge7" type="text" maxlength="30" size="30" value="#misccharge7#"></td>
		</tr>
		<tr> 
		  	<th>Body Remark 1</th>
		  	<td><cfinput name="brem1" type="text" maxlength="30" size="30" value="#brem1#"></td>
		</tr>
		<tr> 
		  	<th>Body Remark 2</th>
		  	<td><cfinput name="brem2" type="text" maxlength="30" size="30" value="#brem2#"></td>
		</tr>
		<tr> 
		  	<th>Body Remark 3</th>
		  	<td><cfinput name="brem3" type="text" maxlength="30" size="30" value="#brem3#"></td>
		</tr>
		<tr> 
		  	<th>Body Remark 4</th>
		  	<td><cfinput name="brem4" type="text" maxlength="30" size="30" value="#brem4#"></td>
		</tr>
        
        <cfif getGeneralInfo.addonremark eq 'Y'>
        <tr> 
		  	<th>Header Remark 30</th>
		  	<td><cfinput name="rem30" type="text" maxlength="30" size="30" value="#rem30#"></td>
		</tr>
        <tr> 
		  	<th>Header Remark 31</th>
		  	<td><cfinput name="rem31" type="text" maxlength="30" size="30" value="#rem31#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 32</th>
		  	<td><cfinput name="rem32" type="text" maxlength="30" size="30" value="#rem32#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 33</th>
		  	<td><cfinput name="rem33" type="text" maxlength="30" size="30" value="#rem33#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 34</th>
		  	<td><cfinput name="rem34" type="text" maxlength="30" size="30" value="#rem34#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 35</th>
		  	<td><cfinput name="rem35" type="text" maxlength="30" size="30" value="#rem35#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 36</th>
		  	<td><cfinput name="rem36" type="text" maxlength="30" size="30" value="#rem36#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 37</th>
		  	<td><cfinput name="rem37" type="text" maxlength="30" size="30" value="#rem37#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 38</th>
		  	<td><cfinput name="rem38" type="text" maxlength="30" size="30" value="#rem38#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 39</th>
		  	<td><cfinput name="rem39" type="text" maxlength="30" size="30" value="#rem39#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 40</th>
		  	<td><cfinput name="rem40" type="text" maxlength="30" size="30" value="#rem40#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 41</th>
		  	<td><cfinput name="rem41" type="text" maxlength="30" size="30" value="#rem41#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 42</th>
		  	<td><cfinput name="rem42" type="text" maxlength="30" size="30" value="#rem42#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 43</th>
		  	<td><cfinput name="rem43" type="text" maxlength="30" size="30" value="#rem43#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 44</th>
		  	<td><cfinput name="rem44" type="text" maxlength="30" size="30" value="#rem44#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 45</th>
		  	<td><cfinput name="rem45" type="text" maxlength="30" size="30" value="#rem45#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 46</th>
		  	<td><cfinput name="rem46" type="text" maxlength="30" size="30" value="#rem46#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 47</th>
		  	<td><cfinput name="rem47" type="text" maxlength="30" size="30" value="#rem47#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 48</th>
		  	<td><cfinput name="rem48" type="text" maxlength="30" size="30" value="#rem48#"></td>
		</tr>
                <tr> 
		  	<th>Header Remark 49</th>
		  	<td><cfinput name="rem49" type="text" maxlength="30" size="30" value="#rem49#"></td>
		</tr>

        
        
        </cfif>
		<tr> 
		  	<td colspan="2" align="center">
				<input name="submit" type="submit" value="Save">
			  	<input name="reset" type="reset" value="Reset">
			</td>
		</tr>
	</table>
</cfform>

</body>
</html>