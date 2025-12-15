 <cfquery name="getlocation" datasource="#dts#">
   		select attentionno as xattentionno,name,phone,phonea,fax,c_email  from attention WHERE customerno='#url.custno#' and attentionno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.location#%"> and name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custname#%"> and name like <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.leftcustname#%"> order by attentionno limit 500
	</cfquery>



	<cfoutput>  
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">#UCASE(url.nametype)# NO</font></th>
    <th width="300px">NAME</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getlocation" >
    
    <tr>
    <td>#getlocation.xattentionno#</td>
    <td>#getlocation.NAME#</td>
    <td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="document.getElementById('d_attn').value='#getlocation.xattentionno#';document.getElementById('d_phone').value='#getlocation.phone#';document.getElementById('d_phone2').value='#getlocation.phonea#';document.getElementById('d_fax').value='#getlocation.fax#';document.getElementById('d_email').value='#getlocation.c_email#';ColdFusion.Window.hide('findattention2');"><u>SELECT</u></a></td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>