$(document).ready(function() {
   $('#messages > *').detach().each(function() {
       showMessage($(this));
   });
});

function showMessage(htmlstr) {
   var msg = $(htmlstr);
   msg.click(function() {
       msg.fadeOut();
   });
   window.setInterval(function() {
       msg.fadeOut();
   }, 10000);
   $('#messages').append(msg);
}