<cfquery name="getGsetup" datasource="#dts#">
	SELECT dflanguage 
    FROM gsetup;
</cfquery>

<cfquery name="getUserDefinedMenu" datasource="#dts#">
	SELECT menu_id 
    FROM userDefinedMenu;
</cfquery>

<cfif getUserDefinedMenu.recordcount EQ 0>  
    <cfquery name="insertUserDefinedMenu" datasource="#dts#">
       INSERT IGNORE INTO userDefinedMenu(menu_id,menu_name,new_menu_name)
       SELECT menu_id, menu_name AS a,menu_name AS b
       FROM main.menunew2;
    </cfquery>
</cfif>

<cfif getGsetup.dflanguage NEQ "english">
	<cfset menuname=getGsetup.dflanguage>
<cfelse>
	<cfset menuname="menu_name">
</cfif>

<cfquery name="getLevel1Menu" datasource="#dts#">
	SELECT DISTINCT m.menu_id AS menu_id,m.#menuname# AS menu_name,m.menu_url AS menu_url,m.userpin_id as userpin_id,
    				udm.new_menu_name AS newMenuName
	FROM main.menunew2 AS m
    LEFT JOIN userdefinedmenu AS udm ON m.menu_id = udm.menu_id
	WHERE m.menu_level=1
    AND m.menu_id > 9999
	<cfif husergrpid NEQ "super">
    	AND m.menu_id < 70000
    </cfif>
	ORDER BY m.menu_order;
</cfquery>

<cfquery name="getCurrentActiveMenu" datasource="main">
	SELECT menu_id
	FROM menunew2
	WHERE menu_url LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#cgi.SCRIPT_NAME#%">;
</cfquery>

<cfif getCurrentActiveMenu.RecordCount GT 0>
	<cfset session.menuid = getCurrentActiveMenu.menu_id>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-Equiv="Cache-Control" Content="no-cache">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>Inventory Management System</title>
    <link rel="stylesheet" href="/latest/css/hoverscroll/jquery.hoverscroll.css" />
    <link rel="stylesheet" href="/latest/css/side/side.css" />
    <link rel="stylesheet" href="/latest/css/side/sidemenu.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/latest/js/hoverscroll/jquery.hoverscroll.js"></script>
    <script type="text/javascript" src="/latest/js/side/sidemenu.js"></script>
    <!---To hide the link value at status bar (bottom left of the browser) --->
    <script type="text/javascript">
		function redirectMenuLevel2(link1){
			window.open(link1,'mainFrame','','');
			return true;
		}
		
		function popup(url) 
		{
		 params  = 'width='+screen.width;
		 params += ', height='+screen.height;
		 params += ', top=0, left=0, status=yes,menubar=no , location = no'
		 params += ', top=0, left=0'
		 params += ', type=fullWindow, fullscreen ,scrollbars=yes';
		
		 newwin=window.open(url,'expressbill', params);
		 if (window.focus) {newwin.focus()}
		 return false;
		}
		
	</script> 
</head>

<body>
<cfoutput>
    <div id="logo_div" class="section">
        <a href="" target="_blank">
        	<img alt="POS Logo" src="/latest/img/pos logo.png" />
        </a>
    </div>
