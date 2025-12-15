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
<cfif getpin2.h4100 eq "T" or getpin2.h4110 eq "T" or getpin2.h4120 eq "T" or getpin2.h4130 eq "T" or getpin2.h4140 eq "T" or getpin2.h4150 eq "T" or getpin2.h4160 eq "T" or getpin2.h4170 eq "T" or getpin2.h4180 eq "T" or getpin2.h4190 eq "T" or getpin2.h41A0 eq "T" or getpin2.h41B0 eq "T" or getpin2.h41C0 eq "T" or getpin2.h41D0 eq "T" or getpin2.h41E0 eq "T" or getpin2.h41F0 eq "T" or getpin2.h43G0 eq "T" or getpin2.h43H0 eq "T">
	<li onClick="SwitchMenu('sub1')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[89]#</cfoutput>"><cfoutput>#menutitle[89]#</cfoutput></a></li>
<span id="sub1" style="display:none;" class="submenu">
        <cfif getpin2.h4110 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=1" target="mainFrame" title="<cfoutput>#menutitle[42]#</cfoutput>">
				<cfoutput>#menutitle[42]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4120 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=2" target="mainFrame" title="<cfoutput>#menutitle[43]#</cfoutput>">
				<cfoutput>#menutitle[43]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4130 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=3" target="mainFrame" title="<cfoutput>#menutitle[44]#</cfoutput>">
				<cfoutput>#menutitle[44]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4140 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=4" target="mainFrame" title="<cfoutput>#menutitle[45]#</cfoutput>">
				<cfoutput>#menutitle[45]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4150 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=9" target="mainFrame" title="<cfoutput>#menutitle[70]#</cfoutput>">
				<cfoutput>#menutitle[70]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4160 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=5" target="mainFrame" title="<cfoutput>#menutitle[47]#</cfoutput>">
				<cfoutput>#menutitle[47]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4170 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=6" target="mainFrame" title="<cfoutput>#menutitle[48]#</cfoutput>">
				<cfoutput>#menutitle[48]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4180 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=7" target="mainFrame" title="<cfoutput>#menutitle[46]#</cfoutput>">
				<cfoutput>#menutitle[46]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4190 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=8" target="mainFrame" title="<cfoutput>#menutitle[68]#</cfoutput>">
				<cfoutput>#menutitle[68]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h41A0 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=10" target="mainFrame" title="<cfoutput>#menutitle[69]#</cfoutput>">
				<cfoutput>#menutitle[69]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h41B0 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=12" target="mainFrame" title="<cfoutput>#menutitle[71]#</cfoutput>">
				<cfoutput>#menutitle[71]#</cfoutput>
			</a>
		</li>
        </cfif>
		<cfif getpin2.h41C0 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=11" target="mainFrame" title="<cfoutput>#menutitle[157]#</cfoutput>">
				<cfoutput>#menutitle[157]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h41D0 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=13" target="mainFrame" title="<cfoutput>#menutitle[72]#</cfoutput>">
				<cfoutput>#menutitle[72]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h41E0 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=14" target="mainFrame" title="<cfoutput>#menutitle[73]#</cfoutput>">
				<cfoutput>#menutitle[73]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h41F0 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=15" target="mainFrame" title="<cfoutput>#menutitle[74]#</cfoutput>">
				<cfoutput>#menutitle[74]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h43G0 eq "T">
         <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=16" target="mainFrame" title="<cfoutput>#menutitle[417]#</cfoutput>">
				<cfoutput>#menutitle[417]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h43H0 eq "T">
         <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-billing/bill_listingreport.cfm?type=17" target="mainFrame" title="<cfoutput>#menutitle[418]#</cfoutput>">
				<cfoutput>#menutitle[418]#</cfoutput>
			</a>
		</li>
        </cfif>
        
    </span>
	</cfif>
	<cfif getpin2.h4200 eq "T">
    <li onClick="SwitchMenu('sub2')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[90]#</cfoutput>"><cfoutput>#menutitle[90]#</cfoutput></a></li>
