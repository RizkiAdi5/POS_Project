<cfquery name="getgeneral" datasource="#dts#">
	select * from gsetup
</cfquery>

<cfset counter = 4>				<!--- HOME, CONTACT US, HELP, LOGOUT --->
<cfif getpin2.h1000 eq "T">		<!---MAINTENANCE--->
	<cfset counter = counter + 1>
</cfif>
<cfif getpin2.h2000 eq "T">		<!---TRANSACTION--->
	<cfset counter = counter + 1>
</cfif>
<cfif getpin2.h6000 eq "T">
	<cfset counter = counter + 1>	<!---PRINT BILLS--->
</cfif>
<cfif getpin2.h3000 eq "T">		<!---ENQUIRES--->
	<cfset counter = counter + 1>
</cfif>
<cfif getpin2.h4000 eq "T">		<!---REPORT--->
	<cfset counter = counter + 1>
</cfif>
<cfif getpin2.h5000 eq "T">		<!---GENERAL SETUP--->
	<cfset counter = counter + 1>
</cfif>
<cfif lcase(hcomid) eq "ubs_i" or lcase(hcomid) eq "net_i" or lcase(hcomid) eq "imk_i" or lcase(hcomid) eq "netm_i">	<!--- CRM --->
	<cfset counter = counter + 1>
</cfif>
<cfif husergrpid eq "Super">	<!---SUPER MENU--->
	<cfset counter = counter + 1>
</cfif>

<script language="JavaScript">

/***********************************************************************************
*	(c) Ger Versluis 2000 version 5.411 24 December 2001 (updated Jan 31st, 2003 by Dynamic Drive for Opera7)
*	For info write to menus@burmees.nl		          *
*	You may remove all comments for faster loading	          *		
***********************************************************************************/
wwidth=140;hheight=20;hhheight=19;
document.write('<style type="text/css">');
document.write('a {color:black;text-decoration:none;position:absolute;padding-left:10px;width:100%;height:100%;}');
document.write('</style>');

	var NoOffFirstLineMenus=<cfoutput>#counter#</cfoutput>;			// Number of first level items
	var LowBgColor='#F5F1EF';			// Background color when mouse is not over
	var LowSubBgColor='FFFFFF';  		// Background color when mouse is not over on subs
	var HighBgColor='#dedede';			// Background color when mouse is over
	var HighSubBgColor='#F0F0F0';				// Background color when mouse is over on subs
	var FontLowColor='black';			// Font color when mouse is not over
	var FontSubLowColor='black';			// Font color subs when mouse is not over
	var FontHighColor='black';			// Font color when mouse is over
	var FontSubHighColor='#F0F0F0';			// Font color subs when mouse is over
	var BorderColor='#BBB';			// Border color
	var BorderSubColor='#BBB';			// Border color for subs
	var BorderWidth=1;				// Border width
	var BorderBtwnElmnts=2;			// Border between elements 1 or 0
	var FontFamily="Verdana,comic sans ms,technical"	// Font family menu items
	var FontSize=8;				// Font size menu items
	var FontBold=1;				// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered='left';			// Item text position 'left', 'center' or 'right'
	var MenuCentered='right';			// Menu horizontal position 'left', 'center' or 'right'
	var MenuVerticalCentered='top';		// Menu vertical position 'top', 'middle','bottom' or static
	var ChildOverlap=0.02;				// horizontal overlap child/ parent
	var ChildVerticalOverlap=0.1;			// vertical overlap child/ parent
	var StartTop=50;				// Menu offset x coordinate
	var StartLeft=5;				// Menu offset y coordinate
	var VerCorrect=0;				// Multiple frames y correction
	var HorCorrect=0;				// Multiple frames x correction
	var LeftPaddng=3;				// Left padding
	var TopPaddng=2;				// Top padding
	var FirstLineHorizontal=1;			// SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
	var MenuFramesVertical=1;			// Frames in cols or rows 1 or 0
	var DissapearDelay=500;			// delay before menu folds in
	var TakeOverBgColor=1;			// Menu frame takes over background color subitem frame
	var FirstLineFrame='navig';			// Frame where first level appears
	var SecLineFrame='space';			// Frame where sub levels appear
	var DocTargetFrame='space';			// Frame where target documents appear
	var TargetLoc='';				// span id for relative positioning
	var HideTop=0;				// Hide first level when loading new document 1 or 0
	var MenuWrap=1;				// enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
	var UnfoldsOnClick=0;			// Level 1 unfolds onclick/ onmouseover
	var WebMasterCheck=0;			// menu tree checking on or off 1 or 0
	var ShowArrow=1;				// Uses arrow gifs when 1
	var KeepHilite=1;				// Keep selected path highligthed
	var Arrws=['../images/menubar/tri.gif',5,10,'../images/menubar/tridown.gif',10,5,'../images/menubar/trileft.gif',5,10];	// Arrow source, width and height
	
	
	function BeforeStart(){return}
	function AfterBuild(){return}
	function BeforeFirstOpen(){return}
	function AfterCloseAll(){return}

	//Menu tree
	//MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
	//For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"

	<cfset menucount = 0>
	<cfset menucount = menucount + 1>
	Menu<cfoutput>#menucount#</cfoutput>=new Array(
			"<a href='../newBody.cfm' target='mainFrame'>Home</a>",	// ElementText
			"",		// ElementLink
			"../dropdownmenu/bgmenu.PNG",		// ElementBgImage
			0,		// ElementNoOfSubElements
			hhheight,		// ElementHeight
			wwidth-80,		// ElementWidth
			"",	// ElementBgColor
			"",	// ElementBgHighColor
			"",	// ElementFontColor
			"",	// ElementFontHighColor
			"",	// ElementBorderColor
			"",		// ElementFontFamily
			-1,		// ElementFontSize in pixel
			-1,		// ElementBold
			1,		// ElementItalic
			"left",		// ElementTextAlign
			"test");		// ElementStatusText
	//1.Maintenance
	<cfif getpin2.h1000 eq "T">
		//var count = count + 1;
		<cfset menucount = menucount + 1>
		
		<cfset counter_m = 0>			<!--- Business Profile --->
		<cfif getpin2.h1200 eq "T">		<!--- Customer Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1100 eq "T">		<!--- Supplier Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>

		<cfif getpin2.h1300 eq "T">		<!--- Product Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1400 eq "T">		<!--- Category Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1500 eq "T">		<!--- Group Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1600 eq "T">		<!--- Size Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1700 eq "T">		<!--- Rating Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1800 eq "T">		<!--- Material Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1900 eq "T">		<!--- Shelf Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		 <cfif getpin2.h1P00 eq "T">	<!--- Brand Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		
			<cfif getpin2.h1L00 eq "T">		<!--- Color - Size Maintenance --->
			<cfset counter_m = counter_m + 1>
		</cfif>
	 
		<cfif getpin2.h1N00 eq "T">		<!--- Title Maintenance --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1M00 eq "T">		<!--- Matrix Item Maintenance --->
			<cfset counter_m = counter_m + 1>
		</cfif>
					<cfif getpin2.h1Q00 eq "T">		<!--- Vehicles Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1R00 eq "T">		<!--- vouche Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		
	

		
		
		<!---
		  <cfif getpin2.h1B00 eq "T">		<!--- Agent Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1D00 eq "T">		<!--- Area Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1J00 eq "T">		<!--- Bill of Material --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1E00 eq "T">		<!--- Comment Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1C00 eq "T">		<!--- End User Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1O00 eq "T">		<!--- Symbol Maintenance --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1D00 eq "T">		<!--- Location Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1H00 eq "T">		<!--- Project Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1H00 eq "T">		<!--- Job Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		
		<cfif getpin2.h1G00 eq "T">		<!--- Service Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		<cfif getpin2.h1I00 eq "T">		<!--- Term Profile --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		
		<cfif getpin2.h1A00 eq "T">		<!--- Unit of Measurement --->
			<cfset counter_m = counter_m + 1>
		</cfif>
		
		<cfif getpin2.h1K00 eq "T">		<!--- Opening Qty Maintenance --->
			<cfset counter_m = counter_m + 1>
		</cfif>--->
		
	
		
		
		<cfswitch expression="#lcase(hcomid)#">
			<cfcase value="tmt_i|taff_i|taftc_i" delimiters="|">
				<cfif getpin2.hc016 eq "T">		<!--- Commission Profile --->
					<cfset counter_m = counter_m + 1>
				</cfif>
			</cfcase>
			<cfcase value="fincom_i">
				<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">		<!--- Special Item Price Profile --->
					<cfset counter_m = counter_m + 1>
				</cfif>
			</cfcase>
			<cfcase value="pnp_i">
				<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">		<!--- 1.User Id Location Profile 2.Others Transaction Setting 3.Special Setting --->
					<cfset counter_m = counter_m + 3>
				</cfif>
			</cfcase>
			<cfcase value="net_i">
				<cfset counter_m = counter_m + 2>							<!--- 1.CSO Profile 2.Service Type Profile --->
			</cfcase>	
			<cfcase value="netm_i">
				<cfset counter_m = counter_m + 2>							<!--- 1.CSO Profile 2.Service Type Profile --->
			</cfcase>
			<cfcase value="ideal_i|idealb_i" delimiters="|">
				<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">		<!--- Discount Profile --->
					<cfset counter_m = counter_m + 1>
				</cfif>			
			</cfcase>		
		</cfswitch>
		
		Menu<cfoutput>#menucount#</cfoutput>=new Array(
			"<a href=''>Maintenance</a>",	// ElementText
			"",		// ElementLink
			"../dropdownmenu/bgmenu.PNG",		// ElementBgImage
			<cfoutput>#counter_m#</cfoutput>,		// ElementNoOfSubElements
			hhheight,		// ElementHeight
			wwidth-40,		// ElementWidth
			"",	// ElementBgColor
			"",	// ElementBgHighColor
			"",	// ElementFontColor
			"",	// ElementFontHighColor
			"",	// ElementBorderColor
			"",		// ElementFontFamily
			-1,		// ElementFontSize in pixel
			-1,		// ElementBold
			1,		// ElementItalic
			"left",		// ElementTextAlign
			"test");		// ElementStatusText
		<cfset menucount_m = 0>
		<cfif getpin2.h1200 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/linkPage.cfm?type=Customer' target='mainFrame'>Customer Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1100 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/linkPage.cfm?type=Supplier' target='mainFrame'>Supplier Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1300 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/s_icitem.cfm?type=icitem' target='mainFrame'>Product Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>

		<cfif getpin2.h1400 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/categorytable.cfm' target='mainFrame'><cfoutput>#getgeneral.lcategory#</cfoutput> Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
	
		<cfif getpin2.h1500 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/grouptable.cfm' target='mainFrame'><cfoutput>#getgeneral.lgroup#</cfoutput> Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>		
		
		<cfif getpin2.h1600 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/sizeidtable.cfm' target='mainFrame'><cfoutput>#getgeneral.lsize#</cfoutput> Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");		
		</cfif>
		
		<cfif getpin2.h1700 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/costcodetable.cfm' target='mainFrame'><cfoutput>#getgeneral.lrating#</cfoutput> Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");		
		</cfif>
		
		<cfif getpin2.h1800 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/coloridtable.cfm' target='mainFrame'><cfoutput>#getgeneral.lMaterial#</cfoutput> Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");		
		</cfif>
		
		<cfif getpin2.h1900 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/shelftable.cfm' target='mainFrame'><cfoutput>#getgeneral.lModel#</cfoutput> Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1P00 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/brandtable.cfm' target='mainFrame'>Brand Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		<cfif getpin2.h1Q00 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/vehicles/vehicles.cfm' target='mainFrame'>Vehicles Maintenance</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1R00 eq "T">
			<cfset menucount_m = menucount_m + 1>
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/voucher/voucher.cfm' target='mainFrame'>Voucher Maintenance</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		<cfif getpin2.h1M00 eq "T">
			<cfset menucount_m = menucount_m + 1>
			
			<cfset counter_m_o = 0>	
			<cfif getpin2.h1F00 eq "T">		<!--- Address Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	
	<cfif getpin2.h1B00 eq "T">		<!--- Agent Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	
	<cfif getpin2.h1D00 eq "T">		<!--- Area Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	
	<cfif getpin2.h1J00 eq "T">		<!--- Bill of Material --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	
	<cfif getpin2.h1M10 eq "T">	<!--- Edit Item Opening Quantity/Cost --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	
	<cfif getpin2.h1E00 eq "T">		<!--- Comment Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	

	<cfif getpin2.h1C00 eq "T">		<!--- End User Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	<cfif getpin2.h1D00 eq "T">		<!--- Location Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	<cfif getpin2.h1H00 eq "T">		<!--- Project Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	<cfif getpin2.h1H00 eq "T">		<!--- Job Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	<cfif getpin2.h1G00 eq "T">		<!--- Service Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	<cfif getpin2.h1I00 eq "T">		<!--- Term Profile --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
	<cfif getpin2.h1A00 eq "T">		<!--- Unit of Measurement --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
