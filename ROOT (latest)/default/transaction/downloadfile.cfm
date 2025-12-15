<cfif isdefined('url.refno') and isdefined('url.type')>
<cfset refno = urldecode(url.refno)>
<cfset type = url.type>
<cfset filename = urldecode(url.filename)>
<cfcontent type="application/unknown">
<cfheader name="Content-Disposition" value="attachement;filename=#filename#">>
<cfcontent type="application/unknown" file="#HRootPath#\download\#dts#\bill\#type#\#url.refno#\#URLDECODE(url.filename)#">
</cfif>