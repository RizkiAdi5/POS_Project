<cfsetting showdebugoutput="no">
<cfset nexttranno = URLDecode(url.refno)>
<cfset custno = URLDecode(url.custno)>
<cfset itemno = URLDecode(url.itemno)>
<cfset qty = val(URLDecode(url.qty))>
<cfset tran = URLDecode(url.type)>
<cfset trancode = URLDecode(url.trancode)>
<cfset sign = URLDecode(url.sign)>
<cfset batchcode = URLDecode(url.batchcode)>
<cfset batchcode = URLDecode(url.uuid)>

		<cfquery name="getgsetup" datasource="#dts#">
        select * from gsetup
        </cfquery>
		<cfquery name="getremainingserialno2" datasource="#dts#">
        select * from iserialtemp where type='#tran#' and refno='#nexttranno#' and trancode='#trancode#' and itemno='#itemno#' and uuid='#uuid#' order by serialno
        </cfquery>
        

        
        <cfif lcase(hcomid) eq "asaiki_i" and tran eq 'SAM'> 
        
        <cfquery name="getaddedserialno2" datasource="#dts#">
        select * from (
		Select serialno,sum(sign) as sign
		from iserial 
		where itemno='#itemno#'
        and location='#location#' and serialno like '#batchcode#%'
        and (void is null or void='')
        group by serialno
		order by serialno) as a
        where a.sign=1
        order by a.serialno
        </cfquery>
        
        <cfelse>
        
        <cfquery name="getaddedserialno2" datasource="#dts#">
        select * from (
		Select serialno,sum(sign) as sign
		from iserial 
		where itemno='#itemno#'
        and location='#location#' and type<>'SAM'
        and (void is null or void='')
        group by serialno
		order by serialno) as a
        where a.sign=1
        and serialno not in (select serialno from iserialtemp where uuid="#uuid#")
        order by a.serialno
        </cfquery>
        
		</cfif>
		<cfoutput>
        <table class="data">
		<tr>
			<th width="50">No</th>
            
			<th><cfoutput>Serial No</cfoutput></th>
			<th width="70">Action</th>
		</tr>
        <input type="hidden" name="totaladdedserial" id="totaladdedserial" value="#getremainingserialno2.recordcount#" />
        <cfif getremainingserialno2.recordcount neq 0>
        <cfloop query="getremainingserialno2">
        <tr>
        <td>#getremainingserialno2.currentrow#</td>
        <td>#getremainingserialno2.serialno#</td>
        <td><input type="button" name="delete" value="delete" onClick="deleteSerialno('#getremainingserialno2.serialno#')"></td>
        </tr>
        </cfloop>
        </cfif>
        <cfif getremainingserialno2.recordcount lt qty>
        <cfif sign eq '-1'>
		<tr>
			<td>New</td>
			<td align="right">
            <select name="select_serialno" id="select_serialno" onkeypress="return handleEnter(event)">
            <cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i" or lcase(hcomid) eq "iaf_i"  or lcase(hcomid) eq "scpl_i" or lcase(hcomid) eq "mfssmy_i">
            <option value="">Choose a serialno</option>
            </cfif>
            <cfloop query="getaddedserialno2">
            <option value="#getaddedserialno2.serialno#">#getaddedserialno2.serialno#</option>
            </cfloop>
            </select>
            <cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i" or lcase(hcomid) eq "iaf_i"  or lcase(hcomid) eq "scpl_i" or lcase(hcomid) eq "mfssmy_i">
            <input type="text" name="serialnoselect" id="serialnoselect" value="" onKeyPress="return handleEnter(event)">
			</cfif>
            </td>
			<td><input type="button" name="add" value="Add" onClick="addNewSerialno()"></td>
		</tr>
        <cfelse>
		<tr>
			<td>New</td>
			<td align="right"><input type="text" name="text_serialno" id="text_serialno" maxlength="<cfif lcase(hcomid) neq "dental_i" or lcase(hcomid) neq "dental10_i" or lcase(hcomid) neq "mfss_i" or lcase(hcomid) neq "hcss_i" or lcase(hcomid) neq "iaf_i" or lcase(hcomid) eq "scpl_i" or lcase(hcomid) eq "mfssmy_i">100<cfelse>100</cfif>" size="30" onKeyPress="return handleEnter(event)"></td>
			<td><input type="button" name="add_text" value="Add" onClick="addNewSerialno()"></td>
		</tr>
        </cfif>
        </cfif>
		</table>
        </cfoutput>