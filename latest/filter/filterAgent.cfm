<cfoutput>
	<script type="text/javascript">
		var Hlinkams='#Hlinkams#';
		var dts='#dts#';
		var table='#target_icagent#';
		var limit=10;
	</script>
</cfoutput>

<script type="text/javascript">

	function formatResult26(result){
		return result.agent+' - '+result.desp;  
	};
	
	function formatSelection26(result){
		$('#description').val(result.desp);
		return result.agent+' - '+result.desp;   
	};
	
	$(document).ready(function(e) {
		$('.agentFilter').select2({
			ajax:{
				type: 'POST',
				url:'/latest/filter/filterAgent.cfc',
				dataType:'json',
				data:function(term,page){
					return{
						method:'listAccount',
						returnformat:'json',
						Hlinkams:Hlinkams,
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
						url:'/latest/filter/filterAgent.cfc',
						dataType:'json',
						data:{
							method:'getSelectedAccount',
							returnformat:'json',
							Hlinkams:Hlinkams,
							dts:dts,
							table:table,
							value:value,
						},
					}).done(function(data){callback(data);});
				};
			},
			formatResult:formatResult26,
			formatSelection:formatSelection26,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
			placeholder:"Choose an Agent",
			allowClear:true,			
					
		});
	});
</script>
