<cfsetting showdebugoutput="no">
<cfset nexttranno = URLDecode(url.refno)>
<cfset custno = URLDecode(url.custno)>
<cfset itemno = URLDecode(url.itemno)>
<cfset qty = val(URLDecode(url.qty))>
<cfset tran = URLDecode(url.type)>
<cfset trancode = URLDecode(url.trancode)>
<cfset sign = URLDecode(url.sign)>

		<cfquery name="getgsetup" datasource="#dts#">
        select * from gsetup
        </cfquery>

		<cfquery name="getremainingserialno" datasource="#dts#">
        select * from iserial where type='#tran#' and refno='#nexttranno#' and trancode='#trancode#' and itemno='#itemno#'
        </cfquery>
        
        <cfquery name="getaddedserialno" datasource="#dts#">
        select * from (
		Select serialno,sum(sign) as sign
		from iserial 
		where itemno='#itemno#'
        and (void is null or void='')
        group by serialno
		order by serialno) as a
        where a.sign=1
        order by a.serialno
        </cfquery>
		
		<cfoutput>
        <table class="data">
		<tr>
			<th>Reference No</th>
			<th>Customer No</th>
			<th>Itemno</th>
			<th>Total Qty</th>
			<th>Qty To Be Select</th>
			<cfif sign eq 1><th>Added <cfoutput>#getgsetup.lserial#</cfoutput>. List</th></cfif>
		</tr>
		
		<tr>
			<td>#nexttranno#</td>
			<td>#custno#</td>
			<td>#itemno#</td>
			<td align="center">#qty#<input type="hidden" id="totalitemqty" name="totalitemqty" value="#qty#"></td>
			<td align="center">#getremainingserialno.recordcount#</td>
			<cfif sign eq 1><td><select name="added_serialno">
            <cfloop query="getaddedserialno">
            <option value="#getaddedserialno.serialno#">#getaddedserialno.serialno#</option>
            </cfloop>
            </select></td></cfif>
		</tr>
		
		</table>
        </cfoutput>