<span id="sub2" style="display:none;" class="submenu">

		<cfif getpin2.h4210 eq "T" or getpin2.h421B eq "T" or getpin2.h4220 eq "T" or getpin2.h4230 eq "T" or getpin2.h4240 eq "T" or getpin2.h4250 eq "T" or getpin2.h4260 eq "T" or getpin2.h4270 eq "T" or getpin2.h4280 eq "T" or getpin2.h4290 eq "T">
        <li onClick="SwitchMenu2('sub3')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[208]#</cfoutput>">
        <cfoutput>#menutitle[208]#</cfoutput></a></li>
                <span id="sub3" style="display:none;" class="submenu2">
        <cfif getpin2.h4210 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/stockcard.cfm?type=1" target="mainFrame" title="<cfoutput>#menutitle[209]#</cfoutput>">
				<cfoutput>#menutitle[209]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4220 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/reorderadvise.cfm?type=2" target="mainFrame" title="<cfoutput>#menutitle[210]#</cfoutput>">
				<cfoutput>#menutitle[210]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4260 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/stockaging.cfm" target="mainFrame" title="<cfoutput>#menutitle[211]#</cfoutput>">
				<cfoutput>#menutitle[211]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4270 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/physical_worksheet_menu.cfm" target="mainFrame" title="<cfoutput>#menutitle[212]#</cfoutput>">
				<cfoutput>#menutitle[212]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4280 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/transsummary.cfm?type=Quantity" target="mainFrame" title="<cfoutput>#menutitle[213]#</cfoutput>">
				<cfoutput>#menutitle[213]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4290 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/transsummary.cfm?type=Value" target="mainFrame" title="<cfoutput>#menutitle[214]#</cfoutput>">
				<cfoutput>#menutitle[214]#</cfoutput>
			</a>
		</li>
        </cfif>
       
       
        </span>
        </cfif>
 
        <cfif getpin2.h4230 eq "T" or getpin2.h4240 eq "T">
        <li onClick="SwitchMenu2('sub4')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[217]#</cfoutput>">
        <cfoutput>#menutitle[217]#</cfoutput></a></li>
                <span id="sub4" style="display:none;" class="submenu2">
        <cfif getpin2.h4230 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/itemstatus.cfm?type=3" target="mainFrame" title="<cfoutput>#menutitle[218]#</cfoutput>">
				<cfoutput>#menutitle[218]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4240 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-stock/groupstatus.cfm?type=4" target="mainFrame" title="<cfoutput>#menutitle[219]#</cfoutput>">
            <cfif getgeneral.dflanguage eq 'english'>
            #getgeneral.lGROUP# Status and Value
            <cfelse>
				<cfoutput>#menutitle[219]#</cfoutput>
                </cfif>
			</a>
		</li>
        </cfif>
        
        
        
        
        </span> 
        </cfif>       
    </span>
	</cfif>
    
	<cfif getpin2.h4300 eq "T">
    <li onClick="SwitchMenu('sub5')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[91]#</cfoutput>"><cfoutput>#menutitle[91]#</cfoutput></a></li>
