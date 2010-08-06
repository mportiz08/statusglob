// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  init();
});

function init() {
  // fade in main content
  $('#title, #content ul, #splash').hide();
  $('#title, #content ul, #splash').fadeIn("slow");
  
  // fade out flash messages
  setTimeout(fadeNotification, 3000);
}

function fadeNotification() {
  $('#flash').fadeOut();
}
