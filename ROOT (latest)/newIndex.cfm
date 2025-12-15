<cfquery name="getgeneral" datasource="#dts#">
	select * from gsetup
</cfquery>

<cfif getgeneral.interface eq 'old'>

<cfajaximport tags="cfform,cftree,cfgrid,cftooltip,cfmenu">
<script src="scripts/trans.js" type="text/javascript"></script>
<!-- <link rel="stylesheet" href="./stylesheet/trans.css"/>-->

<cfinclude template="scripts/trans.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<!DOCTYPE HTML>
<html>

<head>
<title>Accounting Management System</title>
	<SCRIPT TYPE="text/javascript">
function popup3(PopUpUrl, windowname)
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
	
}
</script>
<style type="text/css">
body{
	
	font-family: Arial;
	filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='#C0CFE2', startColorstr='#FFFFFF', gradientType='0');
}

li{
	font-size: 9px;
}

.menutitle{
	cursor:hand;
	margin-bottom: 5px;
	background-color: #4B4B95;
	
	color:#FFFFFF;
	width:130px;
	padding:2px;
	text-align:center;
	font-weight:bold;
	font-size: 11px;
	border:1px solid #FFFFFF;
	font-family: Tahoma, Arial, Times New Roman;
}

.submenu{
	margin-bottom: 0.5em;
	list-style-image:  url(/foldoutmenu2_arrow.gif);
}
</style>
<script type="text/javascript">



if (document.getElementById){ 
document.write('<style type="text/css">\n')
document.write('.submenu{display: none;}\n')
document.write('</style>\n')
}

function SwitchMenu(obj){
	if(document.getElementById){
	var el = document.getElementById(obj);
	var ar = document.getElementById("masterdiv").getElementsByTagName("span"); 
		if(el.style.display != "block"){ 
			for (var i=0; i<ar.length; i++){
				if (ar[i].className=="submenu") 
				ar[i].style.display = "none";
			}
			el.style.display = "block";
		}else{
			el.style.display = "none";
		}
	}
}
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
</head>
<body>
	     
	<cflayout name="outerlayout" type="vbox">
    <cflayoutarea >
        <cflayout name="thelayout" type="border">
            <!--- The 100% height style ensures that the background color fills 
                the area. --->
          <cflayoutarea position="top" size="90"  style="filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='##FFFFFF', startColorstr='##C0CFE2', gradientType='0'); height:100%" source="header.cfm"/>
          <cflayoutarea title="Menu" position="left"  collapsible="true" name="left" splitter="true"
                    style="filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='##FFFFFF', startColorstr='##C0CFE2', gradientType='0'); height:100%" size="150" source="menu/newMenu2.cfm"/>
                
          
            <cflayoutarea position="center" 
                    style="filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='##FFFFFF', startColorstr='##C0CFE2', gradientType='0'); height:100%" >
              <iframe name="ifr" id="ifr"   style="width:100%;height:100%;" src="frameset/frameset3.cfm" ></iframe>	
            </cflayoutarea>
            <!--- <cflayoutarea position="right" collapsible="true" 
                    title="Right Layout Area" initcollapsed="true"
                    style="background-color:##FF00FF; height:100%" >
                This is text in layout area 4: right<br />
                You can collapse this, but not close it.<br />
                It is initially collapsed.
            </cflayoutarea> --->
        <!---<cflayoutarea position="bottom" size="28" 
                     style="background-color:##EFF8FF; font-size:9px">
                <div align="center">&copy; 2009 Netiquette All Rights Reserved.<br/>Version 3.0 </div>
          </cflayoutarea>---> 
        </cflayout>
    </cflayoutarea>

 <!---    <cflayoutarea style="height:100; ; background-color:##FFCCFF">
        <h3>Change the state of Area 2</h3>
        <cfform>
            <cfinput name="expand2" width="100" value="Expand Area 2" type="button" 
                onClick="ColdFusion.Layout.expandArea('thelayout', 'left');">
            <cfinput name="collapse2" width="100" value="Collapse Area 2" type="button"
                onClick="ColdFusion.Layout.collapseArea('thelayout', 'left');">
            <cfinput name="show2" width="100" value="Show Area 2" type="button" 
                onClick="ColdFusion.Layout.showArea('thelayout', 'left');">
            <cfinput name="hide2" width="100" value="Hide Area 2" type="button" 
                onClick="ColdFusion.Layout.hideArea('thelayout', 'left');">
        </cfform>
    </cflayoutarea> --->
</cflayout> 
   


 <cfwindow x="150" y="20" width="850" height="630" 
        name="myTran" title="Transaction File Maintenance" source="../transaction/transactionFileMaintenance/transaction-main.cfm" 
        initshow="false" resizable="false" refreshOnShow = "true" bodyStyle="font-family: verdana; color: ##ff0000;filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='##C0CFE2', startColorstr='##FFFFFF', gradientType='0');"
        >   
         
  </cfwindow> 
         <form name="uuidVar" id="uuidVar" action="" method="post">
         <input type="hidden" name="uuidVarNo" id="uuidVarNo" value="" />
         </form>
         <cfwindow x="805" y="20" width="450" height="630" 
        name="viewAll" title="View All Transaction" source="/transaction/transactionFileMaintenance/transactionViewAll.cfm?tf_uuid={uuidVar:uuidVarNo}" 
        initshow="false" resizable="false"  refreshOnShow = "true" bodyStyle="font-family: verdana; color: ##ff0000;filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='##C0CFE2', startColorstr='##FFFFFF', gradientType='0');"
        >   
         
         </cfwindow>  
         
