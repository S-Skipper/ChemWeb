var num = 10;
var data;
var page;

$(function() {
  var d = new Date();
  var year = d.getFullYear().toString();
  var monthLast = d.getMonth().toString();
  var monthNow = (d.getMonth() + 1).toString();
  monthLast = (monthLast.length == 1) ? '0' + monthLast : monthLast;
  monthNow = (monthNow.length == 1) ? '0' + monthNow : monthNow;
  var day = d.getDate().toString();
  day = (day.length == 1) ? '0' + day : day;
  $('#startTime').val(year + '-' + monthLast + '-' + day);
  $('#endTime').val(year + '-' + monthNow + '-' + day);

  $('#btnSearch').click(function() {
    var a = $('#keyword').val().trim();
    var b = $('#startTime').val().replace(/\//g, '-');
    var c = $('#endTime').val().replace(/\//g, '-');
    Webservice_Drug.GetDrugInOutByName(id, pw, a, b, c, setTable);
    return false;
  });

  $('#page').on('click', 'li', function() {
    if ($(this).html() == '...') {
      return;
    }
    if ($(this).html() == '&gt;&gt;') {
      page++;
    } else if ($(this).html() == '&lt;&lt;') {
      page--;
    } else {
      page = parseInt($(this).html());
    }
    setPage();
    setData();
  });

  $('#btnSearch').click();
});

function setTable(result) {
  data = [];
  if (result != '') {
    result = JSON.parse(result);
    var count = 0;
    for (var re in result) {
      data[count++] = result[re];
    }
  }
  page = 0;
  setPage();
  setData();
}

function setPage() {
  $('#page').html('');
  var l = Math.ceil(data.length / num);
  if (l <= 0) {
    return;
  }
  if (page > l) {
    page = l;
  } else if (page <= 0) {
    page = 1;
  }
  if (l == 1) {
    $('#page').append('<li class="active">1</li>');
  } else {
    var s = (page - 2 < 1) ? 1 : page - 2;
    var e = (s + 4 > l) ? l : s + 4;
    s = (e - 4 < 1) ? 1 : e - 4;
    if (s != page) {
      $('#page').append('<li><<</li>');
    }
    if (s > 1) {
      $('#page').append('<li>...</li>');
    }
    for (var i = s ; i <= e; i++) {
      if (page == i) {
        $('#page').append('<li class="active">' + i + '</li>');
      }else {
        $('#page').append('<li>' + i + '</li>');
      }
    }
    if (e < l) {
      $('#page').append('<li>...</li>');
    }
    if (e != page) {
      $('#page').append('<li>>></li>');
    }
  }
}

// 数据填充
function setData() {
  $('#result tbody').html('');
  if (Math.ceil(data.length / num) == 0) {
    $('#result tbody').append('<tr><td colspan="5">无查找结果</td></tr>');
    return;
  }
  for (var i = (page - 1) * num; i < page * num && i < data.length; i++) {
    var temp = $('<tr>');
    temp.append('<td>' + data[i].drug_name + '</td>');
    if (data[i].type == '存') {
      temp.append('<td>+ ' + data[i].change + data[i].standard + '</td>');
    }else {
      temp.append('<td>- ' + data[i].change + data[i].standard + '</td>');
    }
    temp.append('<td>' + data[i].position + '</td>');
    temp.append('<td>' + data[i].people + '</td>');
    temp.append('<td>' + data[i].time + '</td>');
    $('#result tbody').append(temp);
  }
}
