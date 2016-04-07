$(function () {
  $("#add-lab").addMore();
  $("#add-activity").addMore();
  $("#add-objective").addMore();
  // addLabListener();
  // addActivityListener();
  // addObjectiveListener();
})

$.fn.addMore = function(e) {
  this.on("click", function(event){
    event.preventDefault();
    event.stopPropagation();
    var addType =  $(this).data('add-type');
    var newIdNum = 0;
    if ($('[data-' + addType + '-position]').length > 1) {
      var newIdNum = $('[data-' + addType + '-position]').last().data()[addType + "Position"];
    }
    $("#add-" + addType + "s").append(HandlebarsTemplates['add-' + addType]({newIdNum: newIdNum}));
  })
};
 
// function addLabListener(){
//   $("#add-lab").on("click", function(event){
//     event.preventDefault();
//     event.stopPropagation();
//     var newIdNum = 0
//     if ($('[data-lab-position]').length > 1) {
//       var newIdNum = $('[data-lab-position]').last().data().labPosition
//     }

//     $("#add-labs").append(HandlebarsTemplates['add-lab']({newIdNum: newIdNum}));
//   });
// }

// function addActivityListener(){
//   $("#add-activity").on("click", function(event){
//     event.preventDefault();
//     event.stopPropagation();
//     var new_id_num = 0;
//     var inputs = $("input[name^='schedule[activities_attributes]'");
//     if (inputs.length > 0) {
//       var last = inputs[inputs.length - 1];
//       var last_id_num = last.id.split("_")[3];
//       var new_id_num = parseInt(last_id_num) + 1;
//     }

//     $("#add-activities").append('<label for="schedule_activities_attributes_"' + new_id_num + '_start_time">Start Time</label><input class="form-control" type="time" name="schedule[activities_attributes][' + new_id_num + '][start_time]" id="schedule_activities_attributes_' + new_id_num + '_start_time"><label for="schedule_activities_attributes_"' + new_id_num + '_end_time">End Time</label><input class="form-control" type="time" name="schedule[activities_attributes][' + new_id_num + '][end_time]" id="schedule_activities_attributes_' + new_id_num + '_end_time"><br><label for="schedule_activities_attributes_"' + new_id_num + '_description">Description</label><input class="form-control" type="text" name="schedule[activities_attributes][' + new_id_num + '][description]" id="schedule_activities_attributes_' + new_id_num + '_description"><br><label for="schedule_activities_attributes_"' + new_id_num + '_reserve_room">Reserve Room</label><input type="hidden" name="schedule[activities_attributes][' + new_id_num + '][reserve_room]" value="0"><input type="checkbox" value="1" name="schedule[activities_attributes][' + new_id_num + '][reserve_room]" id="schedule_activities_attributes_' + new_id_num + '][reserve_room]"><br><br>')
//   });
// }

// function addObjectiveListener(){
//   $("#add-objective").on("click", function(event){
//     event.preventDefault();
//     event.stopPropagation();
//     var new_id_num = 0;
//     var inputs = $("input[name^='schedule[objectives_attributes]'");
//     if (inputs.length > 0) {
//       var last = inputs[inputs.length - 1];
//       var last_id_num = last.id.split("_")[3];
//       var new_id_num = parseInt(last_id_num) + 1;
//     }

//     $("#add-objectives").append('<br><label for="schedule_objectives_attributes_"' + new_id_num + '_content">Content</label><input class="form-control" type="text" name="schedule[objectives_attributes][' + new_id_num + '][content]" id="schedule_objectives_attributes_' + new_id_num + '_content"><br>')
//   })
// }








