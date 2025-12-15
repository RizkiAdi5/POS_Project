<script type="text/javascript">
    
    $(document).ready(function(e) {
    
        $('#dateFrom').datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            onClose: function( selectedDate ) {
                $( "#dateTo" ).datepicker( "option", "minDate", selectedDate );
            }
        });
        $('#dateTo').datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            onClose: function( selectedDate ) {
                $( "#dateFrom" ).datepicker( "option", "maxDate", selectedDate );
            }
        });	
        
        document.getElementById('tf_fperiodtoDesp').value = document.getElementById('periodTo').options[document.getElementById('periodTo').selectedIndex].title;
        document.getElementById('tf_fperiodfromDesp').value = document.getElementById('periodFrom').options[document.getElementById('periodFrom').selectedIndex].title;
    });
</script>