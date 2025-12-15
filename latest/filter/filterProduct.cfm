<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var table='icitem';
		var limit=10;
    
        function formatResult5(result){
            return result.itemNo+' - '+result.desp;  
        };
        
        function formatSelection5(result){
			$('##description').val(result.desp);
            return result.itemNo+' - '+result.desp;  
        };
        
        $(document).ready(function(e) {
            $('.productFilter').select2({
                ajax:{
                    type: 'POST',
                    url:'/latest/filter/filterProduct.cfc',
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
                            url:'/latest/filter/filterProduct.cfc',
                            dataType:'json',
                            data:{
                                method:'getSelectedAccount',
                                returnformat:'json',
                                dts:dts,
                                table:table,
								Hlinkams:Hlinkams,
                                value:value,
                            },
                        }).done(function(data){callback(data);});
                    };
                },
                formatResult:formatResult5,
                formatSelection:formatSelection5,
                minimumInputLength:0,
                width:'off',
                dropdownCssClass:'bigdrop',
                dropdownAutoWidth:true,
				placeholder:"Choose a Product",
				
                
                <cfif NOT IsDefined('item')>
                    <cfset item = "">
                </cfif>		
            }).select2('val','#item#');
        });
    </script>
</cfoutput>
