<cfoutput>
<form action="" method="post">
<input type="text" name="form1" id="form1" size="4" />
<input type="text" name="form2" id="form2"  size="4"/>
<input type="text" name="form3" id="form3" size="4" />
<input type="text" name="form4" id="form4"  size="4"/>
<input type="text" name="form5" id="form5" size="4" /><br />

<input type="submit" name="sub_btn" id="sub_btn" value="Generate" />
</form>

<cfif isdefined('form.form1')>
<cfset newstring = chr(form.form1)&chr(form.form2)&chr(form.form3)&chr(form.form4)&chr(form.form5)>
<cffile action="write" file="C:\inetpub\wwwroot\ims\download\ocd.DTL" 
    output="#newstring#" >
    
    <cfset yourFileName="C:\inetpub\wwwroot\ims\download\ocd.DTL">
<cfset yourFileName2="ocd.DTL">
 
 <cfcontent type="application/x-unknown"> 

 <cfset thisPath = ExpandPath("#yourFileName#")> 
 <cfheader name="Content-Disposition" value="attachment; filename=#yourFileName2#">
<cfheader name="Content-Description" value="This is a tab-delimited file.">
<cfcontent type="Multipart/Report" file="#yourFileName#">
<cflocation url="#yourFileName#">

</cfif>    
</cfoutput>