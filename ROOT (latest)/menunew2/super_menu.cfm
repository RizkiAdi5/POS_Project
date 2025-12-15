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
<cfoutput>
<div style="overflow:hidden">
<div class="secondary_menu">
<div id="masterdiv">
<cfif husergrpid eq "Super">
<cfif findnocase("junyong",HUserID) or findnocase("vincent",HUserID) or findnocase("weesiong",HUserID)>
			<li>
				<a class="oe_secondary_submenu_item" href="/super_menu/amssetup.cfm" target="mainFrame">
					Setup AMS Server
				</a>
			</li>
			<li>
				<a class="oe_secondary_submenu_item" href="/super_menu/add_special_maintenance.cfm" target="mainFrame">
					Add Special Maintenance
				</a>
			</li>
			<li>
				<a class="oe_secondary_submenu_item" href="/super_menu/add_special_transaction.cfm" target="mainFrame">
					Add Special Transaction
				</a>
			</li>
			<li>
				<a class="oe_secondary_submenu_item" href="/super_menu/add_special_print_bills.cfm" target="mainFrame">
					Add Special Print Bills
				</a>
			</li>
			<li>
				<a class="oe_secondary_submenu_item" href="/super_menu/add_special_enquire.cfm" target="mainFrame">
					Add Special Enquire
				</a>
			</li>
			<li>
				<a class="oe_secondary_submenu_item" href="/super_menu/add_special_report.cfm" target="mainFrame">
					Add Special Report
				</a>
			</li>
		</cfif>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/amsuser.cfm" target="mainFrame">
				Setup AMS Users
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/userlimit.cfm" target="mainFrame">
				Setup Account Users Limit
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/unblockbrute.cfm" target="mainFrame">
				Unblock Brute Users
			</a>
		</li>
		
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/admin/user.cfm?type=Create" target="mainFrame">
				To Create An IMS User
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/#HDir#/admin/vuser1.cfm?all=all" target="mainFrame">
				To View IMS Users
			</a>
		</li>
		
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/upload.cfm" target="mainFrame">
				Upload .CFR Bills
			</a>
		</li>
		<!--- ADD ON 18-05-2009 --->
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/addbillformat.cfm" target="mainFrame">
				Add .CFR Bills
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/importing/uploadfile.cfm" target="mainFrame">
				Upload and Import Dbf File to System
			</a>
		</li>
		
        <cfif left(huserid,5) eq "ultra">
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/backupdata/index.cfm" target="mainFrame">
				BACKUP
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/backupdata/restore.cfm" target="mainFrame">
				RESTORE
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/emaildb.cfm" target="mainFrame">
				Email Backup
			</a>
		</li>
		</cfif>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/fifo_costing_recalculate.cfm" target="mainFrame">
				FIFO Costing Calculation After Year-End
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recalculatelocationqty.cfm" target="mainFrame">
				Location QtyBf Calculation After Year-End
			</a>
		</li>
       <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/calculate_gradeqty.cfm" target="mainFrame">
				Grade QtyBf Calculation After Year-End
			</a>
		</li>
		
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/import.cfm" target="mainFrame">
				Import Table
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/match_comment.cfm" target="mainFrame">
				Match Comment
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/insertuserpin.cfm" target="mainFrame">
				Add UserPIN
			</a>
		</li>
		<!--- <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/updateoperiod.cfm" target="mainFrame">
				Update Old Period
			</a>
		</li> --->
		<cfif findnocase("swdemo",HUserID) or findnocase("weesiong",HUserID)>
			<li>
				<a class="oe_secondary_submenu_item" href="/super_menu/deleteusers.cfm" target="mainFrame">
					Delete Users
				</a>
			</li>
		</cfif>
		<cfif findnocase("swdemo",HUserID) or findnocase("swneti",HUserID)>
			<li>
				<a class="oe_secondary_submenu_item" href="/super_menu/insertcolumn.cfm" target="mainFrame">
					Insert Column
				</a>
			</li>
		</cfif>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/menutable.cfm" target="mainFrame">
				Menu Maintenance
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/info_view.cfm" target="mainFrame">
				Information Profile
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/startupwarning.cfm" target="mainFrame">
				Startup Warning Setting
			</a>
		</li>
		
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recover_update_menu.cfm" target="mainFrame">
				Recover Update
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recovery.cfm" target="mainFrame">
				Recover Year End 
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recalculateperiod.cfm" target="mainFrame">
				Recalculate Period
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recalculateoldqty.cfm" target="mainFrame">
				Qtybf Recalculate
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recalculateqty.cfm" target="mainFrame">
				Qin Qout Recalculate
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recalculate_gradeqty.cfm" target="mainFrame">
				Grade Qin Qout Recalculate
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/recalculate_locationoldqty.cfm" target="mainFrame">
				Location Qtybf Recalculate
			</a>
		</li>
		<li>
			<a class="oe_secondary_submenu_item" href="/super_menu/updateproject.cfm" target="mainFrame">
				Update Transaction Project
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/checkpricecost.cfm" target="mainFrame">
				Check Item Price & Cost
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/checkfifocost.cfm" target="mainFrame">
				Check Fifo Item Cost
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/updatefifocost/updatefifo.cfm" target="mainFrame">
				Update Fifo Cost
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/super_menu/checkopeningqty.cfm" target="mainFrame">
				Compare Item Opening with Fifo opening
			</a>
		</li>
        <hr />
        <li>
			<a class="oe_secondary_submenu_item" href="/ext/docs/menuMaintenance_view2.cfm?id=" target="mainFrame">
				Help Menu Maintenance
			</a>
		</li>
        <li>
			<a class="oe_secondary_submenu_item" href="/ext/docs/index.cfm" target="mainFrame">
				Help Center
			</a>
		</li>
        
        
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