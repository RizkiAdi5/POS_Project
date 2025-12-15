<cfif IsDefined('url.menuID')>
    <cfset URLmenuID = trim(urldecode(url.menuID))>
</cfif>


<cfquery name="getUserDefinedMenu" datasource="#dts#">
   SELECT menu_id,new_menu_name 
   FROM userdefinedmenu
   WHERE menu_id = '#URLmenuID#'
   ORDER BY menu_id;   
</cfquery>

<cfloop query="getUserDefinedMenu">
	<cfset pageTitle = getUserDefinedMenu.new_menu_name>
</cfloop>
