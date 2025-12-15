<cfoutput>
<div align="center">

<h4>Please Key in Password for Negaitve Limit</h4>
<input type="password" name="passwordString" id="passwordString" ><br/><br />
<div id="negativeqtyajax"></div>
<input type="button" name="btn_sub" value="Submit" onClick="ajaxFunction(document.getElementById('negativeqtyajax'),'negativeqtyprocess.cfm?passwordString='+document.getElementById('passwordString').value);setTimeout('checkpasswordnegativeqty();',200);">&nbsp;&nbsp;<input type="button" name="can_sub" value="Cancel" onClick="ColdFusion.Window.hide('negativeqty');">

</div>
</cfoutput>