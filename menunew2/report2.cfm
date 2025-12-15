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
<cfif getpin2.h4000 eq "T">
<cfif getpin2.h4100 eq "T">
	<li onClick="SwitchMenu('sub1')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[89]#</cfoutput>"><cfoutput>#menutitle[89]#</cfoutput></a></li>
<span id="sub1" style="display:none;" class="submenu">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=1" target="mainFrame" title="<cfoutput>#menutitle[42]#</cfoutput>">
				<cfoutput>#menutitle[42]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=2" target="mainFrame" title="<cfoutput>#menutitle[43]#</cfoutput>">
				<cfoutput>#menutitle[43]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=3" target="mainFrame" title="<cfoutput>#menutitle[44]#</cfoutput>">
				<cfoutput>#menutitle[44]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=4" target="mainFrame" title="<cfoutput>#menutitle[45]#</cfoutput>">
				<cfoutput>#menutitle[45]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=9" target="mainFrame" title="<cfoutput>#menutitle[70]#</cfoutput>">
				<cfoutput>#menutitle[70]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=5" target="mainFrame" title="<cfoutput>#menutitle[47]#</cfoutput>">
				<cfoutput>#menutitle[47]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=6" target="mainFrame" title="<cfoutput>#menutitle[48]#</cfoutput>">
				<cfoutput>#menutitle[48]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=7" target="mainFrame" title="<cfoutput>#menutitle[46]#</cfoutput>">
				<cfoutput>#menutitle[46]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=8" target="mainFrame" title="<cfoutput>#menutitle[68]#</cfoutput>">
				<cfoutput>#menutitle[68]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=10" target="mainFrame" title="<cfoutput>#menutitle[69]#</cfoutput>">
				<cfoutput>#menutitle[69]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=11" target="mainFrame" title="<cfoutput>#menutitle[157]#</cfoutput>">
				<cfoutput>#menutitle[157]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=12" target="mainFrame" title="<cfoutput>#menutitle[71]#</cfoutput>">
				<cfoutput>#menutitle[71]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=13" target="mainFrame" title="<cfoutput>#menutitle[72]#</cfoutput>">
				<cfoutput>#menutitle[72]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=14" target="mainFrame" title="<cfoutput>#menutitle[73]#</cfoutput>">
				<cfoutput>#menutitle[73]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=15" target="mainFrame" title="<cfoutput>#menutitle[74]#</cfoutput>">
				<cfoutput>#menutitle[74]#</cfoutput>
			</a>
		</li>
         <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=16" target="mainFrame" title="<cfoutput>#menutitle[417]#</cfoutput>">
				<cfoutput>#menutitle[417]#</cfoutput>
			</a>
		</li>
         <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=17" target="mainFrame" title="<cfoutput>#menutitle[418]#</cfoutput>">
				<cfoutput>#menutitle[418]#</cfoutput>
			</a>
		</li>
        
    </span>
	</cfif>
	<cfif getpin2.h4200 eq "T">
    <li onClick="SwitchMenu('sub2')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[90]#</cfoutput>"><cfoutput>#menutitle[90]#</cfoutput></a></li>
<span id="sub2" style="display:none;" class="submenu">
		<li onClick="SwitchMenu2('sub3')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[208]#</cfoutput>">
        <cfoutput>#menutitle[208]#</cfoutput></a></li>
                <span id="sub3" style="display:none;" class="submenu2">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/stockcard.cfm?type=1" target="mainFrame" title="<cfoutput>#menutitle[209]#</cfoutput>">
				<cfoutput>#menutitle[209]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/reorderadvise.cfm?type=2" target="mainFrame" title="<cfoutput>#menutitle[210]#</cfoutput>">
				<cfoutput>#menutitle[210]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/stockaging.cfm" target="mainFrame" title="<cfoutput>#menutitle[211]#</cfoutput>">
				<cfoutput>#menutitle[211]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/physical_worksheet_menu.cfm" target="mainFrame" title="<cfoutput>#menutitle[212]#</cfoutput>">
				<cfoutput>#menutitle[212]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/transsummary.cfm?type=Quantity" target="mainFrame" title="<cfoutput>#menutitle[213]#</cfoutput>">
				<cfoutput>#menutitle[213]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/transsummary.cfm?type=Value" target="mainFrame" title="<cfoutput>#menutitle[214]#</cfoutput>">
				<cfoutput>#menutitle[214]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/dailystockcard.cfm" target="mainFrame" title="<cfoutput>#menutitle[215]#</cfoutput>">
				<cfoutput>#menutitle[215]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/itemstockcard1.cfm" target="mainFrame" title="<cfoutput>#menutitle[216]#</cfoutput>">
				<cfoutput>#menutitle[216]#</cfoutput>
			</a>
		</li>
        </span>
        
        <li onClick="SwitchMenu2('sub4')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[217]#</cfoutput>">
        <cfoutput>#menutitle[217]#</cfoutput></a></li>
                <span id="sub4" style="display:none;" class="submenu2">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/itemstatus.cfm?type=3" target="mainFrame" title="<cfoutput>#menutitle[218]#</cfoutput>">
				<cfoutput>#menutitle[218]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/groupstatus.cfm?type=4" target="mainFrame" title="<cfoutput>#menutitle[219]#</cfoutput>">
				<cfoutput>#menutitle[219]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/catestatus.cfm?type=4" target="mainFrame" title="<cfoutput>#menutitle[220]#</cfoutput>">
				<cfoutput>#menutitle[220]#</cfoutput>
			</a>
		</li>
        
        </span>        
    </span>
	</cfif>
    
	<cfif getpin2.h4300 eq "T">
    <li onClick="SwitchMenu('sub5')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[91]#</cfoutput>"><cfoutput>#menutitle[91]#</cfoutput></a></li>
