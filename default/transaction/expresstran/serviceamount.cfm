<cfoutput>
<div align="center">
<cfform action="serviceamountprocess.cfm" method="post">
<h4>Please Key in Service Amount</h4>
<cfinput type="text" name="serviceamount" id="serviceamount" required="yes" validateat="onsubmit" message="Service Amount is Required"><br/><br />
<input type="submit" name="btn_sub" value="Submit">&nbsp;&nbsp;<input type="button" name="can_sub" value="Cancel" onClick="ColdFusion.Window.hide('serviceamount');">
 </cfform>
</div>
</cfoutput>