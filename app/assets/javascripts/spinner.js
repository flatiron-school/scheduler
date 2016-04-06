// NOTE: I made the spinner HTML part of window so you can use it whenever
//       you need to insert that. Maybe a different kind of JS variable
//       or even a template HTML you include the application layout and read
//       from there.
window.spinnerHTML = '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>'

$(document).ready(function() {
  $("#reserve-rooms").on("click", function(){
    $("#rooms").html(window.spinnerHTML)
  });

  $("#deploy").on("click", function(){
    $("#deployment-history").html(window.spinnerHTML)
  })
});
