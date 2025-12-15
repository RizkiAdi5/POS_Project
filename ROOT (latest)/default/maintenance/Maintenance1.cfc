<cfcomponent output="false">
	
        
	<cffunction name="getitem" access="remote" returntype="any">
		<cfargument name="page" required="yes">
      		<cfargument name="pageSize" required="yes">
    		<cfargument name="gridsortcolumn" required="yes">
		<cfargument name="gridsortdirection" required="yes">
      		<cfargument name="dts" required="no" default="">
	        <cfargument name="uuid" required="no" default="">
        
        	<cfquery name="setCounter" datasource="#dts#">
	        set @counter = 0;

	        </cfquery>

		<cfquery name="getitem" datasource="#dts#">
			select itemno,desp,unit,qtybf,ucost,avcost,avcost2 
			from icitem 
			order by itemno;
		</cfquery>
	   
		
		<cfreturn queryconvertforgrid(getitem,Arguments.page,Arguments.pagesize)/>
	    
	</cffunction>
    
        <cffunction name="editItemOP" access="remote">
        	<cfargument name="gridaction" type="string" required="yes">
	        <cfargument name="gridrow" type="struct" required="yes">
        	<cfargument name="gridchanged" type="struct" required="yes">
	        <cfargument name="dts" required="no">
		<cfargument name="HuserID" required="no">
        	<!--- Local variables --->
	        <cfset var colname="">
        	<cfset var value="">
		<cfset SetLocale("English (UK)")>
		<cfset currentdatetime = '#lsdateformat(now(), "YYYY-MM-DD")# #timeformat(now(), "HH:MM:SS")#'>
        	<!--- Process gridaction --->
	        <cfswitch expression="#ARGUMENTS.gridaction#">
        	   <!--- Process updates --->
    	           <cfcase value="U">
                	<!--- Get column name and value --->
	                <cfset colname=StructKeyList(ARGUMENTS.gridchanged)>
        	        <cfset value=ARGUMENTS.gridchanged[colname]>
                	<!--- Perform actual update --->
	                 <cfquery datasource="#dts#">
        	        UPDATE icitem
                	SET #colname# = 
	                <cfqueryparam cfsqltype="cf_sql_varchar" value="#value#">
        	        	WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.gridrow.itemno#">
                	</cfquery>
                   </cfcase>
            
                   <!--- Process deletes --->
	           <cfcase value="D">
        	        <!--- Perform actual delete --->
                	<cfquery datasource="#dts#">
		                DELETE FROM icitem
        	        	where itemno = #ARGUMENTS.gridrow.itemno#
                	</cfquery>
        	  </cfcase>
        	</cfswitch>
    </cffunction>   
   
</cfcomponent>