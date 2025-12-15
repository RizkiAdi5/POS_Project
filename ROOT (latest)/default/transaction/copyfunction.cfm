<html>
<head>
<title>Copy Job Order</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>


<cfquery datasource="#dts#" name="gettranname">
	Select lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM

	from GSetup
</cfquery>

<cfquery name="getGSetup" datasource="#dts#">
		SELECT invno,invno_2,invno_3,invno_4,invno_5,invno_6,
    	invoneset,rc_oneset,pr_oneset,do_oneset,cs_oneset,cn_oneset,dn_oneset,iss_oneset,
		po_oneset,so_oneset,quo_oneset,assm_oneset,tr_oneset,oai_oneset,oar_oneset,sam_oneset
    	FROM gsetup
</cfquery>

<script type="text/javascript">

<cfoutput query="getGSetup">
	var oneInv=#getGSetup.invoneset#;
	var oneRc=#getGSetup.rc_oneset#;
	var onePr=#getGSetup.pr_oneset#;
	var oneDo=#getGSetup.do_oneset#;
	var oneCs=#getGSetup.cs_oneset#;
	var oneCn=#getGSetup.cn_oneset#;
	var oneDn=#getGSetup.dn_oneset#;
	var oneIss=#getGSetup.iss_oneset#;
	var onePo=#getGSetup.po_oneset#;
	var oneSo=#getGSetup.so_oneset#;
	var oneQuo=#getGSetup.quo_oneset#;
	var oneAssm=#getGSetup.assm_oneset#;
	var oneTr=#getGSetup.tr_oneset#;
	var oneOai=#getGSetup.oai_oneset#;
	var oneOar=#getGSetup.oar_oneset#;
	var oneSam=#getGSetup.sam_oneset#;
</cfoutput>

$(document).ready(function() {
	refresh_to();
});

function getRefnoFtRefresh(count, type){
	//ajaxFunction(document.getElementById("search2"),'copyAjax2.cfm?count='+count+'&type='+type);

	$.ajax({
			type:"POST",
			url:"copyAjax2.cfm",
			data: {"count":count,"type":type},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#search2').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
				alert(errorThrown);
			},
			complete: function(){
				document.getElementById("counter").value=count;
			}
	});
}


function refresh_to(){
	var dts = document.getElementById("dts").value;
	var ft = document.getElementById("ft").value;
	if (ft=="INV" || ft ==""){
	var validset= "invoneset";
	}else{
	var validset= ft+ "_oneset";
	}
	$.ajax({
			type:"POST",
			url:"copyAjax.cfm",
			data: {"ft":ft,"dts":dts,"validset":validset},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#search').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
				alert(errorThrown);
			},
			complete: function(){
				getRefnoFtRefresh(document.getElementById("ft_invtype").value, ft);
			}
  		});
}

function showCopyJobOrderResult(msg){
	if(msg ==''){
		var nextjoborderno=document.getElementById('nextjoborderno').value;
		var windowOpener =window.dialogArguments;
		windowOpener.document.getElementById('joborderno').value=nextjoborderno;
		window.close();
	}
	else{
		alert(msg);
	}
}


</script>

</head>

<body width="100%">
<br>
<cfset ft= url.type >
<cfset dts= dts >
<cfoutput>
<cfform name="form" method="post" action="copyfunctionprocess.cfm" target="_self">
	<input  type="hidden" name="ff_type" id="ff_type" value="#url.type#">
    <input  type="hidden" id="ff_refnofrom" name="ff_refnofrom" value="#url.refno#">
	<input  type="hidden" id="dts" name="dts" value="#dts#">
    <input type="hidden" id="counter" name="counter" value="1">
    <table class="data" align="center" width="200px">
    	<tr><td height="10" colspan="100%"></td></tr>
        <tr>
        	<th width="40%">Bill Type</th>
           	<td width="60%">
            <select name="ft" id="ft" value="ft" onChange="refresh_to()">
            <option value="">Choose a bill type</option>
            <cfif getpin2.H2401 eq 'T'><option value="INV" <cfif url.type eq 'INV'>selected</cfif>>#gettranname.lINV#</option></cfif>
            <cfif getpin2.H2102 eq 'T'><option value="RC" <cfif url.type eq 'RC'>selected</cfif>>#gettranname.lRC#</option></cfif>
            <cfif getpin2.H2201 eq 'T'><option value="PR" <cfif url.type eq 'PR'>selected</cfif>>#gettranname.lPR#</option></cfif>
            <cfif getpin2.H2301 eq 'T'><option value="DO" <cfif url.type eq 'DO'>selected</cfif>>#gettranname.lDO#</option></cfif>
            <cfif getpin2.H2501 eq 'T'><option value="CS" <cfif url.type eq 'CS'>selected</cfif>>#gettranname.lCS#</option></cfif>
            <cfif getpin2.H2601 eq 'T'><option value="CN" <cfif url.type eq 'CN'>selected</cfif>>#gettranname.lCN#</option></cfif>
            <cfif getpin2.H2701 eq 'T'><option value="DN" <cfif url.type eq 'DN'>selected</cfif>>#gettranname.lDN#</option></cfif>
            <cfif getpin2.H2821 eq 'T'><option value="ISS" <cfif url.type eq 'ISS'>selected</cfif>>Issue</option></cfif>
            <cfif getpin2.H2861 eq 'T'><option value="PO" <cfif url.type eq 'PO'>selected</cfif>>#gettranname.lPO#</option></cfif>
            <cfif getpin2.H2881 eq 'T'><option value="SO" <cfif url.type eq 'SO'>selected</cfif>>#gettranname.lSO#</option></cfif>
            <cfif getpin2.H2871 eq 'T'><option value="QUO" <cfif url.type eq 'QUO'>selected</cfif>>#gettranname.lQUO#</option></cfif>
            <cfif getpin2.H28A1 eq 'T'><option value="TR" <cfif url.type eq 'TR'>selected</cfif>>Transfer/Consignment</option></cfif>
            <cfif getpin2.H2851 eq 'T'><option value="SAM" <cfif url.type eq 'SAM'>selected</cfif>>#gettranname.lSAM#</option></cfif>
            <cfif getpin2.H289E eq 'T'><option value="OAI" <cfif url.type eq 'OAI'>selected</cfif>>Adjustment Increase</option></cfif>
            <cfif getpin2.H289F eq 'T'><option value="OAR" <cfif url.type eq 'OAR'>selected</cfif>>Adjustment Reduce</option></cfif>
            </select>
            </td>
        </tr>

    	<tr>
        	<th width="40%">Ref No.</th>
			<td width="60%">
			<div id="search">
			<select name="ft_invtype" id="ft_invtype">
				<option value=""></option>
			</select>
			</div>
			<div id="search2">
            <input type="text" name="ft_refnofrom" id="ft_refnofrom" value=""><input id="ft_actualrefno" type="hidden" name="ft_actualrefno">
			</div>
			</td>
        </tr>
        <tr>
        <td colspan="2"><input type="checkbox" name="crossover" id="crossover" value="1"> Transfer Cross Over Copy</td>
        </tr>
        <tr>
        	<td colspan="100%"><div align="right">
        		<input type="submit" value="Copy">
                &nbsp;
                <input type="button" value="Cancel" onClick="window.close();">
            </div></td>
        </tr>
    </table>
</cfform>
</cfoutput>
</body>
</html>