<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
  <h1>Address Selection Page</h1>
		
  <cfoutput>
    <h4><cfif getpin2.h1F10 eq 'T'><a href="Addresstable2.cfm?type=Create">Creating a New Address</a> </cfif><cfif getpin2.h1F20 eq 'T'>|| <a href="Addresstable.cfm">List 
    all Address</a> </cfif><cfif getpin2.h1F30 eq 'T'>|| <a href="s_Addresstable.cfm?type=Icitem">Search For Address</a></cfif></h4>
  </cfoutput>
		
  <cfoutput>
    <form action="s_Addresstable.cfm" method="post"><!--- </cfoutput> --->

<!---     <cfoutput> --->
	  <h1>Search By :
        <select name="searchType">
         <cfif hcomid eq "kimlee_i" or lcase(HcomID) eq "bakersoven_i">
         <option value="Name">Name</option>
	      <option value="Code">Code</option>
          <cfelse>
          <option value="Code">Code</option>
	      <option value="Name">Name</option>
          </cfif>
		  <option value="custno">Cust/Supp No</option>	     
	      <option value="Phone">Telephone</option>
	      <option value="Fax">Fax</option>
	    </select>
      Search for Address : 
      <input type="text" name="searchStr" value="" size="40">
	  </h1>
	</form>
  </cfoutput>		
		
  <cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
  </cfif>
	
  <cfquery datasource='#dts#' name="type">
	Select * from Address order by Code, name, custno, add1, add2, add3, add4, attn
  </cfquery>
		
  <cfif isdefined("form.searchStr")>
  <cfquery datasource="#dts#" name="exactResult">
    Select * from address where #form.searchType# = '#form.searchStr#' order by #form.searchType#
	</cfquery>
			
  <cfquery datasource="#dts#" name="similarResult">
    Select * from address where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by #form.searchType#
	</cfquery>
			
	<h2>Exact Result</h2>
	<cfif #exactResult.recordCount# neq 0>
	  
    <table align="center" class="data" width="700px">
      <tr> 
        <th>Code</th>
        <th>Name</th>
        <th>Customer No</th>
        <th>Address</th>
        <th>Attn</th>
        <th>Phone</th>
        <th>Fax</th>
        <cfif getpin2.h1F11 eq 'T'><th width="10%">Action</th></cfif>
      </tr>
      <cfoutput query="exactResult"> 
        <tr> 
          <td>#exactResult.Code#</td>
          <td>#exactResult.name#</td>
          <td>#exactResult.custno#</td>
          <td>#exactResult.add1#<br>
            #exactResult.add2#<br>
            #exactResult.add3#<br>
            #exactResult.add4#</td>
          <td>#exactResult.attn#</td>
          <td>#exactResult.phone#</td>
          <td>#exactResult.fax#</td>
          <cfif getpin2.h1F11 eq 'T'><td nowrap> 
            <div align="center"><a href="Addresstable2.cfm?type=Delete&Code=#urlencodedformat(exactResult.Code)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
              &nbsp; <a href="Addresstable2.cfm?type=Edit&Code=#urlencodedformat(exactResult.Code)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a> 
            </div></td></cfif>
        </tr>
      </cfoutput> 
    </table>
	<cfelse>
	  <h3>No Exact Records were found.</h3>
    </cfif>
			
    <h2>Similar Result</h2>
    <cfif #similarResult.recordCount# neq 0>
      <table align="center" class="data" width="700px">					
	    <tr>
	      <th>Code</th>
          <th>Name</th>
		  <th>Customer No</th>
	      <th>Address</th>
	      <th>Attn</th>
          <th>Phone</th>
          <th>Fax</th>	      
          <cfif getpin2.h1F11 eq 'T'><th width="10%">Action</th></cfif>
	    </tr>
	
	    <cfoutput query="similarResult">
	      <tr>
		    <td>#similarResult.Code#</td>
		    <td>#similarResult.name#</td>
			<td>#similarResult.custno#</td>
		    <td>#similarResult.add1#<br>
			  #similarResult.add2#<br>
			  #similarResult.add3#<br>
			  #similarResult.add4#</td>
		    <td>#similarResult.attn#</td>
		    <td>#similarResult.phone#</td>
		    <td>#similarResult.fax#</td>
		    
          <cfif getpin2.h1F11 eq 'T'><td nowrap> 
            <div align="center"><a href="Addresstable2.cfm?type=Delete&Code=#urlencodedformat(similarResult.Code)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
              &nbsp;
              <a href="Addresstable2.cfm?type=Edit&Code=#urlencodedformat(similarResult.Code)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a> 
            </div></td></cfif>
	      </tr>
	    </cfoutput>
      </table>
    <cfelse>
	  <h3>No Similar Records were found.</h3>
    </cfif>
  </cfif>
		
  <cfparam name="i" default="1" type="numeric">
  <hr>
  <fieldset>
    <legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;
	  font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;">
  
      <cfoutput>20 Newest Address:</cfoutput>
	</legend>
	<br>
<cfif #type.recordCount# neq 0>
  <table align="center" class="data" width="700px">
    <tr> 
      <th>No.</th>
      <th>Code</th>
      <th>Name</th>
      <th>Customer No</th>
      <th>Address</th>
      <th>Attn</th>
      <th>Phone</th>
      <th>Fax</th>
      <cfif getpin2.h1F11 eq 'T'><th width="10%">Action</th></cfif>
    </tr>
    <cfoutput query="type" maxrows="20"> 
      <tr> 
        <td>#i#</td>
        <td>#type.Code#</td>
        <td nowrap>#type.name#</td>
        <td>#type.custno#</td>
        <td nowrap>#type.add1#<br>
          #type.add2#<br>
          #type.add3#<br>
          #type.add4# </td>
        <td>#type.attn#</td>
        <td>#type.phone#</td>
        <td>#type.fax#</td>
        <cfif getpin2.h1F11 eq 'T'><td nowrap> <div align="center"><a href="Addresstable2.cfm?type=Delete&Code=#urlencodedformat(type.Code)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
            &nbsp; <a href="Addresstable2.cfm?type=Edit&Code=#urlencodedformat(type.Code)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a> 
          </div></td></cfif>
      </tr>
      <cfset i = incrementvalue(#i#)>
    </cfoutput> 
  </table>
  <cfelse>
  <h3>No Records were found.</h3>
</cfif>
<br>
  </fieldset>
</body>
</html>
