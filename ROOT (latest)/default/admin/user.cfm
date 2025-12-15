<cfif husergrpid neq "Super" and url.type eq "Create">
<cfquery name="getusercount" datasource="main">
select count(userid) as totaluser from users where userbranch = "#dts#" and usergrpid <> "super" group by userbranch
</cfquery>
<cfquery name="getuserlimit" datasource="main">
SELECT usercount FROM useraccountlimit where companyid = "#dts#"
</cfquery>
<cfif val(getusercount.totaluser) gte val(getuserlimit.usercount)>
<cfif url.comid neq dts>
<cfoutput>
<h1>Error occured. Please contact system administrator.</h1>
<cfabort />
</cfoutput>
</cfif>
<cfoutput>
<h1>Total Licensed User Exceeded. Please contact system administrator.</h1>
<cfabort />
</cfoutput>
</cfif>
</cfif>
<html>
<head>
<title>Create An IMS User</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/pspl_multiselect.js"></script>
<link href="/stylesheet/pspl_multiselect.css" rel="stylesheet" type="text/css">

<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<script for="feedcontact1" event="ondatasetcomplete">show_reply(this.recordset);</script>

<script language="JavaScript">
	function validate()
	{
		if(document.userForm.mode.value!='Delete')
		{   
		<cfoutput>
		var husergrpid = "#lcase(husergrpid)#";
		</cfoutput> 
			if (document.userForm.userPwd.value!=document.userForm.rePwd.value)
			{
				alert("Your passwords does not tally. Please re-enter");
				document.userForm.userPwd.value='';
				document.userForm.rePwd.value='';
				document.userForm.userPwd.focus();
				return false;
			}
			if (document.userForm.mode.value == 'Edit' && husergrpid != 'super' && husergrpid != 'admin'){
				if(document.userForm.olduserPwd.value == ''){
				<cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and lcase(husergrpid) eq "admin">
				<cfelse>
				
					alert("Please enter your old password!");
					return false;
				</cfif>
				}
			}
			<cfif isdefined('url.userId')>
				<cfif url.userId eq "ultracai" or url.userId eq "ultrack" or url.userId eq "ultrasw" or url.userId eq "ultralilian" or url.userId eq "ultratheresa" or url.userId eq "ultrasiong" or url.userId eq "ultranoon" or url.userId eq "ultraalan" or url.userId eq "ultraedwin" or url.userId eq "ultrairene">
				var passval = document.userForm.userPwd.value;
				var passlength = passval.length;
				if (passlength < 10)
				{
				alert("Password length should be more than 10 characters");
				return false;
				}
				</cfif>
				</cfif>
			return true;
		}
	}
	
	function checkpassword(){
		var userid = document.userForm.userID.value;
		var oldpwd = document.userForm.olduserPwd.value;
		document.all.feedcontact1.dataurl="databind/checkpwd.cfm?userid=" + userid + "&oldpwd=" + oldpwd;
		//prompt("D",document.all.feedcontact1.dataurl);
		document.all.feedcontact1.charset=document.charset;
		document.all.feedcontact1.reset();

	}
	
	function show_reply(rset){
 		rset.MoveFirst();
 		var error = rset.fields("error").value;
 		var msg = rset.fields("msg").value;
 		if(error == 1){
 			alert(msg);
 			document.userForm.olduserPwd.value='';
 			document.userForm.olduserPwd.focus();
 		}
 	}
 	
</script>
</head>

<body <cfif url.type eq "Create">onLoad="document.userForm.userID.focus()"<cfelse>onLoad="document.userForm.userPwd.focus()"</cfif>>

<h4>
	<cfif husergrpid eq "Muser">
		<a href="/home2.cfm"><u>Home</u></a>
	</cfif>
</h4>

<cfset mode = isdefined("url.type")>
<!--- ADD ON 050608 --->
<cfquery datasource="#dts#" name="getusergroup">
	select * from <cfif isdefined('url.comid')>#url.comid#.</cfif>userpin2 
	<cfif husergrpid neq "super">
		where level <> 'super'
	</cfif> 
	order by level
</cfquery>
<!--- ADD ON 050608 --->

