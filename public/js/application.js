$(document).ready(function() {
// Submit event for the form button.
// NOTE: I added a validation to make sure the user enters two different actors.
$('#pick_actors').on('submit', function(e) {
  $("#player").css("display", "block")
  e.preventDefault();
  var form_data = $(this).serialize();
  console.log(form_data)
  if ($('[name="firstactor"]').val() != $('[name="secondactor"]').val()){
    $.ajax({
      url: '/actors',
      type: 'post',
      data: form_data
    }).done(function(server_data) {
      console.log(server_data)
      $('#winner').html(server_data);
    }).fail(function() {
      console.log('failed')
      $('#winner').html('These people don\'t exist. Please enter some real actors.');
    });
  }
  else {
    $('#winner').html('You must enter two different actors.');
 }
});

// Click event for recent fight links.
  $(".fight_link").click(function(e){
    $("#player").css("display", "block")
    e.preventDefault();
    $("#player").css("display", "block")
    $.post("/actors",
    {
     firstactor: $(this).attr("firstactor"),
     secondactor: $(this).attr("secondactor")
   }).done(function(server_data) {
    console.log(server_data)
    $('#winner').html(server_data);
  }).fail(function() {
    console.log('failed')
    $('#winner').html('These people don\'t exist. Please enter some real actors.');
  });
});


});
