<cfoutput>
	<script type="text/javascript">
		var dts="#dts#";
		var Hlinkams = '#Hlinkams#';
		var limit=10;
		
		function formatResult3(result){
			return result.supplierNo+' - '+result.name+' '+result.name2; 
		};
		
		function formatSelection3(result){
			$('##name').val(result.name);
			return result.supplierNo+' - '+result.name+' '+result.name2;  
		};
	
		$(document).ready(function(e) {
			$('.supplierFilter').select2({
				ajax:{
					type: 'POST',
					url:'/latest/filter/filterSupplier.cfc',
					dataType:'json',
					data:function(term,page){
						return{
							method:'listAccount',
							returnformat:'json',
							dts:dts,
							Hlinkams:Hlinkams,
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
							url:'/latest/filter/filterSupplier.cfc',
							dataType:'json',
							data:{
								method:'getSelectedAccount',
								returnformat:'json',
								dts:dts,
								Hlinkams:Hlinkams,
								value:value,
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
				placeholder:'Choose a Supplier',
				
				<cfif NOT IsDefined('supplier')>
					<cfset supplier = "">
				</cfif>
				
			}).select2('val','#supplier#');
		});
    </script>
</cfoutput>