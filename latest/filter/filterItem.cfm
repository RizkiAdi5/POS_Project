<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='icitem';
		var limit=10;
    
        function formatResult23(result){
            return result.itemNo+' - '+result.desp;  
        };
        
        function formatSelection23(result){
			$('##description').val(result.desp);
            return result.itemNo+' - '+result.desp;  
        };
        
        $(document).ready(function(e) {
            $('.itemFilter').select2({
                ajax:{
                    type: 'POST',
                    url:'/latest/filter/filterItem.cfc',
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
                            url:'/latest/filter/filterItem.cfc',
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
                formatResult:formatResult23,
                formatSelection:formatSelection23,
                minimumInputLength:0,
                width:'off',
                dropdownCssClass:'bigdrop',
                dropdownAutoWidth:true,
				placeholder:"Choose an Item",
				
                
                <cfif NOT IsDefined('item')>
                    <cfset item = "">
                </cfif>		
            }).select2('val','#item#');
        });
    </script>
</cfoutput>
