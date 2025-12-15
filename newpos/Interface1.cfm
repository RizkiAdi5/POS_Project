
<cfquery name="getitem" datasource="#dts#">
	SELECT itemno,photo
    FROM icitem
    WHERE 
    <cfif (#itemno# NEQ "") AND (#category# NEQ "")>
    itemno LIKE "%#itemno#%"  
    AND category LIKE "%#category#%"
    <cfelseif #itemno# NEQ "">
    itemno LIKE "%#itemno#%" 
    <cfelse>
    category LIKE "%#category#%"
    </cfif>
    ORDER BY "%#itemno#%";
</cfquery>

<cfoutput>
<cfset k=0>
<table class="table">
	<tbody >	
        <cfloop  query="getitem" >
        <cfif k eq 0>
  		<tr>              
		<cfelseif k eq 4>
 		</tr>
        <cfset k = 0>        
        </cfif>  
             <td style="width:25%; height:25%; text-align:center"><img onclick="addItemAdvance('#evaluate('getitem.itemno[#getitem.currentrow#]')#')" src="/images/#dts#/#evaluate('getitem.photo[#getitem.currentrow#]')#" width="100px" height="100px" alt="No picture is uploaded"/></td>  
        <cfset k = k+1>	         	
        </cfloop>						                               	    
	</tbody>          
</table> 
</cfoutput>
