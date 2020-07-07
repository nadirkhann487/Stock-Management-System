window.is_picked = function(){
  if (s
  {
  	document.getElementById("demo").innerHTML = 'Picked';

  } 	
  else
  {
  	  	document.getElementById("demo").innerHTML = 'Not Picked';
  }
}

$(document).ready(function() {
  $(".btn btn-primary").on(
    'click',
    function() {
    	
    	
      is_picked();
    }
  );
});

