<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Accounting Management System</title>
<link rel="stylesheet" type="text/css" href="/newinterface/css1.css" />
<script language="javascript" type="text/javascript" src="/scripts/change_left_menu.js"></script>
<!--- function popup3(PopUpUrl, windowname)
{
	if(window.WinPop3){
	WinPop3.close();
	}
if (! window.focus)return true;

    var ScreenWidth= Math.floor(screen.Availwidth); 
    var ScreenHeight= Math.floor(screen.Availheight); 
    var mScreenWidth= Math.floor((screen.Availwidth-ScreenWidth)/2); 
    var mScreenHeight= Math.floor((screen.Availheight-ScreenHeight)/2); 

    placementx=(-mScreenWidth); 
    placementy=(-mScreenHeight); 
    WinPop3=window.open(PopUpUrl,windowname,"width=895,height=640,toolbar=0,location=0,directories=0,status=0,scrollbars=1,menubar=0,resizable=1,  left="+placementx+",top="+placementy+",screenX="+placementx+",screenY="+placementy+","); 
	
} --->
	<SCRIPT TYPE="text/javascript">

function popup(url) 
{
 params  = 'width='+(screen.width*0.8);
 params += ', height='+screen.height;
 params += ', top=0, left=0, status=yes,menubar=no , location = no'
 params += ', fullscreen=yes,scrollbars=yes,resizable=yes';

 newwin=window.open(url,'expressbill', params);
 //if (window.focus) {newwin.focus()}
 //return false;
}
</script>
<cfprocessingdirective pageencoding="UTF-8">
</head>

<body class="netiquette"><cfquery datasource="#dts#" name="getgeneral">
    	select * from gsetup
</cfquery>
<cfquery datasource="#dts#" name="getmenu">
    SELECT * FROM mainams.menunew as a left join #dts#.userpin as b on a.menu_id = b.menu_id
     where a.menu_id=50
    <cfif husergrpid eq "super">
     and pin0='T'
    <cfelseif husergrpid eq "admin">
     and pin1='T'
    <cfelseif husergrpid eq "guser">
     and pin2='T'
    <cfelseif husergrpid eq "luser">
     and pin3='T'
    <cfelseif husergrpid eq "muser">
     and pin4='T'
    <cfelseif husergrpid eq "suser">
     and pin5='T'
    </cfif>
</cfquery>

<cfif getgeneral.dflanguage NEQ "english">
	<cfset menunameA=getgeneral.dflanguage>	
<cfelse>
	<cfset menunameA="menu_name">
</cfif>

