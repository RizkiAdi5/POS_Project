<cfsetting showdebugoutput="no">

<cfquery name="custlist" datasource="#dts#">
select * from collect_Address
where custno='#url.custno#'
order by Code, custno, name
</cfquery>
<cfoutput>
<select name="CollectAddress" id="CollectAddress" size='10' ondblclick="setCollectAddress(this.options[this.selectedIndex].value);" >
<cfloop query="custlist">

<option value="#custlist.code#">#custlist.code#-#custlist.name#</option>

</cfloop>
</select>

<cfloop query="custlist" >
<input type="hidden" name="#custlist.code#CCode" id="#custlist.code#CCode" value="#custlist.code#" />
<input type="hidden" name="#custlist.code#CName" id="#custlist.code#CName" value="#custlist.name#" />
<input type="hidden" name="#custlist.code#c_add1" id="#custlist.code#c_add1" value="#custlist.add1#" />
<input type="hidden" name="#custlist.code#c_add2" id="#custlist.code#c_add2" value="#custlist.add2#" />
<input type="hidden" name="#custlist.code#c_add3" id="#custlist.code#c_add3" value="#custlist.add3#" />
<input type="hidden" name="#custlist.code#c_add4" id="#custlist.code#c_add4" value="#custlist.add4#" />
<input type="hidden" name="#custlist.code#c_attn" id="#custlist.code#c_attn" value="#custlist.attn#" />
<input type="hidden" name="#custlist.code#c_phone" id="#custlist.code#c_phone" value="#custlist.phone#" />
<input type="hidden" name="#custlist.code#c_fax" id="#custlist.code#c_fax" value="#custlist.fax#" />
</cfloop>
</cfoutput>