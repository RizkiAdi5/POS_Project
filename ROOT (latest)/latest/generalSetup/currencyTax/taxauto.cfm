<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1908, 1896, 965, 56, 65, 1909, 1910, 1911, 1901, 1912">
<cfinclude template="/latest/words.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<cfoutput><title>#words[1908]#</title></cfoutput>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../../stylesheet/stylesheet.css">
</head>
<h1 align="center"><cfoutput>#words[1896]#</cfoutput></h1>
<cfif Hlinkams eq "Y">
	<cfquery name="getdata" datasource="#replace(LCASE(dts),'_i','_a','all')#">
		select distinct accno 
        from gldata 
        order by accno
	</cfquery>
</cfif>

<cfquery name="getgsetup" datasource="#dts#">
    SELECT ctycode,bcurr 
    FROM gsetup;
</cfquery>


<form action="taxAutoProcess.cfm" method="post">
<cfoutput>
<table width="70%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th width="8%">#words[965]#</th>
		<th width="10%">#words[56]#</th>
		<th width="40%">#words[65]#</th>
		<th width="8%">#words[1909]#</th>
		<th width="10%">#words[1910]#</th>
		<th width="10%">#words[1911]#</th>
		<th width="14%">#words[1901]#</th>
	</tr>

    <cfif getgsetup.ctycode eq "MYR">
    	<cfset currcode = "MYR">
    	<cfset taxlist ="TX,IM,IS,BL,NR,ZP,EP,OP,TX-E43,TX-N43,TX-RE,GP,AJP,SR,ZRL,ZRE,ES43,DS,OS,ES,RS,GS,AJS">
	<cfelseif getgsetup.ctycode eq "IDR">
    	<cfset currcode = "IDR">
        <cfset taxlist ="PPh23P4,PPh23R4,PPNR,PPh23R2,PPNP,PPh23P2,PPh23R3,PPh23P3,PPh23R5,PPh23P5,PPh23R6,PPh23P6,PPh23R10,PPh23P10">   
    <cfelseif getgsetup.ctycode eq "PHP">  
        <cfset currcode = "PHP">
        <cfset taxlist ="VAT-P,VAT-S,XVAT-P,XVAT-S"> 
    <cfelse>
    	<cfset currcode = "SGD">
    	<cfset taxlist ="TX,IM,ME,BL,NR,ZP,EP,OP,TX-E33,TX-N33,TX-RE,SR,ZR,ES33,ESN33,DS,OS">
    </cfif>

    <cfquery name="getcurrencytax" datasource="main">
        select * 
        from taxcode 
        where currcode="#currcode#"
	</cfquery>
    
    <!--- <cfset taxlist=valuelist(getcurrencytax.code)> --->
    
    <cfquery name="deletenotrelatedtax" datasource="#dts#">
    	delete from #target_taxtable# 
        where currcode<>"#currcode#"
    </cfquery>
	
	<cfloop index="looptype" list="#taxlist#" delimiters=",">
		<cfquery name="gettaxcode" datasource="main">
			select * 
            from taxcode 
            where code='#looptype#' 
            and length(type) >= 2 
            and currcode="#currcode#"            
		</cfquery>
		<cfquery name="checkcode" datasource="#dts#">
			select * 
            from #target_taxtable# 
            where code='#looptype#' 
            and tax_type="#gettaxcode.type#" 
            and tax_type2="#gettaxcode.type2#"
		</cfquery>
		
		<cfloop query="gettaxcode">
	<tr>
		<td>
			<input type="checkbox" name="gsttax" id="gsttax" value="#gettaxcode.code#"
				<cfif checkcode.recordcount neq 0>disabled="disabled"<cfelse>checked="checked"</cfif>></td>
		<td>#gettaxcode.code#<input type="hidden" name="currcode#gettaxcode.code#" id="currcode#gettaxcode.code#" value="#gettaxcode.currcode#" readonly></td>
		<td>
			<input type="text" name="desp#gettaxcode.code#" id="desp#gettaxcode.code#" value="#gettaxcode.desp#" size="50" readonly>
		</td>
		<td>
			<input type="text" name="rate#gettaxcode.code#" id="rate#gettaxcode.code#" value="#gettaxcode.rate1#" size="8" readonly>
		</td>
		<td>
			<input type="text" name="type#gettaxcode.code#" id="type#gettaxcode.code#" value="#gettaxcode.type#" size="8" readonly>
		</td>
		<td>
			<input type="text" name="type2#gettaxcode.code#" id="type2#gettaxcode.code#" value="#gettaxcode.type2#" size="8" readonly>
		</td>
		<td>
        <cfif Hlinkams eq "Y">
			<select name="corr_accno#gettaxcode.code#">
				<option value="">--</option>
          		<cfoutput><cfloop query="getdata">
            	<option value="#accno#">#accno#</option>
          		</cfloop></cfoutput>
      		</select>
            <cfelse>
            <input type="text" name="corr_accno#gettaxcode.code#" value="">
            </cfif>
		</td>
	</tr>
		</cfloop>
	</cfloop>
</table>
<table width="70%" align="center">
	<tr><td>* #words[1912]#.</td></tr>
	<tr><td align="center">
		<input type="submit" name="submit" value="Submit">&nbsp;
		<input type="submit" name="cancel" value="Cancel">
	</td></tr>
</table>
</cfoutput>
</form>
</body>
</html>