<span id="sub5" style="display:none;" class="submenu">
		<cfif getpin2.h4310 eq "T" or getpin2.h4320 eq "T" or getpin2.h4330 eq "T" or getpin2.h4340 eq "T" or getpin2.h4350 eq "T" > 
        <li onClick="SwitchMenu2('sub6')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[221]#</cfoutput>"><cfoutput>#menutitle[221]#</cfoutput></a></li>
                <span id="sub6" style="display:none;" class="submenu2">
                            <cfif getpin2.h4310 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=producttype" target="mainFrame" title="<cfoutput>#menutitle[222]#</cfoutput>">
                                    <cfoutput>#menutitle[222]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h4320 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=customertype" target="mainFrame" title="<cfoutput>#menutitle[223]#</cfoutput>">
                                   <cfoutput>#menutitle[223]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h4330 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=agenttype" target="mainFrame" title="<cfoutput>#menutitle[224]#</cfoutput>">
                                   <cfoutput>#menutitle[224]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h4340 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=grouptype" target="mainFrame" title="<cfoutput>#menutitle[225]#</cfoutput>">
                                <cfif getgeneral.dflanguage eq 'english'>
                                #getgeneral.lgroup# Sales
                                <cfelse>
                                   <cfoutput>#menutitle[225]#</cfoutput></cfif>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h4350 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestype.cfm?type=endusertype" target="mainFrame" title="<cfoutput>#menutitle[226]#</cfoutput>">
                                 <cfoutput>#menutitle[226]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                           
                </span>
                </cfif>
                
                <cfif getpin2.h4360 eq "T" or getpin2.h4370 eq "T" or getpin2.h4380 eq "T" or getpin2.h4390 eq "T" or getpin2.h43A0 eq "T" > 
                
        <li onClick="SwitchMenu2('sub7')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[228]#</cfoutput>">
        <cfoutput>#menutitle[228]#</cfoutput></a></li>
                <span id="sub7" style="display:none;" class="submenu2">
                	         <cfif getpin2.h4360 eq "T">
                             <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=productmonth" target="mainFrame" title="<cfoutput>#menutitle[229]#</cfoutput>">
                                    <cfoutput>#menutitle[229]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h4360 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonth_2.cfm?type=productmonth" target="mainFrame" title="<cfoutput>#menutitle[230]#</cfoutput>">
                                    <cfoutput>#menutitle[230]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h4370 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=customermonth" target="mainFrame" title="<cfoutput>#menutitle[223]#</cfoutput>">
                                    <cfoutput>#menutitle[223]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h4380 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=agentmonth" target="mainFrame" title="<cfoutput>#menutitle[224]#</cfoutput>">
                                    <cfoutput>#menutitle[224]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h4390 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonthnew.cfm?type=groupmonth" target="mainFrame" title="<cfoutput>#menutitle[225]#</cfoutput>">
                                <cfif getgeneral.dflanguage eq 'english'>
                                #getgeneral.lgroup# Sales
                                <cfelse>
                                    <cfoutput>#menutitle[225]#</cfoutput>
                                    </cfif>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43A0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesmonth.cfm?type=endusermonth" target="mainFrame" title="<cfoutput>#menutitle[226]#</cfoutput>">
                                    <cfoutput>#menutitle[226]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            
                </span>
                </cfif>

                <cfif getpin2.h43I0 eq "T" or getpin2.h43J0 eq "T" or getpin2.h43K0 eq "T" or getpin2.h43L0 eq "T" or getpin2.h43M0 eq "T"> 
        <li onClick="SwitchMenu2('sub9')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[357]#</cfoutput>">
		<cfoutput>#menutitle[357]#</cfoutput></a></li>
                <span id="sub9" style="display:none;" class="submenu2">
                	        <cfif getpin2.h43I0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=fixed" target="mainFrame" title="<cfoutput>#menutitle[237]#</cfoutput>">
                                    <cfoutput>#menutitle[237]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43J0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=fifo" target="mainFrame" title="<cfoutput>#menutitle[238]#</cfoutput>">
                                    <cfoutput>#menutitle[238]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43K0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=lifo" target="mainFrame" title="<cfoutput>#menutitle[239]#</cfoutput>">
                                    <cfoutput>#menutitle[239]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43L0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=month" target="mainFrame" title="<cfoutput>#menutitle[240]#</cfoutput>">
                                    <cfoutput>#menutitle[240]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43M0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/calculatecostmenu.cfm?type=moving" target="mainFrame" title="<cfoutput>#menutitle[241]#</cfoutput>">
                                    <cfoutput>#menutitle[241]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            
                </span>
                </cfif>
                
                <cfif getpin2.h43B0 eq "T" or getpin2.h43C0 eq "T" or getpin2.h43D0 eq "T" or getpin2.h43E0 eq "T" or getpin2.h43N0 eq "T" or getpin2.h43O0 eq "T"> 
        <li onClick="SwitchMenu2('sub10')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[242]#</cfoutput>">
        <cfoutput>#menutitle[242]#</cfoutput></a></li>
                <span id="sub10" style="display:none;" class="submenu2">
                	        <cfif getpin2.h43B0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=productmargin" target="mainFrame" title="<cfoutput>#menutitle[243]#</cfoutput>">
                                    <cfoutput>#menutitle[243]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43C0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=billmargin" target="mainFrame" title="<cfoutput>#menutitle[244]#</cfoutput>">
                                    <cfoutput>#menutitle[244]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43D0 eq "T">
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=agentmargin" target="mainFrame" title="<cfoutput>#menutitle[245]#</cfoutput>">
                                    <cfoutput>#menutitle[245]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43E0 eq "T">
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=projectmargin" target="mainFrame" title="<cfoutput>#menutitle[246]#</cfoutput>">
                                <cfif getgeneral.dflanguage eq 'english'>
                                By #getgeneral.lproject# 
                                <cfelse>
                                    <cfoutput>#menutitle[246]#</cfoutput>
                                    </cfif>
                                </a>
                            </li>
                            </cfif>
                          
                           <cfif getpin2.h43N0 eq "T">
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=billitemmargin" target="mainFrame" title="<cfoutput>#menutitle[247]#</cfoutput>">
                                    <cfoutput>#menutitle[247]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43O0 eq "T">
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/profitmargin.cfm?type=customermargin" target="mainFrame" title="<cfoutput>#menutitle[180]#</cfoutput>">
                                    <cfoutput>#menutitle[180]#</cfoutput>
                                </a>
                            </li>
                           </cfif>
                </span>
                </cfif>
                
                <cfif getpin2.h43F0 eq "T" or getpin2.h43G0 eq "T" or getpin2.h43H0 eq "T" or getpin2.h43P0 eq "T"> 
        <li onClick="SwitchMenu2('sub11')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[248]#</cfoutput>">
        <cfoutput>#menutitle[248]#</cfoutput></a></li>
                <span id="sub11" style="display:none;" class="submenu2">
                	        <cfif getpin2.h43F0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/saleslisting.cfm?type=customerlist" target="mainFrame" title="<cfoutput>#menutitle[180]#</cfoutput>">
                                    <cfoutput>#menutitle[180]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43G0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/saleslisting.cfm?type=productlist" target="mainFrame" title="<cfoutput>#menutitle[243]#</cfoutput>">
                                    <cfoutput>#menutitle[243]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43H0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/saleslisting.cfm?type=agentlist" target="mainFrame" title="<cfoutput>#menutitle[245]#</cfoutput>">
                                    <cfoutput>#menutitle[245]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43P0 eq "T">
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/saleslisting.cfm?type=arealist" target="mainFrame" title="<cfoutput>#menutitle[249]#</cfoutput>">
                                    <cfoutput>#menutitle[249]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                </span>
                </cfif>
                
                <cfif getpin2.h43Q0 eq "T" or getpin2.h43R0 eq "T">
        <li onClick="SwitchMenu2('sub12')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[250]#</cfoutput>">
        <cfoutput>#menutitle[250]#</cfoutput></a></li>
                <span id="sub12" style="display:none;" class="submenu2">
                	        <cfif getpin2.h43Q0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topbottomsales.cfm?type=top" target="mainFrame" title="<cfoutput>#menutitle[251]#</cfoutput>">
                                    <cfoutput>#menutitle[251]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43R0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topbottomsales.cfm?type=bottom" target="mainFrame" title="<cfoutput>#menutitle[252]#</cfoutput>">
                                    <cfoutput>#menutitle[252]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                </span>
                </cfif>
                <cfif getpin2.h43S0 eq "T" or getpin2.h43T0 eq "T" or getpin2.h43U0 eq "T">
        <li onClick="SwitchMenu2('sub13')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[253]#</cfoutput>">
        <cfoutput>#menutitle[253]#</cfoutput></a></li>
                <span id="sub13" style="display:none;" class="submenu2">
                	        <cfif getpin2.h43S0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topsales.cfm?type=customertype" target="mainFrame" title="<cfoutput>#menutitle[180]#</cfoutput>">
                                    <cfoutput>#menutitle[180]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43T0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topsales.cfm?type=agenttype" target="mainFrame" title="<cfoutput>#menutitle[245]#</cfoutput>">
                                    <cfoutput>#menutitle[245]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                            <cfif getpin2.h43U0 eq "T">
                           <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/topsales.cfm?type=areatype" target="mainFrame" title="<cfoutput>#menutitle[249]#</cfoutput>">
                                    <cfoutput>#menutitle[249]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                </span>
				</cfif>
                
               
                
        <li onClick="SwitchMenu2('sub15')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[264]#</cfoutput>">
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
                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salespaydetail.cfm" target="mainFrame" title="<cfoutput>#menutitle[426]#</cfoutput>">
                                    <cfoutput>#menutitle[426]#</cfoutput>
                                </a>
                            </li>

                </span>

               
                
                <cfif getpin2.h43V0 eq "T" >
        <li onClick="SwitchMenu2('sub17')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[411]#</cfoutput>">
        <cfoutput>#menutitle[411]#</cfoutput></a></li>
                <span id="sub17" style="display:none;" class="submenu2">
                	        <cfif getpin2.h43V0 eq "T">
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesreport.cfm?type=agenttype" target="mainFrame" title="<cfoutput>#menutitle[269]#</cfoutput>">
                                   <cfoutput>#menutitle[269]#</cfoutput>
                                </a>
                            </li>
                            </cfif>
                           
                </span>
				</cfif>
    </span>
    </cfif>
    
     
              
        <li onClick="SwitchMenu('sub14')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[254]#</cfoutput>">
		<cfoutput>#menutitle[254]#</cfoutput></a></li>
                <span id="sub14" style="display:none;" class="submenu">
                	     
                           	
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salesqtyreport.cfm" target="mainFrame" title="<cfoutput>Daily Sales Qty Report</cfoutput>">
                                    <cfoutput>Daily Sales Qty Report</cfoutput>
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
                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/dailyprofit.cfm" target="mainFrame" title="Daily Profit">
                                    Daily Profit
                                </a>
                            </li>
                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/monthprofit.cfm" target="mainFrame" title="Daily Profit">
                                    Monthly Profit
                                </a>
                            </li>
                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/cashsalesdetail.cfm" target="mainFrame" title="Daily Profit">
                                    Daily Cash Sales Detail
                                </a>
                            </li>
                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/receivedetail.cfm" target="mainFrame" title="Daily Profit">
                                    Daily Receive Detail
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/stockreceipt.cfm" target="mainFrame" title="Daily Profit">
                                    Stock Receipt
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/salestodatebyagent.cfm" target="mainFrame" title="Daily Profit">
                                    Sales to Date By Agent
                                </a>
                            </li>
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/cashuplog.cfm" target="mainFrame" title="Daily Profit">
                                    Cash Up Log
                                </a>
                            </li>
                             <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/stockonhandsummary.cfm" target="mainFrame" title="<cfoutput>#menutitle[219]#</cfoutput>">
                    
                               Group Stock Card  Summary
                                </a>
                            </li>
                            
                </span>
                
                 <li onClick="SwitchMenu('sub30')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>Member Report</cfoutput>">
		<cfoutput>Member Report</cfoutput></a></li>
                <span id="sub30" style="display:none;" class="submenu">
                
                <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/memberitemhistory.cfm" target="mainFrame" title="<cfoutput>Member Item History</cfoutput>">
                                    <cfoutput>Member Item History</cfoutput>
                                </a>
                            </li>
                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/memberpointhistory.cfm" target="mainFrame" title="<cfoutput>Member Point History</cfoutput>">
                                    <cfoutput>Member Point History</cfoutput>
                                </a>
                            </li>
                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/birthday.cfm" target="mainFrame" title="<cfoutput>Member Birthday</cfoutput>">
                                    <cfoutput>Member Birthday</cfoutput>
                                </a>
                            </li>
                            
                            <li>
                                <a class="oe_secondary_submenu_item" href="/#HDir#/report-sales/memberexpire.cfm" target="mainFrame" title="<cfoutput>Member Expire Date</cfoutput>">
                                    <cfoutput>Member Expire Date</cfoutput>
                                </a>
                            </li>
                
                </span>
                
                <cfif getpin2.h4400 eq "T">
    <li onClick="SwitchMenu('sub19')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[92]#</cfoutput>"><cfoutput>#menutitle[92]#</cfoutput></a></li>