<cfif getmenu.recordcount neq 0>
        <cfquery datasource="#dts#" name="getmenu1">
         SELECT a.menu_id AS menu_id, a.#menunameA# AS menu_name,a.menu_url AS menu_url 
         FROM mainams.menunew as a left join #dts#.userpin as b on a.menu_id = b.menu_id
         where a.menu_parent_id= '50'
         and a.menu_name<> "hr"
        <cfif husergrpid eq "super">
         and pin0='T'
        <cfelseif husergrpid eq "admin">
         and pin1='T'
        <cfelseif husergrpid eq "guser">
         and pin2='T'
        <cfelseif husergrpid eq "luser">
         and pin3='T'
        <cfelseif husergrpid eq "muser">
         and pin4='T'
        <cfelseif husergrpid eq "suser">
         and pin5='T'
        </cfif>
        order by a.menu_order
        </cfquery>
        <div style="overflow:hidden;">
        <div class="secondary_menu">
            <div style="width:100%" id="masterdiv">
            <!--- level 1 --->
            <cfset i = 0>
            <cfloop query="getmenu1">
            	<cfset menuname['#getmenu1.menu_id#']=getmenu1.menu_name>
                <!--- <cfif getgeneral.dflanguage eq 'english'>
                    <cfset menuname['#getmenu1.menu_id#']=getmenu1.menu_name>
                    <cfelseif getgeneral.dflanguage eq 'sim_ch'>
                    <cfset menuname['#getmenu1.menu_id#']=getmenu1.sim_ch>
                    <cfelseif getgeneral.dflanguage eq 'tra_ch'>
                    <cfset menuname['#getmenu1.menu_id#']=getmenu1.tra_ch>
					<cfelseif getgeneral.dflanguage eq 'indo'>
                    <cfset menuname['#getmenu1.menu_id#']=getmenu1.indo>
					<cfelseif getgeneral.dflanguage eq 'thai'>
                    <cfset menuname['#getmenu1.menu_id#']=getmenu1.thai>
                    <cfelseif getgeneral.dflanguage eq 'viet'>
                    <cfset menuname['#getmenu1.menu_id#']=getmenu1.viet>
                    <cfelseif getgeneral.dflanguage eq 'malay'>
                    <cfset menuname['#getmenu1.menu_id#']=getmenu1.malay>                    
                    </cfif> --->
        
            <cfset i = i +1>
            <li style="vertical-align:middle" onClick="SwitchMenu('sub<cfoutput>#i#</cfoutput>')"><a style="vertical-align:middle" class="oe_secondary_menu_item" title="<cfoutput>#menuname['#getmenu1.menu_id#']#</cfoutput>" <cfif getmenu1.menu_id eq "252" AND left(getAuthuser(),5) eq "ultra">onclick="top.frames['mainFrame'].location.href='/menuNew/transactions2.cfm';return true;"</cfif>><cfoutput>#menuname['#getmenu1.menu_id#']#</cfoutput></a></li>
            <span class="submenu" id="sub<cfoutput>#i#</cfoutput>" <cfif i neq 1>style="display: none;"<cfelse>style="display: block;"</cfif>>
        
                <cfset parentID = getmenu1.menu_id>
                <cfquery datasource="#dts#" name="getmenu2">
                    SELECT a.menu_id AS menu_id, a.#menunameA# AS menu_name,a.menu_url AS menu_url 
                    FROM mainams.menunew as a left join #dts#.userpin as b on a.menu_id = b.menu_id 
                    where a.menu_parent_id = '#parentID#' 
                    <cfif husergrpid eq "super">
                     and pin0='T'
                    <cfelseif husergrpid eq "admin">
                     and pin1='T'
                    <cfelseif husergrpid eq "guser">
                     and pin2='T'
                    <cfelseif husergrpid eq "luser">
                     and pin3='T'
                    <cfelseif husergrpid eq "muser">
                     and pin4='T'
                    <cfelseif husergrpid eq "suser">
                     and pin5='T'
                    </cfif>
                    order by a.menu_order
                </cfquery>
                <!--- level 2 --->
                <Cfloop query="getmenu2">
                	<cfset menuname['#getmenu2.menu_id#']=getmenu2.menu_name>
                    <cfif getgeneral.dflanguage eq 'sim_ch' OR getgeneral.dflanguage eq 'tra_ch'>
                    	<cfset L2size = "+1">
                    <cfelse>
                    	<cfset L2size = "-2">
                    </cfif>
                    <!--- <cfif getgeneral.dflanguage eq 'english'>
                    <cfset menuname['#getmenu2.menu_id#']=getmenu2.menu_name>
                    <cfset L2size = "-2">
                    <cfelseif getgeneral.dflanguage eq 'sim_ch'>
                    <cfset menuname['#getmenu2.menu_id#']=getmenu2.sim_ch>
                    <cfset L2size = "+1">
                    <cfelseif getgeneral.dflanguage eq 'tra_ch'>
                    <cfset menuname['#getmenu2.menu_id#']=getmenu2.tra_ch>
                    <cfset L2size = "+1">
                    <cfelseif getgeneral.dflanguage eq 'indo'>
                    <cfset menuname['#getmenu2.menu_id#']=getmenu2.indo>
                    <cfset L2size = "-2">
					<cfelseif getgeneral.dflanguage eq 'thai'>
                    <cfset menuname['#getmenu2.menu_id#']=getmenu2.thai>
                    <cfset L2size = "-2">
                    <cfelseif getgeneral.dflanguage eq 'viet'>
                    <cfset menuname['#getmenu2.menu_id#']=getmenu2.viet>
                    <cfset L2size = "-2">
                    <cfelseif getgeneral.dflanguage eq 'malay'>
                    <cfset menuname['#getmenu2.menu_id#']=getmenu2.malay>
                    <cfset L2size = "-2">                     
                    </cfif> --->
        
                <!--- <cfif getmenu2.menu_name eq "hr">
                    <hr>
                <cfelseif getmenu2.menu_url eq "">
                <br/>
                <strong>- &nbsp;<cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput>&nbsp; -</strong>
                <cfelse> --->
                <cfif getmenu2.menu_id eq "263">
                	<cfif dts eq "demo_a" and huserid eq "ultrack">
                    	<li><a class="oe_secondary_submenu_item" href="<cfoutput>#getmenu2.menu_url#</cfoutput>" title="<cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput>" target="mainFrame"><cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput></a></li>
                    <cfelse>
                		<li><a class="oe_secondary_submenu_item" href="javascript:popup('/trans.cfm')" title="<cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput>"><cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput></a></li>
					</cfif>                        
                <cfelse>
                <li><a class="oe_secondary_submenu_item" href="<cfoutput>#getmenu2.menu_url#</cfoutput>" title="<cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput>" target="mainFrame"><cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput></a></li>
                </cfif>
                <!--- </cfif> --->	
                    
                </cfloop>
                <!--- level 2 end --->
            </span>	
        
            </cfloop>
            <!--- level 1 end --->
            </div>
<cfelse>

</cfif>
<cfinclude template="/menunew/chat.cfm">
</body>
</html>
