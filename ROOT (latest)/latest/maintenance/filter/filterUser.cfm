<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='users';
		var limit=10;
	</script>
</cfoutput>

<script type="text/javascript">

	function formatResult14(result){
		return result.userID+' - '+result.userName; 
	};
	
	function formatSelection14(result){
		return result.userID+' - '+result.userName;   
	};
	
	$(document).ready(function(e) {
		$('.userFilter').select2({
			ajax:{
				type: 'POST',
				url:'/latest/filter/filterUser.cfc',
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
						url:'/latest/filter/filterUser.cfc',
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
			formatResult:formatResult14,
			formatSelection:formatSelection14,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
		});
	});
</script>
