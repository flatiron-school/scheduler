$(function () {
  $("#add-lab").addMore();
  $("#add-activity").addMore();
  $("#add-objective").addMore();
})

$.fn.addMore = function(e) {
  this.on("click", function(event){
    event.preventDefault();
    event.stopPropagation();
    var addType =  $(this).data('add-type');
    var newIdNum = 0;
    if ($('[data-' + addType + '-position]').length >= 1) {
      var newIdNum = $('[data-' + addType + '-position]').last().data()[addType + "Position"] + 1;
    }
    $("#add-" + addType + "s").append(HandlebarsTemplates['add-' + addType]({newIdNum: newIdNum, addType: addType}));
  })
};