<span id="sub19" style="display:none;" class="submenu">

		<cfif getpin2.h4410 eq "T" or getpin2.h4420 eq "T">
		<li onClick="SwitchMenu2('sub20')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[221]#</cfoutput>"><cfoutput>#menutitle[221]#</cfoutput></a></li>
                <span id="sub20" style="display:none;" class="submenu2">
        <cfif getpin2.h4410 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasetype.cfm?type=producttype" target="mainFrame" title="<cfoutput>#menutitle[271]#</cfoutput>">
				<cfoutput>#menutitle[271]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4420 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasetype.cfm?type=vendortype" target="mainFrame" title="<cfoutput>#menutitle[272]#</cfoutput>">
				<cfoutput>#menutitle[272]#</cfoutput>
			</a>
		</li>
        </cfif>
        </span>
        </cfif>
        
        <cfif getpin2.h4430 eq "T" or getpin2.h4440 eq "T">
        <li onClick="SwitchMenu2('sub21')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[228]#</cfoutput>">
        <cfoutput>#menutitle[228]#</cfoutput></a></li>
                <span id="sub21" style="display:none;" class="submenu2">
        <cfif getpin2.h4430 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasemonth.cfm?type=productmonth" target="mainFrame" title="<cfoutput>#menutitle[271]#</cfoutput>">
				<cfoutput>#menutitle[271]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4440 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchasemonth.cfm?type=vendormonth" target="mainFrame" title="<cfoutput>#menutitle[272]#</cfoutput>">
				<cfoutput>#menutitle[272]#</cfoutput>
			</a>
		</li>
        </cfif>
        </span>
        </cfif>
        
        <li onClick="SwitchMenu2('sub22')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[273]#</cfoutput>">
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

        

        <li onClick="SwitchMenu2('sub23')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[276]#</cfoutput>"><cfoutput>#menutitle[276]#</cfoutput></a></li>
                <span id="sub23" style="display:none;" class="submenu2">

        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-purchase/purchaselisting.cfm" target="mainFrame" title="<cfoutput>#menutitle[277]#</cfoutput>">
				<cfoutput>#menutitle[277]#</cfoutput>
			</a>
		</li>

        </span>

        

        <li onClick="SwitchMenu2('sub24')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[278]#</cfoutput>">
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
                
                	<cfif getpin2.h4500 eq "T">
    <li onClick="SwitchMenu('sub29')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[94]#</cfoutput>">
    		<cfif getgeneral.dflanguage eq 'english'>
               				#getgeneral.lLOCATION# Report
                    <cfelse>
                    <cfoutput>#menutitle[94]#</cfoutput>
                    </cfif>
    </a></li>
