<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>ready demo</title>
  <style>
  p {
    color: red;
  }
  a.test {
    font-weight: bold;
}
  </style>

  <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script>
 $( document ).ready(function() {
<!---	 $( "a" ).addClass( "test" );
	 $( "a" ).removeClass( "test" );

    $( "a" ).click(function( event ) {

        alert( "Thanks for visiting!" );
		 event.preventDefault();

    $( this ).hide( "slow" );

    });--->
 $.get( "testing2.cfm", myCallBack( ) );


});

 <!--- $( document ).ready(function() {
    $( "p" ).text( "The DOM is now loaded and can be manipulated." );
  });

 window.onload = function() {

    alert( "welcome" );

}; --->
  </script>

</head>
<body>

<p>Not loaded yet.</p>
 <a href="#">Apple</a>

</body>
</html>
