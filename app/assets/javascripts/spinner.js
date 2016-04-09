window.spinnerHTML = '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>'

$(document).ready(function() {
  $("#reserve-rooms").on("click", function(){
    $("#rooms").html(window.spinnerHTML)
  });

  $("#deploy").on("click", function(){
    $("#deployment-history").html(window.spinnerHTML)
  })
});