<!---          <cfwindow center="true" width="450" height="450" 
        name="startupwarning" title="Urgent Network Circuit Upgrade" source="startup.cfm" 
        initshow="true" resizable="false"  refreshOnShow = "true" modal="true"
        /> --->
         
	<cfquery name="check" datasource="#main#">
		select * from startupwarning
		where (comid='#dts#' or comid='all')
		limit 1
	</cfquery>
	<cfif check.recordcount neq 0 and (check.message neq "" or check.details neq "")>
  <cfinclude template="admin/startup/startupinclude.cfm">
</cfif>

</body>
</html>
<!---
<cfwindow name="showoccasion" draggable="false" center="true" title="Scheduled System Maintenance" height="300" width="500" closable="true" modal="true" resizable="false" initshow="true">
<cfoutput>
Dear Valued Customer/Partners, <br/>
<br/>
Please be advised that Netiquette will be performing a server maintenance, which requires the complete shutdown of the main server system. While the server is offline, AMS, IMS, Payroll and CRM site will not be accessible. 
<br/>
<br/>
Work Starts: 10:00pm Friday, August 12 2011<br/> 
Work Ends: 08:00am Saturday, August 13 2011<br/>
<br/>
Our apologies for any inconvenience this may cause. <br/>
<br/>
Netiquette Service Team 
<br/>
<br/>
<div align="center">
<input type="button" align="middle" value="Close" onclick="ColdFusion.Window.hide('showoccasion');" />
</div>
</cfoutput>
</cfwindow>--->

<cfelse>

<cfajaximport tags="cfform,cftree,cfgrid,cftooltip,cfmenu">
<script src="scripts/trans.js" type="text/javascript"></script>
<!-- <link rel="stylesheet" href="./stylesheet/trans.css"/>-->

<cfinclude template="scripts/trans.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<html>

<head>
<title>Accounting Management System</title>
	<SCRIPT TYPE="text/javascript">
function popup3(PopUpUrl, windowname)
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
    WinPop3=window.open(PopUpUrl,windowname,"width=820,height=620,toolbar=0,location=0,directories=0,status=0,scrollbars=1,menubar=0,resizable=1,  left="+placementx+",top="+placementy+",screenX="+placementx+",screenY="+placementy+","); 
	
}
</script>
<script type="text/javascript">



if (document.getElementById){ 
document.write('<style type="text/css">\n')
document.write('.submenu{display: none;}\n')
document.write('</style>\n')
}

function SwitchMenu(obj){
	if(document.getElementById){
	var el = document.getElementById(obj);
	var ar = document.getElementById("masterdiv").getElementsByTagName("span"); 
		if(el.style.display != "block"){ 
			for (var i=0; i<ar.length; i++){
				if (ar[i].className=="submenu") 
				ar[i].style.display = "none";
			}
			el.style.display = "block";
		}else{
			el.style.display = "none";
		}
	}
}

</script>
</head>
</html>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="shortcut icon"
 href="/ams.ico" />

	
        <cfquery name="check" datasource="#main#">
            select * from startupwarning
            where (comid='#dts#' or comid='all')
            limit 1
        </cfquery>
       
		<cfif check.recordcount neq 0 and (check.message neq "" or check.details neq "") and not isdefined("url.check")>
			<!--- <cfinclude template="admin/startup/startupinclude.cfm"> --->
			<cfinclude template="/admin/startup/startupinclude.cfm">
		
	<cfelse>	

<cfoutput>
<frameset rows="130,*" cols="*" frameborder="no" border="0" framespacing="0">
<frame src="header2.cfm" name="topFrame" scrolling="no"  noresize>
<frameset cols="200,*" frameborder="no" border="0" framespacing="0">
<frame src="/menunew/transactions.cfm" name="leftFrame" scrolling="auto"  noresize>
<frame src="/newBody3.cfm" name="mainFrame">
<frame src="UntitledFrame-1"></frameset>
</frameset><noframes></noframes>
</cfoutput>
	</cfif>


</cfif>
<cftry>
<cfquery name="checklog" datasource="mainams">
select userlogid from userlog where status="Success!" and udatabase='#hcomid#'
</cfquery>
<cfquery name="checkskipwizard" datasource="#dts#">
select skipwizard from gsetup
</cfquery>


<cfif checklog.recordcount lt 5 and checkskipwizard.skipwizard eq ''>
<cflocation url="/setupwizard/wizard1.cfm?type=1">
</cfif>
<cfcatch></cfcatch>
</cftry>