<span id="sub5" style="display:none;" class="submenu">
		
        <li onClick="SwitchMenu2('sub6')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[221]#</cfoutput>"><cfoutput>#menutitle[221]#</cfoutput></a></li>
                <span id="sub6" style="display:none;" class="submenu2">
                	       
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=producttype" target="mainFrame" title="<cfoutput>#menutitle[222]#</cfoutput>">
                                    <cfoutput>#menutitle[222]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=customertype" target="mainFrame" title="<cfoutput>#menutitle[223]#</cfoutput>">
                                   <cfoutput>#menutitle[223]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=agenttype" target="mainFrame" title="<cfoutput>#menutitle[224]#</cfoutput>">
                                   <cfoutput>#menutitle[224]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=grouptype" target="mainFrame" title="<cfoutput>#menutitle[225]#</cfoutput>">
                                   <cfoutput>#menutitle[225]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=endusertype" target="mainFrame" title="<cfoutput>#menutitle[226]#</cfoutput>">
                                 <cfoutput>#menutitle[226]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=brandtype" target="mainFrame" title="<cfoutput>#menutitle[227]#</cfoutput>">
                                    <cfoutput>#menutitle[227]#</cfoutput>
                                </a>
                            </li>
                </span>
        <li onClick="SwitchMenu2('sub7')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[228]#</cfoutput>">
        <cfoutput>#menutitle[228]#</cfoutput></a></li>
                <span id="sub7" style="display:none;" class="submenu2">
                	         <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=productmonth" target="mainFrame" title="<cfoutput>#menutitle[229]#</cfoutput>">
                                    <cfoutput>#menutitle[229]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonth_2.cfm?type=productmonth" target="mainFrame" title="<cfoutput>#menutitle[230]#</cfoutput>">
                                    <cfoutput>#menutitle[230]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=customermonth" target="mainFrame" title="<cfoutput>#menutitle[223]#</cfoutput>">
                                    <cfoutput>#menutitle[223]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=agentmonth" target="mainFrame" title="<cfoutput>#menutitle[224]#</cfoutput>">
                                    <cfoutput>#menutitle[224]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=groupmonth" target="mainFrame" title="<cfoutput>#menutitle[225]#</cfoutput>">
                                    <cfoutput>#menutitle[225]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonth.cfm?type=endusermonth" target="mainFrame" title="<cfoutput>#menutitle[226]#</cfoutput>">
                                    <cfoutput>#menutitle[226]#</cfoutput>
                                </a>
                            </li>                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/activecust.cfm" target="mainFrame" title="<cfoutput>#menutitle[232]#</cfoutput>">
                                    <cfoutput>#menutitle[232]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=brandmonth" target="mainFrame" title="<cfoutput>#menutitle[227]#</cfoutput>">
                                    <cfoutput>#menutitle[227]#</cfoutput>
                                </a>
                            </li>
                            
                </span>
        <li onClick="SwitchMenu2('sub18')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[233]#</cfoutput>">
        <cfoutput>#menutitle[233]#</cfoutput></a></li>
                <span id="sub18" style="display:none;" class="submenu2">
                	       
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesweek.cfm?type=productweek" target="mainFrame" title="<cfoutput>#menutitle[222]#</cfoutput>">
                                    <cfoutput>#menutitle[222]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesweek.cfm?type=customerweek" target="mainFrame" title="<cfoutput>#menutitle[223]#</cfoutput>">
                                    <cfoutput>#menutitle[223]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesweek.cfm?type=agentweek" target="mainFrame" title="<cfoutput>#menutitle[224]#</cfoutput>">
                                    <cfoutput>#menutitle[224]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesweek.cfm?type=groupweek" target="mainFrame" title="<cfoutput>#menutitle[225]#</cfoutput>">
                                    <cfoutput>#menutitle[225]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesweek.cfm?type=enduserweek" target="mainFrame" title="<cfoutput>#menutitle[226]#</cfoutput>">
                                    <cfoutput>#menutitle[226]#</cfoutput>
                                </a>
                            </li>
                </span>
        <li onClick="SwitchMenu2('sub8')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[234]#</cfoutput>"><cfoutput>#menutitle[234]#</cfoutput></a></li>
                <span id="sub8" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesday.cfm?type=enduserday" target="mainFrame" title="<cfoutput>#menutitle[235]#</cfoutput>">
                                    <cfoutput>#menutitle[235]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/dailyendusersalesform.cfm" target="mainFrame" title="<cfoutput>#menutitle[236]#</cfoutput>">
                                    <cfoutput>#menutitle[236]#</cfoutput>
                                </a>
                            </li>
                </span>
        <li onClick="SwitchMenu2('sub9')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[357]#</cfoutput>">
		<cfoutput>#menutitle[357]#</cfoutput></a></li>
                <span id="sub9" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=fixed" target="mainFrame" title="<cfoutput>#menutitle[237]#</cfoutput>">
                                    <cfoutput>#menutitle[237]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=fifo" target="mainFrame" title="<cfoutput>#menutitle[238]#</cfoutput>">
                                    <cfoutput>#menutitle[238]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=lifo" target="mainFrame" title="<cfoutput>#menutitle[239]#</cfoutput>">
                                    <cfoutput>#menutitle[239]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=month" target="mainFrame" title="<cfoutput>#menutitle[240]#</cfoutput>">
                                    <cfoutput>#menutitle[240]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=moving" target="mainFrame" title="<cfoutput>#menutitle[241]#</cfoutput>">
                                    <cfoutput>#menutitle[241]#</cfoutput>
                                </a>
                            </li>
                            
                </span>
        <li onClick="SwitchMenu2('sub10')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[242]#</cfoutput>">
        <cfoutput>#menutitle[242]#</cfoutput></a></li>
                <span id="sub10" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=productmargin" target="mainFrame" title="<cfoutput>#menutitle[243]#</cfoutput>">
                                    <cfoutput>#menutitle[243]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=billmargin" target="mainFrame" title="<cfoutput>#menutitle[244]#</cfoutput>">
                                    <cfoutput>#menutitle[244]#</cfoutput>
                                </a>
                            </li>
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=agentmargin" target="mainFrame" title="<cfoutput>#menutitle[245]#</cfoutput>">
                                    <cfoutput>#menutitle[245]#</cfoutput>
                                </a>
                            </li>
                            <cfif getmodule.project eq '1'>
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=projectmargin" target="mainFrame" title="<cfoutput>#menutitle[246]#</cfoutput>">
                                    <cfoutput>#menutitle[246]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=billitemmargin" target="mainFrame" title="<cfoutput>#menutitle[247]#</cfoutput>">
                                    <cfoutput>#menutitle[247]#</cfoutput>
                                </a>
                            </li>
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=customermargin" target="mainFrame" title="<cfoutput>#menutitle[180]#</cfoutput>">
                                    <cfoutput>#menutitle[180]#</cfoutput>
                                </a>
                            </li>
                           
                </span>
        <li onClick="SwitchMenu2('sub11')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[248]#</cfoutput>">
        <cfoutput>#menutitle[248]#</cfoutput></a></li>
                <span id="sub11" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/saleslisting.cfm?type=customerlist" target="mainFrame" title="<cfoutput>#menutitle[180]#</cfoutput>">
                                    <cfoutput>#menutitle[180]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/saleslisting.cfm?type=productlist" target="mainFrame" title="<cfoutput>#menutitle[243]#</cfoutput>">
                                    <cfoutput>#menutitle[243]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/saleslisting.cfm?type=agentlist" target="mainFrame" title="<cfoutput>#menutitle[245]#</cfoutput>">
                                    <cfoutput>#menutitle[245]#</cfoutput>
                                </a>
                            </li>
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/saleslisting.cfm?type=arealist" target="mainFrame" title="<cfoutput>#menutitle[249]#</cfoutput>">
                                    <cfoutput>#menutitle[249]#</cfoutput>
                                </a>
                            </li>
                </span>
        <li onClick="SwitchMenu2('sub12')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[250]#</cfoutput>">
        <cfoutput>#menutitle[250]#</cfoutput></a></li>
                <span id="sub12" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topbottomsales.cfm?type=top" target="mainFrame" title="<cfoutput>#menutitle[251]#</cfoutput>">
                                    <cfoutput>#menutitle[251]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topbottomsales.cfm?type=bottom" target="mainFrame" title="<cfoutput>#menutitle[252]#</cfoutput>">
                                    <cfoutput>#menutitle[252]#</cfoutput>
                                </a>
                            </li>
                </span>
        <li onClick="SwitchMenu2('sub13')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[253]#</cfoutput>">
        <cfoutput>#menutitle[253]#</cfoutput></a></li>
                <span id="sub13" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topsales.cfm?type=customertype" target="mainFrame" title="<cfoutput>#menutitle[180]#</cfoutput>">
                                    <cfoutput>#menutitle[180]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topsales.cfm?type=agenttype" target="mainFrame" title="<cfoutput>#menutitle[245]#</cfoutput>">
                                    <cfoutput>#menutitle[245]#</cfoutput>
                                </a>
                            </li>
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topsales.cfm?type=areatype" target="mainFrame" title="<cfoutput>#menutitle[249]#</cfoutput>">
                                    <cfoutput>#menutitle[249]#</cfoutput>
                                </a>
                            </li>
                </span>
        <li onClick="SwitchMenu2('sub14')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[254]#</cfoutput>">
		<cfoutput>#menutitle[254]#</cfoutput></a></li>
                <span id="sub14" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/cashsalesreport.cfm" target="mainFrame" title="<cfoutput>#menutitle[255]#</cfoutput>">
                                    <cfoutput>#menutitle[255]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/cashsales.cfm" target="mainFrame" title="<cfoutput>#menutitle[256]#</cfoutput>">
                                    <cfoutput>#menutitle[256]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/cashsalesbycounter.cfm" target="mainFrame" title="<cfoutput>#menutitle[257]#</cfoutput>">
                                    <cfoutput>#menutitle[257]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/cashsalessummary.cfm" target="mainFrame" title="<cfoutput>#menutitle[258]#</cfoutput>">
                                    <cfoutput>#menutitle[258]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/dailycheckout.cfm" target="mainFrame" title="<cfoutput>#menutitle[259]#</cfoutput>">
                                    <cfoutput>#menutitle[259]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/dailycheckoutA.cfm" target="mainFrame" title="<cfoutput>#menutitle[260]#</cfoutput>">
                                    <cfoutput>#menutitle[260]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesreportitem.cfm" target="mainFrame" title="<cfoutput>#menutitle[261]#</cfoutput>">
                                    <cfoutput>#menutitle[261]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/cashsalesbycashier.cfm" target="mainFrame" title="<cfoutput>#menutitle[262]#</cfoutput>">
                                    <cfoutput>#menutitle[262]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/dailycashsales.cfm" target="mainFrame" title="<cfoutput>#menutitle[263]#</cfoutput>">
                                    <cfoutput>#menutitle[263]#</cfoutput>
                                </a>
                            </li>
                            
                </span>
        <li onClick="SwitchMenu2('sub15')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[264]#</cfoutput>">
        <cfoutput>#menutitle[264]#</cfoutput></a></li>
                <span id="sub15" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesdetailbysupp.cfm" target="mainFrame" title="<cfoutput>#menutitle[180]#</cfoutput>">
                                    <cfoutput>#menutitle[180]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesdetailbyitem.cfm" target="mainFrame" title="<cfoutput>#menutitle[183]#</cfoutput>">
                                    <cfoutput>#menutitle[183]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesdetailbyagent.cfm" target="mainFrame" title="<cfoutput>#menutitle[245]#</cfoutput>">
                                    <cfoutput>#menutitle[245]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesdetailbyrefno.cfm" target="mainFrame" title="<cfoutput>#menutitle[265]#</cfoutput>">
                                    <cfoutput>#menutitle[265]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesdetailbyrefnoB.cfm" target="mainFrame" title="<cfoutput>#menutitle[266]#</cfoutput>">
                                    <cfoutput>#menutitle[266]#</cfoutput>
                                </a>
                            </li>
                </span>
        <li onClick="SwitchMenu2('sub16')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[267]#</cfoutput>">
        <cfoutput>#menutitle[267]#</cfoutput></a></li>
                <span id="sub16" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/statementform.cfm" target="mainFrame" title="<cfoutput>#menutitle[268]#</cfoutput>">
                                    <cfoutput>#menutitle[268]#</cfoutput>
                                </a>
                            </li>
                </span>
                
        <li onClick="SwitchMenu2('sub48')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[422]#</cfoutput>">
        <cfoutput>#menutitle[422]#</cfoutput></a></li>
                <span id="sub48" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/paymentstatus(supplier).cfm" target="mainFrame" title="<cfoutput>#menutitle[419]#</cfoutput>">
                                   <cfoutput>#menutitle[419]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/paymentstatus(customer).cfm" target="mainFrame" title="<cfoutput>#menutitle[420]#</cfoutput>">
                                   <cfoutput>#menutitle[420]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/invoicesummary.cfm" target="mainFrame" title="<cfoutput>#menutitle[421]#</cfoutput>">
                                   <cfoutput>#menutitle[421]#</cfoutput>
                                </a>
                            </li>
                </span>
                
                
        <li onClick="SwitchMenu2('sub17')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[411]#</cfoutput>">
        <cfoutput>#menutitle[411]#</cfoutput></a></li>
                <span id="sub17" style="display:none;" class="submenu2">
                	        <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesreport.cfm?type=agenttype" target="mainFrame" title="<cfoutput>#menutitle[269]#</cfoutput>">
                                   <cfoutput>#menutitle[269]#</cfoutput>
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/endusersalesreport.cfm" target="mainFrame" title="<cfoutput>#menutitle[270]#</cfoutput>">
                                   <cfoutput>#menutitle[270]#</cfoutput>
                                </a>
                            </li>
                </span>

    </span>
    </cfif>
 	
	<cfif getpin2.h4400 eq "T">
    <li onClick="SwitchMenu('sub19')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[92]#</cfoutput>"><cfoutput>#menutitle[92]#</cfoutput></a></li>
