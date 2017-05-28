var zoom = true;
$(document).ready(function(e) {
  setTimeout(scrollTo, 0, 0, 0);
  $('#aside_zoom').click(function() {
    zoomToggle();
  });

  if ($(window).width() < 768) {
    zoomToggle();
  }

  setAppend($('#aside_tree>ul>li'));
  $('#aside_tree li a span').click(function() {
    spreadOrShrink($(this));
    return false;
  });

  $('#main_container').css('height', $(window).height() - 190 + 'px');
  window.onresize = function() {
    $('#main_container').css('height', $(window).height() - 190 + 'px');
  };
});

function spreadOrShrink(link) {
  var nextLevel = link.parent().parent().find('>ul');
  if (link.hasClass('spread')) {
    link.removeClass('spread');
    link.addClass('shrink');
    nextLevel.css('height', '0');
  } else if (link.hasClass('shrink')) {
    link.removeClass('shrink');
    link.addClass('spread');
    nextLevel.css('height', 'auto');
  }
}

function zoomToggle() {
  zoom = !zoom;
  if (zoom) {
    $('#aside_zoom').attr('src', '../img/zoom_out.png');
    $('#aside_zoom').css('margin-top', '20px');
    $('#aside_zoom').css('height', '100px');
    $('#aside_zoom').css('width', '100px');
    $('#main_container aside').css('width', '220px');
    $('#aside_tree').css('height', '400px');
  } else {
    $('#aside_zoom').attr('src', '../img/zoom_in.png');
    $('#aside_zoom').css('margin-top', '300px');
    $('#aside_zoom').css('height', '40px');
    $('#aside_zoom').css('width', '40px');
    $('#main_container aside').css('width', '50px');
    $('#aside_tree').css('height', '0');
  }
}

function setAppend(menu) {
  for (var i = 0; i < menu.length; i++) {
    var temp = menu.eq(i).find('>ul>li');
    if (temp.length != 0) {
      menu.eq(i).find('>a').append('<span class=\'spread\'></span>');
      setAppend(temp);
    }
  }
}
