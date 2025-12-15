<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Testing</title>
<link rel="stylesheet" type="text/css" href="/newinterface2/css1.css" />
<script language="javascript" type="text/javascript" src="/scripts/change_left_menunew.js"></script>

</head>

<script type="text/javascript" src="/scripts/prototypenew.js" ></script>
<script type="text/javascript">
<!--
function popup(url) 
{
 params  = 'width='+screen.width;
 params += ', height='+screen.height;
 params += ', top=0, left=0, status=yes,menubar=no , location = no'
 params += ', fullscreen=yes,scrollbars=yes';

 newwin=window.open(url,'', params);
 if (window.focus) {newwin.focus()}
 return false;
}
// -->
</script>

<body class="netiquette" onload="SwitchMenu('sub6')">
<cfquery name="getGeneralInfo" datasource="#dts#">
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
<cfif getGeneralInfo.dflanguage eq 'english'>
<cfset menutitle['#getlanguage.no#']=getlanguage.eng>
<cfelseif getGeneralInfo.dflanguage eq 'sim_ch'>
<cfset menutitle['#getlanguage.no#']=getlanguage.sim_ch>
<cfelseif getGeneralInfo.dflanguage eq 'tra_ch'>
<cfset menutitle['#getlanguage.no#']=getlanguage.tra_ch>
</cfif>
</cfloop>


<cfoutput>
<div style="overflow:hidden;">
<div class="secondary_menu">
<div id="masterdiv">
<cfif getpin2.h2000 eq "T">
	

    <cfif  getpin2.h28C0 eq "T" or getpin2.h2100 eq "T" or getpin2.h2200 eq "T" or getpin2.h2860 eq "T">
    
    <li onClick="SwitchMenu('sub2')">
	<a href="/purchasediagrammenu.cfm" target="mainFrame" class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[148]#</cfoutput>"><cfoutput>#menutitle[148]#</cfoutput></a>
	<!---<a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[148]#</cfoutput>"><cfoutput>#menutitle[148]#</cfoutput></a>---></li>
<span id="sub2" style="display:none;" class="submenu">
    	<cfif getpin2.h2860 eq 'T'>
                <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=po" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lPO#
                    <cfelse>
                    <cfoutput>#menutitle[68]#</cfoutput>
                </cfif>">
                
                <cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lPO#
                    <cfelse>
                    <cfoutput>#menutitle[68]#</cfoutput>
                </cfif>
				</a>
				</li>
        </cfif>
    
		<cfif getpin2.h2100 eq "T">
			<li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=rc" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lRC#
                    <cfelse>
                    <cfoutput>#menutitle[64]#</cfoutput>
                    </cfif>">
					<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lRC#
                    <cfelse>
                    <cfoutput>#menutitle[64]#</cfoutput>
                    </cfif>
				</a>
			</li>
		</cfif>
		<cfif getpin2.h2200 eq "T">
			<li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=pr" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lPR#
                    <cfelse>
                    <cfoutput>#menutitle[65]#</cfoutput>
                    </cfif>">
					<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lPR#
                    <cfelse>
                    <cfoutput>#menutitle[65]#</cfoutput>
                    </cfif>
				</a>
			</li>
		</cfif>
		
        </span>
        </cfif>
		
                <li onClick="SwitchMenu('sub6')">
				<a href="/salesdiagrammenu.cfm" target="mainFrame" class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[155]#</cfoutput>"><cfoutput>#menutitle[155]#</cfoutput></a>
                
				<!---<a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[155]#</cfoutput>"><cfoutput>#menutitle[155]#</cfoutput></a>---></li>
                <span id="sub6" style="display:none;" class="submenu">
        
        
        <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/maintenance/dailyopening/s_dailycountertable.cfm" target="mainFrame" title="Cash Recording maintenance">
					Cash Recording maintenance
				</a>
		</li>
       
		       
        
        <li>
				<a class="oe_secondary_submenu_item" href="/newbody.cfm" target="mainFrame" onclick="popup('/#HDir#/transaction/POS/index.cfm?first=true')" title="POS Transaction">
				POS transaction
				</a>
		</li>
        <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/attendance/attendancetable.cfm" target="mainFrame" title="Deposit">
					Staff Attendance
				</a>
		</li>
        
        <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/deposit/deposittable.cfm" target="mainFrame" title="Deposit">
					Deposit
				</a>
		</li>
        <cfif hcomid eq 'tcds_i'>
        <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/reserve/s_reservetable.cfm" target="mainFrame" title="Reserve">
					Reserve
				</a>
		</li>
        </cfif>
		<cfif getpin2.h2880 eq "T">
			<li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=SO" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lSO#
                    <cfelse>
                    <cfoutput>#menutitle[156]#</cfoutput>
                    </cfif>">
					<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lSO#
                    <cfelse>
                    <cfoutput>#menutitle[156]#</cfoutput>
                    </cfif>
				</a>
			</li>
		</cfif>
		<cfif getpin2.h2300 eq "T">
			<li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=do" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lDO#
                    <cfelse>
                    <cfoutput>#menutitle[66]#</cfoutput>
                    </cfif>">
					<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lDO#
                    <cfelse>
                    <cfoutput>#menutitle[66]#</cfoutput>
                    </cfif>
				</a>
			</li>
		</cfif>
		<cfif getpin2.h2400 eq "T">
			<li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=inv" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lINV#
                    <cfelse>
                    <cfoutput>#menutitle[45]#</cfoutput>
                    </cfif>">
					<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lINV#
                    <cfelse>
                    <cfoutput>#menutitle[45]#</cfoutput>
                    </cfif>
				</a>
			</li>
		</cfif>	
		
        <cfif getpin2.h2500 eq 'T'>
                 <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=cs" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lCS#
                    <cfelse>
                    <cfoutput>#menutitle[46]#</cfoutput>
                </cfif>">
                <cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lCS#
                    <cfelse>
                    <cfoutput>#menutitle[46]#</cfoutput>
                </cfif>
				</a>
				</li>
        </cfif>
        <cfif getpin2.h2600 eq 'T'>
                 <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=cn" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lCN#
                    <cfelse>
                    <cfoutput>#menutitle[47]#</cfoutput>
                </cfif>">
                <cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lCN#
                    <cfelse>
                    <cfoutput>#menutitle[47]#</cfoutput>
                </cfif>
				</a>
				</li>
        </cfif>
