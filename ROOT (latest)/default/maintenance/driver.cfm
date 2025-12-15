<html>
<head>
	<title>Driver Page</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>
<script type="text/javascript" src="/scripts/jscripts/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript" src="/scripts/highslide/highslide.js"></script>
<link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
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
		if(document.DriverForm.DriverNo.value=='')
		{
			alert("Your Driver's No. cannot be blank.");
			document.DriverForm.DriverNo.focus();
			return false;
		}
		else if(document.DriverForm.attn.value=='')
		{
			alert("Your Driver's Company Name cannot be blank.");
			document.DriverForm.attn.focus();
			return false;
		}
		else if(document.DriverForm.add1.value=='')
		{
			alert("Your Driver's Address cannot be blank.");
			document.DriverForm.add1.focus();
			return false;			
		}
		
		return true;
	}
	
</script>
<body>	
<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lDRIVER,df_mem_price from GSetup
</cfquery>

<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from Driver where DriverNo='#url.DriverNo#'
	</cfquery>
				
	<cfif getPersonnel.recordcount gt 0>
		<cfset DriverNo=getPersonnel.DriverNo>
		<cfset name=getPersonnel.name>
		<cfset name2=getPersonnel.name2>
		<cfset attn=getPersonnel.attn>
		<cfset xcustomerno=getPersonnel.customerno>						
		<cfset add1=getPersonnel.add1>
		<cfset add2=getPersonnel.add2>
		<cfset add3=getPersonnel.add3>
		<cfset dept=getPersonnel.dept>						
		<cfset contact=getPersonnel.contact>	
        <cfset Dadd1=getPersonnel.Dadd1>
		<cfset Dadd2=getPersonnel.Dadd2>
		<cfset Dadd3=getPersonnel.Dadd3>
		<cfset Dattn=getPersonnel.Dattn>						
		<cfset Dcontact=getPersonnel.Dcontact>	
        <cfset remarks=getPersonnel.remarks>					
		<cfset fax=getPersonnel.fax>	
        <cfset photo=getPersonnel.photo>
        <cfset commission1=getPersonnel.commission1>	
        <cfset pointsbf=getPersonnel.pointsbf>	
        <cfif getPersonnel.expiredate eq '0000-00-00'>
        <cfset expiredate=''>	
        <cfelse>
        <cfset expiredate=dateformat(getPersonnel.expiredate,'DD/MM/YYYY')>	
        </cfif>
        <cfif getPersonnel.dob eq '0000-00-00'>
        <cfset dob=''>	
        <cfelse>
        <cfset dob=dateformat(getPersonnel.dob,'DD/MM/YYYY')>	
        </cfif>
        <cfset icno=getPersonnel.icno>	
        <cfset gender=getPersonnel.gender>	
        <cfset pricelevel=getPersonnel.pricelevel>	
    	<cfset discontinuedriver=getPersonnel.discontinuedriver>
			<cfset phone=getPersonnel.phone>
			<cfset phonea=getPersonnel.phonea>
            <cfset e_mail=getPersonnel.e_mail>
					
						
		<cfset mode="Edit">
			<cfset title="Edit #getGsetup.lDRIVER#">
			<cfset button="Edit">
		<cfelse>
			<cfset status="Sorry, the #getGsetup.lDRIVER#, #url.DriverNo# was ALREADY removed from the system. Process unsuccessful.">
			<form name="done" action="vdriver.cfm?process=done" method="post">
				<input name="status" value="#status#" type="hidden">
			</form>
			<script>
				done.submit();
			</script>
		</cfif>
	<cfelseif url.type eq "Create">
		<cfset DriverNo="">
		<cfset name="">
		<cfset name2="">
		<cfset attn="">
		<cfset xcustomerno="">						
		<cfset add1="">
		<cfset add2="">
		<cfset add3="">
		<cfset dept="">						
		<cfset contact="">		
        <cfset Dadd1="">
		<cfset Dadd2="">
		<cfset Dadd3="">
		<cfset Dattn="">						
		<cfset Dcontact="">
        <cfset remarks="">						
		<cfset fax="">	
        <cfset photo="">
        <cfset commission1="">	
        <cfset pointsbf="">	
        <cfset dob="">	
        <cfset expiredate=''>	
        <cfset icno=''>	
        <cfset gender=''>	
        <cfset pricelevel=getGsetup.df_mem_price>	
        <cfset discontinuedriver="">

			<cfset phone="">	
			<cfset phonea="">	
            <cfset e_mail="">

			
		<cfset mode="Create">
		<cfset title="Create #getGsetup.lDRIVER#">
		<cfset button="Create">
	<cfelseif url.type eq "Delete">
		<cfquery datasource='#dts#' name="getPersonnel">
			Select * from Driver where DriverNo='#url.DriverNo#'
		</cfquery>
				
		<cfif getPersonnel.recordcount gt 0>
			<cfset DriverNo=getPersonnel.DriverNo>
			<cfset name=getPersonnel.name>
			<cfset name2=getPersonnel.name2>
			<cfset attn=getPersonnel.attn>
			<cfset xcustomerno=getPersonnel.customerno>						
			<cfset add1=getPersonnel.add1>
			<cfset add2=getPersonnel.add2>
			<cfset add3=getPersonnel.add3>
			<cfset dept=getPersonnel.dept>						
			<cfset contact=getPersonnel.contact>	
            <cfset Dadd1=getPersonnel.Dadd1>
			<cfset Dadd2=getPersonnel.Dadd2>
			<cfset Dadd3=getPersonnel.Dadd3>
			<cfset Dattn=getPersonnel.Dattn>						
			<cfset Dcontact=getPersonnel.Dcontact>	
            <cfset remarks=getPersonnel.remarks>						
			<cfset fax=getPersonnel.fax>	
            <cfset commission1=getPersonnel.commission1>	
            <cfset pointsbf=getPersonnel.pointsbf>	
            <cfset photo=getPersonnel.photo>
            <cfif getPersonnel.expiredate eq '0000-00-00'>
        <cfset expiredate=''>	
        <cfelse>
        <cfset expiredate=dateformat(getPersonnel.expiredate,'DD/MM/YYYY')>	
        </cfif>
            <cfif getPersonnel.dob eq '0000-00-00'>
        <cfset dob=''>	
        <cfelse>
        <cfset dob=dateformat(getPersonnel.dob,'DD/MM/YYYY')>	
        </cfif>
            <cfset icno=''>	
        	<cfset gender=''>	
            <cfset pricelevel=getPersonnel.pricelevel>	
			<cfset discontinuedriver=getPersonnel.discontinuedriver>
                <cfset phone=getPersonnel.phone>
                <cfset phonea=getPersonnel.phonea>
                <cfset e_mail=getPersonnel.e_mail>

						
			<cfset mode="Delete">
			<cfset title="Delete #getGsetup.lDRIVER#">
			<cfset button="Delete">
	<cfelse>
		<cfset status="Sorry, the #getGsetup.lDRIVER#, #url.DriverNo# was ALREADY removed from the system. Process unsuccessful. Please refresh your webpage.">
		<form name="done" action="vdriver.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		<script>
			done.submit();
		</script>
	</cfif>			
