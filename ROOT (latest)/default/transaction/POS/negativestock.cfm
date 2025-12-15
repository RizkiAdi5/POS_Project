<cfoutput>
<div align="center">
<cfform action="negativestockprocess.cfm" method="post">
<h4>Please Key in Password for Allow Negative Stock</h4>
<cfinput type="password" name="passwordString" id="passwordString" required="yes" validateat="onsubmit" message="Password is Required"><br/><br />
<input type="submit" name="btn_sub" value="Submit">&nbsp;&nbsp;<input type="button" name="can_sub" value="Cancel" onClick="ColdFusion.Window.hide('negativestock');">
 </cfform>
</div>
</cfoutput>