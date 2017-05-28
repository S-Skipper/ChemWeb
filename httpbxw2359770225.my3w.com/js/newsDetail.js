var Request;
$(function () {
    Request = GetRequest();
    GetNews();
  });

function GetNews() {
  var num = Request['ID'];
  WebService_News.GetNewsDetail(num, setContent);
}

function setContent(result) {
  result = JSON.parse(result)[0];
  console.log(result);
  $('div.content h1.title').html(result['Title']);
  $('div.content div.contentInfo span').html('发布人: ' + result['Member_Name']);
  $('div.content div.contentInfo time').html('发布时间: ' + result['DateTime']);
  $('div.contentFooter time').html('发布时间: ' + result['DateTime']);
  $('div.content').append(result['Content_1']);
}

function GetRequest() {
  var url = location.search; //获取url中"?"符后的字串
  var theRequest = new Object();
  if (url.indexOf('?') != -1) {
    var str = url.substr(1);
    strs = str.split('&');
    for (var i = 0; i < strs.length; i++) {
      theRequest[strs[i].split('=')[0]] = unescape(strs[i].split('=')[1]);
    }
  }

  return theRequest;
}
