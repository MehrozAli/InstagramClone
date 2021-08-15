//= require jquery3
//= require jquery_ujs

function fadeFlashes() {
  setTimeout(function() { $('.flash').fadeOut(); }, 4000);
}

$(fadeFlashes);
$(document).on('ajax:complete', fadeFlashes);
