<cfcomponent>
<cftry>
	<cffunction name="display" access="public">
        <cfset currentDirectory = GetDirectoryFromPath(GetTemplatePath())>
		<cfset runfile = currentDirectory&"\"&"opendrawer.bat">
		<cfthread action="sleep" duration="150"/>
        <cfexecute name = "#runfile#" timeout="120">
        </cfexecute>
		<cfexecute name = "C:\Windows\System32\cmd.exe" arguments="/c #runfile#">
		</cfexecute>
	</cffunction>
<cfcatch>
</cfcatch>
</cftry>
</cfcomponent>