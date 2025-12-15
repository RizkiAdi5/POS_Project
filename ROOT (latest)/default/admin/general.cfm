<html>
<head>
<title>Company Profile</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<h4>
	<cfif getpin2.h5110 eq "T"><a href="comprofile.cfm">Company Profile</a> </cfif>
    <cfif getpin2.h5120 eq "T">|| <a href="lastusedno.cfm">Last Used No</a> </cfif>
    <cfif getpin2.h5130 eq "T">|| <a href="transaction.cfm">Transaction Setup</a> </cfif>
    <cfif getpin2.h5140 eq "T">|| <a href="Accountno.cfm">UBS Accounting Default Setup</a> </cfif> 
    <cfif getpin2.h5150 eq "T">|| <a href="userdefine.cfm">User Defined</a> </cfif>
    <cfif getpin2.h5160 eq "T">||<a href="dealer_menu/dealer_menu.cfm">Dealer Menu</a> </cfif> 
    <cfif getpin2.h5170 eq "T">||<a href="transaction_menu/transaction_menu.cfm">Transaction Menu</a> </cfif> 
    <cfif getpin2.h5180 eq "T">||<a href="userdefineformula.cfm">User Define - Formula</a></cfif>
    <cfif husergrpid eq "super">||<a href="modulecontrol.cfm">Module Control</a></cfif>
</h4>

<h1 align="center">General Setup</h1>

<table align="center" class="data" width="300px" cellpadding="4" cellspacing="0">
<cfif getpin2.h5110 eq "T">
	<tr> 
		<th class="net001"><a href="comprofile.cfm">Company Profile</a></th>
    </tr>
    </cfif>
    <cfif getpin2.h5120 eq "T">
	<tr> 
		<th class="net001"><a href="lastusedno.cfm">Last Used No</a></th>
	</tr>
    </cfif>
    <cfif getpin2.h5130 eq "T">
	<tr> 
		<th class="net001"><a href="transaction.cfm">Transaction Setup</a></th>
	</tr>
    </cfif>
    <cfif getpin2.h5140 eq "T">
	<tr> 
		<th class="net001"><a href="Accountno.cfm">UBS Accounting Default Setup</a></th>
	</tr>
    </cfif>
    <cfif getpin2.h5150 eq "T">
	<tr> 
		<th class="net001"><a href="userdefine.cfm">User Defined</a></th>
	</tr>
    </cfif>
    <cfif getpin2.h5160 eq "T">
	<tr> 
		<th class="net001"><a href="dealer_menu/dealer_menu.cfm">Dealer Menu</a></th>
	</tr>
    </cfif>
    <cfif getpin2.h5170 eq "T">
	<tr> 
		<th class="net001"><a href="transaction_menu/transaction_menu.cfm">Transaction Menu</a></th>
	</tr>
    </cfif>
    <cfif getpin2.h5180 eq "T">
	<tr> 
		<th class="net001"><a href="userdefineformula.cfm">User Define - Formula</a></th>
	</tr>
    </cfif>
</table>

</body>
</html>