<span id="sub19" style="display:none;" class="submenu">
		<li onClick="SwitchMenu2('sub20')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[221]#</cfoutput>"><cfoutput>#menutitle[221]#</cfoutput></a></li>
                <span id="sub20" style="display:none;" class="submenu2">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasetype.cfm?type=producttype" target="mainFrame" title="<cfoutput>#menutitle[271]#</cfoutput>">
				<cfoutput>#menutitle[271]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasetype.cfm?type=vendortype" target="mainFrame" title="<cfoutput>#menutitle[272]#</cfoutput>">
				<cfoutput>#menutitle[272]#</cfoutput>
			</a>
		</li>
        </span>
        <li onClick="SwitchMenu2('sub21')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[228]#</cfoutput>">
        <cfoutput>#menutitle[228]#</cfoutput></a></li>
                <span id="sub21" style="display:none;" class="submenu2">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasemonth.cfm?type=productmonth" target="mainFrame" title="<cfoutput>#menutitle[271]#</cfoutput>">
				<cfoutput>#menutitle[271]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasemonth.cfm?type=vendormonth" target="mainFrame" title="<cfoutput>#menutitle[272]#</cfoutput>">
				<cfoutput>#menutitle[272]#</cfoutput>
			</a>
		</li>
        </span>
        <li onClick="SwitchMenu2('sub22')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[273]#</cfoutput>">
        <cfoutput>#menutitle[273]#</cfoutput></a></li>
                <span id="sub22" style="display:none;" class="submenu2">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasequantity.cfm?type=vendorproduct" target="mainFrame" title="<cfoutput>#menutitle[274]#</cfoutput>">
				<cfoutput>#menutitle[274]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasequantity.cfm?type=productvendor" target="mainFrame" title="<cfoutput>#menutitle[275]#</cfoutput>">
				<cfoutput>#menutitle[275]#</cfoutput>
			</a>
		</li>
        </span>
        <li onClick="SwitchMenu2('sub23')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[276]#</cfoutput>"><cfoutput>#menutitle[276]#</cfoutput></a></li>
                <span id="sub23" style="display:none;" class="submenu2">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchaselisting.cfm" target="mainFrame" title="<cfoutput>#menutitle[277]#</cfoutput>">
				<cfoutput>#menutitle[277]#</cfoutput>
			</a>
		</li>
        </span>
        <li onClick="SwitchMenu2('sub24')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[278]#</cfoutput>">
        <cfoutput>#menutitle[278]#</cfoutput></a></li>
                <span id="sub24" style="display:none;" class="submenu2">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasedetailbyitem.cfm" target="mainFrame" title="<cfoutput>#menutitle[183]#</cfoutput>">
				<cfoutput>#menutitle[183]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasedetailbysupp.cfm" target="mainFrame" title="<cfoutput>#menutitle[187]#</cfoutput>">
				<cfoutput>#menutitle[187]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasedetailbyrefno.cfm" target="mainFrame" title="<cfoutput>#menutitle[279]#</cfoutput>">
				<cfoutput>#menutitle[279]#</cfoutput>
			</a>
		</li>
        </span>
	</span>
    </cfif>
	<cfif getpin2.h4800 eq "T">
    <li onClick="SwitchMenu('sub25')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[93]#</cfoutput>"><cfoutput>#menutitle[93]#</cfoutput></a></li>
