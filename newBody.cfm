
<cfset currentDirectory = expandpath('/Excel_Report/#dts#')>
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
<cfset currentDirectory = expandpath('/Download/#dts#')>
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sliding Panels Sample 2</title>
<script type="text/javascript" src="../scripts/SprySlidingPanels.js"></script>
<script language="javascript" type="text/javascript" src="../scripts/ajax.js"></script>
<link href="stylesheet/SprySlidingPanels.css" rel="stylesheet" type="text/css" />
<link href="stylesheet/samples.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="stylesheet/stylesheet.css"/>
<script language="javascript" type="text/javascript" src="../scripts/SpryEffects.js"></script>
<style type="text/css">
	.demoDiv{
		width: 700px;
		height: 100px;
		overflow: hidden;
	}
	.hiddenElement{
		display:none;
		position: absolute;
		left: 15px;
    	top:  5px; 
		width: 700px;
		height: 100px;
	}
</style>
<script type="text/javascript">
var observer = {};

observer.nextEffect = false;
observer.onPostEffect = function(e){
	if (this.nextEffect)
	{
		var eff = this.nextEffect;
		setTimeout(function(){eff.start();}, 10);
	}

	this.nextEffect = false;
}

function myPanelsSlides(currentPanel)
{
    // The list of all the panels that need sliding
	var panels = ['slide1','slide2','slide3'];
	var opened = -1;

	// Let's check if we have an effect for each of these sliding panels
	if (typeof effects == 'undefined')
		effects = {};

	for (var i=0; i < panels.length; i++)
	{
		if (typeof effects[panels[i]] == 'undefined'){
			effects[panels[i]] = new Spry.Effect.Fade(panels[i], {from: '0%', to: '100%', toggle: true});
			effects[panels[i]].addObserver(observer);
		}
		 
		if (effects[panels[i]].direction == Spry.forwards && currentPanel != panels[i])
			opened = i;

		//prevent too fast clicks on the buttons
		if (effects[panels[i]].direction == Spry.backwards && effects[panels[i]].isRunning)
		{
			observer.nextEffect = effects[currentPanel];
			return;
		}
	}

	if (opened != -1)
	{
		observer.nextEffect = effects[currentPanel];
		effects[panels[opened]].start();
	} 
	else if (effects[currentPanel].direction != Spry.forwards)
	{
		effects[currentPanel].start();
	}
};

</script>
<style type="text/css">
#newsTicker {
	width: 900px;
	border: solid 0px #999999;
	float: left;
	border-left: solid 0px #CCC;
	border-right: solid 0px #999;
	border-top: solid 0px #999;
	border-bottom: solid 0px #CCC;
	background-color: #C0CFE2;
	filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='#FFFFFF', startColorstr='#C0CFE2', gradientType='0');
}
#newsTicker .SlidingPanels {
	width: 900px;
	height: 1000px;
	float: left;
}
#newsTicker .SlidingPanelsContentGroup {
	width: 8000em;
	float: left;
}
#newsTicker .SlidingPanelsContent {
	float: left;
	width: 900px;
	height: 1000px;
}

#newsTicker img {
	float: left;
	margin-right: 4px;
}

#newsTicker .SlidingPanelsContent .content {
	margin: 4px auto;
	float: left;
}
#item1 .content, #item2 .content, #item3 .content {
	border-right: dashed 0px #999999;
	height: 500px;
}
#newsTicker .content {
	height: 580px;
	padding: 0px 4px;
}

#newsTicker p {
	margin: 4px 4px;
}

#newsTicker .prev {
	text-align: left;
	padding: 4px 4px;
	clear: both;
}

#newsTicker .next {
	text-align: right;
	padding: 4px 4px;
	clear: both;
}

.SlidingPanelsAnimating * {
	overflow: visible !important;
}

#newsTicker .navLinks {
	clear: both;
	text-align: center;
	border-top:  solid 1px #CCC;
	padding-top: 4px;
	padding-bottom: 4px;
	border: solid 0px #999;
}
.tabActive {
	DISPLAY: block; WIDTH: 50px; CURSOR: default; POSITION: relative; TOP: 1px; HEIGHT: 46px; outline: none
}
.tab {
	BACKGROUND-POSITION: -100px 50%; DISPLAY: block; WIDTH: 50px; CURSOR: pointer; POSITION: relative; TOP: 1px; HEIGHT: 46px; outline: none
}

