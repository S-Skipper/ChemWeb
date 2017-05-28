var num = 10;
var data;
var page;

$(function() {
  // 权限
  rankDeal();

  // 寻找参数
  var name = getQueryVariable('drug_name');
  if (name != false) {
    name = decodeURI(name).replace('百分号', '%');
    $('#keyword').val(name);
  }

  // 搜索按钮
  $('#btnSearch').click(function() {
    Webservice_Drug.GetDrug(id, pw, $('#keyword').val(), setTable);
    return false;
  }).click();

  // 换页
  $('#page').on('click', 'li', paging);

  // 详细框
  initModal();
});

// 初始化模态框
function initModal() {
  $('#result tbody').on('click', 'tr', showModal);
  // 关闭
  $('#detailModal .close, #detailModal').click(hideModal);
  $('#detailModal .modal_container').click(function() {
    return false;
  });
  // 切换页面
  $('#detailModal .modal_header ul').on('click', 'li:not(.active)', changePane);
}

// 切换页面
function changePane() {
  $('#detailModal .modal_header ul li').removeClass('active');
  $(this).addClass('active');
  $('#detailModal .modal_container .modal_main').removeClass('active');
  $('#' + $(this).attr('data-id')).addClass('active');
}

// URL参数
function getQueryVariable(variable) {
  var query = window.location.search.substring(1);
  var vars = query.split('&');
  for (var i = 0; i < vars.length; i++) {
    var pair = vars[i].split('=');
    if (pair[0] == variable) {return pair[1];}
  }
  return (false);
}

// 隐藏并刷新搜索
function hideModal() {
  $('#detailModal').css('visibility', 'hidden');
  $('#btnSearch').click();
  return false;
}

// 渲染基本信息
function setBasePane(result) {
  result = JSON.parse(result);
  var inputs = $('#basePane input, #basePane textarea');
  $(inputs[0]).val(result[0].drug_name);
  $(inputs[1]).val(result[0].drug_another_name);
  $(inputs[2]).val(result[0].drug_Englishname);
  $(inputs[3]).val(result[0].CAS);
  $(inputs[4]).val(result[0].fen_zi_shi);
  $(inputs[5]).val(result[0].fen_zi_liang);
  $(inputs[6]).val(result[0].dangerous);
  if (manager >= 1) {
    $(inputs[8]).val(result[0].counting);
    $(inputs[9]).val(result[0].standard);
    $(inputs[10]).val(result[0].people);
    $(inputs[11]).val(result[0].edit_time);
    $(inputs[12]).val(result[0].details);
  } else {
    $(inputs[7]).val(result[0].details);
  }
};

// 渲染位置信息
function setLocPane(result) {
  var count = 0;
  $('#locPane').html('');
  if (result != '') {
    result = JSON.parse(result);
    for (var re in result) {
      count += parseInt(result[re].counting);
      if (manager == 2) {
        $('#locPane').append('<div><label>修改人: ' + result[re].people +
          ' || 修改时间: ' + result[re].edit_time + '</label></div>');
        var tempTotal = parseFloat(result[re].counting) *
            parseFloat(result[re].each) +
            parseFloat(result[re].remain);
        $('#locPane').append('<div class="half"><button ' +
          'data-total="' + tempTotal +
          '" class="btnDelLoc" data-loc="' + result[re].id +
          '" style="padding: 0.2em">删除</button></div>');
        $('#locPane').append('<div class="half"><button ' +
          'data-total="' + tempTotal +
          '" class="btnChangeLoc" data-loc="' + result[re].id +
          '" style="padding: 0.2em">确认修改</button></div>');
      } else {
        $('#locPane').append('<div class="full"><label>修改人: ' +
          result[re].people + ' || 修改时间: ' +
          result[re].edit_time + '</label></div>');
      }
      $('#locPane').append('<div class="half"><span>药品瓶数</span>' +
        '<input type="text" disabled="disabled" value=' +
        result[re].counting + '></div>');
      $('#locPane').append('<div class="half"><span>规格</span>' +
      '<input type="text" disabled="disabled" value=' +
      result[re].each + '></div>');
      $('#locPane').append('<div class="half"><span>不足一瓶数量</span>' +
        '<input type="text" disabled="disabled" value=' +
        result[re].remain + '></div>');
      $('#locPane').append('<div class="half"><span>单位</span>' +
        '<input type="text" disabled="disabled" value=' +
        result[re].standard + '></div>');
      $('#locPane').append('<div class="full"><span>位置信息</span>' +
        '<input type="text" disabled="disabled" value=' +
        result[re].position + '></div>');
    }
    if (manager == 2) {
      var inputs = $('#locPane input');
      for (var i = 0; i < inputs.length; i++) {
        if (i % 5 == 3) {
          continue;
        }
        $(inputs[i]).removeAttr('disabled');
      }
    }
  }else {
    $('#locPane').append('<div class="full"><label>' +
      '目前暂无位置信息!</label></div>');
  }
  if (manager == 2) {
    $('#locPane').append('<div class="full"><button id="btnAddLoc">' +
      '新增位置</button></div>');
  }
  $('#basePane input').eq(7).val(count);
};

