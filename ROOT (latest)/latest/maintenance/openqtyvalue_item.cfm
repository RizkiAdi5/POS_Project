<cfif IsDefined('url.itemno')>
	<cfset itemno = trim(urldecode(url.itemno))>
</cfif>

<html>
<head>
<title>Enquiry Opening Value</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<cfoutput>

<cfquery name="getgsetup" datasource="#dts#">
	select * 
    from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select concat(',.',(repeat('_',decl_uprice))) as decl_uprice 
	from gsetup2
</cfquery>

<cfset valuefifo = 0>
<cfset lastcost = 0>

 <cfquery name="getitem" datasource="#dts#">
	select itemno,desp,qtybf,ucost,avcost,avcost2 
	from icitem 
    where itemno='#itemno#';
</cfquery>

<cfquery name="check" datasource="#dts#">
    select itemno 
    from fifoopq 
    where itemno='#getitem.itemno#';
</cfquery>

 <cfquery name="getrc" datasource="#dts#">
    select qty, amt, amt_bil, price, price_bil 
    from ictran 
    where itemno='#getitem.itemno#'
</cfquery>



<cfif check.recordcount gt 0>

	<cfset cntLP = 11>
	
<cfset ffc = "ffc"&"#cntLP#">
<cfset ffq = "ffq"&"#cntLP#">
        <cfquery name="getopq" datasource="#dts#">
				select #ffq# as affq, #ffc# as affc
				from fifoopq 
				where itemno='#itemno#';
		</cfquery>
        
					<cfset lastcost = getopq.affc>
					
	
	<cfloop index="i" from="50" to="11" step="-1">
		
<cfset ffq = "ffq"&"#i#">
<cfset ffc = "ffc"&"#i#">

<cfquery name="getfifoopq" datasource="#dts#">
        select #ffq# as xffq, #ffc# as xffc
        from fifoopq 
        where itemno='#getitem.itemno#';
</cfquery>
		    
	<cfset valuefifounit = getfifoopq.xffq * getfifoopq.xffc>
	<cfset valuefifo = val(valuefifo) + val(valuefifounit)>

     </cfloop>

<cfelse>

<cfquery name="getfifoopq" datasource="#dts#">
      select qtybf, ucost as lastcost 
      from icitem 
      where itemno='#getitem.itemno#';
</cfquery>

<cfset lastcost = val(getfifoopq.lastcost)>
  <cfset valuefifo = round(val(getfifoopq.lastcost) * val(getfifoopq.qtybf))>
  </cfif>
                
<body>

<h2 align="center">Item No - <cfoutput>#itemno#</cfoutput></h2>
<cfloop query="getitem">
            <cfset valueqty= round(val(getitem.ucost) * val(getitem.qtybf))>
			<cfset valuemthave= round(val(getitem.avcost) * val(getitem.qtybf))>
			<cfset valuemovave= round(val(getitem.avcost2) * val(getitem.qtybf))>
            <table width="700" border="0" cellspacing="0" cellpadding="2" class="data" align="center">
              <tr>
                <td width="150"></td>
                <td colspan="6"></td>
              </tr>
              <tr>
                <th width="150">Item No </th>
                <td colspan="6">#itemno#</td>
              </tr>
              <tr>
                <th width="150">Item description </th>
                <td colspan="6">#desp#</td>
              </tr>
              <tr>
                <td width="150">&nbsp;</td>
                <th><div align="right">Quantity </div></th>
                <th colspan="4"><div align="right">Cost </div></th>
                <th><div align="right">Value </div></th>
              </tr>
              <tr>
                <th width="150">By Fixed Cost </th>
                <td><div align="right">#numberformat(qtybf,",_.___")#</div></td>
                <td colspan="4"><div align="right">#numberformat(ucost,",_._______")#</div></td>
                <td><div align="right">#numberformat(valueqty,",_.__")#</div></td>
              </tr>
              <tr>
                <th width="150">By Mth. Ave Cost</th>
                <td><div align="right">#numberformat(qtybf,",_.___")#</div></td>
                <td colspan="4"><div align="right">#numberformat(avcost,",_._______")#</div></td>
                <td><div align="right">#numberformat(valuemthave,",_.__")#</div></td>
              </tr>
              <tr>
                <th width="150">By Mov. Ave Cost</th>
                <td><div align="right">#numberformat(qtybf,",_.___")#</div></td>
                <td colspan="4"><div align="right">#numberformat(avcost2,",_._______")#</div></td>
                <td><div align="right">#numberformat(valuemovave,",_.__")#</div></td>
              </tr>
              <tr>
                <th width="150">FIFO</th>
                <td><div align="right">#numberformat(qtybf,",_.___")#</div></td>
                <td colspan="4"><div align="right">#numberformat(lastcost,",_._______")#</div></td>
                <td><div align="right">#numberformat(valuefifo,",_.__")#</div></td>
              </tr>
              <tr>
                <td colspan="7">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="7"><table width="700" border="0" cellpadding="3" cellspacing="0">
                    <tr>
                      <th colspan="4"><div align="center">FIFO Opening Qty &amp; Cost</div></th>
                    </tr>
                    <tr>
                      <td><table width="200" border="0" cellpadding="5" cellspacing="1">
                          <tr>
                            <th>&nbsp;</th>
                            <th><div align="center">Qty</div></th>
                            <th><div align="right">Cost</div></th>
                          </tr>
                        
