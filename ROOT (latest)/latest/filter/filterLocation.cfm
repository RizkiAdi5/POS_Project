<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='iclocation';
		var limit=10;
		var huserloc='#huserloc#';

		function formatResult25(result){
			return result.location+' - '+result.desp;  
		};
		
		function formatSelection25(result){
			$('##description').val(result.desp);
			return result.location+' - '+result.desp;   
		};
		$(document).ready(function(e) {
			$('.locationFilter').select2({
				ajax:{
					type: 'POST',
					url:'/latest/filter/filterLocation.cfc',
					dataType:'json',
					data:function(term,page){
						return{
							method:'listAccount',
							returnformat:'json',
							dts:dts,
							huserloc:huserloc,
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
							url:'/latest/filter/filterLocation.cfc',
							dataType:'json',
							data:{
								method:'getSelectedAccount',
								returnformat:'json',
								dts:dts,
								huserloc:huserloc,
								table:table,
								value:value,
							},
						}).done(function(data){callback(data);
						});						
					};
				},
				formatResult:formatResult25,
				formatSelection:formatSelection25,
				minimumInputLength:0,
				width:'off',
				dropdownCssClass:'bigdrop',
				dropdownAutoWidth:true,
				placeholder:"Choose a Location",
				allowClear:true,
				});	
		});
		
			
		
	</script>
</cfoutput>
