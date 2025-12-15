<cfoutput>
	<script type="text/javascript">
		var dts="#dts#";
		var table='#target_apvend#';
		var limit=10;
		
			function formatResult3(result){
				return result.supplierNo+' - '+result.name+' '+result.name2; 
			};
			
			function formatSelection3(result){
				return result.supplierNo+' - '+result.name+' '+result.name2;  
			};
			
			function setPreSelectedValue(){
				$('##supplier').select2('val','#supplier#');
				
			};
	
			
			$(document).ready(function(e) {
				$('.supplierFilter').select2({
					ajax:{
						type: 'POST',
						url:'/latest/maintenance/filter/filterSupplier.cfc',
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
						var custno=$(element).val();
						if(custno!=''){
							$.ajax({
								type:'POST',
								url:'/latest/maintenance/filterSupplier.cfc',
								dataType:'json',
								data:{
									method:'getSelectedTarget',
									returnformat:'json',
									dts:dts,
									table:table,
									custno:custno,
								},
							}).done(function(data){callback(data);});
						};
					},
					formatResult:formatResult3,
					formatSelection:formatSelection3,
					minimumInputLength:0,
					width:'off',
					dropdownCssClass:'bigdrop',
					dropdownAutoWidth:true,
					formatResult: function (data) {
        				return data.text;
    				}	
					
				})
			});
    </script>
</cfoutput>