<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Testing</title>
<link rel="stylesheet" type="text/css" href="/newinterface2/css1.css" />
<script language="javascript" type="text/javascript" src="/scripts/change_left_menunew.js"></script>

</head>

<body class="netiquette" onload="SwitchMenu('sub1')">
<cfquery name="getgeneral" datasource="#dts#">
SELECT * FROM gsetup
</cfquery>

<cfquery name="getlanguage" datasource="#dts#">
select * from main.menulang
</cfquery>

<cfquery name="getmodule" datasource="#dts#">
	select * 
	from modulecontrol;
</cfquery>

<cfset menutitle=StructNew()>
<cfloop query="getlanguage">
<cfif getgeneral.dflanguage eq 'english'>
<cfset menutitle['#getlanguage.no#']=getlanguage.eng>
<cfelseif getgeneral.dflanguage eq 'sim_ch'>
<cfset menutitle['#getlanguage.no#']=getlanguage.sim_ch>
<cfelseif getgeneral.dflanguage eq 'tra_ch'>
<cfset menutitle['#getlanguage.no#']=getlanguage.tra_ch>
</cfif>
</cfloop>

<cfoutput>
<div style="overflow:hidden;">
<div class="secondary_menu">
<div id="masterdiv">
<cfif getpin2.h1200 eq "T" or  getpin2.h1100 eq "T" or getpin2.h1300 eq "T">
<li onClick="SwitchMenu('sub1')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[126]#</cfoutput>">
<cfoutput>#menutitle[126]#</cfoutput></a></li>
<span id="sub1" style="display:none;" class="submenu">
<cfif getpin2.h1200 eq "T">
<li>
	<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/linkPage.cfm?type=Customer" target="mainFrame" title="<cfoutput>#menutitle[2]#</cfoutput>">
		<cfoutput>#menutitle[2]#</cfoutput>
	</a>
</li>
</cfif>
<cfif getpin2.h1100 eq "T">
<li>
	<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/linkPage.cfm?type=Supplier" target="mainFrame" title="<cfoutput>#menutitle[3]#</cfoutput>">
		<cfoutput>#menutitle[3]#</cfoutput>
	</a>
</li>
</cfif>
<cfif getpin2.h1300 eq "T">
<li>
	<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/s_icitem.cfm?type=icitem" target="mainFrame" title="<cfoutput>#menutitle[4]#</cfoutput>">
    	<cfif getgeneral.dflanguage eq 'english'>
                	#getgeneral.litemno# Profile
        <cfelse>
        <cfoutput>#menutitle[4]#</cfoutput>
        </cfif>
	</a>
</li>
</cfif>

</span>
</cfif>

<cfif getpin2.h1400 eq "T" or  getpin2.h1500 eq "T" or getpin2.h1600 eq "T" or  getpin2.h1700 eq "T" or getpin2.h1800 eq "T" or getpin2.h1900 eq "T" or getpin2.h1P00 eq "T" >
<li onClick="SwitchMenu('sub2')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[128]#</cfoutput>">
<cfoutput>#menutitle[128]#</cfoutput></a></li>
<span id="sub2" style="display:none;" class="submenu">
<cfif getpin2.h1400 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/categorytable.cfm" target="mainFrame" title="<cfoutput>#menutitle[6]#</cfoutput>">
                <cfif getgeneral.dflanguage eq 'english'>
               		#getgeneral.lcategory# Profile
                <cfelse>
                <cfoutput>#menutitle[6]#</cfoutput>
                </cfif>
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1500 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/grouptable.cfm" target="mainFrame" title="<cfoutput>#menutitle[7]#</cfoutput>">
				<cfif getgeneral.dflanguage eq 'english'>
                	#getgeneral.lgroup# Profile
                <cfelse>
                <cfoutput>#menutitle[7]#</cfoutput>
                </cfif>
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1600 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/sizeidtable.cfm" target="mainFrame" title="<cfoutput>#menutitle[8]#</cfoutput>">
				<cfif getgeneral.dflanguage eq 'english'>
               #getgeneral.lsize# Profile
                <cfelse>
                <cfoutput>#menutitle[8]#</cfoutput>
                </cfif>
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1700 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/costcodetable.cfm" target="mainFrame" title="<cfoutput>#menutitle[129]#</cfoutput>">
				<cfif getgeneral.dflanguage eq 'english'>
               		#getgeneral.lrating# Profile		
                    <cfelse>
                    <cfoutput>#menutitle[129]#</cfoutput>
                    </cfif>
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1800 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/coloridtable.cfm" target="mainFrame" title="<cfoutput>#menutitle[10]#</cfoutput>">
				<cfif getgeneral.dflanguage eq 'english'>
               #getgeneral.lMaterial# Profile
                <cfelse>
                <cfoutput>#menutitle[10]#</cfoutput>
                </cfif>
                
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1900 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/shelftable.cfm" target="mainFrame" title="<cfoutput>#menutitle[130]#</cfoutput>">
				<cfif getgeneral.dflanguage eq 'english'>
               				#getgeneral.lModel# Profile
                    <cfelse>
                    <cfoutput>#menutitle[130]#</cfoutput>
                    </cfif>
			</a>
		</li>
	</cfif>
    <cfif getpin2.h1P00 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/brandtable.cfm" target="mainFrame" title="<cfoutput>#menutitle[12]#</cfoutput>">
            <cfif getgeneral.dflanguage eq 'english'>
            #getgeneral.lbrand# Profile
            <cfelse>
				<cfoutput>#menutitle[12]#</cfoutput>
			</cfif>
            </a>
		</li>
	</cfif>
