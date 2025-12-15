<cfsetting showdebugoutput="no">
<cfquery name="getcustdetail" datasource="#dts#">
SELECT * from #target_arcust# where custno="#url.custno#"
</cfquery>

<cfoutput>
<table>
    <tr>
    <td>Name</td>
    <td><input type='text' size='40' name='custname' value='#getcustdetail.Name#' maxlength='100'></td>
    </tr>
    <tr>
    <td>Address </td>
    <td><input type='text' size='40' name='add1' value='#getcustdetail.add1#' maxlength='100'></td>
    </tr>
    <tr>
    <td></td>
    <td><input type='text' size='40' name='add2' value='#getcustdetail.add2#' maxlength='100'></td>
    </tr>
    <tr>
    <td></td>
    <td><input type='text' size='40' name='add3' value='#getcustdetail.add3#' maxlength='100'></td>
    </tr>
    <tr>
    <td></td>
    <td><input type='text' size='40' name='add4' value='#getcustdetail.add4#' maxlength='100'></td>
    </tr>
    <tr>
    <td>Contact Person</td>
    <td><select name="honorific" id="honorific">
    <option value="Mr" <cfif getcustdetail.arrem3 eq 'Mr'>selected</cfif>>Mr</option>
    <option value="Mrs" <cfif getcustdetail.arrem3 eq 'Mrs'>selected</cfif>>Mrs</option>
    <option value="Ms" <cfif getcustdetail.arrem3 eq 'Ms'>selected</cfif>>Ms</option>
    </select>
    <input type='text' size='40' name='contactperson' value='#getcustdetail.attn#' maxlength='100'>		</td>
    </tr>
    <tr>
    <td>Postalcode</td>
    <td><input type='text' size='40' name='postalcode' value='#getcustdetail.postalcode#' maxlength='100'></td>
    </tr>
    <tr>
    <td>E-mail</td>
    <td><input type='text' size='40' name='email' value='#getcustdetail.e_mail#' maxlength='100'></td>
    </tr>
    <tr>
    <td>Tel</td>
    <td><input type='text' size='40' name='phone' value='#getcustdetail.phone#' maxlength='100'></td>
    </tr>
    <tr>
    <td>HP</td>
    <td><input type='text' size='40' name='HP' value='#getcustdetail.phonea#' maxlength='100'></td>
    </tr>
    <tr>
    <td>Contact</td>
    <td><input type='text' size='40' name='contact' value='#getcustdetail.contact#' maxlength='100'></td>
    </tr>
    
    <tr>
    <td>Member ID</td>
    <td><input type='text' size='40' name='memberid' value='#getcustdetail.arrem1#' maxlength='15'></td>
    </tr>
    <tr>
    <td>Gender</td>
    <td><select name="gender" id="gender">
    <option value="">Please Select a gender</option>
    <option value="male" <cfif getcustdetail.arrem2 eq 'male'>selected</cfif>>Male</option>
    <option value="female" <cfif getcustdetail.arrem2 eq 'female'>selected</cfif>>Female</option>
    </select>
    </td>
    </tr>
    </table>
</cfoutput>
<script type="text/javascript">
clearform();
</script>