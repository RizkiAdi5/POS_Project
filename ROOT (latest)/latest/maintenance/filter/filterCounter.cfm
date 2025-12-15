<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='counter';
		var limit=10;
	</script>
</cfoutput>

<script type="text/javascript">

	function formatResult16(result){
		return result.counterid; 
	};
	
	function formatSelection16(result){
		return result.counterid;  
	};
	
	$(document).ready(function(e) {
		$('.counterFilter').select2({
			ajax:{
				type: 'POST',
				url:'/latest/filter/filterCounter.cfc',
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
						url:'/latest/filter/filterCounter.cfc',
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
			formatResult:formatResult16,
			formatSelection:formatSelection16,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
		});
	});
</script>
