$(function() {
    WebService_News.GetNews('2', setNews);
    function setNews(result) {
      result = JSON.parse(result);
      var count = 0;
      var row = '';
      for (re in result) {
        if (count % 3 == 0) {
          $('#main').append(row);
          row = $('<div>').addClass('row');
        }

        var col = $('<div>').addClass('col').attr('data-id', result[re]['ArticleID']);
        col.append('<h3>' + result[re]['Title'] + '</h3>');
        col.append('<p>' + result[re]['infor'] + '</p>');
        col.append('<span>创建人: ' + result[re]['Member_Name'] + '</span>');
        col.append('<time>发布时间: ' + result[re]['DateTime'] + '</time>');
        row.append(col);
        count++;
      }

      $('#main').append(row);
      $('#main').on('click', 'div.col', function() {
          location.href = 'News_NewsDetails.aspx?ID=' + $(this).attr('data-id');
        });
    }
  });
