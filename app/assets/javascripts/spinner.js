$( document ).ready(function() {
  $("#reserve-rooms").on("click", function(){
    $("#rooms").html('<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>')
  });

  $("#deploy").on("click", function(){
    debugger;
    $("#deployment-history").html('<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>')
  })
});