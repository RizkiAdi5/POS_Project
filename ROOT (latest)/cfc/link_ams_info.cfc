<cfcomponent>
	<cffunction name="getamslinkinfo" returntype="query">
		<cfquery name="getlinkresult" datasource="main">
			select 
			amsid,
			aes_decrypt(amsipaddress,amsid) as amsipaddress,
			aes_decrypt(amsportno,amsid) as amsportno,
			aes_decrypt(amsusername,amsid) as amsusername,
			aes_decrypt(amspassword,amsid) as amspassword 
			from amssetup;
		</cfquery>
		<cfreturn getlinkresult>
	</cffunction>
</cfcomponent>