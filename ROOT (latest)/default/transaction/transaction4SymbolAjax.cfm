
            <div align="center">
		
            <cfoutput>
            <cfquery name="getSymbol" datasource="#dts#">
            select * from symbol
            </cfquery>
            <table width="280">
            <tr>
            <td  ><input style=" font-family:'Courier New', Courier, monospace;font-size:20px" name="symbol1" id="symbol1" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol1,'BASE64'))#" onClick="insertSymbol('symbol1')" size="20"  /></td>
            <td  s><input style=" font-family:'Courier New', Courier, monospace;font-size:20px" name="symbol2" id="symbol2" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol2,'BASE64'))#" onClick="insertSymbol('symbol2')"/></td>
            <td  ><input name="symbol3" id="symbol3" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol3,'BASE64'))#" style="font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol3')"/></td>
            <td  ><input name="symbol4" id="symbol4" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol4,'BASE64'))#" style="font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol4')"/></td>
            </tr>
            <tr>
            <td><input  style=" font-family:'Courier New', Courier, monospace;font-size:20px" name="symbol5" id="symbol5" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol5,'BASE64'))#" onClick="insertSymbol('symbol5')"/></td>
            <td ><input style=" font-family:'Courier New', Courier, monospace;font-size:20px"name="symbol6" id="symbol6" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol6,'BASE64'))#" onClick="insertSymbol('symbol6')"/></td>
            <td ><input name="symbol7" id="symbol7" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol7,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol7')"/></td>
            <td  ><input name="symbol8" id="symbol8" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol8,'BASE64'))#" style="font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol8')"/></td>
            </tr>
            <tr>
            <td ><input name="symbol9" id="symbol9" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol9,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol9')"/></td>
            <td ><input name="symbol10" id="symbol10" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol10,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol10')"/></td>
            <td ><input name="symbol11" id="symbol11" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol11,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol11')"/></td>
            <td  ><input name="symbol12" id="symbol12" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol12,'BASE64'))#" style="font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol12')"/></td>
            </tr>
            <tr>
            <td ><input name="symbol13" id="symbol13" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol13,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol13')"/></td>
            <td ><input name="symbol14" id="symbol14" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol14,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol14')"/></td>
            <td ><input name="symbol15" id="symbol15" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol15,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol15')"/></td>
            <td  ><input name="symbol16" id="symbol16" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol16,'BASE64'))#" style="font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol16')"/></td>
            </tr>
            <tr>
            <td ><input name="symbol17" id="symbol17" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol17,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol17')"/></td>
            <td ><input name="symbol18" id="symbol18" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol18,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol18')"/></td>
            <td ><input name="symbol19" id="symbol19" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol19,'BASE64'))#" style=" font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol19')"/></td>
            <td  ><input name="symbol20" id="symbol20" type="button" value="#tostring(BINARYDECODE(getSymbol.symbol20,'BASE64'))#" style="font-family:'Courier New', Courier, monospace;font-size:20px" onClick="insertSymbol('symbol20')"/></td>
            </tr>
            </table>
            </div>
            </cfoutput>