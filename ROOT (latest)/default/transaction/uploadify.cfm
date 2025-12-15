<cfcontent reset="yes" type="text/html">
<cfsetting showdebugoutput="no">
<cfparam name="form.filedata" default="" />
<cfparam name="form.filename" default="" />
<cfparam name="form.folder" default="" />

<!--- got a file to process? --->
<cfif Len(form.filedata)>
<!--- does the requested directory exist? --->
<cfif not DirectoryExists(ExpandPath(form.folder))>
<cfdirectory action="create" directory="#ExpandPath(form.folder)#" />
</cfif>

<!--- move the file out of the CF tmp directory to the requested location --->
<cffile accept="*" filefield="filedata" action="upload" nameconflict="overwrite" destination="#ExpandPath(form.folder)#\#form.filename#" > 
</cfif>
<cfcontent reset="yes" type="text/html">
<cfoutput>#cffile.serverFile#</cfoutput>