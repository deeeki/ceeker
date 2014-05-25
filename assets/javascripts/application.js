//= require jquery/dist/jquery.js
//= require bootstrap-sass/js/dropdown.js
//= require_tree .

$(function(){
  var content = $('.conversations');
  var nextUrl = $('a[rel=next]').attr('href')
  var loading = false;

  $(window).on('scroll', function(){
    if (content.offset().top + content.height() > $(document).scrollTop() + window.innerHeight) {
      return;
    }
    if (loading || !nextUrl) { return; }

    loading = true
    $.get(nextUrl, function(data){
      var partial = $('<div/>').append(data);
      partial.find('.conversations').children().appendTo(content);
      nextUrl = partial.find('a[rel=next]').attr('href');
      if (!nextUrl) { $(window).off('scroll', '**'); }
      loading = false;
    });
  });
});
