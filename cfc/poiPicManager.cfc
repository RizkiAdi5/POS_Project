<cfcomponent output="false">
	<cffunction name="getPOIPictureType" access="public" returntype="numeric" output="false">
		<cfargument name="fileExtension" type="string">
		<cfargument name="workbook" type="any" required="true">
		
		<cfset var type = "" >
		<cfswitch expression="#arguments.fileExtension#">
			<!--- PNG format --->
		    <cfcase value="PNG">
				<cfset type = arguments.workbook.PICTURE_TYPE_PNG>
		    </cfcase>
		    <!--- JPEG format --->
		    <cfcase value="JPG,JPEG">
		        <cfset type = arguments.workbook.PICTURE_TYPE_JPEG>
		    </cfcase>
		    <!--- Device independant bitmap --->
		    <cfcase value="BMP,DIB">
		        <cfset type = arguments.workbook.PICTURE_TYPE_DIB>
		    </cfcase>
		    <!--- Mac PICT format --->
		    <cfcase value="EMF">
		        <cfset type = arguments.workbook.PICTURE_TYPE_EMF>
		    </cfcase>
		    <!--- Mac PICT format --->
		    <cfcase value="PICT,PCT">
		        <cfset type = arguments.workbook.PICTURE_TYPE_PICT>
		    </cfcase>
		    <!--- Windows Meta File --->
		    <cfcase value="WMF">
		        <cfset type = arguments.workbook.PICTURE_TYPE_WMF>
		    </cfcase>
		
		    <cfdefaultcase>
		        <cfthrow message="Invalid or unhandled file extension [#arguments.fileExtension#]">
		    </cfdefaultcase>
		</cfswitch>
		
		<cfreturn type>
	</cffunction>

	<cffunction name="loadPicture" access="public" returntype="numeric" output="false"> 
		<cfargument name="path" type="string"  required="true"> 
	    <cfargument name="workbook" type="any" required="true"> 
	    <cfset var Local = structNew()> 
	
	    <cfscript> 
			Local.index = 0; 
	        Local.errorMessage = ""; 
	
	        try { 
				Local.fis = createObject("java", "java.io.FileInputStream").init( arguments.path ); 
	            Local.bao = createObject("java", "java.io.ByteArrayOutputStream").init(); 
	            Local.c = Local.fis.read(); 
	            
	            while ( Local.c neq -1 ) 
	            { 
					Local.bao.write( Local.c ); 
	                Local.c = Local.fis.read(); 
	            } 
	
				// Note: Assumes image is PNG format. Adapt if needed 
				Local.index = arguments.workbook.addPicture( Local.bao.toByteArray(), arguments.workbook.PICTURE_TYPE_PNG); 
			} 
	        catch (Any e) { 
				Local.errorMessage = e.Message &" "& e.Detail; 
	        } 
	        // always close the input stream     
	        if ( structKeyExists(Local, "fis") ) { 
	            Local.fis.close(); 
	        }             
		</cfscript> 
	
	    <!--- if an error occurred, rethrow it ---> 
	    <cfif len(Local.errorMessage)> 
	        <cfthrow message="#Local.errorMessage#" type="UnableToLoadPicture"> 
	    </cfif> 
	
	    <cfreturn Local.index > 
	</cffunction>
</cfcomponent>