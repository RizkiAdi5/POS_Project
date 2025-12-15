<cfcomponent>
	<cffunction name="getcostformula" access="remote" returntype="string">
		<cfargument name="dts" type="string" required="yes">
        <cfargument name="ucost" type="string" required="no">
        <cftry>
        <cfset cost1=listgetat(ucost,1,'.')>
        <cfset cost2=listgetat(ucost,2,'.')>
        <cfcatch>
        
        <cfset cost1=ucost>
        <cfset cost2=''>
        </cfcatch></cftry>
        
        <cfquery name="getcostcodeformula" datasource="#dts#">
        SELECT * from costcodesetup
        </cfquery>
        <cfif getcostcodeformula.recordcount neq 0>
        <cfset newcostcode=ucost>
        
        <cfloop from="0" to="9" index="i">
        <cfset newcostcode=replace(newcostcode,i,evaluate("getcostcodeformula.costcode#i#"),"All")>
        </cfloop>
        <cfset newcostcode=replace(newcostcode,'.',getcostcodeformula.costcodedot,"All")>
        
        <cfset myResult=newcostcode>
        
        <cfelse>
        
        <cfquery name="getformula" datasource="#dts#">
        SELECT * from gsetup
        </cfquery>
        <cfset itemnumber = arraynew(1)>
        <cfset itemnumber[1]=left(getformula.costformula1,1)>
		<cfset itemnumber[2]=mid(getformula.costformula1,2,1)>
        <cfset itemnumber[3]=mid(getformula.costformula1,3,1)>
        <cfset itemnumber[4]=mid(getformula.costformula1,4,1)>
        <cfset itemnumber[5]=mid(getformula.costformula1,5,1)>
        <cfset itemnumber[6]=mid(getformula.costformula1,6,1)>
        <cfset itemnumber[7]=mid(getformula.costformula1,7,1)>
        <cfset itemnumber[8]=mid(getformula.costformula1,8,1)>
        <cfset itemnumber[9]=mid(getformula.costformula1,9,1)>
        <cfset itemnumber[10]=mid(getformula.costformula1,10,1)>

        <cfloop from="1" to="9" index="i">
        <cfset cost1=replace(cost1,i,itemnumber[i],"All")>
        </cfloop>
        
        <cfset itemnumber2 = arraynew(1)>
        <cfset itemnumber2[1]=left(getformula.costformula3,1)>
		<cfset itemnumber2[2]=mid(getformula.costformula3,2,1)>
        <cfset itemnumber2[3]=mid(getformula.costformula3,3,1)>
        <cfset itemnumber2[4]=mid(getformula.costformula3,4,1)>
        <cfset itemnumber2[5]=mid(getformula.costformula3,5,1)>
        <cfset itemnumber2[6]=mid(getformula.costformula3,6,1)>
        <cfset itemnumber2[7]=mid(getformula.costformula3,7,1)>
        <cfset itemnumber2[8]=mid(getformula.costformula3,8,1)>
        <cfset itemnumber2[9]=mid(getformula.costformula3,9,1)>
        <cfset itemnumber2[10]=mid(getformula.costformula3,10,1)>
        
        <cfloop from="1" to="9" index="i">
        <cfset cost2=replace(cost2,i,itemnumber2[i],"All")>
        </cfloop>
        
        <cfif cost2 eq ''>
        <cfset myResult=replace(cost1,'0',itemnumber[10],"All")&getformula.costformula2>
        <cfelse>
		<cfset myResult=replace(cost1,'0',itemnumber[10],"All")&getformula.costformula2&replace(cost2,'0',itemnumber2[10],"All")>
        </cfif>
        </cfif>
        
		<cfreturn myResult>
	</cffunction>
    
</cfcomponent>