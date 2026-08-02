<cfif IsDefined("url.id")>
	<cfif husergrpid EQ "super">
        <cfset pin="super">
    <cfelseif husergrpid EQ "admin">
        <cfset pin="Admin">
    <cfelseif husergrpid EQ "guser">
        <cfset pin="General">
    <cfelseif husergrpid EQ "luser">
        <cfset pin="Limited">
    <cfelseif husergrpid EQ "muser">
        <cfset pin="Mobile">
    <cfelseif husergrpid EQ "suser">
        <cfset pin="Standard">
    <cfelse>
        <cfset pin="#husergrpid#">
    </cfif>

    <cfquery name="getGsetup" datasource="#dts#">
        SELECT dflanguage
        FROM gsetup;
    </cfquery>

    <!---Perform checking for new MENU added in MAIN table --->
    <cfquery name="getictrantemp" datasource="#dts#">
       INSERT IGNORE INTO userDefinedMenu(menu_id,menu_name,new_menu_name,menu_level)
       SELECT menu_id, menu_name AS a,menu_name AS b,menu_level AS c
       FROM main.menunew2;
    </cfquery>

	<cfif getGsetup.dflanguage NEQ "english">
        <cfset menuname=getGsetup.dflanguage>
        <cfset titledesp="titledesp_"&getGsetup.dflanguage>
    <cfelse>
        <cfset menuname="menu_name">
        <cfset titledesp="titledesp">
    </cfif>

	<cfquery name="getictrantemp" datasource="#dts#">
		UPDATE userDefinedMenu a,main.menunew2 b
		SET
			a.new_menu_name = b.#menuname#,
			a.menu_name = b.menu_name
		WHERE a.menu_id = b.menu_id
		AND changed != '1';
    </cfquery>

    <cfquery name="getMenu" datasource="#dts#">
        SELECT DISTINCT m.menu_id AS menu_id, m.#menuname# AS menu_name,m.menu_url AS menu_url,m.#titledesp# AS titledesp, m.userpin_id as userpin_id,
        				udm.new_menu_name AS newMenuName
        FROM main.menunew2 AS m
        LEFT JOIN userdefinedmenu AS udm ON m.menu_id = udm.menu_id
        WHERE m.menu_parent_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.id)#">
        AND m.menu_id > 9999
        ORDER BY m.menu_order
    </cfquery>

    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>Inventory Management System</title>
            <script type="text/javascript">
                function wposPopup(url) {
                    var p = 'width=' + screen.width + ',height=' + screen.height +
                            ',top=0,left=0,status=yes,menubar=no,location=no,scrollbars=yes,fullscreen';
                    var w = window.open(url, 'waiterpos', p);
                    if (window.focus) { w.focus(); }
                    return false;
                }
            </script>
            <cfif husergrpid EQ "super">
                <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
                <script type="text/javascript" src="/latest/js/jeditable/jquery.jeditable.mini.js"></script>
                <cfoutput>
					<script type="text/javascript">
                        var dts='#dts#';
                        var authUser='#getAuthUser()#';
                    </script>
                </cfoutput>
                <script type="text/javascript" src="/latest/js/body/bodymenu.js"></script>
            </cfif>
            <style>
                body{
                    margin:0;
                }
                .content{
                    margin:0;
                    padding:0;
                }
                .content_body{
                    margin:0;
                    padding:0;
                    width:100%;
                }
                .menulist ul{
                    max-width:905px;
                    padding:0;
                    margin:25px;
                }
                .menulist li{
                    display:inline-block;
                    text-decoration:none;
                    list-style-type:none;
                    font-family:Segoe UI;
                    margin-left:25px;
                    margin-top:25px;
                    border-left:8px solid #f0606d;
                    box-shadow: 0px 0px 10px #CCCCCC;
                    background-color:#FFFFFF;
                    cursor:pointer;
                    behavior: url(/latest/css/pie/PIE.htc);
                }
                .menulist li:hover,.menulist li:active{
                    color:#1D2835;
                    border-left:8px solid #1D2835;
                    background-color:#f0606d;
                }
                .menulist a{
                    text-decoration:none;
                }
                .submenu{
                    margin:10px 24px 10px 16px;
                    width:367px;
                }
                .title{
                    vertical-align:top;
                    font-family:"Franklin Gothic Book";
                    font-size:22px;
                    font-weight:bold;
                    letter-spacing:0.025em;
                    color:#1D2835;
                    border-bottom:1px solid #666666;
                    overflow:hidden;
                    word-wrap:break-word;
                    min-height:35px;
                }
                .desp{
                    margin-top:7px;
                    font-family:"Segoe UI";
                    font-size:12px;
                    font-style:italic;
                    color:#666666;
                    min-height:35px;
                    overflow:hidden;
                    word-wrap:break-word;
                }
                .menulist li:hover .title,.menulist li:active .title{
                    color:#1D2835;
                    border-bottom:1px solid #1D2835;
                }
                .menulist li:hover .desp,.menulist li:active .desp{
                    color:#1D2835;
                }
            </style>

        </head>
        <cfoutput>
            <body>
                <div class="content">
                    <div class="content_body">
                        <div class="menulist">
                            <ul>
                                <cfloop query="getMenu">
                                    <!--- Table management lives in Waiter Dashboard; hide legacy Tables tile (menu_id 60004). --->
                                    <cfif trim(getMenu.menu_id) eq "60004"><cfcontinue></cfif>
                                    <!--- Waiter POS opens as a dedicated fullscreen window, same as the legacy "new screen POS" (menuID=20500). --->
                                    <cfif trim(getMenu.menu_id) eq "60005">
                                        <cfset qq = chr(39)>
                                        <cfset menuLinkAttrs = 'href="##" onclick="return wposPopup(' & qq & JSStringFormat('../' & getMenu.menu_url) & qq & ')"'>
                                    <cfelse>
                                        <cfset menuLinkAttrs = 'href="../' & getMenu.menu_url & '"'>
                                    </cfif>
									<cfif getMenu.userpin_id neq "">
                                        <cfif evaluate('getpin2.#userpin_id#') eq "T">
                                            <li>
                                                <cfif husergrpid NEQ "super">
                                                    <a #menuLinkAttrs#>
                                                </cfif>
                                                <div class="submenu">
                                                    <cfif husergrpid EQ "super">
                                                        <a #menuLinkAttrs#>
                                                    </cfif>
                                                    <div class="title">#getMenu.newMenuName#</div>
                                                        <cfif husergrpid EQ "super">
                                                            </a>
                                                        </cfif>
                                                    <div id="#getMenu.menu_id#" class="desp">#getMenu.titledesp#</div>
                                                </div>
                                                <cfif husergrpid NEQ "super">
                                                	</a>
                                                </cfif>
                                            </li>
                                        </cfif>
                                    <cfelse>
                                        <li>
                                            <cfif husergrpid NEQ "super">
                                                <a #menuLinkAttrs#>
                                            </cfif>
                                            <div class="submenu">
                                                <cfif husergrpid EQ "super">
                                                    <a #menuLinkAttrs#>
                                                </cfif>
                                                <div class="title">#getMenu.newMenuName#</div>
                                                    <cfif husergrpid EQ "super">
                                                        </a>
                                                    </cfif>
                                                <div id="#getMenu.menu_id#" class="desp">#getMenu.titledesp#</div>
                                            </div>
                                            <cfif husergrpid NEQ "super">
                                            	</a>
                                            </cfif>
                                        </li>
                                    </cfif>
                                </cfloop>
                                	<cfif trim(url.id) eq "10300" and lcase(hcomid) eq "keminates_i">
                                    	<li>
                                                <a href="/customized/keminates_i/firmProfile.cfm">
                                            <div class="submenu">
                                                <div class="title">Firm Profile</div>
                                                <div id="firmProfile" class="desp">Firm Profile</div>
                                            </div>
                                            	</a>
                                        </li>
                                    </cfif>
                                    <cfif trim(url.id) eq "50300" and lcase(hcomid) eq "keminates_i">
                                    	<li>
                                                <a href="/Report/KEMINATES/commReport.cfm">
                                            <div class="submenu">
                                                <div class="title">Designer Commission Report</div>
                                                <div id="firmProfile" class="desp">Designer Commission Report</div>
                                            </div>
                                            	</a>
                                        </li>
                                    </cfif>
                                    <cfif trim(url.id) eq "10300" and lcase(hcomid) eq "hamari_i">
                                    	<li>
                                                <a href="/customized/hamari_i/buscommProfile.cfm">
                                            <div class="submenu">
                                                <div class="title">Business Commission Profile</div>
                                                <div id="firmProfile" class="desp">Business Commission Profile</div>
                                            </div>
                                            	</a>
                                        </li>
                                    </cfif>
                                    <cfif trim(url.id) eq "50300" and lcase(hcomid) eq "hamari_i">
                                    	<li>
                                                <a href="/customized/hamari_i/commissionReport.cfm">
                                            <div class="submenu">
                                                <div class="title">Business Commission Report</div>
                                                <div id="firmProfile" class="desp">Business Commission Report</div>
                                            </div>
                                            	</a>
                                        </li>
                                    </cfif>

                                    <cfif trim(url.id) eq "10300" and lcase(hcomid) eq "haikhim_i">
                                    	<li>
                                                <a href="/customized/haikhim_i/projectProfile.cfm">
                                            <div class="submenu">
                                                <div class="title">Project Profile</div>
                                                <div id="firmProfile" class="desp">Project Profile</div>
                                            </div>
                                            	</a>
                                        </li>
                                    </cfif>
                            </ul>
                        </div>
                    </div>
                </div>
            </body>
        </cfoutput>
    </html>
</cfif>