<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='iccate';
		var limit=10;
	</script>
</cfoutput>

<script type="text/javascript">

	function formatResult7(result){
		return result.category; 
	};
	
	function formatSelection7(result){
		return result.category;  
	};
	
	$(document).ready(function(e) {
		$('.categoryFilter').select2({
			ajax:{
				type: 'POST',
				url:'/latest/maintenance/filter/filterCategory.cfc',
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
						url:'/latest/maintenance/filter/filterCategory.cfc',
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
			formatResult:formatResult7,
			formatSelection:formatSelection7,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
			
			<cfif NOT IsDefined('category')>
				<cfset category = "">
			</cfif>
					
		}).select2('val','#category#');
	});
</script>
