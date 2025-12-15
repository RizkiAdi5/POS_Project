<html>
<head>
	<title>Customer Page</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
    
    <script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>
<script type="text/javascript" src="/scripts/jscripts/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript" src="/scripts/highslide/highslide.js"></script>
<link rel="stylesheet" type="text/css" href="/scripts/highslide/highslide.css" />
<script type="text/javascript">
//<![CDATA[
hs.registerOverlay({
	html: '<div class="closebutton" onclick="return hs.close(this)" title="Close"></div>',
	position: 'top right',
	fade: 2 // fading the semi-transparent overlay looks bad in IE
});


hs.graphicsDir = '/scripts/highslide/graphics/';
hs.wrapperClassName = 'borderless';
//]]>
</script>
    
</head>
<body>
<script language="JavaScript">
	
	function add_option(pic_name)
	{
		var agree = confirm("Are You Sure ?");
		if (agree==true)
		{
			var detection=0;
			var totaloption=document.getElementById("picture_available").length-1;

			for(var i=0;i<=totaloption;++i)
			{
				if(document.getElementById("picture_available").options[i].value==pic_name)
				{
					detection=1;
					break;
				}
			}
			
			if(detection!=1)
			{
				var a=new Option(pic_name,pic_name);
				document.getElementById("picture_available").options[document.getElementById("picture_available").length]=a;
			}
			document.getElementById("picture_available").value=pic_name;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	function change_picture(picture)
	{
		var encode_picture = encodeURI(picture);
		show_picture.location="icagent_image.cfm?pic3="+encode_picture;
	}
	
	function delete_picture(picture)
	{
	var answer =confirm("Are you sure wan to delete picture "+picture);
	if (answer)
	{
		var encode_picture = encodeURI(picture);
		show_picture.location="icagent_image.cfm?delete=true&picture="+encode_picture;
		var elSel = document.getElementById('picture_available');
		  var i;
		  for (i = elSel.length - 1; i>=0; i--) {
			if (elSel.options[i].selected) {
			  elSel.remove(i);
			}
		  }
	}
	
	}
	
	function showpic(picname)
		{
		return hs.expand(picname)
		}
		
	function uploading_picture(pic_name)
	{
		var new_pic_name1 = new String(pic_name);
		var new_pic_name2 = new_pic_name1.split(/[-,/,\\]/g);
		document.getElementById("picture_name").value=new_pic_name2[new_pic_name2.length-1];
	}
	
	function validate()
	{

		if(document.CustomerForm.agent.value=='')
		{
			alert("Your Agent cannot be blank.");
			document.CustomerForm.agent.focus();
			return false;
		}

		return true;
	}

</script>

<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lAGENT,agentuserid,agentlistuserid,lTEAM from GSetup
</cfquery>

<cfquery name="getteam" datasource="#dts#">
  Select team,desp from icteam
</cfquery>

<cfoutput>
	<cfif url.type eq "Edit">
		<cfquery datasource='#dts#' name="getitem">
			Select * from icagent where agent='#url.agent#'
		</cfquery>
		<cfset AGENT=getitem.agent>
		<cfset desp=getitem.desp>
		<cfset COMMSION1=getitem.commsion1>
		<cfset hp=getitem.hp>
        <cfset discontinueagent=getitem.discontinueagent>
        <cfset team1=getitem.team>
        <cfset agentID=getitem.agentID>
        <cfset agentlistID = getitem.agentlist>
        <cfset photo = getitem.photo>
		<cfset mode="Edit">
		<cfset title="Edit #getGsetup.lAGENT#">
		<cfset button="Edit">
	</cfif>

	<cfif url.type eq "Delete">
		<cfquery datasource='#dts#' name="getitem">
			Select * from icagent where agent='#url.agent#'
		</cfquery>
		<cfset AGENT=getitem.agent>
		<cfset desp=getitem.desp>
		<cfset COMMSION1=getitem.commsion1>
		<cfset hp=getitem.hp>
        <cfset discontinueagent=getitem.discontinueagent>
        <cfset team1=getitem.team>
        <cfset agentID=getitem.agentID>
        <cfset agentlistID = getitem.agentlist>
        <cfset photo = getitem.photo>
		<cfset mode="Delete">
		<cfset title="Delete #getGsetup.lAGENT#">
		<cfset button="Delete">
	</cfif>

  	<cfif url.type eq "Create">
		<cfset AGENT="">
		<cfset desp="">
		<cfset COMMSION1="">
		<cfset hp="">
        <cfset discontinueagent="">
        <cfset team1="">
        <cfset agentID="">
        <cfset photo = "">
		<cfset mode="Create">
		<cfset title="Create #getGsetup.lAGENT#">
		<cfset button="Create">
        <cfset agentlistID = "">
	</cfif>

	<h1>#title#</h1>

  	<h4>
		<cfif getpin2.h1B10 eq 'T'><a href="agenttable2.cfm?type=Create">Creating a New #getGsetup.lAGENT#</a> </cfif>
		<cfif getpin2.h1B20 eq 'T'>|| <a href="agenttable.cfm">List all #getGsetup.lAGENT#</a> </cfif>
		<cfif getpin2.h1B30 eq 'T'>|| <a href="s_agenttable.cfm?type=Icitem">Search For #getGsetup.lAGENT#</a></cfif>
	</h4>
</cfoutput>

<cfform name="CustomerForm" action="agenttableprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput>
    	<input type="hidden" name="mode" value="#mode#">
  	</cfoutput>
  	<h1 align="center"><cfoutput>#getGsetup.lAGENT#</cfoutput> File Maintenance</h1>
  	<table align="center" class="data" width="450">
    <cfoutput>
      	<tr>
	        <td>#getGsetup.lAGENT# :</td>
	        <td> 
				<cfif mode eq "Delete" or mode eq "Edit">
		            <!--- <h2>#url.agent#</h2> --->
		            <input type="text" size="20" name="agent" value="#url.agent#" readonly>
	            <cfelse>
	            	<input type="text" size="20" name="agent" value="#agent#" maxlength="20">
	          	</cfif> 
			</td>
      	</tr>
      	<tr>
        	<td>Description:</td>
        	<td><input type="text" size="40" name="desp" value="#desp#" maxlength="40"></td>
     	</tr>
	 	<cfif lcase(HcomID) eq "avt_i" or lcase(HcomID) eq "net_i" or lcase(HcomID) eq "netm_i" or lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
      		<tr>
        		<td>Email:</td>
        		<td><input type="text" size="40" name="COMMSION1" value="#COMMSION1#" maxlength="55"></td>
      		</tr>
	   		<tr>
		        <td>Contact:</td>
		        <td><input type="text" name="hp" value="#hp#" maxlength="12"></td>
      		</tr>
	  	<cfelseif lcase(HcomID) eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">
		  	<cfquery name="getAgentType" datasource="#dts#">
				select * from icagent_type order by desp
		  	</cfquery>
			<tr>
				<td>Commission:</td>
				<td><input type="text" size="40" name="COMMSION1" value="#COMMSION1#" maxlength="11"></td>
			</tr>
			<tr>
				<td>Agent Type</td>
				<td>
				<select name="hp">
					<option value="">Please Select</option>
					<cfloop query="getAgentType"><option value="#atype_id#" #IIF(atype_id eq hp,DE('selected'),DE(''))#>#desp#</option></cfloop>
				</select>
				</td>
			</tr>
	  	<cfelse>
	   		<tr>
		        <td>Commission:</td>
		        <td><cfinput type="text" size="40" name="COMMSION1" value="#COMMSION1#" maxlength="11" validate="float" message="Please Enter Numbers Only"></td>
      		</tr>
	   		<tr>
		        <td>Contact:</td>
		        <td><input type="text" name="hp" value="#hp#" maxlength="12"></td>
		    </tr>
	  	</cfif>
        <tr>
				<td>Discontinue Agent</td>
				<td>
				<input type="checkbox" name="discontinueagent" id="discontinueagent" value="Y" <cfif discontinueagent eq 'Y'>checked</cfif>>
				</td>
			</tr>
         <tr>

				<td>#getGsetup.lTeam#</td>
				<td>
				<select name="team">
					<option value="">Please Select</option>
					<cfloop query="getteam"><option value="#getteam.team#"  #IIF(team eq team1,DE('selected'),DE(''))#>#getteam.team#</option></cfloop>
				</select>
				</td>
			</tr>
            
        
        <cfif getGsetup.agentuserid eq 'Y'>
        <cfquery name="getuserid" datasource="main">
				select userID from users where userbranch='#dts#' and userID not in (select agentID from #dts#.icagent where agentID !='' and agentID is not null and agent !='#agent#') and usergrpid <> "SUPER" order by userID
		  	</cfquery>
        <tr>
				<td>Agent User ID</td>
				<td>
				<select name="agentID">
					<option value="">Please Select</option>
					<cfloop query="getuserid"><option value="#getuserid.userid#"  #IIF(userid eq agentID,DE('selected'),DE(''))#>#getuserid.userid#</option></cfloop>
				</select>
				</td>
			</tr>
            
            
            <cfelse>
            <input type='hidden' name="agentID" id='agentID' value="">
            </cfif>
             <cfif getGsetup.agentlistuserid eq 'Y'>
        	<cfquery name="getuserid" datasource="main">
				select userID from users where userbranch='#dts#' and usergrpid <> "SUPER" order by usergrpid
		  	</cfquery>
            <cfset agentlist = valuelist(getuserid.userid,",")>
        <tr>
				<td colspan="2" align="center">Multiple User ID</td>
			</tr>
            <cfloop list="#agentlist#" delimiters="," index="i">
            <cfquery name="getusergrp" datasource="main">
				select usergrpid from users where userbranch='#dts#' and usergrpid <> "SUPER" and userID="#i#"
		  	</cfquery>
            <tr>
            <td></td>
            <td><input type="checkbox" name="agentlist" id="agentlist" value="#i#" <cfif Listfindnocase('#agentlistID#','#i#',',') neq 0>checked</cfif>  />#i# - #getusergrp.usergrpid#</td>
            </tr>
            </cfloop>
            
            
            <cfelse>
            <input type='hidden' name="agentlist" id='agentlist' value="">
            </cfif>
            <tr>
		<td>Change Signature :</td>
		<cfdirectory action="list" directory="#HRootPath#\billformat\#hcomid#\" name="picture_list">
		<td>
			<select name="picture_available" id="picture_available" onChange="javascript:change_picture(this.value);">
				<option value="">-</option>
				<cfloop query="picture_list">
					<cfif picture_list.name neq "Thumbs.db" and (right(picture_list.name,3) eq "jpg" or right(picture_list.name,3) eq "png" or right(picture_list.name,3) eq "bmp")>
						<option value="#picture_list.name#" #iif((photo eq picture_list.name),DE("selected"),DE(""))#>#picture_list.name#</option>
					</cfif>
				</cfloop>
			</select>&nbsp;&nbsp;<img name="img1" src="/images/delete.ico" height="15" width="15" onMouseOver="this.style.cursor='hand'" onClick="delete_picture(document.getElementById('picture_available').value);" />
		</td>
	</tr>
    <tr>
    <td></td>
    <th height='10'>
    <iframe id="show_picture" name="show_picture" frameborder="1" marginheight="0" marginwidth="0" align="middle" height="100" width="100" scrolling="no" src="icagent_image.cfm?pic3=#urlencodedformat(photo)#"></iframe>
    </th>
    </tr>
	    <tr>
	    	<td></td>
	        <td align="right">
	            <input name="submit" type="submit" value="  #button#  ">
	          </td>
	    </tr>
    </cfoutput>
  	</table>
</cfform>

<form name="upload_picture" action="icagent_image.cfm" method="post" enctype="multipart/form-data" target="_blank">
<cfoutput>
	<table class="data" align="center" width="779">
		<tr>
        	<th height='20' colspan='8'><div align='center'><strong>Upload Agent Photo</strong></div></th>
      	</tr>
		<tr id="r2">
			<td align="center" colspan='8'>
				<input type="file" name="picture" size="50" onChange="javascript:uploading_picture(this.value);" accept="image/gif,image/jpeg,image/tiff,image/x-ms-bmp,image/x-photo-cd,image/x-png,image/x-portable-greymap,image/x-portable-pixmap,image/x-portablebitmap">
				<br/>
				<input type="text" name="picture_name" size="50" value="">&nbsp;
				<input type="submit" name="Upload" value="Upload" onClick="javascript:return add_option(document.getElementById('picture_name').value);">
			</td>
		</tr>
	</table>
    </cfoutput>
</form>
</body>
</html>