<cfif url.type eq "Edit">
	<cfquery datasource='main' name="getUsers">
		select * 
		from users 
		where userId='#url.userId#';
	</cfquery>
	
	<cfif getUsers.recordcount gt 0>
		<cfoutput query="getUsers">
			<cfset userId = getUsers.userID>
			<cfset userName = getUsers.userName>
			<cfset userPwd = "">
			<cfset userDept = getUsers.userDept>
			<cfset userGrp = getUsers.userGrpId>
			<cfset userBranch = getUsers.userBranch>
			<cfset userCty = getUsers.userCty>
			<cfset userEmail = getUsers.userEmail>
            <cfset userPhone = getUsers.userPhone>
			<cfset lastlogin = getUsers.lastlogin>
			<cfset userdirectory = getUsers.userdirectory>
			<cfset mode = "Edit">
			<cfset title = "Edit Users">
			<cfset button = "Edit">
			<!--- <cfset locationlist = getUsers.location> --->
			<cfset xlocation = getUsers.location>
            <cfset xitemgroup = getUsers.itemgroup>
            <cfset start_time1=timeformat(getUsers.start_time,"HH:mm:ss")>
            <cfset end_time1=timeformat(getUsers.end_time,"HH:mm:ss")>
            <cfif getUsers.start_time neq "">
				<cfset start_hr=listgetat(start_time1,1,":")>
                <cfset start_min=listgetat(start_time1,2,":")>
            <cfelse>
            	<cfset start_hr="00">
    			<cfset start_min="00">
			</cfif>
            <cfif getUsers.end_time neq "">
				<cfset end_hr=listgetat(end_time1,1,":")>
                <cfset end_min=listgetat(end_time1,2,":")>
            <cfelse>
            	<cfset end_hr="00">
    			<cfset end_min="00">
			</cfif>
		</cfoutput>
		<!--- ADD ON 250908 --->
		<cfquery name="getlocation" datasource="#userDept#">
			select * from iclocation
		</cfquery>
        <cfquery name="getgroup" datasource="#userDept#">
			select * from icgroup
		</cfquery>
	<cfelse>
		<cfset status="Sorry, the user, #url.userId# was ALREADY removed from the system. Process unsuccessful. Please refresh your webpage.">
		
		<form name="done" action="/admin/vUser.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		
		<script language="javascript" type="text/javascript">
			done.submit();
		</script>
	</cfif>
<cfelseif url.type eq "Create">
	<cfset userId = "">
	<cfset userName = "">
	<cfset userPwd = "">
	<cfset userDept = "#dts#">
	<cfset userGrp = "">
	<cfset userBranch = "#dts#">
	<cfset userCty = "">
	<cfset userEmail = "">
    <cfset userPhone = "">
	<cfset lastlogin = "00000000000000">
	<cfset userdirectory = "default">
	<cfset mode = "Create">
	<cfset title = "Create Users">
	<cfset button = "Create">
	<!--- <cfset locationlist = "All_loc"> --->
	<cfset xlocation = "All_loc">
    <cfset xitemgroup = "">
    <cfset start_hr="00">
    <cfset start_min="00">
    <cfset end_hr="00">
    <cfset end_min="00">
	
	<cfquery name="getlocation" datasource="#dts#">
		select * from iclocation
	</cfquery>
    <cfquery name="getgroup" datasource="#dts#">
		select * from icgroup
	</cfquery>
	<cfif isdefined("url.comid")>
		<cfset userBranch=url.comid>
		<cfset userDept=url.comid>
	</cfif>
