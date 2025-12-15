<cfif husergrpid eq "Super">
	<cfoutput>
	<div class="menutitle" onClick="SwitchMenu('sub7')">Super Menu</div>
	
	<span class="submenu" id="sub7">
		<cfif findnocase("junyong",HUserID) or findnocase("vincent",HUserID) or findnocase("weesiong",HUserID)>
			<li>
				<a href="/super_menu/amssetup.cfm" target="mainFrame">
					Setup AMS Server
				</a>
			</li>
			<li>
				<a href="/super_menu/add_special_maintenance.cfm" target="mainFrame">
					Add Special Maintenance
				</a>
			</li>
			<li>
				<a href="/super_menu/add_special_transaction.cfm" target="mainFrame">
					Add Special Transaction
				</a>
			</li>
			<li>
				<a href="/super_menu/add_special_print_bills.cfm" target="mainFrame">
					Add Special Print Bills
				</a>
			</li>
			<li>
				<a href="/super_menu/add_special_enquire.cfm" target="mainFrame">
					Add Special Enquire
				</a>
			</li>
			<li>
				<a href="/super_menu/add_special_report.cfm" target="mainFrame">
					Add Special Report
				</a>
			</li>
		</cfif>
		<li>
			<a href="/super_menu/amsuser.cfm" target="mainFrame">
				Setup AMS Users
			</a>
		</li>
        <li>
			<a href="/super_menu/userlimit.cfm" target="mainFrame">
				Setup Account Users Limit
			</a>
		</li>
        <li>
			<a href="/super_menu/unblockbrute.cfm" target="mainFrame">
				Unblock Brute Users
			</a>
		</li>
		<hr/>
		<li>
			<a href="/#HDir#/admin/user.cfm?type=Create" target="mainFrame">
				To Create An IMS User
			</a>
		</li>
		<li>
			<a href="/#HDir#/admin/vuser1.cfm?all=all" target="mainFrame">
				To View IMS Users
			</a>
		</li>
		<hr/>
		<li>
			<a href="/super_menu/upload.cfm" target="mainFrame">
				Upload .CFR Bills
			</a>
		</li>
		<!--- ADD ON 18-05-2009 --->
		<li>
			<a href="/super_menu/addbillformat.cfm" target="mainFrame">
				Add .CFR Bills
			</a>
		</li>
        <li>
			<a href="/super_menu/importing/uploadfile.cfm" target="mainFrame">
				Upload and Import Dbf File to System
			</a>
		</li>
		<hr/>
        <cfif left(huserid,5) eq "ultra">
        <li>
			<a href="/super_menu/backupdata/index.cfm" target="mainFrame">
				BACKUP
			</a>
		</li>
        <li>
			<a href="/super_menu/backupdata/restore.cfm" target="mainFrame">
				RESTORE
			</a>
		</li>
        <li>
			<a href="/super_menu/emaildb.cfm" target="mainFrame">
				Email Backup
			</a>
		</li>
		</cfif>
		<li>
			<a href="/super_menu/fifo_costing_recalculate.cfm" target="mainFrame">
				FIFO Costing Calculation After Year-End
			</a>
		</li>
		<li>
			<a href="/super_menu/recalculatelocationqty.cfm" target="mainFrame">
				Location QtyBf Calculation After Year-End
			</a>
		</li>
      <!---   <li>
			<a href="/super_menu/calculate_gradeqty.cfm" target="mainFrame">
				Grade QtyBf Calculation After Year-End
			</a>
		</li> --->
		<hr/>
		<li>
			<a href="/super_menu/import.cfm" target="mainFrame">
				Import Table
			</a>
		</li>
		<li>
			<a href="/super_menu/match_comment.cfm" target="mainFrame">
				Match Comment
			</a>
		</li>
		<li>
			<a href="/super_menu/insertuserpin.cfm" target="mainFrame">
				Add UserPIN
			</a>
		</li>
		<!--- <li>
			<a href="/super_menu/updateoperiod.cfm" target="mainFrame">
				Update Old Period
			</a>
		</li> --->
		<cfif findnocase("swdemo",HUserID) or findnocase("weesiong",HUserID)>
			<li>
				<a href="/super_menu/deleteusers.cfm" target="mainFrame">
					Delete Users
				</a>
			</li>
		</cfif>
		<cfif findnocase("swdemo",HUserID) or findnocase("swneti",HUserID)>
			<li>
				<a href="/super_menu/insertcolumn.cfm" target="mainFrame">
					Insert Column
				</a>
			</li>
		</cfif>
		<li>
			<a href="/super_menu/menutable.cfm" target="mainFrame">
				Menu Maintenance
			</a>
		</li>
		<li>
			<a href="/super_menu/info_view.cfm" target="mainFrame">
				Information Profile
			</a>
		</li>
		<li>
			<a href="/super_menu/startupwarning.cfm" target="mainFrame">
				Startup Warning Setting
			</a>
		</li>
		<hr/>
		<li>
			<a href="/super_menu/recover_update_menu.cfm" target="mainFrame">
				Recover Update
			</a>
		</li>
		<li>
			<a href="/super_menu/recovery.cfm" target="mainFrame">
				Recover Year End 
			</a>
		</li>
		<li>
			<a href="/super_menu/recalculateperiod.cfm" target="mainFrame">
				Recalculate Period
			</a>
		</li>
		<li>
			<a href="/super_menu/recalculateoldqty.cfm" target="mainFrame">
				Qtybf Recalculate
			</a>
		</li>
		<li>
			<a href="/super_menu/recalculateqty.cfm" target="mainFrame">
				Qin Qout Recalculate
			</a>
		</li>
		<li>
			<a href="/super_menu/recalculate_gradeqty.cfm" target="mainFrame">
				Grade Qin Qout Recalculate
			</a>
		</li>
		<li>
			<a href="/super_menu/recalculate_locationoldqty.cfm" target="mainFrame">
				Location Qtybf Recalculate
			</a>
		</li>
		<li>
			<a href="/super_menu/updateproject.cfm" target="mainFrame">
				Update Transaction Project
			</a>
		</li>
        <li>
			<a href="/super_menu/checkpricecost.cfm" target="mainFrame">
				Check Item Price & Cost
			</a>
		</li>
        <li>
			<a href="/super_menu/checkfifocost.cfm" target="mainFrame">
				Check Fifo Item Cost
			</a>
		</li>
        <li>
			<a href="/super_menu/updatefifocost/updatefifo.cfm" target="mainFrame">
				Update Fifo Cost
			</a>
		</li>
        <li>
			<a href="/super_menu/checkopeningqty.cfm" target="mainFrame">
				Compare Item Opening with Fifo opening
			</a>
		</li>
        <hr />
        <li>
			<a href="/ext/docs/menuMaintenance_view2.cfm?id=" target="mainFrame">
				Help Menu Maintenance
			</a>
		</li>
        <li>
			<a href="/ext/docs/index.cfm" target="mainFrame">
				Help Center
			</a>
		</li>
        
        
	</span>
	</cfoutput>
</cfif>