<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfoutput>
<script type="text/javascript">
	function trim(str) {
		str = str.replace(/^\s+/, '');
		for (var i = str.length - 1; i >= 0; i--) {
			if (/\S/.test(str.charAt(i))) {
				str = str.substring(0, i + 1);
				break;
			}
		}
		return str;
	}
		
	function validate()
	{
  		<!--- INSERT COMPULSORY LOCATION CHECKING --->
		<cfif is_service neq 1>
		<cfinclude template = "transaction_setting_checking/compulsory_location_transaction4.cfm">
		</cfif>
		<!--- INSERT COMPULSORY LOCATION CHECKING --->
		
		<cfif checkcustom.customcompany eq "Y" and is_service neq 1>
			<!--- INSERT COMPULSORY BATCHCODE CHECKING --->
			<cfinclude template = "transaction_setting_checking/compulsory_batchcode_transaction4.cfm">
			<!--- INSERT COMPULSORY BATCHCODE CHECKING --->
		</cfif>
		<cfif lcase(hcomid) eq "aimpest_i" and tran eq 'SAM'>
		if(document.form1.req3.value=='')
		{
		alert ("Please Choose a Period.");
		return false;
		}
		</cfif>	
		if(document.form1.qty.value=='')
		{
			alert ("Empty Quantity!" + '\n\n' + "Please key in the quantity.");
			document.form1.qty.focus();
			return false;
  		}
  		if(isNaN(document.form1.qty.value))
		{
			alert ("Please key in quantity in numeric.");
			document.form1.qty.focus();
			return false;
 		 }
		 <cfif lcase(hcomid) eq "aimpest_i">
		 document.getElementById('foc').value = "N";
		 <cfelse>
		 if(parseFloat(document.getElementById('pri6').value) <= 0 && document.getElementById('foc').value != "Y")
		 {
		  var answer = confirm("The item price is zero, Do you wish to list this item into FOC?");
		  if(answer)
		  {
		  document.getElementById('foc').value = "Y";
		  }
		 }
		 else if(parseFloat(document.getElementById('pri6').value) > 0 && document.getElementById('foc').value == "Y")
		 {
		 document.getElementById('foc').value = "N";
		 }
		</cfif>
  		var xCompareQty=document.form1.CompareQty.value;

  		if(xCompareQty=='Y')
		{
    		var aQty=document.form1.qty.value;
    		
			var aMin=document.form1.minimum.value;
			<cfif tran eq 'SO'>
			var aQOH=(document.form1.balance.value*1)-(document.form1.reserveqty.value*1);
			<cfelse>
			var aQOH=document.form1.balance.value;
			</cfif>

    		if((parseFloat(aQOH) - parseFloat(aQty)) < parseFloat(aMin))
			{
				if (parseFloat(aMin)=='0')
				{
				<cfif tran eq 'SO'>

					alert("The quantity is more than available Qty!");		
					document.form1.qty.focus();
	   	 			return false;

				<cfelse>
				<!---
					var xConfirm=confirm("The quantity is more than Balance On Hand!" + '\n\n' + "Do you want to proceed?");	--->
					<cfif isdefined('mode')>
					<cfif mode eq "Add">
					alert("The quantity is more than Balance On Hand!");	
					return false;
					<cfelse>
					return true;
					</cfif>
					<cfelse>
					alert("The quantity is more than Balance On Hand!");	
					return false;	
					</cfif>
					
				</cfif>
				}
				else
				{
					var xConfirm=confirm("Stock below minimum level!" + '\n\n' + "Do you want to proceed?");
				}
				<cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "kjctrial_i">
				if (xConfirm==true)
				{
	   	 			return true;
     			}
     			else
				{
	   	 			document.form1.qty.focus();
	   	 			return false;
      			}
				<cfelse>
				<cfif (tran neq 'SO')>
      			if (xConfirm==true)
				{
	   	 			return true;
     			}
     			else
				{
	   	 			document.form1.qty.focus();
	   	 			return false;
      			}
				</cfif>
				</cfif>
    		}
  		}
  	return true;
	}
	
	function CopyItemRemark()
	{
		<cfquery name="getItemRemark" datasource="#dts#">
    		select 
			remark1,
			remark2,
			remark3,
			remark4,
			remark5,
			remark6,
			remark7,
			remark8,
			remark9,
			remark10,
	  		remark11,
			remark12,
			remark13,
			remark14,
			remark15,
			remark16,
			remark17,
			remark18,
			remark19,
			remark20,
	  		remark21,
			remark22,
			remark23,
			remark24,
			remark25,
			remark26,
			remark27,
			remark28,
			remark29,
			remark30
	  		from icitem 
			where itemno='#itemno#';
    	</cfquery>

    	<cfset NewLine=JSStringFormat(chr(13))>

		<cfif getItemRemark.remark1 neq "">
			<cfif left(getItemRemark.remark1,1) eq " ">
				document.form1.comment.value=document.form1.comment.value + ' ' + '#getItemRemark.remark1#';
			<cfelse>
       			document.form1.comment.value=document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark1#';
			</cfif>
    	</cfif>

		<cfif getItemRemark.remark2 neq "">
			<cfif left(getItemRemark.remark2,1) eq " ">
	  			document.form1.comment.value=document.form1.comment.value + '#getItemRemark.remark2#';
			<cfelse>
				document.form1.comment.value=document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark2#';
			</cfif>
		</cfif>

		<cfif getItemRemark.remark3 neq "">
			<cfif left(getItemRemark.remark3,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark3#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark3#';
			</cfif>
    	</cfif>

		<cfif getItemRemark.remark4 neq "">
			<cfif left(getItemRemark.remark4,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark4#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark4#';
			</cfif>
    	</cfif>

		<cfif getItemRemark.remark5 neq "">
			<cfif left(getItemRemark.remark5,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark5#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark5#';
	  		</cfif>
    	</cfif>

		<cfif getItemRemark.remark6 neq "">
			<cfif left(getItemRemark.remark6,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark6#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark6#';
			</cfif>
    	</cfif>

		<cfif getItemRemark.remark7 neq "">
			<cfif left(getItemRemark.remark7,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark7#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark7#';
			</cfif>
    	</cfif>

		<cfif getItemRemark.remark8 neq "">
			<cfif left(getItemRemark.remark8,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark8#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark8#';
			</cfif>
    	</cfif>

		<cfif getItemRemark.remark9 neq "">
			<cfif left(getItemRemark.remark9,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark9#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark9#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark10 neq "">
			<cfif left(getItemRemark.remark10,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark10#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark10#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark11 neq "">
			<cfif left(getItemRemark.remark11,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark11#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark11#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark12 neq "">
			<cfif left(getItemRemark.remark12,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark12#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark12#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark13 neq "">
			<cfif left(getItemRemark.remark13,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark13#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark13#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark14 neq "">
			<cfif left(getItemRemark.remark14,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark14#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark14#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark15 neq "">
			<cfif left(getItemRemark.remark15,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark15#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark15#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark16 neq "">
			<cfif left(getItemRemark.remark16,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark16#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark16#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark17 neq "">
			<cfif left(getItemRemark.remark17,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark17#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark17#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark18 neq "">
			<cfif left(getItemRemark.remark18,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark18#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark18#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark19 neq "">
			<cfif left(getItemRemark.remark19,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark19#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark19#';
    		</cfif>
    	</cfif>

		<cfif getItemRemark.remark20 neq "">
			<cfif left(getItemRemark.remark20,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark20#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark20#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark21 neq "">
			<cfif left(getItemRemark.remark21,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark21#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark21#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark22 neq "">
			<cfif left(getItemRemark.remark22,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark22#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark22#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark23 neq "">
			<cfif left(getItemRemark.remark23,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark23#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark23#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark24 neq "">
			<cfif left(getItemRemark.remark24,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark24#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark24#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark25 neq "">
			<cfif left(getItemRemark.remark25,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark25#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark25#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark26 neq "">
			<cfif left(getItemRemark.remark26,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark26#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark26#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark27 neq "">
			<cfif left(getItemRemark.remark27,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark27#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark27#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark28 neq "">
			<cfif left(getItemRemark.remark28,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark28#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark28#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark29 neq "">
			<cfif left(getItemRemark.remark29,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark29#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark29#';
    		</cfif>
		</cfif>

		<cfif getItemRemark.remark30 neq "">
			<cfif left(getItemRemark.remark30,1) eq " ">
				document.form1.comment.value = document.form1.comment.value + '#getItemRemark.remark30#';
			<cfelse>
      			document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark30#';
    		</cfif>
		</cfif>
  	
  	return true;
	}
</script>
</cfoutput>