<span id="sub25" style="display:none;" class="submenu">
		<li onClick="SwitchMenu2('sub26')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[221]#</cfoutput>">
		<cfoutput>#menutitle[221]#</cfoutput></a></li>
                <span id="sub26" style="display:none;" class="submenu2">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-item/itemtype.cfm?type=customerproducttype" target="mainFrame" title="<cfoutput>#menutitle[280]#</cfoutput>">
                    <cfoutput>#menutitle[280]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-item/itemtype.cfm?type=productcustomertype" target="mainFrame" title="<cfoutput>#menutitle[281]#</cfoutput>">
                    <cfoutput>#menutitle[281]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-item/itemtype.cfm?type=agentproducttype" target="mainFrame" title="<cfoutput>#menutitle[282]#</cfoutput>">
                    <cfoutput>#menutitle[282]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-item/itemtype.cfm?type=areacatetype" target="mainFrame" title="<cfoutput>#menutitle[423]#</cfoutput>">
                    <cfoutput>#menutitle[423]#</cfoutput>
                </a>
            </li>
            
         </span>
         <li onClick="SwitchMenu2('sub27')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[228]#</cfoutput>">
		 <cfoutput>#menutitle[228]#</cfoutput></a></li>
                <span id="sub27" style="display:none;" class="submenu2">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-item/itemmonth.cfm?type=customerproductmonth" target="mainFrame" title="<cfoutput>#menutitle[280]#</cfoutput>">
                    <cfoutput>#menutitle[280]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-item/itemmonth.cfm?type=agentcustomermonth" target="mainFrame" title="<cfoutput>#menutitle[358]#</cfoutput>">
                    <cfoutput>#menutitle[358]#</cfoutput>
                </a>
            </li>
         </span>
         <li onClick="SwitchMenu2('sub28')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[283]#</cfoutput>">
		 <cfoutput>#menutitle[283]#</cfoutput></a></li>
                <span id="sub28" style="display:none;" class="submenu2">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-item/topbottomsalescategory.cfm?type=top" target="mainFrame" title="<cfoutput>#menutitle[284]#</cfoutput>">
                    <cfoutput>#menutitle[284]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-item/topbottomsalescategory.cfm?type=bottom" target="mainFrame" title="<cfoutput>#menutitle[285]#</cfoutput>">
                    <cfoutput>#menutitle[285]#</cfoutput>
                </a>
            </li>
         </span>
         
    </span>
	</cfif>
    <cfif getmodule.location eq "1">
	<cfif getpin2.h4500 eq "T">
    <li onClick="SwitchMenu('sub29')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[94]#</cfoutput>">
    		<cfif getgeneral.dflanguage eq 'english'>
               				#getgeneral.lLOCATION# Report
                    <cfelse>
                    <cfoutput>#menutitle[94]#</cfoutput>
                    </cfif>
    </a></li>
