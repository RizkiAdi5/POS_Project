<cftry>
	<cfquery datasource="#dts#" name="tryalter">
    	select newTransac2 from gsetup
    </cfquery>	
<cfcatch>
	<cfquery datasource="#dts#" name="alter">
    	ALTER TABLE `gsetup` ADD COLUMN `newTransac2` VARCHAR(1) DEFAULT '' ;
    </cfquery>	
</cfcatch>

</cftry>
<style type="text/css">
body{
	background-color: #eff8ff;
	font-family: Arial;

}

li{
	font-size: 9px;
}

.menutitle{
	cursor:hand;
	margin-bottom: 5px;
	background-color:#999999;
	color:#FFFFFF;
	width:120px;
	padding:2px;
	text-align:center;
	font-weight:bold;
	font-size: 11px;
	border:1px solid #FFFFFF;
	font-family: Tahoma, Arial, Times New Roman;
}

.submenu{
	margin-bottom: 0.5em;
	list-style-image:  url(../foldoutmenu2_arrow.gif);
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

</script>

<cfprocessingdirective pageencoding="UTF-8">
</head>

<cfquery datasource="#dts#" name="getgeneral">
    	select * from gsetup
</cfquery>

<cfif getgeneral.dflanguage NEQ "english">
	<cfset menunameA=getgeneral.dflanguage>	
<cfelse>
	<cfset menunameA="menu_name">
</cfif>

<cfquery datasource="#main#" name="getmenu1">
 SELECT a.menu_id AS menu_id, a.#menunameA# AS menu_name,a.menu_url AS menu_url
 FROM menu as a left join #dts#.userpin as b on a.menu_id = b.menu_id
 where a.menu_level= '1'
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

<body>
	
	<div id="masterdiv">
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
	<div class="menutitle" onClick="SwitchMenu('sub<cfoutput>#i#</cfoutput>')"><cfoutput>#menuname['#getmenu1.menu_id#']#</cfoutput></div>
	<span class="submenu" id="sub<cfoutput>#i#</cfoutput>">

		<cfset parentID = getmenu1.menu_id>
		<cfquery datasource="#main#" name="getmenu2">
			SELECT a.menu_id AS menu_id, a.#menunameA# AS menu_name,a.menu_url AS menu_url 
            FROM menu as a left join #dts#.userpin as b on a.menu_id = b.menu_id 
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
            <!--- and (a.menu_id<>212 and a.menu_id<>227 and a.menu_id<>213 and a.menu_id<>228) ---> <!--- Trade Receivables & Open Item Trade Receivables & Trade Payables & Open Item Trade Payables --->
			order by a.menu_order
		</cfquery>
		<!--- level 2 --->
		<Cfloop query="getmenu2">
			<cfset menuname['#getmenu2.menu_id#']=getmenu2.menu_name>
            <cfif getgeneral.dflanguage eq 'sim_ch' OR getgeneral.dflanguage eq 'tra_ch'>
                <cfset L2size = "+1">
			<cfelseif getgeneral.dflanguage eq 'thai'>
                <cfset L2size = "-1">            
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
            <cfset L2size = "-1">
            <cfelseif getgeneral.dflanguage eq 'viet'>
            <cfset menuname['#getmenu2.menu_id#']=getmenu2.viet>
            <cfset L2size = "-2">
            <cfelseif getgeneral.dflanguage eq 'malay'>
            <cfset menuname['#getmenu2.menu_id#']=getmenu2.malay>
            <cfset L2size = "-2">             
            </cfif> --->
            
		<cfif getgeneral.ctycode eq "MYR" AND getmenu2.menu_id eq "149">
            <cfset menuname['#getmenu2.menu_id#'] = replace(menuname['#getmenu2.menu_id#'],"IRAS","GAF")>
        </cfif> 

		<cfif getmenu2.menu_name eq "hr">
			<hr>
		<cfelseif getmenu2.menu_url eq "">
		<br/>
		<font size="<cfoutput>#L2size#</cfoutput>" color="##000099"><strong>- &nbsp;<cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput>&nbsp; -</strong></font>
		<cfelse>
		<li><a href="<cfoutput>#getmenu2.menu_url#</cfoutput>" target="mainFrame"><font size="<cfoutput>#L2size#</cfoutput>" color="##0000FF"><u><cfoutput>#menuname['#getmenu2.menu_id#']#</cfoutput></u></font></a></li>
		</cfif>	
			
				<cfset parentID = getmenu2.menu_id>
				<cfquery datasource="#main#" name="getmenu3">
					SELECT a.menu_id AS menu_id, a.#menunameA# AS menu_name,a.menu_url AS menu_url 
                    FROM menu as a left join #dts#.userpin as b on a.menu_id = b.menu_id 
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
                    <!--- and (a.menu_id<>212 and a.menu_id<>227 and a.menu_id<>213 and a.menu_id<>228) ---> <!--- Trade Receivables & Open Item Trade Receivables & Trade Payables & Open Item Trade Payables --->
					order by a.menu_order
				</cfquery>
				<!--- level 3 --->
				<Cfloop query="getmenu3">
					<cfset menuname['#getmenu3.menu_id#']=getmenu3.menu_name>
                    <cfif getgeneral.dflanguage eq 'sim_ch' OR getgeneral.dflanguage eq 'tra_ch'>
                        <cfset L3size = "+1">
                    <cfelseif getgeneral.dflanguage eq 'thai'>
                        <cfset L3size = "-1">            
                    <cfelse>
                        <cfset L3size = "-2">
                    </cfif>                
                <!--- <cfif getgeneral.dflanguage eq 'english'>
				<cfset menuname['#getmenu3.menu_id#']=getmenu3.menu_name>
                <cfset L3size = "-2">
                <cfelseif getgeneral.dflanguage eq 'sim_ch'>
                <cfset menuname['#getmenu3.menu_id#']=getmenu3.sim_ch>
                <cfset L3size = "+1">
                <cfelseif getgeneral.dflanguage eq 'tra_ch'>
                <cfset menuname['#getmenu3.menu_id#']=getmenu3.tra_ch>
                <cfset L3size = "+1">
                <cfelseif getgeneral.dflanguage eq 'indo'>
                <cfset menuname['#getmenu3.menu_id#']=getmenu3.indo>
                <cfset L3size = "-2">
				<cfelseif getgeneral.dflanguage eq 'thai'>
				<cfset menuname['#getmenu3.menu_id#']=getmenu3.thai>
                <cfset L3size = "-1">
                <cfelseif getgeneral.dflanguage eq 'viet'>
                <cfset menuname['#getmenu3.menu_id#']=getmenu3.viet>
                <cfset L3size = "-2">
                <cfelseif getgeneral.dflanguage eq 'malay'>
                <cfset menuname['#getmenu3.menu_id#']=getmenu3.malay>
                <cfset L3size = "-2">                 
                </cfif>  --->              

					<cfif getmenu3.menu_name eq "hr">
						<hr>
					<cfelseif getmenu3.menu_url eq "">
					<br/>
					<font size="<cfoutput>#L3size#</cfoutput>" color="##000099"><strong>- &nbsp;<cfoutput>#menuname['#getmenu3.menu_id#']#</cfoutput>&nbsp; -</strong></font>
					<cfelse>
					<li><a href="<cfoutput>#getmenu3.menu_url#</cfoutput>" target="mainFrame"><font size="<cfoutput>#L3size#</cfoutput>" color="##0000FF"><u><cfoutput>#menuname['#getmenu3.menu_id#']#</cfoutput></u></font></a></li>
					</cfif>						
				
						<cfset parentID = getmenu3.menu_id>
						<cfquery datasource="#main#" name="getmenu4">
							SELECT a.menu_id AS menu_id, a.#menunameA# AS menu_name,a.menu_url AS menu_url 
                            FROM menu as a left join #dts#.userpin as b on a.menu_id = b.menu_id 
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
                            <!--- and (a.menu_id<>212 and a.menu_id<>227 and a.menu_id<>213 and a.menu_id<>228) ---> <!--- Trade Receivables & Open Item Trade Receivables & Trade Payables & Open Item Trade Payables --->
							order by a.menu_order
						</cfquery>
						<!--- level 4 --->
						<Cfloop query="getmenu4">
							<cfset menuname['#getmenu4.menu_id#']=getmenu4.menu_name>
                            <cfif getgeneral.dflanguage eq 'sim_ch' OR getgeneral.dflanguage eq 'tra_ch'>
                                <cfset L4size = "+1">
                            <cfelseif getgeneral.dflanguage eq 'thai'>
                                <cfset L4size = "-1">            
                            <cfelse>
                                <cfset L4size = "-2">
                            </cfif>                        
                        <!--- <cfif getgeneral.dflanguage eq 'english'>
						<cfset menuname['#getmenu4.menu_id#']=getmenu4.menu_name>
                        <cfset L4size = "-2">
                        <cfelseif getgeneral.dflanguage eq 'sim_ch'>
                        <cfset menuname['#getmenu4.menu_id#']=getmenu4.sim_ch>
                        <cfset L4size = "+1">
                        <cfelseif getgeneral.dflanguage eq 'tra_ch'>
                        <cfset menuname['#getmenu4.menu_id#']=getmenu4.tra_ch>
                        <cfset L4size = "+1">
                        <cfelseif getgeneral.dflanguage eq 'indo'>
                        <cfset menuname['#getmenu4.menu_id#']=getmenu4.indo>
                        <cfset L4size = "-2">
						<cfelseif getgeneral.dflanguage eq 'thai'>
                        <cfset menuname['#getmenu4.menu_id#']=getmenu4.thai>
                        <cfset L4size = "-1">
                        <cfelseif getgeneral.dflanguage eq 'viet'>
                        <cfset menuname['#getmenu4.menu_id#']=getmenu4.viet>
                        <cfset L4size = "-2">
                        <cfelseif getgeneral.dflanguage eq 'malay'>
                        <cfset menuname['#getmenu4.menu_id#']=getmenu4.malay>
                        <cfset L4size = "-2">                        
                        </cfif> --->



							<cfif getmenu4.menu_name eq "hr">
								<hr>
							<cfelseif getmenu4.menu_url eq "">
							<br/>
							<font size="<cfoutput>#L4size#</cfoutput>" color="##000099"><strong>- &nbsp;<cfoutput>#menuname['#getmenu4.menu_id#']#</cfoutput>&nbsp; -</strong></font>
							<cfelse>
							<li><a href="<cfoutput>#getmenu4.menu_url#</cfoutput>" target="mainFrame"><font size="<cfoutput>#L4size#</cfoutput>" color="##0000FF"><u><cfoutput>#menuname['#getmenu4.menu_id#']#</cfoutput></u></font></a></li>
							</cfif>								
							
						</cfloop>
						
						<!--- level 4 end --->
				</cfloop>
				<!--- level 3 end --->
			
		</cfloop>
		<!--- level 2 end --->
	</span>	

	</cfloop>
	<!--- level 1 end --->
	</div>
	
<cfquery datasource="#main#" name="getmenu51">
 SELECT * FROM menu as a left join #dts#.userpin as b on a.menu_id = b.menu_id
 where b.menu_id= '51'
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
<cfquery datasource="#main#" name="getmenu50">
 SELECT * FROM menu as a left join #dts#.userpin as b on a.menu_id = b.menu_id
 where b.menu_id='50'
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

<cfquery datasource="#dts#" name="getgsetup">
	select * from gsetup
</cfquery>
<!---<cfquery datasource="#main#" name="getmenu5">
	SELECT * FROM menu
</cfquery>
	<cfloop query="getmenu5">
    	<cfif getgeneral.dflanguage eq 'english'>
            <cfset menuname2['#getmenu5.menu_id#']=getmenu5.menu_name>
            <cfelseif getgeneral.dflanguage eq 'sim_ch'>
            <cfset menuname2['#getmenu5.menu_id#']=getmenu5.sim_ch>
            <cfelseif getgeneral.dflanguage eq 'tra_ch'>
            <cfset menuname2['#getmenu5.menu_id#']=getmenu5.tra_ch>
            </cfif>
           </cfloop>--->
    	<cfif getgeneral.dflanguage eq 'english'>
           	<cfset menuMyTran = "*Tranc. File Maintenance">
            <cfset menuMyTranFull = "*Full">
            <cfset menuMyExpTran = "Express Add Transaction">
            <cfset mymenuRefesh = "*Refresh">
        <cfelseif getgeneral.dflanguage eq 'sim_ch'>
           	<cfset menuMyTran = "* 凭证输入">
            <cfset menuMyTranFull = "* 满">
            <cfset menuMyExpTran = "极速添加交易">
            <cfset mymenuRefesh = "* 刷新">
        <cfelseif getgeneral.dflanguage eq 'tra_ch'>
           	<cfset menuMyTran = "* 憑證輸入">
            <cfset menuMyTranFull = "* 滿">
            <cfset menuMyExpTran = "極速添加交易">
            <cfset mymenuRefesh = "* 刷新">
		<cfelseif getgeneral.dflanguage eq 'indo'>
           	<cfset menuMyTran = "*Buat Transaksi">
            <cfset menuMyTranFull = "*Transaksi Lengkap">
            <cfset menuMyExpTran = "Tambah Transaksi Cepat">
            <cfset mymenuRefesh = "*Refresh"> 
		<cfelseif getgeneral.dflanguage eq 'thai'>
           	<cfset menuMyTran = "*การบำรุงรักษา การทำธุรกรรม">
            <cfset menuMyTranFull = "* เต็ม">
            <cfset menuMyExpTran = "แสดงเพิ่มการทำธุรกรรม">
            <cfset mymenuRefesh = "*Refresh"> 
		<cfelseif getgeneral.dflanguage eq 'viet'>
           	<cfset menuMyTran = "*giao dịch bảo trì">
            <cfset menuMyTranFull = "*đầy đủ">
            <cfset menuMyExpTran = "Thêm hiện giao dịch">
            <cfset mymenuRefesh = "*Refresh">
		<cfelseif getgeneral.dflanguage eq 'malay'>
           	<cfset menuMyTran = "*Penyelenggaraan Transaksi">
            <cfset menuMyTranFull = "*Penuh">
            <cfset menuMyExpTran = "Penyelenggaraan Transaksi">
            <cfset mymenuRefesh = "*Refresh">                                              
		</cfif>

<cfif getmenu50.recordcount neq 0>
<cfif getmenu51.recordcount neq 0>
<cfif getgsetup.newTransac eq 'Y'>
	
<!--- <input type="button" name="mybutton3" value="<cfoutput>#menuMyTran#</cfoutput>" style="font-size:9; text-align:left; width:110px" 
        onclick="javascript:ColdFusion.Window.show('myTran')"> --->
        
<input type="button" name="mybutton4" value="<cfoutput>#menuMyTran#<!--- #menuMyTranFull# ---></cfoutput>" style="font-size:9; text-align:left; width:110px<!--- 30px --->" 
        onclick="javascript:popup('/trans.cfm')">
</cfif>
</cfif>
</cfif>
<!---<Cfif dts eq "bakersoven11_a">
<input type="button" name="mybutton3" value="<cfoutput>#menuMyTran#</cfoutput>" style="font-size:9; text-align:left; width:110px" 
        onclick="javascript:ColdFusion.Window.show('myTran')">
<input type="button" name="mybutton4" value="<cfoutput>#menuMyTranFull#</cfoutput>" style="font-size:9; text-align:left; width:30px" 
        onclick="javascript:popup3('../transaction-main-full.cfm','transaction')">
</cfif>--->
<br/>
<cfif dts eq 'kingston_a' or dts eq 'demo_a' or dts eq 'iaf_a' >
<a href="/transaction/expressTransaction/exPressTransactionMain.cfm" target="mainFrame" onMouseOver="this.style.cursor='hand'"><font style="font-size:9; text-align:left; width:90px"><cfoutput>#menuMyExpTran#</cfoutput></font></a>
<a href="/transaction/expressTransaction/exPressTransactionMain.cfm" target="mainFrame" onMouseOver="this.style.cursor='hand'"><font style="font-size:9; text-align:left; width:40px">Full</font></a>
<cfelse>
<cfif getgsetup.newTransac2 eq "Y">
<a href="/transaction/expressTransaction/exPressTransactionMain.cfm" target="mainFrame" onMouseOver="this.style.cursor='hand'"><font style="font-size:9; text-align:left; width:90px"><cfoutput>#menuMyExpTran#</cfoutput></font></a>
</cfif>

</cfif>
<!---<cfif husergrpid eq "super">
						&nbsp;&nbsp;<li><a href="../transaction2/transaction-main.cfm" target="mainFrame"><font color="##0000FF"><u>Transaction *</u></font></a></li>
&nbsp;&nbsp;<li><a href="../calculator/Calculator.cfm" target="mainFrame"><font color="##0000FF"><u>Calculator *</u></font></a></li>
<br>
<li><a href="../transaction/transactionFileMaintenance/transaction-main.cfm?type1=" target="mainFrame"><font color="##0000FF"><u>Transaction2 *</u></font></a></li>
<input type="button" name="mybutton3" value="Open Window" 
        onclick="javascript:ColdFusion.Window.show('myTran')">
												
</cfif>--->


<!--- Custom Applications 
<cfif session.cust_set eq '1'>
<div class="menutitle" onClick="SwitchMenu('sub7')">Customised Functions/Reports</div>
	<span class="submenu" id="sub7">
	<iframe name='iframe1' src='../cust_dir/<cfoutput>#session.cust_path#</cfoutput>/cmenu.cfm' width="120" scrolling="no" frameborder="0" marginwidth="0"></iframe>
	</span>
</div>
</cfif>--->
<input type="button" name="mybutton3" value="<cfoutput>#mymenuRefesh#</cfoutput>" style="font-size:9; text-align:left; width:110px"
        onclick="window.location='http://<cfoutput>#cgi.SERVER_NAME#</cfoutput>/index.cfm'">
<cfinclude template="/menu/chat.cfm">




