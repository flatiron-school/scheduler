$(function () {
  $("#add-lab").on("click", function(event){
    event.preventDefault();
    event.stopPropagation();
    var new_id_num = 0;
    var inputs = $("input[name^='schedule[labs_attributes]'");
    if (inputs.length > 0) {
      var last = inputs[inputs.length - 1];
      var last_id_num = last.id.split("_")[3]
      var new_id_num = parseInt(last_id_num) + 1
    }
    
    $("#add-labs").append('<br><label>Name</label><input class="form-control" type="text" name="schedule[labs_attributes][' + new_id_num + '][name]" id="schedule_labs_attributes_' + new_id_num + '_name"><br>')
  })

   $("#add-activity").on("click", function(event){
    event.preventDefault();
    event.stopPropagation();
    var new_id_num = 0;
    var inputs = $("input[name^='schedule[activities_attributes]'");
    if (inputs.length > 0) {
      var last = inputs[inputs.length - 1];
      var last_id_num = last.id.split("_")[3]
      var new_id_num = parseInt(last_id_num) + 1
    }

    $("#add-activities").append('<label for="schedule_activities_attributes_"' + new_id_num + '_start_time">Start Time</label><input class="form-control" type="time" name="schedule[activities_attributes][' + new_id_num + '][start_time]" id="schedule_activities_attributes_' + new_id_num + '_start_time"><label for="schedule_activities_attributes_"' + new_id_num + '_end_time">End Time</label><input class="form-control" type="time" name="schedule[activities_attributes][' + new_id_num + '][end_time]" id="schedule_activities_attributes_' + new_id_num + '_end_time"><br><label for="schedule_activities_attributes_"' + new_id_num + '_description">Description</label><input class="form-control" type="text" name="schedule[activities_attributes][' + new_id_num + '][description]" id="schedule_activities_attributes_' + new_id_num + '_description"><br><label for="schedule_activities_attributes_"' + new_id_num + '_reserve_room">Reserve Room</label><input type="hidden" name="schedule[activities_attributes][' + new_id_num + '][reserve_room]" value="0"><input type="checkbox" value="1" name="schedule[activities_attributes][' + new_id_num + '][reserve_room]" id="schedule_activities_attributes_' + new_id_num + '][reserve_room]"><br><br>')
  })
})