<span id="sub29" style="display:none;" class="submenu">
		 <li onClick="SwitchMenu2('sub30')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[183]#</cfoutput>">
         <cfoutput>#menutitle[183]#</cfoutput></a></li>
                <span id="sub30" style="display:none;" class="submenu2">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_listingreport.cfm?type=1" target="mainFrame" title="<cfoutput>#menutitle[286]#</cfoutput>">
                    <cfoutput>#menutitle[286]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_listingreport.cfm?type=2" target="mainFrame" title="<cfoutput>#menutitle[287]#</cfoutput>">
                    <cfoutput>#menutitle[287]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_status_form.cfm?type=item_location" target="mainFrame" title="<cfoutput>#menutitle[288]#</cfoutput>">
                    <cfoutput>#menutitle[288]#</cfoutput>
                </a>
            </li>
         </span>
         <li onClick="SwitchMenu2('sub31')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[359]#</cfoutput>">
		 <cfoutput>#menutitle[359]#</cfoutput></a></li>
                <span id="sub31" style="display:none;" class="submenu2">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_stockcard_stock_card.cfm" target="mainFrame" title="<cfoutput>#menutitle[289]#</cfoutput>">
                    <cfoutput>#menutitle[289]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_stockcard_forecast.cfm" target="mainFrame" title="<cfoutput>#menutitle[290]#</cfoutput>">
                    <cfoutput>#menutitle[290]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_physical_worksheet_menu.cfm" target="mainFrame" title="<cfoutput>#menutitle[291]#</cfoutput>">
                    <cfoutput>#menutitle[291]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_status_form.cfm?type=location_item" target="mainFrame" title="<cfoutput>#menutitle[292]#</cfoutput>">
                    <cfoutput>#menutitle[292]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_openingqty.cfm" target="mainFrame" title="<cfoutput>#menutitle[293]#</cfoutput>">
                    <cfoutput>#menutitle[293]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_openingqty1.cfm" target="mainFrame" title="<cfoutput>#menutitle[294]#</cfoutput>">
                    <cfoutput>#menutitle[294]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_stockcard_stock_cardsummary.cfm" target="mainFrame" title="<cfoutput>#menutitle[295]#</cfoutput>">
                    <cfoutput>#menutitle[295]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/locationstockcheck.cfm" target="mainFrame" title="<cfoutput>#menutitle[296]#</cfoutput>">
                    <cfoutput>#menutitle[296]#</cfoutput>
                </a>
            </li>
            
         </span>
	</span>
    </cfif>
    </cfif>
	<cfif getpin2.h4600 eq "T">

    
    
	<cfif getpin2.h4900 eq "T">
    <cfquery name="checkcustom" datasource="#dts#">
            select customcompany from dealer_menu
        </cfquery>
    <li onClick="SwitchMenu('sub35')">
    <a class="oe_secondary_menu_item" style="cursor:pointer" title="    <cfif checkcustom.customcompany eq "Y">
    <cfoutput>#menutitle[297]#</cfoutput>
    <cfelse>
	<cfoutput>#menutitle[96]#</cfoutput></cfif> ">
    <cfif checkcustom.customcompany eq "Y">
    <cfoutput>#menutitle[297]#</cfoutput>
    <cfelse>
	<cfoutput>#menutitle[96]#</cfoutput></cfif> 
    
    </a></li>
    
