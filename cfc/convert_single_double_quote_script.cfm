<cfscript>
	function convertquote(str)
	{
		var converted_single_quote = replace(str,"'","&##x0027;","all");
		var converted_double_quote = replace(converted_single_quote,'"','&##x0022;','all');
		return converted_double_quote;
	}
</cfscript>