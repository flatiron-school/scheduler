$(function () {
  $("#add-lab").on("click", function(event){
    event.preventDefault();
    event.stopPropagation();
    var inputs = $("input[name^='schedule[labs_attributes]'");
    var last = inputs[inputs.length - 1];
    var last_id_num = last.id.split("_")[3]
    var new_id_num = parseInt(last_id_num) + 1
    $("#add-labs").append('<br><label>Name</label><input class="form-control" type="text" name="schedule[labs_attributes][' + new_id_num + '][name]" id="schedule_labs_attributes_' + new_id_num + '_name"><br>')
    debugger;
  })
})