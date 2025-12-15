<cfcomponent>
<cffunction name="getCode128" returntype="any" access="remote" output="true">
     <cfargument name="data" type="string" required="true" />
     <cfargument name="width" type="string" required="true" />
     <cfsetting showdebugoutput="false">
     <cfscript>
     Barcode = createObject("java", "net.sourceforge.barbecue.linear.code128.Code128Barcode").init(data);
     BarcodeImageHandler = createObject("java", "net.sourceforge.barbecue.BarcodeImageHandler");
     Barcode.setDrawingText(false);
     Barcode.setBarHeight(50);
     Barcode.setBarWidth(val(width));
     context = getPageContext();
     context.setFlushOutput(false);
     response = context.getResponse().getResponse();
     response.setContentType("image/jpeg");
     BarcodeImageHandler.writeJPEG(Barcode, response.getOutputStream());
     response.flush();
     response.close();
     </cfscript>
     <!---Return the information as streaming bytes of type image/jpeg--->
     <cfreturn>
</cffunction>
</cfcomponent>