</span>
</cfif>

<cfif  getpin2.h1B00 eq "T" or getpin2.h1Z60 eq "T" or getpin2.h1C00 eq "T">
<li onClick="SwitchMenu('sub3')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[131]#</cfoutput>">
<cfoutput>#menutitle[131]#</cfoutput></a></li>
<span id="sub3" style="display:none;" class="submenu">

	<cfif getpin2.h1B00 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/agenttable.cfm" target="mainFrame" title="<cfoutput>#menutitle[15]#</cfoutput>">
				<cfif getgeneral.dflanguage eq 'english'>
               #getgeneral.lAGENT# Profile
                <cfelse>
                <cfoutput>#menutitle[15]#</cfoutput>
                </cfif>
			</a>
		</li>
	</cfif>
   	<cfif lcase(husergrpid) eq 'admin' or lcase(husergrpid) eq 'super'>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/cashiertable.cfm" target="mainFrame" title="<cfoutput>#menutitle[21]#</cfoutput>">
              Cashier Profile
			</a>
		</li>
        
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/supervisortable.cfm" target="mainFrame" title="<cfoutput>Supervisor Profile</cfoutput>">
              Supervisor Profile
			</a>
		</li>
    </cfif>
	<cfif getpin2.h1C00 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/vdriver.cfm" target="mainFrame" title="<cfoutput>#menutitle[21]#</cfoutput>">
				<cfif getgeneral.dflanguage eq 'english'>
               #getgeneral.lDRIVER# Profile
                <cfelse>
                <cfoutput>#menutitle[21]#</cfoutput>
                </cfif>
			</a>
		</li>
	</cfif>
	<cfif getpin2.h1D00 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/s_locationtable.cfm" target="mainFrame" title="<cfoutput>#menutitle[22]#</cfoutput>">
				<cfif getgeneral.dflanguage eq 'english'>
               #getgeneral.lLOCATION# Profile
                <cfelse>
                <cfoutput>#menutitle[22]#</cfoutput>
                </cfif>
			</a>
		</li>
	</cfif>

</span>
</cfif>


<li onClick="SwitchMenu('sub4')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[142]#</cfoutput>">
<cfoutput>#menutitle[142]#</cfoutput></a></li>
<span id="sub4" style="display:none;" class="submenu">

        
    <cfif getpin2.h1Y00 eq "T">    
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/termsandconditiontable.cfm" target="mainFrame" title="<cfoutput>#menutitle[35]#</cfoutput>">
				<cfoutput>#menutitle[35]#</cfoutput>
			</a>
		</li>
        </cfif>
	<!---
    <cfif getpin2.h1R00 eq "T">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/voucher/voucher.cfm" target="mainFrame" title="<cfoutput>#menutitle[36]#</cfoutput>">
				<cfoutput>#menutitle[36]#</cfoutput>
			</a>
		</li>
     </cfif>
     --->
     <cfif getpin2.h1Z30 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/promotion/" target="mainFrame" title="<cfoutput>#menutitle[37]#</cfoutput>">
				<cfoutput>#menutitle[37]#</cfoutput>
			</a>
		</li>
     </cfif>
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/vouchertype/s_vouchertable.cfm" target="mainFrame" title="<cfoutput>Voucher Type</cfoutput>">
				<cfoutput>Voucher Type</cfoutput>
			</a>
		</li>
 

        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/counter/countertable.cfm" target="mainFrame" title="<cfoutput>#menutitle[40]#</cfoutput>">
				<cfoutput>#menutitle[40]#</cfoutput>
			</a>
		</li>
        


        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/discounttable.cfm" target="mainFrame" title="<cfoutput>#menutitle[413]#</cfoutput>">
				<cfoutput>#menutitle[413]#</cfoutput>
			</a>
		</li>

 
</span>


<a class="oe_secondary_submenu_item" href="https://www.teamviewer.com/link/?url=505374&id=625664214" style="text-decoration:none; text-align:left">
    <img src="https://www.teamviewer.com/link/?url=979936&id=625664214" alt="TeamViewer for Remote Support" title="TeamViewer for Remote Support" border="0" width="130" height="50">
</a>

<a class="oe_secondary_submenu_item" href="https://showmypc.com/ShowMyPC3150.exe" style="text-decoration:none; text-align:left">
	<img src="https://showmypc.com/images/home/remote-support-logo2521.jpg" alt="ShowMyPc for Remote Support" title="Show My Pc for Remote Support" border="0" width="130" height="50">
</a>
</div>
</div>
</div>
</cfoutput>
</body>
</html>