<cfif getpin2.h2700 eq "T">
			<li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/transaction.cfm?tran=dn" target="mainFrame" title="<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lDN#
                    <cfelse>
                    <cfoutput>#menutitle[48]#</cfoutput>
                    </cfif>">
					<cfif getGeneralInfo.dflanguage eq 'english'>
               				#getGeneralInfo.lDN#
                    <cfelse>
                    <cfoutput>#menutitle[48]#</cfoutput>
                    </cfif>
				</a>
			</li>
		</cfif>

                 <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/expressadjustmenttran/index.cfm" target="mainFrame" title="<cfoutput>#menutitle[154]#</cfoutput>">
						<cfoutput>#menutitle[154]#</cfoutput>
				</a>
				</li>

             
            </span>
            
            <cfif getpin2.h2820 eq 'T' or getpin2.h2830 eq 'T' or getpin2.h2840 eq 'T'>
                <li onClick="SwitchMenu('sub8')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="<cfoutput>#menutitle[163]#</cfoutput>"><cfoutput>#menutitle[163]#</cfoutput></a></li>
                <span id="sub8" style="display:none;" class="submenu">
                
                <cfif getpin2.h2820 eq 'T'>
                <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/siss.cfm?tran=ISS" target="mainFrame" title="<cfoutput>#menutitle[150]#</cfoutput>">
						<cfoutput>#menutitle[150]#</cfoutput>
				</a>
				</li>
                </cfif>
                
                <cfif getpin2.h2830 eq 'T'>
                <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/siss.cfm?tran=OAI" target="mainFrame" title="<cfoutput>#menutitle[151]#</cfoutput>">
						<cfoutput>#menutitle[151]#</cfoutput>
				</a>
				</li>
                </cfif>
                <cfif getpin2.h2840 eq 'T'>
                <li>
				<a class="oe_secondary_submenu_item" href="/#HDir#/transaction/siss.cfm?tran=OAR" target="mainFrame" title="<cfoutput>#menutitle[152]#</cfoutput>">
						<cfoutput>#menutitle[152]#</cfoutput>
				</a>
				</li>
                </cfif>

                </span>
            </cfif>
            
                <li onClick="SwitchMenu('sub7')"><a class="oe_secondary_menu_item" style="cursor:pointer" title="POS SYNC"><cfoutput>POS SYNC</cfoutput></a></li>
                <span id="sub7" style="display:none;" class="submenu">
                <li>
                <cfquery name="getposcontrol" datasource="#dts#">
                select * from pospayment
                </cfquery>
                
         		<cfif getposcontrol.possync eq '2'>
                <a class="oe_secondary_submenu_item" href="/default/admin/posnetsync/index.cfm" target="mainFrame" >POS Net Sync</a>		
                <cfelse>
        <a class="oe_secondary_submenu_item" href="/default/admin/possync/index.cfm" target="mainFrame" >POS Sync</a>			
        		</cfif>
        </li>
          <li>
        <a class="oe_secondary_submenu_item" href="/default/transaction/pospayment/index.cfm" target="mainFrame" >POS Control</a>
        </li>
        <li>
        <a class="oe_secondary_submenu_item" href="/default/transaction/POSSubmission/POSSubmission.cfm" target="mainFrame" >POS Submission</a>
        </li>       
            </span>

   
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