<div class="section">
	<ul id="menu" class="accordion">
    <cfif dts eq "starker_i">
    	<li id="itemA90000" class="itemA90000"><a href="##" target="mainFrame">#UCASE(DTS)#</a>
        <ul class="sub-menu">
        <li id="itemA91000" class="itemA91000"><a href="/REPORT/STARK/brewweight/s_brewweight.cfm" target="mainFrame">BM Weigh Record</a></li>
        <li id="itemA92000" class="itemA92000"><a href="/REPORT/STARK/dailyprod/s_dailyprod.cfm" target="mainFrame">Daily Prod. Sheet</a></li>
        <li id="itemA93000" class="itemA93000"><a href="/REPORT/STARK/beertransfer/s_beertransfer.cfm" target="mainFrame">Beer Transfer</a></li>
        </ul>
		</li>	
        </cfif>
		<cfloop query="getLevel1Menu">
        	<cfif husergrpid NEQ "super">
				<cfif getLevel1Menu.userpin_id NEQ "">
                    <cfif evaluate('getPin2.#userpin_id#') EQ "T">
                        <li id="item#getLevel1Menu.menu_id#" class="item#getLevel1Menu.menu_id#">
                            <a href='##'>#getLevel1Menu.newMenuName#</a>    
                            <ul class="sub-menu">
                                <cfquery name="getLevel2Menu" datasource="#dts#">
                                    SELECT DISTINCT m.menu_id AS menu_id,m.#menuname# AS menu_name,m.menu_url AS menu_url,m.userpin_id as userpin_id,
                                                    udm.new_menu_name AS newMenuName
                                    FROM main.menunew2 AS m
                                    LEFT JOIN userdefinedmenu AS udm ON m.menu_id = udm.menu_id
                                    WHERE m.menu_parent_id=#getLevel1Menu.menu_id#
                                    ORDER BY m.menu_order
                                </cfquery>
                                <cfloop query="getLevel2Menu">
                                	<cfif getLevel2Menu.userpin_id NEQ "">
                    					<cfif evaluate('getPin2.#userpin_id#') EQ "T">
                                            <li id="item#getLevel2Menu.menu_id#" class="item#getLevel2Menu.menu_id#">
                                                <cfif getLevel2Menu.menu_id eq "20300">
                                                <a class="oe_secondary_submenu_item" href="/latest/body/overview.cfm" target="mainFrame" onclick="popup('/#HDir#/transaction/POS/index.cfm?first=true&menuID=20715')" title="#getLevel2Menu.newMenuName#"> <cfoutput>#getLevel2Menu.newMenuName#</cfoutput> </a>
                                                <cfelseif getLevel2Menu.menu_id eq "20400">
                                                <a class="oe_secondary_submenu_item" href="/latest/body/overview.cfm" target="mainFrame" onclick="popup('/#HDir#/transaction/POS/checkprice.cfm?first=true&menuID=20400')" title="#getLevel2Menu.newMenuName#"> <cfoutput>#getLevel2Menu.newMenuName#</cfoutput> </a>
                          						<!---<cfelseif getLevel2Menu.menu_id eq "20400">
                                                <a class="##"  onclick="redirectMenuLevel2('/#HDir#/transaction/POS/checkprice.cfm?first=true&menuID=20400')" title="#getLevel2Menu.newMenuName#"> <cfoutput>#getLevel2Menu.newMenuName#</cfoutput> </a>--->
                                                 <cfelseif getLevel2Menu.menu_id eq "20500">
                                                <a class="oe_secondary_submenu_item" href="/latest/body/overview.cfm" target="mainFrame" onclick="popup('/newpos/Interface.cfm?first=true&menuID=20500')" title="#getLevel2Menu.newMenuName#"> <cfoutput>#getLevel2Menu.newMenuName#</cfoutput> </a>
                                                <cfelse>
                                                <a href="##" onClick="redirectMenuLevel2('../#getLevel2Menu.menu_url#')" title="#getLevel2Menu.newMenuName#" >#getLevel2Menu.newMenuName#</a>
                                            	</cfif>
                                            </li>
                                    	</cfif>        
                                    </cfif>
                                </cfloop>
                            </ul>
                        </li>	
                    </cfif>	
                </cfif>	
        	<cfelse>
            	<li id="item#getLevel1Menu.menu_id#" class="item#getLevel1Menu.menu_id#">
                    <a href='##'>#getLevel1Menu.newMenuName#</a>    
                    <ul class="sub-menu">
                        <cfquery name="getLevel2Menu" datasource="#dts#">
                            SELECT DISTINCT m.menu_id AS menu_id,m.#menuname# AS menu_name,m.menu_url AS menu_url,m.userpin_id as userpin_id,
                                            udm.new_menu_name AS newMenuName
                            FROM main.menunew2 AS m
                            LEFT JOIN userdefinedmenu AS udm ON m.menu_id = udm.menu_id
                            WHERE m.menu_parent_id=#getLevel1Menu.menu_id#
                            ORDER BY m.menu_order
                        </cfquery>
                        <cfloop query="getLevel2Menu">
                        	<li id="item#getLevel2Menu.menu_id#" class="item#getLevel2Menu.menu_id#">
                            	<cfif getLevel2Menu.menu_id eq "20300">
								<a class="oe_secondary_submenu_item" href="/latest/body/overview.cfm" target="mainFrame" onclick="popup('/#HDir#/transaction/POS/index.cfm?first=true&menuID=20715')" title="#getLevel2Menu.newMenuName#"> <cfoutput>#getLevel2Menu.newMenuName#</cfoutput> </a>
                            	<cfelse>
                                <a href="##" onClick="redirectMenuLevel2('../#getLevel2Menu.menu_url#')">#getLevel2Menu.newMenuName#</a>
                                </cfif>
                            </li>
                        </cfloop>
                    </ul>
                </li>
            </cfif>        
		</cfloop>
	</ul>
</div>
	<span id="searchNavigation"></span>
<div id="bottomDiv" class="bottomNavigationDiv">
	<span id="favoriteNavigation"></span>
</div>
</cfoutput>
</body>
</html>