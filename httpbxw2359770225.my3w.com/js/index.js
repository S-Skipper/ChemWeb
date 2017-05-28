var bannerIndex = 0;
var noticeIndex = 5;
var newsIndex = 5;
var todayIndex = 5;
var bannerTimer;
$(document).ready(function(e) {
  setTimeout(scrollTo, 0, 0, 0);
  bannerChange(bannerIndex);
  listInit($('#notice'));
  listInit($('#news'));
  listInit($('#today'));
  $('#search_box nav button').click(function() {
    hello(this.id);
  });

  $('#newsHeader').click(function() {
      location.href = '/News/News_moreNews.aspx';
    });

  $('#noticeHeader').click(function() {
      location.href = '/News/News_moreNotice.aspx';
    });
});

function bannerChange(index) {
  bannerIndex = index;
  var bannerLi = $('#banner ul li');
  for (var i = 0; i < 4; i++) {
    if (i == index) {
      bannerLi.eq(i).css('opacity', 0.2);
      bannerLi.eq(i).css('width', '50%');
    } else {
      bannerLi.eq(i).css('opacity', 0.8);
      bannerLi.eq(i).css('width', '0');
    }
  }

  index *= -100;
  $('#banner_contain').css('left', index + '%');
  clearTimeout(bannerTimer);
  bannerTimer = setTimeout(function() {
    bannerIndex = (bannerIndex + 1) % 4;
    bannerChange(bannerIndex);
  }, 5000);
}

function highlightLogin() {
  $('#login_window').css('opacity', 0.95);
  $('#username').focus();
  setTimeout(function() {
    $('#login_window').css('opacity', 0.1);
    $('#login_window').hover(
    function() {
      $('#login_window').css('opacity', 0.95);
    },

    function() {
      $('#login_window').css('opacity', 0.1);
    });
  }, 10000);
}

function listInit(article) {
  var list = article.find('a');
  for (var i = 0; i < 11; i++) {
    if (i > 1 && i <= 5) {
      list.eq(i).css('opacity', 0.3 + 0.2 * (i - 2));
    } else if (i > 5 && i <= 8) {
      list.eq(i).css('opacity', 1.5 - 0.2 * (i - 2));
    } else {
      list.eq(i).css('visibility', 'hidden');
    }

    list.eq(i).css('top', (-60 + 30 * i) + 'px');
    list.eq(i).css('left', (-6 + 3 * i) + '%');
  }

  article.find('span.upScroll').click(function() {
    listScroll(true, article.attr('id'));
  });

  article.find('span.downScroll').click(function() {
    listScroll(false, article.attr('id'));
  });
}

function listScroll(direction, id) {
  var tempScrollIndex;
  if (id == 'notice') {
    tempScrollIndex = noticeIndex;
  } else if (id == 'news') {
    tempScrollIndex = newsIndex;
  } else if (id == 'today') {
    tempScrollIndex = todayIndex;
  }

  list = $('#' + id).find('a');
  if (direction == true && tempScrollIndex < 9) {
    tempScrollIndex = tempScrollIndex + 1;
    for (var i = 0; i < 11; i++) {
      if (i > tempScrollIndex - 4 && i <= tempScrollIndex) {
        list.eq(i).css('visibility', 'visible');
        list.eq(i).css('opacity', 0.3 + 0.2 * (i - tempScrollIndex + 3));
      } else if (i > tempScrollIndex && i <= tempScrollIndex + 3) {
        list.eq(i).css('visibility', 'visible');
        list.eq(i).css('opacity', 1.5 - 0.2 * (i - tempScrollIndex + 3));
      } else {
        list.eq(i).css('visibility', 'hidden');
      }

      list.eq(i).css('top', (-30 * (tempScrollIndex - 3) + 30 * i) + 'px');
      list.eq(i).css('left', (-3 * (tempScrollIndex - 3) + 3 * i) + '%');
    }
  } else if (direction == false && tempScrollIndex > 1) {
    tempScrollIndex = tempScrollIndex - 1;
    for (var i = 0; i < 11; i++) {
      if (i > tempScrollIndex - 4 && i <= tempScrollIndex) {
        list.eq(i).css('visibility', 'visible');
        list.eq(i).css('opacity', 0.3 + 0.2 * (i - tempScrollIndex + 3));
      } else if (i > tempScrollIndex && i <= tempScrollIndex + 3) {
        list.eq(i).css('visibility', 'visible');
        list.eq(i).css('opacity', 1.5 - 0.2 * (i - tempScrollIndex + 3));
      } else {
        list.eq(i).css('visibility', 'hidden');
      }

      list.eq(i).css('top', (-30 * (tempScrollIndex - 3) + 30 * i) + 'px');
      list.eq(i).css('left', (-3 * (tempScrollIndex - 3) + 3 * i) + '%');
    }
  }

  if (id == 'notice') {
    noticeIndex = tempScrollIndex;
  } else if (id == 'news') {
    newsIndex = tempScrollIndex;
  } else if (id == 'today') {
    todayIndex = tempScrollIndex;
  }
}

function hello(id) {
  $('#search_box nav button').removeClass('search_now');
  $('#' + id).addClass('search_now');
  $('#search_box article').removeClass('search_now');
  $('#search_' + id).addClass('search_now');
}