<!--- <cfif getpin2.h1M10 eq "T">	<!--- Edit Item Opening Quantity/Cost --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif> --->
	
	
	
	

	
	
	
	
	Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a>Bill Header Item</a>","","",<cfoutput>#counter_m_o#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
	
			<cfset menucount_m_o = 0>
			
			
			
			<cfif getpin2.h1F00 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/addresstable.cfm' target='mainFrame'>Address Profile</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1B00 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/agenttable.cfm' target='mainFrame'>Agent Profile</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1D00 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/areatable.cfm' target='mainFrame'>Area Profile</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1J00 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/bom.cfm' target='mainFrame'>Bill of Material</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1M10 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/businesstable.cfm' target='mainFrame'>Business Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1E00 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/commenttable.cfm' target='mainFrame'>Comment Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1C00 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/vdriver.cfm' target='mainFrame'>End User Profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1D00 eq "T">		<!--- Location Profile --->
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/locationtable.cfm' target='mainFrame'>Location profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1H00 eq "T">		<!--- Project Profile --->
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/Projecttable.cfm' target='mainFrame'>Project profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		<cfif getpin2.h1H00 eq "T">		<!--- Job Profile --->
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/JOB/Projecttable.cfm' target='mainFrame'>Job profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1G00 eq "T">		<!--- Service Profile --->
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/servicetable.cfm' target='mainFrame'>Service profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h1I00 eq "T">		<!--- Term Profile --->
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/termtable.cfm' target='mainFrame'>Term profile</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		<cfif getpin2.h1A00 eq "T">		<!--- Unit of Measurement --->
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/unittable.cfm' target='mainFrame'>Unit Of Measurement </a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
				</cfif>
				
		
			<!---  <cfif getpin2.h1M20 eq "T">
			<cfset menucount_m_o = menucount_m_o + 1>
			Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a>Opening Qty Maintenance</a>","","",0,hheight+20,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			
			 Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/fifoopq.cfm? target='mainFrame'>Edit Item Opening Quantity/Cost</a>","","",0,hheight+20,wwidth+25,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>_1_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/batch.cfm?modeaction=no' target='mainFrame'>Edit Batch Opening Quantity</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"",""); 
				
				
				--->
				
				
				
				
	<!---  	</cfif>--->
		</cfif>

		
	
	
	
	
	
	
	
	
	
	
	
	
	
		
		
		
		<cfif getpin2.h1K00 eq "T">
			<cfset menucount_m = menucount_m + 1>
			
			<cfset counter_m_o = 0>	
			<cfif getpin2.h1K10 eq "T">	<!--- Edit Item Opening Quantity/Cost --->
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
			<cfif getpin2.h1K20 eq "T">	<!--- Edit Batch Opening Quantity --->
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
			<cfif getpin2.h1K30 eq "T">	<!--- Edit Location Opening Quantity --->
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
			<cfif getpin2.h1K40 eq "T">	<!--- Edit Location - Item Batch Opening Quantity --->
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
			<cfif getpin2.h1K50 eq "T">	<!--- Edit Serial No. Opening Quantity --->
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
			<cfif getpin2.h1K60 eq "T">	<!--- Edit Item - Grade Opening Quantity  --->
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
			<cfif getpin2.h1K70 eq "T">	<!--- Enquiry Opening Value --->
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a>Opening Qty Maintenance</a>","","",0<cfoutput>#counter_m_o#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
	
			<cfset menucount_m_o = 0>
			<cfif getpin2.h1K10 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/fifoopq.cfm? target='mainFrame'>Edit Item Opening Quantity/Cost</a>","","",0,hheight+20,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1K20 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/batch.cfm?modeaction=no' target='mainFrame'>Edit Batch Opening Quantity</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1K30 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/location_opening_qty_maintenance.cfm?modeaction=no' target='mainFrame'>Edit Location Opening Quantity</a>","","",0,hheight+20,wwidth+20,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1K40 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/locationbatch.cfm?modeaction=no' target='mainFrame'>Edit Location - Item Batch Opening Quantity</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1K50 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/serialno_opening_qty_maintenance.cfm' target='mainFrame'>Edit Serial No. Opening Quantity</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1K60 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/grade_opening_qty_maintenance.cfm' target='mainFrame'>Edit Item - Grade Opening Quantity</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1K70 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/openqtymaintenance/s_opvalue.cfm' target='mainFrame'>Enquiry Opening Value</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				
			</cfif>
			

			</cfif>
		
		
		
		
		
		
		
		<cfif getpin2.h1L00 eq "T">
			<cfset menucount_m = menucount_m + 1>
			
			<cfset counter_m_o = 0>	
			<cfif getpin2.h1L10 eq "T">	
				<cfset counter_m_o = counter_m_o + 1>
    		</cfif>
			<cfif getpin2.h1L20 eq "T">	
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
			<cfif getpin2.h1L30 eq "T">	
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
			<cfif getpin2.h1L30 eq "T">	
				<cfset counter_m_o = counter_m_o + 1>
			</cfif>
		
		
		Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a>MISC</a>","","",0<cfoutput>#counter_m_o#</cfoutput>,hheight,wwidth+20,"","","","","","",-1,0,-1,"","");
	
			<cfset menucount_m_o = 0>
			<cfif getpin2.h1L10 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/s_colorsizetable.cfm' target='mainFrame'>Color - Size Maintenance</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1L20 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/s_matrixitemtable.cfm' target='mainFrame'>Matrix Item Maintenance</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1L30 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/s_titletable.cfm' target='mainFrame'>Title Maintenance</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h1L30 eq "T">
				<cfset menucount_m_o = menucount_m_o + 1>
				Menu<cfoutput>#menucount#_#menucount_m#_#menucount_m_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/maintenance/symbol/symbolMaintenance.cfm' target='mainFrame'>Symbol Maintenance</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			</cfif>
			</cfif>
			
			
			
			
			
		
		<cfswitch expression="#lcase(hcomid)#">
			<cfcase value="tmt_i|taff_i|taftc_i" delimiters="|">
				<cfif getpin2.hc016 eq "T">	
					<cfset menucount_m = menucount_m + 1>
					Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='../tmt/commission_menu.cfm' target='mainFrame'>Commission Profile</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
			</cfcase>
			<cfcase value="fincom_i">
				<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">
					<cfset menucount_m = menucount_m + 1>
					Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='../fincom/special_item_price.cfm' target='mainFrame'>Special Item Price Profile</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
			</cfcase>
			<cfcase value="pnp_i">
				<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">
					<cfset menucount_m = menucount_m + 1>
					Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='../pnp/userid_location_profile.cfm' target='mainFrame'>User Id Location Profile</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_m = menucount_m + 1>
					Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='../pnp/others_transaction_setting.cfm' target='mainFrame'>Others Transaction Setting</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_m = menucount_m + 1>
					Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='../pnp/special_setting.cfm' target='mainFrame'>Special Setting</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
			</cfcase>
			<cfcase value="net_i|netm_i" delimiters="|">
				<cfset menucount_m = menucount_m + 1>
				Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/customized/<cfoutput>#lcase(hcomid)#</cfoutput>/maintenance/s_cso.cfm' target='mainFrame'>CSO Profile</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				
				<cfset menucount_m = menucount_m + 1>
				Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/customized/<cfoutput>#lcase(hcomid)#</cfoutput>/maintenance/s_servicetype.cfm' target='mainFrame'>Service Type Profile</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");		
			</cfcase>	
			<cfcase value="ideal_i|idealb_i" delimiters="|">
				<cfif HUserGrpID eq "super" or HUserGrpID eq "admin">		<!--- Discount Profile --->
					<cfset menucount_m = menucount_m + 1>
					Menu<cfoutput>#menucount#_#menucount_m#</cfoutput>=new Array("<a href='/customized/ideal_i/maintenance/s_discount.cfm' target='mainFrame'>Discount Profile</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>			
			</cfcase>	
		</cfswitch>
	</cfif>
	
	//2.Transactions
	<cfif getpin2.h2000 eq "T">
		<cfset menucount = menucount + 1>
		
		<cfset counter_t = 0>
		<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">	<!--- Modified on 29-12-2009 --->
			<cfif getpin2.h2860 eq "T">		<!--- Purchase Order --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2100 eq "T">		<!--- Purchase Receive --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2870 eq "T">		<!--- Quotation --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2880 eq "T">		<!--- Sales Order --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2300 eq "T">		<!--- Delivery Order --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2400 eq "T">		<!--- Invoice --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2500 eq "T">		<!--- Cash Sales --->
				<cfset counter_t = counter_t + 1>
			</cfif>
		<cfelse>
			<cfif getpin2.h2100 eq "T">		<!--- Purchase Receive --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2200 eq "T">		<!--- Purchase Return --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2300 eq "T">		<!--- Delivery Order --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2400 eq "T">		<!--- Invoice --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2500 eq "T">		<!--- Cash Sales --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2600 eq "T">		<!--- Credit Note --->
				<cfset counter_t = counter_t + 1>
			</cfif>	
			<cfif getpin2.h2700 eq "T">		<!--- Debit Note --->
				<cfset counter_t = counter_t + 1>
			</cfif>
			<cfif getpin2.h2700 eq "T">		<!--- Packing List --->
				<cfset counter_t = counter_t + 1>
			</cfif>
		</cfif>
		<cfif getpin2.h2800 eq "T">		<!--- Other Transaction --->
			<cfset counter_t = counter_t + 1>
		</cfif>

		<cfif getpin2.h2900 eq "T">		<!--- Generate/Update --->
			<cfset counter_t = counter_t + 1>
		</cfif>
		<cfif getpin2.h2A00 eq "T">		<!--- E-Invoicing --->
			<cfset counter_t = counter_t + 1>
		</cfif>
		
		<cfswitch expression="#lcase(hcomid)#">
			<cfcase value="fdipx_i">		<!--- Printing Job Order --->
				<cfset counter_t = counter_t + 1>
			</cfcase>
			<cfcase value="imk_i">		<!--- Collection Note --->
				<cfset counter_t = counter_t + 1>
			</cfcase>
			<cfcase value="solidlogic_i">		<!--- Rebate Function --->
				<cfset counter_t = counter_t + 1>
			</cfcase>
		</cfswitch>
		
		Menu<cfoutput>#menucount#</cfoutput>=new Array("<a href=''>Transactions</a>","","../dropdownmenu/bgmenu.PNG",<cfoutput>#counter_t#</cfoutput>,hhheight,wwidth-40,"","","","","","",-1,-1,-1,"","");
		
		<cfset menucount_t = 0>
		<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">	<!--- Modified on 29-12-2009 --->
			<cfif getpin2.h2860 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=po' target='mainFrame'>Purchase Order</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2100 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=rc' target='mainFrame'>Purchase Receive</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2870 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=quo' target='mainFrame'>Quotation</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2880 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=so' target='mainFrame'>Sales Order</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2300 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=do' target='mainFrame'>Delivery Order</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2400 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=inv' target='mainFrame'>Invoice</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2500 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=cs' target='mainFrame'>Cash Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
		<cfelse>
			<cfif getpin2.h2100 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=rc' target='mainFrame'>Purchase Receive</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2200 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=pr' target='mainFrame'>Purchase Return</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2300 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=do' target='mainFrame'>Delivery Order</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2400 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=inv' target='mainFrame'>Invoice</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2500 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=cs' target='mainFrame'>Cash Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2600 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=cn' target='mainFrame'>Credit Note</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2700 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=dn' target='mainFrame'>Debit Note</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			<cfif getpin2.h2700 eq "T">
				<cfset menucount_t = menucount_t + 1>
				Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/default/transaction/packinglist/listPackingMain.cfm' target='mainFrame'>Packing List</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		<cfif getpin2.h2800 eq "T">
			<cfset menucount_t = menucount_t + 1>
			
			<cfset counter_t_o = 2>			<!--- NON ACCOUNTING TRANSACTION, GENERATE UPDATE TRANSACTION --->
			<cfif getpin2.h2810 eq 'T'>		<!--- Item Assembly --->
				<cfset counter_t_o = counter_t_o + 1>	
			</cfif>
    		<cfif getpin2.h2820 eq 'T'>		<!--- Issue --->
				<cfset counter_t_o = counter_t_o + 1>	
			</cfif>
    		<cfif getpin2.h2830 eq 'T'>		<!--- Adj.Increase --->
				<cfset counter_t_o = counter_t_o + 1>	
			</cfif>
    		<cfif getpin2.h2840 eq 'T'>		<!--- Adj. Reduce --->
				<cfset counter_t_o = counter_t_o + 1>	
			</cfif>
			
			<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">	<!--- Modified on 29-12-2009 --->
				<cfif getpin2.h2840 eq 'T'>		<!--- Purchase Return --->
					<cfset counter_t_o = counter_t_o + 1>	
				</cfif>
				
				<cfif getpin2.h2600 eq 'T'>		<!--- Credit Note --->
					<cfset counter_t_o = counter_t_o + 1>	
				</cfif>
				
				<cfif getpin2.h2700 eq 'T'>		<!--- Debit Note --->
					<cfset counter_t_o = counter_t_o + 1>	
				</cfif>
			</cfif>
			
			<cfif getpin2.h28B0 eq 'T'>		<!--- Historical Records --->
				<cfset counter_t_o = counter_t_o + 1>	
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a>Other Transaction</a>","","",<cfoutput>#counter_t_o#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_t_o = 0>	
			<cfif getpin2.h2810 eq 'T'>
				<cfquery datasource="#dts#" name="getGeneralInfo">
					Select assm_oneset
					from GSetup
				</cfquery>
				<cfset menucount_t_o = menucount_t_o + 1>
				<cfif getGeneralInfo.assm_oneset neq '1'>
					Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/assm0.cfm' target='mainFrame'>Item Assembly</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				<cfelse>
					Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/assm1.cfm' target='mainFrame'>Item Assembly</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
			</cfif>
			
			<cfif getpin2.h2820 eq 'T'>
				<cfset menucount_t_o = menucount_t_o + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/iss.cfm?tran=ISS' target='mainFrame'>Issue</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2830 eq 'T'>
				<cfset menucount_t_o = menucount_t_o + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/iss.cfm?tran=OAI' target='mainFrame'>Adj.Increase</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2840 eq 'T'>
				<cfset menucount_t_o = menucount_t_o + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/iss.cfm?tran=OAR' target='mainFrame'>Adj. Reduce</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">	<!--- Modified on 29-12-2009 --->
				<cfif getpin2.h2840 eq 'T'>		<!--- Purchase Return --->
					<cfset menucount_t_o = menucount_t_o + 1>
					Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=pr' target='mainFrame'>Purchase Return</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
				
				<cfif getpin2.h2600 eq 'T'>		<!--- Credit Note --->
					<cfset menucount_t_o = menucount_t_o + 1>
					Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=cn' target='mainFrame'>Credit Note</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
				
				<cfif getpin2.h2700 eq 'T'>		<!--- Debit Note --->
					<cfset menucount_t_o = menucount_t_o + 1>
					Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=dn' target='mainFrame'>Debit Note</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
			</cfif>
			
			<cfif getpin2.h28B0 eq 'T'>
				<cfset menucount_t_o = menucount_t_o + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a>Historical Records</a>","","",3,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/historicalrecords/historicalform.cfm?historical=ViewBatchSummary' target='mainFrame'>View Batch Summary</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");
		
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/historicalrecords/historicalform.cfm?historical=ListHistoricalBills' target='mainFrame'>List Historical Bills</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>_3=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/historicalrecords/historicalform.cfm?historical=ListHistoricalPrice' target='mainFrame'>List Historical Price</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<!--- TRANSACTION/OTHER TRANSACTION/NON ACCOUNTING TRANSACTION --->
			<cfset menucount_t_o = menucount_t_o + 1>
			<cfset counter_t_o_n = 0>	
			
			<cfif lcase(HcomID) neq "ideal_i" and lcase(HcomID) neq "idealb_i">	<!--- Modified on 29-12-2009 --->
				<cfif getpin2.h2860 eq 'T'>		<!--- Purchase Order --->
					<cfset counter_t_o_n = counter_t_o_n + 1>
				</cfif>
	    		<cfif getpin2.h2870 eq 'T'>		<!--- Quotation --->
					<cfset counter_t_o_n = counter_t_o_n + 1>
				</cfif>
	    		<cfif getpin2.h2880 eq 'T'>		<!--- Sales Order --->
					<cfset counter_t_o_n = counter_t_o_n + 1>
				</cfif>	  
			</cfif>
    		<cfif getpin2.h2850 eq 'T'>		<!--- Sample --->
				<cfset counter_t_o_n = counter_t_o_n + 1>
			</cfif>
			<cfif getpin2.h28C0 eq 'T'>		<!--- Write Off Purchase Order --->
				<cfset counter_t_o_n = counter_t_o_n + 1>
			</cfif>
			<cfif getpin2.h28D0 eq 'T'>		<!--- Write Off Sales Order --->
				<cfset counter_t_o_n = counter_t_o_n + 1>
			</cfif>
			<cfif getpin2.h28B0 eq 'T'>		<!--- Historical Records --->
				<cfset counter_t_o_n = counter_t_o_n + 1>	
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a>Non-Accounting Transaction</a>","","",<cfoutput>#counter_t_o_n#</cfoutput>,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_t_o_n = 0>
			
			<cfif lcase(HcomID) neq "ideal_i" and lcase(HcomID) neq "idealb_i">	<!--- Modified on 29-12-2009 --->
				<cfif getpin2.h2860 eq 'T'>
					<cfset menucount_t_o_n = menucount_t_o_n + 1>
					Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=po' target='mainFrame'>Purchase Order</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
				
				<cfif getpin2.h2870 eq 'T'>
					<cfset menucount_t_o_n = menucount_t_o_n + 1>
					Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=quo' target='mainFrame'>Quotation</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
				
				<cfif getpin2.h2880 eq 'T'>
					<cfset menucount_t_o_n = menucount_t_o_n + 1>
					Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=so' target='mainFrame'>Sales Order</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif>
			</cfif>
			
			<cfif getpin2.h2850 eq 'T'>
				<cfset menucount_t_o_n = menucount_t_o_n + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/transaction.cfm?tran=sam' target='mainFrame'>Sample</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h28C0 eq 'T'>
				<cfset menucount_t_o_n = menucount_t_o_n + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/writeoff.cfm?tran=po' target='mainFrame'>Write Off Purchase Order</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h28D0 eq 'T'>
				<cfset menucount_t_o_n = menucount_t_o_n + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/writeoff.cfm?tran=so' target='mainFrame'>Write Off Sales Order</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h28B0 eq 'T'>
				<cfset menucount_t_o_n = menucount_t_o_n + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>=new Array("<a>Historical Records</a>","","",2,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/historicalrecords/historicalrecords.cfm?historical=ListHistoricalBillsOrder' target='mainFrame'>List Historical Bills Order</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
		
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_n#</cfoutput>_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/historicalrecords/historicalrecords.cfm?historical=ListHistoricalItemsOrder' target='mainFrame'>List Historical Items Order</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<!--- TRANSACTION/OTHER TRANSACTION/GENERATE UPDATE TRANSACTION --->
			<cfset menucount_t_o = menucount_t_o + 1>
			<cfset counter_t_o_g = 0>
			<cfif getpin2.h2890 eq 'T'>		<!--- Copy  Bill --->
				<cfset counter_t_o_g = counter_t_o_g + 1>
			</cfif>
			<cfif getpin2.h28A0 eq 'T'>		<!--- Transfer --->
				<cfset counter_t_o_g = counter_t_o_g + 1>
			</cfif>
			<cfif lcase(HcomID) eq "glenn_i" and variables.HUserGrpID eq "super">		<!--- Change Item No --->
				<cfset counter_t_o_g = counter_t_o_g + 1>
			</cfif>
			Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#</cfoutput>=new Array("<a>Generate/Update Transaction</a>","","",<cfoutput>#counter_t_o_g#</cfoutput>,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_t_o_g = 0>
			<cfif getpin2.h2890 eq 'T'>
				<cfset menucount_t_o_g = menucount_t_o_g + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/copy.cfm' target='mainFrame'>Copy Bill</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h28A0 eq 'T'>
				<cfset menucount_t_o_g = menucount_t_o_g + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/iss.cfm?tran=TR' target='mainFrame'>Transfer</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif lcase(HcomID) eq "glenn_i" and variables.HUserGrpID eq "super">
				<cfset menucount_t_o_g = menucount_t_o_g + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_o#_#menucount_t_o_g#</cfoutput>=new Array("<a href='../report/glenn/fchangeItemno.cfm' target='mainFrame'>Change Item No</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		<cfif getpin2.h2900 eq "T">
			<cfset menucount_t = menucount_t + 1>
			
			<cfset counter_t_g = 0>
			<cfif getpin2.h2901 eq 'T'>		<!--- Distribute Miscellaneous Charges Into Cost --->
				<cfset counter_t_g = counter_t_g + 1>
			</cfif>
			<cfif getpin2.h2902 eq 'T'>		<!--- Generate Full Payment Date --->
				<cfset counter_t_g = counter_t_g + 1>
			</cfif>
			<cfif getpin2.h2903 eq 'T'>		<!--- Generate Customer Outstanding Balance --->
				<cfset counter_t_g = counter_t_g + 1>
			</cfif>
			Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a>Generate/Update</a>","","",<cfoutput>#counter_t_g#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_t_g = 0>
			<cfif getpin2.h2901 eq 'T'>
				<cfset menucount_t_g = menucount_t_g + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/generateupdate/distribute_miscellaneous_charges_into_cost.cfm' target='mainFrame'>Distribute Miscellaneous Charges Into Cost</a>","","",0,hheight+20,wwidth+31,"","","","","","",-1,0,-1,"","");
			</cfif>
				
			<cfif getpin2.h2902 eq 'T'>	
				<cfset menucount_t_g = menucount_t_g + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/generateupdate/generate_full_payment_date.cfm' target='_blank'>Generate Full Payment Date</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h2903 eq 'T'>
				<cfset menucount_t_g = menucount_t_g + 1>
				Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/transaction/generateupdate/generate_customer_outstanding_balance.cfm' target='_blank'>Generate Customer Outstanding Balance</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		<cfif getpin2.h2A00 eq "T">
			<cfset menucount_t = menucount_t + 1>
			<cfset counter_t_g = 0>		<!--- E-Invoicing Submission --->
			<cfset counter_t_g = counter_t_g + 1>		<!--- E-Invoicing Log --->
			<cfset counter_t_g = counter_t_g + 1>
			Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a>E-Invoicing</a>","","",<cfoutput>#counter_t_g#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_t_g = 0>
			<cfset menucount_t_g = menucount_t_g + 1>
			Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/eInvoicing/eInvoice.cfm' target='mainFrame'>E-Invoicing Submission</a>","","",0,hheight,wwidth+31,"","","","","","",-1,0,-1,"","");
				
			<cfset menucount_t_g = menucount_t_g + 1>
			Menu<cfoutput>#menucount#_#menucount_t#_#menucount_t_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/eInvoicing/eInvoicelog.cfm' target='mainFrame'>E-Invoice Log</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			
		</cfif>
		
		<cfif lcase(HcomID) eq "solidlogic_i">
			<cfset menucount_t = menucount_t + 1>
			Menu<cfoutput>#menucount#_#menucount_t#</cfoutput>=new Array("<a href='/customized/solidlogic_i/rebatefunction.cfm' target='mainFrame'>Rebate Function</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		</cfif>

</cfif>

	//3.Print Bills
	 
	<cfif getpin2.h6000 eq "T">
	<cfset menucount = menucount + 1>
	
	<cfquery name="get_company_id" datasource="main">
		select 
		(lcase(left(company_id,char_length(company_id)-2))) as company_id
		from customize_print_bills
		where company_id='#jsstringformat(preservesinglequotes(hcomid))#'
		order by company_id;
	</cfquery>
	<cfset counter_p = 18>
	<cfif get_company_id.recordcount eq 1>		<!--- Customized Print Bills --->
		<cfset counter_p = counter_p + 1>
	</cfif>
	
	Menu<cfoutput>#menucount#</cfoutput>=new Array("<a>Print Bills</a>","","../dropdownmenu/bgmenu.PNG",<cfoutput>#counter_p#</cfoutput>,hhheight,wwidth-50,"","","","","","",-1,-1,-1,"","");

	<cfset menucount_p = 0>
	
	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=INV&name=Invoice' target='mainFrame'>Invoice</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=CS&name=Cash Bills' target='mainFrame'>Cash Bills</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=CN&name=Credit Note' target='mainFrame'>Credit Note</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=DN&name=Debit Note' target='mainFrame'>Debit Note</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=RC&name=Receive' target='mainFrame'>Receive</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=PR&name=Purchase Return' target='mainFrame'>Purchase Return</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=DO&name=Delivery Order' target='mainFrame'>Delivery Order</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=DO&name=Packing List' target='mainFrame'>Packing List</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=PO&name=Purchase Order' target='mainFrame'>Purchase Order</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=SO&name=Sales Order' target='mainFrame'>Sales Order</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=QUO&name=Quotation' target='mainFrame'>Quotation</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=ISS&name=Issue' target='mainFrame'>Issue</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=OAI&name=Adjustment Increase' target='mainFrame'>Adjustment Increase</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=OAR&name=Adjustment Reduce' target='mainFrame'>Adjustment Reduce</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=TR&name=Transfer Note' target='mainFrame'>Transfer Note</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=TR&name=Transfer Note 2' target='mainFrame'>Transfer Note 2</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=TR&name=Consignment Note' target='mainFrame'>Consignment Note</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");

	<cfset menucount_p = menucount_p + 1>
	Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../default/print_bills/generate_print_bills.cfm?type=TR&name=Consignment Return' target='mainFrame'>Consignment Return</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");
	
	<cfif get_company_id.recordcount eq 1>		
		<cfset menucount_p = menucount_p + 1>
		Menu<cfoutput>#menucount#_#menucount_p#</cfoutput>=new Array("<a href='../billformat/#dts#/print_bills_special/sub_menu.cfm' target='mainFrame'>Customized Print Bills</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");
	</cfif>
	</cfif>
	//4.Enquires
	<cfif getpin2.h3000 eq "T">
		<cfset menucount = menucount + 1>
		
		<cfset counter_e = 0>
		<cfif husergrpid eq "admin" or husergrpid eq "super">		<!--- Bill Summary Report --->
			<cfset counter_e = counter_e + 1>
		</cfif>
		<cfif getpin2.h3500 eq "T">		<!--- History Price Enquiry --->
			<cfset counter_e = counter_e + 1>
		</cfif>
		<cfif getpin2.h3400 eq "T">		<!--- Inventory Forcast --->
			<cfset counter_e = counter_e + 1>
		</cfif>
		<cfif getpin2.h3200 eq "T">		<!--- Outstanding And Tracking --->
			<cfset counter_e = counter_e + 1>
		</cfif>
		<cfif getpin2.h3100 eq "T">		<!--- Inventory Balance Check --->
			<cfset counter_e = counter_e + 1>
		</cfif>		
		<cfif husergrpid eq "admin" or husergrpid eq "super">	<!--- Trace Item Cost & Value --->
			<cfset counter_e = counter_e + 1>
		</cfif>
		
		Menu<cfoutput>#menucount#</cfoutput>=new Array("<a>Enquiry</a>","","../dropdownmenu/bgmenu.PNG",<cfoutput>#counter_e#</cfoutput>,hhheight,wwidth-50,"","","","","","",-1,-1,-1,"","");
	
		<cfset menucount_e = 0>
		<cfif husergrpid eq "admin" or husergrpid eq "super">
			<cfset menucount_e = menucount_e + 1>
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/billsummary.cfm' target='mainFrame'>Bill Summary Report</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		

		<cfif getpin2.h3500 eq "T">
			<cfset menucount_e = menucount_e + 1>
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>=new Array("<a>History Price Enquiry</a>","","",6,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/historypriceenquiry/historypriceform.cfm?history=customeritemlastprice' target='mainFrame'>Customer - Item Last Price</a>","","",0,hheight+20,wwidth+10,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/historypriceenquiry/historypriceform.cfm?history=customeritemtransactedprice' target='mainFrame'>Customer - Item Transacted Price</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_3=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/historypriceenquiry/historypriceform.cfm?history=itemcustomertransactedprice' target='mainFrame'>Item - Customer Transacted Price</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_4=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/historypriceenquiry/historypriceform.cfm?history=itemsupplierlastprice' target='mainFrame'>Item - Supplier Last Price</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_5=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/historypriceenquiry/historypriceform.cfm?history=itemsuppliertransactedprice' target='mainFrame'>Item - Supplier Transacted Price</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_6=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/historypriceenquiry/historypriceform.cfm?history=supplieritemtransactedprice' target='mainFrame'>Supplier - Item Transacted Price</a>","","",0,hheight+20,wwidth,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h3400 eq "T">
			<cfset menucount_e = menucount_e + 1>
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/inforecast.cfm?type=Inventory' target='mainFrame'>Inventory Forcast</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h3200 eq "T">
			<cfset menucount_e = menucount_e + 1>
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>=new Array("<a>Outstanding And Tracking</a>","","",7,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/outreport.cfm?type=DO' target='mainFrame'>Delivery Order</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/outreport.cfm?type=QUO' target='mainFrame'>Quotation</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_3=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/outreport.cfm?type=3' target='mainFrame'>Purchase Order</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_4=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/outreport.cfm?type=4' target='mainFrame'>PO Details</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_5=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/outreport.cfm?type=5' target='mainFrame'>Sales Order</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_6=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/outreport.cfm?type=6' target='mainFrame'>SO Details</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>_7=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/outreport.cfm?type=7' target='mainFrame'>SO to PO</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h3100 eq "T">
			<cfset menucount_e = menucount_e + 1>
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/inventorybalance_menu.cfm' target='mainFrame'>Inventory Balance Check</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif husergrpid eq "admin" or husergrpid eq "super">
			<cfset menucount_e = menucount_e + 1>
			Menu<cfoutput>#menucount#_#menucount_e#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/enquires/traceitem_costvalue_menu.cfm' target='mainFrame'>Trace Item Cost & Value</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
	</cfif>


	//5.reports
	<cfif getpin2.h4000 eq "T">
		<cfset menucount = menucount + 1>
		
		<cfset counter_r = 0>			
		<cfif getpin2.h4100 eq "T">		<!--- Bill Listing --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4200 eq "T">		<!--- Inventory Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4300 eq "T">		<!--- Sales Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
 		<cfif getpin2.h4400 eq "T">		<!--- Purchase Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4800 eq "T">		<!--- Cust/Supp/Agent/Area Item Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4500 eq "T">		<!--- Location Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4600 eq "T">		<!--- Serial Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4900 eq "T">		<!--- Batch Code Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4A00 eq "T">		<!--- Graded Item Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4B00 eq "T">		<!--- Matrix Item Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		<cfif getpin2.h4C00 eq "T">		<!--- Project Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		
		<cfif getpin2.h4D00 eq "T">		<!--- Service Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		
		<cfquery name="get_company_id" datasource="main">
			select 
			(lcase(left(company_id,char_length(company_id)-2))) as company_id
			from customize_report
			where company_id='#jsstringformat(preservesinglequotes(hcomid))#'
			order by company_id;
		</cfquery>
		<cfif get_company_id.recordcount eq 1>		<!--- Customized Report --->
			<cfset counter_r = counter_r + 1>
		</cfif>
		Menu<cfoutput>#menucount#</cfoutput>=new Array("<a>Reports</a>","","../dropdownmenu/bgmenu.PNG",<cfoutput>#counter_r#</cfoutput>,hhheight,wwidth-20,"","","","","","",-1,-1,-1,"","");

		<cfset menucount_r = 0>
		<cfif getpin2.h4100 eq "T">
		
			<cfset counter_r_b = 4>		<!--- Adjustment Increase, Adjustment Reduce, Transfer Note, Sample --->
			
			<cfif getpin2.h4110 eq 'T'>		<!--- Purchase Receive --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
    		<cfif getpin2.h4120 eq 'T'>		<!--- Purchase Return --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
    		<cfif getpin2.h4130 eq 'T'>		<!--- Delivery Order --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
    		<cfif getpin2.h4140 eq 'T'>		<!--- Invoice --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
    		<cfif getpin2.h4150 eq 'T'>		<!--- Quotation --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
			<cfif getpin2.h4160 eq 'T'>		<!--- Credit Note --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
    		<cfif getpin2.h4170 eq 'T'>		<!--- Debit Note --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
    		<cfif getpin2.h4180 eq 'T'>		<!--- Cash Sales --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
    		<cfif getpin2.h4190 eq 'T'>		<!--- Purchase Order --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
    		<cfif getpin2.h41A0 eq 'T'>		<!--- Sales Order --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
			<cfif getpin2.h41B0 eq 'T'>		<!--- Issue --->
				<cfset counter_r_b = counter_r_b + 1>
			</cfif>
   		
			<cfset menucount_r = menucount_r + 1>
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Bill Listing</a>","","",<cfoutput>#counter_r_b#</cfoutput>,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_b = 0>
			<cfif getpin2.h4110 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=1' target='mainFrame'>Purchase Receive</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4120 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=2' target='mainFrame'>Purchase Return</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4130 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=3' target='mainFrame'>Delivery Order</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4140 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=4' target='mainFrame'>Invoice</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4150 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=9' target='mainFrame'>Quotation</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4160 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=5' target='mainFrame'>Credit Note</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4170 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=6' target='mainFrame'>Debit Note</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4180 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=7' target='mainFrame'>Cash Sales</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4190 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=8' target='mainFrame'>Purchase Order</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h41A0 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=10' target='mainFrame'>Sales Order</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfset menucount_r_b = menucount_r_b + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=11' target='mainFrame'>Sample</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
		
			<cfif getpin2.h41B0 eq 'T'>
				<cfset menucount_r_b = menucount_r_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=12' target='mainFrame'>Issue</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfset menucount_r_b = menucount_r_b + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=13' target='mainFrame'>Adjustment Increase</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_b = menucount_r_b + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=14' target='mainFrame'>Adjustment Reduce</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_b = menucount_r_b + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-billing/bill_listingreport.cfm?type=15' target='mainFrame'>Transfer Note</a>","","",0,hheight,wwidth+60,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h4200 eq "T">
			<cfset menucount_r = menucount_r + 1>
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Inventory Report</a>","","",2,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset counter_r_i_b = 2>		<!--- Stock Aging, Physical Worksheet --->
			
			<cfif getpin2.h4210 eq "T">		<!--- Stock Card --->
				<cfset counter_r_i_b = counter_r_i_b + 1>
			</cfif>
    		<cfif getpin2.h4220 eq "T">		<!--- Reorder Advice --->
				<cfset counter_r_i_b = counter_r_i_b + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1=new Array("<a>Basic Report</a>","","",<cfoutput>#counter_r_i_b#</cfoutput>,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_i_b = 0>
			<cfif getpin2.h4210 eq "T">
				<cfset menucount_r_i_b = menucount_r_i_b + 1>
				<cftry>
					<cfquery name="getrecord" datasource="#dts#">
						SELECT qtybf_actual FROM icitem_last_year limit 1
					</cfquery>
					Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_i_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/stockcard0.cfm?type=1' target='mainFrame'>Stock Card</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				<cfcatch type="any">
					Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_i_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/stockcard.cfm?type=1' target='mainFrame'>Stock Card</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfcatch>
				</cftry>
				<!--- <cfif hcomid eq "idi_i" or hcomid eq "demo_i" or hcomid eq "saehan_i" or hcomid eq "ge_i">
					Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_i_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/stockcard0.cfm?type=1' target='mainFrame'>Stock Card</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				<cfelse>
					Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_i_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/stockcard.cfm?type=1' target='mainFrame'>Stock Card</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfif> --->
			</cfif>
			
			<cfif getpin2.h4220 eq "T">
				<cfset menucount_r_i_b = menucount_r_i_b + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_i_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/reorderadvise.cfm?type=2' target='mainFrame'>Reorder Advice</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfset menucount_r_i_b = menucount_r_i_b + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_i_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/stockaging.cfm' target='mainFrame'>Stock Aging</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_i_b = menucount_r_i_b + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_i_b#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/physical_worksheet_menu.cfm' target='mainFrame'>Physical Worksheet</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset counter_r_i_s = 0>
			
			<cfif getpin2.h4230 eq "T">		<!--- Item Status and Value --->
				<cfset counter_r_i_s = counter_r_i_s + 1>
			</cfif>
    		<cfif getpin2.h4240 eq "T">		<!--- Group Status and Value --->
				<cfset counter_r_i_s = counter_r_i_s + 1>
			</cfif>
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_2=new Array("<a>Stock Value Report</a>","","",<cfoutput>#counter_r_i_s#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_i_s = 0>
			
			<cfif getpin2.h4230 eq "T">
				<cfset menucount_r_i_s = menucount_r_i_s + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_2_#menucount_r_i_s#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/itemstatus.cfm?type=3' target='mainFrame'>Item Status and Value</a>","","",0,hheight,wwidth+25,"","","","","","",-1,0,-1,"","");
			</cfif>
			<cfif getpin2.h4240 eq "T">
				<cfset menucount_r_i_s = menucount_r_i_s + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_2_#menucount_r_i_s#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-stock/groupstatus.cfm?type=4' target='mainFrame'>Group Status and Value</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		<cfif getpin2.h4300 eq "T">
			<cfset menucount_r = menucount_r + 1>
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Sales Report</a>","","",8,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			<cfset counter_r_s_type = 0>
			
			<cfif getpin2.h4310 eq 'T'>		<!--- Products Sales --->
				<cfset counter_r_s_type = counter_r_s_type + 1>
			</cfif>
    		<cfif getpin2.h4320 eq 'T'>		<!--- Customers Sales --->
				<cfset counter_r_s_type = counter_r_s_type + 1>
			</cfif>
    		<cfif getpin2.h4330 eq 'T'>		<!--- Agent Sales --->
				<cfset counter_r_s_type = counter_r_s_type + 1>
			</cfif>
    		<cfif getpin2.h4340 eq 'T'>		<!--- Groups Sales --->
				<cfset counter_r_s_type = counter_r_s_type + 1>
			</cfif>
			<cfif getpin2.h4350 eq 'T'>		<!--- End User Sales --->
				<cfset counter_r_s_type = counter_r_s_type + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1=new Array("<a>Sales Report By Type</a>","","",<cfoutput>#counter_r_s_type#</cfoutput>,hheight,wwidth+30,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_s_type = 0>
			
			<cfif getpin2.h4310 eq 'T'>
				<cfset menucount_r_s_type = menucount_r_s_type + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_s_type#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salestype.cfm?type=producttype' target='mainFrame'>Products Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4320 eq 'T'>
				<cfset menucount_r_s_type = menucount_r_s_type + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_s_type#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salestype.cfm?type=customertype' target='mainFrame'>Customers Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4330 eq 'T'>
				<cfset menucount_r_s_type = menucount_r_s_type + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_s_type#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salestype.cfm?type=agenttype' target='mainFrame'>Agent Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4340 eq 'T'>
				<cfset menucount_r_s_type = menucount_r_s_type + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_s_type#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salestype.cfm?type=grouptype' target='mainFrame'>Groups Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4350 eq 'T'>
				<cfset menucount_r_s_type = menucount_r_s_type + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_1_#menucount_r_s_type#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salestype.cfm?type=endusertype' target='mainFrame'>End User Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfset counter_r_s_month = 0>
			
			<cfif getpin2.h4360 eq 'T'>		<!--- Products Sales --->
				<cfset counter_r_s_month = counter_r_s_month + 1>
			</cfif>
    		<cfif getpin2.h4370 eq 'T'>		<!--- Customers Sales --->
				<cfset counter_r_s_month = counter_r_s_month + 1>
			</cfif>
    		<cfif getpin2.h4380 eq 'T'>		<!--- Agent Sales --->
				<cfset counter_r_s_month = counter_r_s_month + 1>
			</cfif>
    		<cfif getpin2.h4390 eq 'T'>		<!--- Groups Sales --->
				<cfset counter_r_s_month = counter_r_s_month + 1>
			</cfif>
			<cfif getpin2.h43A0 eq 'T'>		<!--- End User Sales --->
				<cfset counter_r_s_month = counter_r_s_month + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_2=new Array("<a>Sales Report By Month</a>","","",<cfoutput>#counter_r_s_month#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_s_month = 0>
			
			<cfif getpin2.h4360 eq 'T'>
				<cfset menucount_r_s_month = menucount_r_s_month + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_2_#menucount_r_s_month#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesmonth.cfm?type=productmonth' target='mainFrame'>Products Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4370 eq 'T'>
				<cfset menucount_r_s_month = menucount_r_s_month + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_2_#menucount_r_s_month#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesmonth.cfm?type=customermonth' target='mainFrame'>Customers Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4380 eq 'T'>
				<cfset menucount_r_s_month = menucount_r_s_month + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_2_#menucount_r_s_month#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesmonth.cfm?type=agentmonth' target='mainFrame'>Agent Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4390 eq 'T'>
				<cfset menucount_r_s_month = menucount_r_s_month + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_2_#menucount_r_s_month#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesmonth.cfm?type=groupmonth' target='mainFrame'>Groups Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h43A0 eq 'T'>
				<cfset menucount_r_s_month = menucount_r_s_month + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_2_#menucount_r_s_month#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesmonth.cfm?type=endusermonth' target='mainFrame'>End User Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfset counter_r_s_week = 0>
					
			<cfif getpin2.h4360 eq 'T'>		<!--- Products Sales --->
				<cfset counter_r_s_week = counter_r_s_week + 1>
			</cfif>
    		<cfif getpin2.h4370 eq 'T'>		<!--- Customers Sales --->
				<cfset counter_r_s_week = counter_r_s_week + 1>
			</cfif>
    		<cfif getpin2.h4380 eq 'T'>		<!--- Agent Sales --->
				<cfset counter_r_s_week = counter_r_s_week + 1>
			</cfif>
    		<cfif getpin2.h4390 eq 'T'>		<!--- Groups Sales --->
				<cfset counter_r_s_week = counter_r_s_week + 1>
			</cfif>
			<cfif getpin2.h43A0 eq 'T'>		<!--- End User Sales --->
				<cfset counter_r_s_week = counter_r_s_week + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_3=new Array("<a>Sales Report By Week</a>","","",<cfoutput>#counter_r_s_week#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_s_week = 0>
			
			<cfif getpin2.h4360 eq 'T'>
				<cfset menucount_r_s_week = menucount_r_s_week + 1>	
				Menu<cfoutput>#menucount#_#menucount_r#_3_#menucount_r_s_week#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesweek.cfm?type=productweek' target='mainFrame'>Products Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4370 eq 'T'>
				<cfset menucount_r_s_week = menucount_r_s_week + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_3_#menucount_r_s_week#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesweek.cfm?type=customerweek' target='mainFrame'>Customers Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4380 eq 'T'>
				<cfset menucount_r_s_week = menucount_r_s_week + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_3_#menucount_r_s_week#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesweek.cfm?type=agentweek' target='mainFrame'>Agent Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4390 eq 'T'>
				<cfset menucount_r_s_week = menucount_r_s_week + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_3_#menucount_r_s_week#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesweek.cfm?type=groupweek' target='mainFrame'>Groups Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h43A0 eq 'T'>
				<cfset menucount_r_s_week = menucount_r_s_week + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_3_#menucount_r_s_week#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/salesweek.cfm?type=enduserweek' target='mainFrame'>End User Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_4=new Array("<a>Calculate Cost Of Sales</a>","","",5,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_4_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/calculatecostmenu.cfm?type=fixed' target='mainFrame'>Fixed Cost</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_4_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/calculatecostmenu.cfm?type=fifo' target='mainFrame'>First In First Out</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_4_3=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/calculatecostmenu.cfm?type=lifo' target='mainFrame'>Last In First Out</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_4_4=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/calculatecostmenu.cfm?type=month' target='mainFrame'>Month Average</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_4_5=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/calculatecostmenu.cfm?type=moving' target='mainFrame'>Moving Average</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset counter_r_s_profit = 2>		<!--- By Bill Item, By Customer --->
			
			<cfif getpin2.h43B0 eq 'T'>		<!--- By Products --->
				<cfset counter_r_s_profit = counter_r_s_profit + 1>
			</cfif>
    		<cfif getpin2.h43C0 eq 'T'>		<!--- By Bill --->
				<cfset counter_r_s_profit = counter_r_s_profit + 1>
			</cfif>
    		<cfif getpin2.h43D0 eq 'T'>		<!--- By Agent --->
				<cfset counter_r_s_profit = counter_r_s_profit + 1>
			</cfif>
    		<cfif getpin2.h43E0 eq 'T'>		<!--- By Project --->
				<cfset counter_r_s_profit = counter_r_s_profit + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_5=new Array("<a>Profit Margin Report</a>","","",<cfoutput>#counter_r_s_profit#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_s_profit = 0>
			
			<cfif getpin2.h43B0 eq 'T'>
				<cfset menucount_r_s_profit = menucount_r_s_profit + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_5_#menucount_r_s_profit#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/profitmargin.cfm?type=productmargin' target='mainFrame'>By Products</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h43C0 eq 'T'>
				<cfset menucount_r_s_profit = menucount_r_s_profit + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_5_#menucount_r_s_profit#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/profitmargin.cfm?type=billmargin' target='mainFrame'>By Bill</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h43D0 eq 'T'>
				<cfset menucount_r_s_profit = menucount_r_s_profit + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_5_#menucount_r_s_profit#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/profitmargin.cfm?type=agentmargin' target='mainFrame'>By Agent</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h43E0 eq 'T'>
				<cfset menucount_r_s_profit = menucount_r_s_profit + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_5_#menucount_r_s_profit#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/profitmargin.cfm?type=projectmargin' target='mainFrame'>By Project</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfset menucount_r_s_profit = menucount_r_s_profit + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_5_#menucount_r_s_profit#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/profitmargin.cfm?type=billitemmargin' target='mainFrame'>By Bill Item</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_s_profit = menucount_r_s_profit + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_5_#menucount_r_s_profit#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/profitmargin.cfm?type=customermargin' target='mainFrame'>By Customer</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset counter_r_s_listing = 1>		<!--- By Area --->
			
			<cfif getpin2.h43F0 eq 'T'>		<!--- By Customers --->
				<cfset counter_r_s_listing = counter_r_s_listing + 1>
			</cfif>
    		<cfif getpin2.h43G0 eq 'T'>		<!--- By Products --->
				<cfset counter_r_s_listing = counter_r_s_listing + 1>
			</cfif>
    		<cfif getpin2.h43H0 eq 'T'>		<!--- By Agent --->
				<cfset counter_r_s_listing = counter_r_s_listing + 1>
			</cfif>
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_6=new Array("<a>Sales Listing</a>","","",<cfoutput>#counter_r_s_listing#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_s_listing = 0>
			
			<cfif getpin2.h43F0 eq 'T'>
				<cfset menucount_r_s_listing = menucount_r_s_listing + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_6_#menucount_r_s_listing#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/saleslisting.cfm?type=customerlist' target='mainFrame'>By Customers</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h43G0 eq 'T'>
				<cfset menucount_r_s_listing = menucount_r_s_listing + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_6_#menucount_r_s_listing#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/saleslisting.cfm?type=productlist' target='mainFrame'>By Products</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h43H0 eq 'T'>
				<cfset menucount_r_s_listing = menucount_r_s_listing + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_6_#menucount_r_s_listing#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/saleslisting.cfm?type=agentlist' target='mainFrame'>By Agent</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfset menucount_r_s_listing = menucount_r_s_listing + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_6_#menucount_r_s_listing#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/saleslisting.cfm?type=arealist' target='mainFrame'>By Area</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_7=new Array("<a>Top/Bottom Product Sales</a>","","",2,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_7_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/topbottomsales.cfm?type=top' target='mainFrame'>Top Product Sales</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_7_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/topbottomsales.cfm?type=bottom' target='mainFrame'>Bottom Product Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_8=new Array("<a>Top Sales Report</a>","","",3,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#_8_1</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/topsales.cfm?type=customertype' target='mainFrame'>Top Sales By Customers</a>","","",0,hheight,wwidth+30,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#_8_2</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/topsales.cfm?type=agenttype' target='mainFrame'>Top Sales By Agent</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#_8_3</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-sales/topsales.cfm?type=areatype' target='mainFrame'>Top Sales By Area</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h4400 eq "T">
			<cfset menucount_r = menucount_r + 1>
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Purchase Report</a>","","",4,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1=new Array("<a>Purchase Report By Type</a>","","",2,hheight,wwidth+65,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-purchase/purchasetype.cfm?type=producttype' target='mainFrame'>Products Purchase</a>","","",0,hheight,wwidth+30,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-purchase/purchasetype.cfm?type=vendortype' target='mainFrame'>Vendor Supply</a>","","",0,hheight,wwidth+30,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_2=new Array("<a>Purchase Report By Month</a>","","",2,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_2_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-purchase/purchasemonth.cfm?type=productmonth' target='mainFrame'>Products Purchase</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_2_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-purchase/purchasemonth.cfm?type=vendormonth' target='mainFrame'>Vendor Supply</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_3=new Array("<a>Purchase Report By Quantity</a>","","",2,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_3_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-purchase/purchasequantity.cfm?type=vendorproduct' target='mainFrame'>Vendor - Products</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_3_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-purchase/purchasequantity.cfm?type=productvendor' target='mainFrame'>Products - Vendor</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_4=new Array("<a>Purchase Listing Report</a>","","",1,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_4_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-purchase/purchaselisting.cfm' target='mainFrame'>Purchase Listing By Vendors</a>","","",0,hheight+15,wwidth,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h4800 eq "T">
			<cfset menucount_r = menucount_r + 1>
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Cust/Supp/Agent/Area Item Report</a>","","",2,hheight+10,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1=new Array("<a>Item Sales Report By Type</a>","","",3,hheight+15,wwidth+20,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-item/itemtype.cfm?type=customerproducttype' target='mainFrame'>Customer - Products Sales</a>","","",0,hheight+15,wwidth+20,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-item/itemtype.cfm?type=productcustomertype' target='mainFrame'>Products - Customer Sales</a>","","",0,hheight+15,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_1_3=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-item/itemtype.cfm?type=agentproducttype' target='mainFrame'>Agent - Products Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_2=new Array("<a>Item Sales Report By Month</a>","","",2,hheight+15,wwidth,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_2_1=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-item/itemmonth.cfm?type=customerproductmonth' target='mainFrame'>Customer - Products Sales</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>_2_2=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-item/itemmonth.cfm?type=agentcustomermonth' target='mainFrame'>Agent - Customers Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h4500 eq "T">
			<cfset menucount_r = menucount_r + 1>
			
			<cfset counter_r_location = 1>		<!--- Location Physical Worksheet --->
			
			<cfif getpin2.h4510 eq "T">		<!--- Item-Location Sales --->
				<cfset counter_r_location = counter_r_location + 1>
			</cfif>
    		<cfif getpin2.h4520 eq "T">		<!--- Item-Location Purchase --->
				<cfset counter_r_location = counter_r_location + 1>
			</cfif>
    		<cfif getpin2.h4530 eq "T">		<!--- Stock Card --->
				<cfset counter_r_location = counter_r_location + 1>
			</cfif>
    		<cfif getpin2.h4540 eq "T">		<!--- Forecast --->
				<cfset counter_r_location = counter_r_location + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Location Report</a>","","",<cfoutput>#counter_r_location#</cfoutput>,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_location = 0>
			
			<cfif getpin2.h4510 eq "T">
				<cfset menucount_r_location = menucount_r_location + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_location#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-location/location_listingreport.cfm?type=1' target='mainFrame'>Item-Location Sales</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4520 eq "T">
				<cfset menucount_r_location = menucount_r_location + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_location#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-location/location_listingreport.cfm?type=2' target='mainFrame'>Item-Location Purchase</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4530 eq "T">
				<cfset menucount_r_location = menucount_r_location + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_location#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-location/location_stockcard_stock_card.cfm' target='mainFrame'>Stock Card</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4540 eq "T">
				<cfset menucount_r_location = menucount_r_location + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_location#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-location/location_stockcard_forecast.cfm' target='mainFrame'>Forecast</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfset menucount_r_location = menucount_r_location + 1>
			Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_location#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-location/location_physical_worksheet_menu.cfm' target='mainFrame'>Location Physical Worksheet</a>","","",0,hheight+15,wwidth,"","","","","","",-1,0,-1,"","");
			
		</cfif>
		
		<cfif getpin2.h4600 eq "T">
			<cfset menucount_r = menucount_r + 1>
			
			<cfset counter_r_other = 0>
			<cfif getpin2.h4610 eq 'T'>		<!--- Transaction Listing by Refno No --->
				<cfset counter_r_other = counter_r_other + 1>
			</cfif>
    		<cfif getpin2.h4620 eq 'T'>		<!--- Transaction Listing by Item --->
				<cfset counter_r_other = counter_r_other + 1>
			</cfif>
    		<cfif getpin2.h4630 eq 'T'>		<!--- Item - Serial No. Status --->
				<cfset counter_r_other = counter_r_other + 1>
			</cfif>
   			<cfif getpin2.h4640 eq 'T'>		<!--- Serial No. Sales Listing --->
				<cfset counter_r_other = counter_r_other + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Serial Report</a>","","",<cfoutput>#counter_r_other#</cfoutput>,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_other = 0>
			
			<cfif getpin2.h4610 eq 'T'>
				<cfset menucount_r_other = menucount_r_other + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_other#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-others/serialreport1.cfm?type=ref' target='mainFrame'>Transaction Listing by Refno No</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4620 eq 'T'>
				<cfset menucount_r_other = menucount_r_other + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_other#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-others/serialreport1.cfm?type=item' target='mainFrame'>Transaction Listing by Item</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4630 eq 'T'>
				<cfset menucount_r_other = menucount_r_other + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_other#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-others/serialreport1.cfm?type=status' target='mainFrame'>Item - Serial No. Status</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
	
			<cfif getpin2.h4640 eq 'T'>		
				<cfset menucount_r_other = menucount_r_other + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_other#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-others/serialreport1.cfm?type=sale' target='mainFrame'>Serial No. Sales Listing</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		<cfif getpin2.h4900 eq "T">
			<cfset menucount_r = menucount_r + 1>
			
			<cfset counter_r_batch = 0>
			<cfif getpin2.h4910 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			<cfif getpin2.h4920 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			<cfif getpin2.h4930 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			<cfif getpin2.h4940 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			<cfif getpin2.h4950 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			<cfif getpin2.h4960 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			<cfif getpin2.h4970 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			<cfif getpin2.h4980 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			<cfif getpin2.h4990 eq "T">
				<cfset counter_r_batch = counter_r_batch + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Batch Code Report</a>","","",<cfoutput>#counter_r_batch#</cfoutput>,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_batch = 0>
			
			<cfif getpin2.h4910 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=itembatchopening' target='mainFrame'>Item Batch Opening</a>","","",0,hheight,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4920 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=itembatchsales' target='mainFrame'>Item Batch Sales</a>","","",0,hheight,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4930 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=itembatchstatus' target='mainFrame'>Item Batch Status</a>","","",0,hheight,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4940 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=itembatchstockcard' target='mainFrame'>Item Batch Stock Card</a>","","",0,hheight,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4950 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=batchlisting' target='mainFrame'>Batch Item Listing</a>","","",0,hheight,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4960 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=locationitembatchopening' target='mainFrame'>Location Item Batch Opening</a>","","",0,hheight+15,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4970 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=locationitembatchsales' target='mainFrame'>Location Item Batch Sales</a>","","",0,hheight+15,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4980 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=locationitembatchstatus' target='mainFrame'>Location Item Batch Status</a>","","",0,hheight+15,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4990 eq "T">
				<cfset menucount_r_batch = menucount_r_batch + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_batch#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-batch/batchreportform.cfm?type=locationitembatchstockcard' target='mainFrame'>Location Item Batch Stock Card</a>","","",0,hheight+15,wwidth+18,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		<cfif getpin2.h4A00 eq "T">
			<cfset menucount_r = menucount_r + 1>
			
			<cfset counter_r_graded = 0>
			<cfif getpin2.h4A10 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4A20 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4A30 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4A40 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4A50 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4A60 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4A70 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4A80 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4A90 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4AA0 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4AB0 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4AC0 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			<cfif getpin2.h4AD0 eq "T">
				<cfset counter_r_graded = counter_r_graded + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Graded Item Report</a>","","",<cfoutput>#counter_r_graded#</cfoutput>,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_graded = 0>
			
			<cfif getpin2.h4A10 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/physical_worksheet_form.cfm?type=physical' target='mainFrame'>Graded Item Physical Worksheet</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4A20 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=opening' target='mainFrame'>Graded Item Opening</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4A30 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=sales' target='mainFrame'>Graded Item Sales</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4A40 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=status' target='mainFrame'>Graded Item Status</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4A50 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=stockcard' target='mainFrame'>Graded Item Stock Card</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4A60 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=itemlocopening' target='mainFrame'>Graded Item - Location Opening</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4A70 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=itemlocsales' target='mainFrame'>Graded Item - Location Sales</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4A80 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=itemlocstatus' target='mainFrame'>Graded Item - Location Status</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4A90 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/physical_worksheet_form.cfm?type=locitemphysical' target='mainFrame'>Location - Graded Item Physical Worksheet</a>","","",0,hheight+15,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4AA0 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=locitemopening' target='mainFrame'>Location - Graded Item Opening</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4AB0 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=locitemsales' target='mainFrame'>Location - Graded Item Sales</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4AC0 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=locitemstatus' target='mainFrame'>Location - Graded Item Status</a>","","",0,hheight,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4AD0 eq 'T'>
				<cfset menucount_r_graded = menucount_r_graded + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_graded#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-gradeditem/gradedreportform.cfm?type=locitemstockcard' target='mainFrame'>Location - Graded Item Stock Card</a>","","",0,hheight+15,wwidth+90,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		<cfif getpin2.h4B00 eq "T">
			<cfset menucount_r = menucount_r + 1>
			
			<cfset counter_r_matrix = 0>
			<cfif getpin2.h4B10 eq "T">
				<cfset counter_r_matrix = counter_r_matrix + 1>
			</cfif>
			<cfif getpin2.h4B20 eq "T">
				<cfset counter_r_matrix = counter_r_matrix + 1>
			</cfif>
			<cfif getpin2.h4B30 eq "T">
				<cfset counter_r_matrix = counter_r_matrix + 1>
			</cfif>
			<cfif getpin2.h4B40 eq "T">
				<cfset counter_r_matrix = counter_r_matrix + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Matrix Item Report</a>","","",<cfoutput>#counter_r_matrix#</cfoutput>,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_r_matrix = 0>
			<cfif getpin2.h4B10 eq "T">
				<cfset menucount_r_matrix = menucount_r_matrix + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_matrix#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-matrixitem/matrixreportform.cfm?type=opening' target='mainFrame'>Matrix Item Opening</a>","","",0,hheight,wwidth+40,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4B20 eq "T">
				<cfset menucount_r_matrix = menucount_r_matrix + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_matrix#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-matrixitem/matrixreportform.cfm?type=sales' target='mainFrame'>Matrix Item Sales</a>","","",0,hheight,wwidth+40,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4B30 eq "T">
				<cfset menucount_r_matrix = menucount_r_matrix + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_matrix#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-matrixitem/matrixreportform.cfm?type=purchase' target='mainFrame'>Matrix Item Purchase</a>","","",0,hheight,wwidth+40,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4B40 eq "T">
				<cfset menucount_r_matrix = menucount_r_matrix + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_matrix#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-matrixitem/matrixreportform.cfm?type=stockbalance' target='mainFrame'>Matrix Stock Balance</a>","","",0,hheight,wwidth+40,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		<cfif getpin2.h4C00 eq "T">		<!--- Project Report --->
			<cfset menucount_r = menucount_r + 1>
			
			<cfset counter_r_project = 0>
			<cfif getpin2.h4C10 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4C20 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4C30 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4C40 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Project Report</a>","","",<cfoutput>#counter_r_project#</cfoutput>,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_r_project = 0>
			<cfif getpin2.h4C10 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-project/projectreportform.cfm?type=listprojitem' target='mainFrame'>List By Project Item</a>","","",0,hheight,wwidth+40,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4C20 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-project/projectreportform.cfm?type=salesiss' target='mainFrame'>Project Sales & Issue</a>","","",0,hheight,wwidth+40,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4C30 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-project/projectreportform.cfm?type=projitemiss' target='mainFrame'>Project - Item Issue</a>","","",0,hheight,wwidth+40,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4C40 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-project/projectreportform.cfm?type=itemprojiss' target='mainFrame'>Item - Project Issue</a>","","",0,hheight,wwidth+40,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
	
		<cfif getpin2.h4D00 eq "T">		<!--- Service Report --->
			<cfset menucount_r = menucount_r + 1>
			
			<cfset counter_r_project = 0>
			<cfif getpin2.h4D10 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D20 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D30 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D40 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D50 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D60 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D70 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D80 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D90 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>
			<cfif getpin2.h4D90 eq "T">
				<cfset counter_r_project = counter_r_project + 1>
			</cfif>

			
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a>Service Report</a>","","",<cfoutput>#counter_r_project#</cfoutput>,hheight,wwidth+70,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_r_project = 0>
			<cfif getpin2.h4D10 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/servicereportform.cfm?type=listprojitem' target='mainFrame'>List By Service Item</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4D20 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/servicereportform1.cfm?type=salesiss' target='mainFrame'>Service Income report</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4D30 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/servicereportform2.cfm?type=salesiss' target='mainFrame'>Customer - ServiceReport</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>
			
			<cfif getpin2.h4D40 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/servicereportform3.cfm?type=projitemiss' target='mainFrame'>Agent - ServiceReport</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>

		<cfif getpin2.h4D50 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/servicereportform4.cfm' target='mainFrame'>Supplier - ServiceReport</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>

		<cfif getpin2.h4D60 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/servicereportform5.cfm' target='mainFrame'>Service Profit Margin - Transactions</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>
		
		<cfif getpin2.h4D70 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/servicereportform6.cfm' target='mainFrame'>Service Profit Margin - Service Code</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>
		
		<cfif getpin2.h4D80 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/servicemonth.cfm' target='mainFrame'>Service Part Report - By Month</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>

		<cfif getpin2.h4D90 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/productivitymonth.cfm' target='mainFrame'>Productivity Report - By Month</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>
		<cfif getpin2.h4D90 eq "T">
				<cfset menucount_r_project = menucount_r_project + 1>
				Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_project#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/report-service/p_servicereportproject.cfm' target='mainFrame'>Service Report - By Project</a>","","",0,hheight,wwidth+120,"","","","","","",-1,0,-1,"","");
			</cfif>
		</cfif>
		
		
		<cfif get_company_id.recordcount eq 1>
			<cfset counter_r_customized = 0>
			<cfswitch expression="#lcase(hcomid)#">		
				<cfcase value="avt_i">		<!--- Service/Installation/commissioning Report --->
					<cfset counter_r_customized = counter_r_customized + 1>
				</cfcase>
				<cfcase value="gel_i">		<!--- Product Profit Margin Report, Product Sales Report By Month, Product Sales Report By Week, Customer Product Report By Month, Customer Sales Report By Week --->
					<cfset counter_r_customized = counter_r_customized + 5>
				</cfcase>
				<cfcase value="floprints_i">		<!--- Job Status Report, Job Status Maintenance --->
					<cfset counter_r_customized = counter_r_customized + 2>
				</cfcase>
				<cfcase value="glenn_i">		<!--- Port Cost Report --->
					<cfset counter_r_customized = counter_r_customized + 1>
				</cfcase>
				<cfcase value="migif_i">		<!--- Location Consignment Report, Consignment Listing Report --->
					<cfset counter_r_customized = counter_r_customized + 2>
				</cfcase>
				<cfcase value="remo_i">		<!--- Item Batch Stock Card Report, Special Stock Card Report --->
					<cfset counter_r_customized = counter_r_customized + 2>
				</cfcase>
				<cfcase value="sjgroup_i">		<!--- INV_CN Report --->
					<cfset counter_r_customized = counter_r_customized + 1>
				</cfcase>
				<cfcase value="idi_i,ge_i,gecn_i,gwa_i,gwachina_i" delimiters=",">		<!--- SO / PO Report --->
					<cfset counter_r_customized = counter_r_customized + 1>
				</cfcase>
				<cfcase value="tmt_i|taff_i|taftc_i" delimiters="|">		
					<cfif getpin2.hc001 eq 'T'>		<!--- Products Sales --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc002 eq 'T'>		<!--- Customers Sales --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc003 eq 'T'>		<!--- Agent Sales --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc004 eq 'T'>		<!--- Balance Summary Report --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc005 eq 'T'>		<!--- Schedule --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc006 eq 'T'>		<!--- Comment List --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc007 eq 'T'>		<!--- Commission Report --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc008 eq 'T'>		<!--- Telemarketing List --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc009 eq 'T'>		<!--- Customer Label --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc010 eq 'T'>		<!--- Student Course Cert --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc011 eq 'T'>		<!--- Activation List --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc012 eq 'T'>		<!--- Sales Monitoring Report --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc013 eq 'T'>		<!--- Student Name Tag --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc014 eq 'T'>		<!--- Attendance List --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
					<cfif getpin2.hc015 eq 'T'>		<!--- Customer Profile Report --->
						<cfset counter_r_customized = counter_r_customized + 1>
					</cfif>
				</cfcase>
				<cfcase value="bhl_i">		<!--- Outstanding Sale Order Report --->
					<cfset counter_r_customized = counter_r_customized + 1>
				</cfcase>
			</cfswitch>
			<cfset menucount_r = menucount_r + 1>
			Menu<cfoutput>#menucount#_#menucount_r#</cfoutput>=new Array("<a href='../Report/report_menu.cfm?company_id=#urlencodedformat(get_company_id.company_id)#' target='mainFrame'>Customized Report</a>","","",<cfoutput>#counter_r_customized#</cfoutput>,hheight,wwidth,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_r_customized = 0>	
			
			<cfswitch expression="#lcase(hcomid)#">		
				<cfcase value="avt_i">		<!--- Service/Installation/commissioning Report --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/AVT/sic.cfm' target='mainFrame'>Service/Installation/commissioning Report</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="gel_i">		<!--- Product Profit Margin Report, Product Sales Report By Month, Product Sales Report By Week, Customer Product Report By Month, Customer Sales Report By Week --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/GEL/product_profit_margin_report.cfm' target='mainFrame'>Product Profit Margin Report</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/GEL/product_sales_report_by_month.cfm' target='mainFrame'>Product Sales Report By Month</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/GEL/product_sales_report_by_week.cfm' target='mainFrame'>Product Sales Report By Week</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/GEL/customer_product_report_by_month.cfm' target='mainFrame'>Customer Product Report By Month</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/GEL/customer_sales_report_by_week.cfm' target='mainFrame'>Customer Sales Report By Week</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="floprints_i">		<!--- Job Status Report, Job Status Maintenance --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/FLOPRINTS/jobstatus.cfm' target='mainFrame'>Job Status Report</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/FLOPRINTS/job_status_maintenance.cfm' target='mainFrame'>Job Status Maintenance</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="glenn_i">		<!--- Port Cost Report --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/GLENN/craftReport.cfm' target='mainFrame'>Port Cost Report</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="migif_i">		<!--- Location Consignment Report, Consignment Listing Report --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/MIGIF/locationmenu.cfm' target='mainFrame'>Location Consignment Report</a>","","",0,hheight+10,wwidth+15,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/MIGIF/consignment_bill_listing_menu.cfm' target='mainFrame'>Consignment Listing Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="remo_i">		<!--- Item Batch Stock Card Report, Special Stock Card Report --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/REMO/batchreportform.cfm' target='mainFrame'>Item Batch Stock Card Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/REMO/specialstockcard.cfm' target='mainFrame'>Special Stock Card Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="sjgroup_i">		<!--- INV_CN Report --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/SJGROUP/inv_cn_report_form.cfm' target='mainFrame'>INV_CN Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="idi_i,ge_i,gecn_i,gwa_i,gwachina_i" delimiters=",">		<!--- SO / PO Report --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/ECN/so_po_report_form.cfm' target='mainFrame'>SO / PO Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="tmt_i|taff_i|taftc_i" delimiters="|">		
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/salereport_filter.cfm?type=product' target='mainFrame'>Products Sales</a>","","",0,hheight,wwidth+10,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/salereport_filter.cfm?type=customer' target='mainFrame'>Customers Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/salereport_filter.cfm?type=agent' target='mainFrame'>Agent Sales</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/bal_summary.cfm' target='mainFrame'>Balance Summary Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/schedule_filter.cfm?ptype=tag' target='mainFrame'>Schedule</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/printing_filter.cfm?ptype=comment' target='mainFrame'>Comment List</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/commission.cfm' target='mainFrame'>Commission Report</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../tmt/telemarketing.cfm?searchtype=&searchstr=' target='mainFrame'>Telemarketing List</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/printing_filter.cfm?ptype=label' target='mainFrame'>Customer Label</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/printing_filter.cfm?ptype=cert' target='mainFrame'>Student Course Cert</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/activationlist_filter.cfm' target='mainFrame'>Activation List</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/salemonitorreport_filter.cfm' target='mainFrame'>Sales Monitoring Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/printing_filter.cfm?ptype=tag' target='mainFrame'>Student Name Tag</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/printing_filter.cfm?ptype=attendance' target='mainFrame'>Attendance List</a>","","",0,hheight,wwidth,"","","","","","",-1,0,-1,"","");
					
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/TMT/printing.cfm?ptype=customer' target='_blank'>Customer Profile Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
				</cfcase>
				<cfcase value="bhl_i">		<!--- Outstanding Sale Order Report --->
					<cfset menucount_r_customized = menucount_r_customized + 1>
					Menu<cfoutput>#menucount#_#menucount_r#_#menucount_r_customized#</cfoutput>=new Array("<a href='../Report/BHL/outstanding_sale_order_report_form.cfm' target='mainFrame'>Outstanding Sale Order Report</a>","","",0,hheight+10,wwidth,"","","","","","",-1,0,-1,"","");
				</cfcase>
			</cfswitch>
		
		</cfif>
	</cfif>


	//6.general setup
	<cfif getpin2.h5000 eq "T">
		<cfset menucount = menucount + 1>
		
		<cfset counter_g = 0>
		<cfif getpin2.h5100 eq "T">		<!--- General Information Setup --->
			<cfset counter_g = counter_g + 1>
		</cfif>
		<cfif getpin2.h5300 eq "T">		<!--- User Administration --->
			<cfset counter_g = counter_g + 1>
		</cfif>
		<cfif getpin2.h5500 eq "T">		<!--- User Defined Menu --->
			<cfset counter_g = counter_g + 1>
		</cfif>
		<!--- <cfif getpin2.h5400 eq "T">		<!--- Currency Table --->
			<cfset counter_g = counter_g + 1>
		</cfif> --->
		<cfif getpin2.h5400 eq "T">		<!--- Currency Table, Tax Table --->
			<cfset counter_g = counter_g + 2>
		</cfif>
		<cfif getpin2.h5600 eq "T">		<!--- Posting To UBS --->
			<cfset counter_g = counter_g + 1>
		</cfif>
		<cfif getpin2.h5200 eq "T">		<!--- Year-End Processing --->
			<cfset counter_g = counter_g + 1>
		</cfif>
		<cfif getpin2.H5800 eq "T">		<!--- View Audit Trail,View Audit Trail II --->
			<cfset counter_g = counter_g + 2>
		</cfif>
		<!--- <cfif Hlinkams eq "Y">	<!--- IRAS Posting --->
			<cfset counter_g = counter_g + 1>
		</cfif> --->
		<cfif husergrpid eq "super" or husergrpid eq "admin">	<!--- Import CSV File to IMS, Import EXCEL File to IMS, Export To CSV File --->
			<cfset counter_g = counter_g + 3>
		</cfif>
		<cfif husergrpid eq "admin">	<!--- Qin Qout Recalculate, Upload .CFR Bills --->
			<cfset counter_g = counter_g + 2>
		</cfif>
		<cfif getpin2.H5900 eq "T">		<!--- Boss Menu --->
			<cfset counter_g = counter_g + 1>
		</cfif>
	
		Menu<cfoutput>#menucount#</cfoutput>=new Array("<a>General Setup</a>","","../dropdownmenu/bgmenu.PNG",<cfoutput>#counter_g#</cfoutput>,hhheight,wwidth-30,"","","","","","",-1,-1,-1,"","");

		<cfset menucount_g = 0>
		<cfif getpin2.h5100 eq "T">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/general.cfm' target='mainFrame'>General Information Setup</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h5300 eq "T">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/vuser.cfm' target='mainFrame'>User Administration</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h5500 eq "T">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/userdefinedmenu/usergroup.cfm' target='mainFrame'>User Defined Menu</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h5400 eq "T">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/currency/vcurrency.cfm' target='mainFrame'>Currency Table</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/tax/tax.cfm' target='mainFrame'>Tax Table</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfif getpin2.h5600 eq "T">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/posting2/postingacc.cfm?status=UNPOSTED' target='mainFrame'>Posting To <cfif Hlinkams eq "Y">AMS<cfelse>UBS</cfif></a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");				
		</cfif>
		
		<cfif getpin2.h5200 eq "T">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/yearend.cfm' target='mainFrame'>Year-End Processing</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		<cfif getpin2.H5800 eq "T">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/viewaudit_trail.cfm' target='mainFrame'>View Audit Trail</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/viewaudit_trail_custsuppitem.cfm' target='mainFrame'>View Audit Trail II</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");			
		</cfif>
		<!--- <cfif Hlinkams eq "Y">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/posting2/irasPosting.cfm' target='mainFrame'>Iras Posting</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif> --->
		<cfif husergrpid eq "super" or husergrpid eq "admin">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/importtable/import.cfm' target='mainFrame'>Import CSV File to IMS</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/importtable/import_excel.cfm' target='mainFrame'>Import EXCEL File to IMS</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/export_to_csv_list.cfm' target='mainFrame'>Export To CSV File</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		<cfif husergrpid eq "admin">
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/super_menu/recalculateqty.cfm' target='mainFrame'>Qin Qout Recalculate</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/super_menu/upload.cfm' target='mainFrame'>Upload .CFR Bills</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		<cfif getpin2.H5900 eq "T">		<!--- Boss Menu --->
			<cfset menucount_g = menucount_g + 1>
			Menu<cfoutput>#menucount#_#menucount_g#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/bossmenu/bossmenu.cfm' target='mainFrame'>Boss Menu</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
	</cfif>

	//7.CRM Function
	<cfif lcase(hcomid) eq "ubs_i" or lcase(hcomid) eq "net_i" or lcase(hcomid) eq "imk_i" or lcase(hcomid) eq "netm_i">
		<cfset menucount = menucount + 1>
		
		<cfset counter_c = 2>	<!--- 1. View Expire Contract 2.Check Contract --->
		<cfif lcase(hcomid) neq "imk_i">
			<cfset counter_c = counter_c + 4>
		</cfif>
		<cfif lcase(hcomid) eq "net_i" or lcase(hcomid) eq "netm_i">
			<cfset counter_c = counter_c + 2>
		</cfif>
		
		Menu<cfoutput>#menucount#</cfoutput>=new Array("<a>CRM</a>","","../dropdownmenu/bgmenu.PNG",<cfoutput>#counter_c#</cfoutput>,hhheight,wwidth-30,"","","","","","",-1,-1,-1,"","");
		
		<cfset menucount_c = 0>
		<cfif lcase(hcomid) neq "imk_i">
			<cfset menucount_c = menucount_c + 1>
			Menu<cfoutput>#menucount#_#menucount_c#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/crm/createjob.cfm' target='mainFrame'>Create Jobsheet</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_c = menucount_c + 1>
			Menu<cfoutput>#menucount#_#menucount_c#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/crm/viewjob.cfm' target='mainFrame'>View Jobsheet</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_c = menucount_c + 1>
			Menu<cfoutput>#menucount#_#menucount_c#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/crm/customerhistory.cfm' target='mainFrame'>View Customer History</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		
			<cfset menucount_c = menucount_c + 1>
			Menu<cfoutput>#menucount#_#menucount_c#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/crm/viewschedule.cfm' target='mainFrame'>View Schedule</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
		
		<cfset menucount_c = menucount_c + 1>
		Menu<cfoutput>#menucount#_#menucount_c#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/crm/rptexpire.cfm' target='mainFrame'>View Expire Contract</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		
		<cfset menucount_c = menucount_c + 1>
		Menu<cfoutput>#menucount#_#menucount_c#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/crm/chkcntct.cfm' target='mainFrame'>Check Contract</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
	
		<cfif lcase(hcomid) eq "net_i" or lcase(hcomid) eq "netm_i">
			<cfset menucount_c = menucount_c + 1>
			Menu<cfoutput>#menucount#_#menucount_c#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/crm/cust_maintenance/index.cfm' target='_blank'>Customer Account</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
			
			<cfset menucount_c = menucount_c + 1>
			Menu<cfoutput>#menucount#_#menucount_c#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/crm/updatecntct.cfm' target='mainFrame'>Update Contract</a>","","",0,hheight,wwidth+45,"","","","","","",-1,0,-1,"","");
		</cfif>
	</cfif>
	//8.customised function
	<cfif husergrpid eq "Super">
		<cfset menucount = menucount + 1>
		
		<cfset counter_s = 11>
		<cfif findnocase("junyong",HUserID) or findnocase("vincent",HUserID) or findnocase("weesiong",HUserID)>
			<cfset counter_s = counter_s + 6>
		</cfif>
		
		Menu<cfoutput>#menucount#</cfoutput>=new Array("<a>Super Menu</a>","","../dropdownmenu/bgmenu.PNG",<cfoutput>#counter_s#</cfoutput>,hhheight,wwidth-45,"","","","","","",-1,-1,-1,"","");
		
		<cfset menucount_s = 0>
		<cfif findnocase("junyong",HUserID) or findnocase("vincent",HUserID) or findnocase("weesiong",HUserID)>
			<cfset menucount_s = menucount_s + 1>
			Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/amssetup.cfm' target='mainFrame')>Setup AMS Server</a>","","",0,hheight,wwidth+10,"","","","","","",-1,-1,-1,"","");
		
			<cfset menucount_s = menucount_s + 1>
			Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/add_special_maintenance.cfm' target='mainFrame')>Add Special Maintenance</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
		
			<cfset menucount_s = menucount_s + 1>
			Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/add_special_transaction.cfm' target='mainFrame')>Add Special Transaction</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
		
			<cfset menucount_s = menucount_s + 1>
			Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/add_special_print_bills.cfm' target='mainFrame')>Add Special Print Bills</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
		
			<cfset menucount_s = menucount_s + 1>
			Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/add_special_enquire.cfm' target='mainFrame')>Add Special Enquire</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
			
			<cfset menucount_s = menucount_s + 1>
			Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/add_special_report.cfm' target='mainFrame')>Add Special Report</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
		</cfif>
		
		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/amsuser.cfm' target='mainFrame')>Setup AMS Users</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");

		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/user.cfm?type=Create' target='mainFrame')>To Create An IMS User</a>","","",0,hheight+10,wwidth,"","","","","","",-1,-1,-1,"","");

		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/<cfoutput>#HDir#</cfoutput>/admin/vuser1.cfm?all=all' target='mainFrame')>To View IMS Users</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");

		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/recover_update_menu.cfm' target='mainFrame')>Recover Update</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
	
		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/upload.cfm' target='mainFrame')>Upload .CFR Bills</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
		
		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/addbillformat.cfm' target='mainFrame')>Add .CFR Bills</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
		
		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/import.cfm' target='mainFrame')>Import Table</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");

		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/match_comment.cfm' target='mainFrame')>Match Comment</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
		
		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/insertuserpin.cfm' target='mainFrame')>Add UserPIN</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");

		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/info_view.cfm' target='mainFrame')>Information Profile</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
		
		<cfset menucount_s = menucount_s + 1>
		Menu<cfoutput>#menucount#_#menucount_s#</cfoutput>=new Array("<a href='/super_menu/recalculateperiod.cfm' target='mainFrame')>Recalculate Period</a>","","",0,hheight,wwidth,"","","","","","",-1,-1,-1,"","");
	</cfif>

	<cfset menucount = menucount + 1>
	Menu<cfoutput>#menucount#</cfoutput>=new Array("<a href='../contact.cfm' target='mainFrame')>Contact Us</a>","","../dropdownmenu/bgmenu.PNG",0,hhheight,wwidth-45,"","","","","","",-1,-1,-1,"","");

	<cfset menucount = menucount + 1>
	Menu<cfoutput>#menucount#</cfoutput>=new Array("<a href='../download.cfm' target='mainFrame')>Help</a>","","../dropdownmenu/bgmenu.PNG",0,hhheight,wwidth-80,"","","","","","",-1,-1,-1,"","");

	<cfset menucount = menucount + 1>
	Menu<cfoutput>#menucount#</cfoutput>=new Array("<a href='../logout.cfm' target='mainFrame')>Logout</a>","","../dropdownmenu/bgmenu.PNG",0,hhheight,wwidth-45,"","","","","","",-1,-1,-1,"","");
</script>