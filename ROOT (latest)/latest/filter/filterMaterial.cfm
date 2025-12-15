<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='iccolorid';
		var limit=10;
	</script>
</cfoutput>

<script type="text/javascript">

	function formatResult21(result){
		return result.colorid+' - '+result.desp;  
	};
	
	function formatSelection21(result){
		$('#description').val(result.desp);
		return result.colorid+' - '+result.desp;   
	};
	
	$(document).ready(function(e) {
		$('.materialFilter').select2({
			ajax:{
				type: 'POST',
				url:'/latest/filter/filterMaterial.cfc',
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
						url:'/latest/filter/filterMaterial.cfc',
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
			formatResult:formatResult21,
			formatSelection:formatSelection21,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
		});
	});
</script>