<span id="sub29" style="display:none;" class="submenu">

		<cfif getpin2.h4510 eq "T" or getpin2.h4520 eq "T" or getpin2.h4580 eq "T">
		 <li onClick="SwitchMenu2('sub30')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[183]#</cfoutput>">
         <cfoutput>#menutitle[183]#</cfoutput></a></li>
                <span id="sub30" style="display:none;" class="submenu2">
            <cfif getpin2.h4510 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_listingreport.cfm?type=1" target="mainFrame" title="<cfoutput>#menutitle[286]#</cfoutput>">
                    <cfoutput>#menutitle[286]#</cfoutput>
                </a>
            </li>
            </cfif>
            <cfif getpin2.h4520 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_listingreport.cfm?type=2" target="mainFrame" title="<cfoutput>#menutitle[287]#</cfoutput>">
                    <cfoutput>#menutitle[287]#</cfoutput>
                </a>
            </li>
            </cfif>
         </span>
         </cfif>
         
         
         
         <cfif getpin2.h4530 eq "T" or getpin2.h4540 eq "T" or getpin2.h4550 eq "T" or getpin2.h4560 eq "T" or getpin2.h4570 eq "T">
         <li onClick="SwitchMenu2('sub31')"><a class="oe_secondary_menu_item2" style="cursor:pointer" title="<cfoutput>#menutitle[359]#</cfoutput>">
		 <cfoutput>#menutitle[359]#</cfoutput></a></li>
                <span id="sub31" style="display:none;" class="submenu2">
            <cfif getpin2.h4530 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_stockcard_stock_card.cfm" target="mainFrame" title="<cfoutput>#menutitle[289]#</cfoutput>">
                    <cfoutput>#menutitle[289]#</cfoutput>
                </a>
            </li>
            </cfif>
            <cfif getpin2.h4540 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_stockcard_forecast.cfm" target="mainFrame" title="<cfoutput>#menutitle[290]#</cfoutput>">
                    <cfoutput>#menutitle[290]#</cfoutput>
                </a>
            </li>
            </cfif>
            <cfif getpin2.h4570 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_openingqty.cfm" target="mainFrame" title="<cfoutput>#menutitle[293]#</cfoutput>">
                    <cfoutput>#menutitle[293]#</cfoutput>
                </a>
            </li>
            </cfif>
            <cfif getpin2.h4570 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_openingqty1.cfm" target="mainFrame" title="<cfoutput>#menutitle[294]#</cfoutput>">
                    <cfoutput>#menutitle[294]#</cfoutput>
                </a>
            </li>
            </cfif>
            <cfif getpin2.h4570 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/location_stockcard_stock_cardsummary.cfm" target="mainFrame" title="<cfoutput>#menutitle[295]#</cfoutput>">
                    <cfoutput>#menutitle[295]#</cfoutput>
                </a>
            </li>
            </cfif>
            <cfif getpin2.h4570 eq "T">
            <li>
                <a class="oe_secondary_submenu_item" href="/#HDir#/report-location/locationstockcheck.cfm" target="mainFrame" title="<cfoutput>#menutitle[296]#</cfoutput>">
                    <cfoutput>#menutitle[296]#</cfoutput>
                </a>
            </li>
            </cfif>
            
         </span>
         </cfif>
	</span>
    </cfif>
                
                
