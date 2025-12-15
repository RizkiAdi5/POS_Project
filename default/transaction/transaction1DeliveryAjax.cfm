<cfsetting showdebugoutput="no">

<cfquery name="dcustlist" datasource="#dts#">
select * from Address
where custno='#url.custno#'
order by Code, custno, name
</cfquery>
<cfoutput>
<select name="DeliveryAddress" id="DeliveryAddress" size='10' ondblclick="setDeliveryAddress(this.options[this.selectedIndex].value);" >
<cfloop query="dcustlist">

<option value="#dcustlist.code#">#dcustlist.code#-#dcustlist.name#</option>

</cfloop>
</select>

<cfloop query="dcustlist" >
<input type="hidden" name="#dcustlist.code#DCode" id="#dcustlist.code#DCode" value="#dcustlist.code#" />
<input type="hidden" name="#dcustlist.code#DName" id="#dcustlist.code#DName" value="#dcustlist.name#" />
<input type="hidden" name="#dcustlist.code#d_add1" id="#dcustlist.code#d_add1" value="#dcustlist.add1#" />
<input type="hidden" name="#dcustlist.code#d_add2" id="#dcustlist.code#d_add2" value="#dcustlist.add2#" />
<input type="hidden" name="#dcustlist.code#d_add3" id="#dcustlist.code#d_add3" value="#dcustlist.add3#" />
<input type="hidden" name="#dcustlist.code#d_add4" id="#dcustlist.code#d_add4" value="#dcustlist.add4#" />
<input type="hidden" name="#dcustlist.code#d_attn" id="#dcustlist.code#d_attn" value="#dcustlist.attn#" />
<input type="hidden" name="#dcustlist.code#d_phone" id="#dcustlist.code#d_phone" value="#dcustlist.phone#" />
<input type="hidden" name="#dcustlist.code#d_fax" id="#dcustlist.code#d_fax" value="#dcustlist.fax#" />
</cfloop>
</cfoutput>