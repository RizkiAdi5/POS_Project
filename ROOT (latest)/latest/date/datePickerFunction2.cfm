<script type="text/javascript">
    
    $(document).ready(function(e) {
    
        $('#deldatefrom').datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            onClose: function( selectedDate ) {
                $( "#deldateto" ).datepicker( "option", "minDate", selectedDate );
            }
        });
        $('#deldateto').datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            onClose: function( selectedDate ) {
                $( "#deldatefrom" ).datepicker( "option", "maxDate", selectedDate );
            }
        });	
    });
</script>