<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='icgroup';
		var limit=10;

		function formatResult10(result){
			return result.wosGroup+' - '+result.desp;  
		};
		
		function formatSelection10(result){
			$('##description').val(result.desp);
			return result.wosGroup+' - '+result.desp;   
		};
		
		$(document).ready(function(e) {
			$('.groupFilter').select2({
				ajax:{
					type: 'POST',
					url:'/latest/filter/filterGroup.cfc',
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
							url:'/latest/filter/filterGroup.cfc',
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

				formatResult:formatResult10,
				formatSelection:formatSelection10,
				minimumInputLength:0,
				width:'off',
				dropdownCssClass:'bigdrop',
				dropdownAutoWidth:true,
				placeholder:"Choose a Group",
				allowClear:true,
				});
				
		});
		
			
	</script>
</cfoutput>