</style>
</head>
<body onload="myPanelsSlides('slide1');">
<div align="center" style="background-color: #C0CFE2;
	filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='#FFFFFF', startColorstr='#C0CFE2', gradientType='0');">
	<table border="0" align="center">
		<tr><td>
			<div id="slide1" class="hiddenElement"><div class="demoDiv" >
				<img src="images/body1.png" usemap="#body1" border="0"/>
 				<map name="body1">
	  				<area shape="rect" coords="12,16,145,41"  onclick="myPanelsSlides('slide1');sp.showPanel('item1'); return false;"/>
	  				<area shape="rect" coords="160,19,292,43"  onclick="myPanelsSlides('slide2');sp.showPanel('item2'); return false;">
  	  				<area shape="rect" coords="302,20,433,39"  onclick="myPanelsSlides('slide3');sp.showPanel('item3'); return false;">
	  			</map>
			</div></div>
			<div id="slide2" class="hiddenElement"><div class="demoDiv" >
				<img src="images/body2.png" usemap="#body2" border="0"/>
 				<map name="body2">
	 	 			<area shape="rect" coords="12,16,145,41"  onclick="myPanelsSlides('slide1');sp.showPanel('item1'); return false;"/>
	  				<area shape="rect" coords="160,19,292,43"  onclick="myPanelsSlides('slide2');sp.showPanel('item2'); return false;">
  	  				<area shape="rect" coords="302,20,433,39"  onclick="myPanelsSlides('slide3');sp.showPanel('item3'); return false;">
	  			</map>
			</div></div>
			<div id="slide3" class="hiddenElement"><div class="demoDiv" >
				<img src="images/body3.png" usemap="#body3" border="0"/>
 				<map name="body3">
	  				<area shape="rect" coords="12,16,145,41"  onclick="myPanelsSlides('slide1');sp.showPanel('item1'); return false;"/>
	  				<area shape="rect" coords="160,19,292,43"  onclick="myPanelsSlides('slide2');sp.showPanel('item2'); return false;">
  	 	 			<area shape="rect" coords="302,20,433,39"  onclick="myPanelsSlides('slide3');sp.showPanel('item3'); return false;">
	  			</map>
			</div></div>
		</td></tr>
	</table><br/><br/><br/><br />
	
	<div id="newsTicker" align="center">
		<div id="ticker" class="SlidingPanels" align="left">
			<div class="SlidingPanelsContentGroup">
				<div id="item1" class="SlidingPanelsContent">
					<div class="content">
						<cfquery datasource="main" name="getinfo">
							select * from info order by info_date desc limit 5
						</cfquery>
                    	<table border="0" width="800">
							<cfloop query="getinfo">
								<tr><td align="left"><b><font style="font-style: italic;" ><cfoutput>#getinfo.info_remark#</cfoutput></font></b></td></tr>
								<tr><td align="left"><cfoutput>#dateformat(getinfo.info_date,"dd/mm/yyyy")#</cfoutput>: <cfoutput>#getinfo.info_desp#</cfoutput></td></tr>
								<tr><td align="left"><ht/></td></tr>
							</cfloop>
						</table>
					
						<cfquery name="getlogindetails" datasource="main">
							Select a.userlogid,a.userlogtime,a.uipaddress,a.status from userlog a
							<cfif lcase(HcomID) neq "net_i" and lcase(HcomID) neq "netm_i">
								left join users as b on a.userLogID=b.userID 
							</cfif>
							where a.udatabase = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#"> 
							<cfif lcase(HcomID) neq "net_i" and lcase(HcomID) neq "netm_i">
								and b.userGrpID <> 'super'
							</cfif>
							order by a.userlogtime desc limit 20
						</cfquery>
						<h2>User's Log</h2>
						<hr/>
						<font size="-2">User's log is a security feature to track user's login traffic and status.</font>
						<br/><br/>
						<table align="center" class="data" cellpadding="0" cellspacing="0" border="0" width="600">
							<tr>
								<th width="100"><font size="-4">User ID</font></th>
								<th width="150"><font size="-4">Log In Time</font></th>
								<th ><font size="-4">IP Address</font></th>
								<th width="150"><font size="-4">Status</font></th>
							</tr>
							<cfoutput query="getlogindetails">
							<tr>
								<td><font size="-4">#userlogid#</font></td>
								<td><font size="-4">#userlogtime#</font></td>
								<td><font size="-4">#uipaddress#</font></td>
								<td><font size="-4">#status#</font></td>
							</tr>
							</cfoutput>
						</table>
					
					</div>
				</div>

				<div id="item2" class="SlidingPanelsContent">
					<div class="content">
						<cfquery datasource="#dts#" name="getGeneral">
							select lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION from gsetup
						</cfquery>
						<cfquery datasource="#dts#" name="getFavorite">
							select * from myFavorite
							where created_by = '#Huserid#'
						</cfquery>
						<cfif getFavorite.recordcount eq 0>
							No Favorite. Go <a href="../favorite.cfm?level=1" target="mainFrame"><font color="#0000FF"><u>Add Favorite</u></font></a>
						<cfelse>
							Add More Favorite. Go <a href="../favorite.cfm?level=1" target="mainFrame"><font color="#0000FF"><u>Add Favorite</u></font></a>
						</cfif>
						<br/>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<cfset i =0>
								<cfoutput>
								<cfloop query="getFavorite">
									<cfset i = i+1>
									<cfset menuname=Replace(menu_name,'mCategory',getGeneral.lCATEGORY)>
									<cfset menuname=Replace(menuname,'mGroup',getGeneral.lGROUP)>
									<cfset menuname=Replace(menuname,'mSize',getGeneral.lSIZE)>
									<cfset menuname=Replace(menuname,'mRating',getGeneral.lRATING)>
									<cfset menuname=Replace(menuname,'mMaterial',getGeneral.lMATERIAL)>
									<cfset menuname=Replace(menuname,'mShelf',getGeneral.lMODEL)>
									<cfset menuname=Replace(menuname,'mAgent',getGeneral.lAGENT)>
									<cfset menuname=Replace(menuname,'mEnd User',getGeneral.lDRIVER)>
									<cfset menuname=Replace(menuname,'mLocation',getGeneral.lLOCATION)>
									<td width="200px"><a href="#getFavorite.menu_url#"><img src="images/ims_icon.png" border="0"/>#menuname#</a></td>
					
									<cfif i eq 3 or i eq 6 or i eq 9 or i eq 12 or i eq 15 or i eq 18><tr></cfif>
								</cfloop>
								</cfoutput>
						</table>	
					</div>
				</div>

				<div id="item3" class="SlidingPanelsContent">
					<div class="content">
						<cfquery datasource="main" name="getDashboard">
							select * from dashboard_menu
						</cfquery>
						<table width="100%">
							<tr>
								<td width="50%">
									<table>
										<tr>
											<td>
												<select name="dashboard1" onchange="self.frames['list'].location='chart.cfm?type='+this.value;">
													<option value="">Please Select</option>
													<cfoutput query="getDashboard">
														<option value="#DM_ID#">#DESP#</option>
													</cfoutput>
												</select>
											</td>
										</tr>
										<tr>
											<td>
												<iframe name="list" height="320" width="150%" src="chart.cfm?type=" noresize border="0" scrolling="true"></iframe>
											</td>
										</tr>
									</table>
								</td>
								<td width="50%">
									<table>
										<tr>
											<td>
												<select name="dashboard2" onchange="self.frames['list2'].location='chart.cfm?type='+this.value;">
													<option value="">Please Select</option>
													<cfoutput query="getDashboard">
														<option value="#DM_ID#">#DESP#</option>
													</cfoutput>
												</select>
											</td>
										</tr>
										<tr>
											<td>
												<iframe name="list2" height="320" width="150%" src="chart.cfm?type=" noresize border="0"></iframe>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>		
					</div>				
				</div>
			
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var sp = new Spry.Widget.SlidingPanels("ticker");
</script>
</body>
</html>