// 显示模态框并填充数据
function showModal() {
  var name = $(this).closest('tr').find('td').html();
  $('#detailModal').css('visibility', 'visible');
  $('li[data-id=basePane]').click();
  $('#detailModal').attr('data-name', name);
  // 基本信息
  Webservice_Drug.GetDrugDetail(id, pw, name, setBasePane);
  if (manager >= 1) {
    Webservice_Drug.GetDrugLoc(id, pw, name, setLocPane);
  }
}

// 换页
function paging() {
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
}

// 响应搜索
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

// 分页处理
function setPage() {
  $('#page').html('');
  if (manager == 2) {
    $('#page').append('<button id="btnNewDrug">新增药品</button>');
  }
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

// 填充数据
function setData() {
  $('#result tbody').html('');
  if (Math.ceil(data.length / num) == 0) {
    if (manager >= 1) {
      $('#result tbody').append('<tr><td colspan="4">无查找结果</td></tr>');
    }else {
      $('#result tbody').append('<tr><td colspan="3">无查找结果</td></tr>');
    }
    return;
  }
  for (var i = (page - 1) * num; i < page * num && i < data.length; i++) {
    var temp = $('<tr>');
    temp.append('<td>' + data[i].drug_name + '</td>');
    temp.append('<td>' + data[i].fen_zi_shi + '</td>');
    temp.append('<td>' + data[i].drug_another_name + '</td>');
    if (manager >= 1) {
      temp.append('<td>' + data[i].counting + data[i].standard + '</td>');
    }
    $('#result tbody').append(temp);
  }
}

// 权限处理
function rankDeal() {
  // 权限分类
  switch (manager) {
    case '管理权限':
      manager = 2;
      break;
    case '一般权限':
      manager = 1;
      break;
    default:
      manager = 0;
      break;
  }
  // 界面设计
  if (manager >= 1) {
    // 表格信息
    $('#result thead tr').append('<th>药品余量</th>');
    // 基本信息
    var pos =  $('#basePane textarea').parent();
    pos.before('<div class="half"><span>药品瓶数</span>' +
      '<input type="text" disabled="disabled"></div>');
    pos.before('<div class="half"><span>药品数量</span>' +
      '<input type="text" disabled="disabled"></div>');
    pos.before('<div class="half"><span>单位</span>' +
      '<input type="text" disabled="disabled"></div>');
    pos.before('<div class="half"><span>修改人</span>' +
      '<input type="text" disabled="disabled"></div>');
    pos.before('<div class="half"><span>修改时间</span>' +
      '<input type="text" disabled="disabled"></div>');
    if (manager == 2) {
      $('#basePane').append('<div><button id="btnChangeBase">' +
        '确认修改</button></div>');
      $('#basePane').append('<div><button id="btnDelBase">' +
        '删除药品</button></div>');
      $('#btnChangeBase').click(changeBase);
      $('#btnDelBase').click(delBase);
      var inputs = $('#basePane input, #basePane textarea');
      $(inputs[0]).removeAttr('disabled');
      $(inputs[1]).removeAttr('disabled');
      $(inputs[2]).removeAttr('disabled');
      $(inputs[3]).removeAttr('disabled');
      $(inputs[4]).removeAttr('disabled');
      $(inputs[5]).removeAttr('disabled');
      $(inputs[6]).removeAttr('disabled');
      $(inputs[9]).removeAttr('disabled');
      $(inputs[12]).removeAttr('disabled');
      $('#page').on('click', '#btnNewDrug', newDrug);
    }
    // 位置信息
    if (manager == 2) {
      $('#locPane').on('click', '#btnAddLoc', addLoc);
      $('#locPane').on('click', '.btnChangeLoc', changeLoc);
      $('#locPane').on('click', '.btnDelLoc', delLoc);
    }
  } else {
    // 位置信息
    $('#locPane, li[data-id=locPane]').remove();
  }
}

// 修改位置信息
function changeLoc() {
  var tempCo = $(this).parent().next().find('input');
  var tempEa = tempCo.parent().next().find('input');
  var tempRe = tempEa.parent().next().find('input');
  var tempPo = tempRe.parent().next().next().find('input');
  tempCo = parseFloat(tempCo.val());
  tempEa = parseFloat(tempEa.val());
  tempRe = parseFloat(tempRe.val());
  var temp = [{
      'id': $(this).attr('data-loc'),
      'drug_name': $('#detailModal').attr('data-name'),
      'position': tempPo.val(),
      'counting': tempCo,
      'remain': tempRe,
      'each': tempEa,
      'standard': 'cmd',
      'people': id,
      'edit_time': getNowTime()
    }];
  Webservice_Drug.Drug_Insert_UpdateLoc(id, pw, JSON.stringify(temp),
    tempCo * tempEa + tempRe - parseFloat($(this).attr('data-total')),
    function(result) {
      alert(result);
      Webservice_Drug.GetDrugLoc(id, pw, $('#detailModal').attr('data-name'),
        setLocPane);
    });
}

// 删除位置信息
function delLoc() {
  Webservice_Drug.Drug_DeleteLoc(id, pw, $(this).attr('data-loc'),
    0 - parseFloat($(this).attr('data-total')), function(result) {
      alert(result);
      Webservice_Drug.GetDrugLoc(id, pw, $('#detailModal').attr('data-name'),
        setLocPane);
    });
}

// 新增位置信息
function addLoc() {
  var temp = [{
      'id': '-1',
      'drug_name': $('#detailModal').attr('data-name'),
      'position': '',
      'counting': '0',
      'remain': '0',
      'each': '0',
      'standard': '',
      'people': id,
      'edit_time': getNowTime()
    }];
  Webservice_Drug.Drug_Insert_UpdateLoc(id, pw, JSON.stringify(temp), 0,
    function(result) {
      alert(result);
      Webservice_Drug.GetDrugLoc(id, pw, $('#detailModal').attr('data-name'),
        setLocPane);
    });
}

// 修改药品
function changeBase() {
  var inputs = $('#basePane input, #basePane textarea');
  var temp = [{
      'drug_name': $(inputs[0]).val(),
      'drug_another_name': $(inputs[1]).val(),
      'drug_Englishname': $(inputs[2]).val(),
      'CAS': $(inputs[3]).val(),
      'fen_zi_shi': $(inputs[4]).val(),
      'fen_zi_liang': $(inputs[5]).val(),
      'dangerous': $(inputs[6]).val(),
      'counting': $(inputs[8]).val(),
      'standard': $(inputs[9]).val(),
      'details': $(inputs[12]).val(),
      'people': id,
      'edit_time': getNowTime()
    }];
  Webservice_Drug.Drug_Insert_Update(id, pw, JSON.stringify(temp),
  $('#detailModal').attr('data-name'), function (result) {
    alert(result);
    if (result == '成功') {
      $('#detailModal .close').click();
    }
  });
}

// 删除药品
function delBase() {
  var name = $('#detailModal').attr('data-name');
  Webservice_Drug.Drug_Delete(id, pw, name, function(result) {
    alert(result);
    $('#detailModal .close').click();
  });
}

// 新增药品
function newDrug() {
  var temp = [{
      'drug_name': '请填写药品名',
      'drug_another_name': '',
      'drug_Englishname': '',
      'CAS': '',
      'fen_zi_shi': '',
      'fen_zi_liang': '',
      'dangerous': '',
      'details': '',
      'counting': '0',
      'standard': '',
      'people': id,
      'edit_time': getNowTime()
    }];
  Webservice_Drug.Drug_Insert_Update(id, pw, JSON.stringify(temp),
    '请填写药品名', function(result) {
        alert(result);
        var name = '请填写药品名';
        $('#detailModal').css('visibility', 'visible');
        $('li[data-id=basePane]').click();
        $('#detailModal').attr('data-name', name);
        Webservice_Drug.GetDrugDetail(id, pw, name, setBasePane);
        if (manager >= 1) {
          Webservice_Drug.GetDrugLoc(id, pw, name, setLocPane);
        }
        $('#baseSel').click();
      });
  return false;
}

// 当前时间
function getNowTime() {
  var t = new Date();
  var s = '';
  s += t.getFullYear() + '/' + (t.getMonth() + 1) + '/' + t.getDate();
  s += ' ' + t.getHours() + ':' + t.getMinutes() + ':' + t.getSeconds();
  return s;
}
