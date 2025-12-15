<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Testing</title>
<link rel="stylesheet" type="text/css" href="/newinterface2/css1.css" />
<script language="javascript" type="text/javascript" src="/scripts/change_left_menunew.js"></script>

</head>

<body class="netiquette">
<cfquery name="getGeneralInfo" datasource="#dts#">
	select * 
	from gsetup;
</cfquery>
<cfquery name="getmodule" datasource="#dts#">
	select * 
	from modulecontrol;
</cfquery>

<cfquery name="getlanguage" datasource="#dts#">
select * from main.menulang
</cfquery>

<cfset menutitle=StructNew()>
<cfloop query="getlanguage">
<cfif getGeneralInfo.dflanguage eq 'english'>
<cfset menutitle['#getlanguage.no#']=getlanguage.eng>
<cfelseif getGeneralInfo.dflanguage eq 'sim_ch'>
<cfset menutitle['#getlanguage.no#']=getlanguage.sim_ch>
<cfelseif getGeneralInfo.dflanguage eq 'tra_ch'>
<cfset menutitle['#getlanguage.no#']=getlanguage.tra_ch>
</cfif>
</cfloop>

<cfoutput>
<div style="overflow:hidden;">
<div class="secondary_menu">
<div id="masterdiv">
<cfif getpin2.h6000 eq "T">
        <cfif getpin2.h6700 eq "T" or getpin2.h6600 eq "T" or getpin2.h6500 eq "T" or getpin2.h6400 eq "T" or getpin2.h6300 eq "T" or getpin2.h6200 eq "T" or getpin2.h6100 eq "T">
        <li onClick="SwitchMenu('sub18')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[148]#</cfoutput>">
        <cfoutput>#menutitle[148]#</cfoutput></a></li>
