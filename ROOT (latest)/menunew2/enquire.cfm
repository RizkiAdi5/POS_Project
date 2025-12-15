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


<cfif getpin2.h3000 eq "T">
	
	<cfif getpin2.h3500 eq "T">
    <li onClick="SwitchMenu('sub2')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[80]#</cfoutput>"><cfoutput>#menutitle[80]#</cfoutput></a></li>
<span id="sub2" style="display:none;" class="submenu">
		
        <li onClick="SwitchMenu2('sub3')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[180]#</cfoutput>"><cfoutput>#menutitle[180]#</cfoutput></a></li>
                <span id="sub3" style="display:none;" class="submenu2">
       
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/enquires/historypriceenquiry/historypriceform.cfm?history=customeritemlastprice" target="mainFrame" title="<cfoutput>#menutitle[181]#</cfoutput>">
				<cfoutput>#menutitle[181]#</cfoutput>
			</a>
		</li>
        
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/enquires/historypriceenquiry/historypriceform.cfm?history=customeritemtransactedprice" target="mainFrame" title="<cfoutput>#menutitle[182]#</cfoutput>">
				<cfoutput>#menutitle[182]#</cfoutput>
			</a>
		</li>
        </span>

        <li onClick="SwitchMenu2('sub4')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[183]#</cfoutput>"><cfoutput>#menutitle[183]#</cfoutput></a></li>
                <span id="sub4" style="display:none;" class="submenu2">
       
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/enquires/historypriceenquiry/historypriceform.cfm?history=itemcustomertransactedprice" target="mainFrame" title="<cfoutput>#menutitle[184]#</cfoutput>">
				<cfoutput>#menutitle[184]#</cfoutput>
			</a>
		</li>

        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/enquires/historypriceenquiry/historypriceform.cfm?history=itemsupplierlastprice" target="mainFrame" title="<cfoutput>#menutitle[185]#</cfoutput>">
				<cfoutput>#menutitle[185]#</cfoutput>
			</a>
		</li>

        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/enquires/historypriceenquiry/historypriceform.cfm?history=itemsuppliertransactedprice" target="mainFrame" title="<cfoutput>#menutitle[186]#</cfoutput>">
				<cfoutput>#menutitle[186]#</cfoutput>
			</a>
		</li>

        </span>

        <li onClick="SwitchMenu2('sub5')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[187]#</cfoutput>"><cfoutput>#menutitle[187]#</cfoutput></a></li>
                <span id="sub5" style="display:none;" class="submenu2">

                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/enquires/historypriceenquiry/historypriceform.cfm?history=supplieritemtransactedprice" target="mainFrame" title="<cfoutput>#menutitle[182]#</cfoutput>">
                        <cfoutput>#menutitle[182]#</cfoutput>
                    </a>
                </li>

                </span>

        <li onClick="SwitchMenu2('sub6')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[411]#</cfoutput>"><cfoutput>#menutitle[411]#</cfoutput></a></li>
        <span id="sub6" style="display:none;" class="submenu2">

        <li>
            <a class="oe_secondary_submenu_item" href="/#HDir#/enquires/historypriceenquiry/historypriceform.cfm?history=adjustedtransactioncost" target="mainFrame" title="<cfoutput>#menutitle[188]#</cfoutput>">
                <cfoutput>#menutitle[188]#</cfoutput>
            </a>
        </li>

        </span>
        
        
    </span>
	</cfif>
    
	<cfif getpin2.h3100 eq "T">
    	<li onClick="SwitchMenu('sub9')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[83]#</cfoutput>"><cfoutput>#menutitle[83]#</cfoutput></a></li>
<span id="sub9" style="display:none;" class="submenu">
		<cfif getpin2.h3110 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/enquires/item_enquires.cfm" target="mainFrame" title="<cfoutput>#menutitle[198]#</cfoutput>">
				<cfoutput>#menutitle[198]#</cfoutput>
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