<!---
    
	<cfif getpin2.h4B00 eq "T">
    <li onClick="SwitchMenu('sub42')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[362]#</cfoutput>"><cfoutput>#menutitle[98]#</cfoutput></a></li>
<span id="sub42" style="display:none;" class="submenu">
				<cfif getpin2.h4B10 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-matrixitem/matrixreportform.cfm?type=opening" target="mainFrame" title="<cfoutput>#menutitle[315]#</cfoutput>"><cfoutput>#menutitle[315]#</cfoutput></a>
                </li>
                </cfif>
                <cfif getpin2.h4B20 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-matrixitem/matrixreportform.cfm?type=sales" target="mainFrame" title="<cfoutput>#menutitle[316]#</cfoutput>"><cfoutput>#menutitle[316]#</cfoutput></a>
                </li>
                </cfif>
                <cfif getpin2.h4B30 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-matrixitem/matrixreportform.cfm?type=purchase" target="mainFrame" title="<cfoutput>#menutitle[327]#</cfoutput>"><cfoutput>#menutitle[327]#</cfoutput></a>
                </li>
                </cfif>
                <cfif getpin2.h4B40 eq "T">
                <li>
                    <a class="oe_secondary_submenu_item" href="/#HDir#/report-matrixitem/matrixreportform.cfm?type=stockbalance" target="mainFrame" title="<cfoutput>#menutitle[328]#</cfoutput>"><cfoutput>#menutitle[328]#</cfoutput></a>
                </li>
                </cfif>
	</span>
    </cfif>
    

<cfif getpin2.h4600 eq "T">
<li onClick="SwitchMenu('sub34')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[353]#</cfoutput>"><cfoutput>#menutitle[353]#</cfoutput></a></li>
                <span id="sub34" style="display:none;" class="submenu">
        <cfif getpin2.h4610 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=ref" target="mainFrame" title="<cfoutput>#menutitle[424]#</cfoutput>">
				<cfoutput>#menutitle[424]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4620 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=item" target="mainFrame" title="<cfoutput>#menutitle[425]#</cfoutput>">
				<cfoutput>#menutitle[425]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4630 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=status" target="mainFrame" title="<cfoutput>#menutitle[354]#</cfoutput>">
				<cfoutput>#menutitle[354]#</cfoutput>
			</a>
		</li>
        </cfif>
        <cfif getpin2.h4640 eq "T">
        <li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/report-others/serialreport1.cfm?type=sale" target="mainFrame" title="<cfoutput>#menutitle[355]#</cfoutput>">
				<cfoutput>#menutitle[355]#</cfoutput>
			</a>
		</li>
        </cfif>

        </span>
        </cfif>


--->


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
        <span id="sub47" style="display:none;" class="submenu">
        
        </span>
	</cfoutput>
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