<span id="sub18" style="display:none;" class="submenu">
<cfif getpin2.h6900 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=PO&name=Purchase Order&BilType=" target="mainFrame" title="<cfoutput>#menutitle[68]#</cfoutput>">
			<cfoutput>#menutitle[68]#</cfoutput>
		</a>
	</li>
    </cfif>
    
       <cfif getpin2.h6500 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=RC&name=Receive&BilType=" target="mainFrame" title="<cfoutput>#menutitle[64]#</cfoutput>">
                        <cfoutput>#menutitle[64]#</cfoutput>
                    </a>
                </li>
                </cfif>
                <cfif getpin2.h6600 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=PR&name=Purchase Return&BilType=" target="mainFrame" title="<cfoutput>#menutitle[65]#</cfoutput>">
                        <cfoutput>#menutitle[65]#</cfoutput>
                    </a>
                </li>
                </cfif>
                

			
                
             
                
                
                
    </span>
    </cfif>
    
   <!--- <cfif getpin2.h6C00 eq "T" or getpin2.h6D00 eq "T" or getpin2.h6E00 eq "T">
    <li onClick="SwitchMenu('sub2')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[49]#</cfoutput>"><cfoutput>#menutitle[49]#</cfoutput></a></li>
                <span id="sub2" style="display:none;" class="submenu">
    
    
    </span>
    </cfif>--->
    
    
    
    <cfif getpin2.h6900 eq "T" or getpin2.h6A00 eq "T" or getpin2.h6B00 eq "T">
    <li onClick="SwitchMenu('sub3')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[155]#</cfoutput>"><cfoutput>#menutitle[155]#</cfoutput></a></li>
                <span id="sub3" style="display:none;" class="submenu">
       <cfif getpin2.h6B00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=QUO&name=Quotation&BilType=" target="mainFrame" title="<cfoutput>#menutitle[70]#</cfoutput>">
			<cfoutput>#menutitle[70]#</cfoutput>
		</a>
	</li>
    </cfif>

    
    <cfif getpin2.h6A00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=SO&name=Sales Order&BilType=" target="mainFrame" title="<cfoutput>#menutitle[69]#</cfoutput>">
			<cfoutput>#menutitle[69]#</cfoutput>
		</a>
	</li>
    </cfif>
 <cfif getpin2.h6700 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=DO&name=Delivery Order&BilType=DO" target="mainFrame" title="<cfoutput>#menutitle[66]#</cfoutput>">
                        <cfoutput>#menutitle[66]#</cfoutput>
                    </a>
                </li>
                </cfif>
                
                <cfif getpin2.h6100 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=INV&name=Invoice&BilType=" target="mainFrame" title="<cfoutput>#menutitle[60]#</cfoutput>">
                        <cfoutput>#menutitle[60]#</cfoutput>
                    </a>
                </li>
                </cfif>
                <cfif getpin2.h6200 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=CS&name=Cash Bills&BilType=" target="mainFrame" title="<cfoutput>#menutitle[61]#</cfoutput>">
                        <cfoutput>#menutitle[61]#</cfoutput>
                    </a>
                </li>
                </cfif>
                
                <cfif getpin2.h6300 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=CN&name=Credit Note&BilType=" target="mainFrame" title="<cfoutput>#menutitle[62]#</cfoutput>">
                        <cfoutput>#menutitle[62]#</cfoutput>
                    </a>
                </li>
                </cfif>
                <cfif getpin2.h6400 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=DN&name=Debit Note&BilType=" target="mainFrame" title="<cfoutput>#menutitle[63]#</cfoutput>">
                        <cfoutput>#menutitle[63]#</cfoutput>
                    </a>
                </li>
                </cfif>
    
    </span>
    </cfif>
    
    
    <cfif getpin2.h6F00 eq "T" or getpin2.h6G00 eq "T" or getpin2.h6H00 eq "T" or getpin2.h6I00 eq "T">
     <li onClick="SwitchMenu('sub4')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[163]#</cfoutput>"><cfoutput>#menutitle[163]#</cfoutput></a></li>
    <span id="sub4" style="display:none;" class="submenu">
    <cfif getpin2.h6C00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=ISS&name=Issue&BilType=" target="mainFrame" title="<cfoutput>#menutitle[71]#</cfoutput>">
			<cfoutput>#menutitle[71]#</cfoutput>
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6D00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=OAI&name=Adjustment Increase&BilType=" target="mainFrame" title="<cfoutput>#menutitle[72]#</cfoutput>">
			<cfoutput>#menutitle[72]#</cfoutput>
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6E00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=OAR&name=Adjustment Reduce&BilType=" target="mainFrame" title="<cfoutput>#menutitle[73]#</cfoutput>">
			<cfoutput>#menutitle[73]#</cfoutput>
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6F00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=TR&name=Transfer Note&BilType=" target="mainFrame" title="<cfoutput>#menutitle[74]#</cfoutput>">
			<cfoutput>#menutitle[74]#</cfoutput>
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6G00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=TR&name=Transfer Note 2&BilType=" target="mainFrame" title="<cfoutput>#menutitle[75]#</cfoutput>">
			<cfoutput>#menutitle[75]#</cfoutput>
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6H00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=TR&name=Consignment Note&BilType=" target="mainFrame" title="<cfoutput>#menutitle[76]#</cfoutput>">
			<cfoutput>#menutitle[76]#</cfoutput>
		</a>
	</li>
    </cfif>
    <cfif getpin2.h6I00 eq "T">
	<li>
		<a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=TR&name=Consignment Return&BilType=" target="mainFrame" title="<cfoutput>#menutitle[77]#</cfoutput>">
			<cfoutput>#menutitle[77]#</cfoutput>
		</a>
	</li>
    </cfif>
    
    </span>
    </cfif>
    
        <cfif getpin2.h6800 eq "T">
        <li onClick="SwitchMenu('sub11')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[411]#</cfoutput>"><cfoutput>#menutitle[411]#</cfoutput></a></li>
       <span id="sub11" style="display:none;" class="submenu">
			<cfif getpin2.h6800 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/print_bills/generate_print_bills.cfm?type=DO&name=Packing List&BilType=" target="mainFrame" title="<cfoutput>#menutitle[67]#</cfoutput>">
                    <cfoutput>#menutitle[67]#</cfoutput>
                </a>
            </li>
            </cfif>
    </span>
    </cfif>
    
</cfif>

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
