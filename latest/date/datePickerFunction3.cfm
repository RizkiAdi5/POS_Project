<script type="text/javascript">
    
    $(document).ready(function(e) {
    
        $('#releasedatefrom').datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            onClose: function( selectedDate ) {
                $( "#releasedateto" ).datepicker( "option", "minDate", selectedDate );
            }
        });
        $('#releasedateto').datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            onClose: function( selectedDate ) {
                $( "#releasedatefrom" ).datepicker( "option", "maxDate", selectedDate );
            }
        });	
    });
</script>