</cfif>
<cfoutput>
	<cfif husergrpid eq "Muser"><a href="../home2.cfm"><u>Home</u></a></cfif>
	<h1>#title#</h1>
			
  	<h4>
		<cfif getpin2.h1C10 eq 'T'><a href="Driver.cfm?type=Create"> Creating a #getGsetup.lDRIVER#</a> </cfif>
		<cfif getpin2.h1C20 eq 'T'>|| <a href="vdriver.cfm">List all #getGsetup.lDRIVER#</a> </cfif>
		<cfif getpin2.h1C30 eq 'T'>|| <a href="sdriver.cfm">Search #getGsetup.lDRIVER#</a> </cfif>
		<cfif getpin2.h1C40 eq 'T'>|| <a href="pdriver.cfm" target="_blank">#getGsetup.lDRIVER# Listing</a></cfif>
	</h4>

<cfform name="DriverForm" action="DriverProcess.cfm" method="post" onSubmit="return validate()">
	<input type="hidden" name="mode" value="#mode#">
	<cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">
		<cfquery name="getcust" datasource="#dts#">
			select custno,name from #target_apvend# where status<>'B' order by custno
		</cfquery>
	<cfelse>
		<cfquery name="getcust" datasource="#dts#">
			select custno,name from #target_arcust# where status<>'B' order by custno
		</cfquery>
	</cfif>
	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno,name from #target_arcust# where status<>'B' order by custno
	</cfquery> --->
	<cfif lcase(hcomid) neq 'tcds_i'>
    <!--- That Cd Shop Display--->
    <table align="center" class="data" width="550px">
	    <tr> 
	      	<td>#getGsetup.lDRIVER# No :</td>
	      	<td> 
		      	<cfif mode eq "Delete" or mode eq "Edit">
	          		<h2>#url.DriverNo#</h2>
	          		<input type="hidden" name="DriverNo" value="#DriverNo#">  
	          	<cfelse>
	          		<input type="text" size="40" name="DriverNo" value="" maxlength="8">
	        	</cfif> 
			</td>
	    </tr>
        <tr> 
      		<td>IC. No</td>
      		<td><input type="text" size="40" name="icno"  value="#icno#" maxlength="100"></td>
    	</tr>
		<tr> 
	      	<td>Name :</td>
	      	<td><input type="text" size="40" name="Name"  value="#name#" maxlength="40"></td>
	    </tr>
		<tr> 
      		<td></td>
      		<td><input type="text" size="40" name="Name2"  value="#name2#" maxlength="40"></td>
    	</tr>
        <tr> 
	      	<td>Date Of Birth :</td>
	      	<td><cfinput type="text" size="10" name="dob"  value="#dob#" maxlength="10" validate="eurodate" message="Kindly Check Date Format"> <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(dob);">DD/MM/YYYY</td>
	    </tr>
        <tr> 
	      	<td>Gender</td>
	      	<td><select name="gender" id="gender">
            <option value="">Choose a Gender</option>
            <option value="Male" <cfif gender eq 'Male'>selected</cfif>>Male</option>
            <option value="Female" <cfif gender eq 'Female'>selected</cfif>>Female</option>
            </select>
            </td>
	    </tr>
         <tr>
		        <td>Expiry Date :</td>
		        <td><cfinput type="text" size="10" name="expiredate" value="#expiredate#" maxlength="40" validate="eurodate"><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(expiredate);">DD/MM/YYYY				</td>
      	</tr>
        <tr> 
                <td>e_mail :</td>
                <td><input type="text" size="40" name="e_mail"  value="#e_mail#" maxlength="25"></td>
            </tr>
        <tr> 
      		<td>Mobile :</td>
      		<td><input type="text" size="40" name="contact"  value="#contact#" maxlength="20"></td>
    	</tr>	

        <tr> 
            <td>Phone :</td>
            <td><input type="text" size="40" name="phone"  value="#phone#" maxlength="25"></td>
        </tr>
        <tr> 
            <td>Phone 2 :</td>
            <td><input type="text" size="40" name="phonea"  value="#phonea#" maxlength="25"></td>
        </tr>
        <tr> 
	      	<td>Home Address :</td>
	      	<td><input type="text" size="40" name="Add1" value="#Add1#" maxlength="40"></td>
   	 	</tr>
	    <tr> 
	      	<td></td>
	      	<td><input type="text" size="40" name="Add2"  value="#Add2#" maxlength="40"></td>
	    </tr>
	 	<tr> 
      		<td></td>
      		<td><input type="text" size="40" name="Add3"  value="#Add3#" maxlength="40"></td>
    	</tr>
        <tr> 
	      	<td>Work Address :</td>
	      	<td><input type="text" size="40" name="DAdd1" value="#DAdd1#" maxlength="40"></td>
   	 	</tr>
	    <tr> 
	      	<td></td>
	      	<td><input type="text" size="40" name="DAdd2"  value="#DAdd2#" maxlength="40"></td>
	    </tr>
	 	<tr> 
      		<td></td>
      		<td><input type="text" size="40" name="DAdd3"  value="#DAdd3#" maxlength="40"></td>
    	</tr>
        
        <tr> 
      		<td>Note :</td>
      		<td><input type="text" size="40" name="remarks"  value="#remarks#" maxlength="100"></td>
    	</tr>
        <tr style="display:none">
		        <td>Price Level:</td>
		        <td><select name="pricelevel" id="pricelevel">
            <option value="">Choose a Price level</option>
            <option value="1" <cfif pricelevel eq '1'>selected</cfif>>1</option>
            <option value="2" <cfif pricelevel eq '2'>selected</cfif>>2</option>
            <option value="3" <cfif pricelevel eq '3'>selected</cfif>>3</option>
            <option value="4" <cfif pricelevel eq '4'>selected</cfif>>4</option>
            </select>
            </td>
      	</tr>
        
	 	<tr style="display:none"> 
      		<td>Attention :</td>
      		<td><input type="text" size="40" name="Attn"  value="#attn#" maxlength="40"></td>
    	</tr>
    	<input type="hidden" name="customerno" id="customerno" value="">
    	
	 	<tr style="display:none"> 
      		<td><cfif lcase(hcomid) eq "litelab_i">Company<cfelse>Department :</cfif></td>
      		<td><cfif lcase(hcomid) eq "litelab_i">
            <cfquery name="getteam" datasource="#dts#">
            select * from icteam
            </cfquery>
            <select name="Dept" id="Dept">
            <option value="">Choose a Company</option>
            <cfloop query="getteam">
            <option value="#getteam.team#" <cfif dept eq getteam.team>selected</cfif>>#getteam.team# - #getteam.desp#</option>
            </cfloop>
            </select>
            <cfelse>
            
            <input type="text" size="40" name="Dept"  value="#dept#" maxlength="30"></cfif></td>
    	</tr>
	 	<tr style="display:none"> 
      		<td>Fax :</td>
      		<td><input type="text" size="40" name="fax"  value="#fax#" maxlength="20"></td>
    	</tr>
        
	 	<tr style="display:none"> 
      		<td>Delivery Attn :</td>
      		<td><input type="text" size="40" name="DAttn"  value="#DAttn#" maxlength="30"></td>
    	</tr>
    	<tr style="display:none"> 
      		<td>Delivery Contact :</td>
      		<td><input type="text" size="40" name="Dcontact"  value="#Dcontact#" maxlength="20"></td>
    	</tr>	
        <tr style="display:none">
		        <td>Commission:</td>
		        <td><cfinput type="text" size="10" name="commission1" value="#commission1#" maxlength="11" validate="integer">%</td>
      		</tr>
        <tr>
		        <td>Points BF:</td>
		        <td><cfinput type="text" size="10" name="pointsbf" value="#pointsbf#" maxlength="11" validate="float"></td>
      		</tr>
        <tr>
		        <td>Discontinued:</td>
		        <td><input type="checkbox" id="discontinuedriver" name="discontinuedriver" value="1" <cfif discontinuedriver eq 'Y'>checked</cfif>></td>
      	</tr>
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
            
            <iframe id="show_picture" name="show_picture" frameborder="1" marginheight="0" marginwidth="0" align="middle" height="100" width="100" scrolling="no" src="icagent_image.cfm?pic3=#urlencodedformat(photo)#"></iframe>
		</td>
	</tr>
    
    <tr> 
			<td></td>
			<td align="right"><input type="submit" value="  #button#  "></td>
 		</tr>
  		
    
  	</table>
    
    
    <cfelse>
    <!--- Normal Company Display--->
  	<table align="center" class="data" width="550px">
	    <tr> 
	      	<td>#getGsetup.lDRIVER# No :</td>
	      	<td> 
		      	<cfif mode eq "Delete" or mode eq "Edit">
	          		<h2>#url.DriverNo#</h2>
	          		<input type="hidden" name="DriverNo" value="#DriverNo#">  
	          	<cfelse>
	          		<input type="text" size="40" name="DriverNo" value="" maxlength="8">
	        	</cfif> 
			</td>
	    </tr>
		<tr> 
	      	<td>Name :</td>
	      	<td><input type="text" size="40" name="Name"  value="#name#" maxlength="40"></td>
	    </tr>
		<tr> 
      		<td></td>
      		<td><input type="text" size="40" name="Name2"  value="#name2#" maxlength="40"></td>
    	</tr>
	 	<tr> 
      		<td>Attention :</td>
      		<td><input type="text" size="40" name="Attn"  value="#attn#" maxlength="40"></td>
    	</tr>
        <cfif lcase(HcomID) eq "polypet_i">
    	<input type="hidden" name="customerno" id="customerno" value="">
        <cfelse>
        <tr> 
      		<td><cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">Supplier<cfelse>Customer</cfif> No :</td>
      		<td>
				<select name="customerno">
	  				<option value="">Choose a <cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">Supplier<cfelse>Customer</cfif></option>
					<cfloop query="getcust">
	  					<option value="#custno#"<cfif xcustomerno eq custno>selected</cfif>>#custno# - #name#</option>
					</cfloop>
	  			</select>
			</td>
    	</tr>
        </cfif>
    	<tr> 
	      	<td>Address :</td>
	      	<td><input type="text" size="40" name="Add1" value="#Add1#" maxlength="40"></td>
   	 	</tr>
	    <tr> 
	      	<td></td>
	      	<td><input type="text" size="40" name="Add2"  value="#Add2#" maxlength="40"></td>
	    </tr>
	 	<tr> 
      		<td></td>
      		<td><input type="text" size="40" name="Add3"  value="#Add3#" maxlength="40"></td>
    	</tr>
	 	<tr> 
      		<td><cfif lcase(hcomid) eq "litelab_i">Company<cfelse>Department :</cfif></td>
      		<td><cfif lcase(hcomid) eq "litelab_i">
            <cfquery name="getteam" datasource="#dts#">
            select * from icteam
            </cfquery>
            <select name="Dept" id="Dept">
            <option value="">Choose a Company</option>
            <cfloop query="getteam">
            <option value="#getteam.team#" <cfif dept eq getteam.team>selected</cfif>>#getteam.team# - #getteam.desp#</option>
            </cfloop>
            </select>
            <cfelse>
            
            <input type="text" size="40" name="Dept"  value="#dept#" maxlength="30"></cfif></td>
    	</tr>
    	<tr> 
      		<td>Contact :</td>
      		<td><input type="text" size="40" name="contact"  value="#contact#" maxlength="20"></td>
    	</tr>	

        	<tr> 
                <td>Phone :</td>
                <td><input type="text" size="40" name="phone"  value="#phone#" maxlength="25"></td>
            </tr>
        	<tr> 
                <td>Handphone :</td>
                <td><input type="text" size="40" name="phonea"  value="#phonea#" maxlength="25"></td>
            </tr>
            <tr> 
                <td>e_mail :</td>
                <td><input type="text" size="40" name="e_mail"  value="#e_mail#" maxlength="25"></td>
            </tr>

	 	<tr> 
      		<td>Fax :</td>
      		<td><input type="text" size="40" name="fax"  value="#fax#" maxlength="20"></td>
    	</tr>
        <tr> 
	      	<td>Delivery Address :</td>
	      	<td><input type="text" size="40" name="DAdd1" value="#DAdd1#" maxlength="40"></td>
   	 	</tr>
	    <tr> 
	      	<td></td>
	      	<td><input type="text" size="40" name="DAdd2"  value="#DAdd2#" maxlength="40"></td>
	    </tr>
	 	<tr> 
      		<td></td>
      		<td><input type="text" size="40" name="DAdd3"  value="#DAdd3#" maxlength="40"></td>
    	</tr>
	 	<tr> 
      		<td>Delivery Attn :</td>
      		<td><input type="text" size="40" name="DAttn"  value="#DAttn#" maxlength="30"></td>
    	</tr>
    	<tr> 
      		<td>Delivery Contact :</td>
      		<td><input type="text" size="40" name="Dcontact"  value="#Dcontact#" maxlength="20"></td>
    	</tr>	
        <tr> 
      		<td><cfif lcase(hcomid) eq "tcds_i">IC. No<cfelse>Remarks :</cfif></td>
      		<td><input type="text" size="40" name="remarks"  value="#remarks#" maxlength="100"></td>
    	</tr>
        
        <tr>
		        <td>Commission:</td>
		        <td><cfinput type="text" size="10" name="commission1" value="#commission1#" maxlength="11" validate="integer">%</td>
      		</tr>
        <tr>
		        <td>Points BF:</td>
		        <td><cfinput type="text" size="10" name="pointsbf" value="#pointsbf#" maxlength="11" validate="float"></td>
      	</tr>
        
        <tr>
		        <td>IC No:</td>
		        <td><cfinput type="text" size="40" name="icno" value="#icno#" maxlength="40" validate="float"></td>
      	</tr>
        <tr>
		        <td>Date Of Birth:</td>
		        <td><cfinput type="text" size="10" name="dob"  value="#dob#" maxlength="10" validate="eurodate" message="Kindly Check Date Format"> <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(dob);">DD/MM/YYYY</td>
      	</tr>
         <tr>
		        <td>Expiry Date :</td>
		        <td><cfinput type="text" size="10" name="expiredate" value="#expiredate#" maxlength="40" validate="eurodate"><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(expiredate);">DD/MM/YYYY				</td>
      	</tr>
        <tr>
		        <td>Gender:</td>
		        <td><select name="gender" id="gender">
            <option value="">Choose a Gender</option>
            <option value="Male" <cfif gender eq 'Male'>selected</cfif>>Male</option>
            <option value="Female" <cfif gender eq 'Female'>selected</cfif>>Female</option>
            </select>
            </td>
      	</tr>
        <tr>
		        <td>Price Level:</td>
		        <td><select name="pricelevel" id="pricelevel">
            <option value="">Choose a Price level</option>
            <option value="1" <cfif pricelevel eq '1'>selected</cfif>>1</option>
            <option value="2" <cfif pricelevel eq '2'>selected</cfif>>2</option>
            <option value="3" <cfif pricelevel eq '3'>selected</cfif>>3</option>
            <option value="4" <cfif pricelevel eq '4'>selected</cfif>>4</option>
            </select>
            </td>
      	</tr>
        <tr>
		        <td>Discontinued:</td>
		        <td><input type="checkbox" id="discontinuedriver" name="discontinuedriver" value="1" <cfif discontinuedriver eq 'Y'>checked</cfif>></td>
      	</tr>
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
            
            <iframe id="show_picture" name="show_picture" frameborder="1" marginheight="0" marginwidth="0" align="middle" height="100" width="100" scrolling="no" src="icagent_image.cfm?pic3=#urlencodedformat(photo)#"></iframe>
		</td>
	</tr>
    
    <tr> 
			<td></td>
			<td align="right"><input type="submit" value="  #button#  "></td>
 		</tr>
  		
    
  	</table>
    </cfif>
</cfform>		
</cfoutput> 
<form name="upload_picture" action="icagent_image.cfm" method="post" enctype="multipart/form-data" target="_blank">
<cfoutput>
	<table class="data" align="center" width="779">
		<tr>
        	<th height='20' colspan='8'><div align='center'><strong>Upload Photo</strong></div></th>
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