<cfset cnt = 50>

<cfloop condition="cnt gte 37">
<cfset ffq = "ffq"&"#cnt#">
<cfset ffc = "ffc"&"#cnt#">
                                
<cfquery name="getopq" datasource="#dts#">
		select #ffq# as affq, #ffc# as affc
		from fifoopq 
		where itemno='#itemno#';
</cfquery>

 	<cfif getopq.affq eq "">
   		 <cfset vffq = 0>
	<cfelse>
          <cfset vffq = getopq.affq>
	</cfif>
    
    <cfif getopq.affc eq "">
          <cfset vffc = 0>
     <cfelse>
           <cfset vffc = getopq.affc>
     </cfif>
           <cfset cnt2 = cnt -10>
  <tr>
<td><cfif cnt eq 50>OLDEST<cfelse>#cnt2#
    </cfif></td>
    
             <td><div align="center">#numberformat(vffq,",_.___")#</div></td>
             <td><div align="right">#numberformat(vffc,",_._______")#</div></td>
</tr>
    <cfset cnt = cnt -1>
    </cfloop>
    </table>
    </td>
                      <td width="300"><table width="200" border="0" align="center" cellpadding="5" cellspacing="1">
                        <tr>
                          <th>&nbsp;</th>
                          <th><div align="center">Qty</div></th>
                          <th><div align="right">Cost</div></th>
                        </tr>
						
<cfset cnt = 36>

<cfloop condition="cnt gte 24">
<cfset ffq = "ffq"&"#cnt#">
<cfset ffc = "ffc"&"#cnt#">
                                
<cfquery name="getopq" datasource="#dts#">
		select #ffq# as affq, #ffc# as affc
		from fifoopq 
		where itemno='#itemno#';
</cfquery>

 	<cfif getopq.affq eq "">
   		 <cfset vffq = 0>
	<cfelse>
          <cfset vffq = getopq.affq>
	</cfif>
    
    <cfif getopq.affc eq "">
          <cfset vffc = 0>
     <cfelse>
           <cfset vffc = getopq.affc>
     </cfif>
           <cfset cnt2 = cnt -10>
  <tr>
<td><cfif cnt eq 50>OLDEST<cfelse>#cnt2#
    </cfif></td>
    
             <td><div align="center">#numberformat(vffq,",_.___")#</div></td>
             <td><div align="right">#numberformat(vffc,",_._______")#</div></td>
  </tr>
    <cfset cnt = cnt -1>
    </cfloop> </table>
                       
                          
                     </td>
                      <td><table width="200" border="0" align="right" cellpadding="5" cellspacing="1">
                          <tr>
                            <th>&nbsp;</th>
                            <th><div align="center">Qty</div></th>
                            <th><div align="right">Cost</div></th>
                          </tr>
     <cfset cnt = 23>
     <cfloop condition="cnt gte 11">
             <cfset ffq = "ffq"&"#cnt#">
            <cfset ffc = "ffc"&"#cnt#">
            
        <cfquery name="getopq" datasource="#dts#">
				select #ffq# as affq, #ffc# as affc
				from fifoopq 
				where itemno='#itemno#';
		</cfquery>
        
          <cfif getopq.affq eq "">
            <cfset vffq = 0>
             <cfelse>
             <cfset vffq = getopq.affq>
              </cfif>
                    <cfif getopq.affc eq "">
                              <cfset vffc = 0>
                              <cfelse>
                              <cfset vffc = getopq.affc>
                            </cfif>
                    <cfset cnt2 = cnt -10>
                            <tr>
                              <td><cfif cnt eq 50>
                                OLDEST
                                    <cfelse>
                                #cnt2#
                              </cfif></td>
                              <td><div align="center">#numberformat(vffq,",_.___")#</div></td>
                              <td><div align="right">#numberformat(vffc,",_._______")#</div></td>
                            </tr>
                    <cfset cnt = cnt -1>
                          </cfloop>
                      </table></td>
                    </tr>
                </table></td>
              </tr>
            </table>
</cfloop>


<table align="center">
	<tr><td><input type="button" name="button" value="Back" onClick="javascript:history.back();"></td></tr>
</table>
</body>
</cfoutput>
</html>