<span id="sub35" style="display:none;" class="submenu">

    	<li onClick="SwitchMenu2('sub36')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[183]#</cfoutput>">
		<cfoutput>#menutitle[183]#</cfoutput></a></li>
         <span id="sub36" style="display:none;" class="submenu2">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=itembatchopening" target="mainFrame" title="<cfoutput>#menutitle[298]#</cfoutput>">
                    <cfoutput>#menutitle[298]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=itembatchsales" target="mainFrame" title="<cfoutput>#menutitle[362]#</cfoutput>">
                    <cfoutput>#menutitle[299]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=itembatchstatus" target="mainFrame" title="<cfoutput>#menutitle[300]#</cfoutput>">
                    <cfoutput>#menutitle[300]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch//batchreportform.cfm?type=itembatchstockcard" target="mainFrame" title="<cfoutput>#menutitle[301]#</cfoutput>">
                   <cfoutput>#menutitle[301]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=itembatchstockcard&stockcard2=1" target="mainFrame" title="<cfoutput>#menutitle[302]#</cfoutput>">
                   <cfoutput>#menutitle[302]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=itembatchstockcard2" target="mainFrame" title="<cfoutput>#menutitle[303]#</cfoutput>">
                    <cfoutput>#menutitle[303]#</cfoutput>
                </a>
            </li>
		</span>
        <li onClick="SwitchMenu2('sub37')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[359]#</cfoutput>"><cfoutput>#menutitle[359]#</cfoutput></a></li>
         <span id="sub37" style="display:none;" class="submenu2">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=locationitembatchopening" target="mainFrame" title="<cfoutput>#menutitle[304]#</cfoutput>">
                    <cfoutput>#menutitle[304]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=locationitembatchsales" target="mainFrame" title="<cfoutput>#menutitle[305]#</cfoutput>">
                    <cfoutput>#menutitle[305]#</cfoutput>
                </a>
            </li>
            
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=locationitembatchstatus" target="mainFrame" title="<cfoutput>#menutitle[306]#</cfoutput>">
                    <cfoutput>#menutitle[306]#</cfoutput>
                </a>
            </li>
            
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=locationitembatchstockcard" target="mainFrame" title="<cfoutput>#menutitle[307]#</cfoutput>">
                    <cfoutput>#menutitle[307]#</cfoutput>
                </a>
            </li>
            
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=locationitembatchstockcard2" target="mainFrame" title="<cfoutput>#menutitle[308]#</cfoutput>">
                    <cfoutput>#menutitle[308]#</cfoutput>
                </a>
            </li>
            
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=locationitembatchstatus2" target="mainFrame" title="<cfoutput>#menutitle[309]#</cfoutput>">
                    <cfoutput>#menutitle[309]#</cfoutput>
                </a>
            </li>
            
		</span>
        <li onClick="SwitchMenu2('sub38')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[411]#</cfoutput>">
		<cfoutput>#menutitle[411]#</cfoutput></a></li>
         <span id="sub38" style="display:none;" class="submenu2">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform.cfm?type=batchlisting" target="mainFrame" title="<cfoutput>#menutitle[310]#</cfoutput>">
                    <cfoutput>#menutitle[310]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform2.cfm?type=monthly" target="mainFrame" title="<cfoutput>#menutitle[311]#</cfoutput>">
                    <cfoutput>#menutitle[311]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform2.cfm?type=bydate_tran" target="mainFrame" title="<cfoutput>#menutitle[312]#</cfoutput>">
                    <cfoutput>#menutitle[312]#</cfoutput>
                </a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-batch/batchreportform2.cfm?type=salesreport" target="mainFrame" title="<cfoutput>#menutitle[313]#</cfoutput>">
                    <cfoutput>#menutitle[313]#</cfoutput>
                </a>
            </li>
		</span>
    </span>
    </cfif>
	<cfif getmodule.grade eq "1" >
	<cfif getpin2.h4A00 eq "T">
    <li onClick="SwitchMenu('sub39')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[97]#</cfoutput>">
    <cfoutput>#menutitle[97]#</cfoutput>
    </a></li>
