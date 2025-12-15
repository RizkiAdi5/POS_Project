<cfquery name="getgsetup" datasource="#dts#">
  select * from gsetup
</cfquery>

<cfform name="createNewColour" id="createNewColour" method="post" action="/default/maintenance/shellvehicles/createNewColourProcess.cfm">
  <table width="1000px" style="font-size:-2">
    <tr>
      <th width="200px" align="left">Colour</th>
      <td><cfoutput>
          <input type="text" size="30" name="colour" value="" maxlength="30">
        </cfoutput></td>
    </tr>
    <tr>
      <th align="left">Description</th>
      <td><cfinput type="text" name="desp" id="desp" size="50" ></td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <cfinput name="SubmitButton" id="SubmitButton" type="submit" value="Submit"/>
</cfform>
