<cfoutput>
	<script type="text/javascript">
		var dts="#dts#";
		var Hlinkams = '#Hlinkams#';
		var limit=10;
		
			function formatResult4(result){
				return result.currencyCode+' - '+result.currency; 
			};
			
			function formatSelection4(result){
				$('##name').val(result.name);
				return result.currencyCode+' - '+result.currency;  
			};
		
			$(document).ready(function(e) {
				$('.currencyFilter').select2({
					ajax:{
						type: 'POST',
						url:'/latest/filter/filterCurrency.cfc',
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
								url:'/latest/filter/filterCurrency.cfc',
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
					formatResult:formatResult4,
					formatSelection:formatSelection4,
					minimumInputLength:0,
					width:'off',
					dropdownCssClass:'bigdrop',
					dropdownAutoWidth:true,
					placeholder:'Choose a Currency',
					
					<cfif NOT IsDefined('currency')>
						<cfset currency = "">
					</cfif>
					
				}).select2('val','#currency#');
			});
    </script>
</cfoutput>