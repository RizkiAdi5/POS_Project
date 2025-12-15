<cfcomponent output="false">
	
        
	<cffunction name="getitem" access="remote" returntype="any">
		<cfargument name="page" required="yes">
      		<cfargument name="pageSize" required="yes">
    		<cfargument name="gridsortcolumn" required="yes">
		<cfargument name="gridsortdirection" required="yes">
        <cfargument name="filtercolumn" required="no" default="">
	    <cfargument name="filter" required="no" default="">
      		<cfargument name="dts" required="no" default="">
	        <cfargument name="uuid" required="no" default="">
        
        	<cfquery name="setCounter" datasource="#dts#">
	        set @counter = 0;

	        </cfquery>

		<cfquery name="getitem" datasource="#dts#">
			select itemno,desp,unit,qtybf,ucost,avcost,avcost2 
			from icitem 
            <cfif Arguments.filtercolumn NEQ "" AND Arguments.filter NEQ "">
				WHERE #Arguments.filtercolumn# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.filter#%">
			</cfif>
			
			<cfif Arguments.gridsortcolumn NEQ "">
				ORDER BY #Arguments.gridsortcolumn# #Arguments.gridsortdirection#
            <cfelse>
            	order by itemno;
			</cfif>

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
                    <cfif colname eq "QTYBF">
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(value)#">
					<cfelse>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#value#">
        	        </cfif>	
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
    
	<cffunction name="getFIFO" access="remote" returntype="any">
		<cfargument name="page" required="yes">
      		<cfargument name="pageSize" required="yes">
    		<cfargument name="gridsortcolumn" required="yes">
		<cfargument name="gridsortdirection" required="yes">
      		<cfargument name="dts" required="no" default="">
	        <cfargument name="uuid" required="no" default="">
        
        	<cfquery name="setCounter" datasource="#dts#">
	        set @counter = 0;
		</cfquery>
	        

		<cfquery name="fifoopq" datasource="#dts#">
			select *
			from fifoopq 
			where itemno='#ARGUMENTS.gridrow.itemno#';
		</cfquery>	   
		
		<cfreturn queryconvertforgrid(getFIFO,Arguments.page,Arguments.pagesize)/>
	    
	</cffunction>

	<cffunction name="editFIFO" access="remote">
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
        	        UPDATE fifoopq
                	SET #colname# = 
	                <cfqueryparam cfsqltype="cf_sql_varchar" value="#value#">
        	        	WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.gridrow.itemno#">
                	</cfquery>
                   </cfcase>
            
                   <!--- Process deletes --->
	           <cfcase value="D">
        	        <!--- Perform actual delete --->
                	<cfquery datasource="#dts#">
		                DELETE FROM fifoopq
        	        	where itemno = #ARGUMENTS.gridrow.itemno#
                	</cfquery>
        	  </cfcase>
        	</cfswitch>
	</cffunction>   
    
    <cffunction name="editFIFO2" access="remote">
    <cfargument name="itemno" type="string" required="yes">
    <cfargument name="gridaction" required="yes">
	        <cfargument name="gridrow" type="struct" required="yes">
        	<cfargument name="gridchanged" type="struct" required="yes">
	        <cfargument name="dts" required="no">
		<cfargument name="HuserID" required="no">
        	<!--- Local variables --->
	        <cfset var colname="">
        	<cfset var value="">
		<cfset SetLocale("English (UK)")>
		<cfset currentdatetime = '#lsdateformat(now(), "YYYY-MM-DD")# #timeformat(now(), "HH:MM:SS")#'>
        
                	<!--- Get column name and value --->
	                <cfset colname=StructKeyList(ARGUMENTS.gridchanged)>
                    <cfif colname eq "Quantity">
                    <cfset colname1='ffq'&'#ARGUMENTS.gridrow.no#'>
                    <cfelseif colname eq "Unit Price">
					<cfset colname1='ffc'&'#ARGUMENTS.gridrow.no#'>
					</cfif>
        	        <cfset value=ARGUMENTS.gridchanged[colname]>
                	<!--- Perform actual update --->
	                 <cfquery datasource="#dts#">
        	        UPDATE fifoopq
                	SET #colname1# = 
	                <cfqueryparam cfsqltype="cf_sql_varchar" value="#value#">
        	        	WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.itemno#">
                	</cfquery>
                  
	</cffunction>   
    
    
    <!--- New opening qty location --->
		
    	<cffunction name="getComm" access="remote" returntype="any">
		<cfargument name="page" required="yes">
      	<cfargument name="pageSize" required="yes">
    	<cfargument name="gridsortcolumn" required="yes">
	    <cfargument name="gridsortdirection" required="yes">
	    <cfargument name="filtercolumn" required="no" default="">
	    <cfargument name="filter" required="no" default="">
        <cfargument name="dts" required="no" default="">
	    
	    <cfquery name="selUsers" datasource="#dts#">
			select location,itemno,locqfield,lreorder,lminimum ,desp
			from locqdbf 
			<cfif Arguments.filtercolumn NEQ "" AND Arguments.filter NEQ "">
				WHERE #Arguments.filtercolumn# 
                
                LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.filter#%">

			</cfif>
			
			<cfif Arguments.gridsortcolumn NEQ "">
				ORDER BY #Arguments.gridsortcolumn# #Arguments.gridsortdirection#,itemno asc
            <cfelse>
            	ORDER BY ITEMNO
			</cfif>
		</cfquery>
		
		<cfreturn queryconvertforgrid(selUsers,Arguments.page,Arguments.pagesize)/>
	    
	</cffunction>
	
	<cffunction name="getCommColumns" access="remote" returntype="any">
    
		<cfargument name="dts" required="no">
		<cfquery name="selUsers" datasource="#dts#" result="selResult">
			select location,itemno,locqfield,lreorder,lminimum 
	from locqdbf 
		</cfquery>
		
		<cfset selColumns = QueryNew("ColumnName,ColumnID")>
		
		<cfloop list="#selResult.columnList#" index="listIndex">
			<cfset temp = QueryAddRow(selColumns,1)>
			<cfset temp = QuerySetCell(selColumns,"ColumnName","#listIndex#")>
			<cfset temp = QuerySetCell(selColumns,"ColumnID","#Val(selColumns.RecordCount-1)#")>
		</cfloop>
		
		<cfreturn selColumns>
		
	</cffunction>
     <cffunction name="editComm" access="remote">
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
   
                
                
                <cfquery datasource="#dts#">
                UPDATE locqdbf
                SET #colname# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(value)#">
                WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.gridrow.itemno#"> and
                location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.gridrow.location#">

                </cfquery>
            </cfcase>
            <!--- Process deletes --->
            <cfcase value="D">
                <!--- Perform actual delete --->
                <cfquery datasource="#dts#">
                DELETE FROM locqdbf
                where itemno = "#ARGUMENTS.gridrow.itemno#" and location = "#ARGUMENTS.gridrow.location#"
                </cfquery>
                
            </cfcase>
        </cfswitch>
    </cffunction>
	
    <cffunction name="getlocation" access="remote" returntype="any">
		<cfargument name="page" required="yes">
      		<cfargument name="pageSize" required="yes">
    		<cfargument name="gridsortcolumn" required="yes">
		<cfargument name="gridsortdirection" required="yes">

      		<cfargument name="dts" required="no" default="">
	        <cfargument name="uuid" required="no" default="">
        
        	<cfquery name="setCounter" datasource="#dts#">
	        set @counter = 0;

	        </cfquery>

		<cfquery name="getlocation" datasource="#dts#">
			select *
			from iclocation 
    
			
			<cfif Arguments.gridsortcolumn NEQ "">
				ORDER BY #Arguments.gridsortcolumn# #Arguments.gridsortdirection#
            <cfelse>
            	order by location;
			</cfif>

		</cfquery>
	   
		
		<cfreturn queryconvertforgrid(getlocation,Arguments.page,Arguments.pagesize)/>
	    
	</cffunction>
    
    <cffunction name="editlocation" access="remote">
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
        	        UPDATE iclocation
                	SET #colname# = 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#value#">
                        WHERE location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.gridrow.location#">
                	</cfquery>
                   </cfcase>
            
                   <!--- Process deletes --->
	           <cfcase value="D">
        	        <!--- Perform actual delete --->
                	<cfquery datasource="#dts#">
		                DELETE FROM iclocation
        	        	where location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.gridrow.location#">
                	</cfquery>
        	  </cfcase>
        	</cfswitch>
	</cffunction>   
    
</cfcomponent>

