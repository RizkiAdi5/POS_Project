<html>
<head>
<title>Update Function Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">

	function validate()
	{	<cfoutput>
		if(document.CustomerForm.Title.value=='') <!--- QCH if(document.update2Form.Title.value=='') --->
		{
			alert("Your Title's No. cannot be blank.");
			document.CustomerForm.Title.focus();
			return false;
		}
		</cfoutput>
		return true;
	}
	
</script>

<body>
			
		<cfoutput>
			<cfif #url.type# eq "Edit">
				<cfquery datasource='#dts#' name="getinfo">
					Select * from info where title='#url.title#'
				</cfquery>
                			    <cfquery datasource='#dts#' name="gettype">
					Select type from tabletype
				</cfquery>
				<cfset type=#getinfo.type#>
				<cfset title=#getinfo.title#>
				<cfset desp=#getinfo.desp#>
                
				<cfset mode="Edit">
				<cfset title="Edit Item">
				<cfset button="Edit">
						
				
			</cfif>
			<cfif #url.type# eq "Delete">
				<cfquery datasource='#dts#' name="getinfo">
					Select * from info where title='#url.title#'
				</cfquery>
                			    <cfquery datasource='#dts#' name="gettype">
					Select type from tabletype
				</cfquery>
				<cfset type=#getinfo.type#>
				<cfset title=#getinfo.title#>
				<cfset desp=#getinfo.desp#>
				
				<cfset mode="Delete">
				<cfset title="Delete Item">
				<cfset button="Delete">
						
				
			</cfif>
			
			
  <cfif #url.type# eq "Create">   
   <cfquery datasource='#dts#' name="gettype">
					Select type from tabletype
    <cfquery datasource='#dts#' name="getinfo">
					Select * from info
				</cfquery>
    			<cfset type="">
				<cfset desp="">
                
				<cfset mode="Create">
				<cfset title="Create Item">
				<cfset button="Create">
			   
				</cfquery>
            
			</cfif>

			<h1>#title#</h1>
			
  <h4><cfif getpin2.h1810 eq 'T'><a href="Update2.cfm?type=Create">Creating a Update</a> </cfif><cfif getpin2.h1820 eq 'T'>
      || <a href="update.cfm?">Edit &amp; Delate Update</a> </cfif></h4>
</cfoutput>

<cfform name="CustomerForm" action="updateprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#">
					
	
  <h1 align="center">Update Maintenance</h1></cfoutput>
  	
  <table align="center" class="data" width="450">
  
        <tr> 
        <td>Date :</td>
		
        <td><cfif mode eq "Delete" or mode eq "Edit"><cfoutput query="getinfo"><input type="text" size="20" name="date" value="#date#" maxlength="10"></cfoutput>
        <cfelse>
        <cfoutput>
       <input type="text" size="20" name="date" value="#dateformat(now(),'DD-MM-YYYY')#" maxlength="10"></cfoutput>
        </cfif>
        </td>
      </tr>
  
        <tr> 
        <td width="80" nowrap>Title :</td>
        <td width="370">                  
         <cfif mode eq "Delete" or mode eq "Edit">
            <!--- <h2>#url.title#</h2> ---><cfoutput query="getinfo">
            <input type="text" size="20" name="Title" value="#title#" readonly></cfoutput>
            <cfelse>
            <input type="text" size="20" name="Title" value="" maxlength="10">
          </cfif></td>
      </tr>
       <tr> 
      <th width="20%"><cfoutput>Type</cfoutput></th>
      <td width="5%">
              <cfif mode eq "Delete" or mode eq "Edit">
              <select name="updatetype">
                        <cfoutput query="getinfo">
            <option value="#type#">#type# </option>
             </cfoutput> 
                       <cfoutput query="gettype">
            <option value="#type#">#type# </option>
          </cfoutput>
             </select>
              <cfelse>
          <select name="updatetype">
          <option value=""><cfoutput>Choose a Type of Update</cfoutput></option>
          <cfoutput query="gettype">
            <option value="#type#">#type# </option>
          </cfoutput> </select>
</cfif>
          </td>

    </tr>
    

      <tr> 
        <td>Description :</td>
		
        <td><cfif mode eq "Delete" or mode eq "Edit"><cfoutput query="getinfo"><textarea name="desp" rows="5" cols="70" value="" maxlength="40">#desp#</textarea></cfoutput>
        <cfelse>
        <textarea name="desp" rows="5" cols="70" value="" maxlength="40"></textarea>
        </cfif>
        </td>
      </tr>
      <tr> 
        <td></td>
        <td>&nbsp;</td>
      </tr>
 <!--- QCH <CFOUTPUT> </CFOUTPUT> <CFOUTPUT> </CFOUTPUT> <CFOUTPUT> </CFOUTPUT> 
    <CFOUTPUT> </CFOUTPUT> <cfoutput> </cfoutput> <cfoutput> </cfoutput> <cfoutput> 
    </cfoutput> <cfoutput> </cfoutput> <cfoutput> </cfoutput> ---> 
	<cfoutput> 
      <tr> 
        <td></td>
        <td align="right"><cfoutput>
          <input type="button" value="Back" onClick="javascript:history.back();"> 
            <input name="submit" type="submit" value="  #button#  ">
          </cfoutput></td>
      </tr>
    </cfoutput> 
  </table>
</cfform>
			
</body>
</html>
