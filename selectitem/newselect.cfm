
<link rel="stylesheet" href="/stylesheet/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="/stylesheet/select2/select2.css" />
<link rel="stylesheet" href="/stylesheet/form.css" />
<script type="text/javascript" src="/scripts/jquery/jquery-1.10.2.min.js"></script>
<!--[if (gte IE 6)&(lte IE 8)]>
	<script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
  	<noscript><link rel="stylesheet" href="" /></noscript>
<![endif]-->
<script type="text/javascript" src="/scripts/jqueryui/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javascript" src="/scripts/select2/select2.min.js"></script>
<cfoutput>
	<script type="text/javascript">
	var dts='#dts#';
	var table='icitem';
	var limit=200;
</script>
</cfoutput>

<script type="text/javascript">
function formatResult(result){
	return result.itemno+' - '+result.desp; 
};
function formatSelection(result){
	return result.itemno+' - '+result.desp; 
};


$(document).ready(function(e) {
	
	$('#expressservicelist').on("change",function(e){bluradditem(e.val);});
	
	$('.itemno').select2({
		ajax:{
			type: 'POST',
			url:'/selectitem/itemlist.cfc',
			dataType:'json',
			data:function(term,page){
				return{
					method:'listitem',
					returnformat:'json',
					dts:dts,
					table:table,
					term:term,
					limit:limit,
					page:page-1,
				};
			},
			results:function(data,page){
				var more=((page-1)*limit)<data.total;
				return{
					results:data.result,
					more:more
				};
			}
		},
		initSelection: function(element, callback) {
			var value=$(element).val();
			if(value!=''){
				$.ajax({
					type:'POST',
					url:'/selectitem/itemlist.cfc',
					dataType:'json',
					data:{
						method:'getSelecteditem',
						returnformat:'json',
						dts:dts,
						table:table,
						value:value,
					},
				}).done(function(data){callback(data);});
			};
		},
		formatResult:formatResult,
		formatSelection:formatSelection,
		minimumInputLength:0,
		width:'300',
		dropdownCssClass:'bigdrop',
		dropdownAutoWidth:true,
	}).select2('val','test');
	
	<!--- $("#focus_btn").click(function () { $("#expressservicelist").select2("open"); }); --->
	$('#expressservicelist').select2('open');
	});
	
</script>
			<input type="hidden" id="expressservicelist" class="itemno" name="expressservicelist" onKeyUp="nextIndex(event,'expressservicelist','expqty');" onBlur="this.value = this.value.split('___', 1);bluradditem(this.value);"  data-placeholder="Choose an Item" />