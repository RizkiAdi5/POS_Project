<cfoutput>
<html>
<head>
<title>Symbol Maintenance</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function getSymbol(val)
{
var textfield = document.getElementById('selectedField').value;
document.getElementById(textfield).value = val;
}
function getFocus(symbol)
{
document.getElementById('selectedField').value = symbol;
}
</script>
</head>
<body>
<div style="margin:0 auto; widows:1000px;" align="center">
<h1>Symbol Maintenace</h1>

<cfquery name="getSymbol" datasource="#dts#">
SELECT * from symbol
</cfquery>

<h4>Please Insert Your Favourite Symbol as Below</h4>
<form action="/default/maintenance/symbol/symbolMaintenanceProcess.cfm" method="post">
<table width="650px">
<tr>
<td width="400px"><table  class="data" ><tr><td><table  class="data" >
  <tr>
    <th>Symbol 1</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol1" id="symbol1" value="#tostring(BINARYDECODE(getSymbol.symbol1,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol1')" ></td>
    <td></td>
    <th>Symbol 11</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol11" id="symbol11" value="#tostring(BINARYDECODE(getSymbol.symbol11,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol11')" ></td>
  </tr>
  <tr>
    <th>Symbol 2</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol2" id="symbol2" value="#tostring(BINARYDECODE(getSymbol.symbol2,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol2')"></td>
    <td></td>
    <th>Symbol 12</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol12" id="symbol12" value="#tostring(BINARYDECODE(getSymbol.symbol12,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol12')" ></td>
  </tr>
  <tr>
    <th>Symbol 3</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol3" id="symbol3" value="#tostring(BINARYDECODE(getSymbol.symbol3,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol3')"></td>
    <td></td>
    <th>Symbol 13</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol13" id="symbol13" value="#tostring(BINARYDECODE(getSymbol.symbol13,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol13')" ></td>
  </tr>
  <tr>
    <th>Symbol 4</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol4" id="symbol4" value="#tostring(BINARYDECODE(getSymbol.symbol4,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol4')"></td>
    <td></td>
    <th>Symbol 14</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol14" id="symbol14" value="#tostring(BINARYDECODE(getSymbol.symbol14,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol14')" ></td>
  </tr>
  <tr>
    <th>Symbol 5</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol5" id="symbol5" value="#tostring(BINARYDECODE(getSymbol.symbol5,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol5')"></td>
    <td></td>
    <th>Symbol 15</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol15" id="symbol15" value="#tostring(BINARYDECODE(getSymbol.symbol15,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol15')" ></td>
  </tr>
  <tr>
    <th>Symbol 6</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol6" id="symbol6" value="#tostring(BINARYDECODE(getSymbol.symbol6,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol6')"></td>
    <td></td>
    <th>Symbol 16</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol16" id="symbol16" value="#tostring(BINARYDECODE(getSymbol.symbol16,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol16')" ></td>
  </tr>
  <tr>
    <th>Symbol 7</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol7" id="symbol7" value="#tostring(BINARYDECODE(getSymbol.symbol7,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol7')"></td>
    <td></td>
    <th>Symbol 17</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol17" id="symbol17" value="#tostring(BINARYDECODE(getSymbol.symbol17,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol17')" ></td>
  </tr>
  <tr>
    <th>Symbol 8</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol8" id="symbol8" value="#tostring(BINARYDECODE(getSymbol.symbol8,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol8')"></td><td></td><th>Symbol 18</th><td>&nbsp;</td><td><input type="text" name="symbol18" id="symbol18" value="#tostring(BINARYDECODE(getSymbol.symbol18,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol18')" ></td>
  </tr>
  <tr>
    <th>Symbol 9</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol9" id="symbol9" value="#tostring(BINARYDECODE(getSymbol.symbol9,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol9')"></td><td></td><th>Symbol 19</th><td>&nbsp;</td><td><input type="text" name="symbol19" id="symbol19" value="#tostring(BINARYDECODE(getSymbol.symbol19,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol19')" ></td>
  </tr>
  <tr>
    <th>Symbol 10</th>
    <td>&nbsp;</td>
    <td><input type="text" name="symbol10" id="symbol10" value="#tostring(BINARYDECODE(getSymbol.symbol10,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol10')"></td><td></td><th>Symbol 20</th><td>&nbsp;</td><td><input type="text" name="symbol20" id="symbol20" value="#tostring(BINARYDECODE(getSymbol.symbol20,'BASE64'))#" maxlength="3" size="3" onFocus="getFocus('symbol20')" ></td>
  </tr>
  <tr>
    <td colspan="3" align="center"><input type="Submit" name="Submit" value="Save" ></td>
  </tr>
</table></td></tr>
</table>
<input type="hidden" value="" name="selectedField" id="selectedField" >
</td>
<td width="300px" >
<table>
<tr>
<cfloop list="188,189,8531,8532,8533,8534,8535,8536,8537,8538" index="i">
<td width="20" style="font-size:large"><input type="button" value="#chr(i)#" style=" font-family:'Courier New', Courier, monospace;font-size:25px" onClick="getSymbol('#chr(i)#')" ></td>
</cfloop>
</tr>
<tr>
<cfloop list="8539,8540,8541,8542,190,216,181,176,187,8364" index="i">
<td width="20" style="font-size:large"><input type="button" value="#chr(i)#" style=" font-family:'Courier New', Courier, monospace;font-size:25px" onClick="getSymbol('#chr(i)#')"></td>
</cfloop>
</tr>
<tr>
<cfloop list="163,165,169,171,187,174,215,247,178,179" index="i">
<td width="20" style="font-size:large"><input type="button" value="#chr(i)#" style=" font-family:'Courier New', Courier, monospace;font-size:25px" onClick="getSymbol('#chr(i)#')"></td>
</cfloop>
</tr>
<tr><td colspan="10">
<cfloop list="8451,177,9651,9671,9711,9712,9734,164" index="i">
<input type="button" value="#chr(i)#" style=" font-family:'Courier New', Courier, monospace;font-size:25px" onClick="getSymbol('#chr(i)#')">&nbsp;
</cfloop>
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<div>
</body>
</html>
</cfoutput>