<span id="sub39" style="display:none;" class="submenu">
		<li onClick="SwitchMenu2('sub40')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[183]#</cfoutput>">
        <cfoutput>#menutitle[183]#</cfoutput></a></li>
                <span id="sub40" style="display:none;" class="submenu2">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/physical_worksheet_form.cfm?type=physical" target="mainFrame" title="<cfoutput>#menutitle[314]#</cfoutput>">
                    <cfoutput>#menutitle[314]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=opening" title="<cfoutput>#menutitle[315]#</cfoutput>" target="mainFrame"><cfoutput>#menutitle[315]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=sales" title="<cfoutput>#menutitle[316]#</cfoutput>" target="mainFrame"><cfoutput>#menutitle[316]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=status" title="<cfoutput>#menutitle[317]#</cfoutput>" target="mainFrame"><cfoutput>#menutitle[317]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=stockcard" title="<cfoutput>#menutitle[318]#</cfoutput>" target="mainFrame"><cfoutput>#menutitle[318]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=itemlocopening" title="<cfoutput>#menutitle[319]#</cfoutput>" target="mainFrame"><cfoutput>#menutitle[319]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=itemlocsales" title="<cfoutput>#menutitle[320]#</cfoutput>" target="mainFrame"><cfoutput>#menutitle[320]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=itemlocstatus" target="mainFrame" title="<cfoutput>#menutitle[321]#</cfoutput>"><cfoutput>#menutitle[321]#</cfoutput></a>
                </li>
                
        </span>
        
        <li onClick="SwitchMenu2('sub41')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[359]#</cfoutput>">
		<cfoutput>#menutitle[359]#</cfoutput></a></li>
                <span id="sub41" style="display:none;" class="submenu2">
                	<li>
                        <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/physical_worksheet_form.cfm?type=locitemphysical" target="mainFrame" title="<cfoutput>#menutitle[322]#</cfoutput>"><cfoutput>#menutitle[322]#</cfoutput></a>
                    </li>
                    <li>
                        <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=locitemopening" target="mainFrame" title="<cfoutput>#menutitle[323]#</cfoutput>"><cfoutput>#menutitle[323]#</cfoutput></a>
                    </li>
                    <li>
                        <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=locitemsales" target="mainFrame" title="<cfoutput>#menutitle[324]#</cfoutput>"><cfoutput>#menutitle[324]#</cfoutput></a>
                    </li>
                    <li>
                        <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=locitemstatus" target="mainFrame" title="<cfoutput>#menutitle[325]#</cfoutput>"><cfoutput>#menutitle[325]#</cfoutput></a>
                    </li>
                    <li>
                        <a class="oe_secondary_submenu_item" href="/#HDir#/report-gradeditem/gradedreportform.cfm?type=locitemstockcard" target="mainFrame" title="<cfoutput>#menutitle[326]#</cfoutput>"><cfoutput>#menutitle[326]#</cfoutput></a>
                    </li>
                    
        
        </span>
	</span>
    </cfif>
    </cfif>
    <cfif getmodule.matrix eq "1" >
	<cfif getpin2.h4B00 eq "T">
    <li onClick="SwitchMenu('sub42')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[362]#</cfoutput>"><cfoutput>#menutitle[98]#</cfoutput></a></li>
<span id="sub42" style="display:none;" class="submenu">
				<li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-matrixitem/matrixreportform.cfm?type=opening" target="mainFrame" title="<cfoutput>#menutitle[315]#</cfoutput>"><cfoutput>#menutitle[315]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-matrixitem/matrixreportform.cfm?type=sales" target="mainFrame" title="<cfoutput>#menutitle[316]#</cfoutput>"><cfoutput>#menutitle[316]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-matrixitem/matrixreportform.cfm?type=purchase" target="mainFrame" title="<cfoutput>#menutitle[327]#</cfoutput>"><cfoutput>#menutitle[327]#</cfoutput></a>
                </li>
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-matrixitem/matrixreportform.cfm?type=stockbalance" target="mainFrame" title="<cfoutput>#menutitle[328]#</cfoutput>"><cfoutput>#menutitle[328]#</cfoutput></a>
                </li>
	</span>
    </cfif>
    </cfif>
    <cfif getmodule.project eq "1" >
	<cfif getpin2.h4C00 eq "T">
    <li onClick="SwitchMenu('sub43')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[362]#</cfoutput>"><cfoutput>#menutitle[329]#</cfoutput></a></li>
<span id="sub43" style="display:none;" class="submenu">
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-project/projectreportform.cfm?type=listprojitem" target="mainFrame" title="<cfoutput>#menutitle[330]#</cfoutput>">
            <cfoutput>#menutitle[330]#</cfoutput></a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-project/projectreportform.cfm?type=salesiss" target="mainFrame" title="<cfoutput>#menutitle[331]#</cfoutput>">
            <cfoutput>#menutitle[331]#</cfoutput></a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-project/projectreportform.cfm?type=projitemiss" target="mainFrame" title="<cfoutput>#menutitle[332]#</cfoutput>">
            <cfoutput>#menutitle[332]#</cfoutput></a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-project/projectreportform.cfm?type=itemprojiss" target="mainFrame" title="<cfoutput>#menutitle[333]#</cfoutput>">
            <cfoutput>#menutitle[333]#</cfoutput></a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-project/projectreportform1.cfm" target="mainFrame" title="<cfoutput>#menutitle[334]#</cfoutput>">
            <cfoutput>#menutitle[334]#</cfoutput> </a>
		</li>
        
	</span>
    </cfif>
    </cfif>
    	<cfif getpin2.h4D00 eq "T">
        <li onClick="SwitchMenu('sub44')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[100]#</cfoutput>"><cfoutput>#menutitle[100]#</cfoutput></a></li>
