<html>
<head>
<title>Check Material</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select compro from gsetup
</cfquery>

<body>
<div align="center"><font color="#000000" size="4" face="Times New Roman,Times,serif">CHECK MATERIAL</font></div>

<table width="100%" border="0" cellpadding="3" align="center">
	<cfquery name="getdesp" datasource="#dts#">
		select desp 
		from icitem 
		where itemno='#form.getitem#'
	</cfquery>
	
	<cfoutput>
	
	<cfif lcase(HcomID) neq "ideal_i" and lcase(HcomID) neq "idealb_i">
		<font color="000000" size="2" face="Times New Roman, Times, serif">#form.getitem# ~ #getdesp.desp#</font><br/><br/>
	</cfif>
	
	<tr>
		<td colspan="7"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
      	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
    <tr>
      	<td colspan="8"><hr></td>
    </tr>
    <tr>
      	<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><strong>MATERIAL REQUIRED</strong></font></td>
        <cfif form.location neq "">
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>LOCATION</strong></font></div></td>
        </cfif>
     	<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>QTY REQ./PER ITEM</strong></font></div></td>
      	<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL QTY REQ.</strong></font></div></td>
      	<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>ON HAND </strong></font></div></td>
      	<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>BALANCE</strong></font></div></td>
      	<td></td>
    </tr>
    <tr>
      	<td colspan="8"><hr></td>
    </tr>

	<cfquery name="check_material_balance" datasource="#dts#">
		select 
		a.itemno,a.bomno,a.bmitemno,a.bmqty,a.bmlocation,a.assm_group,
		b.desp,b.qtybf,b.unit,
		c.suminqty,
		d.sumoutqty,
		(ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0)) as balance_on_hand,
		((ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0))-(#val(form.qty)#*ifnull(a.bmqty,0))) as balance,
		if(((ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0))-(#val(form.qty)#*ifnull(a.bmqty,0)))< 0,'XX','OK') as status
		 
		from billmat as a
		
		left join 
		(
			select itemno,desp,qtybf,unit 
			from icitem 
		) as b on a.bmitemno=b.itemno 
		
		left join 
		(
			select itemno,sum(qty) as suminqty 
			from ictran 
			where type in ('RC','CN','TRIN','OAI') and (void='' or void is null)
            and fperiod !='99'
			group by itemno 
			order by itemno
		) as c on a.bmitemno=c.itemno 
		
		left join 
		(
			select itemno,sum(qty) as sumoutqty 
			from ictran 
			where type in ('INV','DN','CS','PR','TROU','ISS','OAR','DO') and (void='' or void is null) and (toinv='' or toinv is null) 
            and fperiod !='99'
            and (toinv='' or toinv is null) 
			group by itemno 
			order by itemno
		) as d on a.bmitemno=d.itemno 
		
		where a.itemno='#jsstringformat(form.getitem)#' 
		group by a.bomno,a.bmitemno 
		order by status,a.bomno,a.bmitemno
	</cfquery>

	<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
		<tr><td colspan="100%"><div align="left"><font size="2" face="Times New Roman,Times,serif"><i>#form.getitem# ~ #getdesp.desp#</i></font></div></td></tr>
	</cfif>
	<cfloop query="check_material_balance">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance.bomno#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance.bmitemno#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance.desp#</font></div></td>
            <cfif form.location neq "">
            <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#form.location#</font></div></td>
            <cfquery name="getlocationbalance" datasource="#dts#">
            select 
            c.balance
            
            from icitem as a 
            
            left join 
            (
                select 
                location,
                itemno,
                (select desp from iclocation where location=locqdbf.location) as locationdesp 
                from locqdbf
                where itemno=itemno 
                and itemno='#check_material_balance.bmitemno#' 
                <cfif form.location neq "">
                and location ='#form.location#'
                </cfif>
            ) as b on a.itemno=b.itemno 
            
            left join 
            (
                select 
                a.location,
                a.itemno,
                (ifnull(a.locqfield,0)+ifnull(b.sum_in,0)-ifnull(c.sum_out,0)) as balance 
                
                from locqdbf as a 
                
                left join
                (
                    select 
                    location,
                    itemno,
                    sum(qty) as sum_in 
                    
                    from ictran
                    
                    where type in ('RC','CN','OAI','TRIN') 
                    and fperiod<>'99'
                    and itemno='#check_material_balance.bmitemno#' 
                    <cfif form.location neq "">
                    and location ='#form.location#'
                    </cfif>
        
                    group by location,itemno
                    order by location,itemno
                ) as b on a.location=b.location and a.itemno=b.itemno
                
                left join
                (
                    select 
                    location,
                    category,
                    wos_group,
                    itemno,
                    sum(qty) as sum_out 
                    
                    from ictran 
                    
                    where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') 
                    and (toinv='' or toinv is null) 
                    and fperiod<>'99'
                    and itemno='#check_material_balance.bmitemno#' 
                    <cfif form.location neq "">
                    and location ='#form.location#'
                    </cfif>
                    group by location,itemno
                    order by location,itemno
                ) as c on a.location=c.location and a.itemno=c.itemno 
                
                where a.itemno=a.itemno
                and a.itemno='#check_material_balance.bmitemno#' 
               
                <cfif form.location neq "">
                and a.location ='#form.location#'
                </cfif>
            ) as c on a.itemno=c.itemno and b.location=c.location 
            
            where a.itemno=a.itemno 
            and b.location<>''
        
            <cfif form.location neq "">
            and b.location = '#form.location#'
            </cfif> 
            and a.itemno='#check_material_balance.bmitemno#' 
            order by a.itemno;
            </cfquery>
            
            <cfset check_material_balance.balance_on_hand=getlocationbalance.balance>
            <cfset check_material_balance.balance=val(getlocationbalance.balance)-val((form.qty*check_material_balance.bmqty))>
            <cfif check_material_balance.balance gt 0>
            <cfset check_material_balance.status='OK'>
            <cfelse>
            <cfset check_material_balance.status='XX'>
            </cfif>
            </cfif>
            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance.bmqty#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#form.qty*check_material_balance.bmqty#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance.balance_on_hand#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance.balance#</font></div></td>
            <td><div align="center"><font size="2" face="Times New Roman,Times,serif">#check_material_balance.status#</font></div></td>
          </tr>
	</cfloop>
	</cfoutput>
    <tr>
		<td colspan="8"><hr></td>
	</tr>
	<cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i") and form.getitem2 neq "">
		<cfquery name="getdesp" datasource="#dts#">
			select desp 
			from icitem 
			where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.getitem2#">
		</cfquery>
		<cfquery name="check_material_balance2" datasource="#dts#">
			select 
			a.itemno,a.bomno,a.bmitemno,a.bmqty,a.bmlocation,a.assm_group,
			b.desp,b.qtybf,b.unit,
			c.suminqty,
			d.sumoutqty,e.bmqty as bmqty1,
			(ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0)-(#val(form.qty)#*ifnull(e.bmqty,0))) as balance_on_hand,
			((ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0)-(#val(form.qty)#*ifnull(e.bmqty,0)))-(#val(form.qty2)#*ifnull(a.bmqty,0))) as balance,
			if(((ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0)-(#val(form.qty)#*ifnull(e.bmqty,0)))-(#val(form.qty2)#*ifnull(a.bmqty,0)))< 0,'XX','OK') as status
			 
			from billmat as a
			
			left join 
			(
				select itemno,desp,qtybf,unit 
				from icitem 
			) as b on a.bmitemno=b.itemno 
			
			left join 
			(
				select itemno,sum(qty) as suminqty 
				from ictran 
				where type in ('RC','CN','TRIN','OAI') and (void='' or void is null)
				group by itemno 
				order by itemno
			) as c on a.bmitemno=c.itemno 
			
			left join 
			(
				select itemno,sum(qty) as sumoutqty 
				from ictran 
				where type in ('INV','DN','CS','PR','TROU','ISS','OAR','DO') and (void='' or void is null) and (toinv='' or toinv is null) 
				group by itemno 
				order by itemno
			) as d on a.bmitemno=d.itemno 
			
			left join
			(
				select bmitemno,bmqty from billmat
				where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.getitem#">
			)as e on a.bmitemno=e.bmitemno
			
			where a.itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.getitem2#">
			group by a.bomno,a.bmitemno 
			order by status,a.bomno,a.bmitemno
		</cfquery>
		
		<tr><td colspan="100%"><div align="left"><font size="2" face="Times New Roman,Times,serif"><cfoutput><i>#form.getitem2# ~ #getdesp.desp#</i></cfoutput></font></div></td></tr>
		<cfoutput query="check_material_balance2">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance2.bomno#</font></div></td>
	            <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance2.bmitemno#</font></div></td>
	            <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance2.desp#</font></div></td>
	            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance2.bmqty#</font></div></td>
	            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#form.qty2*check_material_balance2.bmqty#</font></div></td>
	            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance2.balance_on_hand#</font></div></td>
	            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance2.balance#</font></div></td>
	            <td><div align="center"><font size="2" face="Times New Roman,Times,serif">#check_material_balance2.status#</font></div></td>
	          </tr>
		</cfoutput>
	    <tr>
			<td colspan="8"><hr></td>
		</tr>
	</cfif>
	
	<cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i") and form.getitem3 neq "">
		<cfquery name="getdesp" datasource="#dts#">
			select desp 
			from icitem 
			where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.getitem3#">
		</cfquery>
		<cfquery name="check_material_balance3" datasource="#dts#">
			select 
			a.itemno,a.bomno,a.bmitemno,a.bmqty,a.bmlocation,a.assm_group,
			b.desp,b.qtybf,b.unit,
			c.suminqty,
			d.sumoutqty,
			(ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0)-(#val(form.qty)#*ifnull(e.bmqty,0))-(#val(form.qty2)#*ifnull(f.bmqty,0))) as balance_on_hand,
			((ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0)-(#val(form.qty)#*ifnull(e.bmqty,0))-(#val(form.qty2)#*ifnull(f.bmqty,0)))-(#val(form.qty3)#*ifnull(a.bmqty,0))) as balance,
			if(((ifnull(b.qtybf,0)+ifnull(c.suminqty,0)-ifnull(d.sumoutqty,0)-(#val(form.qty)#*ifnull(e.bmqty,0))-(#val(form.qty2)#*ifnull(f.bmqty,0)))-(#val(form.qty3)#*ifnull(a.bmqty,0)))< 0,'XX','OK') as status
			 
			from billmat as a
			
			left join 
			(
				select itemno,desp,qtybf,unit 
				from icitem 
			) as b on a.bmitemno=b.itemno 
			
			left join 
			(
				select itemno,sum(qty) as suminqty 
				from ictran 
				where type in ('RC','CN','TRIN','OAI') and (void='' or void is null)
				group by itemno 
				order by itemno
			) as c on a.bmitemno=c.itemno 
			
			left join 
			(
				select itemno,sum(qty) as sumoutqty 
				from ictran 
				where type in ('INV','DN','CS','PR','TROU','ISS','OAR','DO') and (void='' or void is null) and (toinv='' or toinv is null) 
				group by itemno 
				order by itemno
			) as d on a.bmitemno=d.itemno 
			
			left join
			(
				select bmitemno,bmqty from billmat
				where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.getitem#">
			)as e on a.bmitemno=e.bmitemno
			
			left join
			(
				select bmitemno,bmqty from billmat
				where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.getitem2#">
			)as f on a.bmitemno=f.bmitemno
			
			where a.itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.getitem3#">
			group by a.bomno,a.bmitemno 
			order by status,a.bomno,a.bmitemno
		</cfquery>
		
		<tr><td colspan="100%"><div align="left"><font size="2" face="Times New Roman,Times,serif"><cfoutput><i>#form.getitem3# ~ #getdesp.desp#</i></cfoutput></font></div></td></tr>
		<cfoutput query="check_material_balance3">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance3.bomno#</font></div></td>
	            <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance3.bmitemno#</font></div></td>
	            <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#check_material_balance3.desp#</font></div></td>
	            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance3.bmqty#</font></div></td>
	            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#form.qty3*check_material_balance3.bmqty#</font></div></td>
	            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance3.balance_on_hand#</font></div></td>
	            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#check_material_balance3.balance#</font></div></td>
	            <td><div align="center"><font size="2" face="Times New Roman,Times,serif">#check_material_balance3.status#</font></div></td>
	          </tr>
		</cfoutput>
	    <tr>
			<td colspan="8"><hr></td>
		</tr>
	</cfif>
</table>

</body>
</html>