<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='#target_project#';
		var Hlinkams = '#Hlinkams#';
		var limit=10;


	function formatResult20(result){
		return result.source+' - '+result.project;  
	};
	
	function formatSelection20(result){
		$('##project').val(result.project);
		return result.source+' - '+result.project;   
	};
	
	$(document).ready(function(e) {
		$('.jobFilter').select2({
			ajax:{
				type: 'POST',
				url:'/latest/filter/filterJob.cfc',
				dataType:'json',
				data:function(term,page){
					return{
						method:'listAccount',
						returnformat:'json',
						dts:dts,
						table:table,
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
						url:'/latest/filter/filterJob.cfc',
						dataType:'json',
						data:{
							method:'getSelectedAccount',
							returnformat:'json',
							dts:dts,
							table:table,
							value:value,
							Hlinkams:Hlinkams,
						},
					}).done(function(data){callback(data);});
				};
			},
			formatResult:formatResult20,
			formatSelection:formatSelection20,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
			placeholder:"Choose a Job",
			allowClear:true,
			});	
		});
	</script>
</cfoutput>