<span id="sub44" style="display:none;" class="submenu">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/servicereportform.cfm?type=listprojitem" target="mainFrame" title="<cfoutput>#menutitle[335]#</cfoutput>">
                <cfoutput>#menutitle[335]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/servicereportform1.cfm?type=salesiss" target="mainFrame" title="<cfoutput>#menutitle[336]#</cfoutput>">
                <cfoutput>#menutitle[336]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/servicereportform2.cfm?type=salesiss" target="mainFrame" title="<cfoutput>#menutitle[337]#</cfoutput>">
                <cfoutput>#menutitle[337]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/servicereportform3.cfm?type=projitemiss" target="mainFrame" title="<cfoutput>#menutitle[338]#</cfoutput>">
                <cfoutput>#menutitle[338]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/servicereportform4.cfm" target="mainFrame" title="<cfoutput>#menutitle[339]#</cfoutput>">
                <cfoutput>#menutitle[339]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/servicereportform5.cfm" target="mainFrame" title="<cfoutput>#menutitle[340]#</cfoutput>">
                <cfoutput>#menutitle[340]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/servicereportform6.cfm" target="mainFrame" title="<cfoutput>#menutitle[341]#</cfoutput>">
                <cfoutput>#menutitle[341]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/servicemonth.cfm" target="mainFrame" title="<cfoutput>#menutitle[342]#</cfoutput>">
                <cfoutput>#menutitle[342]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/productivitymonth.cfm" target="mainFrame" title="<cfoutput>#menutitle[343]#</cfoutput>">
                <cfoutput>#menutitle[343]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-service/p_servicereportproject.cfm" target="mainFrame" title="<cfoutput>#menutitle[344]#</cfoutput>">
                <cfoutput>#menutitle[344]#</cfoutput></a>
            </li>
            
    </span>        
	</cfif>
    	<cfif getpin2.h4E00 eq "T">
        <li onClick="SwitchMenu('sub45')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[101]#</cfoutput>"><cfoutput>#menutitle[101]#</cfoutput></a></li>
<span id="sub45" style="display:none;" class="submenu">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-store/stockcard.cfm?type=1" target="mainFrame" title="<cfoutput>#menutitle[289]#</cfoutput>">
                <cfoutput>#menutitle[289]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-store/saleslisting.cfm" target="mainFrame" title="<cfoutput>#menutitle[345]#</cfoutput>">
                <cfoutput>#menutitle[345]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-store/invdetaillisting.cfm" target="mainFrame" title="<cfoutput>#menutitle[346]#</cfoutput>">
                <cfoutput>#menutitle[346]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-store/supplieritem.cfm" target="mainFrame" title="<cfoutput>#menutitle[347]#</cfoutput>">
                <cfoutput>#menutitle[347]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-store/supplierbill.cfm" target="mainFrame" title="<cfoutput>#menutitle[348]#</cfoutput>">
                <cfoutput>#menutitle[348]#</cfoutput></a>
            </li>
            
	</span>
    </cfif>
    <cfif getmodule.manufacturing eq "1" >
    <cfif getpin2.h4F00 eq "T">
    <li onClick="SwitchMenu('sub46')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[102]#</cfoutput>"><cfoutput>#menutitle[102]#</cfoutput></a></li>
<span id="sub46" style="display:none;" class="submenu">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-manufacturing/costingreport.cfm" target="mainFrame" title="<cfoutput>#menutitle[349]#</cfoutput>"><cfoutput>#menutitle[349]#</cfoutput></a>
            </li>
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-manufacturing/assemblesummaryreport.cfm" target="mainFrame" title="<cfoutput>#menutitle[350]#</cfoutput>"><cfoutput>#menutitle[350]#</cfoutput></a>
            </li>
	</span>
    </cfif>
    </cfif>
<cfif getmodule.serialno eq "1" >
<li onClick="SwitchMenu('sub34')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[353]#</cfoutput>"><cfoutput>#menutitle[353]#</cfoutput></a></li>
                <span id="sub34" style="display:none;" class="submenu">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=ref" target="mainFrame" title="<cfoutput>#menutitle[424]#</cfoutput>">
				<cfoutput>#menutitle[424]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=item" target="mainFrame" title="<cfoutput>#menutitle[425]#</cfoutput>">
				<cfoutput>#menutitle[425]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=status" target="mainFrame" title="<cfoutput>#menutitle[354]#</cfoutput>">
				<cfoutput>#menutitle[354]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=sale" target="mainFrame" title="<cfoutput>#menutitle[355]#</cfoutput>">
				<cfoutput>#menutitle[355]#</cfoutput>
			</a>
		</li>

        </span>
</cfif>

    <li onClick="SwitchMenu('sub32')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[351]#</cfoutput>"><cfoutput>#menutitle[351]#</cfoutput></a></li>
<span id="sub32" style="display:none;" class="submenu">
		<li onClick="SwitchMenu2('sub33')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[352]#</cfoutput>"><cfoutput>#menutitle[352]#</cfoutput></a></li>
                <span id="sub33" style="display:none;" class="submenu2">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=ref" target="mainFrame" title="<cfoutput>#menutitle[279]#</cfoutput>">
				<cfoutput>#menutitle[279]#</cfoutput>
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=item" target="mainFrame" title="<cfoutput>#menutitle[183]#</cfoutput>">
				<cfoutput>#menutitle[183]#</cfoutput>
			</a>
		</li>
        </span>
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-email/bill_emailreport.cfm" target="mainFrame" title="<cfoutput>#menutitle[356]#</cfoutput>">
				<cfoutput>#menutitle[356]#</cfoutput>
			</a>
		</li>
	</span>
    </cfif>
	
    
    <cfquery name="get_company_id" datasource="main">
	select 
	(lcase(left(company_id,char_length(company_id)-2))) as company_id
	from customize_report
	where company_id='#jsstringformat(preservesinglequotes(hcomid))#'
	order by company_id;
</cfquery>

<cfif get_company_id.recordcount eq 1>
	<cfoutput>
    
    <li onClick="SwitchMenu('sub47')"><a class="oe_secondary_menu_item" style="cursor:pointer" href="/Report/report_menu.cfm?company_id=#urlencodedformat(get_company_id.company_id)#" target="mainFrame" title="<cfoutput>#menutitle[356]#</cfoutput>">
				<cfoutput>Customized Report</cfoutput>
			</a>
		</li>
        <span id="sub47" style="display:none;" class="submenu2">
        
        </span>
	</cfoutput>
</cfif>




</cfif>
</div>
</div>
</div>
</cfoutput>
</body>
</html>
