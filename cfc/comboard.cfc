<cfcomponent>
<cftry>
	<cffunction name="display" access="public">
		<cfargument name="firstline" type="any" required="yes">
        <cfargument name="secondlineleft" type="any" required="yes">
        <cfargument name="secondlineright" type="any" required="yes">
        <cfargument name="comchannel" type="any" required="yes">
        <cfexecute arguments="#comchannel#:9600,n,8,1" name="C:\Windows\System32\mode.com">
        </cfexecute>
        <cfset currentDirectory = GetDirectoryFromPath(GetTemplatePath())>
		<cfset runfile = currentDirectory&"\"&"commboard.bat">
        <cfif len(firstline) gt 20>
        <cfset firstline = left(firstline,20)>
		</cfif>
        <cfif len(firstline) neq 20>
        <cfloop from="1" to="#20-len(firstline)#" index="i">
        <cfset firstline = firstline&" ">
        </cfloop>
		</cfif>
        <cfif len(secondlineleft) gt 10>
        <cfset secondlineleft = left(secondlineleft,10)>
		</cfif>
        <cfif len(secondlineleft) neq 10>
        <cfloop from="1" to="#10-len(secondlineleft)#" index="i">
        <cfset secondlineleft = secondlineleft&" ">
        </cfloop>
		</cfif>
        <cfif len(secondlineright) gt 10>
        <cfset secondlineright = left(secondlineright,10)>
		</cfif>
        <cfif len(secondlineright) neq 10>
        <cfloop from="1" to="#10-len(secondlineright)#" index="i">
        <cfset secondlineright = " "&secondlineright>
        </cfloop>
		</cfif>
        <cfset filecontent = "echo 11111111111111111111"&firstline&secondlineleft&secondlineright&">"&comchannel>
        <cffile action="Write" 
                    file="#runfile#" 
                    output="#filecontent#" nameconflict="overwrite"> 
		<cfthread action="sleep" duration="100"/>

        <cfexecute name = "#runfile#" timeout="120">
        </cfexecute>
	</cffunction>
<cfcatch>
</cfcatch>
</cftry>
</cfcomponent>