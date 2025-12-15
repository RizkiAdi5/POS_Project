<cfoutput>
	<script type="text/javascript">
		var dts="#dts#";
		var table='#target_arcust#';
		var limit=10;
		
			function formatResult2(result){
				return result.customerNo+' - '+result.name+' '+result.name2; 
			};
			
			function formatSelection2(result){
				return result.customerNo+' - '+result.name+' '+result.name2;  
			};
		
			$(document).ready(function(e) {
				$('.customerFilter').select2({
					ajax:{
						type: 'POST',
						url:'/latest/filter/filterCustomer.cfc',
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
								url:'/latest/filter/filterCustomer.cfc',
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
					formatResult:formatResult2,
					formatSelection:formatSelection2,
					minimumInputLength:0,
					width:'off',
					dropdownCssClass:'bigdrop',
					dropdownAutoWidth:true,
				});
			});
    </script>
</cfoutput>