<cfelseif url.type eq "Delete">
	<cfquery datasource='main' name="getUsers">
		select * 
		from users 
		where userId='#url.userId#';
	</cfquery>
	
	<cfif getUsers.recordcount gt 0>
		<cfoutput query="getUsers">
			<cfset userId = getUsers.userID>
			<cfset userName = getUsers.userName>
			<cfset userPwd = "">
			<cfset userDept = getUsers.userDept>
			<cfset userGrp = getUsers.userGrpID>
			<cfset userBranch = getUsers.userBranch>
			<cfset userCty = getUsers.userCty>
			<cfset userEmail = getUsers.userEmail>
            <cfset userPhone = getUsers.userPhone>
			<cfset lastlogin = getUsers.lastlogin>
			<cfset userdirectory = getUsers.userdirectory>
			<cfset mode = "Delete">
			<cfset title = "Delete Users">
			<cfset button = "Delete">
			<!--- <cfset locationlist = getUsers.location> --->
			<cfset xlocation = getUsers.location>
            <cfset xitemgroup = getUsers.itemgroup>
            <cfset start_time1=timeformat(getUsers.start_time,"HH:mm:ss")>
            <cfset end_time1=timeformat(getUsers.end_time,"HH:mm:ss")>
            <cfif getUsers.start_time neq "">
				<cfset start_hr=listgetat(start_time1,1,":")>
                <cfset start_min=listgetat(start_time1,2,":")>
            <cfelse>
            	<cfset start_hr="00">
    			<cfset start_min="00">
			</cfif>
            <cfif getUsers.end_time neq "">
				<cfset end_hr=listgetat(end_time1,1,":")>
                <cfset end_min=listgetat(end_time1,2,":")>
            <cfelse>
            	<cfset end_hr="00">
    			<cfset end_min="00">
			</cfif>
		</cfoutput>
		<cfquery name="getlocation" datasource="#userDept#">
			select * from iclocation
		</cfquery>
        <cfquery name="getgroup" datasource="#userDept#">
			select * from icgroup
		</cfquery>
	<cfelse>
		<cfset status="Sorry, the user, #url.userId# was ALREADY removed from the system. Process unsuccessful. Please refresh your webpage.">
		
		<form name="done" action="/admin/vUser.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		
		<script language="javascript" type="text/javascript">
			done.submit();
		</script>
	</cfif>
</cfif>

<cfoutput><h1>#title#</h1></cfoutput>

