<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='brand';
		var limit=10;
	</script>
</cfoutput>

<script type="text/javascript">

	function formatResult6(result){
		return result.brand+' - '+result.desp;  
	};
	
	function formatSelection6(result){
		return result.brand+' - '+result.desp;   
	};
	
	$(document).ready(function(e) {
		$('.brandFilter').select2({
			ajax:{
				type: 'POST',
				url:'/latest/maintenance/filter/filterBrand.cfc',
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
						url:'/latest/maintenance/filter/filterBrand.cfc',
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
			formatResult:formatResult6,
			formatSelection:formatSelection6,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
			
			<cfif NOT IsDefined('brand')>
				<cfset brand = "">
			</cfif>
					
		}).select2('val','#brand#');
	});
</script>
