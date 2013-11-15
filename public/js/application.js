$(document).ready(function() {
  $('#pick_actors').on('submit', function(e) {
    $("#player").css("display", "block")
    e.preventDefault();
    var form_data = $(this).serialize();
    console.log(form_data)
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
    

  });
});