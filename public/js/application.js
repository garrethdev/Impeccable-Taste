$(document).ready(function() {
  $('form').on('submit', function(e) {
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
    });
  });
});