<cfform name="userForm" action="userProcess.cfm" method="post" onsubmit="return validate();">
	<cfoutput>			
	<input type="hidden" name="mode" value="#mode#">
	<cfif isdefined("url.comid")>
		<input type="hidden" name="comid" value="#url.comid#">
	</cfif>
	<table align="center" class="data" width="550px">
    	<tr> 
      		<td>User Id :</td>
      		<td>
			<cfif mode eq "Delete" or mode eq "Edit">
				<h2>#url.userId#</h2>
          		<input type="hidden" name="userID" value="#userId#">
          	<cfelse>
          		<cfinput type="text" name="userID" value="" required="yes" message="Please Enter User ID !" size="20" maxlength="50">
        	</cfif>
			</td>
    	</tr>
		<cfif mode eq "Edit" and husergrpid neq "super" and husergrpid neq "admin">
			<tr> 
      			<td>Old Password :</td>
      			<td>
					<input type="password" name="olduserPwd" value="" maxlength="20" size="20" onChange="checkpassword();">
				</td>
    		</tr>
		</cfif>
    	<tr> 
      		<td>User Password :</td>
      		<td>
				<cfif mode eq "Delete">
					<input type="password" name="userPwd" value="#userPwd#" maxlength="20" size="20" readonly="">
				<cfelse>
           
                 <cfinput type="password" name="userPwd" value="#userPwd#" required="yes" message="Please Enter Password !" maxlength="20" size="20">
	
					
				
				</cfif>
			</td>
    	</tr>
    	<tr> 
      		<td>Re-enter Password :</td>
      		<td>
				<cfif mode eq "Delete">
					<input type="password" name="rePwd" value="#userPwd#" maxlength="20" size="20" readonly="">
				<cfelse>
					<cfinput type="password" name="rePwd" value="#userPwd#" required="yes" message="Please Enter Re-Password !" maxlength="20" size="20">
				</cfif>
			</td>
    	</tr>	
    	<tr> 
      		<td>User Name :</td>
      		<td><cfinput type="text" name="userName" value="#userName#" required="yes" message="Please Enter User Name !" maxlength="50" size="20"></td>
    	</tr>
    	<tr>
      		<td>Country :</td>
			<td>
				<select name="userCty">
					<option value="SINGAPORE"<cfif userCty eq "SINGAPORE">selected</cfif>>SINGAPORE</option>
					<option value="CHINA"<cfif userCty eq "CHINA">selected</cfif>>CHINA</option>
					<option value="HONG KONG"<cfif userCty eq "HONG KONG">selected</cfif>>HONG KONG</option>
					<option value="MALAYSIA"<cfif userCty eq "MALAYSIA">selected</cfif>>MALAYSIA</option>			
					<option value="TAIWAN"<cfif userCty eq "TAIWAN">selected</cfif>>TAIWAN</option>
				</select>
			</td>
		</tr>
    	<tr> 
      		<td>Company ID :</td>
      		<td>
				<cfif husergrpid eq "super">
					<cfinput type="text" name="userbranch" value="#userbranch#" required="yes" message="Please Enter User Branch !" maxlength="50" size="20">
				<cfelse>
					<input type="text" name="userbranch" value="#userbranch#" maxlength="35" size="20" readonly="">
				</cfif>
			</td>
    	</tr>
		
		<cfif husergrpid eq "super">
      		<tr> 
        		<td>Database :</td>
        		<td><cfinput type="text" name="userDept" value="#userDept#" required="yes" message="Please Enter User Database !" maxlength="50" size="20"></td>
      		</tr>
      	<cfelse>
			<input type="hidden" name="userDept" value="#userDept#">
		</cfif>
    	
		<tr> 
      		<td>User Group :</td>
      		<td>
				<cfif husergrpid neq "Admin" and husergrpid neq "super">
          			<cfif husergrpid eq "Suser">
            			<cfset xuserid = "Standard User">
		  			<cfelseif husergrpid eq "guser">
            			<cfset xuserid = "General User">
          			<cfelseif husergrpid eq "luser">
            			<cfset xuserid = "Limited User">
          			<cfelseif husergrpid eq "muser">
            			<cfset xuserid = "Mobile User">
                    <cfelse>
          				<cfset xuserid = husergrpid>
					</cfif>
        
            		<input type="hidden" name="usergrpid" value="#husergrpid#" readonly>
                    
            		<input type="text" name="xusergrpid" value="#xuserid#" readonly>
				<cfelse>
					<select name="userGrpId">
						<cfloop query="getusergroup">
							<cfif getusergroup.level eq "Standard">
								<cfset thisgroupid = "Suser">
								<cfset thisgroupname = "Standard User">	
							<cfelseif getusergroup.level eq "General">	
								<cfset thisgroupid = "guser">
								<cfset thisgroupname = "General User">	
							<cfelseif getusergroup.level eq "Limited">	
								<cfset thisgroupid = "luser">
								<cfset thisgroupname = "Limited User">
							<cfelseif getusergroup.level eq "Mobile">	
								<cfset thisgroupid = "muser">
								<cfset thisgroupname = "Mobile User">
							<cfelseif getusergroup.level eq "Admin">	
								<cfset thisgroupid = "admin">
								<cfset thisgroupname = "Administrator">	
							<cfelseif getusergroup.level eq "Super">	
								<cfset thisgroupid = "super">
								<cfset thisgroupname = "Super User">	
							<cfelse>	
								<cfset thisgroupid = "#getusergroup.level#">
								<cfset thisgroupname = "#getusergroup.level#">				
							</cfif>
							<option value="#thisgroupid#"<cfif usergrp eq thisgroupid>selected</cfif>>#thisgroupname#</option>
						</cfloop>
					</select>
          			<!---select name="userGrpId">
		  				<option value="Suser"<cfif usergrp eq'Suser'>selected</cfif>>Standard User</option>
            			<option value="guser"<cfif usergrp eq'guser'>selected</cfif>>General User</option>
            			<option value="luser"<cfif usergrp eq'luser'>selected</cfif>>Limited User</option>
            			<option value="muser"<cfif usergrp eq'muser'>selected</cfif>>Mobile User</option>
            			<option value="admin"<cfif usergrp eq'admin'>selected</cfif>>Administrator</option>
            			<cfif husergrpid eq "super">
              				<option value="super"<cfif usergrp eq'super'>selected</cfif>>Super User</option>
            			</cfif>
          			</select--->
				</cfif>
			</td>
    	</tr>
      	<tr> 
        	<td>User Email :</td>
        	<td><cfinput name="userEmail" type="text" value="#userEmail#" message="Please Enter Correct Email Address !" validate="email" maxlength="35" size="35"></td>
      	</tr>
        <tr>
        <td>User Phone :</td>
        	<td><cfinput name="userPhone" type="text" value="#userPhone#" maxlength="35" size="35"></td></tr>
        
      	<tr> 
        	<td>User Directory :</td>
        	<td>
				<cfif husergrpid eq "super">
					<cfinput name="userdirectory" type="text" value="#userdirectory#" required="yes" message="Please Enter Correct User Directory !" maxlength="15" size="20">
				<cfelse>
					<input name="userdirectory" type="text" value="#userdirectory#" maxlength="35" size="20" readonly="">
				</cfif>
			</td>
      	</tr>
		<!--- ADD ON 250908, Assign User Location --->
		<tr> 
        	<td>Location :</td>
        	<td>
				<!--- Modified on 141108 --->
				<!--- <span id="sel1_box" class="selBox">
					<select id="sel1" name="sel1" size="5" class="msel" width="15" multiple>
						<option value="All_loc" <cfif locationlist eq "All_loc">selected</cfif>>All Location</option>
						<cfif url.type neq "Create">
							<cfloop query="getlocation">
								<option value="#getlocation.location#" <cfif FindNoCase(getlocation.location,locationlist)>selected</cfif>>#getlocation.location#</option>
							</cfloop>
						<cfelse>
							<cfloop query="getlocation">
								<option value="#getlocation.location#">#getlocation.location#</option>
							</cfloop>
						</cfif>
					</select>
				</span>
				<cfif (url.type neq "Create" and getlocation.recordcount lt 10) or url.type eq "Create">
				<script language="javascript">
					Init( 'sel1', "/images/pspl_multiselect/arrow_on1.gif", "/images/pspl_multiselect/arrow_off1.gif","arrow1", "optionTextBox1", "optionDiv1", "cell1", "cellHover1", "cellSelected1" );
				</script>
				</cfif> --->
				<select id="sel1" name="sel1" width="15">
					<option value="All_loc" <cfif xlocation eq "All_loc">selected</cfif>>All Location</option>
						<cfloop query="getlocation">
							<option value="#getlocation.location#" <cfif xlocation eq getlocation.location>selected</cfif>>#getlocation.location#</option>
						</cfloop>
				</select>
			</td>
      	</tr>
        <cfif husergrpid eq "super" or husergrpid eq "admin">
        <tr> 
        	<td>Item Group :</td>
        	<td>
				<select id="sel2" name="sel2" width="15">
					<option value="" <cfif xitemgroup eq "">selected</cfif>>All Group</option>
						<cfloop query="getgroup">
							<option value="#getgroup.wos_group#" <cfif xitemgroup eq getgroup.wos_group>selected</cfif>>#getgroup.wos_group#</option>
						</cfloop>
				</select>
			</td>
      	</tr>
        </cfif>
        
		<!--- ADD ON 250908 --->
		<cfif url.type eq "Delete">
			<tr> 
                <td>Remark :</td>
                <td>
                    <textarea name="remark" cols="40" rows="4"></textarea>
                </td>
            </tr>
		</cfif>
      	<tr> 
        	<td>Start Time :</td>
        	<td>
            	<select name="start_hr">
                	<cfloop from="0" to="23" index="a">
                		<option value="#numberformat(a,'00')#" <cfif start_hr eq a>selected</cfif>>#numberformat(a,"00")#</option>
                    </cfloop>
                </select>&nbsp;:
                <select name="start_min">
                	<cfloop from="0" to="60" index="b">
                		<option value="#numberformat(b,'00')#" <cfif start_min eq b>selected</cfif>>#numberformat(b,"00")#</option>
                    </cfloop>
                </select>
			</td>
      	</tr>
        
      	<tr> 
        	<td>End Time :</td>
        	<td>
            	<select name="end_hr">
                	<cfloop from="0" to="23" index="a">
                		<option value="#numberformat(a,'00')#" <cfif end_hr eq a>selected</cfif>>#numberformat(a,"00")#</option>
                    </cfloop>
                </select>&nbsp;:
                <select name="end_min">
                	<cfloop from="0" to="60" index="b">
                		<option value="#numberformat(b,'00')#" <cfif end_min eq b>selected</cfif>>#numberformat(b,"00")#</option>
                    </cfloop>
                </select>
			</td>
      	</tr>
      	<tr> 
        	<input name="lastlogin"  type="hidden" value="#lastlogin#">
        	<td colspan="2" align="center"><input type="submit" value="#button#"></td>
      	</tr>
	</table>
	</cfoutput>			
</cfform>
		
</body>
</html>