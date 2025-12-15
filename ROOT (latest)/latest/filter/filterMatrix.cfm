<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='icmitem';
		var limit=10;
	</script>
</cfoutput>

<script type="text/javascript">

	function formatResult27(result){
		return result.mitemno+' - '+result.desp; 
	};
	
	function formatSelection27(result){
		return result.mitemno+' - '+result.desp; 
	};
	
	$(document).ready(function(e) {
		$('.matrixFilter').select2({
			ajax:{
				type: 'POST',
				url:'/latest/filter/filterMatrix.cfc',
				dataType:'json',
				data:function(term,page){
					return{
						method:'listAccount',
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
						url:'/latest/filter/filterMatrix.cfc',
						dataType:'json',
						data:{
							method:'getSelectedAccount',
							returnformat:'json',
							dts:dts,
							table:table,
							value:value,
						},
					}).done(function(data){callback(data);});
				};
			},
			formatResult:formatResult27,
			formatSelection:formatSelection27,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
		});
	});
</script>
