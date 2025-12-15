<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Testing</title>
<link rel="stylesheet" type="text/css" href="/newinterface2/css1.css" />
<script language="javascript" type="text/javascript" src="/scripts/change_left_menunew.js"></script>

</head>

<body class="netiquette">
<cfquery name="getGeneral" datasource="#dts#">
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
<cfif getpin2.h5000 eq "T">
<cfif getpin2.h5100 eq "T" or getpin2.h5110 eq "T" or getpin2.h5120 eq "T" or getpin2.h5130 eq "T" or getpin2.h5140 eq "T" or getpin2.h5150 eq "T" or getpin2.h5160 eq "T" or getpin2.h5170 eq "T" or getpin2.h5180 eq "T">
		<li onClick="SwitchMenu('sub1')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[105]#</cfoutput>">
            <cfoutput>#menutitle[105]#</cfoutput></a>
        </li>
            <span id="sub1" style="display:none;" class="submenu">
            <cfif getpin2.h5110 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/admin/comprofile.cfm" target="mainFrame" title="<cfoutput>#menutitle[360]#</cfoutput>">
                	<cfoutput>#menutitle[360]#</cfoutput>   
                </a>
            </li>
            <li>
			<a class="oe_secondary_submenu_item" href="/changetable.cfm" target="Top">
				Update Table
			</a>
			</li>
            <li>
			<a class="oe_secondary_submenu_item" href="/repairtable.cfm" target="Top">
				Repair Table
			</a>
			</li>
            
            <li>
			<a class="oe_secondary_submenu_item" href="/updatetax.cfm" target="Top">
				Update tax
			</a>
			</li>
            
            </cfif>
            
            
            <cfif getpin2.h5120 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/admin/lastusedno.cfm" target="mainFrame" title="<cfoutput>#menutitle[361]#</cfoutput>">
                	<cfoutput>#menutitle[361]#</cfoutput>     
                </a>
            </li>
            </cfif>
            <cfif getpin2.h5130 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/admin/transaction.cfm" target="mainFrame" title="<cfoutput>#menutitle[362]#</cfoutput>">
                   <cfoutput>#menutitle[362]#</cfoutput> 
                </a>
            </li>
            </cfif>
          
            <cfif getpin2.h5150 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/admin/userdefine.cfm" target="mainFrame" title="<cfoutput>#menutitle[364]#</cfoutput>">
                    <cfoutput>#menutitle[364]#</cfoutput> 
                </a>
            </li>
            </cfif>
            <cfif getpin2.h5160 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/admin/dealer_menu/dealer_menu.cfm" target="mainFrame" title="<cfoutput>#menutitle[365]#</cfoutput>">
                    <cfoutput>#menutitle[365]#</cfoutput> 
                </a>
            </li>
            </cfif>
         	<li>
			<a class="oe_secondary_submenu_item" href="/updatelocationbf.cfm" target="Top">
				Update Location qtybf to qtybf
			</a>
			</li>
            
	</span>
    </cfif>
    <cfif getpin2.h5300 eq "T" or getpin2.h5500 eq "T">
        <li onClick="SwitchMenu('sub2')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[368]#</cfoutput>">
        <cfoutput>#menutitle[368]#</cfoutput> </a></li>
        <span id="sub2" style="display:none;" class="submenu">
            <cfif getpin2.h5300 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/admin/vuser.cfm" target="mainFrame" title="<cfoutput>#menutitle[106]#</cfoutput>">
                        <cfoutput>#menutitle[106]#</cfoutput>
                    </a>
                </li>
            </cfif>
            <cfif getpin2.h5500 eq "T">
                <li>
                    <!---a href="/#HDir#/admin/userdefinedmenu.cfm" target="mainFrame">
                        User Defined Menu
                    </a--->
                    <a class="oe_secondary_submenu_item" href="/#HDir#/admin/userdefinedmenu/usergroup.cfm" target="mainFrame" title="<cfoutput>#menutitle[107]#</cfoutput>">
                        <cfoutput>#menutitle[107]#</cfoutput>
                    </a>
                </li>
        	</cfif>
             <cfif getpin2.h5300 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/changepass/index.cfm" target="mainFrame" title="<cfoutput>#menutitle[431]#</cfoutput>">
                        <cfoutput>#menutitle[431]#</cfoutput>
                    </a>
                </li>
            </cfif>
            
            <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/backupdata/index.cfm" target="mainFrame">
				BACKUP
			</a>
	</li>
    </span>
    </cfif>
    
    <cfif getpin2.h5200 eq "T" and (husergrpid eq "super" or hcomid eq 'aepl_i' or hcomid eq 'aeisb_i' or hcomid eq 'risb_i')>
        <li onClick="SwitchMenu('sub15')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="Year End">
    	<cfoutput>Year End</cfoutput></a></li>
    <span id="sub15" style="display:none;" class="submenu">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/admin/yearend.cfm" target="mainFrame" title="<cfoutput>#menutitle[371]#</cfoutput>">
				<cfoutput>#menutitle[371]#</cfoutput> 
			</a>
		</li>
        
		<!---<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recalculatelocationqty.cfm" target="mainFrame">
				Location QtyBf Calculation After Year-End
			</a>
		</li>--->

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