
<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name,van,rem41 from artran WHERE type ='#url.type#' and refno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custno#%"> and van like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custname#%"> order by refno limit 20
	</cfquery>
	<cfoutput>  
   
       <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">REF NO #url.type#</font></th>
    <th width="300px">MEMBER</th>
    <th width="80px">EXCHANGE RECEIPT NO</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getcustsupp" >
    <tr>
    <td>#getcustsupp.refno#</td>
    <td>#getcustsupp.van#</td>
    <td>#getcustsupp.rem41#</td>
    <td>
    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.hide('findRefno');exchangereceipt('#getcustsupp.refno#');"><u>SELECT</u></a>
   
</td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>