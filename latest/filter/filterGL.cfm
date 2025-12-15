<cfoutput>
	<script type="text/javascript">
		var dts="#replace(LCASE(dts),'_i','_a','all')#";
		var table='gldata';
		var limit=10;
    
		<cfloop from="1" to="5" index="aa">
		
			function formatResult(result){
				return result.accno+' - '+result.desp;
			};
			
			function formatSelection(result){
				return result.accno+' - '+result.desp;  
			};
		
			$(document).ready(function(e) {
				$('.accno#aa#').select2({
					ajax:{
						type: 'POST',
						url:'/latest/maintenance/filterGL.cfc',
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
								accno:'#aa#',
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
								url:'/latest/maintenance/filterGL.cfc',
								dataType:'json',
								data:{
									method:'getSelectedAccount',
									returnformat:'json',
									dts:dts,
									table:table,
									value:value,
									accno:'#aa#',
								},
							}).done(function(data){callback(data);});
						};
					},
					formatResult:formatResult,
					formatSelection:formatSelection,
					minimumInputLength:0,
					width:'off',
					dropdownCssClass:'bigdrop',
					dropdownAutoWidth:true,
					placeholder:"Choose an Account",
					allowClear:true,					
				});
			});
        </cfloop>
    </script>
</cfoutput>